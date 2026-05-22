// Fried Steak + Pepper -> Pepper Steak
/datum/food_recipe/pepper_steak
	name = "Pepper Steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/peppersteak

// Fried Steak + Fried Onion -> Onion Steak
/datum/food_recipe/onion_steak
	name = "Onion Steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/onionsteak

// Fried Steak + Baked Carrot -> Carrot Steak
/datum/food_recipe/carrot_steak_meat
	name = "Carrot Steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotsteak

// Fried Bacon + Wiener Egg -> Wiener Egg with Bacon
/datum/food_recipe/bacon_wiener_egg
	name = "Wiener Egg with Bacon (from Bacon)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon

// Fried Bacon + Fried Egg -> Bacon and Eggs
/datum/food_recipe/bacon_egg
	name = "Bacon and Eggs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon

// Roast Bird + Pepper -> Spiced Bird-Roast
/datum/food_recipe/spiced_bird
	name = "Spiced Bird-Roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced

// Roast Bird + Butter -> Butter Bird-Roast
/datum/food_recipe/butter_bird
	name = "Butter Bird-Roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butter
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter

// Roast Bird + Roast Bird -> Double Stacked Bird-Roast
/datum/food_recipe/double_bird
	name = "Double Stacked Bird-Roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked

// Frybird + Baked Potato -> Frybird Tato
/datum/food_recipe/frybird_tato_meat
	name = "Frybird Tato"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Frybird + Fried Potato -> Frybird Tato (alt)
/datum/food_recipe/frybird_tato_meat_alt
	name = "Frybird Tato (Alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Fried Cabbit + Garlic Clove -> Garlick Cabbit
/datum/food_recipe/garlick_cabbit
	name = "Garlick Cabbit"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick

// Fried Volf + Garlic Clove -> Garlick Volf
/datum/food_recipe/garlick_volf
	name = "Garlick Volf"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick

// Fried Fish Filet + Pepper -> Pepper Fish
/datum/food_recipe/pepper_fish
	name = "Pepper Fish"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pepperfish

// Cooked Sausage + Fried Egg -> Wiener Egg
/datum/food_recipe/wiener_egg_sausage
	name = "Wiener Egg (from Sausage)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
