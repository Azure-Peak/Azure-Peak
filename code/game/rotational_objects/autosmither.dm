#define STEP_FIDDLE "fiddle with the machine"
#define STEP_LEVER "pull the lever"
#define STEP_BUTTON "push a button"

/obj/structure/autosmither
	name = "auto anvil"
	desc = "A holy amalgamation of buttons and levers built purposely to fulfill Malum's will."

	icon = 'icons/obj/autosmithy.dmi'
	icon_state = "1"
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_LEFT | CONN_DIR_FLIP | CONN_DIR_Z_DOWN
	anchored = TRUE
	density = TRUE
	var/list/anvil_recipes_to_craft = list()
	var/list/completed_items = list()

	var/datum/anvil_recipe/current
	var/list/current_requirements = list()

	var/obj/structure/material_bin/bin

	var/working = FALSE
	var/bloodied = FALSE

	var/progress = 0
	var/needed_progress = 100

	var/static/list/regular_recipes = list()

	var/list/step_list = list()

	var/list/pre_start_list = list(STEP_FIDDLE, STEP_BUTTON, STEP_LEVER)
	var/list/post_start_list = list(STEP_BUTTON, STEP_LEVER, STEP_FIDDLE)
	debris = list(/obj/item/roguegear = 2, /obj/item/natural/wood/plank = 2, /obj/item/ingot/steel = 1)

/obj/structure/autosmither/Initialize()
	. = ..()
	var/turf/turf = get_step(src, EAST)
	bin = new /obj/structure/material_bin(turf)
	bin.parent = src
	LAZYINITLIST(regular_recipes)
	if(!length(regular_recipes))
		for(var/datum/anvil_recipe/recipe_path as anything in subtypesof(/datum/anvil_recipe))
			if(IS_ABSTRACT(recipe_path))
				continue
			if(!((recipe_path.req_bar == /obj/item/ingot/copper)||(recipe_path.req_bar == /obj/item/ingot/bronze)||(recipe_path.req_bar == /obj/item/ingot/iron) || (recipe_path.req_bar == /obj/item/ingot/steel)||(recipe_path.req_bar == /obj/item/ingot/tin)))//it needs to be at least tin, copper, iron, bronze, or steel
				continue
			regular_recipes |= new recipe_path

	START_PROCESSING(SSobj, src)

/obj/structure/autosmither/Destroy()
	if(current)
		QDEL_NULL(current)
	for(var/datum/anvil_recipe/recipe as anything in regular_recipes)
		LAZYREMOVE(regular_recipes, recipe)
		QDEL_NULL(recipe)
	QDEL_NULL(bin)
	current_requirements.Cut()
	anvil_recipes_to_craft.Cut()
	completed_items.Cut()
	return ..()

/obj/structure/autosmither/examine(mob/user)
	. = ..()
	var/next_step
	if(!working)
		next_step = pre_start_list[length(step_list) + 1]
		. += span_notice("[src] is currently OFF.")
	else
		next_step = post_start_list[length(step_list) + 1]
		. += span_notice("[src] is currently ON.")

	if (user.get_skill_level(/datum/skill/craft/engineering) > 3) //you have enough knowledge to know the sequence
		switch(next_step)
			if(STEP_FIDDLE)
				. += span_notice("To toggle the machine, fiddle with the dials")
			if(STEP_BUTTON)
				. += span_notice("To toggle the machine, push the buttons")
			if(STEP_LEVER)
				. += span_notice("To toggle the machine, pull the lever")
	
	. += span_notice("It is Set to Craft")
	if(anvil_recipes_to_craft.len > 0)
		for(var/i in 1 to anvil_recipes_to_craft.len)
			. += span_notice("[anvil_recipes_to_craft[i]]")


