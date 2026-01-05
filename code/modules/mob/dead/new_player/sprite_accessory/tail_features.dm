/datum/sprite_accessory/tail_feature
	abstract_type = /datum/sprite_accessory/tail_feature
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER)
	var/can_wag = TRUE

/datum/sprite_accessory/tail_feature/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDETAIL)

/datum/sprite_accessory/tail_feature/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES, OFFSET_UNDIES_F)

/datum/sprite_accessory/tail_feature/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!owner || !can_wag)
		return ..()
	var/obj/item/organ/tail/tail_organ = owner.getorganslot(ORGAN_SLOT_TAIL)
	if(!tail_organ || !tail_organ.wagging)
		return ..()
	return "[icon_state]_wagging"

#ifdef UNIT_TESTS

/datum/sprite_accessory/tail_feature/unit_testing_icon_states(list/states)
	states += icon_state
	if(can_wag)
		states += "[icon_state]_wagging"

#endif

/datum/sprite_accessory/tail_feature/spines
	abstract_type = /datum/sprite_accessory/tail_feature/spines
	icon = 'icons/mob/sprite_accessory/tail_features/spines.dmi'
	color_key_name = "Spines"
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_UNDER_LAYER)

/datum/sprite_accessory/tail_feature/spines/short
	name = "Short"
	icon_state = "short"

/datum/sprite_accessory/tail_feature/spines/shortmeme
	name = "Short + Membrane"
	icon_state = "shortmeme"

/datum/sprite_accessory/tail_feature/spines/long
	name = "Long"
	icon_state = "long"

/datum/sprite_accessory/tail_feature/spines/longmeme
	name = "Long + Membrane"
	icon_state = "longmeme"

/datum/sprite_accessory/tail_feature/spines/aquatic
	name = "Aquatic"
	icon_state = "aqua"

/datum/sprite_accessory/tail_feature/vox_marking
	abstract_type = /datum/sprite_accessory/tail_feature/vox_marking
	icon = 'icons/mob/sprite_accessory/tail_features/vox_markings.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	color_key_name = "Marking"

/datum/sprite_accessory/tail_feature/vox_marking/bands
	name = "Bands"
	icon_state = "bands"

/datum/sprite_accessory/tail_feature/vox_marking/tip
	name = "Tip"
	icon_state = "tip"

/datum/sprite_accessory/tail_feature/vox_marking/stripe
	name = "Stripe"
	icon_state = "stripe"

/datum/sprite_accessory/tail_feature/large_snake
	icon = 'icons/mob/tails/large_snake_markings.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
