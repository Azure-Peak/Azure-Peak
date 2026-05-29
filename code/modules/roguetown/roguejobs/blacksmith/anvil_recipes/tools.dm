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

/datum/anvil_recipe/tools/bronze
	abstract_type = /datum/anvil_recipe/tools/bronze
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
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/pick
	name = "Pick, Copper (+1 Stick)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/copper
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/pitchfork
	name = "Pitchfork, Copper (+2 Sticks)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/copper
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/lamptern
	name = "Lamptern, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/flashlight/flare/torch/lantern/copper
	display_category = ITEM_CAT_TOOLS_SUNDRIES

/datum/anvil_recipe/tools/copper/hammer
	name = "Hammer, Copper (+Stick)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/copper
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	i_type = "Tools"


// --------- ANCIENT ALLOY -----------

/datum/anvil_recipe/tools/aalloy/thresher
	name = "Thresher, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher/aalloy
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/hoe
	name = "Hoe, Decrepit (+2 Sticks)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe/aalloy
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/pitchfork
	name = "Pitchfork, Decrepit (+2 Sticks)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/aalloy
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/hammer
	name = "Hammer, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/aalloy
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	i_type = "Tools"

/datum/anvil_recipe/tools/paalloy/hammer
	name = "Hammer, Ancient (+1 Stick)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/paalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/sickle
	name = "Sickle, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/aalloy
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/tongs
	name = "Tongs, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/tongs/aalloy
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	i_type = "Tools"

/datum/anvil_recipe/tools/paalloy/tongs
	name = "Tongs, Ancient"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/tongs/paalloy
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/pick
	name = "Pickaxe, Decrepit (+1 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/aalloy
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/shovel
	name = "Shovel, Decrepit (+2 Sticks)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel/aalloy
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/aalloy/sewingneedle
	name = "Needles, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/needle/aalloy
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/pan
	name = "Frypan, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/cooking/pan/aalloy
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/aalloy/agobs
	name = "Goblet, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/cup/aalloygob
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/amugs
	name = "Mug, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/cup/aalloymug
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/pot
	name = "Cooking Pot, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/bucket/pot/aalloy
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/aalloy/platter
	name = "Platter, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/cooking/platter/aalloy
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/bowl
	name = "Bowl, Decrepit"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/bowl/aalloy
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/aalloy/fork
	name = "Fork, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/kitchen/fork/aalloy
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/aalloy/spoon
	name = "Spoon, Decrepit (x3)"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/kitchen/spoon/aalloy
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

// ------- BRONZE -----------
/datum/anvil_recipe/tools/bronze/thresher
	name = "Thresher, Bronze (+1 Stick)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher/bronze
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/hoe
	name = "Hoe, Bronze (+2 Sticks)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe/bronze
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/pitchfork
	name = "Pitchfork, Bronze (+2 Sticks)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/bronze
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/hammer
	name = "Hammer, Bronze (+1 Stick)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/bronze
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/sickle
	name = "Sickle, Bronze (+1 Stick)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/bronze
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/tongs
	name = "Tongs, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/tongs/bronze
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/pick
	name = "Axepick, Bronze (+1 Stick, +1 Bronze)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/pick/bronze
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/shovel
	name = "Shovel, Bronze (+2 Sticks)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel/bronze
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/bronze/sewingneedle
	name = "Needle, Bronze (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/needle/bronze
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/pan
	name = "Frypan, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/cooking/pan/bronze
	display_category = ITEM_CAT_TOOLS_COOKWARE
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/pot
	name = "Cooking Pot, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/bucket/pot/bronze
	display_category = ITEM_CAT_TOOLS_COOKWARE
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/handsaw
	name = "Handsaw, Bronze (+1 Stick)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/handsaw/bronze
	display_category = ITEM_CAT_TOOLS_WORKSHOP

/datum/anvil_recipe/tools/bronze/chisel
	name = "Chisel, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/chisel/bronze
	display_category = ITEM_CAT_TOOLS_WORKSHOP

/datum/anvil_recipe/tools/bronze/gobs
	name = "Goblet, Bronze (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/cup/bronzegob
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2

/datum/anvil_recipe/tools/bronze/amugs
	name = "Mug, Bronze (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/cup/bronzemug
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/platter
	name = "Platter, Bronze (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/cooking/platter/bronze
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/bowl
	name = "Bowl, Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/bowl/bronze
	display_category = ITEM_CAT_TOOLS_COOKWARE
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/fork
	name = "Fork, Bronze (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/kitchen/fork/bronze
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/spoon
	name = "Spoon, Bronze (x2)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/kitchen/spoon/bronze
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/tools/bronze/lamptern
	name = "Handlamptern, Bronze (+3 Sticks)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/flashlight/flare/torch/lantern/bronze
	display_category = ITEM_CAT_TOOLS_SUNDRIES


// --------- IRON -----------

/datum/anvil_recipe/tools/iron/blowrod
	name = "Glass Blowing Rod"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/blowrod
	display_category = ITEM_CAT_TOOLS_WORKSHOP

/datum/anvil_recipe/tools/iron/surgerytools
	name = "Surgeon's Bag (+1 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/storage/belt/rogue/surgery_bag/full
	display_category = ITEM_CAT_SMITHING_MISC

/datum/anvil_recipe/tools/iron/torch
	name = "Fieftorches (x5) (+1 Coal)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/rogueore/coal)
	created_item = /obj/item/flashlight/flare/torch/metal
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	createditem_num = 5

/datum/anvil_recipe/tools/iron/pan
	name = "Frypan, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/cooking/pan
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/iron/keyring
	name = "Keyrings (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/storage/keyring
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	createditem_num = 3

