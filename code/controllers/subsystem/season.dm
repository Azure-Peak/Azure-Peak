// Tracks outdoor seasonal atoms and updates them as the in-character calendar
// month rolls over:
// - Base outdoor grass turfs swap between grass/grassyel/grassred/snow, one
//   type per season - all three months of Winter target snow alike, so the
//   only thing that makes Early Winter look any different is the gradual
//   ramp still being partway through converting grass to snow. Deliberately-
//   mapped grass color variants (grassred, grassyel, grasscold, etc placed by
//   mappers for flavor) are left alone - only the plain
//   /turf/open/floor/rogue/grass tiles are tracked and converted.
// - Tree canopy leaf objects (/obj/structure/flora/newleaf and its /corner
//   variant, plus the leaf overlays drawn on newtree canopy caps and
//   newbranch) swap between the spring/summer/fall/winter leaf sprites via
//   their overridden apply_flora_season() proc.
// - Freezable water turfs (those with a freeze_type set - still murk, ponds and clean
//   shallows, but never rivers, ocean, sewers or interiors) gain a layer of ice in Mid/Late
//   Winter and lose it again on the thaw. Freezing uses PlaceOnTop(), so the original water
//   subtype rides along on baseturfs and the thaw is a plain ScrapeAway() back to it. Both
//   the liquid and the frozen turfs live in the same tracking list.
// - Paths (dirt, dirt/road, cobble, cobblerock - anything with seasonal_icon_swap set) get a
//   "snow"-prefixed icon_state and neighborlay in Winter instead of a different type - there's no
//   behavioral difference, just a sprite, so there's no reason to pay ChangeTurf()'s cost the way
//   grass and water do. See apply_season_to_icon_turf().
//
// A rollover that actually changes how a category renders doesn't convert everything at once -
// it ramps in over the calendar month it happens in, 25% more of that category's tracked atoms
// each in-game week, landing on full coverage by the month's 4th week. That target percentage is
// a pure function of the current IC date (which week of which month), not anything SSseason
// remembers about "how far along" a transition is - so there's nothing to lose or get stuck by
// not persisting across rounds. See sync_seasonal_coverage().

/// Should SSseason treat this turf as open to the sky? Checked at conversion time rather
/// than at registration, so a roof raised (or torn off) mid-round is honoured on the next
/// season change - and so the cost is one predicate per tracked turf per season change,
/// inside an already tick-budgeted background subsystem, not anything per-tick.
///
/// Both halves are needed. is_weatherproof() alone is not enough: it walks up the z-stack
/// and, whenever any turf exists above, ends up testing the TOP turf's area instead of this
/// one's - so an indoor garden with open sky on the z-level above still reads as exposed.
/// The area check catches that; is_weatherproof() then catches the reverse case, an outdoor
/// area that's been roofed over by a tent or built ceiling.
/turf/proc/is_seasonally_exposed()
	var/area/turf_area = loc
	if(!turf_area?.outdoors)
		return FALSE
	return !is_weatherproof()

/// Shuffles `things` in SEASON_SHUFFLE_CHUNK-tile square blocks rather than tile by tile.
///
/// The aim is to scatter a conversion across the map without also scattering it in *time*.
/// Every ChangeTurf() re-queues its 8 neighbours with SSicon_smooth, which dedups only in the
/// short window before an atom actually gets smoothed - and SSicon_smooth is a ticker
/// subsystem running every tick, so that window is tiny. Shuffling tile by tile spreads a
/// tile's neighbours right across the drain, so it gets re-smoothed once per neighbour rather
/// than once in total, and the smoothing bill (up to 9 atoms queued per converted turf) is
/// what actually shows up as tick lag. Keeping each block contiguous restores the dedup for
/// everything except block edges, and the resulting clumps read more like patchy snowfall
/// than the television-static look of per-tile randomness.
/proc/season_chunk_shuffle(list/things)
	var/list/chunk_lookup = list() // "z_cx_cy" -> that block's list
	var/list/chunk_order = list() // the same lists, as a flat list we can shuffle
	for(var/atom/A as anything in things)
		var/turf/T = get_turf(A)
		if(!T)
			continue
		var/key = "[T.z]_[round(T.x / SEASON_SHUFFLE_CHUNK)]_[round(T.y / SEASON_SHUFFLE_CHUNK)]"
		var/list/bucket = chunk_lookup[key]
		if(!bucket)
			bucket = list()
			chunk_lookup[key] = bucket
			chunk_order += list(bucket)
		bucket += A
	. = list()
	for(var/list/bucket as anything in shuffle(chunk_order))
		. += bucket

