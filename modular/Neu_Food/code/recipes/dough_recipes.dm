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

/datum/food_recipe/dough/cake_base
	name = "Cake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	time_per_step = 3 SECONDS

/datum/food_recipe/dough/muffin
	name = "Muffindough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/kitchen/spoon = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/muffindough

/datum/food_recipe/dough/pumpkin_loaf
	name = "Pumpkin Loaf"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced,
			/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed,
			/obj/item/reagent_containers/food/snacks/pumpkinspice,
		)
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw

/datum/food_recipe/dough/jackberry_bread
	name = "Jackberry Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked
	time_per_step = 3 SECONDS

/datum/food_recipe/dough/poisonberry_bread
	name = "Jackberry Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/poisonberrybread_uncooked
	time_per_step = 3 SECONDS
	hidden = TRUE

/datum/food_recipe/dough/piedough
	name = "Piedough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(/obj/item/kitchen/rollingpin = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/piedough

/datum/food_recipe/dough/tartdough
	name = "Tartdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(/obj/item/kitchen/spoon = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/tartdough

/datum/food_recipe/dough/pumpkin_ball
	name = "Pumpkin Ball"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced,
			/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed,
			/obj/item/reagent_containers/food/snacks/pumpkinspice,
		)
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinball_raw

/datum/food_recipe/dough/tangerine_biscuit
	name = "Tangerine Biscuits"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tangerinebiscuit_raw
	result_amount = 2

/datum/food_recipe/dough/plum_biscuit
	name = "Plum Biscuits"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/plum
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/plumbiscuit_raw
	result_amount = 2

/datum/food_recipe/dough/raisin_biscuit
	name = "Raisin Biscuits"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw
	result_amount = 2

/datum/food_recipe/dough/chocolate_biscuit
	name = "Chocolate Biscuits"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/chocolate
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw
	result_amount = 2

/datum/food_recipe/dough/prezzel
	name = "Prezzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(COOKSTEP_SHARP = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw
	restricted_message = "You lack knowledge of dwarven pastries!"

/datum/food_recipe/dough/prezzel/user_can_make(mob/user)
	return isdwarf(user)
