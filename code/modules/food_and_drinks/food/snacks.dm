/** # Snacks

Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units. Generally speaking, you don't want to go over 40
total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use omnizine). On use
effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
the bites. No more contained reagents = no more bites.

Here is an example of the new formatting for anyone who wants to add more food items.
```
/obj/item/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
	name = "Xenoburger"													//Name that displays in the UI.
	desc = ""						//Duh
	icon_state = "xburger"												//Refers to an icon in food.dmi
/obj/item/reagent_containers/food/snacks/xenoburger/Initialize()		//Don't mess with this. | nO I WILL MESS WITH THIS
	. = ..()														//Same here.
	reagents.add_reagent(/datum/reagent/xenomicrobes, 10)						//This is what is in the food item. you may copy/paste
	reagents.add_reagent(/datum/reagent/consumable/nutriment, 2)							//this line of code for all the contents.
	bitesize = 3													//This is the amount each bite consumes.
```

All foods are distributed among various categories. Use common sense.
*/
/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = ""
	icon = 'icons/obj/food/food.dmi'
	icon_state = null
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	obj_flags = UNIQUE_RENAME
	grind_results = list() //To let them be ground up to transfer their reagents
	possible_item_intents = list(/datum/intent/food)
	var/bitesize = 3
	var/bitecount = 0
	var/trash = null
	var/slice_path    // for sliceable food. path of the item resulting from the slicing
	var/slice_bclass = BCLASS_CUT
	var/slices_num
	var/slice_name
	var/slice_batch = TRUE
	var/eatverb
	var/dried_type = null
	var/dry = 0
	var/dunkable = FALSE // for dunkable food, make true
	var/dunk_amount = 10 // how much reagent is transferred per dunk
	var/cooked_type = null  //for overn cooking
	/// How palatable is this food for a given social class? Also influences food quality
	var/faretype = FARE_IMPOVERISHED
	/// If false, this will inflict mood debuffs on nobles who eat it without being near a table.
	var/portable = TRUE
	var/fried_type = null	//instead of becoming
	var/deep_fried_type = null
	var/filling_color = "#FFFFFF" //color to use when added to custom food.
	var/custom_food_type = null  //for food customizing. path of the custom food to create
	var/junkiness = 0  //for junk food. used to lower human satiety.
	var/list/bonus_reagents //the amount of reagents (usually nutriment and vitamin) added to crafted/cooked snacks, on top of the ingredients reagents.
	var/customfoodfilling = 1 // whether it can be used as filling in custom food
	var/list/tastes  // for example list("crisps" = 2, "salt" = 1)

	var/cooking = 0
	var/cooktime = 0
	var/burning = 0
	var/burntime = 5 MINUTES
	var/warming = 5 MINUTES		//if greater than 0, have a brief period where the food buff applies while its still hot

	var/cooked_color = "#91665c"
	var/burned_color = "#302d2d"

	var/ingredient_size = 1
	var/eat_effect
	var/extra_eat_effect //ideally the eat_effect should just be able to work with lists, but for now, this'll do
	var/rotprocess = FALSE
	var/become_rot_type = null

	var/fertamount = 50

	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	smeltresult = /obj/item/ash
	//Placeholder for effect that trigger on eating that aren't tied to reagents.

	var/cooked_smell


/datum/intent/food
	name = "feed"
	noaa = TRUE
	icon_state = "infeed"
	rmb_ranged = TRUE
	no_attack = TRUE

/datum/intent/food/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_green("[user] beckons [M] with [masteritem]."), span_green("I beckon [M] with [masteritem]."), ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_green("[user] beckons me with [masteritem]."))
		M.food_tempted(masteritem, user)
	return

/obj/item/reagent_containers/food/snacks/fire_act(added, maxstacks)
	burning(1 MINUTES)

/obj/item/reagent_containers/food/snacks/Initialize()
	if(rotprocess)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(begin_rotting)))
	if(cooked_type || fried_type)
		cooktime = 30 SECONDS
	..()

/obj/item/reagent_containers/food/snacks/proc/begin_rotting()
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/process()
	..()
	if(rotprocess)
		if(!istype(loc, /obj/structure/closet/crate/chest) && ! istype(loc, /obj/item/cooking/platter)  && !istype(loc, /obj/structure/roguemachine/vendor) && !istype (loc, /obj/item/storage/backpack/rogue/artibackpack)&& !istype (loc, /obj/structure/table/cooling))
			if(!locate(/obj/structure/table) in loc)
				warming -= 20 //ssobj processing has a wait of 20
			else
				if(locate(/obj/structure/table/cooling) in loc)
					warming -= 0
				else
					warming -= 10
			if(warming < (-1*rotprocess))
				if(become_rotten())
					STOP_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/can_craft_with()
	if(eat_effect == /datum/status_effect/debuff/rotfood)
		return FALSE
	return ..()

