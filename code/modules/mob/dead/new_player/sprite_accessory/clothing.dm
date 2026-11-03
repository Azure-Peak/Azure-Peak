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

/datum/sprite_accessory/clothing/earring/classic
	item_type = /obj/item/earring/classic

/datum/sprite_accessory/clothing/earring/classic/hoop
	item_type = /obj/item/earring/classic/hoop

// Retired color choices remain readable in savefiles; validation folds them into the four shapes.
/datum/sprite_accessory/clothing/earring/glass
	abstract_type = /datum/sprite_accessory/clothing/earring/glass

/datum/sprite_accessory/clothing/earring/dangle/glass
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/glass

/datum/sprite_accessory/clothing/earring/wood
	abstract_type = /datum/sprite_accessory/clothing/earring/wood

/datum/sprite_accessory/clothing/earring/dangle/wood
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/wood

/datum/sprite_accessory/clothing/earring/iron
	abstract_type = /datum/sprite_accessory/clothing/earring/iron

/datum/sprite_accessory/clothing/earring/dangle/iron
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/iron

/datum/sprite_accessory/clothing/earring/steel
	abstract_type = /datum/sprite_accessory/clothing/earring/steel

/datum/sprite_accessory/clothing/earring/dangle/steel
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/steel

/datum/sprite_accessory/clothing/earring/silver
	abstract_type = /datum/sprite_accessory/clothing/earring/silver

/datum/sprite_accessory/clothing/earring/dangle/silver
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/silver

/datum/sprite_accessory/clothing/earring/gold
	abstract_type = /datum/sprite_accessory/clothing/earring/gold

/datum/sprite_accessory/clothing/earring/dangle/gold
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/gold

/datum/sprite_accessory/clothing/earring/platinum
	abstract_type = /datum/sprite_accessory/clothing/earring/platinum

/datum/sprite_accessory/clothing/earring/dangle/platinum
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/platinum

/datum/sprite_accessory/clothing/earring/onyx
	abstract_type = /datum/sprite_accessory/clothing/earring/onyx

/datum/sprite_accessory/clothing/earring/dangle/onyx
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/onyx

/datum/sprite_accessory/clothing/earring/emerald
	abstract_type = /datum/sprite_accessory/clothing/earring/emerald

/datum/sprite_accessory/clothing/earring/dangle/emerald
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/emerald

/datum/sprite_accessory/clothing/earring/amber
	abstract_type = /datum/sprite_accessory/clothing/earring/amber

/datum/sprite_accessory/clothing/earring/dangle/amber
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/amber

/datum/sprite_accessory/clothing/earring/amethyst
	abstract_type = /datum/sprite_accessory/clothing/earring/amethyst

/datum/sprite_accessory/clothing/earring/dangle/amethyst
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/amethyst

/datum/sprite_accessory/clothing/earring/ruby
	abstract_type = /datum/sprite_accessory/clothing/earring/ruby

/datum/sprite_accessory/clothing/earring/dangle/ruby
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/ruby

/datum/sprite_accessory/clothing/earring/sapphire
	abstract_type = /datum/sprite_accessory/clothing/earring/sapphire

/datum/sprite_accessory/clothing/earring/dangle/sapphire
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/sapphire

/datum/sprite_accessory/clothing/earring/diamond
	abstract_type = /datum/sprite_accessory/clothing/earring/diamond

/datum/sprite_accessory/clothing/earring/dangle/diamond
	abstract_type = /datum/sprite_accessory/clothing/earring/dangle/diamond

/datum/sprite_accessory/clothing/earring/classic/silver
	abstract_type = /datum/sprite_accessory/clothing/earring/classic/silver

/datum/sprite_accessory/clothing/earring/classic/hoop/silver
	abstract_type = /datum/sprite_accessory/clothing/earring/classic/hoop/silver
