/datum/ai_planning_subtree/find_weapon
	var/vision_range = 9

/proc/ai_npc_has_weapon(mob/living/carbon/human/pawn)
	if(!istype(pawn))
		return FALSE
	for(var/obj/item/held in pawn.held_items)
		if(istype(held, /obj/item/rogueweapon/shield))
			continue
		if(istype(held, /obj/item/rogueweapon) || istype(held, /obj/item/gun))
			return TRUE
	if(_find_archer_bow(pawn)) // a bow in hand or worn - this is an archer, leave the loot
		return TRUE
	return FALSE

/proc/ai_npc_fights_unarmed(mob/living/carbon/human/pawn)
	if(!istype(pawn))
		return FALSE
	if(HAS_TRAIT(pawn, TRAIT_WEAPONLESS))
		return TRUE
	var/datum/status_effect/buff/arcyne_momentum/momentum = pawn.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	return momentum?.chant == "unarmed"

/datum/ai_planning_subtree/find_weapon/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_MOB_EQUIP_TARGET]
	if(!QDELETED(target))
		// Busy with something
		return

	if(ai_npc_has_weapon(controller.pawn) || ai_npc_fights_unarmed(controller.pawn))
		return

	controller.queue_behavior(/datum/ai_behavior/find_and_set/better_weapon, BB_MOB_EQUIP_TARGET, null, vision_range)
