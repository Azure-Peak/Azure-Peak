/datum/sprite_accessory/frills
	abstract_type = /datum/sprite_accessory/frills
	icon = 'icons/mob/sprite_accessory/frills/frills.dmi'
	color_key_name = "Frills"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/frills/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEEARS|HIDEHAIR)

/datum/sprite_accessory/frills/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/frills/simple
	name = "Simple"
	icon_state = "simple"

/datum/sprite_accessory/frills/simpledualcolor
	name = "Simple - Dual Color"
	icon_state = "m_frills_simple"
	color_keys = 2
	color_key_names = list("Outer", "Inner")

/datum/sprite_accessory/frills/short
	name = "Short"
	icon_state = "short"

/datum/sprite_accessory/frills/shortdualcolor
	name = "Short - Dual Color"
	icon_state = "m_frills_short"
	color_keys = 2
	color_key_names = list("Outer", "Inner")

/datum/sprite_accessory/frills/aquatic
	name = "Aquatic"
	icon_state = "aqua"

/datum/sprite_accessory/frills/aquaticdualcolor
	name = "Aquatic - Dual Color"
	icon_state = "m_frills_aqua"
	color_keys = 2
	color_key_names = list("Outer", "Inner")

/datum/sprite_accessory/frills/divinity
	name = "Divinity"
	icon_state = "divinity"

/datum/sprite_accessory/frills/horns
	name = "Horns"
	icon_state = "horns"

/datum/sprite_accessory/frills/horns_double
	name = "Horns Double"
	icon_state = "hornsdouble"

/datum/sprite_accessory/frills/big
	name = "Big"
	icon_state = "big"

/datum/sprite_accessory/frills/cobrahood
	name = "Cobra Hood"
	icon_state = "cobrahood"
	color_keys = 2
	color_key_names = list("Hood", "Inner")

/datum/sprite_accessory/frills/cobrahood_ears
	name = "Cobra Hood (Ears)"
	icon_state = "cobraears"
	color_keys = 2
	color_key_names = list("Hood", "Inner")

/datum/sprite_accessory/frills/split
	name = "Split"
	icon_state = "split"

/datum/sprite_accessory/frills/split_big
	name = "Split (Big)"
	icon_state = "split_big"

/datum/sprite_accessory/frills/split_slim
	name = "Split (Slim)"
	icon_state = "split_slim"

/datum/sprite_accessory/frills/earlike
	name = "Earlike"
	icon_state = "earlike"
	color_keys = 2
	color_key_names = list("Outer", "Inner")

/datum/sprite_accessory/frills/earlike_thick
	name = "Earlike (Thick)"
	icon_state = "earlike_thick"

/datum/sprite_accessory/frills/earlike_angled
	name = "Earlike (Angled)"
	icon_state = "earlike_angled"

/datum/sprite_accessory/frills/earlike_long
	name = "Earlike (Long)"
	icon_state = "earlike_long"
