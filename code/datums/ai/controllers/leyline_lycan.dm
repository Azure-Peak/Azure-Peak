/datum/ai_controller/leyline_lycan

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/leyline_teleport,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_planning_subtree/leyline_teleport
	var/min_distance = 5

/datum/ai_planning_subtree/leyline_teleport/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan/lycan = controller.pawn
	if(!istype(lycan) || world.time < lycan.teleport_cooldown)
		return
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target) || get_dist(lycan, target) < min_distance)
		return
	lycan.leyline_teleport(target)
