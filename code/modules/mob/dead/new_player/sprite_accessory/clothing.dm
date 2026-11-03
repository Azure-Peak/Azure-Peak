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

/datum/sprite_accessory/clothing/bra
	item_type = /obj/item/clothing/bra

/datum/sprite_accessory/clothing/bra/bikini
	item_type = /obj/item/clothing/bra/bikini

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
	item_type = /obj/item/earring

/datum/sprite_accessory/clothing/earring/dangle
	item_type = /obj/item/earring/dangle

/datum/sprite_accessory/clothing/earring/glass
	item_type = /obj/item/earring/glass

/datum/sprite_accessory/clothing/earring/dangle/glass
	item_type = /obj/item/earring/dangle/glass

/datum/sprite_accessory/clothing/earring/wood
	item_type = /obj/item/earring/wood

/datum/sprite_accessory/clothing/earring/dangle/wood
	item_type = /obj/item/earring/dangle/wood

/datum/sprite_accessory/clothing/earring/iron
	item_type = /obj/item/earring/iron

/datum/sprite_accessory/clothing/earring/dangle/iron
	item_type = /obj/item/earring/dangle/iron

/datum/sprite_accessory/clothing/earring/steel
	item_type = /obj/item/earring/steel

/datum/sprite_accessory/clothing/earring/dangle/steel
	item_type = /obj/item/earring/dangle/steel

/datum/sprite_accessory/clothing/earring/silver
	item_type = /obj/item/earring/silver

/datum/sprite_accessory/clothing/earring/dangle/silver
	item_type = /obj/item/earring/dangle/silver

/datum/sprite_accessory/clothing/earring/gold
	item_type = /obj/item/earring/gold

/datum/sprite_accessory/clothing/earring/dangle/gold
	item_type = /obj/item/earring/dangle/gold

/datum/sprite_accessory/clothing/earring/platinum
	item_type = /obj/item/earring/platinum

/datum/sprite_accessory/clothing/earring/dangle/platinum
	item_type = /obj/item/earring/dangle/platinum

/datum/sprite_accessory/clothing/earring/onyx
	item_type = /obj/item/earring/onyx

/datum/sprite_accessory/clothing/earring/dangle/onyx
	item_type = /obj/item/earring/dangle/onyx

/datum/sprite_accessory/clothing/earring/emerald
	item_type = /obj/item/earring/emerald

/datum/sprite_accessory/clothing/earring/dangle/emerald
	item_type = /obj/item/earring/dangle/emerald

/datum/sprite_accessory/clothing/earring/amber
	item_type = /obj/item/earring/amber

/datum/sprite_accessory/clothing/earring/dangle/amber
	item_type = /obj/item/earring/dangle/amber

/datum/sprite_accessory/clothing/earring/amethyst
	item_type = /obj/item/earring/amethyst

/datum/sprite_accessory/clothing/earring/dangle/amethyst
	item_type = /obj/item/earring/dangle/amethyst

/datum/sprite_accessory/clothing/earring/ruby
	item_type = /obj/item/earring/ruby

/datum/sprite_accessory/clothing/earring/dangle/ruby
	item_type = /obj/item/earring/dangle/ruby

/datum/sprite_accessory/clothing/earring/sapphire
	item_type = /obj/item/earring/sapphire

/datum/sprite_accessory/clothing/earring/dangle/sapphire
	item_type = /obj/item/earring/dangle/sapphire

/datum/sprite_accessory/clothing/earring/diamond
	item_type = /obj/item/earring/diamond

/datum/sprite_accessory/clothing/earring/dangle/diamond
	item_type = /obj/item/earring/dangle/diamond

/datum/sprite_accessory/clothing/earring/classic
	item_type = /obj/item/earring/classic
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/classic/silver
	item_type = /obj/item/earring/classic/silver
	color_disabled = FALSE

/datum/sprite_accessory/clothing/earring/classic/hoop
	item_type = /obj/item/earring/classic/hoop
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earring/classic/hoop/silver
	item_type = /obj/item/earring/classic/hoop/silver
	color_disabled = FALSE
