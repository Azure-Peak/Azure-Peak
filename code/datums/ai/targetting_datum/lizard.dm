/datum/targetting_datum/basic/lizard

/datum/targetting_datum/basic/lizard/can_attack(mob/living/living_mob, atom/the_target)
	var/mob/living/simple_animal/hostile/lizard/lizard = living_mob
	if(!istype(lizard) || !is_type_in_typecache(the_target, lizard.edibles))
		return FALSE
	return ..()
