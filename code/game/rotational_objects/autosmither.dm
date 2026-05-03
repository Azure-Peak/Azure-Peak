#define STEP_FIDDLE "fiddle with the machine"
#define STEP_LEVER "pull the lever"
#define STEP_BUTTON "push a button"

/datum/looping_sound/autosmither_work
	mid_sounds = 'sound/items/bsmithfail.ogg'
	mid_length = 10
	volume = 45

/datum/autosmither_queue_entry
	var/id
	var/type_path

/datum/autosmither_queue_entry/New(new_id, new_type_path)
	id = new_id
	type_path = new_type_path
	. = ..()

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
	var/next_queue_id = 1

	var/datum/anvil_recipe/current
	var/current_queue_id

	var/hopper_type = /obj/structure/closet/crate/chest/autosmither
	var/obj/structure/closet/crate/chest/autosmither/hopper

	var/working = FALSE
	var/bloodied = FALSE
	var/datum/looping_sound/autosmither_work/soundloop

	var/progress = 0
	var/needed_progress = 100

	var/static/list/regular_recipes = list()
	var/missing_materials_alert = FALSE
	var/queue_finished_alert = FALSE

	var/list/step_list = list()

	var/list/pre_start_list = list(STEP_FIDDLE, STEP_BUTTON, STEP_LEVER)
	var/list/post_start_list = list(STEP_BUTTON, STEP_LEVER, STEP_FIDDLE)
	debris = list(/obj/item/roguegear = 2, /obj/item/natural/wood/plank = 2, /obj/item/ingot/steel = 1)

/obj/structure/autosmither/Initialize()
	. = ..()
	var/turf/turf = get_step(src, EAST)
	hopper = new hopper_type(turf)
	hopper.parent = src
	soundloop = new(src, FALSE)
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
	QDEL_NULL(soundloop)
	for(var/datum/autosmither_queue_entry/queue_entry as anything in anvil_recipes_to_craft)
		qdel(queue_entry)
	QDEL_NULL(hopper)
	anvil_recipes_to_craft.Cut()
	return ..()

/obj/structure/autosmither/examine(mob/user)
	. = ..()
	var/next_step
	if(!working)
		next_step = pre_start_list[length(step_list) + 1]
	else
		next_step = post_start_list[length(step_list) + 1]

	if (user.get_skill_level(/datum/skill/craft/engineering) > 3)
		switch(next_step)
			if(STEP_FIDDLE)
				. += span_notice("To toggle the machine, fiddle with the dials")
			if(STEP_BUTTON)
				. += span_notice("To toggle the machine, push the buttons")
			if(STEP_LEVER)
				. += span_notice("To toggle the machine, pull the lever")

/obj/structure/autosmither/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click it with an empty hand to open its control interface and manage its crafting queue.")
	. += span_info("It crafts from the attached hopper chest and only works while connected to a powered rotational network with enough RPM.")
	. += span_info("Use its interface to perform its start or stop sequence: pull the lever, push the buttons, and fiddle with the dials in the correct order.")
	. += span_info("Open the hopper chest while the autosmithy is off, load materials into it, then close it before starting the machine.")
	. += span_info("Each recipe consumes its required materials as soon as that recipe starts.")
	if(user.get_skill_level(/datum/skill/craft/engineering) > 3)
		. += span_info("Skilled engineers can read the next required step from the machine's normal examine text.")

/obj/structure/autosmither/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autosmither", "Auto Anvil")
		ui.open()

/obj/structure/autosmither/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/anvil_recipes)
	)

/obj/structure/autosmither/ui_static_data(mob/user)
	var/list/data = ..()
	var/list/recipes = list()
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/anvil_recipes)

	for(var/datum/anvil_recipe/recipe as anything in regular_recipes)
		var/list/requirements = recipe_req_data(recipe)
		UNTYPED_LIST_ADD(recipes, list(
			"name" = recipe.name,
			"category" = recipe.i_type || recipe.category,
			"ref" = REF(recipe),
			"icon" = spritesheet.icon_class_name(sanitize_css_class_name("recipe_[REF(recipe)]")),
			"icon_file" = "[initial(recipe.created_item:icon)]",
			"icon_state" = "[initial(recipe.created_item:icon_state)]",
			"created_num" = recipe.createditem_num,
			"requirements" = requirements
		))

	data["recipes"] = recipes
	return data

/obj/structure/autosmither/ui_data(mob/user)
	var/list/data = ..()
	var/list/current_recipes = list()
	var/list/hopper_counts = list()
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/anvil_recipes)

	for(var/i in 1 to anvil_recipes_to_craft.len)
		var/datum/autosmither_queue_entry/queue_entry = anvil_recipes_to_craft[i]
		var/datum/anvil_recipe/recipe = queue_recipe(queue_entry)
		if(!recipe)
			continue
		UNTYPED_LIST_ADD(current_recipes, list(
			"id" = queue_entry.id,
			"index" = i,
			"name" = recipe.name,
			"category" = recipe.i_type || recipe.category,
			"icon" = spritesheet.icon_class_name(sanitize_css_class_name("recipe_[REF(recipe)]")),
			"created_num" = recipe.createditem_num,
			"active" = (queue_entry.id == current_queue_id)
		))

	if(hopper)
		for(var/atom/movable/item in hopper.contents)
			var/type_key = "[item.type]"
			hopper_counts[type_key] = (hopper_counts[type_key] || 0) + 1

	data["machine_on"] = working
	data["machine_powered"] = has_power_flow()
	data["status_state"] = status_text()
	data["controls_locked"] = !user?.Adjacent(src)
	data["hopper_counts"] = hopper_counts
	data["current_recipes"] = current_recipes
	data["current_recipe_ref"] = current ? REF(current) : null
	data["progress"] = progress
	data["needed_progress"] = needed_progress
	return data

/obj/structure/autosmither/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("add_recipe")
			var/datum/anvil_recipe/recipe = locate(params["ref"])
			if(!istype(recipe) || !(recipe in regular_recipes))
				return TRUE
			var/amount = clamp(text2num(params["amount"]), 1, 25)
			for(var/i in 1 to amount)
				anvil_recipes_to_craft += create_queue_entry(recipe)
			return TRUE
		if("remove_recipe")
			var/queue_id = text2num(params["id"])
			if(!queue_id)
				return TRUE
			if(queue_id == current_queue_id)
				clear_current_recipe()
			remove_entry_id(queue_id)
			update_animation_effect()
			return TRUE
		if("lever")
			control_act("lever", ui.user)
			return TRUE
		if("button")
			control_act("button", ui.user)
			return TRUE
		if("dial")
			control_act("dial", ui.user)
			return TRUE
	return FALSE


/obj/structure/autosmither/process()
	if(!working)
		return
	if(!hopper || hopper.opened)
		update_animation_effect()
		return
	if(!length(anvil_recipes_to_craft))
		update_animation_effect()
		notify_queue_finished()
		return
	queue_finished_alert = FALSE
	var/had_current = !!current
	if(!try_recipe_queue())
		update_animation_effect()
		notify_missing_materials()
		return
	if(!had_current && current)
		update_animation_effect()

	if(current.rotations_required > rotations_per_minute)
		update_animation_effect()
		return
	missing_materials_alert = FALSE

	progress += 5 * (rotations_per_minute / 16)
	if(progress >= needed_progress)
		create_current()

/obj/structure/autosmither/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
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
		var/fiftyfifty = pick(TRUE,FALSE)
		if(fiftyfifty)
			user.visible_message(span_danger("[user] gets their arm caught in [src] instead!"), span_danger("You get your arm caught in [src]!"))
			user.apply_damage(4 * max(1, (rotations_per_minute / 8)), BRUTE, active_arm_zone(user))
			playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
			return

	victim.apply_damage(10 * (rotations_per_minute / 8), BRUTE, BODY_ZONE_HEAD)
	playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	bloodied = TRUE
	update_animation_effect()

