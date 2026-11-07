// Adventuring Supplies. General category for random stuffs useful for adventurers
// Like container, bedrolls etc.

/datum/supply_pack/rogue/adventure_supplies
	group = "Adventuring Supplies"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	derive_cost = TRUE

/datum/supply_pack/rogue/adventure_supplies/bedroll
	name = "Bedroll"
	contains = list(/obj/item/bedroll)

/datum/supply_pack/rogue/adventure_supplies/waterskin
	name = "Waterskin"
	contains = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/supply_pack/rogue/adventure_supplies/ropes
	name = "Ropes"
	contains = list(
					/obj/item/rope,
					/obj/item/rope,
					/obj/item/rope,
				)

/datum/supply_pack/rogue/adventure_supplies/woodstaff
	name = "Six Foot Pole"
	cost = 6 // No recipe, hand priced
	contains = list(/obj/item/rogueweapon/woodstaff)

/datum/supply_pack/rogue/adventure_supplies/lamptern
	name = "Iron Lamptern"
	contains = list(/obj/item/flashlight/flare/torch/lantern)

/datum/supply_pack/rogue/adventure_supplies/folding_table
	name = "Folding Table"
	contains = list(/obj/item/folding_table_stored)

/datum/supply_pack/rogue/adventure_supplies/folding_alchstation
	name = "Alchemical Station Kit"
	contains = list(/obj/item/folding_alchstation_stored)

/datum/supply_pack/rogue/adventure_supplies/folding_alchcauldron
	name = "Folding Cauldron"
	contains = list(/obj/item/folding_alchcauldron_stored)

/datum/supply_pack/rogue/adventure_supplies/mess_kit
	name = "Mess Kit"
	contains = list(/obj/item/storage/gadget/messkit)

/datum/supply_pack/rogue/adventure_supplies/needles
	name = "Needles"
	contains = list(/obj/item/needle,
					/obj/item/needle,
					/obj/item/needle)

/datum/supply_pack/rogue/adventure_supplies/rationpaper
	name = "Ration Wrapping Paper"
	cost = 20 // Paper unpriced, hand priced
	contains = list(
					/obj/item/ration,
					/obj/item/ration,
				)

/datum/supply_pack/rogue/adventure_supplies/bandages
	name = "Roll of bandages"
	cost = 25 // No recipe, hand priced
	contains = list(/obj/item/natural/bundle/cloth/bandage/full)

/datum/supply_pack/rogue/adventure_supplies/small_tent
	name = "Small Tent Kit"
	contains = list(/obj/item/tent_kit)

/datum/supply_pack/rogue/adventure_supplies/ger
	name = "Ger Kit"
	contains = list(/obj/item/tent_kit/ger)

/datum/supply_pack/rogue/adventure_supplies/yurt
	name = "Yurt Kit"
	contains = list(/obj/item/tent_kit/yurt)

/datum/supply_pack/rogue/adventure_supplies/grapplinghook
	name = "Grappling Hook"
	cost = 320
	derive_cost = FALSE
	contains = list(/obj/item/grapplinghook)
