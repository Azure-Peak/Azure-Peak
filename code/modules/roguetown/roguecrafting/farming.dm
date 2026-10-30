/datum/crafting_recipe/roguetown/farming
	abstract_type = /datum/crafting_recipe/roguetown/farming
	display_category = ITEM_CAT_RAW_MATERIAL_ORGANIC
	req_table = FALSE
	verbage_simple = "mix"
	skillcraft = /datum/skill/labor/farming
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/farming/fertilizer
	name = "fertilizer"
	result = /obj/item/fertilizer
	reqs = list(/obj/item/compost = 1, /obj/item/natural/bone = 1, /obj/item/natural/poo = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/farming/stockbait
	name = "stockbait (via farming)"
	result = /obj/item/bait/stockbait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/natural/chaff/wheat = 1,
		/obj/item/reagent_containers/food/snacks/roastseeds = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
		/obj/item/natural/cured/essence = 1,
		)
	craftdiff = 5
