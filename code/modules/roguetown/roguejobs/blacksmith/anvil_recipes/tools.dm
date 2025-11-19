/datum/anvil_recipe/tools
	abstract_type = /datum/anvil_recipe/tools
	i_type = "Utilities"

// Material parent classes - one skill level lower than weapons
/datum/anvil_recipe/tools/aalloy
	abstract_type = /datum/anvil_recipe/tools/aalloy
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/copper
	abstract_type = /datum/anvil_recipe/tools/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/iron
	abstract_type = /datum/anvil_recipe/tools/iron
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/steel
	abstract_type = /datum/anvil_recipe/tools/steel
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/tools/gold
	abstract_type = /datum/anvil_recipe/tools/gold
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/tools/tin
	abstract_type = /datum/anvil_recipe/tools/tin
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/blacksteel
	abstract_type = /datum/anvil_recipe/tools/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

// --------- Copper -----------
/datum/anvil_recipe/tools/copper/sickle
	name = "Sickle, Copper (+1 Stick)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/copper
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/pick
	name = "Pick, Copper (+1 Stick)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/copper
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/pitchfork
	name = "Pitchfork, Copper (+2 Sticks)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/copper
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/lamptern
	name = "Lamptern, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/flashlight/flare/torch/lantern/copper

/datum/anvil_recipe/tools/copper/hammer
	name = "Hammer, Copper (+Stick)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/copper
	i_type = "Tools"


// --------- ANCIENT ALLOY -----------

/datum/anvil_recipe/tools/aalloy/thresher
	name = "Thresher, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher/aalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/hoe
	name = "Hoe, Decrepit (+2 Sticks)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe/aalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/pitchfork
	name = "Pitchfork, Decrepit (+2 Sticks)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/aalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/hammer
	name = "Hammer, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/aalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/sickle
	name = "Sickle, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/aalloy
	i_type = "Tools"


/datum/anvil_recipe/tools/aalloy/tongs
	name = "Tongs, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/tongs/aalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/pick
	name = "Pickaxe, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/aalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/shovel
	name = "Shovel, Decrepit (+2 Sticks)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel/aalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/sewingneedle
	name = "Needles, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/needle/aalloy
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/pan
	name = "Frypan, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/cooking/pan/aalloy

/datum/anvil_recipe/tools/aalloy/agobs
	name = "Goblet, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/cup/aalloygob
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/amugs
	name = "Mug, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/cup/aalloymug
	createditem_num = 3


/datum/anvil_recipe/tools/aalloy/pot
	name = "Cooking Pot, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/bucket/pot/aalloy


/datum/anvil_recipe/tools/aalloy/platter
	name = "Platter, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/cooking/platter/aalloy
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/bowl
	name = "Bowl, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/bowl/aalloy

/datum/anvil_recipe/tools/aalloy/fork
	name = "Fork, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/kitchen/fork/aalloy
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/spoon
	name = "Spoon, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/kitchen/spoon/aalloy
	createditem_num = 3


// --------- IRON -----------

/datum/anvil_recipe/tools/iron/blowrod
	name = "Glass Blowing Rod"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/blowrod

/datum/anvil_recipe/tools/iron/surgerytools
	name = "Surgeon's Bag (+1 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/storage/belt/rogue/surgery_bag/full

/datum/anvil_recipe/tools/iron/torch
	name = "Fieftorches (x5) (+1 Coal)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/rogueore/coal)
	created_item = /obj/item/flashlight/flare/torch/metal
	createditem_num = 5
	
/datum/anvil_recipe/tools/iron/pan
	name = "Frypan, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/cooking/pan

/datum/anvil_recipe/tools/iron/keyring
	name = "Keyrings (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/storage/keyring
	createditem_num = 3

/datum/anvil_recipe/tools/iron/sewingneedle
	name = "Needles, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/needle
	createditem_num = 3 // They can be refilled with fiber now

/* Movning under Engineering
/datum/anvil_recipe/tools/iron/lockpicks
	name = "Lockpicks x3"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/lockpick
	createditem_num = 3

/datum/anvil_recipe/tools/iron/lockpickring
	name = "Lockpickrings x3"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/lockpickring
	createditem_num = 3
*/

/datum/anvil_recipe/tools/iron/shovel
	name = "Shovel, Iron (+2 Sticks)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/hammer
	name = "Hammer, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/iron
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/handsaw
	name = "Handsaw, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/handsaw

/datum/anvil_recipe/tools/iron/chisel
	name = "Chisel, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/chisel

/datum/anvil_recipe/tools/iron/tongs
	name = "Tongs, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/tongs
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/sickle
	name = "Sickle, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/pick
	name = "Pickaxe, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/hoe
	name = "Hoe, Iron (+2 Sticks)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/pitchfork
	name = "Pitchfork, Iron (+2 Sticks)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/lamptern
	name = "Lampterns, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/flashlight/flare/torch/lantern
	createditem_num = 3

/datum/anvil_recipe/tools/iron/cups
	name = "Cups, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/cup
	createditem_num = 3

/datum/anvil_recipe/tools/iron/thresher
	name = "Thresher, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/headhook
	name = "Headhook, Iron (+2 Fibers)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	created_item = /obj/item/storage/hip/headhook
	i_type = "Tools"

