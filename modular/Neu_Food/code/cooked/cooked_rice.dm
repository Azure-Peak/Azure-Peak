/* .............   RICE   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	cuisine = CUISINE_SOUTHEASTERN
	name = "cooked rice"
	desc = "Plain cooked rice, a staple food in many cultures."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "rice"
	faretype = FARE_POOR
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_LONG

/*	.................   Rice & pork  ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricepork
	cuisine = CUISINE_SOUTHEASTERN
	dish_type = DISH_MEAT
	name = "rice and pork"
	tastes = list("rice" = 1, "pork" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "Rice mixed with fatty pork."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricepork"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & pork & cucumbers ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceporkcuc
	cuisine = CUISINE_SOUTHEASTERN
	dish_type = DISH_MEAT|DISH_VEGETABLE
	name = "rice and pork meal"
	tastes = list("rice" = 1, "pork" = 1, "fresh cucumber" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	desc = "Rice mixed with fatty pork and fresh cucumbers."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceporkmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & beef ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebeef
	cuisine = CUISINE_SOUTHEASTERN|CUISINE_RANESHENI
	dish_type = DISH_MEAT
	name = "rice and beef"
	tastes = list("rice" = 1, "steak" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "Rice mixed with beef steak."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebeef"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & beef & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebeefcar
	cuisine = CUISINE_SOUTHEASTERN|CUISINE_RANESHENI
	dish_type = DISH_MEAT|DISH_VEGETABLE
	name = "rice and beef meal"
	tastes = list("rice" = 1, "steak" = 1, "carrot" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	desc = "Rice mixed with beef steak and carrots."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebeefmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & shrimp ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceshrimp
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_ETRUSCAN|CUISINE_SOUTHEASTERN
	dish_type = DISH_SEAFOOD
	name = "rice and shrimp"
	tastes = list("rice" = 1, "shrimp" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "Rice mixed with shrimp."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceshrimp"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & shrimp & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_ETRUSCAN|CUISINE_SOUTHEASTERN
	dish_type = DISH_SEAFOOD|DISH_VEGETABLE
	name = "rice and shrimp meal"
	tastes = list("rice" = 1, "shrimp" = 1, "carrot" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "Rice mixed with shrimp and carrots."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceshrimpmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & bird ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebird
	cuisine = CUISINE_SOUTHEASTERN|CUISINE_RANESHENI
	dish_type = DISH_POULTRY
	name = "rice and frybird"
	tastes = list("rice" = 1, "tasty birdmeat" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "Rice mixed with frybird."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebird"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & bird & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebirdcar
	cuisine = CUISINE_SOUTHEASTERN|CUISINE_RANESHENI
	dish_type = DISH_POULTRY|DISH_VEGETABLE
	name = "rice and frybird meal"
	tastes = list("rice" = 1, "tasty birdmeat" = 1, "carrot" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	desc = "Rice mixed with frybird and carrots."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebirdmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & egg ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceegg
	cuisine = CUISINE_SOUTHEASTERN
	dish_type = DISH_EGG
	name = "rice and egg"
	tastes = list("rice" = 1, "egg" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "Rice mixed with an egg."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceegg"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & cheese ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricecheese
	cuisine = CUISINE_ETRUSCAN|CUISINE_SOUTHEASTERN
	dish_type = DISH_DAIRY
	name = "rice and cheese"
	tastes = list("rice" = 1, "cheese" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	desc = "Rice with a layer of melted cheese."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricecheese"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Rice & egg & cheese ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceeggcheese
	cuisine = CUISINE_SOUTHEASTERN
	dish_type = DISH_EGG|DISH_DAIRY
	name = "rice with egg and cheese"
	tastes = list("rice" = 1, "cheese" = 1, "egg" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	desc = "Rice mixed with an egg and layered with melted cheese."
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceeggcheese"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff
