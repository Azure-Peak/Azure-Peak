// Regional or otherwise exclusive armor. NOT for Merc equipment (unless it is deemed so)
// Pricing Principles is based on vibes, but you don't want reskins worth /less/ than the originals.
// The Gronn stuff is all-in-one due to laziness, not as a standard.

/datum/supply_pack/rogue/armor_exotic
	group = "Armor (Exotic)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	derive_cost = TRUE
	no_name_quantity = TRUE

/datum/supply_pack/rogue/armor_exotic/gronn_pack_light
	name = "Gronnic Ravager Leather Set (Light)"
	cost = 125 // No recipe, hand priced
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn,
		/obj/item/clothing/under/roguetown/trou/leather/gronn,
		/obj/item/clothing/gloves/roguetown/angle/gronn
		)

/datum/supply_pack/rogue/armor_exotic/gronn_pack_medium
	name = "Gronnic Byrine Chain Set (Medium)"
	cost = 225 // No recipe, hand priced
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel,
		/obj/item/clothing/suit/roguetown/armor/brigandine/gronn,
		/obj/item/clothing/gloves/roguetown/chain/gronn,
		/obj/item/clothing/under/roguetown/chainlegs/gronn
		)

/datum/supply_pack/rogue/armor_exotic/gronn_pack_heavy
	name = "Gronnic Norsii Plate Set (Heavy)"
	cost = 400 // No recipe, hand priced
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn,
		/obj/item/clothing/suit/roguetown/armor/plate/iron/gronn,
		/obj/item/clothing/gloves/roguetown/plate/iron/gronn,
		/obj/item/clothing/under/roguetown/platelegs/iron/gronn,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
		)

/datum/supply_pack/rogue/armor_exotic/legacycuirass_steel
	name = "Valorian Cuirass, Steel"
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhalfplate_steel
	name = "Valorian Half-Plate, Steel"
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyfullplate_steel
	name = "Valorian Full-Plate, Steel"
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyfluteplate_steel
	name = "Valorian Fluted Full-Plate, Steel"
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy)

/datum/supply_pack/rogue/armor_exotic/legacycuirass_iron
	name = "Valorian Cuirass, Iron"
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhalfplate_iron
	name = "Valorian Half-Plate, Iron"
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/iron/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyfullplate_iron
	name = "Valorian Full-Plate, Iron"
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/iron/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_kettle_steel
	name = "Valorian Helmet, Kettle, Steel"
	contains = list(/obj/item/clothing/head/roguetown/helmet/kettle/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_sallet_steel
	name = "Valorian Helmet, Sallet, Steel"
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_sallet_visor_steel
	name = "Valorian Helmet, Sallet with Visor, Steel"
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_knight_helmet_steel
	name = "Valorian Helmet, Knight's Helmet, Steel"
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/old)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_kettle_iron
	name = "Valorian Helmet, Kettle, Iron"
	contains = list(/obj/item/clothing/head/roguetown/helmet/kettle/iron/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_sallet_iron
	name = "Valorian Helmet, Sallet, Iron"
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet/iron/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_sallet_visor_iron
	name = "Valorian Helmet, Sallet with Visor, Iron"
	contains = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhelmet_knight_helmet_iron
	name = "Valorian Helmet, Knight's Helmet, Iron"
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron)

