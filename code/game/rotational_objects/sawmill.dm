/datum/looping_sound/sawmill_work
	mid_sounds = 'sound/items/stonestone.ogg'
	mid_length = 8
	volume = 40
	extra_range = -1

/datum/sawmill_queue_entry
	var/id
	var/type_path

/datum/sawmill_queue_entry/New(new_id, new_type_path)
	id = new_id
	type_path = new_type_path
	. = ..()

/obj/structure/sawmill
	name = "mechanical sawmill"
	desc = "A complex contraption of gears, belts, and a large bandsaw blade. It can be used to cut logs into planks with ease; just.. don't stick your hand in it."
	icon = 'icons/roguetown/misc/sawmill.dmi'
	icon_state = "sawmill_off"
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_LEFT | CONN_DIR_FLIP | CONN_DIR_Z_DOWN
	anchored = TRUE
	density = TRUE
	var/list/sawmill_recipes = list()
	var/next_queue_id = 1

	var/datum/sawmill_recipe/current
	var/current_queue_id

	var/hopper_type = /obj/structure/closet/crate/chest/sawmill
	var/obj/structure/closet/crate/chest/sawmill/hopper

	var/working = FALSE
	var/bloodied = FALSE
	var/datum/looping_sound/sawmill_work/soundloop

	var/progress = 0
	var/needed_progress = 100

	var/static/list/regular_recipes = list()
	var/missing_materials_alert = FALSE
	var/queue_finished_alert = FALSE

	var/list/step_list = list()

	var/list/pre_start_list = list(STEP_FIDDLE, STEP_BUTTON, STEP_LEVER)
	var/list/post_start_list = list(STEP_BUTTON, STEP_LEVER, STEP_FIDDLE)
	debris = list(/obj/item/roguegear = 2, /obj/item/natural/wood/plank = 4, /obj/item/ingot/steel = 1)


	var/setting_dowels = FALSE	//True-false setting for producing dowels. If false, it produces planks.

/obj/structure/sawmill/Initialize(mapload)
	. = ..()
	var/turf/turf = get_step(src, EAST)
	hopper = new hopper_type(turf)
	hopper.parent = src
	soundloop = new(src, FALSE)
	LAZYINITLIST(regular_recipes)
	if(!length(regular_recipes))
		for(var/datum/sawmill_recipe/recipe_path as anything in subtypesof(/datum/sawmill_recipe))
			if(IS_ABSTRACT(recipe_path))
				continue
			if(!((recipe_path.req_bar == /obj/item/ingot/copper)||(recipe_path.req_bar == /obj/item/ingot/bronze)||(recipe_path.req_bar == /obj/item/ingot/iron) || (recipe_path.req_bar == /obj/item/ingot/steel)||(recipe_path.req_bar == /obj/item/ingot/tin)))//it needs to be at least tin, copper, iron, bronze, or steel
				continue
			regular_recipes |= new recipe_path

	START_PROCESSING(SSobj, src)

/obj/structure/sawmill/Destroy()
	if(current)
		QDEL_NULL(current)
	//QDEL_NULL(soundloop)
	for(var/datum/sawmill_queue_entry/queue_entry as anything in anvil_recipes_to_craft)
		qdel(queue_entry)
	QDEL_NULL(hopper)
	anvil_recipes_to_craft.Cut()
	return ..()

/obj/structure/sawmill/examine(mob/user)
	. = ..()
	. += span_notice(working ? "It is switched <b>on</b>." : "It is switched <b>off</b>.")
	if(has_power_flow())
		. += span_notice("RPM: [rotations_per_minute]")
	else
		. += span_warning("It is not drawing any rotational power.")

	. += span_info("It is currently set to produce [setting_dowels ? "dowels" : "planks"].")

