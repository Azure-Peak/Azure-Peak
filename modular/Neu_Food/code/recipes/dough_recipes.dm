/datum/food_recipe/dough
	abstract_type = /datum/food_recipe/dough
	book_category = FOOD_CAT_BAKED

/datum/food_recipe/dough/wet_flour
	name = "Unfinished Dough"
	base_item = /obj/item/reagent_containers/powder/flour
	ingredients = list(/datum/reagent/water = 10)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/dough_base
	extra_steps = list("knead it by hand (left click with an empty hand on)")
	hidden = TRUE

/datum/food_recipe/dough/basic
	name = "Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/dough_base
	ingredients = list(
		/obj/item/reagent_containers/powder/flour
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/dough

/datum/food_recipe/dough/raisin_bread
	name = "Raisin Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/dough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/rbread_half

/datum/food_recipe/dough/strudel_form
	name = "Strudel Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/dough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/butterdough
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/strudeldough

/datum/food_recipe/dough/flat
	name = "Flatdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/dough
	ingredients = list(/obj/item/kitchen/rollingpin = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/flatdough
	time_per_step = 3 SECONDS

/datum/food_recipe/dough/hardtack
	name = "Hardtack"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/flatdough
	ingredients = list(COOKSTEP_SHARP = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	result_amount = 2
	time_per_step = 3 SECONDS

/datum/food_recipe/dough/tomatoplate
	name = "Tomatoplate Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/flatdough
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/grown/fruit/tomato,
			/obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced,
		)
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw
	time_per_step = 3 SECONDS