/datum/anvil_recipe/tools/iron/sewingneedle
	name = "Needles, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/needle
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	createditem_num = 3 // They can be refilled with fiber now

/datum/anvil_recipe/tools/iron/shovel
	name = "Shovel, Iron (+2 Sticks)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/hammer
	name = "Hammer, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/iron
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/handsaw
	name = "Handsaw, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/handsaw
	display_category = ITEM_CAT_TOOLS_WORKSHOP

/datum/anvil_recipe/tools/iron/chisel
	name = "Chisel, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/chisel
	display_category = ITEM_CAT_TOOLS_WORKSHOP

/datum/anvil_recipe/tools/iron/tongs
	name = "Tongs, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/tongs
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/sickle
	name = "Sickle, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/pick
	name = "Pickaxe, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/hoe
	name = "Hoe, Iron (+2 Sticks)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/pitchfork
	name = "Pitchfork, Iron (+2 Sticks)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick,/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/lamptern
	name = "Lampterns, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/flashlight/flare/torch/lantern
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	createditem_num = 3

/datum/anvil_recipe/tools/iron/scrap
	name = "Pieces Of Scrap, Iron (x2)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/scrap
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	createditem_num = 2

/datum/anvil_recipe/tools/iron/cups
	name = "Cups, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/cup
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/iron/thresher
	name = "Thresher, Iron (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/headhook
	name = "Headhook, Iron (+2 Fibers)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	created_item = /obj/item/storage/hip/headhook
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	i_type = "Tools"

// --------- Steel -----------

/datum/anvil_recipe/tools/steel/metalrepairkit
	name = "Armor Plates (x2) (+1 Steel, +1 Iron, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/repair_kit/metal
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	createditem_num = 2
	craftdiff = 4 //Expert

/datum/anvil_recipe/tools/steel/hammer
	name = "Claw Hammer (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/steel
	display_category = ITEM_CAT_TOOLS_WORKSHOP

/datum/anvil_recipe/tools/steel/pick
	name = "Pickaxe, Steel (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/steel
	display_category = ITEM_CAT_TOOLS_FIELD
	i_type = "Tools"

/datum/anvil_recipe/tools/steel/cups
	name = "Goblet, Steel (x3)"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/reagent_containers/glass/cup/steel
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/steel/chefknife
	name = "Chef's Knife"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/chefknife
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 1

/datum/anvil_recipe/tools/steel/cleaver
	name = "Cleaver"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/chefknife/cleaver
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 1

// --------- SILVER -----------

/datum/anvil_recipe/tools/silver/cups
	name = "Goblet, Silver (x3)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/reagent_containers/glass/cup/silver
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/silver/shovel
	name = "Shovel, Silver (+1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shovel/silver
	display_category = ITEM_CAT_TOOLS_FIELD

// --------- GOLD RECIPES-----------

/datum/anvil_recipe/tools/gold/cups
	name = "Goblet, Gold (x3)"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/reagent_containers/glass/cup/golden
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3


// --------- COOKING RECIPES -----------
/datum/anvil_recipe/tools/iron/pot
	name = "Cooking Pot, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/bucket/pot
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/iron/kettle
	name = "Cooking Kettle, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/bucket/pot/kettle
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/copper/pot
	name = "Cooking Pot, Copper"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/reagent_containers/glass/bucket/pot/copper
	display_category = ITEM_CAT_TOOLS_COOKWARE

/datum/anvil_recipe/tools/copper/platter
	name = "Platter, Copper (x2)"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/cooking/platter/copper
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2

/datum/anvil_recipe/tools/tin/platter
	name = "Platter, Tin (x2)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/cooking/platter/pewter
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2

/datum/anvil_recipe/tools/gold/platter
	name = "Platter, Gold (x2)"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/cooking/platter/gold
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2

/datum/anvil_recipe/tools/silver/platter
	name = "Platter, Silver (x2)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/cooking/platter/silver
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 2

/datum/anvil_recipe/tools/iron/spoon
	name = "Spoon, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/kitchen/spoon/iron
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/tin/spoon
	name = "Spoon, Tin (x3)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/kitchen/spoon/tin
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/iron/fork
	name = "Fork, Iron (x3)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/kitchen/fork/iron
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/tin/fork
	name = "Fork, Tin (x3)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/kitchen/fork/tin
	display_category = ITEM_CAT_TOOLS_COOKWARE
	createditem_num = 3

/datum/anvil_recipe/tools/iron/bowl
	name = "Bowl, Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/glass/bowl/iron
	display_category = ITEM_CAT_TOOLS_COOKWARE
	craftdiff = 1

// --------- HEARTBEAST TOOLS -----------
/datum/anvil_recipe/tools/heartbeast_vials
	name = "Blood vials"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_vial
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 5

/datum/anvil_recipe/tools/heartbeast_canisters
	name = "Blood canisters"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_canister
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 2

/datum/anvil_recipe/tools/aspect_canisters
	name = "Aspect canisters"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_canister
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 3
/datum/anvil_recipe/tools/bowl/aalloy
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/reagent_containers/glass/bowl/aalloy
	display_category = ITEM_CAT_TOOLS_COOKWARE


//black steel tools
/datum/anvil_recipe/tools/blacksteel/hammer
	name = "Blacksteel hammer (+1 Stick)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/blacksteel
	display_category = ITEM_CAT_TOOLS_WORKSHOP

/datum/anvil_recipe/tools/blacksteel/pick
	name = "Blacksteel Pickaxe (+1 Stick)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/blacksteel
	display_category = ITEM_CAT_TOOLS_FIELD

/datum/anvil_recipe/tools/blacksteel/tongs
	name = "Blacksteel Tongs"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/rogueweapon/tongs/blacksteel
	display_category = ITEM_CAT_TOOLS_WORKSHOP
