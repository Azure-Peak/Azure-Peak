/// Base component that reacts when an item is dropped or unequipped.
/// Override handle_drop() in subtypes to define behavior.
/datum/component/item_on_drop

/datum/component/item_on_drop/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))

/datum/component/item_on_drop/proc/on_dropped(obj/item/source, mob/user)
	SIGNAL_HANDLER
	handle_drop(source, user)

/// Override this in subtypes to define what happens when the item is dropped.
/datum/component/item_on_drop/proc/handle_drop(obj/item/source, mob/user)
	return

/// Deletes the item when dropped - it crumbles to dust.
/datum/component/item_on_drop/dust

/datum/component/item_on_drop/dust/handle_drop(obj/item/source, mob/user)
	qdel(source)
