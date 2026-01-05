// Generic category for everything that is related to "general survival".
// Includes some skill diff 0 or 1 recipes that make sense like drying rack.
// This is just basically everything under the generic "crafting" skills
// With a few exceptions atm to be cleared out later.
// Quarterstaff, carpentry etc. you know.
// Previously known as items.dm
/datum/crafting_recipe/roguetown/
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival
	abstract_type = /datum/crafting_recipe/roguetown/survival/
	skillcraft = /datum/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/flint //custar recipe for flint.
	name = "flint"
	result = /obj/item/flint
	reqs =  list(/obj/item/scrap = 2,
				/obj/item/natural/whetstone = 2,
				/obj/item/natural/fibers = 1,
	)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/repairkitclothbad
	name = "fabric patch" //9 fiber
	result = /obj/item/repair_kit/bad
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/repairkitmetalingot
	name = "empty metal kit (iron bar)"
	result = /obj/item/armorkit_empty
	reqs = list(
		/obj/item/ingot/iron = 1,
		)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/repairkitmetalscrap
	name = "empty metal kit (scrap)"
	result = /obj/item/armorkit_empty
	reqs = list(
		/obj/item/scrap = 3,
		)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/repairkitcloth
	name = "sewing kit"
	result = /obj/item/repair_kit
	reqs = list(
		/obj/item/natural/cloth = 4,
		/obj/item/natural/hide/cured = 2,
		)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4 //Expert

/datum/crafting_recipe/roguetown/survival/tneedle
	name = "sewing needle"
	result = /obj/item/needle/thorn
	reqs = list(
		/obj/item/natural/thorn = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/cloth
	name = "cloth"
	result = /obj/item/natural/cloth
	reqs = list(/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/clothbelt
	name = "cloth belt"
	result = /obj/item/storage/belt/rogue/leather/cloth
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0
	verbage_simple = "tie"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/unclothbelt
	name = "untie cloth belt"
	result = /obj/item/natural/cloth
	reqs = list(/obj/item/storage/belt/rogue/leather/cloth = 1)
	craftdiff = 0
	verbage_simple = "untie"
	verbage = "unties"

/datum/crafting_recipe/roguetown/survival/clothsash
	name = "fine sash"
	result = /obj/item/storage/belt/rogue/leather/sash
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/ropebelt
	name = "rope belt"
	result = /obj/item/storage/belt/rogue/leather/rope
	reqs = list(/obj/item/rope = 1)
	craftdiff = 0
	verbage_simple = "tie"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/unropebelt
	name = "untie rope belt"
	result = /obj/item/rope
	reqs = list(/obj/item/storage/belt/rogue/leather/rope = 1)
	craftdiff = 0
	verbage_simple = "untie"
	verbage = "unties"

/datum/crafting_recipe/roguetown/survival/rope
	name = "rope"
	result = /obj/item/rope
	reqs = list(/obj/item/natural/fibers = 3)
	verbage_simple = "braid"
	verbage = "braids"

/datum/crafting_recipe/roguetown/survival/torch
	name = "torch"
	result = /obj/item/flashlight/flare/torch
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/bag
	name = "sack"
	result = /obj/item/storage/roguebag/crafted
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 1,
		)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing

/obj/item/storage/roguebag/crafted
	sellprice = 4

/datum/crafting_recipe/roguetown/survival/bait
	name = "bait"
	result = /obj/item/bait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/sbaita
	name = "sweetbait (apple)"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/apple = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/sbait
	name = "sweetbait (berry)"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/bloodbait
	name = "bloodbait"
	result = /obj/item/bait/bloody
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/pipe
	name = "wood pipe"
	result = /obj/item/clothing/mask/cigarette/pipe/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)

/obj/item/clothing/mask/cigarette/pipe/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/survival/broom
	name = "broom"
	result = /obj/item/broom
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 4,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/book_crafting_kit
	name = "book crafting kit"
	result = /obj/item/book_crafting_kit
	reqs = list(
		/obj/item/natural/hide = 2,
		/obj/item/natural/cloth = 1,
		)
	tools = list(/obj/item/needle = 1)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/paperscroll
	name = "scroll of parchment (x3)"
	result = list(
		/obj/item/paper/scroll,
		/obj/item/paper/scroll,
		/obj/item/paper/scroll,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/datum/reagent/water = 48,
		)
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftarm
	name = "wood arm (L)"
	result = list(/obj/item/bodypart/l_arm/prosthetic/woodleft)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightarm
	name = "wood arm (R)"
	result = list(/obj/item/bodypart/r_arm/prosthetic/woodright)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftleft
	name = "wood leg (L)"
	result = list(/obj/item/bodypart/l_leg/prosthetic)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightleg
	name = "wood leg (R)"
	result = list(/obj/item/bodypart/r_leg/prosthetic)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/tarot_deck
	name = "tarot deck"
	result = list(/obj/item/toy/cards/deck/tarot)
	reqs = list(
		/obj/item/paper/scroll = 3,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ash = 1,
		)
	skillcraft = /datum/skill/misc/reading
	tools = list(/obj/item/natural/feather)
	req_table = TRUE
	craftdiff = 2