/obj/structure/autosmither/process()
	if(!working)
		return
	if(!length(anvil_recipes_to_craft))
		return
	try_set_recipe_stuff()

	if(current.rotations_required > rotations_per_minute)
		return

	var/list/material_copy = current_requirements.Copy()
	for(var/atom/listed_atom in bin.contents)
		if(listed_atom.type in material_copy)
			material_copy[listed_atom.type]--
			if(material_copy[listed_atom.type] <= 0)
				material_copy -= listed_atom.type

	if(length(material_copy))
		return

	progress += 5 * (rotations_per_minute / 16)
	if(progress >= needed_progress)
		create_current()

/obj/structure/autosmither/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!working)
		return

	if(!istype(I, /obj/item/grabbing))
		return
	var/obj/item/grabbing/grab = I
	var/mob/living/carbon/victim = grab.grabbed
	if(!istype(victim))
		return
	user.visible_message(span_danger("[user] starts to put [victim] under [src]!"), span_danger("You start to put [victim] under [src]!"))
	if(!do_after(user, 10 SECONDS, src))
		return

	if (user.get_skill_level(/datum/skill/craft/engineering) < 3)
		var/fiftyfifty = pick(TRUE,FALSE) // 50/50 Chance you smash your hand if you're not experienced enough
		if(fiftyfifty)
			user.visible_message(span_danger("[user] gets their arm caught in [src] instead!"), span_danger("You get your arm caught in [src]!"))
			var/body_zone = BODY_ZONE_R_ARM
			if(user.active_hand_index == 1)
				body_zone = BODY_ZONE_L_ARM
			user.apply_damage(4 * max(1, (rotations_per_minute / 8)), BRUTE, body_zone)
			playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
			return

	victim.apply_damage(10 * (rotations_per_minute / 8), BRUTE, BODY_ZONE_HEAD)
	playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	bloodied = TRUE
	update_animation_effect()

/obj/structure/autosmither/attack_right(mob/user, list/modifiers)
	. = ..()
	var/option = tgui_input_list(user, "What Do you want to do?", "Autosmither", list("Pull the lever", "Push the Buttons", "Fiddle with the Dials"))
	//var/option = input(user, "What Do you want to do?", src) as null|anything in list("Pull the lever", "Push the Buttons", "Fiddle with the Dials")
	if(!option)
		return
	if(option == "Pull the lever")
		playsound(src, 'sound/foley/lever.ogg', 100, extrarange = -1)
		try_step(STEP_LEVER, user)
		return TRUE
	if(option == "Push the Buttons")
		playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
		if(!user.Adjacent(src))
			return
		try_step(STEP_BUTTON, user)
		return TRUE
	if(option == "Fiddle with the Dials")
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		if(. == 2) //SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
			return
		try_step(STEP_FIDDLE, user)
		return TRUE //SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN



/obj/structure/autosmither/attack_hand(mob/user)
	. = ..()
	if(!check_step_damage(user))
		return
	if(working)
		to_chat(user, span_notice("You can't changes the recipe queue while the machine is running, turn it off first."))
		return

	var/option = tgui_input_list(user, "Remove or Add a recipe?", "Autosmither", list("Add", "Remove"))
	//var/option = input(user, "Remove or Add a recipe?", src) as null|anything in list("Add", "Remove")
	if(!option)
		return

	if(option == "Add")
		var/list/options = list()
		for(var/datum/anvil_recipe/recipe as anything in regular_recipes)
			options |= recipe

		if(!length(options))
			return

		var/datum/anvil_recipe/choice = tgui_input_list(user, "Choose a recipe to add to the queue", "Autosmither", options)
		//var/datum/anvil_recipe/choice = input(user, "Choose a recipe to add to the queue", src) as null|anything in options
		if(!choice)
			return
		anvil_recipes_to_craft |= choice
	else
		var/datum/anvil_recipe/choice = tgui_input_list(user, "Choose a recipe to remove from the queue", "Autosmither", anvil_recipes_to_craft)
		//var/datum/anvil_recipe/choice = input(user, "Choose a recipe to remove from the queue", src) as null|anything in anvil_recipes_to_craft
		if(!choice)
			return
		if(choice == current)
			current = null
			progress = 0
		anvil_recipes_to_craft -= choice

