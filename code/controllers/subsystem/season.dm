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
GLOBAL_LIST_EMPTY(seasonal_grass_turfs)
GLOBAL_LIST_EMPTY(seasonal_flora_objs)

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

/datum/controller/subsystem/season/Initialize(start_timeofday)
	current_season = get_current_season()
	current_season_phase = get_current_season_phase()
	queue_full_conversion()
	return ..()

/datum/controller/subsystem/season/fire(resumed = FALSE)
	if(!resumed)
		currentrun_turfs = turfs_to_convert.Copy()
		turfs_to_convert = list()
		currentrun_flora = flora_to_convert.Copy()
		flora_to_convert = list()

	var/list/turf_run = currentrun_turfs
	while(turf_run.len)
		var/turf/open/floor/rogue/T = turf_run[turf_run.len]
		turf_run.len--
		if(T && !QDELETED(T))
			apply_season_to_turf(T)
		if(MC_TICK_CHECK)
			return

	var/list/flora_run = currentrun_flora
	var/target_flora_season = get_target_flora_season()
	while(flora_run.len)
		var/obj/structure/flora/L = flora_run[flora_run.len]
		flora_run.len--
		if(L && !QDELETED(L))
			L.apply_flora_season(target_flora_season)
		if(MC_TICK_CHECK)
			return

/// Re-checks the calendar and, if the season (or phase, for winter's snow buildup) has changed, queues every tracked seasonal atom for conversion.
/datum/controller/subsystem/season/proc/check_season_change()
	var/new_season = get_current_season()
	var/new_phase = get_current_season_phase()
	if(new_season == current_season && new_phase == current_season_phase)
		return
	current_season = new_season
	current_season_phase = new_phase
	queue_full_conversion()

/datum/controller/subsystem/season/proc/queue_full_conversion()
	turfs_to_convert = GLOB.seasonal_grass_turfs.Copy()
	flora_to_convert = GLOB.seasonal_flora_objs.Copy()

/datum/controller/subsystem/season/proc/get_target_turf_type()
	switch(current_season)
		if("Spring")
			return /turf/open/floor/rogue/grass
		if("Summer")
			return /turf/open/floor/rogue/grassyel
		if("Autumn")
			return /turf/open/floor/rogue/grassred
		if("Winter")
			switch(current_season_phase)
				if("Early")
					return /turf/open/floor/rogue/grasscold
				if("Mid", "Late")
					return /turf/open/floor/rogue/snow
	return /turf/open/floor/rogue/grass

/datum/controller/subsystem/season/proc/apply_season_to_turf(turf/open/floor/rogue/T)
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
		if("Spring")
			return "spring"
		if("Summer")
			return "summer"
		if("Autumn")
			return "fall"
		if("Winter")
			return "winter"
	return "spring"
