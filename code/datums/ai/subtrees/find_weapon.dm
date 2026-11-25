/datum/ai_planning_subtree/find_weapon
	var/vision_range = 9

/proc/ai_is_melee_weapon(obj/item/I)
	return istype(I, /obj/item/rogueweapon) && !(I.flags_ai_inventory & AI_ITEM_THROWING)

/proc/ai_npc_has_weapon(mob/living/carbon/human/pawn)
	if(!istype(pawn))
		return FALSE
	if(HAS_TRAIT(pawn, TRAIT_CHUNKYFINGERS)) // A deadite does not concern itself with weapons.
		return TRUE
	for(var/obj/item/held in pawn.held_items)
		if(istype(held, /obj/item/rogueweapon/shield))
			continue
		if(ai_is_melee_weapon(held) || istype(held, /obj/item/gun))
			return TRUE
	if(_find_archer_bow(pawn)) // a bow in hand or worn - this is an archer, leave the loot
		return TRUE
	if(ai_find_stowed_weapon(pawn))
		return TRUE
	return FALSE

/proc/ai_stowed_melee_in(obj/item/carried)
	var/datum/component/holster/holster = carried?.GetComponent(/datum/component/holster)
	var/obj/item/weapon = holster ? holster.sheathed : carried
	if(ai_is_melee_weapon(weapon) && !istype(weapon, /obj/item/rogueweapon/shield) && !istype(weapon, /obj/item/rogueweapon/scabbard))
		return weapon
	return null

/proc/ai_find_stowed_weapon(mob/living/carbon/human/pawn)
	var/static/list/stow_slots = list(SLOT_BELT_R, SLOT_BELT_L, SLOT_BACK_R, SLOT_BACK_L, SLOT_WRISTS, SLOT_SHOES, SLOT_BELT)
	for(var/slot in stow_slots)
		var/obj/item/weapon = ai_stowed_melee_in(pawn.get_item_by_slot(slot))
		if(weapon)
			return weapon
	for(var/slot in stow_slots)
		var/obj/item/worn = pawn.get_item_by_slot(slot)
		if(!worn?.GetComponent(/datum/component/storage))
			continue
		for(var/obj/item/stored in worn.held_contents())
			var/obj/item/weapon = ai_stowed_melee_in(stored)
			if(weapon)
				return weapon
	return null

/proc/ai_draw_stowed_weapon(mob/living/carbon/human/pawn, obj/item/weapon, active = TRUE)
	if(active ? pawn.get_active_held_item() : pawn.get_inactive_held_item())
		return FALSE
	var/obj/item/container = isitem(weapon.loc) ? weapon.loc : null
	if(container && !container.GetComponent(/datum/component/holster))
		container.release_held(weapon, pawn)
	return _draw_into_hand(pawn, weapon, active)

/proc/ai_sheathe_weapon(mob/living/carbon/human/pawn, obj/item/weapon)
	for(var/slot in list(SLOT_BELT_R, SLOT_BELT_L, SLOT_BACK_R, SLOT_BACK_L))
		var/obj/item/worn = pawn.get_item_by_slot(slot)
		var/datum/component/holster/holster = worn?.GetComponent(/datum/component/holster)
		if(!holster || holster.sheathed || !holster.weapon_check(pawn, weapon))
			continue
		pawn.temporarilyRemoveItemFromInventory(weapon, force = TRUE)
		weapon.forceMove(worn)
		holster.sheathed = weapon
		holster.update_icon()
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