/obj/structure/sawmill/get_mechanics_examine(mob/user, params)
	. = ..()
	. += span_info("Left-click it with an empty hand to switch it on or off; non-skilled engineers should be careful of catching their hand in the blade!")
	. += span_info("Right-click it with an empty hand to switch between producing planks or dowels. Engineers with low skill should be careful of catching their hand in the blade when adjusting it!")
	. += span_info("It saws anything that can be sawn from itsattached hopper and only works while connected to a powered rotational network with enough RPM.")
	. += span_info("Place wood or other sawable materials into the attached hopper's tile and then switch the grinder on; it feeds itself.")
	. += span_info("Click-dragging a grabbed mob onto the sawmill while it's grabbed will- well, I think you know what'll happen if you do that..")
	. += span_info("Jumping or climbing onto the sawmill while it's on can be dangerous! Who would have thought!?")


/// Malicious sawing
/obj/structure/sawmill/attackby(obj/item/I, mob/living/user, list/modifiers)
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
	user.visible_message(span_danger("[user] struggles to shove [victim] onto the sawmill [src]!"), span_danger("You start to put [victim] onto the [src]!"))
	if(!do_after(user, 10 SECONDS, src))
		return

	if(user.get_skill_level(/datum/skill/craft/engineering) < 3)
		if(prob(50))
			user.visible_message(span_danger("[user] gets their arm caught in the [src] instead!"), span_danger("You get your arm caught in the [src]!"))
			user.apply_damage(4 * max(1, (rotations_per_minute / 8)), BRUTE, active_arm_zone(user))
			playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
			return

	victim.apply_damage(10 * (rotations_per_minute / 8), BRUTE, BODY_ZONE_CHEST)
	playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	bloodied = TRUE
	update_animation_effect()

/obj/structure/sawmill/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.movement_type & (FLYING|FLOATING)) // You're safe if you fly over it, but fall in and you're screwed
			return ..()

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/area = BODY_ZONE_L_LEG
		if(prob(50))
			area = BODY_ZONE_R_LEG
		var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(area))

		if(!affecting) //if somehow no legs, we hit the chest.
			H.visible_message(span_danger("[user]'s body lays right in the way of [src]'s saw!"), span_danger("Your body lays right in the way of [src]'s saw!"))
			affecting =	H.apply_damage(10 * (rotations_per_minute / 8), BRUTE, BODY_ZONE_CHEST)
			affecting.add_wound(/datum/wound/slash/disembowel)
			H.emote("painscream")
			return

		H.visible_message(span_danger("[user] gets a leg caught in [src]'s saw!"), span_danger("You get your hand caught in [src]'s saw!"))
		if(prob(25))	//Pray you don't lose a leg
			affecting.dismember(skip_checks = TRUE)
			H.emote("painscream")
			return

		affecting.add_wound(/datum/wound/slash/large)
		H.emote("painscream")
		return

/obj/structure/sawmill/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	toggle_machine(user)

/obj/structure/sawmill/attack_right(mob/user)
	. = ..()
	if(.)
		return
	toggle_production(user)

/obj/structure/sawmill/process()
	if(!working)
		return
	if(!hopper)
		update_working_visuals()
		return
	if(!has_power_flow() || rotations_per_minute < rotations_required)
		update_working_visuals()
		return

	if(!current_item || QDELETED(current_item) || !in_saw_pool(current_item) || !is_sawable(current_item))
		current_item = find_sawable()
		progress = 0

	if(!current_item)
		update_working_visuals()
		notify_empty()
		return
	empty_alert = FALSE

	progress += 8 * (rotations_per_minute / 16)
	update_working_visuals()
	if(progress >= needed_progress)
		saw_current()

/**
 * The container the grinder pulls material from.
 *
 * The hopper is a permanently open feed bin, so it always feeds straight off the tile it sits on —
 * drop grist onto it like a real hopper and the stone takes it.
 */
/obj/structure/sawmill/proc/saw_pool()
	if(!hopper)
		return null
	return get_turf(hopper)

/// Whether the given item is currently sitting in the grinder's active material pool.
/obj/structure/sawmill/proc/in_saw_pool(obj/item/candidate)
	if(QDELETED(candidate))
		return FALSE
	var/atom/pool = saw_pool()
	return pool && candidate.loc == pool

/// Returns the first sawable item in the active material pool, or null if there are none.
/obj/structure/sawmill/proc/find_sawable()
	var/atom/pool = saw_pool()
	if(!pool)
		return null
	for(var/obj/item/candidate in pool)
		if(is_sawable(candidate))
			return candidate
	return null

/// Whether the machine currently has sawable material queued up in the hopper.
/obj/structure/sawmill/proc/has_sawable()
	return !!find_sawable()

/// Consumes the current item and drops its milled result onto the grinder's own tile.
/obj/structure/sawmill/proc/saw_current()
	if(!current_item || QDELETED(current_item))
		current_item = null
		progress = 0
		return
	var/obj/item/ground = current_item
	if(setting_dowels == TRUE)
		if(current_item == /obj/item/grown/log/tree/small)
			new /obj/item/natural/bundle/stick/dowel/small_log_result(get_turf(src))
		if(current_item == /obj/item/grown/log/tree)
			new /obj/item/natural/bundle/stick/dowel/log_result(get_turf(src))
		if(current_item == /obj/item/natural/wood/plank)
			new /obj/item/natural/bundle/stick/dowel/plank_result(get_turf(src))
		if(current_item == /obj/item/grown/log/tree/stick)
			new /obj/item/natural/bundle/stick/dowel(get_turf(src))	//The singular dowel......
		else //fail-safe, just incase you manage to fuck this up somehow
			return
	if(setting_dowels == FALSE)
		if(current_item == /obj/item/grown/log/tree/small)
			new /obj/item/natural/bundle/plank/small_log_result(get_turf(src))
		if(current_item == /obj/item/grown/log/tree)
			new /obj/item/natural/bundle/plank/full_log_result(get_turf(src))
		if(current_item == /obj/item/natural/wood/plank)
			new /obj/item/natural/wood/plank(get_turf(src))	//Just gives you a single plank for.. a single plank.
		if(current_item == /obj/item/grown/log/tree/stick)
			to_chat(user, span_warning("The sawmill sputs out sawdust, but nothing useful comes of it."))
	qdel(ground)
	current_item = null
	progress = 0
	playsound(src, 'sound/foley/stone_scrape.ogg', 80, TRUE, -1)
	update_working_visuals()
	if(!has_sawable())
		notify_empty()

/// Fires a one-shot alert (once) when the grinder runs dry of material.
/obj/structure/sawmill/proc/notify_empty()
	if(empty_alert)
		return
	empty_alert = TRUE
	playsound(src, 'sound/items/steamrelease.ogg', 100, FALSE)

/*
 * Bundles relating to dowels. Depending what item is in the sawmill's hopper, you get a different amount of dowels.
 * - 1 plank = 3 dowels (2-3 planks per small log, so 6-9 dowels per small log when processed into planks)
 * - 1 log = 8 dowels
 * - 1 half-log = 4 dowels
 * - 1 stick = 1 dowel	- Kinda meh, but it makes sense I guess
 */
/obj/item/natural/bundle/stick/dowel/log_result
	amount = 8

/obj/item/natural/bundle/stick/dowel/small_log_result
	amount = 4

/obj/item/natural/bundle/stick/dowel/plank_result
	amount = 3

/*
 * Bundles relating to planks. Depending what item is in the sawmill's hopper, you get a different amount of planks.
 * - 1 plank = 1 plank (duh)
 * - 1 log = 6 planks
 * - 1 half-log = 3 planks (A skilled logger can get 4-5 planks per small log)
 * - 1 stick = sawdust, you get nothing (!)
 */
/obj/item/natural/bundle/plank/full_log_result
	amount = 6

/obj/item/natural/bundle/plank/small_log_result
	amount = 3


/obj/structure/sawmill/proc/has_power_flow()
	return rotation_network && !rotation_network.overstressed && rotations_per_minute

/// Whether the grinder is switched on and actually being driven fast enough by the network.
/// Governs the "running" look of both the stone and the hopper gears, regardless of material.
/obj/structure/sawmill/proc/is_spinning()
	return working && has_power_flow() && rotations_per_minute >= rotations_required

/// Whether the stone should currently look and sound like it is grinding.
/obj/structure/sawmill/proc/show_working()
	if(!working || !has_power_flow() || rotations_per_minute < rotations_required)
		return FALSE
	if(!hopper)
		return FALSE
	return has_grindable()

/obj/structure/sawmill/proc/stop_work()
	working = FALSE
	current_item = null
	progress = 0
	update_working_visuals()

