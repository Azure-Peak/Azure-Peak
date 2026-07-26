// For anything that is/requires a boiled ingredient! (Boiled means cooked like stew but results in a pickable item.)
/*	.................   Noodles   ................... */
/obj/item/reagent_containers/food/snacks/rogue/noodles
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "noodles"
	desc = "Tasteless wet noodles, while the truly desperate could eat this as is, some sauce might be in order."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pasta.dmi'
	icon_state = "noodle"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_TINY
	foodtype = GRAIN
	tastes = list("bland noodles" = 1)
	bitesize = 2
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/sheetnoodles
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "sheet noodles"
	desc = "Tasteless wet sheet noodles. Oh. You can't stack cheese or sauce on this... It's ruined." // If anyone ever adds a real recipe, change this.
	icon = 'modular/Neu_Food/icons/cooked/cooked_pasta.dmi'
	icon_state = "sheetnoodle"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_TINY
	foodtype = GRAIN
	tastes = list("bland disappointment" = 1)
	bitesize = 2
	rotprocess = SHELFLIFE_EXTREME

/*	.................   Spaghetti   ................... */
/obj/item/reagent_containers/food/snacks/rogue/spaghetti
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "spaghetti"
	desc = "Noodles mixed with fresh marinara, beloved by the Etruscan isles. It's said that Navarno cuisine is as rich as it is poor, and it's scarce ingredients was necessary before it's unification with Montecarina."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pasta.dmi'
	icon_state = "spaghetti"
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL) //It's pasta and sauce.
	tastes = list("richly smooth and salty tomatoes" = 1, "al dente noodles" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | FRUIT
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/spaghetti_pesto
	dish_type = DISH_NOODLES
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "pesto spaghetti"
	desc = "Noodles mixed with a spiced refined sauce made from smoky rocknut and garlick. A cultural blend of Azurian improvisation and Navarno ingenuity."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pasta.dmi'
	icon_state = "spaghetti_pesto"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 1)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce"=1, "al dente noodles" = 1)
	foodtype = GRAIN | VEGETABLES
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	rotprocess = SHELFLIFE_DECENT
