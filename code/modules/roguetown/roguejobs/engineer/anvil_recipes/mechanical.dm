/datum/anvil_recipe/engineering
	i_type = "Engineering"
	appro_skill = /datum/skill/craft/engineering
	craftdiff = 1
	
//--------- TIN RECIPES -----------

/datum/anvil_recipe/engineering/nails
	name = "5x nails"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/construction/nail
	createditem_num = 5
	craftdiff = 1

// --------- IRON RECIPES -----------

/datum/anvil_recipe/engineering/jingle_bells
	name = "Jingling Bells"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/jingle_bells
	createditem_num = 5
	craftdiff = 1

/datum/anvil_recipe/engineering/flint
	name = "Flint (x3) (+1 stone)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/stone)
	created_item = /obj/item/flint
	createditem_num = 4
	craftdiff = 0

/datum/anvil_recipe/engineering/mess_kit
	name = "Mess Kit (+2 Iron)" // 3 Iron, cuz you get a pot, a pan and other things for free.
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/storage/gadget/messkit
	createditem_num = 1
	craftdiff = 2

//Lockpicks and rings moved from blacksmithing, to fit with locks being engineered
/datum/anvil_recipe/engineering/lockpicks
	name = "Lockpick (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/lockpick
	createditem_num = 3
	craftdiff = 2

/datum/anvil_recipe/engineering/lockpickring
	name = "Lockpickring (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/lockpickring
	createditem_num = 3
	craftdiff = 0

/datum/anvil_recipe/engineering/chains
	name = "Chains"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rope/chain
	createditem_num = 1
	craftdiff = 0

/datum/anvil_recipe/engineering/ironscissors
	name = "Iron Scissors (+1 cog)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegear)
	created_item = /obj/item/rogueweapon/huntingknife/scissors
	i_type = "Tools"

// --------- STEEL RECIPES -----------

/datum/anvil_recipe/engineering/steelscissors
	name = "steel Scissors (+1 cog)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear)
	created_item = /obj/item/rogueweapon/huntingknife/scissors/steel
	i_type = "Tools"


// --------- BRONZE RECIPES -----------

/datum/anvil_recipe/engineering/bronze/locks
	name = "Lock (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/customlock
	createditem_num = 2
	craftdiff = 1

/datum/anvil_recipe/engineering/bronze/keys
	name = "Key (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/customblank
	createditem_num = 2
	craftdiff = 1

/datum/anvil_recipe/engineering/bronze/wrench
	name = "Engineering Wrench (+1 cog)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/contraption/linker
	additional_items = list(/obj/item/roguegear)
	createditem_num = 1
	craftdiff = 0

/datum/anvil_recipe/engineering/bronze/cog
	name = "Cog (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/roguegear
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/engineering/folding_table
	name = "Folding Table (+1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/folding_table_stored
	craftdiff = 1

/datum/anvil_recipe/engineering/folding_alchcauldron
	name = "Folding Cauldron (+1 Small Log, +Stone Pot, +Tin)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/reagent_containers/glass/bucket/pot/stone, /obj/item/ingot/tin)
	created_item = /obj/item/folding_alchcauldron_stored
	craftdiff = 3

/datum/anvil_recipe/engineering/folding_alchstation_stored
	name = "Alchemical Station Kit (+2 Small Log, +Bottle, +Cog)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/reagent_containers/glass/bottle, /obj/item/roguegear)
	created_item = /obj/item/folding_alchstation_stored
	craftdiff = 3

/datum/anvil_recipe/engineering/bronze/lamptern
	name = "Lamptern, Bronze (x3)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	createditem_num = 3
	craftdiff = 3

/datum/anvil_recipe/engineering/bronze/waterpurifier
	name = "Self-Purifying Waterskin (+Waterskin)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/bottle/waterskin/purifier
	additional_items = list(/obj/item/reagent_containers/glass/bottle/waterskin)
	craftdiff = 3

/datum/anvil_recipe/engineering/bronze/coolingbackpack
	name = "Cooling Backpack (+Cog, +Backpack)" // why are these recipes capitalized differently than every other crafting recipe my ocddddddddddd
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/storage/backpack/rogue/artibackpack
	additional_items = list(/obj/item/roguegear, /obj/item/storage/backpack/rogue/backpack)
	craftdiff = 5

/datum/anvil_recipe/engineering/bronze/mobilestove
	name = "Mobile Stove (+Cog +Tin)" // capitalized to fall in line with the rest of engineering recipes T_T
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/mobilestove
	additional_items = list(/obj/item/roguegear, /obj/item/ingot/tin)
	craftdiff = 4

/datum/anvil_recipe/engineering/bronze/smokebomb
	name = "gas belcher shells (x3) (+Cog)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/smokeshell
	additional_items = list(/obj/item/roguegear)
	createditem_num = 3
	craftdiff = 3

