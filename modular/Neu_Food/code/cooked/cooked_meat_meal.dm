// High efforts (i.e. spiced / buttered / onioned or whatever) meal where meat
// Is the main ingredient.
/*	..................   Pepper steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	tastes = list("steak" = 1, "pepper" = 1)
	name = "peppersteak"
	desc = "Roasted meat flanked with a generous coating of ground pepper for intense flavor."
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "peppersteak"
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/peppersteak/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/garlick/rogue))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	..................   Ducal steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal
	tastes = list("steak" = 1, "pepper" = 1, "garlick" = 1)
	name = "ducal steak"
	desc = "Roasted meat flanked with a generous coating of ground pepper for intense flavor and scribbled in with garlick. Said to have been favorite meal of the Mad Duke."
	faretype = FARE_LAVISH
	icon_state = "ducalsteak"
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	..................   Onion steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/onionsteak
	name = "onion steak"
	desc = "Roasted meat garnished with fragrant fried onions, then slathered with the juices of both for a perfect mouth-watering sauce."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "onionsteak"
	tastes = list("steak" = 1, "onions" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/obj/item/reagent_containers/food/snacks/rogue/onionsteak/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	..................   Carrot Steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/carrotsteak
	name = "carrot steak"
	desc = "Roasted meat paired with a savory baked carrot, then slathered with the juices of both for a perfect mouth-watering sauce."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "carrotsteak"
	tastes = list("steak" = 1, "carrot" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	foodtype = MEAT
	faretype = FARE_FINE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/carrotsteak/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................   Steak & carrot & onion   ................... */
/obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("steak" = 1, "onion" = 1, "carrots" = 1)
	name = "steak meal"
	desc = ""
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "steakmeal"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Wiener Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienercabbage
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("savory sausage" = 1, "cabbage" = 1)
	name = "wiener on cabbage"
	desc = "A rich and hearty meal, perfect for a soldier on the march."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienercabbage"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff


/*	.................   Wiener & Fried potato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("savory sausage" = 1, "potato" = 1)
	name = "wiener on tato"
	desc = "Stout and nourishing."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienerpotato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff


/obj/item/reagent_containers/food/snacks/rogue/wienerpotato/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................   Wiener & Fried onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wieneronions
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("savory sausage" = 1, "fried onions" = 1)
	name = "wiener and onions"
	desc = "Stout and flavourful."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wieneronion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff


/obj/item/reagent_containers/food/snacks/rogue/wieneronions/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................   Wiener & potato & onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("savory sausage" = 1, "potato" = 1)
	name = "wiener meal"
	desc = "Stout and nourishing."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wpotonion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................  Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced
	name = "spiced bird-roast"
	desc = "A plump bird, roasted perfection, spiced to taste divine."
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "pepperchicken"
	tastes = list("spicy birdmeat" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/garlick/rogue))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................  Ducal Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal
	name = "ducal bird-roast"
	desc = "A plump bird, roasted perfection, spiced to taste divine with touch of garlick to top it all off. Perfect to feast on while your son is dying in battle..."
	faretype = FARE_LAVISH
	icon_state = "ducalchicken"
	tastes = list("spicy birdmeat" = 1, "garlick" = 1)
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................  Baked Butter Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter
	name = "butter bird-roast"
	desc = "A plump bird, roasted perfection, overflowing with butter from the inside."
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "butterchicken"
	tastes = list("buttery birdmeat" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................  Baked Double Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked
	name = "bird filled bird-roast"
	desc = "A plump bird, roasted perfection.. filled with another bird - what compelled you to make this? Psydon Weeps at your hubris."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "stuffedchicken"
	eat_effect = /datum/status_effect/buff/mealbuff
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE*2)

/*	.................   Frybird & Tato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdtato
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("frybird" = 1, "tato" = 1)
	name = "frybird with a tato"
	desc = "Hearty, comforting, and rich - Some say it was Ravox's favorite meal."
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdtato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Frybird Bucket   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE*3)
	tastes = list("frybird" = 1)
	name = "frybird bucket"
	desc = "Hearty, comforting, and rich - Azurean Frybirds are the best on the entire continent and now even in a convinient bucket!"
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdbucket"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............   Fried Cabbit w/ Garlick  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick
	name = "garlick cabbit"
	desc = "A slab of cabbit, fried to a perfect crispy texture - coated over in glove of garlick."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frycabbit_garlick"
	tastes = list("warm cabbit" = 1, "garlick" = 1)

/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............   Fried Cabbit w/ Garlick & Cucumber ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber
	name = "elven cabbit roast"
	desc = "A slab of cabbit, fried to a perfect crispy texture - coated over in glove of garlick and served with side of cucumber. Thought to bring good luck by rangers!"
	icon_state = "frycabbit_garlick_cucumber"
	tastes = list("warm cabbit" = 1, "garlick" = 1, "cucumber" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Garlicked Fried Volf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick
	name = "garlick volf"
	desc = "A slab of volf, fried to a perfect medium rare. A bit gamey and chewy, but tasty. This piece has been coated over in glove of garlick."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "fryvolf_garlick"
	tastes = list("gamey volf" = 1, "garlick" = 1)

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/cucumber(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............  Garlicked Fried Volf w/ Cucumber  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/cucumber
	name = "hunter's feast"
	desc = "A slab of volf, fried to a perfect medium rare. A bit gamey and chewy, but tasty. This piece has been coated over in glove of garlick and served with side of cucumber."
	icon_state = "fryvolf_garlick_cucumber"
	tastes = list("gamey volf" = 1, "garlick" = 1, "cucumber" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
