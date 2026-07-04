/* * * * * * * * * * * **
 *						*	-Cooking based on slapcrafting
 *		 NeuFood		*	-Uses defines to track nutrition
 *						*	-Meant to replace menu crafting completely for foods
 *						*
 * * * * * * * * * * * **/


/*	........   Templates / Base items   ................ */
/obj/item/reagent_containers // added vars used in neu cooking, might be used for other things too in the future. How it works is in each items attackby code.
	var/short_cooktime = 2 SECONDS
	var/long_cooktime = 3 SECONDS

/obj/item/reagent_containers/proc/update_cooktime(mob/user)
	if(user.mind)
		short_cooktime = (initial(short_cooktime) / get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking)))
		long_cooktime = (initial(long_cooktime) / get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking)))
	else
		short_cooktime = initial(short_cooktime)
		long_cooktime = initial(long_cooktime)

/obj/item/reagent_containers/food/snacks/rogue // base food type, for icons and cooktime, and to make it work with processes like pie making
	icon = 'modular/Neu_Food/icons/unused.dmi' // Still need a backup file lol
	desc = ""
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	foodtype = GRAIN
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	cooktime = 30 SECONDS
	var/process_step // used for pie making and other similar modular foods
	var/datum/food_recipe/active_recipe
	var/current_step = 1

/obj/item/reagent_containers/food/snacks/rogue/examine(mob/user)
	. = ..()
	if(active_recipe && current_step <= active_recipe.ingredients.len)
		var/entry = active_recipe.ingredients[current_step]
		. += span_smallnotice("Recipe: <b>[active_recipe.name]</b>. Next step: [active_recipe.step_label(entry)].")

	var/list/prep = list()

	var/list/possible = SScooking.recipe_index[src.type]
	if(possible && possible.len)
		var/list/recipe_links = list()
		for(var/datum/food_recipe/R in possible)
			if(R.hidden)
				continue
			if(!length(R.ingredients))
				continue
			recipe_links += "<a href='byond://?src=[REF(src)];view_wiki=[R.get_wiki_key()]'>[R.name]</a> (starts with [R.step_label(R.ingredients[1])])"
		if(length(recipe_links))
			prep += "This could be used to prepare: [recipe_links.Join(", ")]."

	if(cooked_type)
		var/obj/item/CT = cooked_type
		prep += "Ready to be <b>cooked</b> into [initial(CT.name)]."
	if(fried_type)
		var/obj/item/FT = fried_type
		prep += "Ready to be <b>fried</b> into [initial(FT.name)]."
	if(slice_path)
		var/obj/item/ST = slice_path
		prep += "Ready to be <b>sliced</b> into [initial(ST.name)]."

	var/datum/food_recipe/producing = SScooking.get_producing_recipe(src.type)
	if(producing && !producing.hidden)
		. += span_smallnotice("(<a href='byond://?src=[REF(src)];view_wiki=[producing.get_wiki_key()]'>View recipe</a> in the Encyclopedia.)")

	if(length(prep))
		var/list/prep_lines = list()
		for(var/line in prep)
			prep_lines += "<span class='smallnotice'> - [line]</span>"
		. += "<details><summary><span class='smallnotice'>Recipes</span></summary>[prep_lines.Join("<br>")]</details>"

/obj/item/reagent_containers/food/snacks/rogue/Topic(href, href_list)
	. = ..()
	if(href_list["view_wiki"])
		var/key = href_list["view_wiki"]
		var/datum/recipe_wiki/wiki = get_recipe_wiki()
		var/datum/food_recipe/single_cook/auto = SScooking?.auto_single_lookup[key]
		if(auto)
			if(!auto.hidden)
				wiki.show_for_recipe(usr, key)
			return
		var/recipe_type = text2path(key)
		if(!ispath(recipe_type, /datum/food_recipe))
			return
		var/datum/food_recipe/R = recipe_type
		if(initial(R.hidden) || is_abstract(recipe_type))
			return
		wiki.show_for_recipe(usr, recipe_type)

/obj/item/reagent_containers/food/snacks/rogue/MiddleClick(mob/user)
	. = ..()

	if(!active_recipe)
		to_chat(user, span_warning("There is no recipe currently active on [src]."))
		return

	var/confirmation = tgui_alert(user, "Are you sure you want to reset the preparation for [active_recipe.name]?", "Reset Recipe", list("Yes", "No"))
	if(confirmation != "Yes" || !active_recipe)
		return

	to_chat(user, span_notice("You clear the preparation progress for [active_recipe.name] from [src]."))
	active_recipe = null
	current_step = 1
	cut_overlays()
	name = initial(name)
	icon = initial(icon)
	icon_state = initial(icon_state)