GLOBAL_LIST_EMPTY(seasonal_grass_turfs)
GLOBAL_LIST_EMPTY(seasonal_flora_objs)
GLOBAL_LIST_EMPTY(seasonal_water_turfs)
GLOBAL_LIST_EMPTY(seasonal_icon_turfs)

SUBSYSTEM_DEF(season)
	name = "Season"
	flags = SS_BACKGROUND
	wait = 2 SECONDS
	// Lobby included so the roundstart sweep - the whole map, every single round - drains
	// while players are still on the lobby screen instead of costing them tick time in the
	// world. SSicon_smooth, which does the expensive half of the work, already runs from
	// RUNLEVEL_SETUP onwards.
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME
	var/current_season = null
	var/current_season_phase = null
	var/list/turfs_to_convert = list()
	var/list/currentrun_turfs = list()
	var/list/flora_to_convert = list()
	var/list/currentrun_flora = list()
	var/list/water_to_convert = list()
	var/list/currentrun_water = list()
	var/list/icon_turfs_to_convert = list()
	var/list/currentrun_icon = list()
	/// Drain instrumentation: when the current batch started converting, and how many atoms
	/// it has got through. Logged when the queues run dry.
	var/drain_started = 0
	var/drain_count = 0
	/// Set by Initialize() while the roundstart baseline sweep (see below) is still draining.
	/// Once every queue empties out, fire() flips current_season/phase to the real current month
	/// and runs the normal ramped sync on top - see the bottom of fire().
	var/pending_true_season_sync = FALSE

/// A freshly-loaded map is entirely mapper defaults (plain grass, liquid water, bare branches) -
/// there's no partial conversion left over from last round to ramp forward from, and defaults
/// don't resemble any particular season (plain grass happens to equal Spring's target, but that's
/// not "whatever season it actually was"). So roundstart is a genuine two-step special case, not
/// just this month's target applied early:
///  1. Pretend it's still last month, and fully sweep to *that* target - a plausible "the world
///     kept turning while nobody was watching" baseline instead of raw defaults.
///  2. Once that's finished draining (checked at the bottom of fire()), flip to the real current
///     month and run the same percentage-based sync a live round would - so if today happens to
///     land on, say, the second week of a ramp, roundstart shows the same 50% a natural week of
///     dawns getting there would have shown, not an instant jump to 100%.
/datum/controller/subsystem/season/Initialize(start_timeofday)
	// Nothing rendered before this to compare against, so the baseline has to come from the
	// calendar itself rather than "whatever the subsystem last saw" - unlike everywhere else that
	// picks a "before" state (see sync_seasonal_coverage()'s doc comment for why that distinction
	// matters).
	var/baseline_month = get_current_month() - 1
	if(baseline_month < 1)
		baseline_month += CALENDAR_MONTHS_PER_YEAR
	current_season = get_season_from_month(baseline_month)
	current_season_phase = get_season_phase(baseline_month)
	sync_seasonal_coverage(force_full = TRUE)
	pending_true_season_sync = TRUE
	return ..()

/datum/controller/subsystem/season/stat_entry()
	var/queued = length(turfs_to_convert) + length(currentrun_turfs)
	queued += length(flora_to_convert) + length(currentrun_flora)
	queued += length(water_to_convert) + length(currentrun_water)
	queued += length(icon_turfs_to_convert) + length(currentrun_icon)
	return ..("[current_season] [current_season_phase] | Q:[queued]")

