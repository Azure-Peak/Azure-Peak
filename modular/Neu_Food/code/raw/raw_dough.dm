// Dough, and variants thereof for usage in making various baked food items.
// Doesn't include raw variants of bread and others
/*	.................   Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/dough_base
	name = "unfinished dough"
	desc = "With a little more ambition, you will conquer."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi' // I know but we are following Raw as a pre-pender
	icon_state = "dough_base"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/dough_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/flour))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading in more powder..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/dough
	name = "dough"
	desc = "The triumph of all bakers. Smother with butter, roll it flat with a rolling pin, speckle it with apples and raisins.. the possibilities are truly endless!"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dough"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/dough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Kneading butter into the dough..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/butterdough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading the dough and adding raisins..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/rbread_half(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading the dough and adding apple slices..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/abread_half(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading the dough into an elongated shape..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Rolling the dough flat and thin..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/flatdough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else
		return ..()

/*	.................   Flatdough  ................... */
/obj/item/reagent_containers/food/snacks/rogue/flatdough
	name = "flatdough"
	desc = "Flattened dough, bare for all to see. A sharp edge can prepare the lines for a sheet of crackerdough, while a smearing of tomatoes can set the stage for a peasant's feast."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "flatdough"
	slices_num = null
	slice_batch = FALSE
	slice_path = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/flatdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(I.get_sharpness())
		if(isturf(loc)&& (found_table))
			playsound(user, 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Scoring lines into [src]..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to score it into crackerdough!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tomato))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Meticulously crushing the tomatoes into a thick, chunky sauce..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to smear the flatdough with sauced tomatoes!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Crushing the sliced tomatoes into a thick, velvety sauce..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to smear the flatdough with sauced tomatoes!"))
	else
		return ..()

