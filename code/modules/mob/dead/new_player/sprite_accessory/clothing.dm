/datum/sprite_accessory/clothing
	abstract_type = /datum/sprite_accessory/clothing
	color_key_name = "Clothing"
	/// Real inventory item represented by this character preference.
	var/item_type

/datum/sprite_accessory/clothing/New()
	var/obj/item/garment = item_type
	icon = initial(garment.icon)
	icon_state = initial(garment.icon_state)
	default_colors = list(initial(garment.color) ? initial(garment.color) : "#FFFFFF")
	return ..()

/datum/sprite_accessory/clothing/bikini_top
	name = "Bikini top"
	item_type = /obj/item/clothing/underwear_top/bikini

/datum/sprite_accessory/clothing/undershirt
	name = "Sheer body"
	item_type = /obj/item/clothing/undershirt

/datum/sprite_accessory/clothing/undershirt/leotard
	name = "Leotard"
	item_type = /obj/item/clothing/undershirt/leotard

/datum/sprite_accessory/clothing/undershirt/athletic_leotard
	name = "Athletic leotard"
	item_type = /obj/item/clothing/undershirt/athletic_leotard

/datum/sprite_accessory/clothing/undershirt/solid_half
	name = "Sheer half-body"
	item_type = /obj/item/clothing/undershirt/solid_half

/datum/sprite_accessory/clothing/undershirt/fullbody
	name = "Full-body suit"
	item_type = /obj/item/clothing/undershirt/fullbody

/datum/sprite_accessory/clothing/undershirt/silk
	name = "Silk body"
	item_type = /obj/item/clothing/undershirt/silk

/datum/sprite_accessory/clothing/undershirt/silk_half
	name = "Silk half-body"
	item_type = /obj/item/clothing/undershirt/silk_half

/datum/sprite_accessory/clothing/undershirt/mesh
	name = "Mesh body"
	item_type = /obj/item/clothing/undershirt/mesh

/datum/sprite_accessory/clothing/undershirt/mesh_half
	name = "Mesh half-body"
	item_type = /obj/item/clothing/undershirt/mesh_half

/datum/sprite_accessory/clothing/undershirt/net
	name = "Net body"
	item_type = /obj/item/clothing/undershirt/net

/datum/sprite_accessory/clothing/undershirt/net_half
	name = "Net half-body"
	item_type = /obj/item/clothing/undershirt/net_half

/datum/sprite_accessory/clothing/armsleeves
	name = "Cloth armsleeve"
	item_type = /obj/item/clothing/armsleeves

/datum/sprite_accessory/clothing/armsleeves/solid_half
	name = "Sheer half-armsleeve"
	item_type = /obj/item/clothing/armsleeves/solid_half

/datum/sprite_accessory/clothing/armsleeves/silk
	name = "Silk armsleeve"
	item_type = /obj/item/clothing/armsleeves/silk

/datum/sprite_accessory/clothing/armsleeves/silk_half
	name = "Silk half-armsleeve"
	item_type = /obj/item/clothing/armsleeves/silk_half

/datum/sprite_accessory/clothing/armsleeves/mesh
	name = "Mesh armsleeve"
	item_type = /obj/item/clothing/armsleeves/mesh

/datum/sprite_accessory/clothing/armsleeves/mesh_half
	name = "Mesh half-armsleeve"
	item_type = /obj/item/clothing/armsleeves/mesh_half

/datum/sprite_accessory/clothing/armsleeves/net
	name = "Net armsleeve"
	item_type = /obj/item/clothing/armsleeves/net

/datum/sprite_accessory/clothing/armsleeves/net_half
	name = "Net half-armsleeve"
	item_type = /obj/item/clothing/armsleeves/net_half

/datum/sprite_accessory/clothing/choker
	name = "Choker"
	item_type = /obj/item/clothing/choker

/datum/sprite_accessory/clothing/choker/neckband
	name = "Neckband"
	item_type = /obj/item/clothing/choker/neckband
	color_disabled = TRUE

/datum/sprite_accessory/clothing/choker/neckband/embroidered
	name = "Embroidered neckband"
	item_type = /obj/item/clothing/choker/neckband/embroidered
	color_disabled = TRUE

/datum/sprite_accessory/clothing/garter
	name = "Garters"
	item_type = /obj/item/clothing/garter

/datum/sprite_accessory/clothing/earring
	abstract_type = /datum/sprite_accessory/clothing/earring

/datum/sprite_accessory/clothing/earring/hoop
	abstract_type = /datum/sprite_accessory/clothing/earring/hoop

/datum/sprite_accessory/clothing/earring/silver
	name = "Earrings (S)"
	item_type = /obj/item/earring/silver

/datum/sprite_accessory/clothing/earring/gold
	name = "Earrings (G)"
	item_type = /obj/item/earring/gold
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/hoop/silver
	name = "Hoop Earrings (S)"
	item_type = /obj/item/earring/hoop/silver

/datum/sprite_accessory/clothing/earring/hoop/gold
	name = "Hoop Earrings (G)"
	item_type = /obj/item/earring/hoop/gold
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/stud
	abstract_type = /datum/sprite_accessory/clothing/earring/stud

/datum/sprite_accessory/clothing/earring/stud/silver
	name = "Stud Earrings (S)"
	item_type = /obj/item/earring/stud/silver

/datum/sprite_accessory/clothing/earring/stud/gold
	name = "Stud Earrings (G)"
	item_type = /obj/item/earring/stud/gold
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/dangle
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle

/datum/sprite_accessory/clothing/earring/dangle/silver
	name = "Dangle Earrings (S)"
	item_type = /obj/item/earring/dangle/silver

/datum/sprite_accessory/clothing/earring/dangle/gold
	name = "Dangle Earrings (G)"
	item_type = /obj/item/earring/dangle/gold
	color_disabled = TRUE
