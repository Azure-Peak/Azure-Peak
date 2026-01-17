/obj/item/reagent_containers/food/snacks/rogue/friedegg
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("fried egg" = 1)
	name = "fried egg"
	desc = "Some Astratans enjoy their eggs sunny-side up."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "friedegg"
	portable = FALSE
	faretype = FARE_POOR
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/two(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage(loc)
				qdel(I)
				qdel(src)
	else
		return ..()


/*	.............   Twin fried eggs   ................ */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/two
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY)
	tastes = list("fried egg" = 1)
	name = "twin fried egg"
	faretype = FARE_NEUTRAL
	desc = "Double the yolks, double the fun."
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "seggs"
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/friedegg/two/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.............   Deviled Eggs   ................ */
/obj/item/reagent_containers/food/snacks/rogue/stuffeggraw
	name = "raw stuffed egg"
	desc = "Raw egg stuffed with a creamy cheese filling."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "deviledegg_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/stuffegg
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/preserved/stuffegg
	tastes = list("creamy cheese" = 1, "egg" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	name = "stuffed egg"
	desc = "Egg stuffed with a creamy cheese filling."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "deviledegg"
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT

/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*	- Defined as edible food that can be plated and usually needs rare tools or ingridients. Typically based on a snack but not necessarily
 *		 (Meals)		*
 *						*
 * * * * * * * * * * * **/

/*	.................   Valerian Omelette   ................... */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
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
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("fried egg" = 1, "bacon" = 1)
	name = "bacon and egg"
	desc = "Fried eggs with bacon. The bacon's savory salty crunch is a perfect complement to the eggs' more mellow flavors."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "baconegg"
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = SHELFLIFE_DECENT

/*	.................   Hammerholdian Breakfast   ................... */
//This is an extremely convoluded recipe probably not even worth it but yknow what, why not.
/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("fried egg" = 1, "sausage" = 1)
	name = "wiener egg"
	desc = "Fried egg with sausage on the side. A good start to a perfect morning."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "wieneregg"
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("fried egg" = 1, "sausage" = 1, "bacon" = 1)
	name = "wiener egg with bacon"
	desc = "Fried egg with sausage and bacon on the side. Mere step away from greatness."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "wienereggbacon"
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("fried egg" = 1, "sausage" = 1, "bacon" = 1, "toast" = 1)
	name = "Hammerholdian breakfast"
	desc = "A classic of the northern fortresses, peeled of it's more exotic ingredients for Azurean kitchens, a true staple of Dwarven diet."
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	icon_state = "hammerbreak"
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = SHELFLIFE_DECENT