/obj/item/reagent_containers/food/snacks/rogue/attackby(obj/item/I, mob/living/user)
	if(!active_recipe)
		var/datum/food_recipe/R = SScooking.get_recipe(src, I)
		if(R)
			if(!R.user_can_make(user))
				if(R.restricted_message)
					to_chat(user, span_warning(R.restricted_message))
				return
			active_recipe = R
		else
			return ..()

	if(active_recipe.required_station && !(locate(active_recipe.required_station) in loc))
		var/atom/station = active_recipe.required_station
		to_chat(user, span_warning("You need [initial(station.name)] to prepare [src.name]."))
		if(current_step == 1)
			active_recipe = null
		return

	var/entry = active_recipe.ingredients[current_step]

	if(ispath(entry, /datum/reagent))
		var/amt = active_recipe.ingredients[entry]
		if(I.reagents && I.reagents.has_reagent(entry, amt))
			do_cooking_step(I, user, entry, amt)
		else
			to_chat(user, span_warning("You need at least [amt] units of [initial(entry:name)]!"))
		return

	if(active_recipe.step_accepts(entry, I))
		do_cooking_step(I, user)
		return

	return ..()

/obj/item/reagent_containers/food/snacks/rogue/proc/do_cooking_step(obj/item/I, mob/living/user, req_reagent, req_amt)
	var/entry = active_recipe.ingredients[current_step]
	var/is_tool = (!req_reagent && active_recipe.ingredients[entry] == COOKSTEP_TOOL)

	if(!do_after(user, get_cooking_do_time(user, active_recipe.time_per_step), target = src))
		if(current_step == 1)
			active_recipe = null
			current_step = 1
		return

	if(!active_recipe)
		return

	playsound(src, 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.mind.add_sleep_experience(/datum/skill/craft/cooking, H.STAINT * active_recipe.experience_per_step)

	if(req_reagent)
		// Re-verify reagent exists after the timer
		if(!I.reagents || !I.reagents.has_reagent(req_reagent, req_amt))
			return
		I.reagents.remove_reagent(req_reagent, req_amt)
		playsound(src, 'modular/Creechers/sound/milking1.ogg', 50, TRUE)
	else if(!is_tool)
		playsound(src, 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE)
		I.moveToNullspace()

	var/list/visuals = active_recipe.step_visuals
	var/list/visual = (current_step <= length(visuals)) ? visuals[current_step] : null
	var/list/step_over = (current_step <= length(active_recipe.step_overlays)) ? active_recipe.step_overlays[current_step] : null
	if(visual)
		cut_overlays()
		icon = visual[1]
		icon_state = visual[2]
	else if(step_over)
		add_overlay(mutable_appearance(step_over[1], step_over[2]))
	else if(!is_tool && (current_step < active_recipe.ingredients.len || active_recipe.needs_cooking || active_recipe.cook_method))
		var/image/over = image(I.icon, I.icon_state)
		over.transform = matrix() * 0.7
		switch(current_step)
			if(1) { over.pixel_x = -7; over.pixel_y = 7 }   // NW
			if(2) { over.pixel_x = 7;  over.pixel_y = 7 }   // NE
			if(3) { over.pixel_x = 7;  over.pixel_y = -7 }  // SE
			if(4) { over.pixel_x = -7; over.pixel_y = -7 }  // SW
		add_overlay(over)

	if(!req_reagent && !is_tool)
		qdel(I)

	// Show the dish, not the base item, while it's in progress.
	name = "unfinished [active_recipe.name]"

	current_step++
	if(current_step > active_recipe.ingredients.len)
		finish_recipe(user)

/obj/item/reagent_containers/food/snacks/rogue/proc/finish_recipe(mob/living/user)
	if(active_recipe.cook_method || active_recipe.needs_cooking)
		if(active_recipe.result_smell)
			cooked_smell = active_recipe.result_smell
	if(active_recipe.cook_method)
		set_cook_handoff(active_recipe.cook_method, active_recipe.result_type)
		to_chat(user, span_nicegreen("[name] is ready to be cooked."))
		active_recipe = null
		current_step = 1
		return
	if(active_recipe.needs_cooking)
		cooked_type = active_recipe.result_type
		fried_type = active_recipe.result_type
		to_chat(user, span_nicegreen("[name] is ready to be cooked."))
		active_recipe = null
		current_step = 1
		return
	finalize_cooking()

/obj/item/reagent_containers/food/snacks/rogue/proc/set_cook_handoff(method, result)
	switch(method)
		if(COOK_BAKE)
			cooked_type = result
		if(COOK_FRY)
			fried_type = result
		if(COOK_DEEPFRY)
			deep_fried_type = result
		// TODO: COOK_BOIL later

/obj/item/reagent_containers/food/snacks/rogue/proc/finalize_cooking()
	var/res_type = active_recipe.result_type
	var/amount = max(1, active_recipe.result_amount)
	var/turf/T = get_turf(src)
	cut_overlays()
	for(var/i in 1 to amount)
		new res_type(T)
	active_recipe = null
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Many foodstuffs can be sliced into smaller portions by left-clicking them with a knife on the 'CUT' or 'CHOP' intents. This includes most meats, vegetables, fruits, bread, pies, cakes, saloumi, butter, salo, and more.")
	. += span_info("Most food will eventually rot, if left out for long enough. Storing food in a closed chest or atop a platter will effectively prevent it from rotting.")
	. += span_info("Rarer foods and drinks, or those made from more expensive recipes, can provide increased bonuses to the indulger's mood and health.")
	. += span_info("Everyone has a favorite meal and drink to indulge in - and, conversely, a hated meal and drink that they absolutely despise. Serve them right, and their mood will greatly improve.")
	. += span_info("Those of nobility have much higher standards, when it comes to what - and how - they eat. They prefer to eat plattered meals with proper utensils, while disliking plainer and cheaper food.")
	. += span_info("Set a recipe on accident? middleclick the item to reset the recipe back to nothing and pick a different one.")

/obj/item/reagent_containers/food/snacks/rogue/Initialize()
	. = ..()
	eatverb = pick("bite","chew","nibble","gobble","chomp")

/obj/item/reagent_containers/food/snacks/rogue/foodbase // root item for uncooked food thats disgusting when raw
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	bitesize = 3
	eat_effect = /datum/status_effect/debuff/uncookedfood

/obj/item/reagent_containers/food/snacks/rogue/foodbase/New() // disables the random placement on creation for this object MAYBE OBSOLETE?
	..()
	pixel_x = 0
	pixel_y = 0

/obj/item/reagent_containers/food/snacks/rogue/preserved // just convenient way to group food with long rotprocess
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks
	var/chopping_sound = FALSE // does it play a choppy sound when batch sliced?
	var/slice_sound = FALSE // does it play the slice sound when sliced?

/obj/item/reagent_containers/food/snacks/proc/changefood(path, mob/living/eater)
	if(!path || !eater)
		return
	var/turf/T = get_turf(eater)
	if(eater.dropItemToGround(src))
		qdel(src)
	var/obj/item/I = new path(T)
	eater.put_in_active_hand(I)

/obj/effect/decal/cleanable/food/mess // decal applied when throwing minced meat for example
	name = "mess"
	desc = ""
	color = "#ab9d9d"
	icon_state = "tomato_floor1"
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W, mob/user, params)
	if(user.used_intent.blade_class == slice_bclass && W.wlength == WLENGTH_SHORT)
		if(slice_bclass == BCLASS_CHOP)
			user.visible_message(span_notice("[user] chops [src]!"))
			slice(W, user)
			return 1
		else if(slice(W, user))
			return 1
	..()

/* added to proc
/obj/item/reagent_containers/food/snacks/proc/slice(obj/item/W, mob/user)
	if(slice_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1) // added some choppy sound
	if(chopping_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/chopping_block.ogg', 60, TRUE, -1) // added some choppy sound
*/
/*	........   Kitchen tools / items   ................ */


/obj/item/rogueweapon/huntingknife/cleaver
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	item_state = "cleaver"
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	experimental_onback = FALSE

/obj/item/book/rogue/yeoldecookingmanual // new book with some tips to learn
	name = "Ye olde ways of cookinge"
	desc = "Penned by Svend Fatbeard, butler in the fourth generation"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "Neu_cooking.json"

/* * * * * * * * * * * * * * *	*
 *								*
 *		Powder & Salt			*
 *					 			*
 *								*
 * * * * * * * * * * * * * * * 	*/

// -------------- Flour -----------------
/obj/item/reagent_containers/powder/flour
	name = "flour"
	desc = "With this ambition, we build an empire."
	gender = PLURAL
	icon_state = "flour"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	var/water_added
	experimental_inhand = TRUE

/obj/item/reagent_containers/powder/flour/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return null
			if("altgrip")
				return null
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 4,"wy" = -1,"ex" = -1,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/reagent_containers/powder/flour/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/obj/item/reagent_containers/powder/flour/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking yourself while targeting the nose will automatically snort the powder in your hand.")
	. += span_info("Most powders can imbue a wide variety of effects, when inhaled.")

