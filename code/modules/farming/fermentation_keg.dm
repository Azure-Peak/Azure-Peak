GLOBAL_LIST_EMPTY(custom_fermentation_recipes)

/datum/looping_sound/boiling
	mid_sounds = list('sound/foley/bubb (1).ogg' = 1,'sound/foley/bubb (2).ogg' = 1,'sound/foley/bubb (3).ogg' = 1,'sound/foley/bubb (4).ogg' = 1,'sound/foley/bubb (5).ogg' = 1)
	mid_length = 2 SECONDS
	volume = 25

/obj/structure/fermentation_keg
	name = "fermentation keg"
	desc = "A keg that bears the duty of birthing plenty of bubbling brews."

	icon = 'icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"

	density = TRUE
	anchored = FALSE

	/// The sound of fermentation
	var/datum/looping_sound/boiling/soundloop
	/// The volume of the barrel sounds
	var/sound_volume = 25
	var/open_icon_state = "barrel_tapless_open"
	var/tapped_icon_state = "barrel_tapped_ready"

	//After brewing we can sell or bottle, this is for the latter
	var/ready_to_bottle = FALSE
	var/brewing = FALSE

	///our currently needed crops
	var/list/recipe_crop_stocks
	///our currently selected recipe
	var/datum/brewing_recipe/selected_recipe
	///our made item which we clear once its no longer ready to bottle
	var/made_item

	var/age_start_time = 0

	var/tapped = FALSE
	var/beer_left = 0

	var/selecting_recipe = FALSE

	var/heated = FALSE
	///machines heat in kelvin
	var/heat = 300
	///our start_time
	var/start_time
	///our brew progress time
	var/heated_progress_time
	///when our heat can decay
	var/heat_decay = 0
	sellprice = 15 // Default price for the keg.
	var/rotation_speed_mult = 1 //for the copper distiller

/obj/structure/fermentation_keg/Initialize()
	create_reagents(900, OPENCONTAINER | NO_REACT | AMOUNT_VISIBLE | REFILLABLE) //on agv it should be 120u for water then rest can be other needed chemicals
	. = ..()
	recipe_crop_stocks = list()

	soundloop = new(src, brewing)
	soundloop.volume = sound_volume

	if(heated)
		START_PROCESSING(SSobj, src)

/obj/structure/fermentation_keg/update_overlays()
	. = ..()
	if(length(overlays))
		overlays.Cut()

	if(!reagents.total_volume)
		return
	if(icon_state != open_icon_state)
		return
	var/mutable_appearance/MA = mutable_appearance(icon, "filling")
	MA.color = mix_color_from_reagents(reagents)
	overlays += MA

/obj/structure/fermentation_keg/attack_right(mob/user)
	. = ..()
	if(!ready_to_bottle && selected_recipe && !brewing)
		user.visible_message("[user] starts emptying out [src].", "You start emptying out [src].")
		if(!do_after(user, 5 SECONDS, src))
			return
		clear_keg(TRUE)
		return

	if(!brewing && (!selected_recipe || ready_to_bottle))
		if(!shopping_run(user))
			return

/obj/structure/fermentation_keg/MiddleClick(mob/user)
	. = ..()
	if(!user.Adjacent(src))
		return

	if(!brewing && ready_to_bottle)
		if(try_tapping(user))
			return

/obj/structure/fermentation_keg/attack_hand(mob/user)
	if((user.used_intent == /datum/intent/grab) || user.cmode)
		return ..()
	if(!selected_recipe)
		to_chat(user, span_warning("No recipe has been set yet!"))
		return ..()

	if(try_n_brew(user))
		start_brew()
		to_chat(user, span_info("[src] begins brewing [selected_recipe.name]."))
	..()

