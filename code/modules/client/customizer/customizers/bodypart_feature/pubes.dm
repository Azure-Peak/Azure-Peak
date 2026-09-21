/datum/customizer/bodypart_feature/pubes
	name = "Pubes"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/pubes)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/pubes
	name = "Pubic Style"
	feature_type = /datum/bodypart_feature/pubes
	sprite_accessories = list(
		/datum/sprite_accessory/pubes/hairy,
		/datum/sprite_accessory/pubes/trim,
		/datum/sprite_accessory/pubes/strip,
		/datum/sprite_accessory/pubes/heart,
		/datum/sprite_accessory/pubes/extreme,
		/datum/sprite_accessory/pubes/cross,
	)

/datum/customizer/bodypart_feature/pits
	name = "Armpits"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/pits)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/pits
	name = "Armpit Style"
	feature_type = /datum/bodypart_feature/pits
	sprite_accessories = list(
		/datum/sprite_accessory/pits/trim,
		/datum/sprite_accessory/pits/moderate,
		/datum/sprite_accessory/pits/hairy,
		//datum/sprite_accessory/pits/extreme excluded from this port for aesthetic sensibilits, still present in the .dmi
	)
