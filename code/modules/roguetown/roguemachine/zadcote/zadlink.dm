/datum/zadlink
	var/datum/weakref/parent
	var/slot_index
	var/display_name = ""
	var/datum/weakref/cage_ref
	var/created_time
	var/severed = FALSE
	var/datum/weakref/pending_flight
	var/allow_summons = TRUE

/datum/zadlink/New(obj/item/roguemachine/zadcote/owner, index)
	parent = WEAKREF(owner)
	slot_index = index
	created_time = world.time

/datum/zadlink/proc/get_label()
	return length(display_name) ? display_name : "Slot [slot_index]"

/datum/zadlink/proc/resolve_cote()
	return parent ? parent.resolve() : null

/datum/zadlink/proc/resolve_cage()
	return cage_ref ? cage_ref.resolve() : null

/datum/zadlink/proc/resolve_flight()
	return pending_flight ? pending_flight.resolve() : null

/datum/zadlink/proc/attach_cage(obj/item/zadcage/cage)
	if(!cage)
		return FALSE
	cage_ref = WEAKREF(cage)
	severed = FALSE
	return TRUE

/datum/zadlink/proc/sever()
	severed = TRUE
	var/obj/item/zadcage/cage = resolve_cage()
	if(cage)
		cage.on_link_severed()
