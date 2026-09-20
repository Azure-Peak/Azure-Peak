#define SMOKE_COOKING_TIME_MULTIPLIER 3
#define SMOKER_EXP_PER_ITEM 0.5

/obj/machinery/light/rogue/smoker
	name = "smoker"
	desc = "An adorable wooden smoker meant for curing meats with wood fire. No, this isn't where gnomes live."
	icon = 'icons/roguetown/misc/smoker.dmi'
	icon_state = "smoker"
	base_state = "smoker"
	density = TRUE
	on = FALSE
	roundstart_forbid = TRUE

	var/maxfood = 6
	var/door_open = FALSE
	var/has_log = FALSE
	var/lit = FALSE
	var/need_underlay_update = TRUE
	var/datum/weakref/lastuser_ref

	var/current_cook_progress = 0
	var/target_cook_time = 0

/obj/machinery/light/rogue/smoker/wheeled
	name = "wheeled smoker"
	desc = "An adorable wooden smoker meant for curing meats with wood fire. This one has wheels so you can move it around."
	anchored = FALSE
	icon_state = "w_smoker"
	base_state = "w_smoker"

/obj/machinery/light/rogue/smoker/fire_act(added, maxstacks)
	if(!door_open || !has_log || lit)
		return FALSE

	lit = TRUE
	update_icon()
	visible_message(span_notice("The fuel inside [src] catches fire!"))

	return ..()

/obj/machinery/light/rogue/smoker/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/light/rogue/smoker/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking inside the <b>door opening</b> interacts with the interior contents.")
	. += span_info("Left-clicking <b>outside the door opening</b> will shut the door when open.")
	. += span_info("Once lit and shut, it will smoke all items inside over time, consuming the log only when finished.")
	. += span_info("Can only be fueled with a small log.")

/obj/machinery/light/rogue/smoker/update_icon()
	if(on && !door_open)
		icon_state = "[base_state]_smoking"
	else if(door_open)
		if(lit)
			icon_state = "[base_state]_burn"
		else if(has_log)
			icon_state = "[base_state]_fuel"
		else
			icon_state = "[base_state]_open"
	else
		icon_state = "[base_state]"

	if(need_underlay_update)
		need_underlay_update = FALSE
		cut_overlays()

		// Only display food overlays when the door is open
		if(door_open)
			var/index = 0
			for(var/obj/item/I in contents)
				I.pixel_x = 0
				I.pixel_y = 0
				var/mutable_appearance/M = new /mutable_appearance(I)
				M.transform *= 0.35
				// -2 maps to world pixel X=14 on a 32x32 sprite center offset (-16 offset basis)
				M.pixel_x = -2 + index
				// -2 maps to world pixel Y=14 max top bounds after scaling
				M.pixel_y = -2
				M.layer = FLOAT_LAYER
				add_overlay(M)
				index++

/obj/machinery/light/rogue/smoker/proc/recalculate_cook_time()
	if(!contents.len)
		target_cook_time = 0
		return

	var/total_required = 0
	var/valid_items = 0

	for(var/obj/item/reagent_containers/food/snacks/S in contents)
		if(!S.smoked_type)
			continue
		var/req = S.cooktime ? S.cooktime : 100
		total_required += req
		valid_items++

	if(valid_items > 0)
		var/average_time = total_required / valid_items
		// It takes longer to smoke items
		target_cook_time = round(average_time * SMOKE_COOKING_TIME_MULTIPLIER)
	else
		target_cook_time = 0

// Helper proc to check if a click falls inside the door bounds
/obj/machinery/light/rogue/smoker/proc/clicked_interior(params)
	var/plist = params2list(params)
	var/_x = text2num(plist["icon-x"])
	var/_y = text2num(plist["icon-y"])
	return (_x >= 13 && _x <= 20 && _y >= 6 && _y <= 17)