// --------- Steel -----------

/datum/anvil_recipe/tools/steel/metalrepairkit
	name = "Armor Plates (x2) (+1 Steel, +1 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/repair_kit/metal
	createditem_num = 2
	craftdiff = 4 //Expert

/datum/anvil_recipe/tools/steel/hammer
	name = "Claw Hammer (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/steel

/datum/anvil_recipe/tools/steel/pick
	name = "Pickaxe, Steel (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/steel
	i_type = "Tools"

/datum/anvil_recipe/tools/steel/cups
	name = "Goblet, Steel (x3)"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/reagent_containers/glass/cup/steel
	createditem_num = 3

/datum/anvil_recipe/tools/steel/chefknife
	name = "Chef's Knife"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/chefknife
	createditem_num = 1

/datum/anvil_recipe/tools/steel/cleaver
	name = "Cleaver"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/cleaver
	createditem_num = 1

// --------- SILVER -----------

/datum/anvil_recipe/tools/silver/cups
	name = "Goblet, Silver (x3)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/reagent_containers/glass/cup/silver
	createditem_num = 3

/datum/anvil_recipe/tools/silver/shovel
	name = "Shovel, Silver (+1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shovel/silver

// --------- GOLD RECIPES-----------

/datum/anvil_recipe/tools/gold/cups
	name = "Goblet, Gold (x3)"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/reagent_containers/glass/cup/golden
	createditem_num = 3


// --------- COOKING RECIPES -----------
/datum/anvil_recipe/tools/iron/pot
	name = "Cooking Pot, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/bucket/pot

/datum/anvil_recipe/tools/iron/kettle
	name = "Cooking Kettle, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/bucket/pot/kettle

/datum/anvil_recipe/tools/copper/pot
	name = "Cooking Pot, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/reagent_containers/glass/bucket/pot/copper

/datum/anvil_recipe/tools/copper/platter
	name = "Platter, Copper (x2)"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/cooking/platter/copper
	createditem_num = 2

/datum/anvil_recipe/tools/tin/platter
	name = "Platter, Tin (x2)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/cooking/platter/pewter

/datum/anvil_recipe/tools/gold/platter
	name = "Platter, Gold (x2)"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/cooking/platter/gold

/datum/anvil_recipe/tools/silver/platter
	name = "Platter, Silver (x2)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/cooking/platter/silver

/datum/anvil_recipe/tools/iron/spoon
	name = "Spoon, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/kitchen/spoon/iron
	createditem_num = 3

/datum/anvil_recipe/tools/tin/spoon
	name = "Spoon, Tin (x3)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/kitchen/spoon/tin

/datum/anvil_recipe/tools/iron/fork
	name = "Fork, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/kitchen/fork/iron
	createditem_num = 3

/datum/anvil_recipe/tools/tin/fork
	name = "Fork, Tin (x3)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/kitchen/fork/tin

/datum/anvil_recipe/tools/iron/bowl
	name = "Bowl, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/bowl/iron
	craftdiff = 1

// --------- CASTING TOOLS -----------

/datum/anvil_recipe/tools/crucible
	name = "Crucible"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/reagent_containers/glass/crucible
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/sprue_funnel
	name = "Sprue and Funnel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/sprue_funnel
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_axe
	name = "Axe Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/axe
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_sword
	name = "Sword Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/sword
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_knife
	name = "Knife Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/knife
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_mace
	name = "Mace Head Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/mace
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_polearm
	name = "Polearm Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/polearm
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_plate
	name = "Plate Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/plate
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

// --------- HEARTBEAST TOOLS -----------
/datum/anvil_recipe/tools/heartbeast_vials
	name = "Blood vials"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_vial
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 5

/datum/anvil_recipe/tools/heartbeast_canisters
	name = "Blood canisters"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_canister
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 2

/datum/anvil_recipe/tools/aspect_canisters
	name = "Aspect canisters"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_canister
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 3
/datum/anvil_recipe/tools/bowl/aalloy
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/bowl/aalloy


// --------- CASTING TOOLS -----------

/datum/anvil_recipe/tools/crucible
	name = "Crucible"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/reagent_containers/glass/crucible
	craftdiff = 5
	i_type = "Casting"

/datum/anvil_recipe/tools/sprue_funnel
	name = "Sprue and Funnel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/sprue_funnel
	craftdiff = 5
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_axe
	name = "Axe Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/axe
	craftdiff = 5
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_sword
	name = "Sword Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/sword
	craftdiff = 5
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_knife
	name = "Knife Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/knife
	craftdiff = 5
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_mace
	name = "Mace Head Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/mace
	craftdiff = 5
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_polearm
	name = "Polearm Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/polearm
	craftdiff = 5
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_plate
	name = "Plate Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/plate
	craftdiff = 5
	i_type = "Casting"

//black steel tools
/datum/anvil_recipe/tools/blacksteel/hammer
	name = "Blacksteel hammer (+1 Stick)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/blacksteel

/datum/anvil_recipe/tools/blacksteel/pick
	name = "Blacksteel Pickaxe (+1 Stick)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/blacksteel

/datum/anvil_recipe/tools/blacksteel/tongs
	name = "Blacksteel Tongs"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/rogueweapon/tongs/blacksteel
