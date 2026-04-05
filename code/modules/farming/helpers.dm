/proc/get_soil_on_turf(turf/target_turf)
	for(var/atom/movable/movable as anything in target_turf.contents)
		// Soil does not have subtypes
		if(movable.type == /obj/structure/soil)
			return movable
	return null

/proc/get_farming_effort_divisor(mob/user)
	return (1 / get_farming_effort_multiplier(user))

/proc/get_farming_effort_multiplier(mob/user, factor = 2)
	return (10 + (user.get_skill_level(/datum/skill/labor/farming) * factor)) * 0.1

/proc/get_farming_do_time(mob/user, time)
	return time / get_farming_effort_multiplier(user, 3)

/proc/get_herb_effort_multiplier(mob/user, factor = 2)
	var/farming_lvl = user.get_skill_level(/datum/skill/labor/farming)
	var/medicine_lvl = user.get_skill_level(/datum/skill/misc/medicine)
	var/effective_lvl = max(farming_lvl, medicine_lvl)

	return (10 + (effective_lvl * factor)) * 0.1

/proc/get_herb_do_time(mob/user, time)
	var/multiplier = get_herb_effort_multiplier(user, 3)
	return time / multiplier

/proc/apply_farming_fatigue(mob/user, fatigue_amount)
	var/multiplier = get_farming_effort_multiplier(user)
	user.stamina_add(fatigue_amount / multiplier)

/proc/adjust_experience(mob/user, skill_type, exp_amount)
	user.adjust_experience(skill_type, exp_amount)

/proc/add_sleep_experience(mob/user, skill_type, exp_amount)
	user.mind.add_sleep_experience(skill_type, exp_amount)
