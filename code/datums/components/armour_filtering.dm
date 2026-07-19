/datum/component/armour_filtering
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/required_trait
	var/positive
	var/filter_id
	var/datum/armour_filter_effect/effect

/datum/component/armour_filtering/Initialize(skill_trait, id, bonus_additive = FALSE)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	required_trait = skill_trait
	filter_id = id
	effect = resolve_armour_filter_effect(skill_trait, id)

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_obj_examine))

/datum/component/armour_filtering/positive
	positive = TRUE

/datum/component/armour_filtering/negative
	positive = FALSE

/datum/component/armour_filtering/proc/on_equip()
	SIGNAL_HANDLER
	var/obj/item/worn = parent
	if(!ishuman(worn.loc))
		return
	var/mob/living/carbon/human/user = worn.loc
	if(!HAS_TRAIT(user, required_trait))
		return
	if(!isclothing(worn))
		return
	if(worn.item_flags & IN_STORAGE)
		return
	if(worn in user.get_held_items())
		return
	effect.on_equip(user, src)

/datum/component/armour_filtering/proc/on_drop()
	SIGNAL_HANDLER
	var/obj/item/worn = parent
	if(!ishuman(worn.loc))
		return
	var/mob/living/carbon/human/user = worn.loc
	if(!HAS_TRAIT(user, required_trait))
		return
	effect.on_drop(user, src)
	for(var/obj/item/clothing/still_worn in user.get_equipped_items())
		if(still_worn == worn)
			continue
		for(var/datum/component/armour_filtering/other in still_worn.GetComponents(/datum/component/armour_filtering))
			if(other.required_trait != required_trait)
				continue
			if(other.positive != positive)
				continue
			effect.on_equip(user, src)
			return

/datum/component/armour_filtering/proc/on_obj_examine(datum/source, mob/M)
	if(!HAS_TRAIT(M, required_trait))
		return
	if(positive)
		to_chat(M, span_green("[parent] suits me. ([required_trait])"))
		return
	to_chat(M, span_red("[parent] does not suit me. ([required_trait])"))


GLOBAL_LIST_INIT(armour_filter_effects, init_armour_filter_effects())
GLOBAL_DATUM_INIT(armour_filter_effect_generic, /datum/armour_filter_effect, new)

/proc/init_armour_filter_effects()
	. = list()
	for(var/datum/armour_filter_effect/effect_path as anything in subtypesof(/datum/armour_filter_effect))
		. += new effect_path()

/proc/resolve_armour_filter_effect(trait, id)
	for(var/datum/armour_filter_effect/effect as anything in GLOB.armour_filter_effects)
		if(effect.handles(trait, id))
			return effect
	return GLOB.armour_filter_effect_generic

/datum/armour_filter_effect
	var/required_trait
	var/required_id
	var/reject = FALSE
	var/reject_message
	var/worn_buff
	var/unworn_debuff
	var/unworn_stress
	var/unworn_exempt_species

/datum/armour_filter_effect/proc/handles(trait, id)
	if(required_trait != trait)
		return FALSE
	if(required_id && required_id != id)
		return FALSE
	return TRUE

/datum/armour_filter_effect/proc/on_equip(mob/living/carbon/human/user, datum/component/armour_filtering/filter)
	if(!filter.positive)
		to_chat(user, span_info("[filter.parent] is not to my liking. ([filter.required_trait])"))
		ADD_TRAIT(user, TRAIT_ARMOUR_DISLIKED, TRAIT_GENERIC)
		if(reject)
			user.dropItemToGround(filter.parent, TRUE, TRUE)
			if(reject_message)
				to_chat(user, span_warning(reject_message))
			REMOVE_TRAIT(user, TRAIT_ARMOUR_DISLIKED, TRAIT_GENERIC)
		return
	to_chat(user, span_info("[filter.parent] fits me well. ([filter.required_trait])"))
	ADD_TRAIT(user, TRAIT_ARMOUR_LIKED, TRAIT_GENERIC)
	if(worn_buff)
		user.apply_status_effect(worn_buff)
	if(unworn_debuff)
		user.remove_status_effect(unworn_debuff)
	if(unworn_stress)
		user.remove_stress(unworn_stress)

/datum/armour_filter_effect/proc/on_drop(mob/living/carbon/human/user, datum/component/armour_filtering/filter)
	if(!filter.positive)
		to_chat(user, span_info("Free at last of [filter.parent]. ([filter.required_trait])"))
		REMOVE_TRAIT(user, TRAIT_ARMOUR_DISLIKED, TRAIT_GENERIC)
		return
	to_chat(user, span_info("I miss [filter.parent] already. ([filter.required_trait])"))
	REMOVE_TRAIT(user, TRAIT_ARMOUR_LIKED, TRAIT_GENERIC)
	if(worn_buff)
		user.remove_status_effect(worn_buff)
	if(!unworn_debuff)
		return
	if(unworn_exempt_species && is_species(user, unworn_exempt_species))
		return
	user.apply_status_effect(unworn_debuff)
	if(unworn_stress)
		user.add_stress(unworn_stress)


/datum/armour_filter_effect/fencer
	required_trait = TRAIT_FENCERDEXTERITY
	reject = TRUE

/datum/armour_filter_effect/honorbound
	required_trait = TRAIT_HONORBOUND
	reject = TRUE

/datum/armour_filter_effect/arcyne
	required_trait = TRAIT_ARCYNE
	reject = TRUE
	reject_message = "It may be light, but this armor chafes my focus far too much. I couldn't hope to channel my magicka, while wearing it."

/datum/armour_filter_effect/civilized_barbarian
	required_trait = TRAIT_CIVILIZEDBARBARIAN
	reject = TRUE
	reject_message = "It may be light, but this armor chafes my focus far too much. I couldn't hope to hone my techniques, while wearing it."


/datum/armour_filter_effect/psydonian_grit
	required_trait = TRAIT_PSYDONIAN_GRIT
	required_id = "ornate_plate"
	worn_buff = /datum/status_effect/buff/psydonic_endurance

/datum/armour_filter_effect/naledi_mask
	required_trait = TRAIT_NALEDI
	required_id = "naledi_mask"
	unworn_debuff = /datum/status_effect/debuff/lost_naledi_mask
	unworn_stress = /datum/stressevent/naledimasklost
	unworn_exempt_species = /datum/species/tieberian

/datum/armour_filter_effect/dungeoneer_hood
	required_trait = TRAIT_JAILOR
	required_id = "dungeoneer"
	unworn_debuff = /datum/status_effect/debuff/lost_dungeoneer_hood
	unworn_stress = /datum/stressevent/dungeoneerhoodlost
