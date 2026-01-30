// Regional or otherwise exclusive armor. NOT for Merc equipment (unless it is deemed so)
// Pricing Principles is based on vibes, but you don't want reskins worth /less/ than the originals.
// The Gronn stuff is all-in-one due to laziness, not as a standard.

/datum/supply_pack/rogue/armor_exotic
	group = "Armor (Exotic)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	no_name_quantity = TRUE

/datum/supply_pack/rogue/armor_exotic/gronn_pack_light
	name = "Gronnic Ravager Leather Set (Light)"
	cost = 125
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn,
		/obj/item/clothing/under/roguetown/trou/leather/gronn,
		/obj/item/clothing/gloves/roguetown/angle/gronn
		)

/datum/supply_pack/rogue/armor_exotic/gronn_pack_medium
	name = "Gronnic Byrine Chain Set (Medium)"
	cost = 225
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel,
		/obj/item/clothing/suit/roguetown/armor/brigandine/gronn,
		/obj/item/clothing/gloves/roguetown/chain/gronn,
		/obj/item/clothing/under/roguetown/splintlegs/iron/gronn
		)

/datum/supply_pack/rogue/armor_exotic/gronn_pack_heavy
	name = "Gronnic Norsii Plate Set (Heavy)"
	cost = 400
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn,
		/obj/item/clothing/suit/roguetown/armor/plate/iron/gronn,
		/obj/item/clothing/gloves/roguetown/plate/iron/gronn,
		/obj/item/clothing/under/roguetown/platelegs/iron/gronn,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
		)

/datum/supply_pack/rogue/armor_exotic/legacycuirass_steel
	name = "Valorian Cuirass, Steel"
	cost = 90
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyhalfplate_steel
	name = "Valorian Half-Plate, Steel"
	cost = 130
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyfullplate_steel
	name = "Valorian Full-Plate, Steel"
	cost = 350
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/legacy)

/datum/supply_pack/rogue/armor_exotic/legacyfluteplate_steel
	name = "Valorian Fluted Full-Plate, Steel"
	cost = 380
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy)
