/datum/customizer/bodypart_feature/face_detail
	name = "Face Detail"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/face_detail)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/face_detail
	name = "Face Detail"
	feature_type = /datum/bodypart_feature/face_detail
	allows_accessory_color_customization = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/face_detail/brows,
		/datum/sprite_accessory/face_detail/brows/dark,
		/datum/sprite_accessory/face_detail/scar,
		/datum/sprite_accessory/face_detail/scart,
		/datum/sprite_accessory/face_detail/slashedeye_r,
		/datum/sprite_accessory/face_detail/slashedeye_l,
		/datum/sprite_accessory/face_detail/mangled,
		/datum/sprite_accessory/face_detail/burnface_r,
		/datum/sprite_accessory/face_detail/burnface_l,
		/datum/sprite_accessory/face_detail/deadeye_r,
		/datum/sprite_accessory/face_detail/deadeye_l,
		/datum/sprite_accessory/face_detail/tattoo_lips,
		/datum/sprite_accessory/face_detail/tattoo_eye_r,
		/datum/sprite_accessory/face_detail/tattoo_eye_l,
		/datum/sprite_accessory/face_detail/tattoo_eye_both,
		/datum/sprite_accessory/face_detail/burneye_r,
		/datum/sprite_accessory/face_detail/burneye_l,
		/datum/sprite_accessory/face_detail/scarhead,
		/datum/sprite_accessory/face_detail/eyebags,
		)

/datum/customizer/bodypart_feature/accessory
	name = "Accessory"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/accessory)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/accessory
	name = "Accessory"
	feature_type = /datum/bodypart_feature/accessory
	allows_accessory_color_customization = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/accessory/choker,
		/datum/sprite_accessory/accessory/chokere,
		/datum/sprite_accessory/accessory/eyepierce,
		/datum/sprite_accessory/accessory/eyepierce/alt,
		/datum/sprite_accessory/accessory/harlequin,
		/datum/sprite_accessory/accessory/warpaint,
		/datum/sprite_accessory/accessory/warpaint_stripes,
		)

/datum/customizer/bodypart_feature/legwear
	name = "Legwear"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/legwear)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/legwear
	name = "Legwear"
	feature_type = /datum/bodypart_feature/legwear
	//default_accessory = /datum/sprite_accessory/legwear/stockings
	sprite_accessories = list(
		/datum/sprite_accessory/legwear/stockings,
		/datum/sprite_accessory/legwear/stockings/silk,
		/datum/sprite_accessory/legwear/stockings/fishnet,
		/datum/sprite_accessory/legwear/stockings/thigh_high,
		/datum/sprite_accessory/legwear/stockings/thigh_high_silk,
		/datum/sprite_accessory/legwear/stockings/knee_high,
		/datum/sprite_accessory/legwear/stockings/knee_high_silk,
		/datum/sprite_accessory/legwear/stockings/sleeve_knee_silk,
		/datum/sprite_accessory/legwear/stockings/sleeve_stir_knee_silk,
		/datum/sprite_accessory/legwear/stockings/sleeve_stir_thigh_silk,
		/datum/sprite_accessory/legwear/stockings/sleeve_stir_ankle_silk
		)

/datum/bodypart_feature/legwear/bodypart_feature_additem(mob/living/carbon/owner, obj/item/bodypart/bp)
	if(!ishuman(owner) || !accessory_type)
		return FALSE
	var/datum/sprite_accessory/legwear/accessory = SPRITE_ACCESSORY(accessory_type)
	var/obj/item/clothing/legwears/garment = new accessory.legwear_type(owner)
	garment.color = accessory_colors
	owner.equip_to_slot_or_del(garment, SLOT_SOCKS, TRUE)
	return TRUE
