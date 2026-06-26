/datum/food_recipe/eggs
	abstract_type = /datum/food_recipe/eggs
	book_category = FOOD_CAT_EGGS

// Two Fried Eggs (Egg + Egg)
/datum/food_recipe/eggs/twin_fried_eggs
	name = "twin fried eggs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	time_per_step = 3 SECONDS

// Fried Egg + Sausage -> Wiener Egg
/datum/food_recipe/eggs/wiener_egg
	name = "wiener egg"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	time_per_step = 3 SECONDS

// Twin Eggs + Cheese -> Valerian Omelette
/datum/food_recipe/eggs/valerian_omelette
	name = "valerian omelette"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian
	time_per_step = 5 SECONDS

// Twin Eggs + Bacon -> Bacon & Eggs
/datum/food_recipe/eggs/bacon_and_eggs
	name = "bacon and eggs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon
	time_per_step = 5 SECONDS

// Bacon & Eggs + Sausage -> Wiener Egg with Bacon
/datum/food_recipe/eggs/wiener_egg_bacon
	name = "wiener egg with bacon"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	time_per_step = 5 SECONDS

// Wiener Egg + Bacon -> Wiener Egg with Bacon (alternative path)
/datum/food_recipe/eggs/wiener_egg_bacon_alt
	name = "wiener egg with bacon (alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	time_per_step = 5 SECONDS

// Wiener Egg with Bacon + Toast -> Hammerholdian Breakfast
/datum/food_recipe/eggs/hammerholdian_breakfast
	name = "hammerholdian breakfast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold
	time_per_step = 5 SECONDS

/datum/food_recipe/eggs/stuffed
	name = "stuffed egg"
	base_item = /obj/item/reagent_containers/food/snacks/egg
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/stuffedegg
	time_per_step = 3 SECONDS
