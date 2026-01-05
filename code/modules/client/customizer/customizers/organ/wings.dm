/datum/customizer/organ/wings
	abstract_type = /datum/customizer/organ/wings
	name = "Wings"

/datum/customizer_choice/organ/wings
	abstract_type = /datum/customizer_choice/organ/wings
	name = "Wings"
	organ_type = /obj/item/organ/wings
	organ_slot = ORGAN_SLOT_WINGS

/datum/customizer/organ/wings/anthro
	customizer_choices = list(/datum/customizer_choice/organ/wings/anthro)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/wings/anthro
	name = "Wings"
	organ_type = /obj/item/organ/wings/anthro
	sprite_accessories = list(
		/datum/sprite_accessory/wings/bat,
		/datum/sprite_accessory/wings/feathery,
		/datum/sprite_accessory/wings/featheryv2,
		/datum/sprite_accessory/wings/wide/succubus,
		/datum/sprite_accessory/wings/fairy,
		/datum/sprite_accessory/wings/bee,
		/datum/sprite_accessory/wings/wide/dragon_alt1,
		/datum/sprite_accessory/wings/wide/dragon_alt2,
		/datum/sprite_accessory/wings/wide/harpywings,
		/datum/sprite_accessory/wings/wide/harpywingsalt1,
		/datum/sprite_accessory/wings/wide/harpywingsalt2,
		/datum/sprite_accessory/wings/wide/harpywings_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt1_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt2_top,
		/datum/sprite_accessory/wings/wide/low_wings,
		/datum/sprite_accessory/wings/wide/low_wings_top,
		/datum/sprite_accessory/wings/wide/spider,
		/datum/sprite_accessory/wings/huge/dragon,
		/datum/sprite_accessory/wings/dragon/clipped,
		/datum/sprite_accessory/wings/large/harpyswept,
		/datum/sprite_accessory/wings/large/harpyswept_alt,
		/datum/sprite_accessory/wings/large/harpyfluff,
		/datum/sprite_accessory/wings/large/harpyfolded,
		/datum/sprite_accessory/wings/large/harpyowl,
		/datum/sprite_accessory/wings/large/harpybat_alt,
		)

/datum/customizer/organ/wings/moth
	name = "Fluvian Wings"
	allows_disabling = TRUE
	default_disabled = FALSE
	customizer_choices = list(/datum/customizer_choice/organ/wings/moth)

/datum/customizer_choice/organ/wings/moth
	name = "Fluvian Wings"
	organ_type = /obj/item/organ/wings/moth
	sprite_accessories = list(
		/datum/sprite_accessory/wings/moth/plain,
		/datum/sprite_accessory/wings/moth/monarch,
		/datum/sprite_accessory/wings/moth/luna,
		/datum/sprite_accessory/wings/moth/atlas,
		/datum/sprite_accessory/wings/moth/reddish,
		/datum/sprite_accessory/wings/moth/royal,
		/datum/sprite_accessory/wings/moth/gothic,
		/datum/sprite_accessory/wings/moth/lovers,
		/datum/sprite_accessory/wings/moth/whitefly,
		/datum/sprite_accessory/wings/moth/punished,
		/datum/sprite_accessory/wings/moth/firewatch,
		/datum/sprite_accessory/wings/moth/deathhead,
		/datum/sprite_accessory/wings/moth/poison,
		/datum/sprite_accessory/wings/moth/ragged,
		/datum/sprite_accessory/wings/moth/moonfly,
		/datum/sprite_accessory/wings/moth/snow,
		/datum/sprite_accessory/wings/moth/oakworm,
		/datum/sprite_accessory/wings/moth/jungle,
		/datum/sprite_accessory/wings/moth/witchwing,
		/datum/sprite_accessory/wings/moth/rosy,
		/datum/sprite_accessory/wings/moth/featherful,
		/datum/sprite_accessory/wings/moth/brown,
		/datum/sprite_accessory/wings/moth/plasmafire,
		)

/datum/customizer/organ/wings/dracon
	customizer_choices = list(/datum/customizer_choice/organ/wings/dracon)
	allows_disabling = FALSE
	default_disabled = FALSE

/datum/customizer_choice/organ/wings/dracon
	name = "Drake Wings"
	organ_type = /obj/item/organ/wings/dracon
	sprite_accessories = list(
		/datum/sprite_accessory/wings/bat,
		/datum/sprite_accessory/wings/wide/succubus,
		/datum/sprite_accessory/wings/wide/dragon_alt1,
		/datum/sprite_accessory/wings/wide/dragon_alt2,
		/datum/sprite_accessory/wings/huge/dragon,
		/datum/sprite_accessory/wings/dragon/clipped,
		)
