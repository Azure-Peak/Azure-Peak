// targeting via a random draw from a provided list of mobs
// ignores LOS, walls, etc. if someone's in the encounter At All, they're getting targeted
// note: chasing distant targets will still require the mob to have a large aggro_maintain range
/datum/ai_behavior/aggro_from_list
	action_cooldown = 5 SECONDS
	behavior_flags = NONE

/datum/ai_behavior/aggro_from_list/perform(seconds_per_tick, datum/ai_controller/controller, list_key, target_key)
	. = ..()

	var/mob/living/existing_target = controller.blackboard[target_key]
	if(ismob(existing_target) && !QDELETED(existing_target) && existing_target.stat == CONSCIOUS) // we don't want to override existing targets
		finish_action(controller, FALSE, list_key, target_key)
		return

	var/list/valid_mobs = controller.blackboard[list_key]
	if(!LAZYLEN(valid_mobs))
		finish_action(controller, FALSE, list_key, target_key)
		return

	var/mob/living/carbon/human/chosen = pick(valid_mobs)

	controller.set_blackboard_key(target_key, chosen)

	var/datum/component/ai_aggro_system/aggro = controller.pawn.GetComponent(/datum/component/ai_aggro_system)
	if(aggro)
		aggro.add_threat_to_mob(chosen, 20)
	else
		controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, chosen)

	finish_action(controller, TRUE, list_key, target_key)

