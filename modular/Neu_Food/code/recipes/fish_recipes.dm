// Cooked Sole + Butter -> Buttered Sole
/datum/food_recipe/buttered_sole
	name = "Buttered Sole"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/buttersole

// Cooked Cod + Ale -> Ale Cod
/datum/food_recipe/ale_cod
	name = "Ale Cod"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	ingredients = list(
		/datum/reagent/consumable/ethanol/beer = 1  // Requires 1 unit of beer reagent
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/alecod

// Cooked Lobster + Pepper -> Pepper Lobster
/datum/food_recipe/pepper_lobster
	name = "Pepper Lobster"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1  // Requires 1 unit of black pepper
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pepperlobsta

// Cooked Lobster + Butter -> Buttered Lobster Meal
/datum/food_recipe/buttered_lobster
	name = "Buttered Lobster"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal

// Cooked Salmon + Mentha -> Dendorsalmon (Mentha Salmon)
/datum/food_recipe/mentha_salmon
	name = "Mentha Salmon"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	ingredients = list(
		/obj/item/alch/mentha
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/dendorsalmon

// Cooked Salmon + Berries -> Berry Salmon
/datum/food_recipe/berry_salmon
	name = "Berry Salmon"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrysalmon

// Cooked Plaice + Sliced Onion -> Onion Plaice
/datum/food_recipe/onion_plaice
	name = "Onion Plaice"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/onionplaice

// Cooked Bass + Garlic Clove -> Garlic Bass
/datum/food_recipe/garlic_bass
	name = "Garlic Bass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/garlickbass

// Cooked Clam + Milk -> Milk Clam
/datum/food_recipe/milk_clam
	name = "Milk Clam"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	ingredients = list(
		/datum/reagent/consumable/milk = 1  // Requires 1 unit of milk
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/milkclam
