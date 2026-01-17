//	.................   Cake base   .................
/obj/item/reagent_containers/food/snacks/rogue/cake_base
	name = "cake base"
	desc = "With this sweet thing, you shall make them sing."
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "cake"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cake
	cooked_smell = /datum/pollutant/food/cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/cake_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/frosting))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Slathering the cake with frosting..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Spreading fresh cheese on the cake..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Slathering the cake with delicious honey..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/cake
	name = "cake"
	desc = "Soft and tender, a base or a delicious treat for the impatient."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1)
	foodtype = GRAIN | DAIRY
	faretype = FARE_NEUTRAL
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/cake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/frosting)) // QoL for those that forgot to put the icing first
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Slathering the cake with frosting..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frostedcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/cakeslice
	name = "cake slice"
	desc = "Soft and tender, a delicious slice of plain cake."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = null
	foodtype = GRAIN | DAIRY
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG

//	.................   Frosted cake   .................
//	.................        Raw       .................
/obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked
	name = "frosted cake base"
	desc = "With this sweet frosted thing, you shall make them sing and dance."
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "frostedcake"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	cooked_smell = /datum/pollutant/food/frosted_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY | SUGAR
	rotprocess = SHELFLIFE_LONG

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/frostedcake
	name = "frosted cake"
	desc = "Cake glazed with a sugary frosting, ready to be decorated or enjoyed."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "frostedcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/frostedcakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_FINE
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/frostedcake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple)) //apple cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Chopping and mixing-in the [I]..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/applecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue)) //berry cake (+poison)
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Squashing some and mixing-in the left-over berries..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
					new /obj/item/reagent_containers/food/snacks/rogue/berrycake/poison(loc)
				else
					new /obj/item/reagent_containers/food/snacks/rogue/berrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry)) //blackberry cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Pouring and filling the cake with juicy blackberries..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/blackberrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked) || istype(I, /obj/item/reagent_containers/food/snacks/grown/carrot)) //carrot cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Peeling and mixing the [I] into the frosting and dough..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/carrotcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/lemon)) //lemon cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Chopping the [I] and mixing it with the cake..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/lemoncake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/lime)) //lime cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Chopping the [I] and mixing it with the cake..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/limecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
/*
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/manabloom)) //manabloom cake
		if(isturf(loc)&& (found_table))
			if(user.get_skill_level(/datum/skill/magic/arcane) < 1)
				to_chat(user, span_notice("I do not know how to bind the arcyne between the manabloom and the cake."))
			else
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_notice("Carefully placing the manabloom on the cake and binding its essence to the cake..."))
				if(do_after(user,long_cooktime, target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/manacake(loc)
					qdel(I)
					qdel(src)
					playsound(get_turf(user), 'sound/magic/charged.ogg', 100, TRUE, -1)
					user.say("Immensa dulcedo!")
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
*/
	if(istype(I, /obj/item/alch/mentha)) //mentha cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Chopping and mixing the [I] with the cake frosting..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/menthacake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/clothing/head/peaceflower)) //peace cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Carefully adding the [I] to the cake..."))
			if(do_after(user,long_cooktime, target = src))
				user.visible_message(span_notice("[user] adds the [I] to the [src]. The frosting changes color!"))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/peacecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry)) //raspberry cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Pouring and filling the cake with juicy raspberries..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/raspberrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut)) //rocknut cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Surrounding the cake with [I]..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/rocknutcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry)) //strawberry cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Surrounding the cake with [I]..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strawberrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)) //tangerine cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Chopping the [I] and mixing it with the cake..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tangerinecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	//(We could add generic cakes here, using the filling overlays)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/frostedcakeslice
	name = "frosted cake slice"
	desc = "Glazed slice with a sugary frosting, ready to be tasted."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "frostedcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Apple cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/applecake
	name = "apple cake"
	desc = "Cake glazed with a sugary frosting and layered with juicy apples, sweetness and tart."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/applecakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"apple"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/applecake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Surrounding the cake with rocknuts..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/applenutcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/applecakeslice
	name = "apple cake slice"
	desc = "Glazed slice with a sugary frosting and layered with juicy apples, sweetness and tart."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"apple"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Applenut cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/applenutcake
	name = "applenut cake"
	desc = "Frosted cake layered with apples and surrounded in nuts. A spectacle of flavors and textures, with mild stimulant properties."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applenutcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/applenutcakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 1)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"apple"=1,"nutty"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/applenutcakeslice
	name = "applenut cake slice"
	desc = "Frosted slice layered with apples and surrounded in nuts. A spectacle of flavors and textures, with mild stimulant properties."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applenutcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/consumable/acorn_powder = 1)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"apple"=1,"nutty"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Berry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/berrycake
	name = "berry cake"
	desc = "Cake with a spread of juicy berries dripping into its frosting. Often found paired with antidote."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "berrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/berrycakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48, /datum/reagent/water = 5)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"berry"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/berrycake/poison
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/berrycakeslice/poison
	list_reagents = list(/datum/reagent/berrypoison = 5, /datum/reagent/consumable/nutriment = 48, /datum/reagent/water = 5)