// Woodcutting recipe
/datum/crafting_recipe/roguetown/survival/lumberjacking
	skillcraft = /datum/skill/labor/lumberjacking
	tools = list(/obj/item/rogueweapon/huntingknife = 1)

/datum/crafting_recipe/roguetown/survival/lumberjacking/cart_upgrade
	name = "woodcutters wheelbrace"
	result = /obj/item/cart_upgrade/level_1
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/stone = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/lumberjacking/cart_upgrade2
	name = "reinforced woodcutters wheelbrace"
	result = /obj/item/cart_upgrade/level_2
	reqs = list(
		/obj/item/grown/log/tree/small = 4,
		/obj/item/cart_upgrade/level_1 = 1,
		/obj/item/ingot/iron = 1,
		)
	craftdiff = 4


/datum/crafting_recipe/hair_dye
    name = "hair dye cream"
    result = /obj/item/hair_dye_cream
    reqs = list(
        /obj/item/reagent_containers/glass/bowl = 1,
        /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 3,
    )

// DIE

/datum/crafting_recipe/roguetown/survival/d4
	name = "bone die (d4)"
	result = /obj/item/dice/d4
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/d6
	name = "bone die (d6)"
	result = /obj/item/dice/d6
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/d8
	name = "bone die (d8)"
	result = /obj/item/dice/d8
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/d10
	name = "bone die (d10)"
	result = /obj/item/dice/d10
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/d12
	name = "bone die (d12)"
	result = /obj/item/dice/d12
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/d20
	name = "bone die (d20)"
	result = /obj/item/dice/d20
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/dye_brush
	name = "dye brush"
	result = /obj/item/dye_brush
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fur = 1
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/whetstone
	name = "whetstone"
	result = /obj/item/natural/whetstone
	reqs = list(
		/obj/item/natural/stone = 1,
		/obj/item/grown/log/tree/stake = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/rucksack
	name = "rucksack"
	result = /obj/item/storage/backpack/rogue/backpack/bagpack
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/rope = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/rucksack/crafted
	reqs = list(/obj/item/storage/roguebag/crafted = 1,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/survival/handmirror
	name = "hand mirror"
	result = /obj/item/handmirror
	reqs = list(
		/obj/item/natural/glass = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
	craftdiff = 2

// Improvised surgey tools. They go here for now (TM)
/datum/crafting_recipe/roguetown/survival/improvisedsaw
	name = "improvised surgery saw"
	result = /obj/item/rogueweapon/surgery/saw/improv
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/stone = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/improvisedclamp
	name = "improvised retractor"
	result = /obj/item/rogueweapon/surgery/retractor/improv
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 2,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/improvisedhemo
	name = "improvised clamp"
	result = /obj/item/rogueweapon/surgery/hemostat/improv
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 2,
		)
	craftdiff = 1

// Unfortunately there's no good category for it, yet.
// I don't want ration paper to be too expensive, making wrapped food underused
// So instead, ration paper is a very cheap recipe with parchment and tallow (instead of full fat) that makes 2 wrapper
// However, it is heavily skillgated by cooking skill. At Craftdiff 4, only Innkeep / Cook can make it easily off the bat.
// Servant w/ high int can also make it, but it is a bit harder. Or just be middle aged / old instead lol
// For 1 fat, 1 log (48 reagents), you get 4 tallow + 6 piece of paper yielding 12 ration wrappers with 1 tallow leftover.
/datum/crafting_recipe/roguetown/survival/ration_wrapper
	name = "ration wrapping paper (x2)"
	result = list(
		/obj/item/ration,
		/obj/item/ration,
		)
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		)
	skillcraft = /datum/skill/craft/cooking
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/cheele
	name = "cheele"
	result = list(
		/obj/item/natural/worms/leech/cheele
		)
	reqs = list(
		/obj/item/reagent_containers/lux = 1,
		/obj/item/natural/worms/leech = 1,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = SKILL_LEVEL_EXPERT

/datum/crafting_recipe/roguetown/survival/purify_lux
	name = "purifiy lux"
	result = list(
		/obj/item/heart_blood_canister,
		/obj/item/reagent_containers/lux,
		)
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/heart_blood_canister/filled = 1,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/purify_lux_vials
	name = "purifiy lux (vials)"
	result = list(
		/obj/item/reagent_containers/lux,
		/obj/item/heart_blood_vial,
		/obj/item/heart_blood_vial,
		/obj/item/heart_blood_vial,
		)
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/heart_blood_vial/filled = 3,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/bandage
	name = "bandages (medicine)"
	result = list(
		/obj/item/natural/cloth/bandage
	)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/silk = 1,
		/obj/item/ash = 1)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2