/datum/controller/subsystem/season/fire(resumed = FALSE)
	if(!drain_started && (length(turfs_to_convert) || length(flora_to_convert) || length(water_to_convert) || length(icon_turfs_to_convert)))
		drain_started = world.time
		drain_count = 0
	if(!resumed)
		currentrun_turfs = turfs_to_convert.Copy()
		turfs_to_convert = list()
		currentrun_flora = flora_to_convert.Copy()
		flora_to_convert = list()
		currentrun_water = water_to_convert.Copy()
		water_to_convert = list()
		currentrun_icon = icon_turfs_to_convert.Copy()
		icon_turfs_to_convert = list()

	var/list/turf_run = currentrun_turfs
	while(turf_run.len)
		var/turf/open/floor/rogue/T = turf_run[turf_run.len]
		turf_run.len--
		if(T && !QDELETED(T))
			apply_season_to_turf(T)
			drain_count++
		if(MC_TICK_CHECK)
			return

	var/list/flora_run = currentrun_flora
	var/target_flora_season = get_target_flora_season()
	while(flora_run.len)
		var/obj/structure/flora/L = flora_run[flora_run.len]
		flora_run.len--
		if(L && !QDELETED(L))
			var/turf/flora_turf = get_turf(L)
			if(flora_turf?.is_seasonally_exposed())
				L.apply_flora_season(target_flora_season)
			drain_count++
		if(MC_TICK_CHECK)
			return

	var/list/water_run = currentrun_water
	while(water_run.len)
		var/turf/W = water_run[water_run.len]
		water_run.len--
		if(W && !QDELETED(W))
			apply_season_to_water(W)
			drain_count++
		if(MC_TICK_CHECK)
			return

	var/list/icon_run = currentrun_icon
	while(icon_run.len)
		var/turf/open/floor/rogue/I = icon_run[icon_run.len]
		icon_run.len--
		if(I && !QDELETED(I))
			apply_season_to_icon_turf(I)
			drain_count++
		if(MC_TICK_CHECK)
			return

	if(drain_started)
		var/elapsed = (world.time - drain_started) / 10
		log_world("SSseason: converted [drain_count] atoms in [elapsed]s ([current_season] [current_season_phase])")
		drain_started = 0
		drain_count = 0

	// The roundstart baseline sweep (see Initialize()) has fully drained - every queue below is
	// empty, whether or not this particular fire() call is the one that emptied the last of them
	// (a map with nothing tracked at all would never set drain_started to begin with). Move on to
	// the real current month and let it ramp normally from here.
	if(pending_true_season_sync && !length(turfs_to_convert) && !length(currentrun_turfs) && \
			!length(flora_to_convert) && !length(currentrun_flora) && \
			!length(water_to_convert) && !length(currentrun_water) && \
			!length(icon_turfs_to_convert) && !length(currentrun_icon))
		pending_true_season_sync = FALSE
		var/baseline_season = current_season
		var/baseline_phase = current_season_phase
		current_season = get_current_season()
		current_season_phase = get_current_season_phase()
		sync_seasonal_coverage(baseline_season, baseline_phase)

/// Called at every dawn, and by the admin Set IC Date verb. Refreshes current_season/phase (but
/// remembers what they were before, to hand to sync_seasonal_coverage() as "what the map actually
/// last looked like"), then re-syncs coverage for wherever the calendar now points - the same
/// ramped percentage a natural dawn would compute, so jumping the date to (say) the first week of
/// Winter shows the same 25% snow scatter a week of real dawns landing there would have produced,
/// not a full instant sweep.
///
/// A plain dawn tick only bothers re-syncing on the first dawn of an in-game week (the other six
/// are a cheap no-op) - `admin_forced` skips that gate, since an admin jumping the date wants to
/// see today's result now, not wait for the next natural week boundary.
/datum/controller/subsystem/season/proc/check_season_change(admin_forced = FALSE)
	var/old_season = current_season
	var/old_phase = current_season_phase
	current_season = get_current_season()
	current_season_phase = get_current_season_phase()
	if(!admin_forced)
		var/list/date_parts = resolve_ic_date_parts(GLOB.dayspassed)
		var/day_of_month = date_parts[1]
		if(MODULUS(day_of_month - 1, CALENDAR_DAYS_IN_WEEK) != 0)
			return // only days 1, 8, 15, 22 - the first dawn of each in-game week - do anything
	sync_seasonal_coverage(old_season, old_phase)

