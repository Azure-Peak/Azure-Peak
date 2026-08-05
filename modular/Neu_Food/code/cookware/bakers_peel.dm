/datum/component/storage/concrete/bakers_peel
	insert_preposition = "on"
	max_w_class = WEIGHT_CLASS_NORMAL
	max_items = 5
	screen_max_rows = 1
	screen_max_columns = 5

/datum/component/storage/concrete/bakers_peel/New(datum/P, ...)
	. = ..()
	can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks))

/datum/intent/use/bakers_peel
	name = "use"
	reach = 2
	rmb_ranged = TRUE

/datum/intent/use/bakers_peel/rmb_ranged(atom/target, mob/user)
	if(!istype(masteritem, /obj/item/rogueweapon/bakers_peel))
		return
	var/obj/item/rogueweapon/bakers_peel/peel = masteritem
	peel.use_on_right_click_target(target, user)

/datum/intent/spear/bash/ranged/bakers_peel
	name = "swat"
	attack_verb = list("swats", "strikes")
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')
	damfactor = 1

/obj/item/rogueweapon/bakers_peel
	name = "baker's peel"
	desc = "A long wooden paddle used by bakers to put food into and take food out of the oven."
	icon = 'modular/Neu_Food/icons/cookware/bakers_peel.dmi'
	icon_state = "bakerspeel0"
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	wlength = WLENGTH_LONG
	twohands_required = TRUE
	possible_item_intents = list(/datum/intent/use/bakers_peel, /datum/intent/spear/bash/ranged/bakers_peel)
	gripped_intents = list(/datum/intent/use/bakers_peel, /datum/intent/spear/bash/ranged/bakers_peel)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	grid_width = 32
	grid_height = 96
	bigboy = TRUE
	force = 10
	force_wielded = 10
	throwforce = 0
	sharpness = IS_BLUNT
	can_parry = TRUE
	wdefense = 8
	associated_skill = /datum/skill/craft/cooking
	var/mob/living/peel_holder

/obj/item/rogueweapon/bakers_peel/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/bakers_peel)

/obj/item/rogueweapon/bakers_peel/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_attack_success))

