// Tracks outdoor seasonal atoms and updates them as the in-character calendar
// month rolls over:
// - Base outdoor grass turfs swap between grass/grassyel/grassred/snow, one
//   type per season - all three months of Winter target snow alike. Deliberately-
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
// - Paths (dirt, dirt/road, cobble, cobblerock - anything with winter_type set) ChangeTurf()
//   between their summer type and a Winter sibling, the same way grass does and for the same
//   reason water's ice layer does: dirt in particular carries real per-instance state (mud
//   saturation, blood, an active dig hole) that a plain icon_state swap can't safely coexist with,
//   since code elsewhere (become_muddy()'s dry-out) resets icon_state to a fixed, season-unaware
//   default. Making the Winter look a real type means that default is correct either way. See
//   apply_season_to_path().
// - Map-placed decorative decals with a winter_icon_state (old cobble edges, etc) get a direct
//   icon_state swap - no per-instance state, no smoothing, and few enough of them on a map that
//   they're synced all at once rather than run through the queue/drain machinery at all. See
//   sync_seasonal_decals().

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
GLOBAL_LIST_EMPTY(seasonal_decal_objs)

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
	/// Atoms still owed to an in-progress gradual transition, in shuffled order. Each dawn
	/// moves a share of these into the *_to_convert queues above.
	var/list/pending_turfs = list()
	var/list/pending_flora = list()
	var/list/pending_water = list()
	var/list/pending_icon = list()
	/// Dawns left in the current gradual transition. 0 means none is running.
	var/transition_days_left = 0
	/// Drain instrumentation: when the current batch started converting, and how many atoms
	/// it has got through. Logged when the queues run dry.
	var/drain_started = 0
	var/drain_count = 0
	/// Totals behind the admin readouts for a gradual transition: how many atoms it started
	/// with, and how many have been through the queues across all its days so far.
	var/transition_total = 0
	var/transition_converted = 0

/datum/controller/subsystem/season/Initialize(start_timeofday)
	current_season = get_current_season()
	current_season_phase = get_current_season_phase()
	queue_full_conversion()
	return ..()

/datum/controller/subsystem/season/stat_entry()
	var/pending = length(pending_turfs) + length(pending_flora) + length(pending_water) + length(pending_icon)
	var/queued = length(turfs_to_convert) + length(currentrun_turfs)
	queued += length(flora_to_convert) + length(currentrun_flora)
	queued += length(water_to_convert) + length(currentrun_water)
	queued += length(icon_turfs_to_convert) + length(currentrun_icon)
	return ..("[current_season] [current_season_phase] | Q:[queued] P:[pending] D:[transition_days_left]")

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
			apply_season_to_path(I)
			drain_count++
		if(MC_TICK_CHECK)
			return

	if(drain_started)
		var/elapsed = (world.time - drain_started) / 10
		log_world("SSseason: converted [drain_count] atoms in [elapsed]s ([current_season] [current_season_phase], [transition_days_left] transition day(s) left)")
		report_drain_complete(elapsed, drain_count)
		drain_started = 0
		drain_count = 0