/obj/structure/autosmither/proc/control_act(control, mob/user)
	if(!user?.Adjacent(src))
		return FALSE

	switch(control)
		if("lever")
			playsound(src, 'sound/foley/lever.ogg', 100, extrarange = -1)
			try_step(STEP_LEVER, user)
			return TRUE
		if("button")
			playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
			try_step(STEP_BUTTON, user)
			return TRUE
		if("dial")
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			try_step(STEP_FIDDLE, user)
			return TRUE
	return FALSE



/obj/structure/autosmither/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	ui_interact(user)

/obj/structure/autosmither/update_animation_effect()
	update_soundloop()
	if(!bloodied)
		if(!show_working_anim())
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
		if(!show_working_anim())
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

/obj/structure/autosmither/proc/update_soundloop()
	if(!soundloop)
		return
	if(show_working_anim())
		if(soundloop.stopped)
			soundloop.start()
		return
	if(!soundloop.stopped)
		soundloop.stop()

/obj/structure/autosmither/proc/show_working_anim()
	if(!working || !rotation_network || rotation_network?.overstressed || !rotations_per_minute)
		return FALSE
	if(!current || !hopper || hopper.opened)
		return FALSE
	return current.rotations_required <= rotations_per_minute

/obj/structure/autosmither/proc/has_power_flow()
	return rotation_network && !rotation_network?.overstressed && rotations_per_minute

/obj/structure/autosmither/proc/status_text()
	if(!working)
		return "off"
	if(!current && length(anvil_recipes_to_craft))
		var/datum/anvil_recipe/queued_recipe = first_queued_recipe()
		if(queued_recipe && !recipe_has_mats(queued_recipe))
			return "waiting"
	if(show_working_anim())
		return "working"
	return "on"

/obj/structure/autosmither/proc/stop_work()
	working = FALSE
	step_list = list()
	update_animation_effect()

/obj/structure/autosmither/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	if(!speed && working)
		stop_work()
	set_stress_use(128 * (speed / 8))

/obj/structure/autosmither/rotation_break()
	if(working)
		stop_work()
	return ..()

/obj/structure/autosmither/proc/first_queued_recipe()
	if(!length(anvil_recipes_to_craft))
		return null
	return queue_recipe(anvil_recipes_to_craft[1])

/obj/structure/autosmither/proc/find_regular_recipe(type_path)
	for(var/datum/anvil_recipe/recipe as anything in regular_recipes)
		if(recipe.type == type_path)
			return recipe
	return null

/obj/structure/autosmither/proc/create_queue_entry(datum/anvil_recipe/recipe)
	return new /datum/autosmither_queue_entry(next_queue_id++, recipe.type)

/obj/structure/autosmither/proc/queue_recipe(datum/autosmither_queue_entry/queue_entry)
	if(!istype(queue_entry))
		return null
	return find_regular_recipe(queue_entry.type_path)

/obj/structure/autosmither/proc/remove_entry_id(queue_id)
	for(var/i in 1 to anvil_recipes_to_craft.len)
		var/datum/autosmither_queue_entry/queue_entry = anvil_recipes_to_craft[i]
		if(queue_entry.id != queue_id)
			continue
		qdel(queue_entry)
		anvil_recipes_to_craft.Cut(i, i + 1)
		return TRUE
	return FALSE

/obj/structure/autosmither/proc/build_recipe_materials(datum/anvil_recipe/recipe)
	if(!recipe)
		return list()

	var/list/materials = list()
	if(recipe.req_bar)
		materials |= recipe.req_bar
		materials[recipe.req_bar]++

	for(var/atom/atom_path as anything in recipe.additional_items)
		materials |= atom_path
		materials[atom_path]++

	return materials