/obj/machinery/light/rogue/smoker/attackby(obj/item/W, mob/living/user, params)
	lastuser_ref = WEAKREF(user)
	var/inside = clicked_interior(params)

	if(!inside)
		if(door_open)
			door_open = FALSE
			if(lit && has_log && contents.len)
				on = TRUE
				START_PROCESSING(SSmachines, src)
			user.visible_message(span_notice("[user] shuts [src]."))
			need_underlay_update = TRUE
			update_icon()
			return
		if(user.cmode)
			return ..()
		return

	// Interacting inside the door bounds
	if(!door_open)
		user.visible_message(span_notice("[user] opens the door to [src]."))
		door_open = TRUE
		on = FALSE
		STOP_PROCESSING(SSmachines, src)
		need_underlay_update = TRUE
		update_icon()
		return

	// Fuel insertion
	if(istype(W, /obj/item/grown/log/tree/small))
		if(has_log)
			to_chat(user, span_warning("[src] already has a log inside!"))
			return
		if(!user.transferItemToLoc(W, src))
			return
		has_log = TRUE
		qdel(W)
		to_chat(user, span_notice("You place a log inside [src]."))
		need_underlay_update = TRUE
		update_icon()
		return

	// Ignition check
	if(W.get_temperature())
		if(!has_log)
			to_chat(user, span_warning("There is no fuel in [src] to light!"))
			return
		if(lit)
			to_chat(user, span_warning("[src] is already lit!"))
			return
		lit = TRUE
		user.visible_message(span_notice("[user] lights the log in [src]."))
		update_icon()
		return

	if(!istype(W, /obj/item/reagent_containers/food/snacks))
		if(user.cmode)
			return ..()
		return

	if(HAS_TRAIT(W, TRAIT_NODROP))
		if(user.cmode)
			return ..()
		return

	if(contents.len < maxfood)
		if(!user.transferItemToLoc(W, src))
			return
		contents += W
		recalculate_cook_time()
		playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 50)
		user.visible_message(span_warning("[user] hangs [W] inside [src]."))
		need_underlay_update = TRUE
		update_icon()
		return
	else
		to_chat(user, span_warning("[src] is already full!"))
		return

/obj/machinery/light/rogue/smoker/attack_hand(mob/user, params)
	lastuser_ref = WEAKREF(user)
	var/inside = clicked_interior(params)

	if(inside)
		if(!door_open)
			door_open = TRUE
			on = FALSE
			STOP_PROCESSING(SSmachines, src)
			user.visible_message(span_notice("[user] opens [src]."))
			need_underlay_update = TRUE
			update_icon()
			return

		if(contents.len)
			var/obj/item/I = contents[contents.len]
			I.forceMove(get_turf(user))
			contents -= I
			user.put_in_active_hand(I)
			recalculate_cook_time()
			need_underlay_update = TRUE
			update_icon()
			return
	else
		if(door_open)
			door_open = FALSE
			if(lit && has_log && contents.len)
				on = TRUE
				START_PROCESSING(SSmachines, src)
			user.visible_message(span_notice("[user] shuts [src]."))
			need_underlay_update = TRUE
			update_icon()
			return
		else
			return ..()

/obj/machinery/light/rogue/smoker/process()
	if(!on || door_open || !lit || !has_log || !contents.len)
		return

	var/cooktime_divisor = 1
	var/mob/living/carbon/human/lastuser = lastuser_ref?.resolve()
	if(lastuser)
		var/datum/skill/craft/cooking/cs = lastuser.get_skill_level(/datum/skill/craft/cooking)
		cooktime_divisor = get_cooktime_divisor(cs)

	current_cook_progress += (10 * cooktime_divisor)

	if(current_cook_progress >= target_cook_time && target_cook_time > 0)
		finish_batch()

/obj/machinery/light/rogue/smoker/proc/finish_batch()
	var/list/new_foods = list()
	var/items_transformed = 0

	for(var/obj/item/I in contents)
		var/obj/item/reagent_containers/food/snacks/S = I
		if(istype(S) && S.smoked_type)
			var/obj/item/reagent_containers/food/snacks/result = new S.smoked_type(src)
			if(S.reagents && result.reagents)
				S.reagents.trans_to(result, S.reagents.total_volume)
			qdel(S)
			new_foods += result
			items_transformed++
		else
			new_foods += I

	contents = new_foods
	visible_message(span_notice("A rich, smoky aroma drifts out from [src]!"))

	var/mob/living/carbon/human/lastuser = lastuser_ref?.resolve()
	if(lastuser && ishuman(lastuser) && lastuser.mind && items_transformed > 0)
		lastuser.mind.add_sleep_experience(/datum/skill/craft/cooking, lastuser.STAINT * (items_transformed * SMOKER_EXP_PER_ITEM))

	has_log = FALSE
	lit = FALSE
	on = FALSE
	STOP_PROCESSING(SSmachines, src)
	current_cook_progress = 0
	target_cook_time = 0
	need_underlay_update = TRUE
	update_icon()

/obj/machinery/light/rogue/smoker/Crossed(atom/movable/AM, oldLoc)
	return

// Don't want this to process when it doesn't have to.
/obj/machinery/light/rogue/smoker/update(trigger = TRUE)
	return

/obj/machinery/light/rogue/smoker/Destroy()
	STOP_PROCESSING(SSmachines, src)
	var/turf/T = get_turf(src)
	if(T)
		for(var/obj/item/I in contents)
			I.forceMove(T)

	contents.Cut()
	lastuser_ref = null
	return ..()

#undef SMOKER_EXP_PER_ITEM
#undef SMOKE_COOKING_TIME_MULTIPLIER
