/obj/item/reagent_containers/food/snacks/rogue/friedegg
	cuisine = CUISINE_NORTH_IMPERIAL
	dish_type = DISH_EGG
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("fried egg" = 1)
	name = "base fried egg"
	desc = "you shouldn't be seeing this."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "friedegg"
	portable = FALSE
	faretype = FARE_POOR
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried //so fried-egg specific shit stops getting inherited
	name = "fried egg"
	desc = "Some Astratans enjoy their eggs sunny-side up."

/*	.............   Twin fried eggs   ................ */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("fried egg" = 1)
	name = "twin fried egg"
	faretype = FARE_NEUTRAL
	desc = "Double the yolks, double the fun."
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "seggs"
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.............   Deviled Eggs   ................ */
/obj/item/reagent_containers/food/snacks/rogue/stuffedegg
	dish_type = DISH_EGG
	name = "raw stuffed egg"
	desc = "Raw egg stuffed with a creamy cheese filling."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "deviledegg_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked
	tastes = list("creamy cheese" = 1, "egg" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	name = "stuffed egg"
	desc = "Egg stuffed with a creamy cheese filling."
	icon_state = "deviledegg"

/*	.............   Tartar   ................ */
//This doesn't really count as either cooked or egg recipe (it does contain an egg at least) so whatever.
/obj/item/reagent_containers/food/snacks/rogue/tartar
	name = "tartar"
	desc = "Grounded meat covered over with uncooked egg, favorite of the steppesmen. Said to have been named after a famous brigand."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "tartar"
	foodtype = MEAT
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_POOR //It's raw meat and egg... come now now

/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*	- Defined as edible food that can be plated and usually needs rare tools or ingridients. Typically based on a snack but not necessarily
 *		 (Meals)		*
 *						*
 * * * * * * * * * * * **/

/*	.................   Valerian Omelette   ................... */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("fried egg" = 1, "cheese" = 1)
	name = "valerian omelette"
	desc = "Fried eggs on a bed of half-melted cheese. A dish from distant lands."
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "omelette"
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = SHELFLIFE_DECENT

/*	.................   Bacon & Eggs   ................... */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("fried egg" = 1, "bacon" = 1)
	name = "bacon and egg"
	desc = "Fried eggs with bacon. The bacon's savory salty crunch is a perfect complement to the eggs' more mellow flavors."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "baconegg"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT

/*	.................   Hammerholdian Breakfast   ................... */
//This is an extremely convoluded recipe probably not even worth it but yknow what, why not.
/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("fried egg" = 1, "sausage" = 1)
	name = "wiener egg"
	desc = "Fried egg with sausage on the side. A good start to a perfect morning."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "wieneregg"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("fried egg" = 1, "sausage" = 1, "bacon" = 1)
	name = "wiener egg with bacon"
	desc = "Fried egg with sausage and bacon on the side. Mere step away from greatness."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "wienereggbacon"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold
	cuisine = CUISINE_NORTHERN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("fried egg" = 1, "sausage" = 1, "bacon" = 1, "toast" = 1)
	name = "Hammerholdian breakfast"
	desc = "A classic of the northern fortresses, peeled of its more exotic ingredients for Azurean kitchens, a true staple of Dwarven diet."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "hammerbreak"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_DECENT

/*	.................   Omelettes   ................... */
/obj/item/reagent_containers/food/snacks/rogue/omelette_raw
	dish_type = DISH_EGG
	name = "raw omelette"
	desc = "Beaten eggs, ready for the pan."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omeletteraw"
	foodtype = MEAT
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/omelette
	rotprocess = SHELFLIFE_SHORT
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/omelette_raw_onion
	dish_type = DISH_EGG|DISH_VEGETABLE
	name = "raw onion omelette"
	desc = "Beaten eggs with chopped onion, ready for the pan."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omeletteraw_onion"
	foodtype = MEAT | VEGETABLES
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/omelette_veggie
	rotprocess = SHELFLIFE_SHORT
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/omelette_raw_veggie
	dish_type = DISH_EGG|DISH_VEGETABLE
	name = "raw vegetable omelette"
	desc = "Beaten eggs loaded with onion and greens, ready for the pan."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omeletteraw_veggie"
	foodtype = MEAT | VEGETABLES
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/omelette_veggie
	rotprocess = SHELFLIFE_SHORT
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/omelette_raw_meat
	dish_type = DISH_EGG|DISH_MEAT
	name = "raw meat omelette"
	desc = "Beaten eggs mixed with meat, ready for the pan."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omeletteraw_meat"
	foodtype = MEAT
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/omelette_meat
	rotprocess = SHELFLIFE_SHORT
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/omelette
	dish_type = DISH_EGG
	name = "omelette"
	desc = "A fluffy omelette."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omelette"
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	rotprocess = SHELFLIFE_DECENT
	slices_num = 4
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/omelette_slice
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/snackbuff
	tastes = list("egg" = 1)

/obj/item/reagent_containers/food/snacks/rogue/omelette_slice
	name = "omelette slice"
	desc = "A wedge of fluffy omelette."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omelette_slice"
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("egg" = 1)

/obj/item/reagent_containers/food/snacks/rogue/omelette_veggie
	cuisine = CUISINE_OTAVAIS|CUISINE_SOUTHEASTERN
	dish_type = DISH_EGG|DISH_VEGETABLE
	name = "vegetable omelette"
	desc = "An omelette packed with onion and greens."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omelette_veggie"
	foodtype = MEAT | VEGETABLES
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	rotprocess = SHELFLIFE_DECENT
	slices_num = 4
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/omelette_veggie_slice
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/mealbuff
	tastes = list("egg" = 1, "vegetables" = 1)

/obj/item/reagent_containers/food/snacks/rogue/omelette_veggie_slice
	cuisine = CUISINE_OTAVAIS|CUISINE_SOUTHEASTERN
	name = "vegetable omelette slice"
	desc = "A hearty wedge of vegetable omelette."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omelette_veggie_slice"
	foodtype = MEAT | VEGETABLES
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THIRD_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("egg" = 1, "vegetables" = 1)

/obj/item/reagent_containers/food/snacks/rogue/omelette_meat
	cuisine = CUISINE_OTAVAIS|CUISINE_SOUTHEASTERN
	dish_type = DISH_EGG|DISH_MEAT
	name = "meat omelette"
	desc = "An omelette rich with meat."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omelette_meat"
	foodtype = MEAT
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	rotprocess = SHELFLIFE_DECENT
	slices_num = 4
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/omelette_meat_slice
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/mealbuff
	tastes = list("egg" = 1, "minced meat" = 1)

/obj/item/reagent_containers/food/snacks/rogue/omelette_meat_slice
	cuisine = CUISINE_OTAVAIS|CUISINE_SOUTHEASTERN
	name = "meat omelette slice"
	desc = "A savory wedge of minced meat omelette."
	icon = 'modular/Neu_Food/icons/cooked/cooked_omelette.dmi'
	icon_state = "omelette_meat_slice"
	foodtype = MEAT
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THIRD_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("egg" = 1, "minced meat" = 1)
