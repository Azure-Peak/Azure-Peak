/datum/zad_occupancy
	var/datum/weakref/cage
	var/expires_at
	var/reply_message = ""
	var/list/reply_payload = list()
	var/zads_capacity = 1
	var/has_bombs = FALSE

/datum/zad_occupancy/New(obj/item/zadcage/owner, capacity, bombs_inbound)
	if(!owner)
		return
	cage = WEAKREF(owner)
	expires_at = world.time + ZAD_OCCUPANCY_DURATION
	zads_capacity = clamp(capacity, ZAD_CAPACITY_TIER_1, ZAD_CAPACITY_TIER_3)
	has_bombs = bombs_inbound ? TRUE : FALSE

/datum/zad_occupancy/proc/resolve_cage()
	return cage ? cage.resolve() : null

/datum/zad_occupancy/proc/time_remaining()
	return max(0, expires_at - world.time)

/datum/zad_occupancy/proc/in_warning_tail()
	return time_remaining() <= ZAD_OCCUPANCY_WARNING_TAIL
