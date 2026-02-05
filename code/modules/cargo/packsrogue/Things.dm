
/datum/supply_pack/rogue/Things
	group = "Things"
	crate_name = "Gifts of Things"
	crate_type = /obj/structure/closet/crate/chest/merchant

//////////////
// SUPPLIES //
//////////////

/datum/supply_pack/rogue/Things/cloth
	name = "Cloth"
	cost = 2
	contains = list(/obj/item/natural/cloth)

/datum/supply_pack/rogue/Things/chain
	name = "Chain"
	cost = 5
	contains = list(/obj/item/rope/chain)

/datum/supply_pack/rogue/Things/Lamp
	name = "Lamptern"
	cost = 5
	contains = list(/obj/item/flashlight/flare/torch/lantern)

/datum/supply_pack/rogue/Things/hknife
	name = "Hunting Knife"
	cost = 5
	contains = list(/obj/item/rogueweapon/huntingknife)

/datum/supply_pack/rogue/Things/Waterskin
	name = "Waterskin"
	cost = 10
	contains = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/supply_pack/rogue/Things/needle
	name = "Needle"
	cost = 5
	contains = list(/obj/item/needle)

/datum/supply_pack/rogue/Things/bandages
	name = "Bundle of Bandages"
	cost = 15
	contains = list(/obj/item/natural/bundle/cloth/bandage/full)

/////////////
// POTIONS //
/////////////

/datum/supply_pack/rogue/Things/healthpot
	name = "Health Potion - Weak"
	cost = 20
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew)

/datum/supply_pack/rogue/Things/healthpotstrong
	name = "Health Potion - Strong"
	cost = 40 //Probably fine?
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew)

/datum/supply_pack/rogue/Things/manapot
	name = "Mana Potion - Weak"
	cost = 30
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/manapot)

/datum/supply_pack/rogue/Things/manapotstrong
	name = "Mana Potion - Strong"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot)

/datum/supply_pack/rogue/Things/stampot
	name = "Stamina Potion - Weak"
	cost = 30
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/stampot)

/datum/supply_pack/rogue/Things/stampotstrong
	name = "Stamina Potion - Strong"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/strongstampot)

///////////
// DRUGS //
///////////

/datum/supply_pack/rogue/Things/westleach
	name = "Westleach Zig"
	cost = 5
	contains = list(/obj/item/clothing/mask/cigarette/rollie/nicotine)

/datum/supply_pack/rogue/Things/swampweed
	name = "Swampweed Zig"
	cost = 10
	contains = list(/obj/item/clothing/mask/cigarette/rollie/cannabis)

/datum/supply_pack/rogue/Things/ozium
	name = "Ozium"
	cost = 25
	contains = list(/obj/item/reagent_containers/powder/ozium)

/datum/supply_pack/rogue/Things/moondust
	name = "Moon Dust"
	cost = 40
	contains = list(/obj/item/reagent_containers/powder/moondust)

/datum/supply_pack/rogue/Things/spice
	name = "Spice"
	cost = 40
	contains = list(/obj/item/reagent_containers/powder/spice)

/////////////
// STORAGE //
/////////////

/datum/supply_pack/rogue/Things/scabbard_knife
	name = "Dagger Sheath"
	cost = 15
	contains = list(/obj/item/rogueweapon/scabbard/sheath)

/datum/supply_pack/rogue/Things/scabbard_sword
	name = "Scabbard"
	cost = 15
	contains = list(/obj/item/rogueweapon/scabbard)

/datum/supply_pack/rogue/Things/gwstrap
	name = "Greatweapon Strap"
	cost = 15
	contains = list(/obj/item/rogueweapon/scabbard/gwstrap)

/datum/supply_pack/rogue/Things/satchel
	name = "Satchel"
	cost = 25
	contains = list(/obj/item/storage/backpack/rogue/satchel)

/datum/supply_pack/rogue/Things/backpack
	name = "Backpack"
	cost = 30
	contains = list(/obj/item/storage/backpack/rogue/backpack)

/datum/supply_pack/rogue/Things/belt
	name = "Leather Belt"
	cost = 10
	contains = list(/obj/item/storage/belt/rogue/leather)

/////////////
// UTILITY //
/////////////

/datum/supply_pack/rogue/Things/rubyband
	name = "Matthiosian SCOMSTONE" //What is a MATTHIAN????
	cost = 20
	contains = list(/obj/item/mattcoin)

/datum/supply_pack/rogue/Things/Dragonscale
	name = "Dragonscale Necklace"
	cost = 900
	contains = list(/obj/item/clothing/neck/roguetown/blkknight)

/datum/supply_pack/rogue/Things/smokebomb
	name = "Smoke Bomb"
	cost = 30
	contains = list(/obj/item/bomb/smoke)

/datum/supply_pack/rogue/Things/clotchkit
	name = "Sewing Kit"
	cost = 30
	contains = list(/obj/item/repair_kit)

/datum/supply_pack/rogue/Things/metalkit
	name = "Armor Plate"
	cost = 50
	contains = list(/obj/item/repair_kit/metal)

//////////
// FOOD //
//////////

/datum/supply_pack/rogue/Things/hardtack
	name = "Hardtack"
	cost = 10
	contains = list(/obj/item/reagent_containers/food/snacks/rogue/crackerscooked)

/datum/supply_pack/rogue/Things/coppiette
	name = "Coppiette"
	cost = 20
	contains = list(/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette)
