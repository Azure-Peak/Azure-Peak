/datum/food_recipe/seafood
	abstract_type = /datum/food_recipe/seafood
	book_category = FOOD_CAT_SEAFOOD

// Cooked Sole + Butter -> Buttered Sole
/datum/food_recipe/seafood/buttered_sole
	name = "buttered sole"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/buttersole

// Cooked Cod + Ale -> Ale Cod
/datum/food_recipe/seafood/ale_cod
	name = "ale cod"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	ingredients = list(
		/datum/reagent/consumable/ethanol/beer = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/alecod

// Cooked Lobster + Pepper -> Pepper Lobster
/datum/food_recipe/seafood/pepper_lobster
	name = "pepper lobster"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pepperlobsta

// Cooked Lobster + Butter -> Buttered Lobster Meal
/datum/food_recipe/seafood/buttered_lobster
	name = "buttered lobster"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal

// Cooked Salmon + Mentha -> Dendorsalmon (Mentha Salmon)
/datum/food_recipe/seafood/mentha_salmon
	name = "mentha salmon"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	ingredients = list(
		/obj/item/alch/mentha
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/dendorsalmon

// Cooked Salmon + Berries -> Berry Salmon
/datum/food_recipe/seafood/berry_salmon
	name = "berry salmon"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrysalmon

// Cooked Plaice + Sliced Onion -> Onion Plaice
/datum/food_recipe/seafood/onion_plaice
	name = "onion plaice"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/onionplaice

// Cooked Bass + Garlic Clove -> Garlic Bass
/datum/food_recipe/seafood/garlic_bass
	name = "garlic bass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/garlickbass

// Cooked Clam + Milk -> Milk Clam
/datum/food_recipe/seafood/milk_clam
	name = "milk clam"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	ingredients = list(
		/datum/reagent/consumable/milk = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/milkclam

// Cooked Sunny + Pepper -> Peppered Sunny
/datum/food_recipe/seafood/pepper_sunny
	name = "peppered sunny"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sunnypepper

// Peppered Sunny + Garlick -> Ducal Sunny
/datum/food_recipe/seafood/ducal_sunny
	name = "ducal sunny"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/sunnypepper
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sunnypepper/ducal
	time_per_step = 3 SECONDS

// Cooked Sunny + Baked Potato -> Sunny with Potatoes
/datum/food_recipe/seafood/potato_sunny
	name = "sunny with potatoes"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sunnypotato

// Cooked Sunny + Fried Potato -> Sunny with Potatoes (alt)
/datum/food_recipe/seafood/potato_sunny_alt
	name = "sunny with potatoes (alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sunnypotato

// Cooked Sunny + Sliced Onion -> Sunny with Onion
/datum/food_recipe/seafood/onion_sunny
	name = "sunny with onion"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sunnyonion

// Cooked Plaice + Pepper -> Peppered Plaice
/datum/food_recipe/seafood/pepper_plaice
	name = "peppered plaice"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/plaicepepper

// Peppered Plaice + Garlick -> Ducal Plaice
/datum/food_recipe/seafood/ducal_plaice
	name = "ducal plaice"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/plaicepepper
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/plaicepepper/ducal
	time_per_step = 3 SECONDS

// Fryfilet + Pepper -> Pepperfilet
/datum/food_recipe/seafood/pepper_filet
	name = "pepperfilet"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/pepper

// Pepperfilet + Garlick -> Ducal Filet
/datum/food_recipe/seafood/ducal_filet
	name = "ducal filet"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/pepper
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/ducal
	time_per_step = 3 SECONDS

// Fryfilet + Sliced Onion -> Filet with Onion
/datum/food_recipe/seafood/onion_filet
	name = "filet with onion"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/onion

// Fryfilet + Baked Potato -> Filet with Potatoes
/datum/food_recipe/seafood/potato_filet
	name = "filet with potatoes"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/potato

// Fryfilet + Fried Potato -> Filet with Potatoes (alt)
/datum/food_recipe/seafood/potato_filet_alt
	name = "filet with potatoes (alt)"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/potato

// Fryfilet + Sliced Tomato -> Filet with Tomato
/datum/food_recipe/seafood/tomato_filet
	name = "filet with tomato"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/tomato

// Fryfilet + Jacksberries -> Filet with Jacksberries
/datum/food_recipe/seafood/jacksberry_filet
	name = "filet with jacksberries"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/jacksberry

// Fryfilet + Honey -> Honeyed Filet
/datum/food_recipe/seafood/honey_filet
	name = "honeyed filet"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/honey

// Fryfilet + Sliced Cucumber -> Filet with Cucumber
/datum/food_recipe/seafood/cucumber_filet
	name = "filet with cucumber"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal/cucumber
