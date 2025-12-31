/datum/component/armour_filtering
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/required_trait
	var/additive
	var/positive

/datum/component/armour_filtering/Initialize(skill_trait, positive_bonus, bonus_additive = FALSE)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	required_trait = skill_trait
	additive = bonus_additive

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/component/armour_filtering/positive
	positive = TRUE

/datum/component/armour_filtering/negative
	positive = FALSE

/datum/component/armour_filtering/proc/on_equip()
	SIGNAL_HANDLER
	var/obj/item/I = parent
	var/mob/living/carbon/human/user

	if(ishuman(I.loc))
		user = I.loc

	if(!user)
		return
	if(!HAS_TRAIT(user, required_trait))
		return

	if(!isclothing(I))
		return
	var/obj/item/clothing/worn_thing = I
	spawn(0)
		if(!(worn_thing.item_flags & IN_INVENTORY))
			return
	if(worn_thing.item_flags & IN_STORAGE)
		return
	var/list/obj/item/held_list = user.get_held_items()
	for(var/obj/item/held_thing in held_list)
		if(held_thing == parent)
			return
	handle_boons(user, TRUE)

	return

/datum/component/armour_filtering/proc/on_drop()
	SIGNAL_HANDLER
	var/obj/item/I = parent
	var/mob/living/carbon/human/user

	if(ishuman(I.loc))
		user = I.loc

	if(!user)
		return
	if(!HAS_TRAIT(user, required_trait))
		return

	handle_boons(user, FALSE)

	for(var/thing in user.contents)
		if(!isclothing(thing))
			return
		var/obj/item/clothing/worn_thing = thing
		if(worn_thing == I)
			continue
		if(!(worn_thing.item_flags & IN_INVENTORY))
			return
		if(worn_thing.item_flags & IN_STORAGE)
			return
		var/list/datum/component/armour_filtering/comps = worn_thing.GetComponents(/datum/component/armour_filtering)
		if(!comps)
			continue
		for(var/datum/component/armour_filtering/af_comp in comps)
			if(af_comp.required_trait != required_trait)
				continue
			if(af_comp.positive != positive)
				continue
			if(!af_comp.additive)
				handle_boons(user, TRUE)
				return
			if(af_comp.positive)
				ADD_TRAIT(user, TRAIT_ARMOUR_LIKED, TRAIT_GENERIC)
			else
				ADD_TRAIT(user, TRAIT_ARMOUR_DISLIKED, TRAIT_GENERIC)

	return


/datum/component/armour_filtering/proc/handle_boons(mob/living/carbon/human/user, equip)
	if(equip)
		if(!positive)
			to_chat(user, span_info("[parent] is not to my liking. ([required_trait])"))
			if(HAS_TRAIT(user, TRAIT_ARMOUR_DISLIKED) && !additive)
				to_chat(user, span_info("...yet, another piece of my armour is on my mind."))
				return
			ADD_TRAIT(user, TRAIT_ARMOUR_DISLIKED, TRAIT_GENERIC)
		else
			to_chat(user, span_info("[parent] fits me well. ([required_trait])"))
			if(HAS_TRAIT(user, TRAIT_ARMOUR_LIKED) && !additive)
				to_chat(user, span_info("..yet another piece of my armour is on my mind."))
				return
			ADD_TRAIT(user, TRAIT_ARMOUR_LIKED, TRAIT_GENERIC)
		trait_boon_equip(user)
		return

	if(!positive)
		to_chat(user, span_info("Free at last of [parent]. ([required_trait])"))
		if(HAS_TRAIT(user, TRAIT_ARMOUR_DISLIKED))
			REMOVE_TRAIT(user, TRAIT_ARMOUR_DISLIKED, TRAIT_GENERIC)
	else
		to_chat(user, span_info("I miss [parent] already. ([required_trait])"))
		if(HAS_TRAIT(user, TRAIT_ARMOUR_LIKED))
			REMOVE_TRAIT(user, TRAIT_ARMOUR_LIKED, TRAIT_GENERIC)
	trait_boon_drop(user)
	return


/*
TRAIT UNIQUE PROCS
*/


/datum/component/armour_filtering/proc/trait_boon_equip(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_FENCERDEXTERITY))
		if(!positive)
			user.dropItemToGround(parent, TRUE, TRUE)
			if(!HAS_TRAIT(user, TRAIT_ARMOUR_DISLIKED))
				return
			REMOVE_TRAIT(user, TRAIT_ARMOUR_DISLIKED, TRAIT_GENERIC)
		return
	
	if(HAS_TRAIT(user, TRAIT_PSYDONIAN_GRIT))
		if(positive)
			user.apply_status_effect(/datum/status_effect/buff/psydonic_endurance)
		return
	return

/datum/component/armour_filtering/proc/trait_boon_drop(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_PSYDONIAN_GRIT))
		if(positive)
			if(!user.has_status_effect(/datum/status_effect/buff/psydonic_endurance))
				return
			user.remove_status_effect(/datum/status_effect/buff/psydonic_endurance)
		return
	return
