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

/datum/supply_pack/rogue/adventure_supplies/folding_alchstation
	name = "alchemical station kit"
	cost = 45
	contains = list(/obj/item/folding_alchstation_stored)

/datum/supply_pack/rogue/adventure_supplies/folding_alchcauldron
	name = "folding cauldron"
	cost = 45
	contains = list(/obj/item/folding_alchcauldron_stored)

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
