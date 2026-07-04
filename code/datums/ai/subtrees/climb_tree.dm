/datum/ai_planning_subtree/tree_climb

#define BB_TREE_CLIMB_TARGET_TRUNK "tree_climb_target_trunk"

/datum/ai_planning_subtree/tree_climb/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return
	var/turf/my_turf = get_turf(pawn)
	var/turf/their_turf = get_turf(target)
	if(!their_turf || their_turf.z != my_turf.z + 1)
		return
	if(!istransparentturf(their_turf))
		return
	var/obj/structure/flora/newbranch/the_branch = locate() in their_turf
	if(!the_branch)
		return
	var/obj/structure/flora/newtree/the_tree = locate() in get_step_multiz(the_branch, REVERSE_DIR(the_branch.dir)|DOWN)
	if(!the_tree)
		return
	if(the_tree.z != my_turf.z)
		return
	controller.set_blackboard_key(BB_TREE_CLIMB_TARGET_TRUNK, the_tree)
	controller.queue_behavior(/datum/ai_behavior/human_npc_climb_tree, BB_TREE_CLIMB_TARGET_TRUNK)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/human_npc_climb_tree
	action_cooldown = 1 SECONDS
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/human_npc_climb_tree/setup(datum/ai_controller/controller, trunk_key)
	. = ..()
	var/obj/structure/flora/newtree/trunk = controller.blackboard[trunk_key]
	if(!trunk)
		return FALSE
	set_movement_target(controller, trunk)

/datum/ai_behavior/human_npc_climb_tree/perform(delta_time, datum/ai_controller/controller, trunk_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/obj/structure/flora/newtree/trunk = controller.blackboard[trunk_key]
	if(!trunk || QDELETED(trunk))
		finish_action(controller, FALSE, trunk_key)
		return
	var/turf/above = get_step_multiz(pawn, UP)
	if(!istype(above, /turf/open/transparent/openspace))
		finish_action(controller, FALSE, trunk_key)
		return
	controller.ai_movement.stop_moving_towards(controller)
	walk(pawn, 0)
	trunk.attack_hand(pawn)
	finish_action(controller, TRUE, trunk_key)

/datum/ai_behavior/human_npc_climb_tree/finish_action(datum/ai_controller/controller, succeeded, trunk_key)
	. = ..()
	controller.clear_blackboard_key(trunk_key)

#undef BB_TREE_CLIMB_TARGET_TRUNK
