// Tracks outdoor seasonal atoms and updates them as the in-character calendar month rolls over:
// - Grass: plain /turf/open/floor/rogue/grass cycles grass/grassyel/grassred/snow by season.
//   Mapper-placed flavor grass (grassred/grassyel/grasscold) keeps its own identity year-round
//   but still swaps to snow in Winter (see winter_type/summer_type below).
// - Flora: tree canopy leaf objects/overlays swap sprites via apply_flora_season().
// - Water: turfs with freeze_type gain/lose an ice layer in Mid/Late Winter via PlaceOnTop()/
//   ScrapeAway(), which lets the original water subtype ride along on baseturfs.
// - Paths: dirt/dirt-road/cobble/cobblerock (anything with winter_type set) ChangeTurf() into a
//   Winter sibling turf rather than an icon swap, since dirt carries per-instance state a bare
//   icon swap can't safely coexist with. See apply_season_to_path().
// - Decals: map-placed decorative decals with a winter_icon_state get a direct icon_state swap.
//   See sync_seasonal_decals().

/// Should SSseason treat this turf as open to the sky? Checked live at conversion time (not
/// cached) so a roof built/removed mid-round is honored. Both checks matter: is_weatherproof()
/// alone misreads an indoor garden under open sky above as exposed, since it tests the TOP
/// turf's area when one exists; the area check alone misses an outdoor area roofed over.
/turf/proc/is_seasonally_exposed()
	var/area/turf_area = loc
	if(!turf_area?.outdoors)
		return FALSE
	return !is_weatherproof()

/// Shuffles `things` in SEASON_SHUFFLE_CHUNK-tile blocks instead of tile-by-tile, so a
/// conversion scatters across the map without scattering each tile's ChangeTurf() neighbors
/// across the whole drain - SSicon_smooth only dedups within a short window, so per-tile
/// shuffling would turn every converted tile's smoothing into several separate resmooths
/// instead of one shared one. Contiguous blocks also read as patchy snowfall, not static.
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
	// Lobby included so the once-per-round full-map sweep drains before anyone's in the world.
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
		// Most rollovers land inside a season whose phases all render identically (only Winter's
		// Mid freeze is a mid-season visual change) - nothing to convert or announce.
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
/// map under everyone's feet at once. Lists are pre-shuffled (mapload order would otherwise
/// convert one contiguous map slab per day) but each day's share stays block-contiguous, so
/// season_chunk_shuffle()'s smoothing dedup still holds.
/datum/controller/subsystem/season/proc/begin_gradual_conversion()
	if(transition_days_left > 0)
		// Already running - don't clobber pending_*. apply_season_to_turf() etc. read
		// current_season live, so the existing schedule still lands atoms on the latest target.
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

/// ChangeTurf()s a winter_type turf between summer/Winter forms, like apply_season_to_turf()
/// does for grass - but direction is read off the turf's own winter_type/summer_type, since
/// these are a summer/winter pair specific to one turf rather than a single global target.
///
/// dirt (and dirt/road) carries per-instance state (water, mud, blood, an active dig hole) that
/// ChangeTurf() would otherwise drop - carried over explicitly below. A tile with a `holie`
/// (/obj/structure/closet/dirthole) is skipped entirely, not requeued: holie is set for the
/// hole's whole lifetime including a permanent finished grave (see hole.dm), so requeueing once
/// turned every grave tile into a permanent busy-loop, re-adding itself every fire() tick. A
/// skipped tile just picks up the swap at the next real season change.
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

/// Map-placed decals with a winter_icon_state get swapped directly - no smoothing, and few
/// enough of them that converting all at once costs nothing worth budgeting for. Called
/// straight from queue_full_conversion()/begin_gradual_conversion(), not the queue/drain path.
/datum/controller/subsystem/season/proc/sync_seasonal_decals()
	var/snowed = should_show_snow_icons()
	for(var/obj/effect/decal/D as anything in GLOB.seasonal_decal_objs)
		var/turf/T = get_turf(D)
		if(!T?.is_seasonally_exposed())
			continue
		var/target_state = snowed ? D.winter_icon_state : D.summer_icon_state
		if(D.icon_state != target_state)
			D.icon_state = target_state
