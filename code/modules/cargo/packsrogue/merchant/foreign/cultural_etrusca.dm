/datum/supply_pack/rogue/etrusca
	group = "Cultural Stock"
	crate_name = "Etrusca crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/etrusca/falchion
	name = "Falchion"
	cost = 90
	contains = list(/obj/item/rogueweapon/sword/short/falchion)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/etrusca/crossbow
	name = "Etruscan Crossbow"
	cost = 50
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/etrusca/heavy_bolts
	name = "Quiver of Bolts"
	cost = 35
	contains = list(/obj/item/quiver/bolt/standard)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/etrusca/pike
	name = "Condottieri Boat Spear"
	cost = 90
	contains = list(/obj/item/rogueweapon/spear/boar)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/etrusca/etruscan_bascinet
	name = "Etruscan Bascinet"
	cost = 130
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/etrusca/condottieri_kit
	name = "Condottieri Pikeman Harness"
	no_name_quantity = TRUE
	cost = 380
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		/obj/item/clothing/suit/roguetown/armor/brigandine,
		/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		/obj/item/clothing/gloves/roguetown/plate,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/etrusca/vaquero_kit
	name = "Vaquero Outrider Kit"
	no_name_quantity = TRUE
	cost = 220
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/leather/studded,
		/obj/item/clothing/head/roguetown/helmet/skullcap,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/shoes/roguetown/boots/leather,
	)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/etrusca/jamon
	name = "Cured Ham (Jamón)"
	cost = 45
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/ham,
		/obj/item/reagent_containers/food/snacks/rogue/meat/ham,
		/obj/item/reagent_containers/food/snacks/rogue/meat/ham,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/etrusca/coppiette
	name = "Etruscan Coppiette"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
	)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/etrusca/salami
	name = "Velasca Salami"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
	)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/etrusca/cheese
	name = "Montecarina Cheese Wheel"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/etrusca/vaquero_ring
	name = "Vaquero's Ring"
	cost = 150
	contains = list(/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/vaquero)
	ship_qty_min = 1
	ship_qty_max = 1
