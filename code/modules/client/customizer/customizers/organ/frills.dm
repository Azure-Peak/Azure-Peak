/datum/customizer/organ/frills
	abstract_type = /datum/customizer/organ/frills
	name = "Frills"

/datum/customizer_choice/organ/frills
	abstract_type = /datum/customizer_choice/organ/frills
	name = "Frills"
	organ_type = /obj/item/organ/frills
	organ_slot = ORGAN_SLOT_FRILLS

/datum/customizer/organ/frills/lizard
	customizer_choices = list(/datum/customizer_choice/organ/frills/lizard)
	allows_disabling = TRUE

/datum/customizer_choice/organ/frills/lizard
	name = "Frills"
	organ_type = /obj/item/organ/frills/lizard
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/frills/simple,
		/datum/sprite_accessory/frills/simpledualcolor,
		/datum/sprite_accessory/frills/short,
		/datum/sprite_accessory/frills/shortdualcolor,
		/datum/sprite_accessory/frills/aquatic,
		/datum/sprite_accessory/frills/aquaticdualcolor,
		/datum/sprite_accessory/frills/divinity,
		/datum/sprite_accessory/frills/horns,
		/datum/sprite_accessory/frills/horns_double,
		/datum/sprite_accessory/frills/big,
		/datum/sprite_accessory/frills/split,
		/datum/sprite_accessory/frills/split_big,
		/datum/sprite_accessory/frills/split_slim,
		/datum/sprite_accessory/frills/earlike,
		/datum/sprite_accessory/frills/earlike_thick,
		/datum/sprite_accessory/frills/earlike_angled,
		/datum/sprite_accessory/frills/earlike_long,
		)

/datum/customizer/organ/frills/anthro
	customizer_choices = list(/datum/customizer_choice/organ/frills/anthro)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/frills/anthro
	name = "Frills"
	organ_type = /obj/item/organ/frills
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/frills/simple,
		/datum/sprite_accessory/frills/short,
		/datum/sprite_accessory/frills/aquatic,
		/datum/sprite_accessory/frills/divinity,
		/datum/sprite_accessory/frills/horns,
		/datum/sprite_accessory/frills/horns_double,
		/datum/sprite_accessory/frills/big,
		/datum/sprite_accessory/frills/split,
		/datum/sprite_accessory/frills/split_big,
		/datum/sprite_accessory/frills/split_slim,
		/datum/sprite_accessory/frills/earlike,
		/datum/sprite_accessory/frills/earlike_thick,
		/datum/sprite_accessory/frills/earlike_angled,
		/datum/sprite_accessory/frills/earlike_long,
		)
