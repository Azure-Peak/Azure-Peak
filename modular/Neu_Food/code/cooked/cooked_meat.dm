// Simple cooked meat from any animals.
// Only includes simple cooked meat instead of the meal.
// Try to order in the same order as raw meat file ok
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	eat_effect = null
	slices_num = 0
	name = "frysteak"
	desc = "A slab of beastflesh, fried to a perfect medium-rare"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frysteak"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("warm steak" = 1)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(mill))
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "There's not enough black pepper to make anything with.")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "You start rubbing the steak with black pepper.")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "There's not enough black pepper to make anything with.")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/peppersteak(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		to_chat(user, span_notice("Adding onions..."))
		if(do_after(user,short_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/onionsteak(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(I)
			qdel(src)

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		to_chat(user, "<span class='notice'>Adding carrots...</span>")
		if(do_after(user,short_cooktime, target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			new /obj/item/reagent_containers/food/snacks/rogue/carrotsteak(loc)
			qdel(I)
			qdel(src)

	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/* .............   Roast Pork   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	eat_effect = null
	name = "roast pork"
	desc = "A hunk of pigflesh, roasted to a perfect crispy texture"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	faretype = FARE_FINE
	icon_state = "roastpork"
	tastes = list("crispy pork" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/*	.............   Crispy bacon   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	eat_effect = null
	name = "fried bacon"
	desc = "A trufflepig's retirement plan."
	faretype = FARE_FINE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedbacon"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.............   Fryspider   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	name = "fried spidermeat"
	desc = "A spider leg, shaved and roasted."
	faretype = FARE_POOR
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedspider"
	eat_effect = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/*	.................  Whole Chicken roast   ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	desc = "A plump bird, roasted to a perfect temperature and bears a crispy skin."
	eat_effect = null
	slices_num = 0
	name = "roast bird"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "roastchicken"
	faretype = FARE_FINE
	portable = FALSE
	tastes = list("tasty birdmeat" = 1)
	cooked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	rotprocess = SHELFLIFE_DECENT


/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/attackby(obj/item/I, mob/user, params)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(istype(mill))
		if (!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/table/optable) in src.loc) && \
			!(locate(/obj/item/storage/bag/tray) in src.loc))
			to_chat(user, span_warning("I need to use a table."))
			return FALSE

		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "There's not enough black pepper to make anything with.")
			return FALSE

		mill.icon_state = "peppermill_grind"
		to_chat(user, "You start rubbing the bird roast with black pepper.")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,3 SECONDS, target = src))
			mill.icon_state = "peppermill"
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "There's not enough black pepper to make anything with.")
				return FALSE

			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced(loc)
			qdel(src)
		else
			mill.icon_state = "peppermill"
	else
		return ..()

/*	.................  Spiced Baked Poultry  ................... */
// Leaving it here instead of meal cuz it has no sprite
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced
	name = "spiced bird-roast"
	desc = "A plump bird, roasted perfection, spiced to taste divine."
	faretype = FARE_LAVISH
	portable = FALSE
	color = "#ffc0c0"
	tastes = list("spicy birdmeat" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.............   Frybird   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	eat_effect = null
	slices_num = 0
	name = "frybird"
	desc = "Poultry scorched to a perfect delicious crisp."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frybird"
	faretype = FARE_FINE
	portable = FALSE
	fried_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frybirdtato(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frybirdtato(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* ............. Fried Crab ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	eat_effect = null
	slices_num = 0
	name = "fried crabmeat"
	faretype = FARE_NEUTRAL
	portable = FALSE
	desc = "A fried piece of crabmeat, yum."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "crabmeat"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	desc = ""
	fried_type = null
	cooked_type = null

/* .............   Fried Cabbit   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	eat_effect = null
	slices_num = 0
	name = "fried cabbit"
	desc = "A slab of cabbit, fried to a perfect crispy texture."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frycabbit"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)	//It's easier and cheaper than normal meat to find.
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("warm cabbit" = 1)
	fried_type = null
	cooked_type = null

/* .............   Fried Volf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	eat_effect = null
	slices_num = 0
	name = "fried volf"
	desc = "A slab of volf, fried to a perfect medium rare. A bit gamey and chewy, but tasty."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "fryvolf"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/* .............   Fried Filet    ................ */
// This is seafood but is one of the "simple cooked meat" so I put it here.
/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	eat_effect = null
	slices_num = 0
	name = "fryfilet"
	desc = "A slab of flaky fish, fried until falling apart."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "cooked_filet"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("warm fish" = 1)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(mill))
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "There's not enough black pepper to make anything with.")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "You start rubbing the fish with black pepper.")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "There's not enough black pepper to make anything with.")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/pepperfish(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)

	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/* .............   Fried Shellfish    ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	eat_effect = null
	slices_num = 0
	name = "fried shellfish"
	desc = "Fried shellfish meat. A bit salty, but delicious."
	faretype = FARE_NEUTRAL
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "shellfish_meat_cooked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	fried_type = null
	cooked_type = null


/*	.............   Sausage & Wiener   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	eat_effect = null
	name = "sausage"
	desc = "Delicious flesh stuffed in a intestine casing."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "wiener"
	faretype = FARE_NEUTRAL
	fried_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage(loc)
				qdel(I)
				qdel(src)
	else
		return ..()
