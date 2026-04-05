/datum/ai_planning_subtree/archer_base/proc/validate_archer_equipment(datum/ai_controller/controller)
	if(world.time < controller.blackboard[BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY])
		var/obj/item/gun/ballistic/revolver/grenadelauncher/cached_bow = controller.blackboard[BB_ARCHER_NPC_BOW]
		var/obj/item/quiver/cached_quiver = controller.blackboard[BB_ARCHER_NPC_QUIVER]
		if(QDELETED(cached_bow) || QDELETED(cached_quiver))
			_clear_equipment_cache(controller)
			return FALSE
		return TRUE

	_clear_equipment_cache(controller)

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return FALSE

	var/mob/living/living_pawn = controller.pawn
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow = inv.get_item(AI_ITEM_GUN)
	// Note: bow variable typed as /grenadelauncher (base) - matches bows, crossbows, and slings
	if(!bow)
		if(istype(living_pawn.get_active_held_item(), /obj/item/gun/ballistic/revolver/grenadelauncher))
			bow = living_pawn.get_active_held_item()
		else if(istype(living_pawn.get_inactive_held_item(), /obj/item/gun/ballistic/revolver/grenadelauncher))
			bow = living_pawn.get_inactive_held_item()
	if(!bow)
		return FALSE

	var/obj/item/quiver/quiver = inv.get_item(AI_ITEM_QUIVER)
	if(!quiver?.arrows.len)
		return FALSE

	controller.set_blackboard_key(BB_ARCHER_NPC_BOW, bow)
	controller.set_blackboard_key(BB_ARCHER_NPC_QUIVER, quiver)
	controller.set_blackboard_key(BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY, world.time + ARCHER_NPC_EQUIPMENT_CACHE_TIME)
	return TRUE

/datum/ai_planning_subtree/archer_base/proc/_clear_equipment_cache(datum/ai_controller/controller)
	controller.clear_blackboard_key(BB_ARCHER_NPC_BOW)
	controller.clear_blackboard_key(BB_ARCHER_NPC_QUIVER)
	controller.clear_blackboard_key(BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY)