/obj/item/rogueweapon/bakers_peel/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(peel_holder && peel_holder != user)
		UnregisterSignal(peel_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
		peel_holder = null
	if(slot != ITEM_SLOT_HANDS || !isliving(user))
		if(peel_holder)
			UnregisterSignal(peel_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
			peel_holder = null
		return
	var/mob/living/living_user = user
	peel_holder = living_user
	RegisterSignal(peel_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved), TRUE)

/obj/item/rogueweapon/bakers_peel/dropped(mob/user, silent = FALSE)
	. = ..()
	if(peel_holder)
		UnregisterSignal(peel_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
		peel_holder = null

/obj/item/rogueweapon/bakers_peel/examine(mob/user)
	. = ..()
	var/loaded_count = stored_item_count()
	if(loaded_count)
		. += span_info("It is carrying [loaded_count] item[loaded_count == 1 ? "" : "s"].")
	else
		. += span_info("It is empty.")

/obj/item/rogueweapon/bakers_peel/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click a tabled food item to slide up to five food items onto the peel, it will prefer the same kind of food you clicked on first.")
	. += span_info("Right-click a table to unload the peel onto it. Right-click an oven to load it with food from the peel. Left-click an oven to slide food from inside it onto the peel.")
	. += span_info("It can reach tables and ovens up to two tiles away.")
	. += span_info("It can be carried in a greatweapon strap.")

/obj/item/rogueweapon/bakers_peel/update_transform()
	. = ..()
	icon_state = ismob(loc) ? "bakerspeel1" : "bakerspeel0"

/obj/item/rogueweapon/bakers_peel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/bakers_peel/afterattack(atom/target, mob/living/user, proximity, params)
	if(!target || !user)
		return ..()
	if(istype(target, /obj/machinery/light/rogue/oven))
		if(take_from_oven(target, user))
			return
	if(isitem(target))
		if(scoop_from_table(target, user))
			return
	return ..()

/obj/item/rogueweapon/bakers_peel/Destroy()
	if(peel_holder)
		UnregisterSignal(peel_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
		peel_holder = null
	UnregisterSignal(src, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_attack_success))
	dump_loaded_items(get_turf(src))
	return ..()

/obj/item/rogueweapon/bakers_peel/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(. && istype(user?.used_intent, /datum/intent/spear/bash/ranged/bakers_peel))
		spill_loaded_items(user, "The impact knocks")

/obj/item/rogueweapon/bakers_peel/attack_turf(turf/T, mob/living/user, multiplier)
	. = ..()
	if(. && istype(user?.used_intent, /datum/intent/spear/bash/ranged/bakers_peel))
		spill_loaded_items(user, "The impact knocks")

/obj/item/rogueweapon/bakers_peel/proc/on_attack_success(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(istype(user?.used_intent, /datum/intent/spear/bash/ranged/bakers_peel))
		spill_loaded_items(user, "The impact knocks")

/obj/item/rogueweapon/bakers_peel/proc/on_holder_moved(mob/living/user, atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	if(!user || QDELETED(src) || loc != user || !user.is_holding(src))
		if(peel_holder)
			UnregisterSignal(peel_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
			peel_holder = null
		return
	if(forced || user.m_intent != MOVE_INTENT_RUN)
		return
	spill_loaded_items(user, "Running with [src] sends")

/obj/item/rogueweapon/bakers_peel/proc/use_on_right_click_target(atom/target, mob/user)
	if(!target || !user)
		return FALSE
	if(!can_reach_target(target, user))
		to_chat(user, span_warning("[src] won't reach that far."))
		return TRUE
	if(istype(target, /obj/structure/table))
		return unload_onto_table(target, user)
	if(istype(target, /obj/machinery/light/rogue/oven))
		return insert_into_oven(target, user)
	return FALSE

/obj/item/rogueweapon/bakers_peel/proc/can_reach_target(atom/target, mob/user)
	if(!user.is_holding(src))
		return FALSE
	if(get_dist(get_turf(user), get_turf(target)) > 2)
		return FALSE
	return user.CanReach(target, src)

/obj/item/rogueweapon/bakers_peel/proc/storage_component()
	return GetComponent(/datum/component/storage)

/obj/item/rogueweapon/bakers_peel/proc/stored_items() as /list
	var/datum/component/storage/STR = storage_component()
	if(!STR)
		return list()
	return STR.contents()

/obj/item/rogueweapon/bakers_peel/proc/stored_item_count()
	return stored_items().len

/obj/item/rogueweapon/bakers_peel/proc/storage_space_left()
	var/datum/component/storage/STR = storage_component()
	if(!STR)
		return 0
	return STR.remaining_space_items()

/obj/item/rogueweapon/bakers_peel/proc/has_space()
	return storage_space_left() > 0

/obj/item/rogueweapon/bakers_peel/proc/can_load_item(obj/item/I)
	if(!I || QDELETED(I) || I == src)
		return FALSE
	if(I.anchored)
		return FALSE
	if(I.wlength > WLENGTH_NORMAL)
		return FALSE
	var/datum/component/storage/STR = storage_component()
	return STR && STR.can_be_inserted(I, TRUE)

/obj/item/rogueweapon/bakers_peel/proc/is_raw_cookable_food(obj/item/I)
	if(!istype(I, /obj/item/reagent_containers/food/snacks))
		return FALSE
	var/obj/item/reagent_containers/food/snacks/food_item = I
	return food_item.cooked_type

/obj/item/rogueweapon/bakers_peel/proc/is_matching_food(obj/item/I, obj/item/source)
	if(I.type == source.type)
		return TRUE
	return is_raw_cookable_food(source) && is_raw_cookable_food(I)

/obj/item/rogueweapon/bakers_peel/proc/load_item(obj/item/I)
	if(!can_load_item(I))
		return FALSE
	var/datum/component/storage/STR = storage_component()
	return STR.handle_item_insertion(I, TRUE)

/obj/item/rogueweapon/bakers_peel/proc/scoop_from_table(obj/item/source, mob/user)
	if(!can_reach_target(source, user))
		return FALSE
	if(!has_space())
		to_chat(user, span_warning("[src] is already full."))
		return TRUE
	if(!can_load_item(source))
		return FALSE
	var/turf/table_turf = get_turf(source)
	if(!table_turf || !(locate(/obj/structure/table) in table_turf))
		return FALSE
	var/list/to_scoop = list()
	var/space_left = storage_space_left()
	for(var/obj/item/I in table_turf)
		if(to_scoop.len >= space_left)
			break
		if(I.type == source.type && can_load_item(I))
			to_scoop += I
	for(var/obj/item/I in table_turf)
		if(to_scoop.len >= space_left)
			break
		if(I in to_scoop)
			continue
		if(is_matching_food(I, source) && can_load_item(I))
			to_scoop += I
	if(!to_scoop.len)
		return FALSE
	var/loaded_count = 0
	for(var/obj/item/I as anything in to_scoop)
		if(load_item(I))
			loaded_count++
	if(!loaded_count)
		return FALSE
	user.visible_message(span_info("[user] slides [loaded_count] item[loaded_count == 1 ? "" : "s"] onto [src]."), span_info("I slide [loaded_count] item[loaded_count == 1 ? "" : "s"] onto [src]."))
	playsound(get_turf(user), 'sound/foley/dropsound/wooden_drop.ogg', 50, TRUE)
	return TRUE

/obj/item/rogueweapon/bakers_peel/proc/unload_onto_table(obj/structure/table/table, mob/user)
	if(!can_reach_target(table, user))
		return FALSE
	if(!stored_item_count())
		to_chat(user, span_warning("[src] is empty."))
		return TRUE
	var/turf/table_turf = get_turf(table)
	if(!table_turf)
		return FALSE
	var/count = dump_loaded_items(table_turf)
	user.visible_message(span_info("[user] turns [count] item[count == 1 ? "" : "s"] out onto [table]."), span_info("I turn [count] item[count == 1 ? "" : "s"] out onto [table]."))
	playsound(table_turf, 'sound/foley/dropsound/wooden_drop.ogg', 50, TRUE)
	return TRUE

/obj/item/rogueweapon/bakers_peel/proc/spill_loaded_items(mob/living/user, message_start)
	if(!stored_item_count())
		return 0
	var/turf/drop_turf = user ? get_turf(user) : get_turf(src)
	var/count = dump_loaded_items(drop_turf)
	if(!count)
		return 0
	if(user)
		user.visible_message(span_warning("[message_start] [count] item[count == 1 ? "" : "s"] from [src] onto the floor."), span_warning("[message_start] [count] item[count == 1 ? "" : "s"] from [src] onto the floor."))
	else
		visible_message(span_warning("[count] item[count == 1 ? "" : "s"] fall from [src] onto the floor."))
	playsound(drop_turf, 'sound/foley/dropsound/wooden_drop.ogg', 50, TRUE)
	return count

/obj/item/rogueweapon/bakers_peel/proc/dump_loaded_items(turf/T)
	if(!T)
		return 0
	var/datum/component/storage/STR = storage_component()
	if(!STR)
		return 0
	var/count = 0
	for(var/obj/item/I as anything in stored_items())
		if(STR.remove_from_storage(I, T))
			I.pixel_x = initial(I.pixel_x)
			I.pixel_y = initial(I.pixel_y)
			count++
	return count

/obj/item/rogueweapon/bakers_peel/proc/insert_into_oven(obj/machinery/light/rogue/oven/oven, mob/user)
	if(!can_reach_target(oven, user))
		return FALSE
	if(!stored_item_count())
		to_chat(user, span_warning("[src] is empty."))
		return TRUE
	var/free_space = oven.maxfood - oven.food.len
	if(free_space <= 0)
		to_chat(user, span_warning("[oven] is already full."))
		return TRUE
	var/datum/component/storage/STR = storage_component()
	if(!STR)
		return FALSE
	var/count = 0
	for(var/obj/item/I as anything in stored_items())
		if(count >= free_space)
			break
		if(STR.remove_from_storage(I, oven))
			oven.food += I
			count++
	if(!count)
		to_chat(user, span_warning("Nothing on [src] fits in [oven]."))
		return TRUE
	var/mob/living/carbon/human/H = user
	if(istype(H))
		oven.lastuser = H
	oven.donefoods = FALSE
	oven.need_underlay_update = TRUE
	oven.update_icon()
	user.visible_message(span_info("[user] slides [count] item[count == 1 ? "" : "s"] from [src] into [oven]."), span_info("I slide [count] item[count == 1 ? "" : "s"] from [src] into [oven]."))
	playsound(get_turf(oven), 'sound/items/wood_sharpen.ogg', 50)
	return TRUE

/obj/item/rogueweapon/bakers_peel/proc/take_from_oven(obj/machinery/light/rogue/oven/oven, mob/user)
	if(!can_reach_target(oven, user))
		return FALSE
	if(!has_space())
		to_chat(user, span_warning("[src] is already full."))
		return TRUE
	if(!oven.food.len)
		to_chat(user, span_warning("[oven] is empty."))
		return TRUE
	var/free_space = storage_space_left()
	var/count = 0
	for(var/i = oven.food.len, i >= 1, i--)
		if(count >= free_space)
			break
		var/obj/item/I = oven.food[i]
		if(!can_load_item(I))
			continue
		if(load_item(I))
			oven.food -= I
			count++
	if(!count)
		to_chat(user, span_warning("Nothing in [oven] fits on [src]."))
		return TRUE
	var/mob/living/carbon/human/H = user
	if(istype(H))
		oven.lastuser = H
	oven.donefoods = FALSE
	oven.need_underlay_update = TRUE
	oven.update_icon()
	user.visible_message(span_info("[user] draws [count] item[count == 1 ? "" : "s"] from [oven] onto [src]."), span_info("I draw [count] item[count == 1 ? "" : "s"] from [oven] onto [src]."))
	playsound(get_turf(oven), 'sound/items/wood_sharpen.ogg', 50)
	return TRUE
