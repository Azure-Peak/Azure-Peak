/datum/zad_flight
	var/datum/weakref/origin
	var/datum/weakref/target_link
	var/direction = "outbound"
	var/zads_used = 1
	var/message_text = ""
	var/list/payload_items = list()
	var/bombs = 0
	var/launch_time
	var/arrival_time
	var/turnback_checked = FALSE
	var/sender_ckey
	var/bomb_caw = ""
	var/precomputed_lost = -1

/datum/zad_flight/New(obj/item/roguemachine/zadcote/origin_cote, datum/zadlink/link, count, msg, list/items, bomb_count)
	if(!origin_cote || !link)
		return
	origin = WEAKREF(origin_cote)
	target_link = WEAKREF(link)
	zads_used = clamp(count, ZAD_CAPACITY_TIER_1, ZAD_CAPACITY_TIER_3)
	message_text = msg || ""
	if(items)
		for(var/obj/item/I in items)
			I.forceMove(origin_cote)
			payload_items += I
	bombs = clamp(bomb_count, 0, ZAD_CAPACITY_TIER_3)
	launch_time = world.time
	var/landing = bombs ? rand(ZAD_FLIGHT_BOMB_LANDING_MIN, ZAD_FLIGHT_BOMB_LANDING_MAX) : ZAD_FLIGHT_LANDING_TIME
	arrival_time = world.time + ZAD_FLIGHT_OUTBOUND_TIME + landing

/datum/zad_flight/proc/resolve_origin()
	return origin ? origin.resolve() : null

/datum/zad_flight/proc/resolve_target_link()
	return target_link ? target_link.resolve() : null

/datum/zad_flight/proc/drop_payload(turf/destination)
	if(!destination)
		return
	for(var/obj/item/I in payload_items)
		I.forceMove(destination)
	payload_items.Cut()
