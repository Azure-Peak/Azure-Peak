/datum/component/hag_curio_tracker
	/// Associative list: [True Name String] = [/datum/hag_boon]
	var/alist/boon_registry = list()

/datum/component/hag_curio_tracker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
