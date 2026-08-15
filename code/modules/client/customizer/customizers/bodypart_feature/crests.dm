/datum/customizer/bodypart_feature/crest
	name = "Crest"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/crest)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/crest
	name = "Crest"
	feature_type = /datum/bodypart_feature/crest
	allows_accessory_color_customization = FALSE
	sprite_accessories = list(
		/datum/sprite_accessory/crests/rubyb,
		/datum/sprite_accessory/crests/ironc,
		/datum/sprite_accessory/crests/bronzer,
		/datum/sprite_accessory/crests/steelt,
	)