/// The heart of the gradual transition. For each tracked category (ground, flora, water), works
/// out what fraction of it *should* currently be converted to this month's target, and queues a
/// freshly-shuffled sample of that size for the drain to walk through.
///
/// `prev_season`/`prev_phase` are what the map's last sync actually rendered toward - not
/// necessarily last calendar month. They default to the subsystem's own current values, which is
/// right for force_full (they're unused there) but wrong to rely on for a normal sync: callers
/// that mean to compare against a real "before" (check_season_change(), the roundstart baseline
/// flip in fire()) pass explicit ones.
///
/// Whether a category is "still the same as before" is decided against *two* baselines, and it
/// only counts as unchanged if it matches both:
///  - Calendar month - 1. This is what keeps a ramp going on weeks 2-4: current_season/phase only
///    actually change on the day a month rolls over, so `prev_season` (last week's actual render)
///    trivially equals *this* week's for the rest of that month - relying on prev_season alone
///    would ramp week 1 and then silently queue nothing for the remaining three weeks, since
///    nothing "changed" between one week's check and the next.
///  - `prev_season`/`prev_phase`, the actual last-rendered state. This is what catches an admin
///    date-jump straight into a month whose render happens to match its own calendar-preceding
///    month (mid-Autumn, say, landing on "month - 1 = Early Autumn, same grassred, no change"):
///    without this, the map would be stranded on whatever season it actually showed before the
///    jump, since the calendar-month check alone can't tell a real jump from natural adjacency.
///
/// Deliberately doesn't track "how much of this category is already converted" anywhere - it just
/// resamples straight off the full tracked list every time it runs. That's safe because
/// apply_season_to_turf()/apply_season_to_water() are no-ops for anything already at the target
/// type, and apply_flora_season() is cheap to repeat - so a queued atom that happened to be
/// converted already just costs one wasted type check, not a wrong result.
///
/// `force_full` is Initialize()'s only caller: a freshly-loaded map is 100% mapper defaults with
/// no partial conversion to build on, so roundstart can't ramp toward today's target the way a
/// live round can - it has to catch the whole map up in one sweep, however many months of
/// unwitnessed rollovers today's date implies.
/datum/controller/subsystem/season/proc/sync_seasonal_coverage(prev_season = current_season, prev_phase = current_season_phase, force_full = FALSE)
	var/turf_pct = 100
	var/flora_pct = 100
	var/water_pct = 100
	var/icon_pct = 100
	if(!force_full)
		var/calendar_month = get_current_month() - 1
		if(calendar_month < 1)
			calendar_month += CALENDAR_MONTHS_PER_YEAR
		var/calendar_season = get_season_from_month(calendar_month)
		var/calendar_phase = get_season_phase(calendar_month)

		var/turf_same = (get_target_turf_type() == get_target_turf_type(calendar_season)) && (get_target_turf_type() == get_target_turf_type(prev_season))
		var/flora_same = (get_target_flora_season() == get_target_flora_season(calendar_season)) && (get_target_flora_season() == get_target_flora_season(prev_season))
		var/water_same = (waters_should_freeze() == waters_should_freeze(calendar_season, calendar_phase)) && (waters_should_freeze() == waters_should_freeze(prev_season, prev_phase))
		var/icon_same = (should_show_snow_icons() == should_show_snow_icons(calendar_season)) && (should_show_snow_icons() == should_show_snow_icons(prev_season))

		turf_pct = coverage_pct_for(turf_same)
		flora_pct = coverage_pct_for(flora_same)
		water_pct = coverage_pct_for(water_same)
		icon_pct = coverage_pct_for(icon_same)
		announce_coverage_progress(turf_pct, flora_pct, water_pct, icon_pct)

	turfs_to_convert += queue_coverage_share(GLOB.seasonal_grass_turfs, turf_pct)
	flora_to_convert += queue_coverage_share(GLOB.seasonal_flora_objs, flora_pct)
	water_to_convert += queue_coverage_share(GLOB.seasonal_water_turfs, water_pct)
	icon_turfs_to_convert += queue_coverage_share(GLOB.seasonal_icon_turfs, icon_pct)

