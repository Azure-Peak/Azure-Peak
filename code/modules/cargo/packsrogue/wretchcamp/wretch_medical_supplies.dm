// Wretch Potions. Wretch potions are meant to be relatively cost semi-effective, normal potion brewers will always exceed when you can grab from the shop here.
// This also includes medical supplies, the general idea is more "to kit you out to last" instead of to kit you out to frag, which bandits fill that niché.
// So for the love of all that is unholy, please do not give them strong potions ever, period. They do not need that shit and I can 100% assure you that.
// This is enough to survive as soon as you walk outside of camp or to top up your way of not immedately bleeding the fuck out dead, maybe a way to escape being near no-blue bar stamcrit once or twice.

// None of this should clutch you in a hyperwar sized fight, solo. It should let you escape and maybe survive your wounds, or keep others alive. It should help your recovery but literally end at that.
// Keep all of this public, its accessed via a goldface sire.
/datum/supply_pack/rogue/medical_supplies_wretch
	group = "Illict Medical Supplies"
	crate_name = "suspicious crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

//Actual Medical Supplies (Vs bandits, its more expensive)

/datum/supply_pack/rogue/medical_supplies_wretch/chain
	name = "Chain"
	cost = 25
	contains = list(/obj/item/rope/chain)

/datum/supply_pack/rogue/medical_supplies_wretch/Lamp
	name = "Lamptern"
	cost = 10
	contains = list(/obj/item/flashlight/flare/torch/lantern)

/datum/supply_pack/rogue/medical_supplies_wretch/Waterskin
	name = "Waterskin"
	cost = 20
	contains = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/supply_pack/rogue/medical_supplies_wretch/needle
	name = "Needle"
	cost = 15
	contains = list(/obj/item/needle)

/datum/supply_pack/rogue/medical_supplies_wretch/bandages
	name = "Bundle of Bandages"
	cost = 25
	contains = list(/obj/item/natural/bundle/cloth/bandage/full)

/datum/supply_pack/rogue/medical_supplies_wretch/heartsblood
	name = "Filled Heartsblood canister"
	cost = 20
	contains = list(/obj/item/heart_blood_canister/filled)

//Only one since that's 2 uses total; two sips each a bottle. You only need one sip for cure.
/datum/supply_pack/rogue/medical_supplies_wretch/rotcure
	name = "Rot Cure Potion"
	cost = 100 //Far cheaper because so few roles can revive + Its fewer
	contains = list(
					/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure,
				)

/datum/supply_pack/rogue/medical_supplies_wretch/healthpot
	name = "Healing Potion"
	cost = 20
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot)

/datum/supply_pack/rogue/medical_supplies_wretch/manapot
	name = "Mana Potion"
	cost = 20
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/manapot)

/datum/supply_pack/rogue/medical_supplies_wretch/stamina
	name = "Stamina Potion"
	cost = 30 //More expensive than regular stores because vamps exist
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/stampot)

/datum/supply_pack/rogue/medical_supplies_wretch/antidote
	name = "Poison Antidote"
	cost = 15
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/antidote)

/datum/supply_pack/rogue/medical_supplies_wretch/runicflask
	name = "Runic Tincture Flask"
	cost = 80
	contains = list(/obj/item/runicflask/charged)

//Regular drugs

/datum/supply_pack/rogue/medical_supplies_wretch/ozium
	name = "Ozium"
	cost = 5
	contains = list(/obj/item/reagent_containers/powder/ozium)

/datum/supply_pack/rogue/medical_supplies_wretch/moondust
	name = "Moon Dust"
	cost = 10
	contains = list(/obj/item/reagent_containers/powder/moondust)

/datum/supply_pack/rogue/medical_supplies_wretch/pdust
	name = "Purified Moondust"
	cost = 30
	contains = list(/obj/item/reagent_containers/powder/moondust_purest)

/datum/supply_pack/rogue/medical_supplies_wretch/spice
	name = "Spice"
	cost = 20
	contains = list(/obj/item/reagent_containers/powder/spice)

//Liquors

/datum/supply_pack/rogue/medical_supplies_wretch/murkwine
	name = "Murkwine"
	cost = 30
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/beer/murkwine)

/datum/supply_pack/rogue/medical_supplies_wretch/nocshine
	name = "Nocshine"
	cost = 40
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/beer/nocshine)

/datum/supply_pack/rogue/medical_supplies_wretch/whipwine
	name = "Magickal Whip-Wine"
	cost = 30
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/beer/whipwine)

//Zigs

/datum/supply_pack/rogue/medical_supplies_wretch/zigbox
	name = "Zigbox (Empty)"
	cost = 5
	contains = list(/obj/item/storage/belt/rogue/pouch/zigarrete)

/datum/supply_pack/rogue/medical_supplies_wretch/zigbox_pipezig
	name = "Zigbox (Pipeweed)"
	cost = 25
	contains = list(/obj/item/storage/belt/rogue/pouch/zigarrete/nicotine)

/datum/supply_pack/rogue/medical_supplies_wretch/zigbox_swampzig
	name = "Zigbox (Swampweed)"
	cost = 55
	contains = list(/obj/item/storage/belt/rogue/pouch/zigarrete/cannabis)

/datum/supply_pack/rogue/medical_supplies_wretch/zigdolier
	name = "Zigdolier (Empty)"
	cost = 35
	contains = list(/obj/item/storage/belt/rogue/leather/zig_bandolier)

//I know what you are

/datum/supply_pack/rogue/medical_supplies_wretch/fermented_crab
	name = "Fermented Crab"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab)

//Controversal supplies/major contraband:

/datum/supply_pack/rogue/medical_supplies_wretch/herozium
	name = "Herozium"
	cost = 100 //Extortionately high, go ask the bath matron
	contains = list(/obj/item/reagent_containers/powder/herozium)

/datum/supply_pack/rogue/medical_supplies_wretch/starsugar
	name = "Starsugar"
	cost = 100 //Extortionately high, go ask the bath matron
	contains = list(/obj/item/reagent_containers/powder/starsugar)
	contraband = TRUE