/obj/item/reagent_containers/food/snacks/proc/become_rotten(to_color = TRUE, to_rename = TRUE)
	if(isturf(loc) && istype(get_area(src),/area/rogue/under/town/sewer))
		if(!istype(src,/obj/item/reagent_containers/food/snacks/smallrat))
			new /obj/item/reagent_containers/food/snacks/smallrat(loc)
			qdel(src)
	if(become_rot_type)
		if(ismob(loc))
			return FALSE
		else
			var/obj/item/reagent_containers/NU = new become_rot_type(loc)
			var/atom/movable/location = loc
			NU.reagents.clear_reagents()
			reagents.trans_to(NU.reagents, reagents.maximum_volume)
			qdel(src)
			if(!location || !SEND_SIGNAL(location, COMSIG_TRY_STORAGE_INSERT, NU, null, TRUE, TRUE))
				NU.forceMove(get_turf(NU.loc))
			record_round_statistic(STATS_FOOD_ROTTED)
			return TRUE
	else
		if(to_color)
			color = "#6c6897"
		var/mutable_appearance/rotflies = mutable_appearance('icons/roguetown/mob/rotten.dmi', "rotten")
		add_overlay(rotflies)
		if(to_rename)
			name = "rotten [initial(name)]"
		eat_effect = /datum/status_effect/debuff/rotfood
		slices_num = 0
		slice_path = null
		cooktime = 0
		if(istype(src.loc, /obj/item/cooking/platter/))
			src.loc.update_icon()
		record_round_statistic(STATS_FOOD_ROTTED)
		return TRUE


/obj/item/proc/cooking(input as num)
	return

// Cook a food, burninput is separate so that burning doesn't scale up with skills
/obj/item/reagent_containers/food/snacks/cooking(input as num, burninput, atom/A)
	if(!input)
		return
	if(cooktime)
		var/added_input = input
		// Pick flat burninput instead of skill-scaled input so high cooking skill doesn't make food burn faster
		if(!cooked_type && !fried_type)
			added_input = burninput
		if(cooking < cooktime)
			cooking = cooking + added_input
			if(cooking >= cooktime)
				return heating_act(A)
			warming = 5 MINUTES
			return
	burning(burninput)

/obj/item/reagent_containers/food/snacks/heating_act(atom/A)
	if(istype(A,/obj/machinery/light/rogue/oven))
		var/obj/item/result
		if(cooked_type)
			result = new cooked_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_food(result, 1)
		return result
	if(istype(A,/obj/machinery/light/rogue/hearth) || istype(A,/obj/machinery/light/rogue/firebowl) || istype(A,/obj/machinery/light/rogue/campfire) || istype(A,/obj/machinery/light/rogue/hearth/mobilestove))
		var/obj/item/result
		if(fried_type)
			result = new fried_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_food(result, 1)
		return result
	var/obj/item/result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
	initialize_cooked_food(result, 1)
	return result

/obj/item/proc/burning(input as num)
	return

/obj/item/reagent_containers/food/snacks/burning(input as num) //used for pans without oil, skips the cooking stage
	if(!input)
		return
	warming = 5 MINUTES
	if(burntime)
		burning = burning + input
		if(eat_effect != /datum/status_effect/debuff/burnedfood)
			if(burning >= burntime)
				color = burned_color
				name = "burned [name]"
				slice_path = null
				eat_effect = /datum/status_effect/debuff/burnedfood
		if(burning > (burntime * 2))
			burn()

/obj/item/reagent_containers/food/snacks/add_initial_reagents()
	create_reagents(volume)
	if(tastes && tastes.len)
		if(list_reagents)
			for(var/rid in list_reagents)
				var/amount = list_reagents[rid]
				if(rid == /datum/reagent/consumable/nutriment || rid == /datum/reagent/consumable/nutriment/vitamin)
					reagents.add_reagent(rid, amount, tastes.Copy())
				else
					reagents.add_reagent(rid, amount)
	else
		..()