/obj/item/reagent_containers/food/snacks/rogue/berrycakeslice
	name = "berry cake slice"
	desc = "Sliced cake with a spread of juicy berries dripping into its frosting."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "berrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"berry"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/berrycakeslice/poison
	list_reagents = list(/datum/reagent/berrypoison = 1, /datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/water = 1)

//	..................   Blackberry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/blackberrycake
	name = "blackberry cake"
	desc = "A dark frosted cake topped with blackberries. A fruity treat often paired with raspberry cake."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "blackberrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/blackberrycakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"blackberry"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/blackberrycakeslice
	name = "blackberry cake slice"
	desc = "A dark frosted slice of cake topped with blackberries. A fruity treat often paired with raspberry cake."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "blackberrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"blackberry"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Carrot cake   ..................
//         This could've been a berry cake too.
/obj/item/reagent_containers/food/snacks/rogue/carrotcake
	name = "carrot cake"
	desc = "A surprisingly sweet frosted cake with cooked carrot peels stuffed in its tender interior."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "carrotcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/carrotcakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"carrot"=1)
	foodtype = GRAIN | DAIRY | SUGAR | VEGETABLES
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/carrotcakeslice
	name = "carrot cake slice"
	desc = "A surprisingly sweet frosted cake slice with cooked carrot peels stuffed in its tender interior."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "carrotcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"carrot"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | VEGETABLES
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Lemon cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/lemoncake
	name = "lemon cake"
	desc = "A frosted cake with a rich citrus taste. A thick layer of lemon filling give it a sweet, tangy and zesty flavour."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "lemoncake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/lemoncakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"lemon"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/lemoncakeslice
	name = "lemon cake slice"
	desc = "A frosted cake slice with a rich citrus taste. A thick layer of lemon filling give it a sweet, tangy and zesty flavour."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "lemoncake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"lemon"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Lime cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/limecake
	name = "lime cake"
	desc = "A frosted cake with a rich citrus taste. A thick layer of lime filling give it a sweet, tangy and zesty flavour."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "limecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/limecakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"lime"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/limecakeslice
	name = "lime cake slice"
	desc = "A frosted cake slice with a rich citrus taste. A thick layer of lime filling give it a sweet, tangy and zesty flavour."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "limecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"lime"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

/*
//	..................   Manabloom cake   ..................
// For whatever reason, this considerably dull the taste in favor of revitalizing the eater's energy.
// It is intended only for characters with the ability to tap into the arcane to make this cake.

/obj/item/reagent_containers/food/snacks/rogue/manacake
	name = "mana cake"
	desc = "Frosted cake filled with arcyne potential. Lighter than it should be and rarely made for its taste."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "manacake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/manacakeslice
	list_reagents = list(/datum/reagent/medicine/manapot = 32, /datum/reagent/consumable/nutriment = 24)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("hollow sweetness"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_POOR
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	//eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/manacakeslice
	name = "mana cake slice"
	desc = "Frosted cake slice with dwindling arcyne potential. Lighter than it should be and rarely consumed for its taste."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "manacake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("hollow sweetness"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	//eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG
*/

//	..................   Mentha cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/menthacake
	name = "mentha cake"
	desc = "A frosted cake with the fresh taste of mentha and the wyld forests."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "menthacake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/menthacakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"fresh herbaceousness"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/menthacakeslice
	name = "mentha cake slice"
	desc = "A frosted cake slice with the fresh taste of mentha and the wyld forests."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "menthacake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"fresh herbaceousness"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Peace cake   ..................
