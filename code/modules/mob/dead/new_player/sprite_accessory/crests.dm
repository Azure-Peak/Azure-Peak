/datum/sprite_accessory/crests
	abstract_type = /datum/sprite_accessory/crests
	layer = HAIR_LAYER - 0.1
	icon = 'icons/mob/sprite_accessory/crests/crests.dmi'
	default_colors = list("#FFFFFF")

/datum/sprite_accessory/crests/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/crests/rubyb
	name = "Rontz-Brass Crest"
	icon_state = "rontzb"

/datum/sprite_accessory/crests/ironc
	name = "Iron Crown Crest"
	icon_state = "ironc"

/datum/sprite_accessory/crests/bronzer
	name = "Bronze Rune Crest"
	icon_state = "bronzer"

/datum/sprite_accessory/crests/steelt
	name = "Steel Thorn Crest"
	icon_state = "steelt"