/// 0 if this category's target hasn't changed since last month (nothing to ramp, and nothing
/// queued). Otherwise 25% per in-game week that's elapsed this month, capped at 100 on week 4 -
/// so by the month's last week, every tracked atom in the category gets queued regardless of what
/// any previous week did.
/datum/controller/subsystem/season/proc/coverage_pct_for(same_as_last_month)
	if(same_as_last_month)
		return 0
	var/list/date_parts = resolve_ic_date_parts(GLOB.dayspassed)
	var/week_of_month = CEILING(date_parts[1] / CALENDAR_DAYS_IN_WEEK, 1)
	return min(week_of_month * 25, 100)

/// A chunk-shuffled sample covering `pct`% of `tracked`, sized off the category's full tracked
/// count (not off however much of it still needs converting) - see sync_seasonal_coverage() for
/// why that's fine.
/datum/controller/subsystem/season/proc/queue_coverage_share(list/tracked, pct)
	if(pct <= 0)
		return list()
	var/target_count = round(length(tracked) * pct / 100)
	if(target_count <= 0)
		return list()
	var/list/shuffled = season_chunk_shuffle(tracked)
	if(target_count < length(shuffled))
		shuffled.Cut(target_count + 1)
	return shuffled

/// Admin-facing readout for a normal (non-instant) coverage sync. Categories that just hit 100%
/// this week are reported as COMPLETE; categories still ramping report their percentage. Categories
/// with nothing to do (pct 0) aren't mentioned at all.
/datum/controller/subsystem/season/proc/announce_coverage_progress(turf_pct, flora_pct, water_pct, icon_pct)
	var/list/complete = list()
	var/list/progress = list()
	if(turf_pct == 100)
		complete += "ground"
	else if(turf_pct > 0)
		progress += "ground [turf_pct]%"
	if(flora_pct == 100)
		complete += "flora"
	else if(flora_pct > 0)
		progress += "flora [flora_pct]%"
	if(water_pct == 100)
		complete += "water"
	else if(water_pct > 0)
		progress += "water [water_pct]%"
	if(icon_pct == 100)
		complete += "paths"
	else if(icon_pct > 0)
		progress += "paths [icon_pct]%"
	if(length(complete))
		message_admins(span_adminnotice("SSseason: [current_season] [current_season_phase] transition COMPLETE for [english_list(complete)]."))
	if(length(progress))
		message_admins(span_adminnotice("SSseason: [current_season] [current_season_phase] transition in progress - [english_list(progress)]."))

/// `season` defaults to the subsystem's current value - pass an explicit one (as
/// sync_seasonal_coverage() does for "last month") to ask what a different point in the calendar
/// would target, without touching current_season. All three months of Winter target snow alike -
/// nothing here cares which phase it is, so there's no phase param to get wrong.
/datum/controller/subsystem/season/proc/get_target_turf_type(season = current_season)
	switch(season)
		if(SEASON_SPRING)
			return /turf/open/floor/rogue/grass
		if(SEASON_SUMMER)
			return /turf/open/floor/rogue/grassyel
		if(SEASON_AUTUMN)
			return /turf/open/floor/rogue/grassred
		if(SEASON_WINTER)
			return /turf/open/floor/rogue/snow
	return /turf/open/floor/rogue/grass

/datum/controller/subsystem/season/proc/apply_season_to_turf(turf/open/floor/rogue/T)
	if(!T.is_seasonally_exposed())
		return
	var/target_type = get_target_turf_type()
	if(T.type == target_type)
		return
	// ChangeTurf() destroys T and constructs a new turf at the same location, which runs
	// Destroy() and drops the old object from GLOB.seasonal_grass_turfs (see the Destroy()
	// overrides in roguefloor.dm) - re-add the result so it stays tracked for future seasons.
	var/turf/new_turf = T.ChangeTurf(target_type)
	if(new_turf)
		GLOB.seasonal_grass_turfs |= new_turf

