/datum/element/plague_ward

/datum/element/plague_ward/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED), PROC_REF(worn_changed))

/datum/element/plague_ward/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

/datum/element/plague_ward/proc/worn_changed(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER
	if(slot == SLOT_WEAR_MASK)
		ADD_TRAIT(user, TRAIT_NOSTINK, REF(source))
	else
		REMOVE_TRAIT(user, TRAIT_NOSTINK, REF(source))