/obj/item/reagent_containers/food/snacks/proc/On_Consume(mob/living/eater)
	if(!eater)
		return

	var/apply_effect = TRUE
	// check to see if what we're eating is appropriate fare for our "social class" (aka nobles shouldn't be eating sticks of butter you troglodytes)
	if (ishuman(eater))
		var/mob/living/carbon/human/human_eater = eater
		if(human_eater.culinary_preferences)
			var/favorite_food_type = human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD]
			if(favorite_food_type == type)
				if(human_eater.add_stress(/datum/stressevent/favourite_food))
					to_chat(human_eater, span_green("Yum! My favorite food!"))
			else if(ispath(type, favorite_food_type))
				var/obj/item/reagent_containers/food/snacks/favorite_food_instance = favorite_food_type
				var/favorite_food_name = initial(favorite_food_instance.name)
				if(favorite_food_name == name)
					if(human_eater.add_stress(/datum/stressevent/favourite_food))
						to_chat(human_eater, span_green("Yum! My favorite food!"))
			else
				var/obj/item/reagent_containers/food/snacks/favorite_food_instance = favorite_food_type
				var/slice_path = initial(favorite_food_instance.slice_path)
				if(slice_path && type == slice_path)
					if(human_eater.add_stress(/datum/stressevent/favourite_food))
						to_chat(human_eater, span_green("Yum! My favorite food!"))

			var/hated_food_type = human_eater.culinary_preferences[CULINARY_HATED_FOOD]
			if(hated_food_type == type)
				if(human_eater.add_stress(/datum/stressevent/hated_food))
					to_chat(human_eater, span_red("Yuck! My hated food!"))
			else if(ispath(type, hated_food_type))
				var/obj/item/reagent_containers/food/snacks/hated_food_instance = hated_food_type
				var/hated_food_name = initial(hated_food_instance.name)
				if(hated_food_name == name)
					if(human_eater.add_stress(/datum/stressevent/hated_food))
						to_chat(human_eater, span_red("Yuck! My hated food!"))
			else
				var/obj/item/reagent_containers/food/snacks/hated_food_instance = hated_food_type
				var/slice_path = initial(hated_food_instance.slice_path)
				if(slice_path && type == slice_path)
					if(human_eater.add_stress(/datum/stressevent/hated_food))
						to_chat(human_eater, span_red("Yuck! My hated food!"))

		if (!HAS_TRAIT(human_eater, TRAIT_NASTY_EATER) && !HAS_TRAIT(human_eater, TRAIT_ORGAN_EATER))
			if (human_eater.is_noble())
				if (!portable)
					if(!(locate(/obj/structure/table) in range(1, eater)))
						eater.add_stress(/datum/stressevent/noble_ate_without_table) // look i just had to okay?
						if (prob(25))
							to_chat(eater, span_red("I should really eat this at a table..."))
				switch (faretype)
					if (FARE_IMPOVERISHED)
						eater.add_stress(/datum/stressevent/noble_impoverished_food)
						to_chat(eater, span_red("This is disgusting... how can anyone eat this?"))
						if (eater.nutrition >= NUTRITION_LEVEL_STARVING)
							eater.taste(reagents)
							human_eater.add_nausea(34)
							return
						else
							if (eater.has_stress_event(/datum/stressevent/noble_impoverished_food))
								eater.add_stress(/datum/stressevent/noble_desperate)
							apply_effect = FALSE
					if (FARE_POOR to FARE_NEUTRAL)
						eater.add_stress(/datum/stressevent/noble_bland_food)
						if (prob(25))
							to_chat(eater, span_red("This is rather bland. I deserve better food than this..."))
						apply_effect = FALSE
					if (FARE_FINE)
						eater.remove_stress(/datum/stressevent/noble_bland_food)
					if (FARE_LAVISH)
						eater.remove_stress(/datum/stressevent/noble_bland_food)
						eater.add_stress(/datum/stressevent/noble_lavish_food)
						if (prob(25))
							to_chat(eater, span_green("Ah, food fit for my title."))

			// yeomen and courtiers are also used to a better quality of life but are way less picky
			if (human_eater.is_yeoman() || human_eater.is_courtier())
				switch (faretype)
					if (FARE_IMPOVERISHED)
						eater.add_stress(/datum/stressevent/noble_bland_food)
						apply_effect = FALSE
						if (prob(25))
							to_chat(eater, span_red("This is rather bland. I deserve better food than this..."))
					if (FARE_POOR to FARE_LAVISH)
						eater.remove_stress(/datum/stressevent/noble_bland_food)

	if(eat_effect && apply_effect)
		eater.apply_status_effect(eat_effect)
		if(extra_eat_effect)
			eater.apply_status_effect(extra_eat_effect)
	eater.taste(reagents)

	if(!reagents.total_volume)
		if(eat_effect == /datum/status_effect/debuff/rotfood)
			SEND_SIGNAL(eater, COMSIG_ROTTEN_FOOD_EATEN, src)
		var/mob/living/location = loc
		var/obj/item/trash_item = generate_trash(location)
		qdel(src)
		if(istype(location))
			location.put_in_hands(trash_item)