/// Returns the lowercase leaf-sprite season name ("spring"/"summer"/"fall"/"winter") matching
/// `season` (defaults to current_season - see get_target_turf_type() for why the param exists).
/datum/controller/subsystem/season/proc/get_target_flora_season(season = current_season)
	switch(season)
		if(SEASON_SPRING)
			return FLORA_SEASON_SPRING
		if(SEASON_SUMMER)
			return FLORA_SEASON_SUMMER
		if(SEASON_AUTUMN)
			return FLORA_SEASON_FALL
		if(SEASON_WINTER)
			return FLORA_SEASON_WINTER
	return FLORA_SEASON_SPRING

/// Water freezes a phase behind the ground: Early Winter is snow with no ice yet, and only once
/// Mid Winter arrives does standing water start its own ramp toward frozen. A deliberate delay
/// (water takes longer to freeze than ground takes to gain a dusting of snow), independent of
/// whatever the ground target happens to be. `season`/`phase` default to current - see
/// get_target_turf_type() for why the params exist.
/datum/controller/subsystem/season/proc/waters_should_freeze(season = current_season, phase = current_season_phase)
	if(season != SEASON_WINTER)
		return FALSE
	return (phase == SEASON_PHASE_MID) || (phase == SEASON_PHASE_LATE)

/// Freezes a tracked water turf, or thaws a tracked ice turf, to match the current season.
/// Both freezing and thawing replace the turf, so - as with apply_season_to_turf() - the
/// result has to be re-added to the tracking list to survive into the next season.
/datum/controller/subsystem/season/proc/apply_season_to_water(turf/T)
	if(!T.is_seasonally_exposed())
		return
	var/should_freeze = waters_should_freeze()
	var/turf/new_turf
	if(istype(T, /turf/open/water))
		if(!should_freeze)
			return
		var/turf/open/water/W = T
		new_turf = W.freeze_over()
	else if(istype(T, /turf/open/floor/rogue/frozen_water))
		if(should_freeze)
			return
		var/turf/open/floor/rogue/frozen_water/F = T
		new_turf = F.thaw()
	if(new_turf)
		GLOB.seasonal_water_turfs |= new_turf

/// Should seasonal_icon_swap terrain (dirt, road, cobblestone, cobblerock) currently be showing
/// its snow sprite? Tied to the same months grass turns to snow - paths pick up their scatter of
/// snow on the same day the ground around them does, no separate delay the way water has.
/// `season` defaults to current - see get_target_turf_type() for why the param exists.
/datum/controller/subsystem/season/proc/should_show_snow_icons(season = current_season)
	return season == SEASON_WINTER

/// Swaps a seasonal_icon_swap turf's icon_state (and neighborlay, for the types that have an
/// active one) between its cached summer_icon_state and a "snow"-prefixed winter version, then
/// re-smooths it and its neighbors so any edge overlays catch up. Unlike apply_season_to_turf()/
/// apply_season_to_water(), nothing gets replaced or re-tracked - same turf, same GLOB entry,
/// just a different sprite.
///
/// A currently-muddy dirt tile is left alone - a live puddle takes precedence over the season's
/// default look, and update_water() already restores the right icon_state on its own once it
/// dries out (see roguefloor.dm).
/datum/controller/subsystem/season/proc/apply_season_to_icon_turf(turf/open/floor/rogue/T)
	if(!T.is_seasonally_exposed())
		return
	if(istype(T, /turf/open/floor/rogue/dirt))
		var/turf/open/floor/rogue/dirt/D = T
		if(D.muddy)
			return
	var/snowed = should_show_snow_icons()
	var/target_state = snowed ? "snow[T.summer_icon_state]" : T.summer_icon_state
	if(T.icon_state == target_state)
		return
	T.icon_state = target_state
	if(T.winter_neighborlay)
		T.neighborlay = snowed ? T.winter_neighborlay : initial(T.neighborlay)
	QUEUE_SMOOTH(T)
	QUEUE_SMOOTH_NEIGHBORS(T)
