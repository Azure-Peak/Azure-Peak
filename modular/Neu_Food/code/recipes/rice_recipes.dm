// Cooked Rice + Fried Steak -> Rice and Beef
/datum/food_recipe/rice_beef
	name = "Rice and Beef"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebeef

// Cooked Rice + Fatty Roast -> Rice and Pork
/datum/food_recipe/rice_pork
	name = "Rice and Pork"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricepork

// Cooked Rice + Shrimp -> Rice and Shrimp
/datum/food_recipe/rice_shrimp
	name = "Rice and Shrimp"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceshrimp

// Cooked Rice + Fried Poultry Cutlet -> Rice and Bird
/datum/food_recipe/rice_bird
	name = "Rice and Bird"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebird

// Cooked Rice + Cheddar Slice -> Rice and Cheese
/datum/food_recipe/rice_cheese
	name = "Rice and Cheese"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricecheese

// Cooked Rice + Egg -> Rice and Egg
/datum/food_recipe/rice_egg
	name = "Rice and Egg"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceegg

// Rice and Pork + Cucumber -> Rice and Pork Meal
/datum/food_recipe/rice_pork_cucumber
	name = "Rice and Pork Meal"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricepork
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceporkcuc

// Rice and Beef + Baked Carrot -> Rice and Beef Meal
/datum/food_recipe/rice_beef_carrot
	name = "Rice and Beef Meal"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricebeef
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebeefcar

// Rice and Shrimp + Baked Carrot -> Rice and Shrimp Meal
/datum/food_recipe/rice_shrimp_carrot
	name = "Rice and Shrimp Meal"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/riceshrimp
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar

// Rice and Bird + Baked Carrot -> Rice and Bird Meal
/datum/food_recipe/rice_bird_carrot
	name = "Rice and Bird Meal"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricebird
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebirdcar

// Rice and Egg + Cheddar Slice -> Rice with Egg and Cheese
/datum/food_recipe/rice_egg_cheese
	name = "Rice with Egg and Cheese"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/riceegg
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese

// Rice and Cheese + Egg -> Rice with Egg and Cheese (alternative path)
/datum/food_recipe/rice_cheese_egg
	name = "Rice with Egg and Cheese (Alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/ricecheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese
