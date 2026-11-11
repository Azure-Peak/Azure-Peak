/datum/ai_planning_subtree/find_weapon
	var/vision_range = 9

/proc/ai_npc_has_weapon(mob/living/carbon/human/pawn)
	if(!istype(pawn))
		return FALSE
	if(HAS_TRAIT(pawn, TRAIT_CHUNKYFINGERS)) // A deadite does not concern itself with weapons.
		return TRUE
	for(var/obj/item/held in pawn.held_items)
		if(istype(held, /obj/item/rogueweapon/shield))
			continue
		if(istype(held, /obj/item/rogueweapon) || istype(held, /obj/item/gun))
			return TRUE
	if(_find_archer_bow(pawn)) // a bow in hand or worn - this is an archer, leave the loot
		return TRUE
	return FALSE

/datum/ai_planning_subtree/find_weapon/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_MOB_EQUIP_TARGET]
	if(!QDELETED(target))
		// Busy with something
		return

	if(ai_npc_has_weapon(controller.pawn))
		return

	controller.queue_behavior(/datum/ai_behavior/find_and_set/better_weapon, BB_MOB_EQUIP_TARGET, null, vision_range)
