GLOBAL_LIST_EMPTY(kit_registry)

/datum/component/kit_owner
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/owner_ckey
	var/slot_key
	var/registry_key

/datum/component/kit_owner/Initialize(assigned_ckey, assigned_slot_key)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	owner_ckey = ckey(assigned_ckey)
	if(!owner_ckey)
		return COMPONENT_INCOMPATIBLE
	slot_key = assigned_slot_key
	if(!slot_key)
		return COMPONENT_INCOMPATIBLE
	registry_key = "[owner_ckey]-[slot_key]"
	var/obj/item/previous_item = GLOB.kit_registry[registry_key]
	if(previous_item && previous_item != parent && !QDELETED(previous_item))
		qdel(previous_item)
	GLOB.kit_registry[registry_key] = parent

/datum/component/kit_owner/Destroy(force = FALSE, silent = FALSE)
	if(registry_key && GLOB.kit_registry[registry_key] == parent)
		GLOB.kit_registry -= registry_key
	return ..()
