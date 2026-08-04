/datum/ai_planning_subtree/archer_base/proc/validate_archer_equipment(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	if(world.time < controller.blackboard[BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY])
		var/obj/item/gun/ballistic/revolver/grenadelauncher/cached_bow = controller.blackboard[BB_ARCHER_NPC_BOW]
		var/obj/item/quiver/cached_quiver = controller.blackboard[BB_ARCHER_NPC_QUIVER]
		if(QDELETED(cached_bow) || QDELETED(cached_quiver) || cached_bow.loc != living_pawn || cached_quiver.loc != living_pawn)
			_clear_equipment_cache(controller)
			return FALSE
		return TRUE

	_clear_equipment_cache(controller)

	// Locate the bow and quiver directly from hands/worn slots. The AI inventory manager only
	// classifies gear it saw equipped after it was created, so items spawned onto the mob (bow,
	// quiver) are often never registered - trust the mob's own inventory instead.
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow = _find_archer_bow(living_pawn)
	if(!bow)
		AI_THINK(living_pawn, "BOW-VALIDATE: no bow in hands or worn")
		return FALSE

	var/obj/item/quiver/quiver = _find_archer_quiver(living_pawn)
	if(!quiver)
		AI_THINK(living_pawn, "BOW-VALIDATE: no quiver worn")
		return FALSE

	controller.set_blackboard_key(BB_ARCHER_NPC_BOW, bow)
	controller.set_blackboard_key(BB_ARCHER_NPC_QUIVER, quiver)
	controller.set_blackboard_key(BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY, world.time + ARCHER_NPC_EQUIPMENT_CACHE_TIME)
	return TRUE

/datum/ai_planning_subtree/archer_base/proc/_clear_equipment_cache(datum/ai_controller/controller)
	controller.clear_blackboard_key(BB_ARCHER_NPC_BOW)
	controller.clear_blackboard_key(BB_ARCHER_NPC_QUIVER)
	controller.clear_blackboard_key(BB_ARCHER_NPC_EQUIPMENT_CACHE_EXPIRY)