/obj/item/reagent_containers/food/snacks/attack_self(mob/user)
	return


/obj/item/reagent_containers/food/snacks/attack(mob/living/M, mob/living/user, def_zone)
	if(user.used_intent.type == INTENT_HARM)
		return ..()
	if(!eatverb)
		eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	if(iscarbon(M))
		if(!canconsume(M, user))
			return FALSE

		var/fullness = M.nutrition + 10
		for(var/datum/reagent/consumable/C in M.reagents.reagent_list) //we add the nutrition value of what we're currently digesting
			fullness += C.nutriment_factor * C.volume / C.metabolization_rate

		if(M == user)								//If you're eating it myself.
/*			if(junkiness && M.satiety < -150 && M.nutrition > NUTRITION_LEVEL_STARVING + 50 && !HAS_TRAIT(user, TRAIT_VORACIOUS))
				to_chat(M, span_warning("I don't feel like eating any more junk food at the moment!"))
				return FALSE
			else if(fullness <= 50)
				user.visible_message(span_notice("[user] hungrily [eatverb]s \the [src], gobbling it down!"), span_notice("I hungrily [eatverb] \the [src], gobbling it down!"))
			else if(fullness > 50 && fullness < 150)
				user.visible_message(span_notice("[user] hungrily [eatverb]s \the [src]."), span_notice("I hungrily [eatverb] \the [src]."))
			else if(fullness > 150 && fullness < 500)
				user.visible_message(span_notice("[user] [eatverb]s \the [src]."), span_notice("I [eatverb] \the [src]."))
			else if(fullness > 500 && fullness < 600)
				user.visible_message(span_notice("[user] unwillingly [eatverb]s a bit of \the [src]."), span_notice("I unwillingly [eatverb] a bit of \the [src]."))
			else if(fullness > (600 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				user.visible_message(span_warning("[user] cannot force any more of \the [src] to go down [user.p_their()] throat!"), span_warning("I cannot force any more of \the [src] to go down your throat!"))
				return FALSE
			if(HAS_TRAIT(M, TRAIT_VORACIOUS))
				M.changeNext_move(CLICK_CD_MELEE * 0.5)*/
			switch(M.nutrition)
				if(NUTRITION_LEVEL_FAT to INFINITY)
					user.visible_message(span_notice("[user] forces [M.p_them()]self to eat \the [src]."), span_notice("I force myself to eat \the [src]."))
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_FAT)
					user.visible_message(span_notice("[user] [eatverb]s \the [src]."), span_notice("I [eatverb] \the [src]."))
				if(0 to NUTRITION_LEVEL_STARVING)
					user.visible_message(span_notice("[user] hungrily [eatverb]s \the [src], gobbling it down!"), span_notice("I hungrily [eatverb] \the [src], gobbling it down!"))
					M.changeNext_move(CLICK_CD_MELEE * 0.5)
/*			if(M.energy <= 50)
				user.visible_message(span_notice("[user] hungrily [eatverb]s \the [src], gobbling it down!"), span_notice("I hungrily [eatverb] \the [src], gobbling it down!"))
			else if(M.energy > 50 && M.energy < 500)
				user.visible_message(span_notice("[user] hungrily [eatverb]s \the [src]."), span_notice("I hungrily [eatverb] \the [src]."))
			else if(M.energy > 500 && M.energy < 1000)
				user.visible_message(span_notice("[user] [eatverb]s \the [src]."), span_notice("I [eatverb] \the [src]."))
			if(HAS_TRAIT(M, TRAIT_VORACIOUS))
			M.changeNext_move(CLICK_CD_MELEE * 0.5) nom nom nom*/
		else
			if(!isbrain(M))		//If you're feeding it to someone else.