/obj/structure/fermentation_keg/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers) && tapped && (user.used_intent.type == /datum/intent/fill))
		if(try_filling(user, I))
			return

	if(heated)
		if(istype(I, /obj/item/rogueore/coal) || istype(I, /obj/item/grown/log/tree))
			refuel(I, user)
			return

	if(ready_to_bottle)
		if(selected_recipe.after_finish_attackby(user, I, src))
			create_items()
			return

	var/list/produce_list = list()
	var/list/storage_list = list()

	if(istype(I, /obj/item/bottle_kit))
		var/obj/item/bottle_kit/kit = I
		bottle(kit.glass_colour)

	if(I.type in selected_recipe?.needed_items)
		produce_list |= I

	if(I.type in selected_recipe?.needed_crops)
		produce_list |= I

	if(istype(I, /obj/item/storage))
		produce_list |= I.contents
		storage_list |= I.contents

	var/dumps = FALSE
	for(var/obj/item/reagent_containers/food/G in produce_list)
		if(G.type in selected_recipe?.needed_crops)
			if(recipe_crop_stocks[G.type] >= selected_recipe?.needed_crops[G.type])
				continue
			recipe_crop_stocks[G.type]++
			if(G in storage_list)
				dumps = TRUE
				SEND_SIGNAL(G.loc, COMSIG_TRY_STORAGE_TAKE, G, get_turf(src), TRUE)
			qdel(G)

	for(var/obj/item/item in produce_list)
		if(item.type in selected_recipe?.needed_items)
			if(recipe_crop_stocks[item.type] >= selected_recipe?.needed_items[item.type])
				continue
			var/amount = recipe_crop_stocks[item.type] || 0
			var/added_item = 1
			recipe_crop_stocks[item.type] = amount + added_item
			if(item in storage_list)
				dumps = TRUE
				SEND_SIGNAL(item.loc, COMSIG_TRY_STORAGE_TAKE, item, get_turf(src), TRUE)
			qdel(item)

	if(dumps)
		user.visible_message("[user] dumps some things into [src].", "You dump some things into [src].")

	. = ..()
	update_overlays()

/obj/structure/fermentation_keg/examine(mob/user)
	. =..()
	if(heated)
		. += "Internal Temperature of around [heat - 271.3]C."
	if(ready_to_bottle)
		. += span_boldnotice("[made_item]")
		if(age_start_time)
			. += "Aged for [(world.time - age_start_time) * 0.1] Seconds.\n"
		if(beer_left)
			. += "[((beer_left / FLOOR((selected_recipe.brewed_amount * selected_recipe.per_brew_amount) , 1))) * 100]% Full"
		if(!tapped)
			. += span_blue("Middle-Click on the Barrel to Tap it. It will lose its sale value.")

	else if(selected_recipe)
		var/message = "Currently making: [selected_recipe.name].\n"

		//time
		if(selected_recipe.brew_time)
			var/multiplier = 1
			if(heated && !selected_recipe.heat_required)
				multiplier = 0.5
			if((selected_recipe.brew_time * multiplier) >= 1 MINUTES)
				message += "Once set, will take [(selected_recipe.brew_time / 600) * multiplier] Minutes.\n"
			else
				message += "Once set, will take [(selected_recipe.brew_time / 10) & multiplier] Seconds.\n"

		//How many are brewed
		if(selected_recipe.brewed_amount)
			message += "Will produce [selected_recipe.brewed_amount] bottles when finished or [FLOOR((selected_recipe.brewed_amount * selected_recipe.per_brew_amount)/ 3 , 1)] oz.\n"

		if(selected_recipe.brewed_item && selected_recipe.brewed_item_count)
			var/name_to_use = selected_recipe.secondary_name
			if(!name_to_use)
				name_to_use = selected_recipe.name
			message += "Will produce [name_to_use] x [selected_recipe.brewed_item_count] when finished.\n"

		if(selected_recipe.helpful_hints)
			message += "[selected_recipe.helpful_hints].\n"

		. += span_blue("Right-Click on the Barrel to clear it. Left-Click to start brewing. Brewing will remove all existing reagents in the barrel!")
		/*
		if(istype(selected_recipe, /datum/brewing_recipe/custom_recipe))
			var/datum/brewing_recipe/custom_recipe/recipe = selected_recipe
			message += "Recipe Created By:[recipe.made_by]"
		. += message
		*/
		. += message
	else
		. += span_blue("Right-Click on the Barrel to select a recipe.")

