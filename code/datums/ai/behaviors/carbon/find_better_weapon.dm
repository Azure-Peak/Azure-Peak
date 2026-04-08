/datum/ai_behavior/find_and_set/better_weapon

/datum/ai_behavior/find_and_set/better_weapon/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/carbon/living_pawn = controller.pawn
	var/obj/item/held_item = living_pawn.get_active_held_item()
	if(istype(held_item, /obj/item/rogueweapon/shield))
		living_pawn.swap_hand()
		held_item = living_pawn.get_active_held_item()

	var/weapon_type = controller.blackboard[BB_WEAPON_TYPE]
	var/list/weapons = list()
	for(var/obj/item/local_candidate in oview(search_range, controller.pawn))
		if(!istype(local_candidate, weapon_type))
			continue
		if(held_item)
			if(held_item.force >= local_candidate.force)
				continue
		weapons += local_candidate
	if(weapons.len)
		return pick(weapons)

/datum/ai_behavior/find_and_set/better_weapon/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	var/mob/living/carbon/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	if(!istype(checking, controller.blackboard[BB_WEAPON_TYPE]))
		return FALSE
	var/obj/item/held_item = living_pawn.get_active_held_item()
	if(istype(held_item, /obj/item/rogueweapon/shield))
		held_item = living_pawn.get_inactive_held_item()
	if(held_item)
		if(istype(held_item, /obj/item/rogueweapon/shield))
			return FALSE
		var/obj/item/candidate = checking
		if(held_item.force >= candidate.force)
			return FALSE
	return TRUE
