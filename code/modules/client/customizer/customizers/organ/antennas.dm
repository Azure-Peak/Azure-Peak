/datum/customizer/organ/antennas
	abstract_type = /datum/customizer/organ/antennas
	name = "Antennas"

/datum/customizer_choice/organ/antennas
	abstract_type = /datum/customizer_choice/organ/antennas
	name = "Antennas"
	organ_type = /obj/item/organ/antennas
	organ_slot = ORGAN_SLOT_ANTENNAS

/datum/customizer/organ/antennas/moth
	allows_disabling = TRUE
	default_disabled = FALSE
	customizer_choices = list(/datum/customizer_choice/organ/antennas/moth)

/datum/customizer_choice/organ/antennas/moth
	name = "Fluvian Antennas"
	organ_type = /obj/item/organ/antennas/moth
	sprite_accessories = list(
		/datum/sprite_accessory/antenna/moth/plain,
		/datum/sprite_accessory/antenna/moth/reddish,
		/datum/sprite_accessory/antenna/moth/royal,
		/datum/sprite_accessory/antenna/moth/gothic,
		/datum/sprite_accessory/antenna/moth/whitefly,
		/datum/sprite_accessory/antenna/moth/lovers,
		/datum/sprite_accessory/antenna/moth/burnt_off,
		/datum/sprite_accessory/antenna/moth/firewatch,
		/datum/sprite_accessory/antenna/moth/deathhead,
		/datum/sprite_accessory/antenna/moth/poison,
		/datum/sprite_accessory/antenna/moth/ragged,
		/datum/sprite_accessory/antenna/moth/moonfly,
		/datum/sprite_accessory/antenna/moth/oakworm,
		/datum/sprite_accessory/antenna/moth/jungle,
		/datum/sprite_accessory/antenna/moth/witchwing,
		/datum/sprite_accessory/antenna/moth/regal,
		/datum/sprite_accessory/antenna/moth/mothra,
		)