/obj/structure/fermentation_keg/proc/shopping_run(mob/user)
	if(brewing)
		return
	if(selecting_recipe)
		return
	selecting_recipe = TRUE
	addtimer(VARSET_CALLBACK(src, selecting_recipe, FALSE), 5 SECONDS)

	var/list/options = list()
	for(var/path in subtypesof(/datum/brewing_recipe))
		var/datum/brewing_recipe/recipe = path
		var/prereq = initial(recipe.pre_reqs)
		if(!heated && initial(recipe.heat_required))
			continue
		if((!ready_to_bottle && prereq == null) || (selected_recipe?.reagent_to_brew == prereq && ready_to_bottle))
			options[initial(recipe.name)] = recipe


	for(var/datum/brewing_recipe/recipe in GLOB.custom_fermentation_recipes)
		var/prereq = recipe.pre_reqs
		if((!ready_to_bottle && prereq == null) || (selected_recipe?.reagent_to_brew == prereq && ready_to_bottle))
			options[recipe.name] = recipe

	if(options.len == 0)
		return

	if(user.get_skill_level(/datum/skill/craft/cooking) < SKILL_LEVEL_APPRENTICE)
		to_chat(user, span_notice("I am not knowledgable enough to brew."))
		return FALSE

	options = sortList(options)
	var/choice = input(user,"What brew do you want to make?", name) as null|anything in options

	if(!choice)
		return

	var/choice_to_spawn = options[choice]

	/*
	if(istype(choice_to_spawn, /datum/brewing_recipe/custom_recipe))
		selected_recipe = choice_to_spawn
	else
		selected_recipe = new choice_to_spawn
	*/
	selected_recipe = new choice_to_spawn
	selecting_recipe = FALSE

	//Second stage brewing gives no refunds! - This is intented design to help make it so folks dont quit halfway through and still get a rebate
	ready_to_bottle = FALSE
	sellprice = initial(sellprice)
	if(open_icon_state)
		icon_state = open_icon_state
	update_overlays()
	return TRUE

//Remove only chemicals
/obj/structure/fermentation_keg/proc/clear_keg_reagents()
	if(reagents)
		//consume consume consume consume
		reagents.clear_reagents()

//Remove and reset
/obj/structure/fermentation_keg/proc/clear_keg(force = FALSE)
	if(brewing)
		return FALSE

	if(!force && ready_to_bottle)
		return FALSE

	if(reagents)
		reagents.clear_reagents()

	ready_to_bottle = FALSE
	made_item = null
	if(open_icon_state)
		icon_state = open_icon_state
	update_overlays()

	recipe_crop_stocks.Cut()
	age_start_time = 0
	start_time = 0

	sellprice = initial(sellprice)
	tapped = FALSE
	beer_left = 0

	if(force)
		selected_recipe = null

	return TRUE

/obj/structure/fermentation_keg/proc/start_brew()
	brewing = TRUE

	for(var/obj/item/reagent_containers/food/item as anything in selected_recipe.needed_crops)
		if(!(item in recipe_crop_stocks))
			return
		var/amount = recipe_crop_stocks[item] || 0
		recipe_crop_stocks[item] = amount - selected_recipe.needed_crops[item]

	for(var/obj/item/item as anything in selected_recipe.needed_items)
		if(!(item in recipe_crop_stocks))
			return
		var/amount = recipe_crop_stocks[item] || 0
		recipe_crop_stocks[item] = amount - selected_recipe.needed_items[item]

	clear_keg_reagents()

	soundloop.start()
	if(!heated)
		addtimer(CALLBACK(src, PROC_REF(end_brew)), selected_recipe.brew_time)
	if(heated && !selected_recipe.heat_required)
		addtimer(CALLBACK(src, PROC_REF(end_brew)), selected_recipe.brew_time * 0.5)
	icon_state = initial(icon_state)
	start_time = world.time
	update_overlays()

/obj/structure/fermentation_keg/proc/end_brew()
	if(!heated)
		icon_state = "barrel_tapless_ready"
	update_overlays()
	soundloop.stop()
	ready_to_bottle = TRUE
	brewing = FALSE
	sellprice = selected_recipe.sell_value + initial(sellprice)
	made_item = selected_recipe.name
	start_time = 0
	heated_progress_time = 0
	if(selected_recipe.ages)
		age_start_time = world.time

/obj/structure/fermentation_keg/proc/try_n_brew(mob/user)
	var/ready = TRUE
	if(!selected_recipe)
		if(user)
			to_chat(user, span_notice("You need to set a booze to brew!"))
		ready = FALSE

	if(brewing)
		if(user)
			to_chat(user, span_notice("This keg is already brewing a mix!"))
		ready = FALSE
		return ready

	//Crops
	for(var/obj/item/reagent_containers/food/needed_crop as anything in selected_recipe.needed_crops)
		if(recipe_crop_stocks[needed_crop] < selected_recipe.needed_crops[needed_crop])
			if(user)
				to_chat(user, span_notice("This keg needs more [initial(needed_crop.name)]!"))
				ready = FALSE

	for(var/obj/item/needed_item as anything in selected_recipe.needed_items)
		if(recipe_crop_stocks[needed_item] < selected_recipe.needed_items[needed_item])
			if(user)
				to_chat(user, span_notice("This keg needs more [initial(needed_item.name)]!"))
				ready = FALSE

	for(var/datum/reagent/required_chem as anything in selected_recipe.needed_reagents)
		if(selected_recipe.needed_reagents[required_chem] > reagents.get_reagent_amount(required_chem))
			if(user)
				to_chat(user, span_notice("This keg needs more [initial(required_chem.name)]!"))
				ready = FALSE

	if(!selected_recipe)
		return

	// doubles the brew speed
	if(!selected_recipe.heat_required && rotation_speed_mult > 1)
		addtimer(CALLBACK(src, PROC_REF(check_rotated_brew_end)), round((selected_recipe.brew_time * 0.5) / rotation_speed_mult))

	return ready

