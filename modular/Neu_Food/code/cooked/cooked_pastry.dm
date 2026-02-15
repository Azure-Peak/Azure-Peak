// For definition - any non-bread premium product dough that is also not a cake.
/*	.................   Pastry   ................... */
/obj/item/reagent_containers/food/snacks/rogue/pastry
	name = "pastry"
	desc = "Crispy, buttery, and delightfully flaky. A favorite treat among children and sweetlovers."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pastry"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	tastes = list("crispy butterdough" = 1)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw
	name = "uncooked raisin biscuit"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "biscuit_raw"
	color = "#ecce61"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/biscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/biscuit
	name = "raisin biscuit"
	desc = "A crispy buttery pastry with chewy raisins inside."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "biscuit"
	faretype = FARE_POOR
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + SNACK_POOR)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("crispy butterdough" = 1, "raisins" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff

// MISSING RECIPE
/obj/item/reagent_containers/food/snacks/rogue/cookie		//It's a biscuit.......
	name = "cookie of smiles"
	desc = "It looks less like a happy smile and more like a tortured grimace."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookie"
	color = "#ecce61"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw
	name = "uncooked prezzel"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "prezzel_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/prezzel
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/prezzel
	name = "prezzel"
	desc = "The next best thing after sliced bread. The recipe is a closely guarded secret among the dwarves. So dire is their conviction that not even the Inquisition's most agonizing methods could force them to reveal it."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "prezzel"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_FINE
	tastes = list("crispy butterdough" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.............   Pumpkin balls   ................ */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinball_raw
	name = "uncooked pumpkin ball"
	desc = "A simple "
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pumpkinball"
	color = "#d17624"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	w_class = WEIGHT_CLASS_SMALL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	name = "pumpkin balls"
	desc = "Crispy and soft ball of dough mixed with pumpkin. A surprisingly nice snack."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinball3"
	faretype = FARE_FINE
	filling_color = "#d17624"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_SMALL
	bitesize = 3
	portable = TRUE
	tastes = list("crispy butterdough" = 1, "pumpkin" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pumpkinball/On_Consume(mob/living/eater)
	. = ..()
	if(bitecount == 1)
		icon_state = "pumpkinball2"
	else if(bitecount == 2)
		icon_state = "pumpkinball1"
		name = "pumpkin ball"

/*	.............   Pumpkin loaf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw
	name = "raw pumpkin loaf"
	desc = "Into the oven you go!"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pumpkindough"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	name = "pumpkin loaf"
	desc = "A loaf of sweetbread baked into a shape worthy of its name. Pumpkin loaves are surprising desserts, easily shared."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinloaf6"
	bitesize = 6
	slices_num = 6
	portable = FALSE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pumpkinloafslice
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweetbread" = 1,"pumpkin" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf/update_icon()
	if(slices_num)
		icon_state = "pumpkinloaf[slices_num]"
	else
		icon_state = "pumpkinloaf_slice"

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)
	update_icon()

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloafslice
	name = "pumpkin loaf slice"
	desc = "Soft and chewy. It's surprisingly light despite its origin."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pumpkinloaf_slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_NEUTRAL
	cooked_type = null
	tastes = list("sweetbread" = 1,"pumpkin" = 1)
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw
	name = "raw handpie"
	desc = "To the oven with you!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "handpie_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom
	name = "raw mushroom handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	foodtype = GRAIN | VEGETABLES
	tastes = list("mushrooms" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish
	name = "raw fish handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	foodtype = GRAIN | MEAT
	tastes = list("fish" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat
	name = "raw meat handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	foodtype = GRAIN | MEAT
	tastes = list("meat" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab
	name = "raw crab handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	foodtype = GRAIN | MEAT
	tastes = list("crab" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry
	name = "raw berry handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	foodtype = GRAIN | FRUIT
	tastes = list("berry" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/poison
	name = "raw berry handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)
	foodtype = GRAIN | FRUIT
	tastes = list("bitter berry" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple
	name = "raw apple handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	foodtype = GRAIN | FRUIT
	tastes = list("apple" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato
	name = "raw potato handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	foodtype = GRAIN | VEGETABLES
	tastes = list("potato" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage//These two are classics no idea how it didn't already exist.
	name = "raw cabbage handpie"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	foodtype = GRAIN | VEGETABLES
	tastes = list("cabbage" = 1)

/obj/item/reagent_containers/food/snacks/rogue/handpie
	name = "handpie"
	desc = "The dwarves call this 'pierogi' in their dialect. It'll stay fresh for a good long while until the crust is bitten."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "handpie"
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	bitesize = 4
	faretype = FARE_FINE
	bonus_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION+MINCE_NUTRITION)
	tastes = list("crispy dough" = 1)
	rotprocess = null
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/handpie/mushroom
	name = "mushroom handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	name = "fish handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	name = "meat handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	name = "potato handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	name = "cabbage handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	name = "crab handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	name = "berry handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	name = "berry handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	name = "apple handpie"

/obj/item/reagent_containers/food/snacks/rogue/handpie/On_Consume(mob/living/eater)
	..()
	icon_state = "handpie[bitecount]"
	if(bitecount == 1)
		rotprocess = SHELFLIFE_DECENT
		addtimer(CALLBACK(src, PROC_REF(begin_rotting)), 20, TIMER_CLIENT_TIME)

/*	.................   Muffins   ................... */
/obj/item/reagent_containers/food/snacks/rogue/muffin
	name = "muffin"
	desc = "Simple to prepare and enjoyed by everyone. Treat in a mushroom shaped package. Could do with something on top."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "muffin"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	tastes = list("crispy butterdough" = 1)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/muffin/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("You start to glaze the muffin with cheese..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("You start to glaze the muffin with honey..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/muffin/honey(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to prepare it!"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/muffin/cheese
	name = "raw cheese muffin"
	desc = "A mushroom shaped treat for whole topped off with cheese. Still needs to be baked!"
	icon_state = "muffin_cheese_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	name = "cheese muffin"
	desc = "A mushroom shaped treat for whole topped off with cheese. Fit for a yeoman."
	icon_state = "muffin_cheese"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION)
	tastes = list("crispy butterdough" = 1, "cheese" = 1)
	faretype = FARE_FINE
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/muffin/honey
	name = "raw honey muffin"
	desc = "A mushroom shaped treat for whole topped off with honey. Still needs to be baked!"
	icon_state = "muffin_honey_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/honey/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/honey/baked
	name = "honey muffin"
	desc = "A mushroom shaped treat for whole topped off with honey. Fit for a burgher."
	icon_state = "muffin_honey"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	cooked_smell = /datum/pollutant/food/muffin
	faretype = FARE_FINE
	cooked_type = null

/*	.................   Strudel   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudel
	name = "strudel"
	desc = "The peak of Grenzelhoftian peasant food - an elongated pastry filled with apple paste and nuts is sure to keep the hunger cramps away."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strudel"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION*2)
	tastes = list("crispy apples" = 1, "rocknut" = 1)
	foodtype = GRAIN | FRUIT
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strudelslice
	slice_batch = TRUE
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/strudelslice
	name = "strudel slice"
	desc = "A slice of tasty apple goodness - just looking at it makes your mouth wet."
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strudel_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("crispy apples" = 1, "rocknut" = 1)
	foodtype = GRAIN | FRUIT
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = null
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/strudel/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I,  /obj/item/reagent_containers/food/snacks/sugar))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("You start to coat the strudel in sugar..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudel/sugar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/strudel/sugar
	name = "coated strudel"
	desc = "The peak of Grenzelhoftian peasant food - an elongated pastry filled with apple paste and nuts is sure to keep the hunger cramps away. This one even has sugar coating!"
	icon_state = "strudel_sugar"
	tastes = list("crispy apples" = 1, "rocknut" = 1 ,"sugar" = 1)
	faretype = FARE_LAVISH
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strudelslice/sugar

/obj/item/reagent_containers/food/snacks/rogue/strudelslice/sugar
	name = "coated strudel slice"
	desc = "A slice of tasty apple goodness - just looking at it makes your mouth wet. If you had some cream this would make it a perfect gift to an inquisitor."
	icon_state = "strudel_sugar_slice"
	tastes = list("crispy apples" = 1, "rocknut" = 1 ,"sugar" = 1)
	faretype = FARE_LAVISH
