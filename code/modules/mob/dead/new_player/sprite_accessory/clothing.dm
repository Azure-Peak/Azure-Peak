/datum/sprite_accessory/clothing
	abstract_type = /datum/sprite_accessory/clothing
	color_key_name = "Clothing"
	/// Real inventory item represented by this character preference.
	var/item_type

/datum/sprite_accessory/clothing/New()
	var/obj/item/garment = item_type
	name = initial(garment.name)
	icon = initial(garment.icon)
	icon_state = initial(garment.icon_state)
	default_colors = list(initial(garment.color) ? initial(garment.color) : "#FFFFFF")
	return ..()

/datum/sprite_accessory/clothing/bikini_top
	item_type = /obj/item/clothing/underwear_top/bikini

/datum/sprite_accessory/clothing/undershirt
	item_type = /obj/item/clothing/undershirt

/datum/sprite_accessory/clothing/undershirt/leotard
	item_type = /obj/item/clothing/undershirt/leotard

/datum/sprite_accessory/clothing/undershirt/athletic_leotard
	item_type = /obj/item/clothing/undershirt/athletic_leotard

/datum/sprite_accessory/clothing/undershirt/solid_half
	item_type = /obj/item/clothing/undershirt/solid_half

/datum/sprite_accessory/clothing/undershirt/fullbody
	item_type = /obj/item/clothing/undershirt/fullbody

/datum/sprite_accessory/clothing/undershirt/silk
	item_type = /obj/item/clothing/undershirt/silk

/datum/sprite_accessory/clothing/undershirt/silk_half
	item_type = /obj/item/clothing/undershirt/silk_half

/datum/sprite_accessory/clothing/undershirt/mesh
	item_type = /obj/item/clothing/undershirt/mesh

/datum/sprite_accessory/clothing/undershirt/mesh_half
	item_type = /obj/item/clothing/undershirt/mesh_half

/datum/sprite_accessory/clothing/undershirt/net
	item_type = /obj/item/clothing/undershirt/net

/datum/sprite_accessory/clothing/undershirt/net_half
	item_type = /obj/item/clothing/undershirt/net_half

/datum/sprite_accessory/clothing/armsleeves
	item_type = /obj/item/clothing/armsleeves

/datum/sprite_accessory/clothing/armsleeves/solid_half
	item_type = /obj/item/clothing/armsleeves/solid_half

/datum/sprite_accessory/clothing/armsleeves/silk
	item_type = /obj/item/clothing/armsleeves/silk

/datum/sprite_accessory/clothing/armsleeves/silk_half
	item_type = /obj/item/clothing/armsleeves/silk_half

/datum/sprite_accessory/clothing/armsleeves/mesh
	item_type = /obj/item/clothing/armsleeves/mesh

/datum/sprite_accessory/clothing/armsleeves/mesh_half
	item_type = /obj/item/clothing/armsleeves/mesh_half

/datum/sprite_accessory/clothing/armsleeves/net
	item_type = /obj/item/clothing/armsleeves/net

/datum/sprite_accessory/clothing/armsleeves/net_half
	item_type = /obj/item/clothing/armsleeves/net_half

/datum/sprite_accessory/clothing/choker
	item_type = /obj/item/clothing/choker

/datum/sprite_accessory/clothing/choker/neckband
	item_type = /obj/item/clothing/choker/neckband
	color_disabled = TRUE

/datum/sprite_accessory/clothing/choker/neckband/embroidered
	item_type = /obj/item/clothing/choker/neckband/embroidered
	color_disabled = TRUE

/datum/sprite_accessory/clothing/garter
	item_type = /obj/item/clothing/garter

/datum/sprite_accessory/clothing/earring
	abstract_type = /datum/sprite_accessory/clothing/earring

/datum/sprite_accessory/clothing/earring/hoop
	abstract_type = /datum/sprite_accessory/clothing/earring/hoop

/datum/sprite_accessory/clothing/earring/silver
	item_type = /obj/item/earring/silver

/datum/sprite_accessory/clothing/earring/gold
	item_type = /obj/item/earring/gold
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/hoop/silver
	item_type = /obj/item/earring/hoop/silver

/datum/sprite_accessory/clothing/earring/hoop/gold
	item_type = /obj/item/earring/hoop/gold
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/stud
	abstract_type = /datum/sprite_accessory/clothing/earring/stud

/datum/sprite_accessory/clothing/earring/stud/silver
	item_type = /obj/item/earring/stud/silver

/datum/sprite_accessory/clothing/earring/stud/gold
	item_type = /obj/item/earring/stud/gold
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/dangle
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle

/datum/sprite_accessory/clothing/earring/dangle/silver
	item_type = /obj/item/earring/dangle/silver

/datum/sprite_accessory/clothing/earring/dangle/gold
	item_type = /obj/item/earring/dangle/gold
	color_disabled = TRUE
