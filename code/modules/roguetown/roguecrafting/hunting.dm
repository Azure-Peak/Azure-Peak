/datum/crafting_recipe/roguetown/hunting
	abstract_type = /datum/crafting_recipe/roguetown/hunting/
	display_category = ITEM_CAT_TOOLS_FIELD
	skillcraft = /datum/skill/misc/hunting
	// I don't want people to use this to substitute actual hunting
	xp_modifier = 0.1
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/hunting/baito
	name = "bait (oats)"
	result = /obj/item/bait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/oat = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/baitr
	name = "bait (rice)"
	result = /obj/item/bait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/rice = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/bait
	name = "bait (wheat)"
	result = /obj/item/bait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/sbaita
	name = "sweetbait (apple)"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/apple = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/sbait
	name = "sweetbait (berry)"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/bloodbait
	name = "bloodbait"
	result = /obj/item/bait/bloody
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/stockbait
	name = "stockbait"
	result = /obj/item/bait/stockbait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/natural/chaff/wheat = 1,
		/obj/item/reagent_containers/food/snacks/roastseeds = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
		/obj/item/natural/cured/essence = 1,
		)
	craftdiff = 2

// A little bit of extra value for leveling your butchery
/datum/crafting_recipe/roguetown/hunting/goat_horn
	name = "goat horn bundle"
	skillcraft = /datum/skill/labor/butchering
	tools = list(/obj/item/rogueweapon/huntingknife)
	result = /obj/item/natural/goathorn
	reqs = list(
		/obj/item/natural/head/goat_wild = 1,
		)
	subtype_reqs = TRUE
	craftdiff = 5
