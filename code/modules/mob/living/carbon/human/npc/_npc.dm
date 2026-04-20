/mob/living/carbon/human/proc/IsDeadOrIncap(checkDead = TRUE)
	if(!(mobility_flags & MOBILITY_FLAGS_INTERACTION))
		return TRUE
	if(health <= 0 && checkDead)
		return TRUE
	if(incapacitated(ignore_restraints = TRUE))
		return TRUE
	return FALSE

/mob/living/proc/npc_detect_sneak(mob/living/target, extra_prob = 0)
	if(target.alpha > 0 || !target.rogue_sneaking)
		return TRUE
	var/probby = 4 * STAPER
	probby += extra_prob
	var/sneak_bonus = 0
	if(target.mind)
		if(world.time < target.mob_timers[MT_INVISIBILITY])
			sneak_bonus = (max(target.get_skill_level(/datum/skill/magic/arcane), target.get_skill_level(/datum/skill/magic/holy)) * 10)
			probby -= 20
		else
			sneak_bonus = (target.get_skill_level(/datum/skill/misc/sneaking) * 5)
		probby -= sneak_bonus
	if(!target.check_armor_skill())
		probby += 85
		if(sneak_bonus)
			probby += sneak_bonus
	if(target.badluck(5))
		probby += (10 - target.STALUC) * 5
	if(target.goodluck(5))
		probby -= (10 - target.STALUC) * 5
	if(prob(probby))
		target.mob_timers[MT_FOUNDSNEAK] = world.time
		to_chat(target, span_danger("[src] sees me! I'm found!"))
		target.update_sneak_invis(TRUE)
		return TRUE
	else
		return FALSE
