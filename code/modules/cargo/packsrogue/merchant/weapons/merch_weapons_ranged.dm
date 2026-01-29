/datum/supply_pack/rogue/ranged_weapons
	group = "Weapons (Ranged)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/ranged_weapons/tossbladeiron
	name = "Tossblade Belt, Iron"
	cost = 25
	contains = list(/obj/item/storage/belt/rogue/leather/knifebelt/black/iron)

/datum/supply_pack/rogue/ranged_weapons/tossbladesteel
	name = "Tossblade Belt, Steel"
	cost = 45
	contains = list(/obj/item/storage/belt/rogue/leather/knifebelt/black/steel)

/datum/supply_pack/rogue/ranged_weapons/javeliniron
	name = "Javelins, Iron"
	cost = 40 // 2 Iron Ingots
	contains = list(/obj/item/quiver/javelin/iron)

/datum/supply_pack/rogue/ranged_weapons/javelinsteel
	name = "Javelins, Steel"
	cost = 80 // 2 Steel Ingots + Small Log
	contains = list(/obj/item/quiver/javelin/steel)

/datum/supply_pack/rogue/ranged_weapons/hurlbat
	name = "Hurlbat"
	cost = 50 // 1 Steel Ingot, but a pretty strong weapon. 
	contains = list(/obj/item/rogueweapon/stoneaxe/hurlbat)

/datum/supply_pack/rogue/ranged_weapons/crossbow
	name = "Crossbow"
	cost = 30
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
				)

/datum/supply_pack/rogue/ranged_weapons/crossbow/slurbow
	name = "Slurbow"
	cost = 30
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow,
				)

/datum/supply_pack/rogue/ranged_weapons/recurvebow
	name = "Bow, Recurve"
	cost = 20
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
				)

/datum/supply_pack/rogue/ranged_weapons/longbow
	name = "Bow, Longbow"
	cost = 45
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow,
				)

/datum/supply_pack/rogue/ranged_weapons/quiver
	name = "Quiver"
	cost = 5
	contains = list(
					/obj/item/quiver,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/arrows
	name = "Quiver of Arrows"
	cost = 35 // 2 Iron Ingots
	contains = list(
					/obj/item/quiver/arrows,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/barrows
	name = "Quiver of Bodkin Arrows"
	cost = 100 // 2 Steel Ingots + Sticks
	contains = list(
					/obj/item/quiver/bodkin,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/pyroarrows
	name = "Quiver of Pyro Arrows"
	cost = 100
	contains = list(
					/obj/item/quiver/pyroarrows,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/poisonarrows
	name = "Quiver of Poison Arrows"
	cost = 100 
	contains = list(
					/obj/item/quiver/poisonarrows,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/bolts
	name = "Quiver of Bolts"
	cost = 35 // 2 Iron Ingots
	contains = list(
					/obj/item/quiver/bolts,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/pyrobolts
	name = "Quiver of Pyroclastic Bolts"
	cost = 100 // Matching price of steel
	contains = list(
					/obj/item/quiver/pyrobolts,
				)

/datum/supply_pack/rogue/ranged_weapons/slingandpouch
	name = "Sling and Pouch"
	cost = 15
	no_name_quantity = TRUE
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/sling,
					/obj/item/quiver/sling,
				)

/datum/supply_pack/rogue/ranged_weapons/slingiron
	name = "Sling Bullets Pouch, Iron"
	cost = 35 // 2 Iron Ingots
	contains = list(
					/obj/item/quiver/sling/iron,
				)

/datum/supply_pack/rogue/ranged_weapons/net
	name = "Net"
	cost = 20
	contains = list(
					/obj/item/net,
				)