/*	.................   Tomatoplate  ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw
	name = "uncooked tomatoplate"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_base"
	desc = "Flatdough with a healthy smearing of sauced tomatoes upon its surface. A sprinkling of fresh cheese should round it all out."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Ripping the fresh cheese apart and sprinkling the tomato-sauced flatdough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to sprinkle the tomato-sauced flatdough with cheese!"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	name = "uncooked tomatoplate with cheese"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes - and sprinkling of fresh cheese - upon its surface. It is ready to be baked into a delicious tomatoplate, lest one wishes to further adorn it with sausages, fillets, onions, pears, or truffles."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Topping the becheesed tomatoplate with sausage..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to finish it off with some toppings!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/fish) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Topping the becheesed tomatoplate with fillets of fish..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_fish(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to finish it off with some toppings!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/truffles))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Topping the becheesed tomatoplate with truffles..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_truffles(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to finish it off with some toppings!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toxicshrooms))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Topping the becheesed tomatoplate with truffles..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_poisontruffles(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to finish it off with some toppings!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/onion/rogue))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Meticulously tearing the whole onion up, and spreading its sum onto the becheesed tomatoplate..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to finish it off with some toppings!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Topping the becheesed tomatoplate with sliced onions..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to finish it off with some toppings!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/pear))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Topping the becheesed tomatoplate with pears..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to finish it off with some toppings!"))
	else
		return ..()

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_sausage
	name = "uncooked tomatoplate with sausages"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "sausage_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of sliced sausages upon its surface. It is ready to be baked into a deliciously rich tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_meat
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate
	foodtype = GRAIN | FRUIT | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_fish
	name = "uncooked tomatoplate with fishes"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "fish_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of filleted fishes upon its surface. It is ready to be baked into a deliciously oiled tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_fish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate
	foodtype = GRAIN | FRUIT | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_truffles
	name = "uncooked tomatoplate with truffles"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadant tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/truffletomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_poisontruffles
	name = "uncooked tomatoplate with truffles"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadant tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	list_reagents = list(/datum/reagent/berrypoison = 5)
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisontruffletomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion
	name = "uncooked tomatoplate with onions"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "onion_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of ringed onions upon its surface. It is ready to be baked into a deliciously earthsome tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_onion
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/oniontomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear
	name = "uncooked tomatoplate with pears"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of juicy pears upon its surface. It is ready to be baked into a deliciously creative tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_pear
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/peartomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/*	.................   Smalldough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/doughslice
	name = "smalldough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "doughslice"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bun
	cooked_smell = /datum/pollutant/food/bun
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/doughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Adding fresh cheese..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/doughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Combining dough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/astrata))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Pressing the shape of Astrata's cross into the bun..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross)) // This is gonna be messy cuz other are subtypes
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Pressing the shape of the psycross into the bun..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/dough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading the dough into an elongated shape..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else
		return ..()

/*	.................   Butterdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdough
	name = "butterdough"
	desc = "What is a triumph, to a legacy?"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough"
	color = "#feffc1"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bookbread
	cooked_smell = /datum/pollutant/food/bookbread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/butterdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the egg into the butterdough, shaping it into a cake..."))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/cake_base(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/kitchen/spoon))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Further spreading the butterdough out, shaping it into a muffin..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/muffindough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to shape it into a muffin!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed) || istype(I, /obj/item/reagent_containers/food/snacks/pumpkinspice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Adding pumpkin to the butterdough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to prepare it!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/pear))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the pears into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/pearbread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/plum))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the plums into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/lemon))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the lemons into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the tangerines into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the blackberries into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the raspberries into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the jackberries into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the jackberries into the butterdough, shaping it into a fruity loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/poisonberrybread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/chocolate) || istype(I, /obj/item/reagent_containers/food/snacks/chocolate/slice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working the chocolate into the butterdough, shaping it into a sweet loaf..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with chocolate!"))
	else
		return ..()

//

/obj/item/reagent_containers/food/snacks/rogue/pearbread_uncooked
	name = "pear-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_pear"
	desc = "A mound of pear-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked
	name = "plum-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_plum"
	desc = "A mound of plum-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked
	name = "lemon-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_lemon"
	desc = "A mound of lemon-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked
	name = "tangerine-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_tangerine"
	desc = "A mound of tangerine-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked
	name = "blackberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_blackberry"
	desc = "A mound of blackberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked
	name = "raspberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_raspberry"
	desc = "A mound of raspberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked
	name = "jackberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "A mound of jacksberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybread_uncooked
	name = "jackberry-stuffed butterdough" //Like pies, these are Evil. Indistinguishable from traditional jackberried variants, until eaten.
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "A mound of jacksberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	list_reagents = list(/datum/reagent/berrypoison = 12)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked
	name = "chocolate-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_chocolate"
	desc = "A mound of chocolate-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/chocolate_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread
	foodtype = GRAIN | DAIRY

/*	.................   Butterdough Piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	name = "butterdough piece"
	desc = "A slice of pedigree, to create lines of history."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdoughslice"
	color = "#feffc1"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pastry
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL

// Dough + rolling pin on table = flat dough. RT got some similar proc for this.
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Flattening [src]..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/piedough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/kitchen/spoon))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Pressing a divot into [src]..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tartdough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed) || istype(I, /obj/item/reagent_containers/food/snacks/pumpkinspice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Adding pumpkin to the butterdough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinball_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to prepare it!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Adding tangerines to the butterdough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tangerinebiscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tangerinebiscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/plum))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Adding raisins to the butterdough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/plumbiscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/plumbiscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Adding raisins to the dough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with fruits!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/chocolate) || istype(I, /obj/item/reagent_containers/food/snacks/chocolate/slice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Adding chocolate to the dough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chocolatebiscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to stuff it with chocolate!"))
	if(I.get_sharpness())
		if(!isdwarf(user))
			to_chat(user, span_warning("You lack knowledge of dwarven pastries!"))
			return
		else
			if(isturf(loc)&& (found_table))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_notice("Cutting the butterdough in strips and making a prezzel..."))
				if(do_after(user,short_cooktime, target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw(loc)
					qdel(src)
			else
				to_chat(user, span_warning("You need to put [src] on a table to cut it!"))
	else
		..()

/*	.................   Muffindough Piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/muffindough
	name = "muffindough"
	desc = "It's muffin time!"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "muffindough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin
	cooked_smell = /datum/pollutant/food/muffin
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................   Piedough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/piedough
	name = "piedough"
	desc = "The beginning of greater things to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "piedough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/piedough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/truffles))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/crab))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue))//This produces 3 instead of 2 so it'd be obvious go to.
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/piedough/proc/prepare_handpie(obj/item/I, mob/living/user, handpie_path)
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("Making a handpie..."))
	if(do_after(user,short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		var/handpie = new handpie_path(get_turf(user))
		user.put_in_hands(handpie)
		qdel(I)
		qdel(src)

/*	.................   Strudel Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudeldough
	name = "strudeldough"
	desc = "An empty shell of a greatness to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strudel_raw"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	process_step = 1

/obj/item/reagent_containers/food/snacks/rogue/strudeldough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Filling the dough with apples.."))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "half-filled strudel"
			desc = "A strudel form mostly filled with apples. Still missing its other part."
			process_step = 2
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut))
		if(process_step != 2)
			return
		to_chat(user, span_notice("Finishing the filling with rocknut.."))
		if(do_after(user, short_cooktime, target = src))
			name = "filled strudel"
			desc = "A strudel filled to the brim with apples and nuts. Now to only bake it."
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/strudel
			process_step = 3
			qdel(I)
			return
	return ..()

/*	.................   Tartdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/tartdough
	name = "dotted tartdough"
	desc = "A hollow bowl that has yet to show its fullest potential."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dottart_base"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	process_step = 1

/obj/item/reagent_containers/food/snacks/rogue/tartdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with tangerines.."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_tangerine(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to fill it up!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/plum))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with plums.."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_plum(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to pack the fillings in!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with blackberries.."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_blackberry(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to pack the fillings in!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with raspberries.."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_raspberry(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to pack the fillings in!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with strawberries.."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_strawberry(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to pack the fillings in!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/pear))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with pears.."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_pear(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to pack the fillings in!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with apple slices.."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_apple(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to pack the fillings in!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("Filling the dotted tartdough with.. golden apple slices..?"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to pack the fillings in!"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_tangerine
	name = "uncooked dot tart with tangerines"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "tangerine_dottart_base"
	desc = "A hollow bowl of butterdough, filled with delicious tangerines. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/tangerine
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_plum
	name = "uncooked dot tart with plums"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "plum_dottart_base"
	desc = "A hollow bowl of butterdough, filled with homely plums. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/plum
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_blackberry
	name = "uncooked dot tart with blackberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "blackberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with sour blackberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/blackberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_raspberry
	name = "uncooked dot tart with raspberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "raspberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with tart raspberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/raspberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_strawberry
	name = "uncooked dot tart with strawberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strawberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with sweet strawberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/strawberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_pear
	name = "uncooked dot tart with pears"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_dottart_base"
	desc = "A hollow bowl of butterdough, filled with honeyed pears. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/pear
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_apple
	name = "uncooked dot tart with apples"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "apple_dottart_base"
	desc = "A hollow bowl of butterdough, filled with apple slices. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/apple
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple
	name = "uncooked dot tart with ambrosia"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "gapple_dottart_base"
	desc = "A hollow bowl of butterdough, filled with a divine fruit. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple
	list_reagents = list(/datum/reagent/medicine/stronghealth = 6) //Because you're going to want something after vomiting up all your guts up for eating raw dough.
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 100, "size" = 1))
