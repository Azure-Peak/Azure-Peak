// Tracks outdoor seasonal atoms and updates them as the in-character calendar
// month rolls over:
// - Base outdoor grass turfs swap between grass/grassyel/grassred/grasscold/
//   snow (Early Winter uses grasscold as a transition, Mid/Late Winter both
//   go to full snow). Deliberately-mapped grass color variants (grassred,
//   grassyel, etc placed by mappers for flavor) are left alone - only the
//   plain /turf/open/floor/rogue/grass tiles are tracked and converted.
// - Tree canopy leaf objects (/obj/structure/flora/newleaf and its /corner
//   variant, plus the leaf overlays drawn on newtree canopy caps and
//   newbranch) swap between the spring/summer/fall/winter leaf sprites via
//   their overridden apply_flora_season() proc.
// - Freezable water turfs (those with a freeze_type set - still murk, ponds and clean
//   shallows, but never rivers, ocean, sewers or interiors) gain a layer of ice in Mid/Late
//   Winter and lose it again on the thaw. Freezing uses PlaceOnTop(), so the original water
//   subtype rides along on baseturfs and the thaw is a plain ScrapeAway() back to it. Both
//   the liquid and the frozen turfs live in the same tracking list.

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

GLOBAL_LIST_EMPTY(seasonal_grass_turfs)
GLOBAL_LIST_EMPTY(seasonal_flora_objs)
GLOBAL_LIST_EMPTY(seasonal_water_turfs)

SUBSYSTEM_DEF(season)
	name = "Season"
	flags = SS_BACKGROUND
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME
	var/current_season = null
	var/current_season_phase = null
	var/list/turfs_to_convert = list()
	var/list/currentrun_turfs = list()
	var/list/flora_to_convert = list()
	var/list/currentrun_flora = list()
	var/list/water_to_convert = list()
	var/list/currentrun_water = list()
	/// Atoms still owed to an in-progress gradual transition, in shuffled order. Each dawn
	/// moves a share of these into the *_to_convert queues above.
	var/list/pending_turfs = list()
	var/list/pending_flora = list()
	var/list/pending_water = list()
	/// Dawns left in the current gradual transition. 0 means none is running.
	var/transition_days_left = 0
	/// Drain instrumentation: when the current batch started converting, and how many atoms
	/// it has got through. Logged when the queues run dry.
	var/drain_started = 0
	var/drain_count = 0

/datum/controller/subsystem/season/Initialize(start_timeofday)
	current_season = get_current_season()
	current_season_phase = get_current_season_phase()
	queue_full_conversion()
	return ..()

/datum/controller/subsystem/season/stat_entry()
	var/pending = length(pending_turfs) + length(pending_flora) + length(pending_water)
	var/queued = length(turfs_to_convert) + length(currentrun_turfs)
	queued += length(flora_to_convert) + length(currentrun_flora)
	queued += length(water_to_convert) + length(currentrun_water)
	return ..("[current_season] [current_season_phase] | Q:[queued] P:[pending] D:[transition_days_left]")

/datum/controller/subsystem/season/fire(resumed = FALSE)
	if(!drain_started && (length(turfs_to_convert) || length(flora_to_convert) || length(water_to_convert)))
		drain_started = world.time
		drain_count = 0
	if(!resumed)
		currentrun_turfs = turfs_to_convert.Copy()
		turfs_to_convert = list()
		currentrun_flora = flora_to_convert.Copy()
		flora_to_convert = list()
		currentrun_water = water_to_convert.Copy()
		water_to_convert = list()

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

	if(drain_started)
		var/elapsed = (world.time - drain_started) / 10
		log_world("SSseason: converted [drain_count] atoms in [elapsed]s ([current_season] [current_season_phase], [transition_days_left] transition day(s) left)")
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
		if(instant)
			// Nothing rolled over, but an admin asking for an instant result shouldn't be
			// left staring at a map that's still half-way through an earlier transition.
			finish_gradual_conversion()
			return
		// No rollover, but a transition started on an earlier dawn may still owe us atoms.
		advance_gradual_conversion()
		return
	current_season = new_season
	current_season_phase = new_phase
	if(instant)
		abort_gradual_conversion()
		queue_full_conversion()
		return
	begin_gradual_conversion()

/// Converts everything at once. Used at roundstart (nobody is in the world yet to watch it
/// happen) and for admin-forced date changes.
/datum/controller/subsystem/season/proc/queue_full_conversion()
	turfs_to_convert = shuffle(GLOB.seasonal_grass_turfs)
	flora_to_convert = shuffle(GLOB.seasonal_flora_objs)
	water_to_convert = shuffle(GLOB.seasonal_water_turfs)

/// Spreads a season change over SEASON_TRANSITION_DAYS dawns instead of repainting the whole
/// map under everyone's feet at once. The lists are shuffled because they're built in mapload
/// order - taking a slice off an unshuffled list would convert one contiguous slab of the map
/// per day, which reads as a rendering artifact rather than as a thaw.
/datum/controller/subsystem/season/proc/begin_gradual_conversion()
	pending_turfs = shuffle(GLOB.seasonal_grass_turfs)
	pending_flora = shuffle(GLOB.seasonal_flora_objs)
	pending_water = shuffle(GLOB.seasonal_water_turfs)
	transition_days_left = SEASON_TRANSITION_DAYS
	advance_gradual_conversion()

/datum/controller/subsystem/season/proc/abort_gradual_conversion()
	pending_turfs = list()
	pending_flora = list()
	pending_water = list()
	transition_days_left = 0

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

/datum/controller/subsystem/season/proc/get_target_turf_type()
	switch(current_season)
		if(SEASON_SPRING)
			return /turf/open/floor/rogue/grass
		if(SEASON_SUMMER)
			return /turf/open/floor/rogue/grassyel
		if(SEASON_AUTUMN)
			return /turf/open/floor/rogue/grassred
		if(SEASON_WINTER)
			switch(current_season_phase)
				if(SEASON_PHASE_EARLY)
					return /turf/open/floor/rogue/grasscold
				if(SEASON_PHASE_MID, SEASON_PHASE_LATE)
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

/// Water freezes a phase behind the ground: Early Winter is grasscold, and only once the snow
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
