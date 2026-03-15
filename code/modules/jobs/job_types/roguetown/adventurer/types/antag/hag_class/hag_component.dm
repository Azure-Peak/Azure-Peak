/datum/component/hag_curio_tracker
	/// Associative list: [True Name String] = [/datum/hag_boon]
	var/alist/boon_registry = list()

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