/datum/anvil_recipe/engineering/bronze/grappler
	name = "Grappler (+1 Iron Pick, +1 Chain, +3 Cog)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/grapplinghook
	additional_items = list(/obj/item/rogueweapon/pick, /obj/item/roguegear, /obj/item/roguegear, /obj/item/roguegear, /obj/item/rope/chain)
	craftdiff = 5

/datum/anvil_recipe/engineering/bronze/headhook
	name = "Headhook, Bronze (+2 Fibers)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/storage/hip/headhook/bronze
	additional_items = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	craftdiff = 3

/datum/anvil_recipe/engineering/bronze/orestore
	name = "Mechanized Ore Bag, Bronze (+1 sac, +1 cog)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/storage/hip/orestore/bronze
	additional_items = list(/obj/item/roguegear, /obj/item/storage/roguebag)
	craftdiff = 3

//contraptions and tools
/datum/anvil_recipe/engineering/bronze/autoshears
	name = "Auto Shears (+2 Bronze, +1 cog)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/ingot/bronze, /obj/item/roguegear)
	created_item = /obj/item/contraption/shears
	craftdiff = 4

/datum/anvil_recipe/engineering/bronze/metalizer
	name = "Wood Metalizer (+2 cog)"
	req_bar= /obj/item/ingot/bronze
	additional_items = list( /obj/item/roguegear, /obj/item/roguegear)
	created_item = /obj/item/contraption/wood_metalizer
	craftdiff = 4

/datum/anvil_recipe/engineering/bronze/lockimprover
	name = "Lock Improver (1 bronze, +1 cog))"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/roguegear)
	created_item = /obj/item/contraption/lock_imprinter
	craftdiff = 4

// ------------ PROSTHETICS ----------------

/datum/anvil_recipe/engineering/bronze/prosthetic/bronzeprosthetic
	name = "bronze prosthetic (+2 Cogs)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear, /obj/item/roguegear)
	created_item = /obj/item/contraption/bronzeprosthetic
	craftdiff = 4

/datum/anvil_recipe/engineering/bronze/prosthetic/ironprosthetic
	name = "iron prosthetic (+2 cogs)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegear, /obj/item/roguegear)
	created_item = /obj/item/contraption/ironprosthetic
	craftdiff = 4

/datum/anvil_recipe/engineering/bronze/prosthetic/steelprosthetic
	name = "steel prosthetic (+2 cogs)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear, /obj/item/roguegear)
	created_item = /obj/item/contraption/steelprosthetic
	craftdiff = 4

/datum/anvil_recipe/engineering/bronze/prosthetic/goldprosthetic
	name = "gold prosthetic (+2 Cogs)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegear, /obj/item/roguegear)
	created_item = /obj/item/contraption/goldprosthetic
	craftdiff = 4

// ------------ Rings ----------------
/datum/anvil_recipe/engineering/serfstone
	name = "Serf Stone (+1 amethyst, +1 Topar)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/roguegem/yellow) //using topar since the description calls it a "dull gem"
	created_item = /obj/item/scomstone/bad
	craftdiff = 5

/datum/anvil_recipe/engineering/houndstone
	name = "Houndstone (+1 amethyst, +1 topar)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/roguegem/yellow)
	created_item = /obj/item/scomstone/bad/garrison
	craftdiff = 5

/datum/anvil_recipe/engineering/scomstone
	name = "SCOM Stone (+1 amethyst, +1 gemerald)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/roguegem/green)
	created_item = /obj/item/scomstone
	craftdiff = 5

/datum/anvil_recipe/engineering/emeraldchoker
	name = "emerald choker (+1 amethyst +Gold, +1 Gemerald)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/ingot/gold, /obj/item/roguegem/green)
	created_item = /obj/item/listenstone
	craftdiff = 5

//combat gear
/datum/anvil_recipe/engineering/artificerarmor
	name = "Artificer armor (+3 ancient alloy ingot)(+2 Bronze gear)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/ingot/purifiedaalloy, /obj/item/roguegear, /obj/item/roguegear)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer
	craftdiff = 4

/datum/anvil_recipe/engineering/volticgauntlet
	name = "Voltic Gauntlet (+1 Tin ingot)(+2 Bronze gear)(+1 cinnabar ore)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear, /obj/item/roguegear, /obj/item/ingot/tin, /obj/item/rogueore/cinnabar)
	created_item = /obj/item/clothing/gloves/roguetown/contraption/voltic
	craftdiff = 4

/datum/anvil_recipe/engineering/steamshield
	name = "Steam Shield (+1 wood plank)(+2 Bronze gear)(+2 bronze ingot)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegear, /obj/item/roguegear, /obj/item/natural/wood/plank, /obj/item/ingot/bronze, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/shield/steam
	craftdiff = 3