/obj/structure/fermentation_keg/proc/refuel(obj/item/item, mob/user)
	user.visible_message("[user] starts refueling [src].", "You start refueling [src].")
	if(!do_after(user, 1.5 SECONDS, src))
		return
	var/burn_time = 4 MINUTES
	var/burn_temp = 300
	if(istype(item, /obj/item/rogueore/coal))
		burn_time *= 1.5
		burn_temp *= 1.5

	heat_decay = world.time + burn_time
	heat = min(1000, burn_temp + heat)
	qdel(item)

/obj/structure/fermentation_keg/proc/create_items()
	if(!ready_to_bottle)
		return

	ready_to_bottle = FALSE
	made_item = null
	tapped = FALSE
	age_start_time = 0
	beer_left = 0
	brewing = FALSE
	sellprice = initial(sellprice)
	heated_progress_time = 0
	start_time = 0
	if(open_icon_state)
		icon_state = open_icon_state
	update_overlays()

	if(selected_recipe.brewed_item)
		var/items_given
		for(items_given= 0, items_given < selected_recipe.brewed_item_count, items_given++)
			new selected_recipe.brewed_item(get_turf(src))
	selected_recipe = null


/obj/structure/fermentation_keg/proc/bottle(glass_colour)
	if(ready_to_bottle)

		ready_to_bottle = FALSE
		made_item = null
		tapped = FALSE
		age_start_time = 0
		beer_left = 0
		brewing = FALSE
		sellprice = initial(sellprice)
		heated_progress_time = 0
		start_time = 0
		if(open_icon_state)
			icon_state = open_icon_state
		update_overlays()

		if(selected_recipe.reagent_to_brew)
			if(!glass_colour)
				glass_colour = "brew_bottle"

			var/bottle_path = selected_recipe.output_bottle_type || /obj/item/reagent_containers/glass/bottle/brewing_bottle
			var/bottlecaps
			for(bottlecaps = 0, bottlecaps < selected_recipe.brewed_amount, bottlecaps++)
				var/obj/item/reagent_containers/glass/bottle/brewing_bottle/bottle_made = new bottle_path(get_turf(src))
				bottle_made.icon_state = "[glass_colour]"
				bottle_made.name = "brewer's bottle of [selected_recipe.bottle_name]"
				bottle_made.sellprice = round(selected_recipe.sell_value / selected_recipe.brewed_amount)
				bottle_made.desc =  selected_recipe.bottle_desc || "A bottle of locally-brewed [selected_recipe.bottle_name]."
				var/datum/reagent/brewed_reagent = selected_recipe.reagent_to_brew
				if(selected_recipe.ages)
					var/time = world.time - age_start_time
					for(var/path in selected_recipe.age_times)
						if(time > selected_recipe.age_times[path])
							brewed_reagent = path
				bottle_made.reagents.add_reagent(brewed_reagent, selected_recipe.per_brew_amount)
		if(selected_recipe.brewed_item)
			var/items_given
			for(items_given= 0, items_given < selected_recipe.brewed_item_count, items_given++)
				new selected_recipe.brewed_item(get_turf(src))
		selected_recipe = null

/obj/structure/fermentation_keg/proc/try_tapping(mob/user)
	if(tapped)
		return
	visible_message("[user] starts tapping [src].", "You start tapping [src].")
	if(!do_after(user, 4 SECONDS, src))
		return
	tapped = TRUE
	if(tapped_icon_state)
		icon_state = tapped_icon_state
	sellprice = 0
	beer_left = selected_recipe.brewed_amount * selected_recipe.per_brew_amount

/obj/structure/fermentation_keg/proc/try_filling(mob/user, obj/item/reagent_containers/container)
	if(!tapped)
		return
	visible_message("[user] starts pouring from [src].", "You start pouring from [src].")
	if(!do_after(user, 1 SECONDS, src))
		return
	var/beer_taken = min((container.reagents.maximum_volume - container.reagents.total_volume), beer_left)

	beer_left -= beer_taken

	var/datum/reagent/brewed_reagent = selected_recipe.reagent_to_brew
	if(selected_recipe.ages)
		var/time = world.time - age_start_time
		for(var/path in selected_recipe.age_times)
			if(time > selected_recipe.age_times[path])
				brewed_reagent = path
	container.reagents.add_reagent(brewed_reagent, beer_taken)

	if(beer_left <= 0)
		clear_keg(TRUE)

/obj/structure/fermentation_keg/process()
	if(brewing && selected_recipe.heat_required)
		var/end_time = world.time + (selected_recipe.brew_time - heated_progress_time)
		if(world.time > end_time)
			end_brew()
		if((heat > selected_recipe.heat_required))
			heated_progress_time += world.time - start_time
		start_time = world.time

	if(heat_decay < world.time)
		heat = max(300, heat-5)


/obj/item/reagent_containers/glass/bottle/brewing_bottle
	name = "brewer's bottle"
	desc = "A bottle with a cork."
	icon =  'icons/obj/bottle.dmi'
	icon_state = "brew_bottle"

	var/glass_name
	var/glass_desc
	var/sealed = TRUE
	glass_on_impact = FALSE // Prevent duping glass

/obj/item/reagent_containers/glass/bottle/brewing_bottle/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(target.type in (typesof(/obj/item/reagent_containers/glass) - typesof(/obj/item/reagent_containers/glass/bottle)))
		if(glass_name)
			target.name = glass_name
		if(glass_desc)
			target.desc = glass_desc
	if(reagents.total_volume <= 0)
		glass_desc = null
		glass_name = null

/obj/item/reagent_containers/glass/bottle/brewing_bottle/examine()
	. = ..()
	if(sealed)
		. += span_notice("The bottle is sealed. It can sell for something.")
	else
		. += span_notice("The bottle has been unsealed. It cannot be sold anymore.")

/obj/item/reagent_containers/glass/bottle/brewing_bottle/rmb_self(mob/user)
	. = ..()
	sealed = FALSE
	sellprice = 0

/obj/structure/fermentation_keg/MouseDrop_T(atom/over, mob/living/user)
	if(!istype(over, /obj/structure/fermentation_keg))
		return
	if(!Adjacent(over))
		return
	if(!Adjacent(user))
		return
	var/obj/structure/fermentation_keg/keg = over
	if(selected_recipe)
		if(keg.tapped)
			if(!(keg.selected_recipe.reagent_to_brew in selected_recipe.needed_reagents))
				return

			var/datum/reagent/reagent = reagents.get_reagent(keg.selected_recipe.reagent_to_brew)
			var/reagents_needed = selected_recipe.needed_reagents[keg.selected_recipe.reagent_to_brew]
			reagents_needed -= reagent?.volume

			if(!reagents_needed)
				return

			var/transfer_amount = min(reagents_needed, keg.beer_left)

			user.visible_message("[user] starts to pour [keg] into [src]." , "You start to pour [keg] in [src].")
			if(!do_after(user, 5 SECONDS, keg))
				return
			reagents.add_reagent(selected_recipe.reagent_to_brew, transfer_amount)
			keg.beer_left -= transfer_amount
			if(keg.beer_left <= 0)
				keg.clear_keg(TRUE)

		else
			for(var/datum/reagent/reagent in keg.reagents.reagent_list)
				if(!(reagent.type in selected_recipe.needed_reagents))
					continue
				var/datum/reagent/keg_reagent = reagents.get_reagent(reagent.type)
				var/reagents_needed = selected_recipe.needed_reagents[reagent.type]
				reagents_needed -= keg_reagent?.volume
				if(!reagents_needed)
					return

				var/transfer_amount = min(reagents_needed, reagent.volume)
				user.visible_message("[user] starts to pour [keg] into [src]." , "You start to pour [keg] in [src].")
				if(!do_after(user, 5 SECONDS, keg))
					return
				reagents.add_reagent(reagent.type, transfer_amount)
				keg.reagents.remove_reagent(reagent.type, transfer_amount)
	else
		if(!keg.tapped)
			return
		user.visible_message("[user] starts to pour [keg] into [src]." , "You start to pour [keg] in [src].")
		if(!do_after(user, 5 SECONDS, keg))
			return
		reagents.add_reagent(keg.selected_recipe?.reagent_to_brew, keg.beer_left)
		keg.beer_left = 0
		keg.clear_keg(TRUE)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/mead
