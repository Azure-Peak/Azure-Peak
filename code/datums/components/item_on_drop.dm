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

/// Replaces the item with a cheaper equivalent the moment it leaves the wearer (dropped, stripped off a corpse, or disarmed). 
/datum/component/item_on_drop/downgrade
	var/replacement_type

/datum/component/item_on_drop/downgrade/Initialize(replacement_type)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!ispath(replacement_type, /obj/item))
		return COMPONENT_INCOMPATIBLE
	src.replacement_type = replacement_type

/datum/component/item_on_drop/downgrade/handle_drop(obj/item/source, mob/user)
	var/turf/drop_turf = get_turf(source)
	if(drop_turf && replacement_type)
		new replacement_type(drop_turf)
	qdel(source)

/// Tags the steel piece worn in `slot` to spill `iron_type` when it leaves the body.
/mob/living/carbon/human/proc/add_downgrade_to_slot(slot, iron_type)
	var/obj/item/worn = get_item_by_slot(slot)
	if(worn && iron_type)
		worn.AddComponent(/datum/component/item_on_drop/downgrade, iron_type)

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
