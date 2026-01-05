/datum/component/skill_blessed
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/required_trait
	var/datum/skill/weapon_skill
	var/skill_amount
	var/original_skill
	var/mob/living/carbon/human/original_user
	var/unique

/datum/component/skill_blessed/Initialize(skill_trait, skillgiven_type, skillgiven_amount, trait_unique = FALSE)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	required_trait = skill_trait
	weapon_skill = skillgiven_type
	skill_amount = skillgiven_amount
	unique = trait_unique

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/component/skill_blessed/proc/on_equip()
	SIGNAL_HANDLER
	var/obj/item/I = parent
	var/mob/living/carbon/human/user

	if(ishuman(I.loc))
		user = I.loc
	else if(ishuman(I.loc.loc))
		user = I.loc.loc

	if(!user)
		return
	if(!HAS_TRAIT(user, required_trait))
		return

	var/list/obj/item/held_list = user.get_held_items()
	for(var/obj/item/held_thing in held_list)
		if(held_thing == parent)
			give_skill(user)
			return
	remove_skill(user)

/datum/component/skill_blessed/proc/on_drop()
	SIGNAL_HANDLER

	if(!original_user)
		return
	if(!ishuman(original_user))
		return

	if(!HAS_TRAIT(original_user, required_trait))
		return
	if(!HAS_TRAIT(original_user, TRAIT_SKILLBLESSED))
		return

	for(var/obj/item/held_thing in original_user.get_held_items())
		if(istype(held_thing, parent.type))
			return

	remove_skill(original_user)


/datum/component/skill_blessed/proc/give_skill(mob/user)
	if(!HAS_TRAIT(user, required_trait))
		return
	if(HAS_TRAIT(user, TRAIT_SKILLBLESSED))
		to_chat(user, span_warning("My mind is already focused on a different weapon."))
		return

	to_chat(user, span_info("[parent] and I are old friends. ([required_trait])"))
	original_skill = user.get_skill_level(weapon_skill)
	user.adjust_skillrank_up_to(weapon_skill, skill_amount, silent = TRUE)
	ADD_TRAIT(user, TRAIT_SKILLBLESSED, TRAIT_GENERIC)

	original_user = user
	if(unique)
		trait_unique_equip(user)

	return

/datum/component/skill_blessed/proc/remove_skill(mob/user)
	if(!HAS_TRAIT(user, required_trait))
		return
	if(!HAS_TRAIT(original_user, TRAIT_SKILLBLESSED))
		return

	var/datum/component/skill_blessed/other_skill

	for(var/obj/item/held_thing in user.get_held_items())
		if(held_thing == parent)
			return
		var/list/datum/component/skill_blessed/comps = held_thing.GetComponents(/datum/component/skill_blessed)
		if(!comps)
			continue
		for(var/datum/component/skill_blessed/sb_comp in comps)
			if(!HAS_TRAIT(user, sb_comp.required_trait))
				continue
			other_skill = sb_comp
			break

	user.adjust_skillrank_down_to(weapon_skill, original_skill, silent = TRUE)
	to_chat(user, span_info("Another tyme, old friend. ([required_trait])"))
	REMOVE_TRAIT(user, TRAIT_SKILLBLESSED, TRAIT_GENERIC)

	if(unique)
		trait_unique_drop(user)
	if(original_user)
		original_user = null
	if(original_skill)
		original_skill = null
	if(other_skill)
		other_skill.on_equip()

	return


/*
TRAIT UNIQUE PROCS
*/


/datum/component/skill_blessed/proc/trait_unique_equip(mob/user)
	if(HAS_TRAIT(user, TRAIT_SABRIST))
		var/obj/item/rogueweapon/sword/sabre/steppesman/shashka = parent
		for(var/datum/intent/sword/sab_intent in shashka.possible_item_intents)
			sab_intent.accuracy_modifier += 10
		return

/datum/component/skill_blessed/proc/trait_unique_drop(mob/user)
	if(HAS_TRAIT(user, TRAIT_SABRIST))
		var/obj/item/rogueweapon/sword/sabre/steppesman/shashka = parent
		for(var/datum/intent/sword/sab_intent in shashka.possible_item_intents)
			sab_intent.accuracy_modifier = initial(sab_intent.accuracy_modifier)
		return


