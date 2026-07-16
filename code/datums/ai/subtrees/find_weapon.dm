/datum/ai_planning_subtree/find_weapon
	var/vision_range = 9

/datum/ai_planning_subtree/find_weapon/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_MOB_EQUIP_TARGET]
	if(!QDELETED(target))
		// Busy with something
		return

	var/mob/living/living_pawn = controller.pawn
	for(var/obj/item/held in living_pawn.held_items)
		if(istype(held, /obj/item/rogueweapon/shield))
			continue
		if(istype(held, /obj/item/rogueweapon) || istype(held, /obj/item/gun))
			return // Already armed (melee or bow) — never drop, upgrade, or swap off a weapon we're holding

	controller.queue_behavior(/datum/ai_behavior/find_and_set/better_weapon, BB_MOB_EQUIP_TARGET, null, vision_range)
