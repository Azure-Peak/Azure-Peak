// Food that is primarily made out of a cooked vegetable component.
/*	.............   Cooked cabbage   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	name = "cooked cabbage"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "cabbage_fried"
	desc = "A peasant's delight."
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("warm cabbage" = 1)
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wienercabbage(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.............   Baked potato   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	name = "baked potatoes"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "A dwarven favorite, as a meal or a game of hot potato."
	faretype = FARE_POOR
	icon_state = "potato_baked"
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Preparing a serving of wiener and tatos...")
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotato(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Preparing a serving of frybird and tatos...")
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frybirdtato(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.............   Fried potato   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	name = "fried potato"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "Potato bits, well roasted."
	icon_state = "potato_fried"
	faretype = FARE_NEUTRAL
	portable = FALSE
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("warm potato" = 1)
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Preparing a serving of wiener and tatos...")
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotato(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Preparing a serving of frybird and tatos...")
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frybirdtato(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............   Baked Carrot   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	name = "baked carrot"
	desc = "A carrot baked to a golden brown, with a soft and sweet interior."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "carrot_cooked"
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("carrot" = 1)
	rotprocess = SHELFLIFE_DECENT
/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Preparing a serving of steak and carrots...")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/carrotsteak(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/ricebeef))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Laying down carrots alongside the rice...")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/ricebeefcar(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.............   Fried onions   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	name = "fried onion"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	desc = "Seared onions roasted to a delicious set of rings."
	icon_state = "onion_fried"
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("savoury morsel" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Preparing a serving of wiener and onions...")
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wieneronions(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............   Eggplant   ................ */
/obj/item/reagent_containers/food/snacks/rogue/eggplantcarved
	name = "carved aubergine"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplant_carved"
	desc = "An eggplant with its insides hollowed out, ready to be stuffed with meat."
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/eggplantcarved/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Filling meat into the aubergine...")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/eggplantmeat(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/eggplantmeat
	name = "unfinished stuffed aubergine"
	desc = "An eggplant stuffed with raw meat, ready to be topped with tomato."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplantraw"
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/eggplantmeat/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tomato))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Topping tomatos onto the aubergine...")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw
	name = "raw stuffed aubergine"
	desc = "A stuffed aubergine with raw meat and tomato, ready to be cooked."
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "eggplantrawtom"
	rotprocess = SHELFLIFE_LONG
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed

/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY)
	name = "stuffed aubergine"
	desc = "Eggplant stuffed with raw meat and tomato. Delicious!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "stuffedeggplant"
	tastes = list("meat" = 1, "tomato" = 1, "aubergine" = 1)
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "Laying down a blanket of cheese...")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	name = "stuffed aubergine with cheese"
	desc = "Stuffed aubergine with cheese on top. Fit for a king!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_veggies.dmi'
	icon_state = "stuffedeggplantcheese"
	tastes = list("meat" = 1, "tomato" = 1, "aubergine" = 1, "cheese" = 1)
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/roastseeds
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
	mill_result = /obj/item/reagent_containers/powder/pumpkin