// Peaceflower cake has the drawback of turning its eater into a pacifist for a few minutes.
/obj/item/reagent_containers/food/snacks/rogue/peacecake
	name = "peace cake"
	desc = "Imbued with the miraculous powers of its decorative bud, a frosted cake said to be shared between lovers or after mourning."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "peacecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/peacecakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"peace"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/peacecake/On_Consume(mob/living/eater)
	if(iscarbon(eater))
		eater.apply_status_effect(/datum/status_effect/buff/peacecake)
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/peacecakeslice
	name = "peace cake slice"
	desc = "Imbued with the remaining powers of its decorative bud, a frosted cake slice said to be shared between lovers or after mourning."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "peacecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"peace"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/peacecakeslice/On_Consume(mob/living/eater)
	if(iscarbon(eater))
		eater.apply_status_effect(/datum/status_effect/buff/peacecake)
	return ..()

//	..................   Raspberry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/raspberrycake
	name = "raspberry cake"
	desc = "A frosted cake topped with beautiful raspberries. A fruity treat often paired with blackberry cake."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "raspberrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/raspberrycakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"raspberry"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/raspberrycakeslice
	name = "raspberry cake slice"
	desc = "A frosted slice of cake topped with beautiful raspberries. A fruity treat often paired with blackberry cake."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "raspberrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"raspberry"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Rocknut cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	name = "rocknut cake"
	desc = "A simple frosted cake with a spread of nuts. Its mild stimulant properties makes-up most of its popularity."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "rocknutcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/rocknutcakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 1)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"nutty"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/rocknutcake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Chopping and mixing-in the [I]..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/applenutcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/rocknutcakeslice
	name = "rocknut cake slice"
	desc = "A simple frosted cake slice with a spread of nuts. Its mild stimulant properties makes-up most of its popularity."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "rocknutcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/consumable/acorn_powder = 1)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"nutty"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Strawberry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/strawberrycake
	name = "strawberry cake"
	desc = "Sweetened strawberries and strawberry filling over a tender frosted cake, simple and elegant."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "strawberrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strawberrycakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"strawberry"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/strawberrycakeslice
	name = "strawberry cake slice"
	desc = "A singular sweetened strawberry and strawberry filling over a tender frosted cake slice, simple and elegant."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "strawberrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"strawberry"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Tangerine cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/tangerinecake
	name = "tangerine cake"
	desc = "A frosted cake with a rich citrus taste. A thick layer of tangerine filling give it a sweet, tangy and zesty flavour."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "tangerinecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/tangerinecakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"tangerine"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/tangerinecakeslice
	name = "tangerine cake slice"
	desc = "A frosted cake slice with a rich citrus taste. A thick layer of tangerine filling give it a sweet, tangy and zesty flavour."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "tangerinecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"sugary frosting"=1,"tangerine"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Honey cake (Zybantu)   ..................
//	..................           Raw            ..................
/obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked
	name = "unbaked cake"
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "honeycake"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/hcake
	cooked_smell = /datum/pollutant/food/honey_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY | SUGAR
	rotprocess = SHELFLIFE_DECENT

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/hcake
	name = "zybantine cake"
	desc = "Cake glazed with honey in the famous Zybantium fashion for a delicious sweet treat."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "honeycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/hcakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"delicious honeyfrosting"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/hcakeslice
	name = "zybantine cake slice"
	desc = "A slice of cake glazed with honey in the famous zybantine fashion, a delicious sweet treat."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "honeycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"delicious honeyfrosting"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Cheesecake   ..................
//	..................      Raw       ..................
/obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked
	name = "unbaked cake of cheese"
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "cheesecake"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/ccake
	cooked_smell = /datum/pollutant/food/cheese_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY
	rotprocess = SHELFLIFE_DECENT

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/ccake
	name = "cheesecake"
	desc = "Humenity's favored creation."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cheesecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/ccakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"creamy cheese"=1)
	foodtype = GRAIN | DAIRY
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/ccakeslice
	name = "cheesecake slice"
	desc = "A simple slice of humenity's favored creation."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cheesecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1,"creamy cheese"=1)
	faretype = FARE_FINE
	cooked_type = null
	foodtype = GRAIN | DAIRY
	bitesize = 2
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG
