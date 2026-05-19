/datum/crafting_recipe/roguetown/hunting
	abstract_type = /datum/crafting_recipe/roguetown/hunting/
	display_category = ITEM_CAT_TOOLS_FIELD
	skillcraft = /datum/skill/misc/hunting
	// I don't want people to use this to substitute actual hunting
	xp_modifier = 0.1

/datum/crafting_recipe/roguetown/hunting/bait
	name = "bait"
	result = /obj/item/bait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/sbaita
	name = "sweetbait (apple)"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/apple = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/sbait
	name = "sweetbait (berry)"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/hunting/bloodbait
	name = "bloodbait"
	result = /obj/item/bait/bloody
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat = 2,
		)
	subtype_reqs = TRUE
	craftdiff = 2
