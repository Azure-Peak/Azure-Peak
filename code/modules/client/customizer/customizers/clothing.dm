/datum/customizer/clothing
	abstract_type = /datum/customizer/clothing
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/clothing
	abstract_type = /datum/customizer_choice/clothing
	var/slot

/datum/customizer_choice/clothing/apply_customizer_to_character(mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/entry)
	if(!entry.accessory_type || human.get_item_by_slot(slot))
		return
	var/datum/sprite_accessory/clothing/accessory = SPRITE_ACCESSORY(entry.accessory_type)
	var/obj/item/garment = new accessory.item_type(human)
	var/list/colors = color_string_to_list(entry.accessory_colors)
	if(length(colors))
		garment.color = colors[1]
	human.equip_to_slot_or_del(garment, slot, TRUE)

/datum/customizer/clothing/underwear_bottom
	name = "Underwear Bottom"
	customizer_choices = list(/datum/customizer_choice/clothing/underwear_bottom)

/datum/customizer_choice/clothing/underwear_bottom
	name = "Underwear Bottom"
	slot = SLOT_UNDER_BOTTOM
	sprite_accessories = list(
		/datum/sprite_accessory/clothing/underwear_bottom/panties,
		/datum/sprite_accessory/clothing/underwear_bottom/braies,
		/datum/sprite_accessory/clothing/underwear_bottom,
		/datum/sprite_accessory/clothing/underwear_bottom/briefs_eoran,
		/datum/sprite_accessory/clothing/underwear_bottom/bikini_bottom,
		/datum/sprite_accessory/clothing/underwear_bottom/bandages,
	)

/datum/customizer/clothing/underwear_top
	name = "Underwear Top"
	customizer_choices = list(/datum/customizer_choice/clothing/underwear_top)

/datum/customizer_choice/clothing/underwear_top
	name = "Underwear Top"
	slot = SLOT_UNDER_TOP
	sprite_accessories = list(
		/datum/sprite_accessory/clothing/bikini_top,
	)

/datum/customizer/clothing/undershirt
	name = "Undershirt"
	customizer_choices = list(/datum/customizer_choice/clothing/undershirt)

/datum/customizer_choice/clothing/undershirt
	name = "Undershirt"
	slot = SLOT_UNDERSHIRT
	sprite_accessories = list(
		/datum/sprite_accessory/clothing/undershirt,
		/datum/sprite_accessory/clothing/undershirt/leotard,
		/datum/sprite_accessory/clothing/undershirt/athletic_leotard,
		/datum/sprite_accessory/clothing/undershirt/solid_half,
		/datum/sprite_accessory/clothing/undershirt/fullbody,
		/datum/sprite_accessory/clothing/undershirt/silk,
		/datum/sprite_accessory/clothing/undershirt/silk_half,
		/datum/sprite_accessory/clothing/undershirt/mesh,
		/datum/sprite_accessory/clothing/undershirt/mesh_half,
		/datum/sprite_accessory/clothing/undershirt/net,
		/datum/sprite_accessory/clothing/undershirt/net_half,
	)

/datum/customizer/clothing/armsleeves
	name = "Armsleeves"
	customizer_choices = list(/datum/customizer_choice/clothing/armsleeves)

/datum/customizer_choice/clothing/armsleeves
	name = "Armsleeves"
	slot = SLOT_ARMSLEEVES
	sprite_accessories = list(
		/datum/sprite_accessory/clothing/armsleeves,
		/datum/sprite_accessory/clothing/armsleeves/solid_half,
		/datum/sprite_accessory/clothing/armsleeves/silk,
		/datum/sprite_accessory/clothing/armsleeves/silk_half,
		/datum/sprite_accessory/clothing/armsleeves/mesh,
		/datum/sprite_accessory/clothing/armsleeves/mesh_half,
		/datum/sprite_accessory/clothing/armsleeves/net,
		/datum/sprite_accessory/clothing/armsleeves/net_half,
	)

/datum/customizer/clothing/choker
	name = "Choker"
	customizer_choices = list(/datum/customizer_choice/clothing/choker)

/datum/customizer_choice/clothing/choker
	name = "Choker"
	slot = SLOT_CHOKER
	sprite_accessories = list(
		/datum/sprite_accessory/clothing/choker,
		/datum/sprite_accessory/clothing/choker/neckband,
		/datum/sprite_accessory/clothing/choker/neckband/embroidered,
	)

/datum/customizer/clothing/garter
	name = "Garters"
	customizer_choices = list(/datum/customizer_choice/clothing/garter)

/datum/customizer_choice/clothing/garter
	name = "Garters"
	slot = SLOT_GARTER
	sprite_accessories = list(/datum/sprite_accessory/clothing/garter)

/datum/customizer/clothing/earring_left
	name = "Left Earring"
	customizer_choices = list(/datum/customizer_choice/clothing/earring/left)

/datum/customizer/clothing/earring_right
	name = "Right Earring"
	customizer_choices = list(/datum/customizer_choice/clothing/earring/right)

/datum/customizer_choice/clothing/earring
	abstract_type = /datum/customizer_choice/clothing/earring
	name = "Earring"
	sprite_accessories = list(
		/datum/sprite_accessory/clothing/earring/silver,
		/datum/sprite_accessory/clothing/earring/gold,
		/datum/sprite_accessory/clothing/earring/hoop/silver,
		/datum/sprite_accessory/clothing/earring/hoop/gold,
		/datum/sprite_accessory/clothing/earring/stud/silver,
		/datum/sprite_accessory/clothing/earring/stud/gold,
		/datum/sprite_accessory/clothing/earring/dangle/silver,
		/datum/sprite_accessory/clothing/earring/dangle/gold,
	)

/datum/customizer_choice/clothing/earring/left
	slot = SLOT_EARRING_L

/datum/customizer_choice/clothing/earring/right
	slot = SLOT_EARRING_R
