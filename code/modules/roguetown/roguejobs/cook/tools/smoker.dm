/obj/machinery/light/rogue/smoker
	name = "smoker"
	desc = "A tall, iron smoker meant for curing meats with wood fire."
	icon = 'icons/roguetown/misc/smoker.dmi'
	icon_state = "smoker"
	base_state = "smoker"
	density = TRUE
	on = FALSE
	roundstart_forbid = TRUE

	var/list/food = list()
	var/maxfood = 6
	var/door_open = FALSE
	var/has_log = FALSE
	var/lit = FALSE
	var/lastsmoke = 0
	var/need_underlay_update = TRUE
	var/mob/living/carbon/human/lastuser

	// Cooking Progress Trackers
	var/current_cook_progress = 0
	var/target_cook_time = 0

/obj/machinery/light/rogue/smoker/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/light/rogue/smoker/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking on the <b>top</b> opens/closes the door or places meat inside when open.")
	. += span_info("Left-clicking on the <b>bottom</b> inserts wood fuel or ignites it when open.")
	. += span_info("Once lit and shut, it will smoke all items inside over time, consuming the log only when finished.")

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
		underlays.Cut()

		// Only display contents when the door is open
		if(door_open)
			var/index = 0
			for(var/obj/item/I in food)
				I.pixel_x = 0
				I.pixel_y = 0
				var/mutable_appearance/M = new /mutable_appearance(I)
				M.transform *= 0.4
				// Fits 6 items tightly across 8 pixels of interior space
				M.pixel_x = -3 + index
				M.pixel_y = 2
				M.layer = 4.24
				underlays += M
				index++

		var/mutable_appearance/M = mutable_appearance(icon, "smoker_under")
		M.layer = 4.23
		underlays += M

/obj/machinery/light/rogue/smoker/proc/recalculate_cook_time()
	if(!food.len)
		target_cook_time = 0
		return

	var/total_required = 0
	var/valid_items = 0

	for(var/obj/item/reagent_containers/food/snacks/S in food)
		var/req = S.cooktime ? S.cooktime : 100
		total_required += req
		valid_items++

	if(valid_items > 0)
		target_cook_time = total_required / valid_items
	else
		target_cook_time = 0

/obj/machinery/light/rogue/smoker/attackby(obj/item/W, mob/living/user, params)
	lastuser = user
	var/_y = text2num(params2list(params)["icon-y"])
	var/clicked_top = (_y > 14)

	if(clicked_top)
		if(!door_open)
			user.visible_message(span_notice("[user] opens the door to [src]."))
			door_open = TRUE
			on = FALSE
			need_underlay_update = TRUE
			update_icon()
			return

		if((W.item_flags & ABSTRACT) || HAS_TRAIT(W, TRAIT_NODROP))
			return ..()
		if(W.wlength > WLENGTH_NORMAL)
			return ..()

		if(food.len < maxfood)
			W.forceMove(src)
			food += W
			recalculate_cook_time()
			playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 50)
			user.visible_message(span_warning("[user] hangs [W] inside [src]."))
			need_underlay_update = TRUE
			update_icon()
			return
		else
			to_chat(user, span_warning("[src] is already full!"))
			return

	else // Clicked bottom
		if(istype(W, /obj/item/grown/log/tree/small))
			if(!door_open)
				to_chat(user, span_warning("You need to open the door first!"))
				return
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

		if(W.get_temperature()) // Any active flame source
			if(!door_open)
				to_chat(user, span_warning("You need to open the door first!"))
				return
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

	return ..()

/obj/machinery/light/rogue/smoker/attack_hand(mob/user, params)
	lastuser = user
	var/_y = text2num(params2list(params)["icon-y"])
	var/clicked_top = (_y > 14)

	if(clicked_top)
		if(!door_open)
			door_open = TRUE
			on = FALSE
			user.visible_message(span_notice("[user] opens [src]."))
			need_underlay_update = TRUE
			update_icon()
			return

		if(food.len)
			var/obj/item/I = food[food.len]
			I.forceMove(get_turf(user))
			food -= I
			user.put_in_active_hand(I)
			recalculate_cook_time()
			need_underlay_update = TRUE
			update_icon()
			return
		else
			door_open = FALSE
			if(lit && has_log && food.len)
				on = TRUE
			user.visible_message(span_notice("[user] shuts [src]."))
			need_underlay_update = TRUE
			update_icon()
			return
	else
		if(door_open)
			door_open = FALSE
			if(lit && has_log && food.len)
				on = TRUE
			user.visible_message(span_notice("[user] shuts [src]."))
			need_underlay_update = TRUE
			update_icon()
			return
		else
			return ..()

/obj/machinery/light/rogue/smoker/process()
	..()
	if(!on || door_open || !lit || !has_log)
		return

	var/datum/skill/craft/cooking/cs = lastuser?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)

	current_cook_progress += (10 * cooktime_divisor)

	if(current_cook_progress >= target_cook_time && target_cook_time > 0)
		finish_batch()

/obj/machinery/light/rogue/smoker/proc/finish_batch()
	var/list/new_foods = list()

	for(var/obj/item/I in food)
		var/obj/item/reagent_containers/food/snacks/S = I
		if(istype(S) && S.smoked_type)
			var/obj/item/reagent_containers/food/snacks/result = new S.smoked_type(src)
			if(S.reagents && result.reagents)
				S.reagents.trans_to(result, S.reagents.total_volume)
			qdel(S)
			new_foods += result
		else
			new_foods += I

	food = new_foods
	visible_message(span_notice("A rich, smoky aroma drifts out from [src]!"))

	// Reset fuel and operation states upon batch completion
	has_log = FALSE
	lit = FALSE
	on = FALSE
	current_cook_progress = 0
	target_cook_time = 0
	need_underlay_update = TRUE
	update_icon()

/obj/machinery/light/rogue/smoker/Crossed(atom/movable/AM, oldLoc)
	return