/obj/structure/autosmither/update_animation_effect()
	if(!bloodied)
		if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute || !working)
			animate(src, icon_state = "1", time = 1)
			return
		var/frame_stage = 1 / ((rotations_per_minute / 30) * 5)
		if(rotation_direction == WEST)
			animate(src, icon_state = "1", time = frame_stage, loop=-1)
			animate(icon_state = "2", time = frame_stage)
			animate(icon_state = "3", time = frame_stage)
			animate(icon_state = "4", time = frame_stage)
			animate(icon_state = "5", time = frame_stage)
		else
			animate(src, icon_state = "5", time = frame_stage, loop=-1)
			animate(icon_state = "4", time = frame_stage)
			animate(icon_state = "3", time = frame_stage)
			animate(icon_state = "2", time = frame_stage)
			animate(icon_state = "1", time = frame_stage)
	else
		if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute || !working)
			animate(src, icon_state = "b1", time = 1)
			return
		var/frame_stage = 1 / ((rotations_per_minute / 30) * 5)
		if(rotation_direction == WEST)
			animate(src, icon_state = "b1", time = frame_stage, loop=-1)
			animate(icon_state = "b2", time = frame_stage)
			animate(icon_state = "b3", time = frame_stage)
			animate(icon_state = "b4", time = frame_stage)
			animate(icon_state = "b5", time = frame_stage)
		else
			animate(src, icon_state = "b5", time = frame_stage, loop=-1)
			animate(icon_state = "b4", time = frame_stage)
			animate(icon_state = "b3", time = frame_stage)
			animate(icon_state = "b2", time = frame_stage)
			animate(icon_state = "b1", time = frame_stage)

/obj/structure/autosmither/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(128 * (speed / 8))

/obj/structure/autosmither/proc/try_set_recipe_stuff()

	var/datum/anvil_recipe/first = anvil_recipes_to_craft[1]
	if(first == current)
		return

	var/list/materials = list()

	materials |= first.req_bar
	materials[first.req_bar]++

	for(var/atom/atom_path as anything in first.additional_items)
		materials |= atom_path
		materials[atom_path]++

	current = first
	current_requirements = materials
	needed_progress = max(1, current.craftdiff) * 100

/obj/structure/autosmither/proc/create_current()
	var/list/material_copy = current_requirements.Copy()
	for(var/atom/listed_atom in bin.contents)
		if(listed_atom.type in material_copy)
			material_copy[listed_atom.type]--
			SEND_SIGNAL(bin, COMSIG_TRY_STORAGE_TAKE, listed_atom, get_turf(src), TRUE)
			qdel(listed_atom)

			if(material_copy[listed_atom.type] <= 0)
				material_copy -= listed_atom.type

	var/obj/item/new_item
	for(var/i in 1 to current.createditem_num)
		new_item = new current.created_item(get_turf(bin))
		if (new_item.obj_integrity < new_item.max_integrity)
			new_item.obj_integrity = new_item.max_integrity //reseting the integrity
			//new_atom.update_integrity(new_atom.max_integrity, update_atom = FALSE)
		SEND_SIGNAL(bin, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE)
	visible_message(span_notice("[new_item] falls into the hopper of [src]."))
	playsound(src, pick('sound/combat/armor_degrade2.ogg','sound/combat/armor_degrade3.ogg'), 200, FALSE, 3)
	anvil_recipes_to_craft -= current
	current = null
	current_requirements = list()
	progress = 0