/// Called at every dawn (and by the admin date verb). Rolls a season/phase change over into a
/// gradual transition, and otherwise nudges an already-running one along by a day.
///
/// `instant` skips the gradual path entirely and converts the map in one sweep - passed by the
/// admin Set IC Date verb, so testing a season doesn't mean sitting through four dawns.
/datum/controller/subsystem/season/proc/check_season_change(instant = FALSE)
	var/new_season = get_current_season()
	var/new_phase = get_current_season_phase()
	if(new_season == current_season && new_phase == current_season_phase)
		// No rollover, but a transition started on an earlier dawn may still owe us atoms.
		tick_existing_transition(instant)
		return
	// Snapshot how the outgoing season renders before we move the clock on, so we can tell
	// whether the incoming one actually looks any different.
	var/old_turf_type = get_target_turf_type()
	var/old_flora_season = get_target_flora_season()
	var/old_frozen = waters_should_freeze()
	var/old_snowed_paths = should_show_snow_icons()
	current_season = new_season
	current_season_phase = new_phase
	var/same_turf = (get_target_turf_type() == old_turf_type)
	var/same_flora = (get_target_flora_season() == old_flora_season)
	var/same_water = (waters_should_freeze() == old_frozen)
	var/same_icon = (should_show_snow_icons() == old_snowed_paths)
	if(same_turf && same_flora && same_water && same_icon)
		// Seven of the twelve monthly rollovers land inside a season whose three phases all
		// render identically - phases only diverge in Winter, where Mid brings the freeze.
		// Nothing on the map would change, so don't chunk-shuffle and then walk every tracked
		// atom across four in-game days to convert none of them, and don't announce a
		// transition to admins that they'd see no evidence of.
		tick_existing_transition(instant)
		return
	if(instant)
		abort_gradual_conversion()
		queue_full_conversion()
		return
	begin_gradual_conversion()

/// Nudges a transition that's already running, without starting a new one.
/datum/controller/subsystem/season/proc/tick_existing_transition(instant = FALSE)
	if(instant)
		// An admin asking for an instant result shouldn't be left staring at a map that's
		// still half-way through an earlier transition.
		finish_gradual_conversion()
		return
	advance_gradual_conversion()

/// Converts everything at once. Used at roundstart - where the lobby runlevel gives it time
/// to finish before anyone is in the world to watch - and for admin-forced date changes.
/datum/controller/subsystem/season/proc/queue_full_conversion()
	turfs_to_convert = season_chunk_shuffle(GLOB.seasonal_grass_turfs)
	flora_to_convert = season_chunk_shuffle(GLOB.seasonal_flora_objs)
	water_to_convert = season_chunk_shuffle(GLOB.seasonal_water_turfs)
	icon_turfs_to_convert = season_chunk_shuffle(GLOB.seasonal_icon_turfs)
	sync_seasonal_decals()

/// Spreads a season change over SEASON_TRANSITION_DAYS dawns instead of repainting the whole
/// map under everyone's feet at once. The lists are scattered because they're built in mapload
/// order - taking a slice off an unscattered list would convert one contiguous slab of the map
/// per day, which reads as a rendering artifact rather than as a thaw. Each day's share is
/// still a contiguous run of whole blocks, so the smoothing dedup described on
/// season_chunk_shuffle() holds within a day as well as across one.
/datum/controller/subsystem/season/proc/begin_gradual_conversion()
	if(transition_days_left > 0)
		// A transition is still running - don't overwrite its pending_* lists out from under it.
		// apply_season_to_turf() etc. read current_season live rather than a captured target, so
		// letting the existing schedule finish will still land every atom on *this* rollover's
		// target once its day comes up. No atoms get stranded, and nothing needs restarting.
		return
	pending_turfs = season_chunk_shuffle(GLOB.seasonal_grass_turfs)
	pending_flora = season_chunk_shuffle(GLOB.seasonal_flora_objs)
	pending_water = season_chunk_shuffle(GLOB.seasonal_water_turfs)
	pending_icon = season_chunk_shuffle(GLOB.seasonal_icon_turfs)
	sync_seasonal_decals()
	transition_days_left = SEASON_TRANSITION_DAYS
	transition_total = length(pending_turfs) + length(pending_flora) + length(pending_water) + length(pending_icon)
	transition_converted = 0
	message_admins(span_adminnotice("SSseason: [current_season] [current_season_phase] transition underway - [transition_total] atoms spread over [SEASON_TRANSITION_DAYS] in-game days."))
	advance_gradual_conversion()

/datum/controller/subsystem/season/proc/abort_gradual_conversion()
	pending_turfs = list()
	pending_flora = list()
	pending_water = list()
	pending_icon = list()
	transition_days_left = 0
	transition_total = 0
	transition_converted = 0