//				if(fullness <= (600 * (1 + M.overeatduration / 1000)))
				if(M.nutrition in NUTRITION_LEVEL_FAT to INFINITY)
					M.visible_message(span_warning("[user] cannot force any more of [src] down [M]'s throat!"), \
										span_warning("[user] cannot force any more of [src] down your throat!"))
					return FALSE
				else
					M.visible_message(span_danger("[user] tries to feed [M] [src]."), \
										span_danger("[user] tries to feed me [src]."))
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					var/obj/item/bodypart/CH = C.get_bodypart(BODY_ZONE_HEAD)
					if(C.cmode)
						if(!CH.grabbedby)
							to_chat(user, span_info("[C.p_they(TRUE)] steals [C.p_their()] face from it."))
							return FALSE
				if(!do_mob(user, M, double_progress = TRUE, can_move = FALSE))
					return
				log_combat(user, M, "fed", reagents.log_list())
				if(istype(src, /obj/item/reagent_containers/food/snacks/grown/berries/rogue) || istype(src, /obj/item/reagent_containers/food/snacks/grown/fruit))
					M.add_stress(/datum/stressevent/hand_fed_fruit)
//				M.visible_message(span_danger("[user] forces [M] to eat [src]!"), span_danger("[user] forces you to eat [src]!"))
			else
				to_chat(user, span_warning("[M] doesn't seem to have a mouth!"))
				return

		if(reagents)								//Handle ingestion of the reagent.
			if(M.satiety > -200)
				M.satiety -= junkiness
			playsound(M.loc,'sound/misc/eat.ogg', rand(30,60), TRUE)
			if(reagents.total_volume)
				SEND_SIGNAL(src, COMSIG_FOOD_EATEN, M, user)
				var/fraction = min(bitesize / reagents.total_volume, 1)
				var/amt2take = reagents.total_volume / (bitesize - bitecount)
				if((bitecount >= bitesize) || (bitesize == 1))
					amt2take = reagents.total_volume
				reagents.trans_to(M, amt2take, transfered_by = user, method = INGEST)
				bitecount++
				On_Consume(M)
				checkLiked(fraction, M)
				if(bitecount >= bitesize)
					qdel(src)
				else if(user.client?.prefs.autoconsume)
					if(M == user && do_after(user, CLICK_CD_MELEE))
						INVOKE_ASYNC(src, PROC_REF(attack), M, user, def_zone)
						user.changeNext_move(CLICK_CD_MELEE)
					else if(M != user)
						INVOKE_ASYNC(src, PROC_REF(attack), M, user, def_zone)
						user.changeNext_move(CLICK_CD_MELEE)
				return TRUE
		playsound(M.loc,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(src)
		return FALSE

	return 0
/obj/item/reagent_containers/food/snacks/proc/get_nutrition()
	var/nutriment_count = 0
	for(var/reagent in list_reagents)
		if(ispath(reagent, /datum/reagent/consumable))
			var/datum/reagent/consumable/R = reagent
			nutriment_count += list_reagents[reagent] * R.nutriment_factor
	return nutriment_count

/obj/item/reagent_containers/food/snacks/proc/get_nutrition_to_text()
	var/nutrition = get_nutrition()
	switch(nutrition)
		if(0)
			return "an inedible item"
		if(1 to BASE_NUTRIMENT_NUTRITION * SNACK_POOR)
			return "a poor snack"
		if(BASE_NUTRIMENT_NUTRITION * SNACK_POOR to BASE_NUTRIMENT_NUTRITION * SNACK_DECENT)
			return "a decent snack"
		if(BASE_NUTRIMENT_NUTRITION * SNACK_DECENT to BASE_NUTRIMENT_NUTRITION * SNACK_NUTRITIOUS)
			return "a nutritious snack"
		if(BASE_NUTRIMENT_NUTRITION * SNACK_NUTRITIOUS to BASE_NUTRIMENT_NUTRITION * SNACK_CHUNKY)
			return "a chunky snack"
		if(BASE_NUTRIMENT_NUTRITION * SNACK_CHUNKY to BASE_NUTRIMENT_NUTRITION * MEAL_MEAGRE)
			return "a meagre meal"
		if(BASE_NUTRIMENT_NUTRITION * MEAL_MEAGRE to BASE_NUTRIMENT_NUTRITION * MEAL_AVERAGE)
			return "an adequate meal"
		if(BASE_NUTRIMENT_NUTRITION * MEAL_AVERAGE to BASE_NUTRIMENT_NUTRITION * MEAL_FILLING)
			return "a good meal"
		else
			return "a lavish, filling meal"

/obj/item/reagent_containers/food/snacks/proc/rotprocess_to_text()
	var/rot_text = ""
	if(!rotprocess)
		return "This food does not rot."
	switch(initial(rotprocess))
		if(0 to SHELFLIFE_TINY)
			rot_text = "This food will rot in less than a third of a dae."
		if(SHELFLIFE_TINY to SHELFLIFE_SHORT)
			rot_text = "This food will rot in half a dae."
		if(SHELFLIFE_SHORT to SHELFLIFE_DECENT)
			rot_text = "This food will last about a dae."
		if(SHELFLIFE_DECENT to SHELFLIFE_LONG)
			rot_text = "This food will last a dae and a half."
		if(SHELFLIFE_LONG to SHELFLIFE_EXTREME)
			rot_text = "This food will last three daes."
	switch(-1 * warming / initial(rotprocess))
		if(-INFINITY to 0.25)
			rot_text += " It is very fresh."
		if(0.25 to 0.5)
			rot_text += " It is fairly fresh."
		if(0.5 to 0.75)
			rot_text += " It is starting to go stale."
		if(0.75 to 1)
			rot_text += " It is about to rot."
	return rot_text

/obj/item/reagent_containers/food/snacks/examine(mob/user)
	. = ..()
	if(!in_container)
		switch (bitecount)
			if(0)
			if(1)
				. += span_smallnotice("[src] was bitten by someone!\n")
			if(2,3)
				. += span_smallnotice("[src] was bitten [bitecount] times!\n")
			else
				. += span_smallnotice("[src] was bitten multiple times!\n")
	switch(faretype)
		if(FARE_IMPOVERISHED)
			. += span_smallnotice("It is food fit for the desperate.")
		if(FARE_POOR)
			. += span_smallnotice("It is food fit for the poor.")
		if(FARE_NEUTRAL)
			. += span_smallnotice("It is decent food.")
		if(FARE_FINE)
			. += span_smallnotice("It is fine food.")
		if(FARE_LAVISH)
			. += span_smallnotice("It is lavish food.")
	if(portable)
		. += span_smallnotice("It can be eaten without a table.")
	else
		. += span_smallnotice("Eating this without a table would be disgraceful for a noble.")
	. += span_smallnotice("It looks like [get_nutrition_to_text()]")
	switch(eat_effect)
		if(/datum/status_effect/debuff/uncookedfood)
			. += span_smallred("It is raw!")
		if(/datum/status_effect/debuff/rotfood)
			. += span_smallred("It is rotten!")
		if(/datum/status_effect/debuff/burnedfood)
			. += span_smallred("It is burned!")
		if(/datum/status_effect/buff/snackbuff)
			. += span_smallnotice("It looks good!")
		if(/datum/status_effect/buff/greatsnackbuff)
			. += span_smallnotice("It looks great!!")
		if(/datum/status_effect/buff/mealbuff)
			. += span_smallnotice("It looks good!")
		if(/datum/status_effect/buff/greatmealbuff)
			. += span_smallnotice("It looks great!!")
	. += span_smallnotice("[rotprocess_to_text()]")

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/kitchen/fork))
		if(do_after(user, 0.5 SECONDS))
			attack(user, user, user.zone_selected)

	if(istype(W, /obj/item/storage))
		..() // -> item/attackby()
		return 0

