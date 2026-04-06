/obj/item/quest_compass
	name = "quest compass"
	desc = "A small enchanted compass."
	icon = 'code/modules/roguetown/roguemachine/questing/quest_compass.dmi'
	icon_state = "icon"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_WRISTS

	var/datum/weakref/linked_scroll_ref
	var/datum/weakref/focused_target_ref
	var/current_distance_state
	var/current_arrow_state
	var/last_signal_text = "The compass is unlinked."

/obj/item/quest_compass/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	vand_update_appearance()

/obj/item/quest_compass/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	linked_scroll_ref = null
	focused_target_ref = null
	return ..()

/obj/item/quest_compass/examine(mob/user)
	. = ..()
	if(linked_scroll_ref)
		. += span_notice("The compass is attuned to a quest signal.")
		. += span_notice("It keeps tracking its linked contract on its own. Use the scroll for map context, and read the compass for the live signal.")
		var/z_hint = get_z_level_hint(user)
		if(z_hint)
			. += z_hint
	else
		. += span_notice("Use the compass on a quest scroll to attune it. The scroll reveals the map, while the compass follows the live signal.")
	. += span_info(last_signal_text)

/obj/item/quest_compass/attack_self(mob/user)
	refresh_tracking(user)
	if(linked_scroll_ref)
		to_chat(user, span_info(last_signal_text))
		var/z_hint = get_z_level_hint(user)
		if(z_hint)
			to_chat(user, z_hint)
	else
		to_chat(user, span_notice("Use the compass on a quest scroll to attune it."))
	return ..()

/obj/item/quest_compass/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag || !istype(target, /obj/item/paper/scroll/quest))
		return

	var/obj/item/paper/scroll/quest/quest_scroll = target
	link_to_scroll(quest_scroll, user)

/obj/item/quest_compass/process()
	var/obj/item/paper/scroll/quest/quest_scroll = get_linked_scroll()
	if(!quest_scroll)
		reset_compass("The compass is unlinked.")
		return

	if(!quest_scroll.assigned_quest || quest_scroll.assigned_quest.complete)
		reset_compass("The linked contract is complete.")
		return

	var/mob/living/carrier = recursive_loc_check(src, /mob/living)
	refresh_tracking(carrier)

/obj/item/quest_compass/update_overlays()
	. = ..()
	if(current_distance_state)
		. += mutable_appearance(icon, current_distance_state)
	if(current_arrow_state)
		. += mutable_appearance(icon, current_arrow_state)

/obj/item/quest_compass/proc/get_linked_scroll()
	var/obj/item/paper/scroll/quest/quest_scroll = linked_scroll_ref?.resolve()
	if(!quest_scroll || QDELETED(quest_scroll))
		linked_scroll_ref = null
		return null
	return quest_scroll

/obj/item/quest_compass/proc/is_linked_to_scroll(obj/item/paper/scroll/quest/quest_scroll)
	return get_linked_scroll() == quest_scroll

/obj/item/quest_compass/proc/link_to_scroll(obj/item/paper/scroll/quest/quest_scroll, mob/user, silent = FALSE)
	if(!quest_scroll?.assigned_quest)
		if(user)
			to_chat(user, span_warning("This scroll carries no quest signal."))
		return FALSE

	linked_scroll_ref = WEAKREF(quest_scroll)
	focused_target_ref = null
	refresh_tracking(user)

	if(user && !silent)
		to_chat(user, span_notice("The compass attunes itself to [quest_scroll]."))
	return TRUE

/obj/item/quest_compass/proc/refresh_tracking(mob/user)
	var/obj/item/paper/scroll/quest/quest_scroll = get_linked_scroll()
	if(!quest_scroll)
		reset_compass("The compass is unlinked.")
		return FALSE

	if(!quest_scroll.assigned_quest)
		reset_compass("The linked scroll no longer carries a signal.")
		return FALSE

	var/turf/reference_turf = user ? get_turf(user) : get_turf(src)
	var/atom/movable/focused_target = quest_scroll.assigned_quest.resolve_compass_focus_target(reference_turf, get_focused_target())
	if(focused_target)
		focused_target_ref = WEAKREF(focused_target)
	else
		focused_target_ref = null

	var/list/signal_data = quest_scroll.assigned_quest.get_compass_signal_data(reference_turf, focused_target)
	if(!islist(signal_data))
		reset_compass("The compass cannot sense the contract.")
		return FALSE

	last_signal_text = signal_data["status_text"] || "The compass cannot sense the contract."
	current_distance_state = null
	current_arrow_state = null

	var/turf/compass_target = signal_data["compass_target"]
	var/turf/resolved_target = signal_data["resolved_target"]
	current_distance_state = get_distance_state(reference_turf, resolved_target)

	if(compass_target && reference_turf)
		current_arrow_state = get_arrow_state(get_dir(reference_turf, compass_target))

	icon_state = "icon"
	vand_update_appearance()
	return TRUE

/obj/item/quest_compass/proc/reset_compass(status_text)
	last_signal_text = status_text
	current_distance_state = null
	current_arrow_state = null
	focused_target_ref = null
	icon_state = "icon"
	vand_update_appearance()

/obj/item/quest_compass/proc/get_focused_target()
	var/atom/movable/focused_target = focused_target_ref?.resolve()
	if(!focused_target || QDELETED(focused_target))
		focused_target_ref = null
		return null
	return focused_target

/obj/item/quest_compass/proc/get_distance_state(turf/reference_turf, turf/resolved_target)
	if(!reference_turf || !resolved_target)
		return null

	var/obj/item/paper/scroll/quest/quest_scroll = get_linked_scroll()
	var/datum/quest/assigned_quest = quest_scroll?.assigned_quest
	if(assigned_quest)
		var/reference_map_file = assigned_quest.get_map_file_for_turf(reference_turf)
		var/target_map_file = assigned_quest.get_map_file_for_turf(resolved_target)
		if(reference_map_file && target_map_file && reference_map_file != target_map_file)
			return "dist_ind_1"

	var/distance = get_dist(reference_turf, resolved_target)
	if(distance >= 100)
		return "dist_ind_2"
	if(distance >= 30)
		return "dist_ind_3"
	return "dist_ind_4"

/obj/item/quest_compass/proc/get_arrow_state(direction)
	switch(direction)
		if(NORTHWEST)
			return "1"
		if(NORTHEAST)
			return "2"
		if(SOUTHWEST)
			return "3"
		if(SOUTHEAST)
			return "4"
		if(NORTH)
			return "5"
		if(SOUTH)
			return "6"
		if(WEST)
			return "7"
		if(EAST)
			return "8"
	return null

/// Returns a z-level hint string for examine, or null if same z-level or no target.
/obj/item/quest_compass/proc/get_z_level_hint(mob/user)
	var/obj/item/paper/scroll/quest/quest_scroll = get_linked_scroll()
	if(!quest_scroll?.assigned_quest)
		return null

	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return null

	var/atom/movable/focused = get_focused_target()
	var/turf/target_turf = quest_scroll.assigned_quest.get_target_location(user_turf, focused)
	if(!target_turf)
		return null

	if(target_turf.z == user_turf.z)
		return null

	if(target_turf.z > user_turf.z)
		return span_notice("The needle tilts upward � the target is <b>above</b> you.")
	else
		return span_notice("The needle tilts downward � the target is <b>below</b> you.")