/// Admin-facing readout for a batch that just finished draining. A gradual transition reports
/// one of these per in-game day - a percentage step while days remain, then a completion line
/// on the last. A sweep with no transition behind it (roundstart, or an admin date change)
/// reports itself as one-shot instead, so the two can't be confused for each other.
/datum/controller/subsystem/season/proc/report_drain_complete(elapsed, converted)
	if(!transition_total)
		message_admins(span_adminnotice("SSseason: [current_season] [current_season_phase] applied - [converted] atoms in [elapsed]s."))
		return
	transition_converted += converted
	var/still_owed = length(pending_turfs) + length(pending_flora) + length(pending_water) + length(pending_icon)
	if(transition_days_left <= 0 && !still_owed)
		message_admins(span_adminnotice("SSseason: [current_season] [current_season_phase] transition COMPLETE - [transition_converted]/[transition_total] atoms converted."))
		transition_total = 0
		transition_converted = 0
		return
	var/pct = clamp(round(transition_converted / transition_total * 100), 0, 100)
	message_admins(span_adminnotice("SSseason: [current_season] [current_season_phase] transition [pct]% converted ([transition_converted]/[transition_total]) - [transition_days_left] in-game day(s) left."))

/// Dumps everything a transition still owes into the queues at once, ending it early.
/datum/controller/subsystem/season/proc/finish_gradual_conversion()
	if(transition_days_left <= 0)
		return
	transition_days_left = 1 // makes take_transition_share() hand back the whole remainder
	advance_gradual_conversion()

/// Moves this dawn's share of the pending atoms into the live conversion queues.
/datum/controller/subsystem/season/proc/advance_gradual_conversion()
	if(transition_days_left <= 0)
		return
	turfs_to_convert += take_transition_share(pending_turfs)
	flora_to_convert += take_transition_share(pending_flora)
	water_to_convert += take_transition_share(pending_water)
	icon_turfs_to_convert += take_transition_share(pending_icon)
	transition_days_left--

/// A 1/days_left slice off the front of `pending`, removed from it. Dividing by the days that
/// are actually left (rather than always by SEASON_TRANSITION_DAYS) means rounding can never
/// strand a remainder: the final dawn always takes everything still outstanding.
/datum/controller/subsystem/season/proc/take_transition_share(list/pending)
	if(!length(pending))
		return list()
	var/count = length(pending)
	if(transition_days_left > 1)
		count = CEILING(length(pending) / transition_days_left, 1)
	. = pending.Copy(1, count + 1)
	pending.Cut(1, count + 1)

/// All three months of Winter target snow alike - nothing here cares which phase it is.
/datum/controller/subsystem/season/proc/get_target_turf_type()
	switch(current_season)
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

/// Returns the lowercase leaf-sprite season name ("spring"/"summer"/"fall"/"winter") matching current_season.
/datum/controller/subsystem/season/proc/get_target_flora_season()
	switch(current_season)
		if(SEASON_SPRING)
			return FLORA_SEASON_SPRING
		if(SEASON_SUMMER)
			return FLORA_SEASON_SUMMER
		if(SEASON_AUTUMN)
			return FLORA_SEASON_FALL
		if(SEASON_WINTER)
			return FLORA_SEASON_WINTER
	return FLORA_SEASON_SPRING

/// Water freezes a phase behind the ground: Early Winter has no ice yet, and only once the snow
/// has settled in (Mid/Late) does standing water ice over.
/datum/controller/subsystem/season/proc/waters_should_freeze()
	if(current_season != SEASON_WINTER)
		return FALSE
	return (current_season_phase == SEASON_PHASE_MID) || (current_season_phase == SEASON_PHASE_LATE)

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

/// Should winter_type terrain (dirt, road, cobblestone, cobblerock) currently be in its Winter
/// form? Tied to the same months grass turns to snow - paths pick up their scatter of snow on the
/// same day the ground around them does, no separate delay the way water has.
/datum/controller/subsystem/season/proc/should_show_snow_icons()
	return current_season == SEASON_WINTER

