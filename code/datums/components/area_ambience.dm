/datum/component/area_ambience
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/area/last_area
	/// whether mob is outside or not
	var/is_outside = FALSE

/datum/component/area_ambience/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/L = parent
	if(!L.mind)
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ENTER_AREA, PROC_REF(on_enter_area))
	last_area = get_area(parent)
	update_outside(last_area)

/datum/component/area_ambience/proc/on_enter_area(datum/source, area/new_area)
	SIGNAL_HANDLER

	var/mob/living/L = parent
	if(!L || !L.mind)
		last_area = new_area
		update_outside(new_area)
		return
	if(!L.ckey || L.stat == DEAD)
		last_area = new_area
		update_outside(new_area)
		return

	var/area/old_area = last_area
	last_area = new_area
	update_outside(new_area)

	if(L.client && !L.cmode)
		INVOKE_ASYNC(SSdroning, TYPE_PROC_REF(/datum/controller/subsystem/droning, area_entered), new_area, L.client)
		INVOKE_ASYNC(SSdroning, TYPE_PROC_REF(/datum/controller/subsystem/droning, play_loop), new_area, L.client)
		var/found = FALSE
		for(var/datum/weather/rain/R in SSweather.curweathers)
			found = TRUE
		if(found)
			INVOKE_ASYNC(SSdroning, TYPE_PROC_REF(/datum/controller/subsystem/droning, play_rain), new_area, L.client)

	if(!SSParticleWeather.runningWeather || !SSParticleWeather.runningWeather.running)
		return

	if(!old_area)
		return

	var/was_indoors = istype(old_area, /area/rogue/indoors)
	var/was_outdoors = istype(old_area, /area/rogue/outdoors)
	var/is_indoors = istype(new_area, /area/rogue/indoors)
	var/is_outdoors = istype(new_area, /area/rogue/outdoors)

	if((was_indoors && is_outdoors) || (was_outdoors && is_indoors))
		SSParticleWeather.runningWeather.stop_weather_sound_effect(L)

/datum/component/area_ambience/proc/update_outside(area/A)
	if(A && istype(A, /area/rogue/outdoors))
		is_outside = TRUE
		return is_outside

	is_outside = FALSE
	return is_outside
