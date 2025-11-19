// Adventuring Supplies. General category for random stuffs useful for adventurers
// Like container, bedrolls etc.

/datum/supply_pack/rogue/adventure_supplies
	group = "Adventuring Supplies"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/adventure_supplies/bedroll
	name = "Bedroll"
	cost = 13
	contains = list(/obj/item/bedroll)

/datum/supply_pack/rogue/adventure_supplies/waterskin
	name = "Waterskin"
	cost = 13
	contains = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/supply_pack/rogue/adventure_supplies/satchel
	name = "Satchel"
	cost = 13
	contains = list(/obj/item/storage/backpack/rogue/satchel)

/datum/supply_pack/rogue/adventure_supplies/shortsatchel
	name = "Satchel, Short"
	cost = 13
	contains = list(/obj/item/storage/backpack/rogue/satchel/short)

/datum/supply_pack/rogue/adventure_supplies/backpack
	name = "Backpack"
	cost = 18
	contains = list(/obj/item/storage/backpack/rogue/backpack)

/datum/supply_pack/rogue/adventure_supplies/pouches
	name = "Pouch"
	cost = 8
	contains = list(
					/obj/item/storage/belt/rogue/pouch,
					/obj/item/storage/belt/rogue/pouch,
					/obj/item/storage/belt/rogue/pouch)

/datum/supply_pack/rogue/adventure_supplies/belts
	name = "Belt"
	cost = 14
	contains = list(
					/obj/item/storage/belt/rogue/leather,
					/obj/item/storage/belt/rogue/leather,
					/obj/item/storage/belt/rogue/leather,
				)

/datum/supply_pack/rogue/adventure_supplies/sheath
	name = "Sheath"
	cost = 12
	contains = list(
					/obj/item/rogueweapon/scabbard/sheath
				)

/datum/supply_pack/rogue/adventure_supplies/scabbard
	name = "Scabbard"
	cost = 15
	contains = list(
					/obj/item/rogueweapon/scabbard/sword
				)

/datum/supply_pack/rogue/adventure_supplies/ropes
	name = "Ropes"
	cost = 10
	contains = list(
					/obj/item/rope,
					/obj/item/rope,
					/obj/item/rope,
				)

/datum/supply_pack/rogue/adventure_supplies/woodstaff
	name = "Six Foot Pole"
	cost = 6
	contains = list(/obj/item/rogueweapon/woodstaff)

/datum/supply_pack/rogue/adventure_supplies/lamptern
	name = "Lamptern"
	cost = 15
	contains = list(/obj/item/flashlight/flare/torch/lantern)

/datum/supply_pack/rogue/adventure_supplies/folding_table
	name = "Folding Table"
	cost = 35
	contains = list(/obj/item/folding_table_stored)

/datum/supply_pack/rogue/adventure_supplies/mess_kit
	name = "Mess Kit"
	cost = 60
	contains = list(/obj/item/storage/gadget/messkit)

/datum/supply_pack/rogue/adventure_supplies/needles
	name = "Needles"
	cost = 15
	contains = list(/obj/item/needle,
					/obj/item/needle,
					/obj/item/needle)

/datum/supply_pack/rogue/adventure_supplies/rationpaper
	name = "Ration Papers"
	cost = 20
	contains = list(
					/obj/item/ration,
					/obj/item/ration,
				)
