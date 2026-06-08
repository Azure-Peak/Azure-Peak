/datum/food_recipe/eggs
	abstract_type = /datum/food_recipe/eggs
	book_category = FOOD_CAT_EGGS

// Two Fried Eggs (Egg + Egg)
/datum/food_recipe/eggs/twin_fried_eggs
	name = "Twin Fried Eggs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	time_per_step = 3 SECONDS

// Fried Egg + Sausage -> Wiener Egg
/datum/food_recipe/eggs/wiener_egg
	name = "Wiener Egg"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	time_per_step = 3 SECONDS

// Twin Eggs + Cheese -> Valerian Omelette
/datum/food_recipe/eggs/valerian_omelette
	name = "Valerian Omelette"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian
	time_per_step = 5 SECONDS

// Twin Eggs + Bacon -> Bacon & Eggs
/datum/food_recipe/eggs/bacon_and_eggs
	name = "Bacon and Eggs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon
	time_per_step = 5 SECONDS

// Bacon & Eggs + Sausage -> Wiener Egg with Bacon
/datum/food_recipe/eggs/wiener_egg_bacon
	name = "Wiener Egg with Bacon"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	time_per_step = 5 SECONDS

// Wiener Egg + Bacon -> Wiener Egg with Bacon (alternative path)
/datum/food_recipe/eggs/wiener_egg_bacon_alt
	name = "Wiener Egg with Bacon (Alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	time_per_step = 5 SECONDS

// Wiener Egg with Bacon + Toast -> Hammerholdian Breakfast
/datum/food_recipe/eggs/hammerholdian_breakfast
	name = "Hammerholdian Breakfast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold
	time_per_step = 5 SECONDS
