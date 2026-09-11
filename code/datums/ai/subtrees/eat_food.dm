/datum/ai_planning_subtree/eat_food
	var/datum/ai_behavior/eat_food/behavior = /datum/ai_behavior/eat_food

/datum/ai_planning_subtree/eat_food/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/obj/item/target = controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]
	if(QDELETED(target))
		controller.clear_blackboard_key(BB_BASIC_MOB_FOOD_TARGET)
		return
	var/mob/living/pawn = controller.pawn
	if(pawn.doing)
		return
	if(!istype(target, /obj/item/reagent_containers/food/snacks/rogue))
		behavior = /datum/ai_behavior/eat_food_from_ground		//if it's a snack then we can just use item interaction otherwise eat from ground

	controller.queue_behavior(behavior, BB_BASIC_MOB_FOOD_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING //we are going to eat...no distractions.


/datum/ai_planning_subtree/eat_food/farm_animals
	behavior = /datum/ai_behavior/eat_food_from_ground