/// Switches the saw (and, through it, the hopper gears) between the idle and running animations.
/obj/structure/sawmill/proc/update_working_visuals()
	icon_state = is_spinning() ? "sawmill_on" : "sawmill_off"
	if(hopper && !QDELETED(hopper))
		hopper.update_gear_anim()

/obj/structure/sawmill/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	if(!speed && working)
		stop_work()
	set_stress_use(64 * (speed / 8))

/obj/structure/sawmill/rotation_break()
	if(working)
		stop_work()
	return ..()

/// Returns the body zone of the hand the user is currently acting with.
/obj/structure/sawmill/proc/active_hand_zone(mob/living/user)
	if(user?.active_hand_index == 1)
		return BODY_ZONE_L_ARM
	return BODY_ZONE_R_ARM

/// Right click toggle. Adjusts the machine from making dowels to making planks, or vice versa. Needs to be manually adjusted.
/obj/structure/sawmill/proc/toggle_production(mob/living/user)
	if(!istype(user) || !user.Adjacent(src))
		return
	if(!working)
		if(!has_power_flow())
			to_chat(user, span_warning("[src] has no rotational power to draw on."))
			return

	var/engineering_skill = user.get_skill_level(/datum/skill/craft/engineering)
	user.visible_message(span_notice("[user] [was_dowels ? "switches [src] to produce planks" : "switches [src] to produce dowels"]."), span_notice("You [was_dowels ? "switch [src] to produce planks" : "switch [src] to produce dowels"]."))
	if(do_after(user, 1.2 SECONDS, src))
		if(setting_dowels == TRUE)
			setting_dowels = FALSE
		else
			setting_dowels = TRUE
		return

	if(working && engineering_skill < 3 && prob(10))
		user.visible_message(span_danger("[user] gets a hand caught in [src]'s saw!"), span_danger("You get your hand caught in [src]'s saw!"))
		user.apply_damage(max(2, round((4 * max(1, rotations_per_minute / 8)) / max(1, engineering_skill), 1)), BRUTE, active_hand_zone(user))
		playsound(src, 'sound/foley/stone_scrape.ogg', 100, FALSE)
		return

/// Left click toggle. Turning the running stone off by hand risks injury for the unskilled.
/obj/structure/sawmill/proc/toggle_machine(mob/living/user)
	if(!istype(user) || !user.Adjacent(src))
		return
	if(!working)
		if(!has_power_flow())
			to_chat(user, span_warning("[src] has no rotational power to draw on."))
			return

	var/was_working = working
	var/engineering_skill = user.get_skill_level(/datum/skill/craft/engineering)
	user.visible_message(span_notice("[user] starts to [was_working ? "shut down" : "start up"] [src]."), span_notice("You start to [was_working ? "shut down" : "start up"] [src]."))
	if(!do_after(user, 1.2 SECONDS, src))
		return

	if(was_working && engineering_skill < 3 && prob(10))
		user.visible_message(span_danger("[user] gets a hand caught in [src]'s saw!"), span_danger("You get your hand caught in [src]'s saw!"))
		user.apply_damage(max(2, round((4 * max(1, rotations_per_minute / 8)) / max(1, engineering_skill), 1)), BRUTE, active_hand_zone(user))
		playsound(src, 'sound/foley/stone_scrape.ogg', 100, FALSE)
		return

	if(working)
		stop_work()
		to_chat(user, span_notice("You shut down [src]."))
	else
		working = TRUE
		update_working_visuals()
		to_chat(user, span_notice("You start up [src]."))

/*
 * The hopper that feeds the autogrinder. A permanently open, lidless feed bin: grist dropped onto
 * its tile is pulled straight into the grinder. Two iron gears turn inside whenever the machine runs.
 */
/obj/structure/closet/crate/chest/sawmill
	name = "sawmill hopper"
	desc = "A lidless material hopper that feeds the sawmill."
	icon = 'icons/obj/autogrinder.dmi'
	icon_state = "open_off"
	base_icon_state = "open_off"
	keylock = FALSE
	locked = FALSE
	anchored = TRUE
	anchorable = FALSE
	var/obj/structure/sawmill/parent
