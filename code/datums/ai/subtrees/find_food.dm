/// similar to finding a target but looks for food types in the general area
/datum/ai_planning_subtree/find_food
	var/vision_range = 9
	var/food_key = BB_BASIC_MOB_FOOD_TARGET

/datum/ai_planning_subtree/proc/get_basic_food_typecache(datum/ai_controller/controller)
	if(QDELETED(controller) || QDELETED(controller.pawn))
		return null

	var/list/food_types = controller.blackboard[BB_BASIC_FOODS]
	if(!length(food_types) && istype(controller.pawn, /mob/living/simple_animal))
		var/mob/living/simple_animal/simple_pawn = controller.pawn
		food_types = simple_pawn.food_type

	if(!length(food_types))
		return null

	var/list/food_typecache = ispath(food_types[1]) ? typecacheof(food_types) : food_types
	if(!length(food_typecache))
		return null

	controller.set_blackboard_key(BB_BASIC_FOODS, food_typecache)
	return food_typecache

/datum/ai_planning_subtree/find_food/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[food_key]
	if(!QDELETED(target))
		// Busy with something
		return

	var/list/food_typecache = get_basic_food_typecache(controller)
	if(!length(food_typecache))
		return

	controller.queue_behavior(/datum/ai_behavior/find_and_set/in_list, food_key, food_typecache, vision_range)


/datum/ai_planning_subtree/find_dead_bodies
	var/vision_range = 9
	var/datum/ai_behavior/find_and_set/dead_bodies/behavior = /datum/ai_behavior/find_and_set/dead_bodies
	var/corpse_key = BB_BASIC_MOB_CORPSE_TARGET

/datum/ai_planning_subtree/find_dead_bodies/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(istype(controller.pawn, /mob/living/simple_animal/hostile/retaliate/rogue))
		var/mob/living/simple_animal/hostile/retaliate/rogue/mob = controller.pawn
		if(mob.food >= mob.food_max && !mob.eat_forever) 
			return // not hungry

	var/atom/target = controller.blackboard[corpse_key]
	if(!QDELETED(target))
		// Busy with something
		return

	controller.queue_behavior(behavior, corpse_key, /mob/living, vision_range)

/datum/ai_planning_subtree/find_dead_bodies/mole
	vision_range = 7

/datum/ai_planning_subtree/find_food/rat
	vision_range = 3

/datum/ai_planning_subtree/find_food/spider
	vision_range = 5

/datum/ai_planning_subtree/find_food/mole
	vision_range = 7

/datum/ai_planning_subtree/find_food/troll
	vision_range = 7


/datum/ai_planning_subtree/find_dead_bodies/troll
	vision_range = 7
	//behavior = /datum/ai_behavior/find_and_set/dead_bodies/bog_troll

/datum/ai_planning_subtree/find_dead_bodies/mimic
	vision_range = 2
	behavior = /datum/ai_behavior/find_and_set/dead_bodies/mimic
