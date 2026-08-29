// Tracks the base outdoor grass turfs and swaps them to the season-appropriate
// variant (grass/grassyel/grassred/grasscold/snowpatchy/snow) as the in-character
// calendar month rolls over. Deliberately-mapped grass color variants (grassred,
// grassyel, etc placed by mappers for flavor) are left alone - only the plain
// /turf/open/floor/rogue/grass tiles are tracked and converted.
GLOBAL_LIST_EMPTY(seasonal_grass_turfs)

SUBSYSTEM_DEF(season)
	name = "Season"
	flags = SS_BACKGROUND
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME
	var/current_season = null
	var/current_season_phase = null
	var/list/turfs_to_convert = list()
	var/list/currentrun = list()

/datum/controller/subsystem/season/Initialize(start_timeofday)
	current_season = get_current_season()
	current_season_phase = get_current_season_phase()
	queue_full_conversion()
	return ..()

/datum/controller/subsystem/season/fire(resumed = FALSE)
	if(!resumed)
		currentrun = turfs_to_convert.Copy()
		turfs_to_convert = list()

	var/list/current_run = currentrun
	while(current_run.len)
		var/turf/open/floor/rogue/T = current_run[current_run.len]
		current_run.len--
		if(T && !QDELETED(T))
			apply_season_to_turf(T)
		if(MC_TICK_CHECK)
			return

/// Re-checks the calendar and, if the season (or phase, for winter's snow buildup) has changed, queues every tracked grass turf for conversion.
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
