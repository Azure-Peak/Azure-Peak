/datum/sprite_accessory/face_detail
	icon = 'icons/mob/sprite_accessory/face_detail.dmi'
	layer = BODY_LAYER
	default_colors = list("FFFFFF")
	color_disabled = TRUE

/datum/sprite_accessory/face_detail/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEFACE)

/datum/sprite_accessory/face_detail/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/face_detail/brows
	name = "Thick Eyebrows"
	icon_state = "brows"
	layer = BODY_LAYER
	default_colors =	null
	color_key_defaults = list(KEY_HAIR_COLOR)
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/brows/dark
	name = "Dark Eyebrows"
	icon_state = "darkbrows"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/scar
	name = "Scar"
	icon_state = "scar"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/scart
	name = "Scar2"
	layer = BODY_LAYER
	icon_state = "scar2"

/datum/sprite_accessory/face_detail/slashedeye_r
	name = "Slashed Eye (r)"
	icon_state = "slashedeye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/slashedeye_r
	name = "Slashed Eye (r)"
	icon_state = "slashedeye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/slashedeye_l
	name = "Slashed Eye (l)"
	icon_state = "slashedeye_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/mangled
	name = "Mangled Jaw"
	icon_state = "mangled"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/tattoo_lips
	name = "Tattoo (Lips)"
	icon_state = "tattoo_lips"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/tattoo_eye_r
	name = "Tattoo (r Eye)"
	icon_state = "tattoo_eye_r"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/tattoo_eye_l
	name = "Tattoo (l Eye)"
	icon_state = "tattoo_eye_l"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/tattoo_eye_both
	name = "Tattoo (Both Eyes)"
	icon_state = "tattoo_eye_both"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/face_detail/burnface_r
	name = "Burns (r)"
	icon_state = "burnface_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/burnface_l
	name = "Burns (l)"
	icon_state = "burnface_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/burneye_r
	name = "Burned Eye (r)"
	icon_state = "burneye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/burneye_l
	name = "Burned Eye (l)"
	icon_state = "burneye_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/deadeye_r
	name = "Dead Eye (r)"
	icon_state = "deadeye_r"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/deadeye_l
	name = "Dead Eye (l)"
	icon_state = "deadeye_l"
	layer = BODY_LAYER

/datum/sprite_accessory/face_detail/scarhead
	name = "Scarred Head"
	icon_state = "scarhead"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory
	icon = 'icons/mob/sprite_accessory/accessory.dmi'
	default_colors = list("FFFFFF")
	color_disabled = TRUE

/datum/sprite_accessory/accessory/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEFACE)

/datum/sprite_accessory/accessory/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/accessory/earrings
	name = "Earrings (G)"
	icon_state = "earrings"
	layer = BODY_FRONT_LAYER

/datum/sprite_accessory/accessory/earrings/sil
	name = "Earrings (Colorable)"
	icon_state = "earrings_sil"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/earrings/em
	name = "Earrings (E)"
	icon_state = "earrings_em"
	layer = BODY_FRONT_LAYER

/datum/sprite_accessory/accessory/eyepierce
	name = "Pierced Brow (L)"
	icon_state = "eyepierce"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/eyepierce/alt
	name = "Pierced Brow (R)"
	icon_state = "eyepiercealt"
	layer = BODY_LAYER
	color_disabled = FALSE

/datum/sprite_accessory/accessory/choker
	name = "Neckband"
	icon_state = "choker"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory/chokere
	name = "Neckband (E)"
	icon_state = "chokere"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory/harlequin
	name = "Harlequin"
	icon_state = "harlequin"
	layer = BODY_LAYER

/datum/sprite_accessory/accessory/warpaint
	name = "Warpaint"
	icon_state = "warpaint"
	layer = BODY_FRONT_LAYER
	color_disabled = FALSE
