/// Base component that reacts when an item is dropped or unequipped.
/// Override handle_drop() in subtypes to define behavior.
/datum/component/item_on_drop

/datum/component/item_on_drop/Initialize(mapload)
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
	if(QDELETED(source)) // We guard it so shit doesnt try to delete stuff twice and runtimes.
		return
	if(user && source.loc == user)
		addtimer(CALLBACK(src, PROC_REF(check_carried), user), 1)
		return
	qdel(source)

/datum/component/item_on_drop/dust/proc/check_carried(mob/user)
	var/obj/item/source = parent
	if(QDELETED(source))
		return
	if(!QDELETED(user) && source.loc == user)
		return
	qdel(source)
