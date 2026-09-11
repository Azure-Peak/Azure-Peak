
/obj/machinery/light/rogue/oven
	icon = 'icons/roguetown/misc/lighting.dmi'
	name = "oven"
	desc = "With enough room for up to six whole pies, this humble yet wondrous invention has fed civilization since time immemorial."
	icon_state = "oven1"
	base_state = "oven"
	density = FALSE
	on = FALSE
	roundstart_forbid = TRUE
	var/mob/living/carbon/human/lastuser

/obj/machinery/light/rogue/oven/proc/can_burn()
	return on

/obj/machinery/light/rogue/oven/seton(s)
	var/was_on = on
	. = ..()
	if(on && !was_on)
		on_ignited()

/obj/machinery/light/rogue/oven/on_ignited()
	SEND_SIGNAL(src, COMSIG_STORAGE_CLOSED)

/obj/machinery/light/rogue/oven/OnCrafted(dirin, user)
	dirin = turn(dirin, 180)
	update_icon()

	..(dirin, user)

/obj/machinery/light/rogue/oven/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking on the <b>top</b> of the oven's sprite with an ingredient will slide it inside. Left-clicking the top empty-handed opens the oven.")
	. += span_info("Left-clicking on the <b>bottom</b> of the oven's sprite will attempt to fuel it.")
	. += span_info("Anything inside bakes on its own so long as the oven is lit, and several of the same ingredient bake together in one batch. Letting the fire die stops the baking.")
	. += span_info("Once an item is fully baked, it will visibly change and emit a good smell. This includes fireable crafts, such as clay vases and jugs. Don't think too much about the implications.")
	. += span_info("Leaving a fully baked item inside of the oven for too long will cause it to burn away.")
	. += span_info("Left-clicking the <b>top</b> with a loaded tray slides everything bakeable inside. An empty tray gathers everything at once.")
	. += span_info("Middle-clicking the oven will take the first item out of it.")

/obj/machinery/light/rogue/oven/attackby(obj/item/W, mob/living/user, params)
	lastuser = user
	var/_y = text2num(params2list(params)["icon-y"])
	var/clicked_top
	if(_y > 14)
		clicked_top = TRUE

	if(clicked_top)
		if(istype(W, /obj/item/storage/bag/tray))
			if(length(W.contents))
				return load_from(W, user)
			return unload_into(W, user)
		if((W.item_flags & ABSTRACT) || HAS_TRAIT(W, TRAIT_NODROP))
			return ..()
		if(W.wlength > WLENGTH_NORMAL)
			return ..()
		if(SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, W, user, FALSE, FALSE))
			playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 50) // neu cooking
			update_icon()
			return TRUE
	return ..()

/obj/machinery/light/rogue/oven/proc/load_from(atom/receptacle, mob/user)
	var/datum/component/storage/origin = receptacle.GetComponent(/datum/component/storage)
	if(!origin)
		return FALSE
	var/list/obj/item/to_load = list()
	for(var/obj/item/I in receptacle.contents)
		to_load += I
	if(!length(to_load))
		to_chat(user, span_warning("[receptacle] is empty."))
		return TRUE
	var/count = 0
	for(var/obj/item/I as anything in to_load)
		if(I.wlength > WLENGTH_NORMAL)
			continue
		if(!origin.remove_from_storage(I, get_turf(src)))
			continue
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, I, user, TRUE, FALSE))
			origin.handle_item_insertion(I, TRUE)
			continue
		count++
	if(!count)
		to_chat(user, span_warning("Nothing on [receptacle] fits in [src]."))
		return TRUE
	SEND_SIGNAL(src, COMSIG_STORAGE_CLOSED, user)
	var/mob/living/carbon/human/H = user
	if(istype(H))
		lastuser = H
	update_icon()
	user.visible_message(span_info("[user] slides [count] item[count == 1 ? "" : "s"] from [receptacle] into [src]."), span_info("I slide [count] item[count == 1 ? "" : "s"] from [receptacle] into [src]."))
	playsound(get_turf(src), 'sound/items/wood_sharpen.ogg', 50)
	return TRUE

/obj/machinery/light/rogue/oven/proc/can_unload_item(obj/item/I, datum/component/storage/destination)
	if(QDELETED(I) || I.anchored)
		return FALSE
	if(I.wlength > WLENGTH_NORMAL)
		return FALSE
	return destination.can_be_inserted(I, TRUE)

