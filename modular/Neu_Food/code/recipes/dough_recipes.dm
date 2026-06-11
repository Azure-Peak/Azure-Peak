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

/datum/food_recipe/dough/cheesebun
	name = "Cheese Bun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw

/datum/food_recipe/dough/combine_smalldough
	name = "Dough (from Smalldough)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/doughslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/dough

/datum/food_recipe/dough/crossbun
	name = "Cross Bun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	ingredients = list(/obj/item/clothing/neck/roguetown/psicross/astrata = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw

/datum/food_recipe/dough/psycrossbun
	name = "Psycross Bun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	ingredients = list(/obj/item/clothing/neck/roguetown/psicross = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw

/datum/food_recipe/dough/strudel_from_smalldough
	name = "Strudel Dough (from Smalldough)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/dough
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/strudeldough

/datum/food_recipe/dough/tomatoplate_cheese
	name = "Cheesed Tomatoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese

/datum/food_recipe/dough/tomatoplate_sausage
	name = "Sausage Tomatoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_sausage

/datum/food_recipe/dough/tomatoplate_fish
	name = "Fish Tomatoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_fish

/datum/food_recipe/dough/tomatoplate_truffle
	name = "Truffle Tomatoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/truffles
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_truffles

/datum/food_recipe/dough/tomatoplate_poisontruffle
	name = "Truffle Tomatoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/toxicshrooms
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_poisontruffles
	hidden = TRUE

/datum/food_recipe/dough/tomatoplate_onion
	name = "Onion Tomatoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/grown/onion/rogue,
			/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced,
		)
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion
	time_per_step = 3 SECONDS

/datum/food_recipe/dough/tomatoplate_pear
	name = "Pear Tomatoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear

/datum/food_recipe/dough/handpie
	abstract_type = /datum/food_recipe/dough/handpie
	base_item = /obj/item/reagent_containers/food/snacks/rogue/piedough
	required_station = null

/datum/food_recipe/dough/handpie/mushroom
	name = "Mushroom Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/truffles
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom

/datum/food_recipe/dough/handpie/fish
	name = "Fish Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish

/datum/food_recipe/dough/handpie/meat
	name = "Meat Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat

/datum/food_recipe/dough/handpie/crab
	name = "Crab Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/crab
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab

/datum/food_recipe/dough/handpie/berry
	name = "Berry Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry

/datum/food_recipe/dough/handpie/apple
	name = "Apple Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple

/datum/food_recipe/dough/handpie/potato
	name = "Potato Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato

/datum/food_recipe/dough/handpie/cabbage
	name = "Cabbage Handpie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage

/datum/food_recipe/dough/strudel
	name = "Strudel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/strudeldough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/nut,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/strudel
	cook_method = COOK_BAKE
	required_station = null

/datum/food_recipe/dough/dot_tart
	abstract_type = /datum/food_recipe/dough/dot_tart
	base_item = /obj/item/reagent_containers/food/snacks/rogue/tartdough

/datum/food_recipe/dough/dot_tart/tangerine
	name = "Tangerine Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_tangerine

/datum/food_recipe/dough/dot_tart/plum
	name = "Plum Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/plum
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_plum

/datum/food_recipe/dough/dot_tart/blackberry
	name = "Blackberry Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_blackberry

/datum/food_recipe/dough/dot_tart/raspberry
	name = "Raspberry Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_raspberry

/datum/food_recipe/dough/dot_tart/strawberry
	name = "Strawberry Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_strawberry

/datum/food_recipe/dough/dot_tart/pear
	name = "Pear Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_pear

/datum/food_recipe/dough/dot_tart/apple
	name = "Apple Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_apple

/datum/food_recipe/dough/dot_tart/goldapple
	name = "Ambrosia Dot Tart"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple
