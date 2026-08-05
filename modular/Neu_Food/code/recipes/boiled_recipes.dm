/datum/food_recipe/boiled
	abstract_type = /datum/food_recipe/boiled
	book_category = FOOD_CAT_BOILED

// Noodles + Tomato Sauce -> Spaghetti
/datum/food_recipe/boiled/spaghetti
	name = "spaghetti"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/noodles
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sauce
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/spaghetti
	time_per_step = 3 SECONDS
	inline_ancestry = TRUE

// Noodles + Pesto -> Pesto Spaghetti
/datum/food_recipe/boiled/spaghetti_pesto
	name = "pesto spaghetti"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/noodles
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/pesto
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/spaghetti_pesto
	time_per_step = 3 SECONDS
	inline_ancestry = TRUE