/obj/item/reagent_containers/powder/flour/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/R = I
	if(istype(R) && wet(I, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/powder/flour/proc/make_wet()
	name = "wet flour"
	desc = "Destined for greatness, at your hands."
	water_added = TRUE
	color = "#d9d0cb"

/obj/item/reagent_containers/powder/flour/proc/wet(obj/item/I, mob/living/user)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	// if false, this is a special case like orison
	var/is_container = istype(R)
	update_cooktime(user)
	if(water_added)
		return FALSE
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("Need a table..."))
		return FALSE
	if(is_container && (!R.reagents.has_reagent(/datum/reagent/water, 10)))
		to_chat(user, span_notice("Needs more water to work it."))
		return TRUE
	to_chat(user, span_notice("Adding water, now it's time to knead it..."))
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user, short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		make_wet()
	return TRUE

/obj/item/reagent_containers/powder/flour/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user, short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			new /obj/item/reagent_containers/food/snacks/rogue/dough_base(loc)
			qdel(src)
	else ..()


// -------------- SALT -----------------
/obj/item/reagent_containers/powder/salt
	name = "salt"
	desc = ""
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/salt/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/* -------------- RICE ----------------- */
/obj/item/reagent_containers/food/snacks/grown/rice
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 3
	var/water_added

/obj/item/reagent_containers/food/snacks/grown/rice/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/R = I
	if(istype(R) && wet(I, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/grown/rice/proc/wet(obj/item/I, mob/living/user)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	var/is_container = istype(R)
	update_cooktime(user)
	if(water_added)
		return FALSE
	if(isturf(loc)&& (!found_table))
		to_chat(user, "<span class='notice'>Need a table...</span>")
		return FALSE
	if(is_container && (!R.reagents.has_reagent(/datum/reagent/water, 10)))
		to_chat(user, "<span class='notice'>Needs more water to work it.</span>")
		return TRUE
	to_chat(user, "<span class='notice'>Adding water, now it's time to hand wash it...</span>")
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user,2 SECONDS, target = src))
		user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
		name = "wet rice"
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#d9d0cb"
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/rice/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user,3 SECONDS, target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			new /obj/item/reagent_containers/food/snacks/rogue/ricewet(loc)
			qdel(src)
	else ..()

/* -------------- WET RICE ----------------- */
/obj/item/reagent_containers/food/snacks/rogue/ricewet
	name = "washed rice"
	desc = ""
	gender = PLURAL
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "rice"
	list_reagents = list(/datum/reagent/floure = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/mineral
	name = "coarse minerals"
	desc = "Ground up rock. It could be made into mineral salts with more work."
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	var/water_added

/obj/item/reagent_containers/powder/coarse_salt
	name = "coarse salt"
	desc = "Somewhat gritty, coarse salt. Could be ground down into finer salt."
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	color = "#999797"
	mill_result = /obj/item/reagent_containers/powder/salt

/obj/item/reagent_containers/powder/mineral/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/obj/item/reagent_containers/powder/mineral/attackby(obj/item/I, mob/user, params)
	var/obj/item/reagent_containers/R = I
	if(istype(R) && wet(I, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/powder/mineral/proc/wet(obj/item/I, mob/user)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	var/is_container = istype(R)
	update_cooktime(user)
	if(water_added)
		return FALSE
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("Need a table..."))
		return FALSE
	if(is_container && (!R.reagents.has_reagent(/datum/reagent/water, 10)))
		to_chat(user, span_notice("Needs more water to work it."))
		return TRUE
	to_chat(user, span_notice("Adding water, now it's time to sift it..."))
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user, short_cooktime, target = src))
		name = "prepared minerals"
		desc = "Still quite coarse, needs some sifting."
		if(is_container)
			R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#666262"
	return TRUE

/obj/item/reagent_containers/powder/mineral/attackby(obj/item/I, mob/user, params)
	if(water_added)
		if(istype(I, /obj/item/natural/cloth))
			user.visible_message(span_info("[user] sifts the minerals..."))
			playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 90, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				new /obj/item/reagent_containers/powder/coarse_salt(loc)
				qdel(src)
	else ..()

/* -------------- PUMPKIN SPICE ----------------- */
/obj/item/reagent_containers/food/snacks/pumpkinspice
	name = "pumpkin spice"
	desc = "Rich flavors from a humble origin."
	gender = PLURAL
	icon_state = "pumpkinspice"
	icon = 'icons/roguetown/items/produce.dmi'
	list_reagents = list(/datum/reagent/consumable/pumpkinspice = 1)
	grind_results = list(/datum/reagent/consumable/pumpkinspice = 10)
	volume = 1
	sellprice = 0

/datum/reagent/consumable/pumpkinspice
	name = "pumpkin spice"
	description = "Spiced delight."
	color = "#ffffff"
