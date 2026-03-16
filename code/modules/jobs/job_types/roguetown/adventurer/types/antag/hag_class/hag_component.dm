/datum/component/hag_curio_tracker
	/// Associative list: [True Name String] = [/datum/hag_boon]
	var/alist/boon_registry = list()
	/// Materials the hag currently has stored in their component.
	var/list/stored_materials = list()
	/// How many of each type of material hags can store, and which ones they can store
	var/static/list/material_limits = list(
		/obj/item/alch/hag_moss/sorrow = 5,
		/obj/item/alch/hag_moss/fury = 5,
		/obj/item/alch/hag_moss/mercy = 5,
		/obj/item/alch/hag_moss/grief = 5,
		/obj/item/alch/hag_moss/envy = 5,
		/obj/item/alch/hag_moss/lullaby = 5,
		/obj/item/alch/hag_moss/pride = 5
	)
	var/hag_tier = 1
	var/static/list/curse_registry = list(
		/datum/hag_boon/curse/rotting_touch = list("cost" = 1, "min_tier" = 1)
	)
	/// List of boon paths the hag has pre-prepared: [boon_path] = quantity
	var/list/prepared_boons = list()

/datum/component/hag_curio_tracker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(src, COMSIG_STATUS_EFFECT_HAG_CURSE_CLEARED, PROC_REF(handle_curse_cleared))

/datum/component/hag_curio_tracker/proc/grant_boon(true_name, boon_path = /datum/hag_boon, set_points)
	if(!true_name || !ispath(boon_path))
		return

	if(boon_registry[true_name])
		var/list/existing_boons = boon_registry[true_name]
		for(var/datum/hag_boon/existing in existing_boons)
			if(existing.type == boon_path)
				return // Already has this specific boon type
	else
		boon_registry[true_name] = list()

	var/datum/hag_boon/B = new boon_path(true_name, src, set_points)
	var/list/name_list = boon_registry[true_name]
	name_list += B

	return B

/datum/component/hag_curio_tracker/proc/find_boon_by_type(true_name, typepath)
	if(!boon_registry[true_name])
		return null
	var/list/B_list = boon_registry[true_name]
	for(var/datum/hag_boon/B in B_list)
		if(istype(B, typepath))
			return B
	return null

/datum/component/hag_curio_tracker/proc/receive_enchanted_item(mob/living/receiver, points = 1)
	var/t_name = receiver.real_name

	var/datum/hag_boon/item_debt/existing_debt = find_boon_by_type(t_name, /datum/hag_boon/item_debt)

	if(existing_debt)
		existing_debt.add_points(points)
		to_chat(parent, span_notice("The debt of [t_name] deepens. Their material pact now holds [existing_debt.points] points of power."))
	else
		// They don't have one, create a fresh one
		var/datum/hag_boon/item_debt/D = grant_boon(t_name, /datum/hag_boon/item_debt)
		if(D)
			D.add_points(points)
			to_chat(parent, span_notice("[t_name] has accepted your gift, unwittingly binding their name to a debt of [points] points."))

/datum/component/hag_curio_tracker/proc/handle_curse_cleared(datum/source, victim_name, curse_type)
	SIGNAL_HANDLER

	var/datum/hag_boon/curse/B = find_boon_by_type(victim_name, curse_type)
	if(B)
		to_chat(parent, span_danger("You feel like the [B.name] affecting [victim_name] was just cleared."))

		// Remove from registry
		var/list/name_list = boon_registry[victim_name]
		name_list -= B
		if(!length(name_list))
			boon_registry -= victim_name
		qdel(B)

/datum/component/hag_curio_tracker/proc/get_limit(obj/item/I)
	for(var/path in material_limits)
		if(istype(I, path))
			return material_limits[path]
	return 0

/datum/component/hag_curio_tracker/proc/absorb_item(obj/item/I)
	var/limit = get_limit(I)
	if(!limit)
		return FALSE

	var/current = stored_materials[I.type] || 0
	if(current >= limit)
		return FALSE

	stored_materials[I.type] = current + 1
	qdel(I)
	return TRUE

/datum/component/hag_curio_tracker/proc/dump_materials(turf/T)
	if(!length(stored_materials))
		return FALSE

	var/total_dumped = 0
	var/max_dump = 5

	for(var/path in stored_materials)
		while(stored_materials[path] > 0 && total_dumped < max_dump)
			new path(T)
			stored_materials[path]--
			total_dumped++

		if(total_dumped >= max_dump)
			break

	return total_dumped > 0

/datum/component/hag_curio_tracker/proc/get_available_curses_data()
	var/list/data = list()
	for(var/path in curse_registry)
		var/list/details = curse_registry[path]
		data += list(list(
			"name" = initial(path:name),
			"path" = "[path]",
			"cost" = details["cost"],
			"min_tier" = details["min_tier"]
		))
	return data

/datum/component/hag_curio_tracker/proc/transmute_boons_to_curse(true_name, list/boons, curse_path, points)
	var/list/name_list = boon_registry[true_name]
	for(var/datum/hag_boon/B in boons)
		name_list -= B
		qdel(B)

	var/datum/hag_boon/curse/C = new curse_path(true_name, src, points)
	name_list += C

/datum/component/hag_curio_tracker/proc/find_target(true_name)
	for(var/mob/living/L in GLOB.player_list)
		if(L.real_name == true_name)
			return L
	return null

/datum/component/hag_curio_tracker/proc/can_grant_boon(boon_path)
	if(!prepared_boons[boon_path] || prepared_boons[boon_path] <= 0)
		return FALSE
	// Add any tier/requirement checks here
	return TRUE

/datum/component/hag_curio_tracker/proc/consume_prepared_boon(boon_path)
	if(!can_grant_boon(boon_path))
		return FALSE
	prepared_boons[boon_path]--
	return TRUE

/datum/component/hag_curio_tracker/proc/absorb_enchanted_moss(obj/item/alch/hag_moss/enchanted/M)
	if(!M.boon_path)
		return FALSE

	prepared_boons[M.boon_path] = (prepared_boons[M.boon_path] || 0) + 1

	to_chat(parent, span_notice("The [M] dissolves into your spirit, preparing a blessing of [initial(M.boon_path:name)]."))
	qdel(M)
	return TRUE
