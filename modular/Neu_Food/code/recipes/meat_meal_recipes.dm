/datum/food_recipe/peppersteak_ducal
	name = "ducal peppersteak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/peppersteak
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal
	time_per_step = 3 SECONDS

/datum/food_recipe/venison_prime_choice
	name = "choice cut steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked/choice
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/venison_prime_choice_butter
	name = "choice cut steak (with butter)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked/choice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked/choice/butter
	time_per_step = 1 SECONDS

/datum/food_recipe/venison_ribs_glazed
	name = "glazed venison ribs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs/cooked/glazed
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/venison_loins_sauced
	name = "wine glazed venison loins"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins
	ingredients = list(
		/datum/reagent/consumable/ethanol/redwine = 5,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked/sauced
	time_per_step = 2 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/deadite_loins_cubed
	name = "gelatinous meat cube"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z
	ingredients = list(
		/obj/item/natural/bone,
		/obj/item/alch/viscera
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z/cooked/cubed
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/deadite_ribs_crown
	name = "berry rib crown"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z/cooked/crown
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/deadite_rose
	name = "meat roses"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z/cooked/roses
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/deadite_loaf
	name = "meatloaf"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z,
		/obj/item/alch/viscera,
		/obj/item/alch/viscera,
		/obj/item/reagent_containers/food/snacks/rogue/meat
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

// Onion Steak + Carrot -> Steak Meal
/datum/food_recipe/steakmeal_carrot
	name = "steak meal (carrot)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/onionsteak
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion
	time_per_step = 3 SECONDS

// Carrot Steak + Onion -> Steak Meal
/datum/food_recipe/steakmeal_onion
	name = "steak meal (onion)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/carrotsteak
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion
	time_per_step = 3 SECONDS

// Wiener Potato + Onion -> Wiener Meal
/datum/food_recipe/wiener_meal_onion
	name = "wiener meal (onion)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/wienerpotato
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	time_per_step = 3 SECONDS

// Wiener Onions + Potato -> Wiener Meal
/datum/food_recipe/wiener_meal_potato
	name = "wiener meal (potato)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/wieneronions
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	time_per_step = 3 SECONDS

// Spiced Baked Poultry + Garlick -> Ducal Bird-Roast
/datum/food_recipe/ducal_birdroast
	name = "ducal bird-roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal
	time_per_step = 3 SECONDS

// Fried Cabbit w/ Garlick + Cucumber -> Elven Cabbit Roast
/datum/food_recipe/elven_cabbit_roast
	name = "elven cabbit roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber
	time_per_step = 3 SECONDS

// Garlicked Fried Volf + Cucumber -> Hunter's Feast
/datum/food_recipe/hunters_feast
	name = "hunter's feast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf/fried/garlick
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf/fried/garlick/cucumber
	time_per_step = 3 SECONDS

/datum/food_recipe/venison_steak_rubbed
	name = "spiced venison steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga
	ingredients = list(
		/obj/item/reagent_containers/powder/rocknut
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga/cooked/rubbed
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/stag_medals
	name = "pale medallions"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w
	ingredients = list(
		/obj/item/reagent_containers/powder/moondust
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w/cooked/medal
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/stag_tartar
	name = "pale tartar"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/egg,
		/obj/item/alch/mentha
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w/cooked/tartar
	time_per_step = 1 SECONDS
	needs_cooking = TRUE

/datum/food_recipe/stag_ribs
	name = "pale ribs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w
	ingredients = list(
		/datum/reagent/consumable/caffeine/coffee = 10
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w/cooked/ribs
	time_per_step = 1 SECONDS
	needs_cooking = TRUE
