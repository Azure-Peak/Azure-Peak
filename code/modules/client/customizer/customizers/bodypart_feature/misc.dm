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
		/datum/sprite_accessory/accessory/earrings,
		/datum/sprite_accessory/accessory/earrings/sil,
		/datum/sprite_accessory/accessory/earrings/em,
		/datum/sprite_accessory/accessory/eyepierce,
		/datum/sprite_accessory/accessory/eyepierce/alt,
		/datum/sprite_accessory/accessory/choker,
		/datum/sprite_accessory/accessory/chokere,
		/datum/sprite_accessory/accessory/harlequin,
		/datum/sprite_accessory/accessory/warpaint,
		)

/datum/customizer/bodypart_feature/accessory
	name = "Accessory"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/accessory)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer/bodypart_feature/underwear
	name = "Underwear"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/underwear)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/underwear
	name = "Underwear"
	feature_type = /datum/bodypart_feature/underwear
	sprite_accessories = list(
		/datum/sprite_accessory/underwear/briefs,
		/datum/sprite_accessory/underwear/briefs/eoran,
		/datum/sprite_accessory/underwear/panties,
		/datum/sprite_accessory/underwear/bikini,
		/datum/sprite_accessory/underwear/leotard,
		/datum/sprite_accessory/underwear/athletic_leotard,
		/datum/sprite_accessory/underwear/braies
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
		)