/obj/structure/autosmither/proc/recipe_req_data(datum/anvil_recipe/recipe)
	var/list/requirements = list()
	var/list/materials = build_recipe_materials(recipe)
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/anvil_recipes)

	for(var/atom/material_type as anything in materials)
		UNTYPED_LIST_ADD(requirements, list(
			"key" = "[material_type]",
			"name" = initial(material_type:name),
			"amount" = materials[material_type],
			"icon" = spritesheet.icon_class_name(sanitize_css_class_name("material_[material_type]")),
		))

	return requirements

/obj/structure/autosmither/proc/has_recipe_materials(list/materials)
	if(!hopper)
		return FALSE

	var/list/material_copy = materials.Copy()
	for(var/atom/listed_atom in hopper.contents)
		if(listed_atom.type in material_copy)
			material_copy[listed_atom.type]--
			if(material_copy[listed_atom.type] <= 0)
				material_copy -= listed_atom.type

	return !length(material_copy)

/obj/structure/autosmither/proc/recipe_has_mats(datum/anvil_recipe/recipe)
	if(!recipe)
		return FALSE
	return has_recipe_materials(build_recipe_materials(recipe))

/obj/structure/autosmither/proc/try_recipe_queue()
	if(!length(anvil_recipes_to_craft))
		clear_current_recipe()
		return FALSE

	var/datum/autosmither_queue_entry/first_entry = anvil_recipes_to_craft[1]
	var/datum/anvil_recipe/first = queue_recipe(first_entry)
	if(!first)
		clear_current_recipe()
		return FALSE
	if(first_entry.id == current_queue_id && first == current)
		return TRUE

	var/list/materials = build_recipe_materials(first)

	if(!consume_recipe_materials(materials))
		clear_current_recipe()
		return FALSE

	current = first
	current_queue_id = first_entry.id
	needed_progress = max(1, current.craftdiff) * 100
	progress = 0
	missing_materials_alert = FALSE
	return TRUE

/obj/structure/autosmither/proc/clear_current_recipe()
	current = null
	current_queue_id = null
	progress = 0
	needed_progress = initial(needed_progress)

/obj/structure/autosmither/proc/consume_recipe_materials(list/materials)
	if(!has_recipe_materials(materials))
		return FALSE

	var/list/material_copy = materials.Copy()
	for(var/atom/listed_atom in hopper.contents)
		if(!(listed_atom.type in material_copy))
			continue
		material_copy[listed_atom.type]--
		qdel(listed_atom)
		if(material_copy[listed_atom.type] <= 0)
			material_copy -= listed_atom.type
		if(!length(material_copy))
			break

	return TRUE

/obj/structure/autosmither/proc/create_current()
	var/obj/item/new_item
	var/list/created_items = list()
	var/inserted_into_hopper = TRUE
	var/atom/drop_target = get_turf(src)
	for(var/i in 1 to current.createditem_num)
		new_item = new current.created_item(drop_target)
		if(new_item.obj_integrity < new_item.max_integrity)
			new_item.obj_integrity = new_item.max_integrity
		created_items += new_item
		if(hopper && !QDELETED(hopper) && hopper.insert(new_item))
			continue
		inserted_into_hopper = FALSE
	if(length(created_items))
		new_item = created_items[length(created_items)]
	if(inserted_into_hopper)
		visible_message(span_notice("[src] finishes [new_item] and deposits it into [hopper]."))
	else
		visible_message(span_notice("[src] finishes [new_item] and drops it out."))
	playsound(src, pick('sound/combat/armor_degrade2.ogg','sound/combat/armor_degrade3.ogg'), 200, FALSE, 3)
	remove_entry_id(current_queue_id)
	clear_current_recipe()
	missing_materials_alert = FALSE
	update_animation_effect()
	if(!length(anvil_recipes_to_craft))
		notify_queue_finished()

/obj/structure/autosmither/proc/notify_missing_materials()
	if(missing_materials_alert)
		return
	missing_materials_alert = TRUE
	playsound(src, 'sound/items/steamrelease.ogg', 100, FALSE)

