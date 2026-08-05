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

/datum/component/item_on_drop/unlock
	var/lock_source

/datum/component/item_on_drop/unlock/Initialize(lock_source)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.lock_source = lock_source

/datum/component/item_on_drop/unlock/handle_drop(obj/item/source, mob/user)
	if(lock_source)
		REMOVE_TRAIT(source, TRAIT_NODROP, lock_source)

/mob/living/carbon/human/proc/lock_gear_piece(obj/item/gear, lock_source)
	ADD_TRAIT(gear, TRAIT_NODROP, lock_source)
	gear.AddComponent(/datum/component/item_on_drop/unlock, lock_source)