/*	if(istype(W, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = W
		if(custom_food_type && ispath(custom_food_type))
			if(S.w_class > WEIGHT_CLASS_SMALL)
				to_chat(user, span_warning("[S] is too big for [src]!"))
				return 0
			if(!S.customfoodfilling || istype(W, /obj/item/reagent_containers/food/snacks/customizable) || istype(W, /obj/item/reagent_containers/food/snacks/pizzaslice/custom) || istype(W, /obj/item/reagent_containers/food/snacks/cakeslice/custom))
				to_chat(user, span_warning("[src] can't be filled with [S]!"))
				return 0
			if(contents.len >= 20)
				to_chat(user, span_warning("I can't add more ingredients to [src]!"))
				return 0
			var/obj/item/reagent_containers/food/snacks/customizable/C = new custom_food_type(get_turf(src))
			C.initialize_custom_food(src, S, user)
			return 0
	if(user.used_intent.blade_class == slice_bclass && W.wlength == WLENGTH_SHORT)
		if(slice_bclass == BCLASS_CHOP)
			//	RTD meat chopping noise  The 66% random bit is just annoying
			if(prob(66))
				user.visible_message(span_warning("[user] chops [src]!"))
				return 0
			else
				user.visible_message(span_notice("[user] chops [src]!"))
				slice(W, user)
			return 1
		else if(slice(W, user))
			return 1*/
	..()