/obj/machinery/light/rogue/oven/proc/unload_into(atom/receptacle, mob/user)
	var/datum/component/storage/destination = receptacle.GetComponent(/datum/component/storage)
	if(!destination)
		return FALSE
	var/list/obj/item/in_oven = list()
	for(var/obj/item/I in contents)
		in_oven += I
	if(!length(in_oven))
		to_chat(user, span_warning("[src] is empty."))
		return TRUE
	var/count = 0
	for(var/i = length(in_oven), i >= 1, i--)
		var/obj/item/I = in_oven[i]
		if(!can_unload_item(I, destination))
			continue
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, I, get_turf(src))
		if(destination.handle_item_insertion(I, TRUE))
			count++
		else
			SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, TRUE)
	if(!count)
		to_chat(user, span_warning("Nothing in [src] fits on [receptacle]."))
		return TRUE
	var/mob/living/carbon/human/H = user
	if(istype(H))
		lastuser = H
	update_icon()
	user.visible_message(span_info("[user] removes [count] item[count == 1 ? "" : "s"] from [src] onto [receptacle]."), span_info("I removes [count] item[count == 1 ? "" : "s"] from [src] onto [receptacle]."))
	playsound(get_turf(src), 'sound/items/wood_sharpen.ogg', 50)
	return TRUE

/obj/machinery/light/rogue/oven/process()
	..()
	if(!on)
		return
	// Legacy Process for non-food items for compatibilities.
	var/list/obj/item/natural/clay/firing = list()
	for(var/obj/item/natural/clay/unfired in contents)
		firing += unfired
	if(!length(firing))
		return
	var/datum/skill/craft/cooking/cs = lastuser?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)
	var/fired_any = FALSE
	for(var/obj/item/natural/clay/unfired as anything in firing)
		var/obj/item/result = unfired.cooking(10 * cooktime_divisor, 10, src)
		if(!result)
			continue
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, unfired, get_turf(src))
		qdel(unfired)
		result.forceMove(get_turf(src))
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, result, null, TRUE, TRUE)
		fired_any = TRUE
	if(fired_any)
		visible_message(span_green("Something smells good!"))
		update_icon()


/obj/machinery/light/rogue/oven/Crossed(atom/movable/AM, oldLoc)
	return

/obj/machinery/light/rogue/oven/north
	dir = NORTH
	pixel_y = -32

/obj/machinery/light/rogue/oven/south
	dir = SOUTH
	pixel_y = 32 //so we see it in mapper

/obj/machinery/light/rogue/oven/west
	dir = WEST
	pixel_x = 32

/obj/machinery/light/rogue/oven/east
	dir = EAST
	pixel_x = -32

/obj/machinery/light/rogue/oven/center

/obj/machinery/light/rogue/oven/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/food/cooking/oven)
	AddComponent(/datum/component/container_craft, get_container_craft_family(/datum/container_craft/oven))
	AddComponent(/datum/component/food_burner, 2 MINUTES, TRUE, CALLBACK(src, PROC_REF(can_burn)))
	update_icon()

/obj/machinery/light/rogue/oven/update_icon()
	pixel_x = 0
	pixel_y = 0
	switch(dir)
		if(SOUTH)
			pixel_y = 32
		if(NORTH)
			pixel_y = -32
		if(WEST)
			pixel_x = 32
		if(EAST)
			pixel_x = -32
	icon_state = "[base_state][on]"

	underlays.Cut()
	for(var/obj/item/I in contents)
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.color = I.color
		M.transform *= 0.5
		M.pixel_y = rand(-2,4) // WHY WOULD YOU WANT TO HIDE THE ENTIRE SPRITE?? Fixed now
		M.layer = 4.24
		underlays += M
	var/mutable_appearance/M = mutable_appearance(icon, "oven_under")
	M.layer = 4.23
	underlays += M

/obj/machinery/light/rogue/oven/attack_hand(mob/user, params)
	lastuser = user
	var/_y = text2num(params2list(params)["icon-y"])
	var/clicked_top
	if(_y > 14)
		clicked_top = TRUE
	if(clicked_top)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SHOW, user, TRUE)
		return TRUE
	else
		return ..()

/obj/machinery/light/rogue/oven/MiddleClick(mob/user, params)
	. = ..()
	if(.)
		return
	if(!user.CanReach(src))
		return
	return take_first_item(user)

/obj/machinery/light/rogue/oven/proc/take_first_item(mob/user)
	var/obj/item/taken = locate(/obj/item) in contents
	if(!taken)
		to_chat(user, span_warning("[src] is empty."))
		return TRUE
	lastuser = user
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, taken, get_turf(src), TRUE)
	if(!user.put_in_active_hand(taken))
		taken.forceMove(get_turf(src))
	update_icon()
	playsound(get_turf(src), 'sound/items/wood_sharpen.ogg', 50)
	user.visible_message(span_info("[user] takes [taken] out of [src]."), span_info("I take [taken] out of [src]."))
	return TRUE
