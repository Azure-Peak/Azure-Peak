/datum/supply_pack/rogue/tools
	group = "Tools"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/tools/spade
	name = "Wooden Spade"
	cost = 5
	contains = list(/obj/item/rogueweapon/shovel/small)

/datum/supply_pack/rogue/tools/shovel
	name = "Shovel"
	cost = 20
	contains = list(/obj/item/rogueweapon/shovel)

/datum/supply_pack/rogue/tools/hoe
	name = "Hoe"
	cost = 10
	contains = list(/obj/item/rogueweapon/hoe)

/datum/supply_pack/rogue/tools/thresher
	name = "Thresher"
	cost = 10
	contains = list(/obj/item/rogueweapon/thresher)

/datum/supply_pack/rogue/tools/sickle
	name = "Sickle"
	cost = 10
	contains = list(/obj/item/rogueweapon/sickle)

/datum/supply_pack/rogue/tools/pfork
	name = "Pitchfork"
	cost = 10
	contains = list(/obj/item/rogueweapon/pitchfork)

/datum/supply_pack/rogue/tools/scythe
	name = "Scythe"
	cost = 25
	contains = list(/obj/item/rogueweapon/scythe)

/datum/supply_pack/rogue/tools/plough
	name = "Plough"
	cost = 50
	contains = list(/obj/structure/plough)

/datum/supply_pack/rogue/tools/handsaw
	name = "Handsaw"
	cost = 35
	contains = list(/obj/item/rogueweapon/handsaw)

/datum/supply_pack/rogue/tools/hammer
	name = "Hammer"
	cost = 35
	contains = list(/obj/item/rogueweapon/hammer/iron)

/datum/supply_pack/rogue/tools/tongs
	name = "Tongs"
	cost = 35
	contains = list(/obj/item/rogueweapon/tongs)

/datum/supply_pack/rogue/tools/metalkit
	name = "Steel Armor Plates"
	cost = 60 // 1 Steel 0.5 iron 1 leather
	contains = list(/obj/item/repair_kit/metal)

/datum/supply_pack/rogue/tools/ironpick
	name = "Iron Pickaxe"
	cost = 10
	contains = list(/obj/item/rogueweapon/pick)

/datum/supply_pack/rogue/tools/chisel
	name = "Chisel"
	cost = 10
	contains = list(/obj/item/rogueweapon/chisel)

/datum/supply_pack/rogue/tools/huntingknife
	name = "Hunting Knife"
	cost = 10
	contains = list(/obj/item/rogueweapon/huntingknife)

/datum/supply_pack/rogue/tools/scissors
	name = "Scissors, Iron"
	cost = 30
	contains = list(/obj/item/rogueweapon/huntingknife/scissors)

/datum/supply_pack/rogue/tools/surgeonsbag
	name = "Surgeon's bag, Full"
	cost = 80
	contains = list(/obj/item/storage/belt/rogue/surgery_bag)

/datum/supply_pack/rogue/tools/soapps
	name = "Soap"
	cost = 10
	contains = list(/obj/item/soap)

/datum/supply_pack/rogue/tools/herbsoap
	name = "Herbal Soap"
	cost = 20
	contains = list(/obj/item/soap/bath)

/datum/supply_pack/rogue/tools/fryingpan
	name = "Frying Pan"
	cost = 20
	contains = list(/obj/item/cooking/pan)

/datum/supply_pack/rogue/tools/bottle_kit
	name = "Bottle Kit"
	cost = 50
	contains = list(/obj/item/bottle_kit)

/datum/supply_pack/rogue/tools/flint
	name = "Flint"
	cost = 15
	contains = list(
					/obj/item/flint,
					/obj/item/flint,
					/obj/item/flint,
				)

/datum/supply_pack/rogue/tools/lockpicks
	name = "Lockpicks"
	cost = 20
	contains = list(/obj/item/lockpickring/mundane)

/datum/supply_pack/rogue/tools/chains
	name = "Chains"
	cost = 15
	contains = list(
					/obj/item/rope/chain,
					/obj/item/rope/chain,
					/obj/item/rope/chain,
				)

/datum/supply_pack/rogue/tools/sacks
	name = "Sacks"
	cost = 10
	contains = list(
					/obj/item/storage/roguebag,
					/obj/item/storage/roguebag,
					/obj/item/storage/roguebag,
				)

/datum/supply_pack/rogue/tools/paper
	name = "Paper"
	cost = 20
	contains = list(
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
				)

/datum/supply_pack/rogue/tools/pipes
	name = "Pipe"
	cost = 15
	contains = list(
					/obj/item/clothing/mask/cigarette/pipe,
					/obj/item/clothing/mask/cigarette/pipe,
					/obj/item/clothing/mask/cigarette/pipe/westman
				)

/datum/supply_pack/rogue/tools/bait
	name = "Premium Fishing Bait"
	cost = 15
	contains = list(
					/obj/item/natural/worms/grubs,
					/obj/item/natural/worms/grubs,
					/obj/item/natural/worms/leech,
					/obj/item/natural/worms/leech,
					/obj/item/natural/worms/leech,
				)


/datum/supply_pack/rogue/tools/bottl
	name = "Glass Bottles"
	cost = 15
	contains = list(
					/obj/item/reagent_containers/glass/bottle/rogue,
					/obj/item/reagent_containers/glass/bottle/rogue,
					/obj/item/reagent_containers/glass/bottle/rogue,
				)

/datum/supply_pack/rogue/tools/alch_bottle
	name = "Alchemy Bottle"
	cost = 1
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical,)

/datum/supply_pack/rogue/tools/alch_bottles
	name = "Bulk Alchemy Bottles" //Buy 8 now get 1 free!
	cost = 8
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,
	/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,
	/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical)

/datum/supply_pack/rogue/tools/headhook
	name = "Iron Head Hook"
	cost = 10
	contains = list(/obj/item/storage/hip/headhook)

/datum/supply_pack/rogue/tools/keyrings
	name = "Keyrings"
	cost = 20
	contains = list(/obj/item/storage/keyring,
					/obj/item/storage/keyring,
					/obj/item/storage/keyring)

/datum/supply_pack/rogue/tools/shopkeyy
	name = "Spare Shopkey"
	cost = 10
	not_in_public = TRUE
	contains = list(/obj/item/roguekey/shop)

/datum/supply_pack/rogue/tools/serfst
	name = "Serfstone"
	cost = 40
	contains = list(/obj/item/scomstone/bad)

/datum/supply_pack/rogue/tools/scomst
	name = "Scomstone"
	cost = 120
	contains = list(/obj/item/scomstone)

/datum/supply_pack/rogue/tools/prarml
	name = "Prosthetic Wood Arm (L)"
	cost = 40
	contains = list(/obj/item/bodypart/l_arm/prosthetic/woodleft)

/datum/supply_pack/rogue/tools/prarmr
	name = "Prosthetic Wood Arm (R)"
	cost = 40
	contains = list(/obj/item/bodypart/r_arm/prosthetic/woodright)

/datum/supply_pack/rogue/tools/prlegl
	name = "Prosthetic Wood Leg (L)"
	cost = 15
	contains = list(/obj/item/bodypart/l_leg/prosthetic)

/datum/supply_pack/rogue/tools/prlegr
	name = "Prosthetic Wood Leg (R)"
	cost = 15
	contains = list(/obj/item/bodypart/r_leg/prosthetic)