//Called when you finish tablecrafting a snack.
/obj/item/reagent_containers/food/snacks/CheckParts(list/parts_list, datum/crafting_recipe/food/R)
	..()
//	reagents.clear_reagents()
	for(var/obj/item/reagent_containers/RC in contents)
		RC.reagents.trans_to(reagents, RC.reagents.maximum_volume)
	if(istype(R))
		contents_loop:
			for(var/A in contents)
				for(var/B in R.real_parts)
					if(istype(A, B))
						continue contents_loop
				qdel(A)
	SSblackbox.record_feedback("tally", "food_made", 1, type)

	if(bonus_reagents && bonus_reagents.len)
		for(var/r_id in bonus_reagents)
			var/amount = bonus_reagents[r_id]
			if(r_id == /datum/reagent/consumable/nutriment || r_id == /datum/reagent/consumable/nutriment/vitamin)
				reagents.add_reagent(r_id, amount, tastes)
			else
				reagents.add_reagent(r_id, amount)

/obj/item/reagent_containers/food/snacks/proc/slice(obj/item/W, mob/user)
	if((slices_num <= 0 || !slices_num) || !slice_path) //is the food sliceable?
		return FALSE

	if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/table/optable) in src.loc) && \
			!(locate(/obj/item/storage/bag/tray) in src.loc) \
		)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE

	if(slice_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1) // added some choppy sound
	if(chopping_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/chopping_block.ogg', 60, TRUE, -1) // added some choppy sound
	if(slice_batch)
		var/cd = get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking))
		if(!do_after(user, 1 SECONDS / cd, target = src))
			return FALSE
		var/reagents_per_slice = reagents.total_volume/slices_num
		if (istype(src,/obj/item/reagent_containers/food/snacks/grown/onion/rogue))
			if (ishuman(user))
				var/mob/living/carbon/H = user
				var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES) //FIXME: getorganslot() and getorgan() don't actually differentiate organ types! This means that transplanted eyes, regardless of type, will still cry, but I need to mess with all of the organ checking code to unfuck this!
				if (E && !(H.eyesclosed || HAS_TRAIT(H,TRAIT_NOPAIN) || H.is_eyes_covered() || HAS_TRAIT(H,TRAIT_BLIND) || H.get_skill_level(/datum/skill/craft/cooking) > SKILL_LEVEL_JOURNEYMAN)) //The painless will not be irritated by onions. Golems, skellies, meth-heads, etc. Expert+ chefs will also be unaffected.
					to_chat(user,span_warning("The onion's juices sting my eyes!"))
					user.blur_eyes(4)
					if (prob(50))
						user.emote("cry",forced=TRUE)
		for(var/i in 1 to slices_num)
			var/obj/item/reagent_containers/food/snacks/slice = new slice_path(loc)
			initialize_slice(slice, reagents_per_slice)
		qdel(src)
	else
		var/reagents_per_slice = reagents.total_volume/slices_num
		var/obj/item/reagent_containers/food/snacks/slice = new slice_path(loc)
		initialize_slice(slice, reagents_per_slice)
		slices_num--
		if(slices_num == 1)
			slice = new slice_path(loc)
			initialize_slice(slice, reagents_per_slice)
			qdel(src)
			return TRUE
		if(slices_num <= 0)
			qdel(src)
			return TRUE
		update_icon()
	return TRUE

/obj/item/reagent_containers/food/snacks/proc/initialize_slice(obj/item/reagent_containers/food/snacks/slice, reagents_per_slice)
	slice.create_reagents(slice.volume)
	reagents.trans_to(slice,reagents_per_slice)
	slice.filling_color = filling_color
	slice.name = slice_name ? slice_name : slice.name
	slice.update_snack_overlays(src)
//	if(name != initial(name))
//		slice.name = "slice of [name]"
//	if(desc != initial(desc))
//		slice.desc = ""
//	if(foodtype != initial(foodtype))
//		slice.foodtype = foodtype //if something happens that overrode our food type, make sure the slice carries that over

