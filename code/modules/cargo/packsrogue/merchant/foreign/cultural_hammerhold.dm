/datum/supply_pack/rogue/hammerhold
	group = "Cultural Stock"
	crate_name = "Hammerhold crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/hammerhold/dwarven_maul
	name = "Dwarvish Maul"
	cost = 240
	contains = list(/obj/item/rogueweapon/mace/maul/steel)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/spiked_maul
	name = "Spiked Maul"
	cost = 260
	contains = list(/obj/item/rogueweapon/mace/maul/spiked)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/iron_fullplate
	name = "Hammerhold Iron Plate"
	cost = 380
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/iron)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/snow_cloak
	name = "Norwardine Forester Cloak"
	cost = 60
	contains = list(/obj/item/clothing/cloak/forrestercloak/snow)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/hammerhold/ironclad_kit
	name = "Hammerhold Ironclad Harness"
	no_name_quantity = TRUE
	cost = 410
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson,
		/obj/item/clothing/suit/roguetown/armor/plate/full/iron,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/iron,
		/obj/item/clothing/neck/roguetown/chaincoif/iron,
		/obj/item/clothing/gloves/roguetown/plate/iron,
		/obj/item/clothing/wrists/roguetown/bracers/splint,
		/obj/item/clothing/under/roguetown/platelegs/iron,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/smoked_sausage
	name = "Smoked Highland Sausage"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/hammerhold/bacon
	name = "Mountainhome Bacon"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
	)
	ship_qty_min = 2
	ship_qty_max = 5
