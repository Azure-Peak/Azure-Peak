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

/datum/customizer/clothing/bra
	name = "Bra"
	customizer_choices = list(/datum/customizer_choice/clothing/bra)

/datum/customizer_choice/clothing/bra
	name = "Bra"
	slot = SLOT_UNDER_TOP
	sprite_accessories = list(
		/datum/sprite_accessory/clothing/bra,
		/datum/sprite_accessory/clothing/bra/bikini,
	)

/datum/customizer/clothing/undershirt
	name = "Undershirt / Bodysuit"
	customizer_choices = list(/datum/customizer_choice/clothing/undershirt)

/datum/customizer_choice/clothing/undershirt
	name = "Undershirt / Bodysuit"
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
		/datum/sprite_accessory/clothing/earring/classic,
		/datum/sprite_accessory/clothing/earring/classic/silver,
		/datum/sprite_accessory/clothing/earring/classic/hoop,
		/datum/sprite_accessory/clothing/earring/classic/hoop/silver,
		/datum/sprite_accessory/clothing/earring,
		/datum/sprite_accessory/clothing/earring/glass,
		/datum/sprite_accessory/clothing/earring/wood,
		/datum/sprite_accessory/clothing/earring/iron,
		/datum/sprite_accessory/clothing/earring/steel,
		/datum/sprite_accessory/clothing/earring/silver,
		/datum/sprite_accessory/clothing/earring/gold,
		/datum/sprite_accessory/clothing/earring/platinum,
		/datum/sprite_accessory/clothing/earring/onyx,
		/datum/sprite_accessory/clothing/earring/emerald,
		/datum/sprite_accessory/clothing/earring/amber,
		/datum/sprite_accessory/clothing/earring/amethyst,
		/datum/sprite_accessory/clothing/earring/ruby,
		/datum/sprite_accessory/clothing/earring/sapphire,
		/datum/sprite_accessory/clothing/earring/diamond,
		/datum/sprite_accessory/clothing/earring/dangle,
		/datum/sprite_accessory/clothing/earring/dangle/glass,
		/datum/sprite_accessory/clothing/earring/dangle/wood,
		/datum/sprite_accessory/clothing/earring/dangle/iron,
		/datum/sprite_accessory/clothing/earring/dangle/steel,
		/datum/sprite_accessory/clothing/earring/dangle/silver,
		/datum/sprite_accessory/clothing/earring/dangle/gold,
		/datum/sprite_accessory/clothing/earring/dangle/platinum,
		/datum/sprite_accessory/clothing/earring/dangle/onyx,
		/datum/sprite_accessory/clothing/earring/dangle/emerald,
		/datum/sprite_accessory/clothing/earring/dangle/amber,
		/datum/sprite_accessory/clothing/earring/dangle/amethyst,
		/datum/sprite_accessory/clothing/earring/dangle/ruby,
		/datum/sprite_accessory/clothing/earring/dangle/sapphire,
		/datum/sprite_accessory/clothing/earring/dangle/diamond,
	)

/datum/customizer_choice/clothing/earring/left
	slot = SLOT_EARRING_L

/datum/customizer_choice/clothing/earring/right
	slot = SLOT_EARRING_R

/// Run before validation replaces accessories that have moved to independent slots.
/datum/preferences/proc/migrate_clothing_customizers()
	for(var/datum/customizer_entry/entry as anything in customizer_entries.Copy())
		if(entry.customizer_type == /datum/customizer/bodypart_feature/underwear)
			switch(entry.accessory_type)
				if(/datum/sprite_accessory/underwear/bikini)
					entry.accessory_type = /datum/sprite_accessory/underwear/bikini_bottom
					migrate_clothing_entry(entry, /datum/customizer/clothing/bra, /datum/sprite_accessory/clothing/bra/bikini)
				if(/datum/sprite_accessory/underwear/leotard)
					migrate_clothing_entry(entry, /datum/customizer/clothing/undershirt, /datum/sprite_accessory/clothing/undershirt/leotard)
					customizer_entries -= entry
				if(/datum/sprite_accessory/underwear/athletic_leotard)
					migrate_clothing_entry(entry, /datum/customizer/clothing/undershirt, /datum/sprite_accessory/clothing/undershirt/athletic_leotard)
					customizer_entries -= entry
		else if(entry.customizer_type == /datum/customizer/bodypart_feature/accessory)
			var/earring_accessory
			switch(entry.accessory_type)
				if(/datum/sprite_accessory/accessory/earrings)
					earring_accessory = /datum/sprite_accessory/clothing/earring/classic
				if(/datum/sprite_accessory/accessory/earrings/sil)
					earring_accessory = /datum/sprite_accessory/clothing/earring/classic/silver
				if(/datum/sprite_accessory/accessory/earrings/hoop)
					earring_accessory = /datum/sprite_accessory/clothing/earring/classic/hoop
				if(/datum/sprite_accessory/accessory/earrings/hoop/sil)
					earring_accessory = /datum/sprite_accessory/clothing/earring/classic/hoop/silver
				if(/datum/sprite_accessory/accessory/choker)
					migrate_clothing_entry(entry, /datum/customizer/clothing/choker, /datum/sprite_accessory/clothing/choker/neckband)
					customizer_entries -= entry
				if(/datum/sprite_accessory/accessory/chokere)
					migrate_clothing_entry(entry, /datum/customizer/clothing/choker, /datum/sprite_accessory/clothing/choker/neckband/embroidered)
					customizer_entries -= entry
			if(earring_accessory)
				migrate_clothing_entry(entry, /datum/customizer/clothing/earring_left, earring_accessory)
				migrate_clothing_entry(entry, /datum/customizer/clothing/earring_right, earring_accessory)
				customizer_entries -= entry

/datum/preferences/proc/migrate_clothing_entry(datum/customizer_entry/source, customizer_type, accessory_type)
	if(get_customizer_entry_for_customizer_type(customizer_type))
		return
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	var/datum/customizer_entry/entry = customizer.make_default_customizer_entry(src, FALSE)
	entry.accessory_type = accessory_type
	entry.accessory_colors = source.accessory_colors
	entry.disabled = source.disabled
	customizer_entries += entry