/obj/structure/autosmither/proc/check_step_damage(mob/living/user)
	if(!length(step_list))
		return TRUE

	var/body_zone = BODY_ZONE_R_ARM
	if(user.active_hand_index == 1)
		body_zone = BODY_ZONE_L_ARM
	if(working)
		user.apply_damage(15 * (rotations_per_minute / 8), BRUTE, body_zone)
		playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		user.visible_message(span_danger("[user] gets their arm crushed by [src]!"), span_danger("You get your arm crushed by [src]!"))
		bloodied = TRUE
		update_animation_effect()

	var/step_on = step_list[length(step_list)]

	//
	switch(step_on)
		if(STEP_FIDDLE)
			return TRUE
			//user.apply_damage(5 * (rotations_per_minute / 8), BRUTE, body_zone)
			//playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
			//user.visible_message(span_danger("[user] get their hand caught in [src]'s cogs!"), span_danger("You get your hand caught in [src]'s cogs!"))
		if(STEP_LEVER)
			return TRUE
		if(STEP_BUTTON)
			return TRUE
			//user.apply_damage(8 * (rotations_per_minute / 8), BRUTE, body_zone)
			//playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
			//user.visible_message(span_danger("[user] gets their hand flattened by [src]!"), span_danger("You get your hand flattened by[src]!"))

/obj/structure/autosmither/proc/try_step(step_type, mob/living/user)

	var/next_step
	var/engineering_skill = user.get_skill_level(/datum/skill/craft/engineering)
	var/body_zone = BODY_ZONE_R_ARM
	if(!working)
		next_step = pre_start_list[length(step_list) + 1]
	else
		next_step = post_start_list[length(step_list) + 1]

	if (engineering_skill < 3)
		var/fiftyfifty = pick(TRUE,FALSE) // 50/50 Chance you smash your hand if you're not experienced enough
		if(fiftyfifty)
			user.visible_message(span_danger("[user] gets their arm caught in [src]!"), span_danger("You get your arm caught in [src]!"))
			if(user.active_hand_index == 1)
				body_zone = BODY_ZONE_L_ARM
			user.apply_damage(4 * max(1, (rotations_per_minute / 8)), BRUTE, body_zone)
			playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
			return

	if(next_step != step_type)
		user.visible_message(span_danger("[user] messes with [src]! The sequence is reset!"), span_danger("You mess with [src]! The sequence is reset!"))
		user.visible_message(span_danger("[user] gets their arm caught in [src]!"), span_danger("You get your arm caught in [src]!"))
		if(user.active_hand_index == 1)
			body_zone = BODY_ZONE_L_ARM
		if(engineering_skill > 1) //damage is reduced by how much engineering skill you have
			user.apply_damage(4 * max(1, ((rotations_per_minute / 8) / engineering_skill)), BRUTE, body_zone)
		else
			user.apply_damage(4 * max(1, (rotations_per_minute / 8)), BRUTE, body_zone)
		playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		step_list = list()
		return

	if(!do_after(user, 1.2 SECONDS, src))
		return

	to_chat(user, span_notice("You [step_type]."))
	step_list |= step_type

	if(working)
		if(length(step_list) == length(post_start_list))
			working = FALSE
			step_list = list()
			update_animation_effect()
	else
		if(length(step_list) == length(pre_start_list))
			working = TRUE
			step_list = list()
			update_animation_effect()

/obj/structure/material_bin
	name = "auto anvil hopper"
	desc = "The storage can be opened and closed with RMB."

	icon = 'icons/obj/autosmithy.dmi'
	icon_state = "material"

	var/opened = FALSE
	var/obj/structure/autosmither/parent

/obj/structure/material_bin/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/anvil_bin)

/obj/structure/material_bin/Destroy()
	parent = null
	return ..()

/obj/structure/material_bin/update_icon_state()
	. = ..()
	if(opened)
		icon_state = "material1"
	else
		icon_state = initial(icon_state)

/obj/structure/material_bin/attack_right(mob/user, list/modifiers)
	. = 2 //SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.visible_message(span_danger("[user] starts to [opened ? "close" : "open"] [src]."), span_danger("You start to [opened ? "close" : "open"] [src]."))
	if(!do_after(user, 2.5 SECONDS, src))
		return
	opened = !opened
	vand_update_appearance(UPDATE_ICON_STATE)
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_HIDE_ALL)

#undef STEP_FIDDLE
#undef STEP_LEVER
#undef STEP_BUTTON