/obj/item/reagent_containers/glass/bottle/brewing_bottle/spidermead
/obj/item/reagent_containers/glass/bottle/brewing_bottle/jack_wine
/obj/item/reagent_containers/glass/bottle/brewing_bottle/plum_wine
/obj/item/reagent_containers/glass/bottle/brewing_bottle/tangerine_wine
/obj/item/reagent_containers/glass/bottle/brewing_bottle/blackberry_wine
/obj/item/reagent_containers/glass/bottle/brewing_bottle/whipwine
/obj/item/reagent_containers/glass/bottle/brewing_bottle/luxintenebre
/obj/item/reagent_containers/glass/bottle/brewing_bottle/winespiced
/obj/item/reagent_containers/glass/bottle/brewing_bottle/voddena
/obj/item/reagent_containers/glass/bottle/brewing_bottle/nocmash
/obj/item/reagent_containers/glass/bottle/brewing_bottle/nocshine
/obj/item/reagent_containers/glass/bottle/brewing_bottle/beer
/obj/item/reagent_containers/glass/bottle/brewing_bottle/beer_oat
/obj/item/reagent_containers/glass/bottle/brewing_bottle/cider
/obj/item/reagent_containers/glass/bottle/brewing_bottle/gin
/obj/item/reagent_containers/glass/bottle/brewing_bottle/ricespirit
/obj/item/reagent_containers/glass/bottle/brewing_bottle/limoncello
/obj/item/reagent_containers/glass/bottle/brewing_bottle/rum
/obj/item/reagent_containers/glass/bottle/brewing_bottle/aqua_vitae
/obj/item/reagent_containers/glass/bottle/brewing_bottle/brandy
/obj/item/reagent_containers/glass/bottle/brewing_bottle/brandy_plum
/obj/item/reagent_containers/glass/bottle/brewing_bottle/brandy_pear
/obj/item/reagent_containers/glass/bottle/brewing_bottle/fermentedcrab
/obj/item/reagent_containers/glass/bottle/brewing_bottle/calendula_tea
/obj/item/reagent_containers/glass/bottle/brewing_bottle/valerian_tea

/obj/structure/fermentation_keg/distiller
	name = "copper distiller"

	icon = 'icons/obj/distillery.dmi'
	icon_state = "distillery"
	tapped_icon_state = null
	open_icon_state = null

	anchored = TRUE
	heated = TRUE

//this is the part fo copper distillers to speed up
/obj/structure/fermentation_keg/distiller
	rotation_structure = TRUE
	stress_use = 32
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_LEFT | CONN_DIR_RIGHT | CONN_DIR_FLIP
	/// Speed multiplier: 1 = normal, 2 = twice as fast at 32+ RPM

/obj/structure/fermentation_keg/distiller/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(speed ? stress_use : 0)
	rotation_speed_mult = (speed >= 32) ? 2 : 1

/obj/structure/fermentation_keg/proc/check_rotated_brew_end()
	if(!brewing)
		return
	end_brew()

/obj/structure/fermentation_keg/distiller/process()
	// Heat decay always runs
	if(heat_decay < world.time)
		heat = max(300, heat - 5)

	if(!brewing || !selected_recipe)
		return
	// Non-heat-required recipes use addtimer — nothing to do in process
	if(!selected_recipe.heat_required)
		return

	if(!start_time)
		start_time = world.time
		return

	if(heat > selected_recipe.heat_required)
		var/tick_progress = world.time - start_time
		heated_progress_time += tick_progress * rotation_speed_mult

	start_time = world.time

	if(heated_progress_time >= selected_recipe.brew_time)
		end_brew()


/obj/structure/fermentation_keg/distiller/examine(mob/user)
	. = ..()
	if(selected_recipe && !ready_to_bottle && rotation_speed_mult > 1)
		var/multiplier = selected_recipe.heat_required ? 1 : 0.5
		multiplier /= rotation_speed_mult
		var/effective_time = selected_recipe.brew_time * multiplier
		if(effective_time >= 1 MINUTES)
			. += span_notice("At current RPM, actual brew time: [round(effective_time / 600, 0.1)] minutes.")
		else
			. += span_notice("At current RPM, actual brew time: [round(effective_time / 10, 0.1)] seconds.")
