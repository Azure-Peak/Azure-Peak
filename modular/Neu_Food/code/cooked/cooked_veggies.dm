// Food that is primarily made out of a cooked vegetable component.
/*	.............	Cooked cabbage	................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	dish_type = DISH_VEGETABLE
	name = "cooked cabbage"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "cabbage_fried"
	desc = "A peasant's delight."
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("warm cabbage" = 1)
	rotprocess = SHELFLIFE_LONG

/*	.............	Baked potato	................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	cuisine = CUISINE_NORTHERN
	dish_type = DISH_VEGETABLE
	name = "baked potatoes"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "A dwarven favorite, as a meal or a game of hot potato."
	faretype = FARE_POOR
	icon_state = "potato_baked"
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_LONG

/*	.............	Fried potato	................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cuisine = CUISINE_NORTHERN
	dish_type = DISH_VEGETABLE
	name = "fried potato"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "Potato bits, well roasted."
	icon_state = "potato_fried"
	faretype = FARE_NEUTRAL
	portable = FALSE
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("warm potato" = 1)
	rotprocess = SHELFLIFE_LONG

/* .............	Baked Carrot	................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	dish_type = DISH_VEGETABLE
	name = "baked carrot"
	desc = "A carrot baked to a golden brown, with a soft and sweet interior."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "carrot_cooked"
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("carrot" = 1)
	rotprocess = SHELFLIFE_DECENT

/*	.............	Fried onions	................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	dish_type = DISH_VEGETABLE
	name = "fried onion"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "Seared onions roasted to a delicious set of rings."
	icon_state = "onion_fried"
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("savoury morsel" = 1)
	rotprocess = SHELFLIFE_DECENT

/* .............	Eggplant	................ */
/obj/item/reagent_containers/food/snacks/rogue/eggplantcarved
	cuisine = CUISINE_ETRUSCAN|CUISINE_RANESHENI
	dish_type = DISH_VEGETABLE
	name = "carved aubergine"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplant_carved"
	desc = "An eggplant with its insides hollowed out, ready to be stuffed with meat."
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/eggplantmeat
	cuisine = CUISINE_ETRUSCAN|CUISINE_RANESHENI
	dish_type = DISH_VEGETABLE|DISH_MEAT
	name = "unfinished stuffed aubergine"
	desc = "An eggplant stuffed with raw meat, ready to be topped with tomato."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplantraw"
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw
	name = "raw stuffed aubergine"
	desc = "A stuffed aubergine with raw meat and tomato, ready to be cooked."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplantrawtom"
	rotprocess = SHELFLIFE_LONG
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed

/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed
	cuisine = CUISINE_ETRUSCAN|CUISINE_RANESHENI
	dish_type = DISH_VEGETABLE|DISH_MEAT
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	name = "stuffed aubergine"
	desc = "Eggplant stuffed with meat and tomato. Delicious!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "stuffedeggplant"
	tastes = list("meat" = 1, "tomato" = 1, "aubergine" = 1)
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese
	cuisine = CUISINE_ETRUSCAN|CUISINE_RANESHENI
	dish_type = DISH_VEGETABLE|DISH_DAIRY
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	name = "stuffed aubergine with cheese"
	desc = "Stuffed aubergine with cheese on top. Fit for a king!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "stuffedeggplantcheese"
	tastes = list("meat" = 1, "tomato" = 1, "aubergine" = 1, "cheese" = 1)
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/etruscalad
	cuisine = CUISINE_ETRUSCAN
	dish_type = DISH_VEGETABLE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	name = "etruscalad"
	desc = "A crunchy, bitter salad with Etruscan origins. A staple food amidst both the rich and the poor, though not nearly as hearty on its own without any meat or cheese."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "etruscalad"
	tastes = list("earthiness" = 1, "tomato" = 1, "cabbage" = 3)
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/dressed_etruscalad
	cuisine = CUISINE_ETRUSCAN
	dish_type = DISH_VEGETABLE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	name = "dressed etruscalad"
	desc = "A delicious végétal salad with a wicked crunch, topped with a sour vinaigrette which has radically transformed the cabbage's taste and color. The centerpiece of any good Etruscan lunch."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "etruscalad_dressed"
	tastes = list("ripe cabbage" = 1, "tomato" = 1, "vinegar" = 1)
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/royal_etruscalad
	cuisine = CUISINE_ETRUSCAN|CUISINE_NORTH_IMPERIAL
	dish_type = DISH_VEGETABLE|DISH_BREAD
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	name = "royal etruscalad"
	desc = "A pidgin végétal dish known to have served as appetizer in many a meal for the old Mad Duke; a crunchy, vinegary etruscalad is topped with flaky cubed toast slices. Excessive and delicious."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "etruscalad_royal"
	tastes = list("ripe cabbage" = 1, "tomato" = 1, "vinegar" = 1, "croutons" = 1)
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/obj/item/reagent_containers/food/snacks/roastseeds
	dish_type = DISH_VEGETABLE
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	tastes = list("toasted seeds" = 1)
	name = "roasted seeds"
	desc = "Food for birds, treats for humens."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "roastseeds"
	dropshrink = 0.8
	color = "#e5b175"
	foodtype = VEGETABLES
	rotprocess = null

/obj/item/reagent_containers/food/snacks/roastseeds/sunflower
	name = "roasted sunflower seeds"
	tastes = list("toasted sunflower seeds" = 1)

/obj/item/reagent_containers/food/snacks/roastseeds/pumpkin
	name = "roasted pumpkin seeds"
	tastes = list("toasted pumpkin seeds" = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/pumpkinspice
