

/datum/supply_pack/rogue/luxury
	group = "Luxury"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/luxury/sigs
	name = "Pipe Weed Zig"
	cost = 3
	contains = list(/obj/item/clothing/mask/cigarette/rollie/nicotine)
	not_in_public = TRUE // go to the PURITY

/datum/supply_pack/rogue/luxury/ozium
	name = "Ozium"
	cost = 5
	contains = list(/obj/item/reagent_containers/powder/ozium)
	not_in_public = TRUE // ditto

/datum/supply_pack/rogue/luxury/moondust
	name = "Moon Dust"
	cost = 10
	contains = list(/obj/item/reagent_containers/powder/moondust)
	not_in_public = TRUE // ditto

/datum/supply_pack/rogue/luxury/spice
	name = "Spice"
	cost = 30
	contains = list(/obj/item/reagent_containers/powder/spice)
	not_in_public = TRUE // ditto

/datum/supply_pack/rogue/luxury/fancyteaset
	name = "Fancy Tea Set (1 Teapot, 4 Cups)"
	cost = 110
	no_name_quantity = TRUE
	contains = list(/obj/item/reagent_containers/glass/bucket/pot/teapot/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy,
	/obj/item/reagent_containers/glass/cup/ceramic/fancy)

/datum/supply_pack/rogue/luxury/silverpsicross
	name = "Silver Psycross"
	cost = 250
	contains = list(/obj/item/clothing/neck/roguetown/psicross/silver)

/datum/supply_pack/rogue/luxury/silverdagger
	name = "Silver Dagger"
	cost = 250 //Note that the Merchant's abode always spawns with a free silver dagger.
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/silver)

/datum/supply_pack/rogue/luxury/nomag
	name = "Ring of Null Magic"
	cost = 300
	contains = list(/obj/item/clothing/ring/active/nomag)

/datum/supply_pack/rogue/luxury/scrying
	name = "Scrying Orb"
	cost = 300
	contains = list(/obj/item/scrying)

/datum/supply_pack/rogue/luxury/listenst
	name = "Emerald Choker"
	cost = 250
	contains = list(/obj/item/listenstone)

/datum/supply_pack/rogue/luxury/polishing_kit
	name = "Polishing Kit"
	no_name_quantity = TRUE
	cost = 100
	contains = list(/obj/item/polishing_cream, /obj/item/armor_brush)

/datum/supply_pack/rogue/luxury/talkstone
	name = "Talkstone"
	cost = 100
	contains = list(/obj/item/clothing/neck/roguetown/talkstone)

/datum/supply_pack/rogue/luxury/circlet
	name = "Circlet"
	cost = 80
	contains = list(/obj/item/clothing/head/roguetown/circlet)

/datum/supply_pack/rogue/luxury/goldring
	name = "Gold Ring"
	cost = 70
	contains = list(/obj/item/clothing/ring/gold)

/datum/supply_pack/rogue/luxury/signet
	name = "Signet"
	cost = 220
	contains = list(/obj/item/clothing/ring/signet)

/datum/supply_pack/rogue/luxury/obsidianfragment
	name = "Obsidian Fragments"
	cost = 55
	contains = list(
			/obj/item/magic/obsidian,
			/obj/item/magic/obsidian,
			/obj/item/magic/obsidian,
			)

/datum/supply_pack/rogue/luxury/manaflower
	name = "Manabloom Flowers"
	cost = 55
	contains = list(
			/obj/item/reagent_containers/food/snacks/grown/manabloom,
			/obj/item/reagent_containers/food/snacks/grown/manabloom,
			/obj/item/reagent_containers/food/snacks/grown/manabloom,
			)

/datum/supply_pack/rogue/luxury/manacrystal
	name = "Mana Crystals"
	cost = 55
	contains = list(
			/obj/item/magic/manacrystal,
			/obj/item/magic/manacrystal,
			/obj/item/magic/manacrystal,
			)

/datum/supply_pack/rogue/luxury/merctoken
	name = "Writ of Commendation"
	cost = 80
	contains = list(/obj/item/merctoken)

/datum/supply_pack/rogue/luxury/canvas
	name = "Canvas"
	cost = 30
	contains = list(/obj/item/canvas)

/datum/supply_pack/rogue/luxury/easel
	name = "Easel"
	cost = 80
	contains = list(/obj/structure/easel)

/datum/supply_pack/rogue/luxury/paintbrush
	name = "Paint brush"
	cost = 15
	contains = list(/obj/item/paint_brush)

/datum/supply_pack/rogue/luxury/paintpalette
	name = "Paint palette"
	cost = 15
	contains = list(/obj/item/paint_palette)

/datum/supply_pack/rogue/luxury/parasol
	name = "Paper Parasol"
	cost = 30
	contains = list(/obj/item/rogueweapon/mace/parasol)

/datum/supply_pack/rogue/luxury/fineparasol
	name = "Fine Parasol"
	cost = 65
	contains = list(/obj/item/rogueweapon/mace/parasol/noble)
