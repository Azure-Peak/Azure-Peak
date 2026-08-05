/datum/food_recipe/dough/corn_wet
	name = "unfinished corn dough"
	base_item = /obj/item/reagent_containers/powder/flour/cornmeal
	ingredients = list(/datum/reagent/water = 10)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corndough_base
	extra_steps = list("knead it by hand (left click with an empty hand on)")
	hidden = TRUE
	book_category = FOOD_CAT_DOUGHS

/datum/food_recipe/dough/corn
	name = "corn dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/corndough_base
	ingredients = list(
		/obj/item/reagent_containers/powder/flour/cornmeal
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corndough
	book_category = FOOD_CAT_DOUGHS

/datum/food_recipe/dough/corn_flat
	name = "corn flatbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/corndough
	ingredients = list(/obj/item/kitchen/rollingpin = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corn_flatdough
	result_amount = 2
	time_per_step = 3 SECONDS
	book_category = FOOD_CAT_DOUGHS

/datum/food_recipe/dough/corn_honey
	name = "honeyed corn dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/corndough
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/honey)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corndough_honey
	book_category = FOOD_CAT_DOUGHS

/datum/food_recipe/dough/corn_ball
	name = "corn dough balls"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/corndough
	ingredients = list(/obj/item/reagent_containers/powder/flour/cornmeal)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corn_ball
	result_amount = 3
	book_category = FOOD_CAT_DOUGHS

/datum/food_recipe/cornfrybread_salsa
	name = "salsa frybread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tomato)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread_salsa
	book_category = FOOD_CAT_BAKED

/datum/food_recipe/cornfrybread_guac
	name = "guacamole frybread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/pesto)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread_guac
	book_category = FOOD_CAT_BAKED
