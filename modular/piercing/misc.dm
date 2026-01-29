/datum/customizer/bodypart_feature/piercing
	name = "Piercing"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/piercing)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/piercing
	name = "Piercing"
	feature_type = /datum/bodypart_feature/piercing
	sprite_accessories = list(
		/datum/sprite_accessory/piercing/rings,
		/datum/sprite_accessory/piercing/beads,
		/datum/sprite_accessory/piercing/rings/emerald,
		/datum/sprite_accessory/piercing/rings/gold,
		/datum/sprite_accessory/piercing/rings/silver,
		/datum/sprite_accessory/piercing/beads/emerald,
		/datum/sprite_accessory/piercing/beads/gold,
		/datum/sprite_accessory/piercing/beads/silver,
		)