/// ChangeTurf()s a winter_type turf between its summer and Winter forms, the same way
/// apply_season_to_turf() does for grass. Unlike grass, the two forms aren't otherwise-independent
/// types SSseason picks between - they're a summer/winter pair specific to this one turf (see
/// winter_type/summer_type on /turf/open/floor/rogue), so which direction to go is read off the
/// turf itself rather than off a single global target.
///
/// dirt (and dirt/road) carries real per-instance state - water saturation, muddiness, blood, an
/// active dig hole - that ChangeTurf() would otherwise drop on the floor same as it would for any
/// other reason a dirt tile's type changed underfoot. The plain data rides along explicitly below;
/// a tile with a `holie` (an /obj/structure/closet/dirthole) is left alone entirely rather than
/// fought over with whatever system is tracking that hole.
///
/// This is a plain skip, not a requeue: `holie` isn't a short-lived "someone is digging right
/// now" flag - it's set for the object's whole lifetime, up to and including a finished, filled
/// grave sitting there indefinitely (see hole.dm), and only clears when that object is destroyed.
/// Re-queueing on every drain (an earlier version of this did) meant every grave tile re-added
/// itself to the queue every fire() tick forever - a permanent busy-loop, not a brief retry. A
/// skipped tile stays tracked in GLOB.seasonal_icon_turfs and picks up the swap at the next real
/// season change, same as any other atom that doesn't get sampled into a given day's share.
/datum/controller/subsystem/season/proc/apply_season_to_path(turf/open/floor/rogue/T)
	if(!T.is_seasonally_exposed())
		return
	var/target_type = should_show_snow_icons() ? T.winter_type : T.summer_type
	if(!target_type || T.type == target_type)
		return
	var/turf/open/floor/rogue/dirt/old_dirt
	if(istype(T, /turf/open/floor/rogue/dirt))
		old_dirt = T
		if(old_dirt.holie)
			return
	var/turf/new_turf = T.ChangeTurf(target_type)
	if(!new_turf)
		return
	GLOB.seasonal_icon_turfs |= new_turf
	if(old_dirt && istype(new_turf, /turf/open/floor/rogue/dirt))
		var/turf/open/floor/rogue/dirt/new_dirt = new_turf
		new_dirt.water_level = old_dirt.water_level
		new_dirt.muddy = old_dirt.muddy
		new_dirt.bloodiness = old_dirt.bloodiness
		new_dirt.dirt_amt = old_dirt.dirt_amt
		if(old_dirt.muddy)
			// become_muddy() touches more than the plain data above - carry those over too,
			// rather than letting the new type's (dry) compile-time defaults quietly take over
			// while the tile still displays a mud puddle.
			new_dirt.icon_state = "mud[rand(1,3)]"
			new_dirt.name = old_dirt.name
			new_dirt.slowdown = old_dirt.slowdown
			new_dirt.footstep = old_dirt.footstep
			new_dirt.barefootstep = old_dirt.barefootstep
			new_dirt.heavyfootstep = old_dirt.heavyfootstep
			new_dirt.track_prob = old_dirt.track_prob

/// Map-placed decorative decals (old cobble edges, etc - see winter_icon_state on
/// /obj/effect/decal) that have a Winter sprite. Unlike everything else in this file these
/// aren't spread across the gradual transition's days or chunk-shuffled for smoothing dedup -
/// they don't smooth at all, and the population is small enough (a handful of map decorations,
/// not tens of thousands of turfs) that converting all of them in one pass costs nothing
/// worth budgeting for. Called directly from queue_full_conversion() and
/// begin_gradual_conversion() rather than running through the queue/drain machinery at all.
/datum/controller/subsystem/season/proc/sync_seasonal_decals()
	var/snowed = should_show_snow_icons()
	for(var/obj/effect/decal/D as anything in GLOB.seasonal_decal_objs)
		var/turf/T = get_turf(D)
		if(!T?.is_seasonally_exposed())
			continue
		var/target_state = snowed ? D.winter_icon_state : D.summer_icon_state
		if(D.icon_state != target_state)
			D.icon_state = target_state