/obj/item/reagent_containers/food/snacks/proc/generate_trash(atom/location)
	if(trash)
		if(ispath(trash, /obj/item))
			. = new trash(location)
			trash = null
			return
		else if(isitem(trash))
			var/obj/item/trash_item = trash
			trash_item.forceMove(location)
			. = trash
			trash = null
			return

/obj/item/reagent_containers/food/snacks/proc/update_snack_overlays(obj/item/reagent_containers/food/snacks/S)
	cut_overlays()
	var/mutable_appearance/filling = mutable_appearance(icon, "[initial(icon_state)]_filling")
	filling.color = filling_color

	add_overlay(filling)

// initialize_cooked_food() is called when microwaving the food
/obj/item/reagent_containers/food/snacks/proc/initialize_cooked_food(obj/item/reagent_containers/food/snacks/S, cooking_efficiency = 1)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)
	if(S.bonus_reagents && S.bonus_reagents.len)
		for(var/r_id in S.bonus_reagents)
			var/amount = S.bonus_reagents[r_id] * cooking_efficiency
			if(r_id == /datum/reagent/consumable/nutriment || r_id == /datum/reagent/consumable/nutriment/vitamin)
				S.reagents.add_reagent(r_id, amount)
			else
				S.reagents.add_reagent(r_id, amount)
	S.filling_color = filling_color
	S.update_snack_overlays(src)

/obj/item/reagent_containers/food/snacks/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(contents)
		for(var/atom/movable/something in contents)
			something.forceMove(drop_location())
	return ..()

/obj/item/reagent_containers/food/snacks/attack_animal(mob/M)
	if(isanimal(M))
		if(isdog(M))
			var/mob/living/L = M
			if(bitecount == 0 || prob(50))
				M.emote("me", 1, "nibbles away at \the [src]")
			bitecount++
			L.taste(reagents) // why should carbons get all the fun?
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "yaps for more", "woofs twice", "looks at the area where \the [src] was")
				if(sattisfaction_text)
					M.emote("me", 1, "[sattisfaction_text]")
				qdel(src)

/obj/item/reagent_containers/food/snacks/afterattack(obj/item/reagent_containers/M, mob/user, proximity)
	. = ..()
	if(!dunkable || !proximity)
		return
	if(istype(M, /obj/item/reagent_containers/glass))	//you can dunk dunkable snacks into beakers or drinks
		if(!M.is_drainable())
			to_chat(user, span_warning("[M] is unable to be dunked in!"))
			return
		if(M.reagents.trans_to(src, dunk_amount, transfered_by = user))	//if reagents were transfered, show the message
			to_chat(user, span_notice("I dunk \the [src] into \the [M]."))
			return
		if(!M.reagents.total_volume)
			to_chat(user, span_warning("[M] is empty!"))
		else
			to_chat(user, span_warning("[src] is full!"))

// //////////////////////////////////////////////Store////////////////////////////////////////
/// All the food items that can store an item inside itself, like bread or cake.
/obj/item/reagent_containers/food/snacks/store
	w_class = WEIGHT_CLASS_NORMAL
	var/stored_item = 0

/obj/item/reagent_containers/food/snacks/store/attackby(obj/item/W, mob/user, params)
	..()
	if(W.w_class <= WEIGHT_CLASS_SMALL & !istype(W, /obj/item/reagent_containers/food/snacks)) //can't slip snacks inside, they're used for custom foods.
		if(W.get_sharpness())
			return 0
		if(stored_item)
			return 0
		if(!iscarbon(user))
			return 0
		if(contents.len >= 20)
			to_chat(user, span_warning("[src] is full."))
			return 0
		to_chat(user, span_notice("I slip [W] inside [src]."))
		user.transferItemToLoc(W, src)
		add_fingerprint(user)
		contents += W
		stored_item = 1
		return 1 // no afterattack here

/obj/item/reagent_containers/food/snacks/MouseDrop(atom/over)
	var/turf/T = get_turf(src)
	var/obj/structure/table/TB = locate(/obj/structure/table) in T
	if(TB)
		TB.MouseDrop(over)
	else
		return ..()


/obj/item/reagent_containers/food/snacks/badrecipe
	name = "burned mess"
	desc = ""
	icon_state = "badrecipe"
	list_reagents = list(/datum/reagent/toxin/bad_food = 30)
	filling_color = "#8B4513"
	foodtype = GROSS
	burntime = 0
	cooktime = 0