/obj/structure/autosmither/proc/notify_queue_finished()
	if(queue_finished_alert)
		return
	queue_finished_alert = TRUE
	playsound(src, 'sound/items/steamrelease.ogg', 100, FALSE)


/obj/structure/autosmither/proc/active_arm_zone(mob/living/user)
	if(user?.active_hand_index == 1)
		return BODY_ZONE_L_ARM
	return BODY_ZONE_R_ARM


/obj/structure/autosmither/proc/startup_injury(engineering_skill = 1)
	var/rpm_scalar = max(1, (rotations_per_minute / 8))
	var/skill_scalar = max(1, engineering_skill)
	return max(2, CEILING((4 * rpm_scalar) / skill_scalar, 1))

/obj/structure/autosmither/proc/try_step(step_type, mob/living/user)

	var/next_step
	var/engineering_skill = user.get_skill_level(/datum/skill/craft/engineering)
	if(!working)
		next_step = pre_start_list[length(step_list) + 1]
	else
		next_step = post_start_list[length(step_list) + 1]

	if (engineering_skill < 3)
		var/fiftyfifty = pick(TRUE,FALSE)
		if(fiftyfifty)
			user.visible_message(span_danger("[user] gets their arm caught in [src]!"), span_danger("You get your arm caught in [src]!"))
			user.apply_damage(startup_injury(), BRUTE, active_arm_zone(user))
			playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
			return

	if(next_step != step_type)
		user.visible_message(span_danger("[user] messes with [src]! The sequence is reset!"), span_danger("You mess with [src]! The sequence is reset!"))
		user.visible_message(span_danger("[user] gets their arm caught in [src]!"), span_danger("You get your arm caught in [src]!"))
		user.apply_damage(startup_injury(engineering_skill), BRUTE, active_arm_zone(user))
		playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		step_list = list()
		return

	if(!do_after(user, 1.2 SECONDS, src))
		return

	to_chat(user, span_notice("You [step_type]."))
	step_list |= step_type

	if(working)
		if(length(step_list) == length(post_start_list))
			stop_work()
	else
		if(length(step_list) == length(pre_start_list))
			if(hopper?.opened)
				to_chat(user, span_warning("The anvil refuses to operate, for [hopper] is open."))
				step_list = list()
				return
			working = TRUE
			step_list = list()
			update_animation_effect()

/obj/structure/closet/crate/chest/autosmither
	name = "auto anvil hopper"
	desc = "A hopper that feeds on materials. It yearns to help create, and is usually connected to the auto anvil by a series of pipes."
	icon = 'icons/obj/autosmithy.dmi'
	icon_state = "material"
	base_icon_state = "material"
	keylock = FALSE
	locked = FALSE
	anchored = TRUE
	anchorable = FALSE
	var/obj/structure/autosmither/parent

/obj/structure/closet/crate/chest/autosmither/CanAStarPass(ID, dir, caller)
	return TRUE

/obj/structure/closet/crate/chest/autosmither/CanPass(atom/movable/mover, turf/target)
	return TRUE

/obj/structure/closet/crate/chest/autosmither/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use it like a chest. It only opens while the autosmithy is off.")
	. += span_info("Load materials into it, then close it so the autosmithy can consume them when a recipe begins.")

/obj/structure/closet/crate/chest/autosmither/can_open(mob/living/user)
	if(parent && parent.working)
		if(user)
			to_chat(user, span_warning("The hopper locks shut while the auto anvil is running."))
		return FALSE
	return ..()

/obj/structure/closet/crate/chest/autosmither/update_icon()
	cut_overlays()
	if(opened)
		layer = BELOW_OBJ_LAYER
		icon_state = "material1"
	else
		layer = OBJ_LAYER
		icon_state = "material"

/obj/structure/closet/crate/chest/autosmither/Destroy()
	parent = null
	return ..()

#undef STEP_FIDDLE
#undef STEP_LEVER
#undef STEP_BUTTON
