/datum/component/hag_curio_tracker
	/// Associative list: [True Name String] = [/datum/hag_boon]
	var/alist/boon_registry = list()

/datum/component/hag_curio_tracker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/hag_curio_tracker/proc/grant_boon(true_name, boon_path = /datum/hag_boon)
	if(!true_name || !ispath(boon_path))
		return

	if(boon_registry[true_name])
		var/list/existing_boons = boon_registry[true_name]
		for(var/datum/hag_boon/existing in existing_boons)
			if(existing.type == boon_path)
				return // Already has this specific boon type
	else
		boon_registry[true_name] = list()

	var/datum/hag_boon/B = new boon_path(true_name)
	var/list/name_list = boon_registry[true_name]
	name_list += B

	return B
