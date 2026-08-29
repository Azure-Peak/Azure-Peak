// Tracks outdoor seasonal atoms and updates them as the in-character calendar
// month rolls over:
// - Base outdoor grass turfs swap between grass/grassyel/grassred/grasscold/
//   snowpatchy/snow. Deliberately-mapped grass color variants (grassred,
//   grassyel, etc placed by mappers for flavor) are left alone - only the
//   plain /turf/open/floor/rogue/grass tiles are tracked and converted.
// - Tree canopy leaf objects (/obj/structure/flora/newleaf and its /corner
//   variant) swap their icon_state between the spring/summer/fall/winter
//   sprite sets.
GLOBAL_LIST_EMPTY(seasonal_grass_turfs)
GLOBAL_LIST_EMPTY(seasonal_leaf_objs)

SUBSYSTEM_DEF(season)
	name = "Season"
	flags = SS_BACKGROUND
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME
	var/current_season = null
	var/current_season_phase = null
	var/list/turfs_to_convert = list()
	var/list/currentrun_turfs = list()
	var/list/leaves_to_convert = list()
	var/list/currentrun_leaves = list()

/datum/controller/subsystem/season/Initialize(start_timeofday)
	current_season = get_current_season()
	current_season_phase = get_current_season_phase()
	queue_full_conversion()
	return ..()

/datum/controller/subsystem/season/fire(resumed = FALSE)
	if(!resumed)
		currentrun_turfs = turfs_to_convert.Copy()
		turfs_to_convert = list()
		currentrun_leaves = leaves_to_convert.Copy()
		leaves_to_convert = list()

	var/list/turf_run = currentrun_turfs
	while(turf_run.len)
		var/turf/open/floor/rogue/T = turf_run[turf_run.len]
		turf_run.len--
		if(T && !QDELETED(T))
			apply_season_to_turf(T)
		if(MC_TICK_CHECK)
			return

	var/list/leaf_run = currentrun_leaves
	while(leaf_run.len)
		var/obj/structure/flora/newleaf/L = leaf_run[leaf_run.len]
		leaf_run.len--
		if(L && !QDELETED(L))
			apply_season_to_leaf(L)
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
	leaves_to_convert = GLOB.seasonal_leaf_objs.Copy()

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
				if("Mid")
					return /turf/open/floor/rogue/snowpatchy
				if("Late")
					return /turf/open/floor/rogue/snow
	return /turf/open/floor/rogue/grass

/datum/controller/subsystem/season/proc/apply_season_to_turf(turf/open/floor/rogue/T)
	var/target_type = get_target_turf_type()
	if(T.type == target_type)
		return
	T.ChangeTurf(target_type)

/// Returns the lowercase leaf-sprite season name ("spring"/"summer"/"fall"/"winter") matching current_season.
/datum/controller/subsystem/season/proc/get_target_leaf_season()
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

/datum/controller/subsystem/season/proc/apply_season_to_leaf(obj/structure/flora/newleaf/L)
	var/target_season = get_target_leaf_season()
	if(L.leaf_season == target_season)
		return
	L.leaf_season = target_season
	L.refresh_leaf_icon()
