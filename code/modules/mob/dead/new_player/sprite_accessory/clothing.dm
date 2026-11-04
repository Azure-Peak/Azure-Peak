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

/datum/sprite_accessory/clothing/underwear_bottom
	name = "Briefs"
	item_type = /obj/item/clothing/underwear_bottom

/datum/sprite_accessory/clothing/underwear_bottom/panties
	name = "Panties"
	item_type = /obj/item/clothing/underwear_bottom/panties

/datum/sprite_accessory/clothing/underwear_bottom/braies
	name = "Braies"
	item_type = /obj/item/clothing/underwear_bottom/braies

/datum/sprite_accessory/clothing/underwear_bottom/briefs_eoran
	name = "Briefs - Eoran"
	item_type = /obj/item/clothing/underwear_bottom/briefs_eoran

/datum/sprite_accessory/clothing/underwear_bottom/bikini_bottom
	name = "Bikini Bottom"
	item_type = /obj/item/clothing/underwear_bottom/bikini_bottom

/datum/sprite_accessory/clothing/underwear_bottom/bandages
	name = "Bandages"
	item_type = /obj/item/clothing/underwear_bottom/bandages

/datum/sprite_accessory/clothing/underwear_top
	abstract_type = /datum/sprite_accessory/clothing/underwear_top

/datum/sprite_accessory/clothing/underwear_top/bikini
	name = "Bikini Top"
	item_type = /obj/item/clothing/underwear_top/bikini

/datum/sprite_accessory/clothing/undershirt
	name = "Sheer Body"
	item_type = /obj/item/clothing/undershirt

/datum/sprite_accessory/clothing/undershirt/leotard
	name = "Leotard"
	item_type = /obj/item/clothing/undershirt/leotard

/datum/sprite_accessory/clothing/undershirt/athletic_leotard
	name = "Athletic Leotard"
	item_type = /obj/item/clothing/undershirt/athletic_leotard

/datum/sprite_accessory/clothing/undershirt/solid_half
	name = "Sheer Half-Body"
	item_type = /obj/item/clothing/undershirt/solid_half

/datum/sprite_accessory/clothing/undershirt/fullbody
	name = "Full-Body Suit"
	item_type = /obj/item/clothing/undershirt/fullbody

/datum/sprite_accessory/clothing/undershirt/silk
	name = "Silk Body"
	item_type = /obj/item/clothing/undershirt/silk

/datum/sprite_accessory/clothing/undershirt/silk_half
	name = "Silk Half-Body"
	item_type = /obj/item/clothing/undershirt/silk_half

/datum/sprite_accessory/clothing/undershirt/mesh
	name = "Mesh Body"
	item_type = /obj/item/clothing/undershirt/mesh

/datum/sprite_accessory/clothing/undershirt/mesh_half
	name = "Mesh Half-Body"
	item_type = /obj/item/clothing/undershirt/mesh_half

/datum/sprite_accessory/clothing/undershirt/net
	name = "Net Body"
	item_type = /obj/item/clothing/undershirt/net

/datum/sprite_accessory/clothing/undershirt/net_half
	name = "Net Half-Body"
	item_type = /obj/item/clothing/undershirt/net_half

/datum/sprite_accessory/clothing/armsleeves
	name = "Cloth Armsleeve"
	item_type = /obj/item/clothing/armsleeves

/datum/sprite_accessory/clothing/armsleeves/solid_half
	name = "Sheer Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/solid_half

/datum/sprite_accessory/clothing/armsleeves/silk
	name = "Silk Armsleeve"
	item_type = /obj/item/clothing/armsleeves/silk

/datum/sprite_accessory/clothing/armsleeves/silk_half
	name = "Silk Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/silk_half

/datum/sprite_accessory/clothing/armsleeves/mesh
	name = "Mesh Armsleeve"
	item_type = /obj/item/clothing/armsleeves/mesh

/datum/sprite_accessory/clothing/armsleeves/mesh_half
	name = "Mesh Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/mesh_half

/datum/sprite_accessory/clothing/armsleeves/net
	name = "Net Armsleeve"
	item_type = /obj/item/clothing/armsleeves/net

/datum/sprite_accessory/clothing/armsleeves/net_half
	name = "Net Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/net_half

/datum/sprite_accessory/clothing/choker
	name = "Choker"
	item_type = /obj/item/clothing/choker

/datum/sprite_accessory/clothing/choker/neckband
	name = "Neckband"
	item_type = /obj/item/clothing/choker/neckband
	color_disabled = TRUE

/datum/sprite_accessory/clothing/choker/neckband/embroidered
	name = "Embroidered Neckband"
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
