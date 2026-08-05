/proc/zad_max_weight_for_tier(tier)
	switch(tier)
		if(ZAD_CAPACITY_TIER_1)
			return WEIGHT_CLASS_SMALL
		if(ZAD_CAPACITY_TIER_2)
			return WEIGHT_CLASS_NORMAL
		if(ZAD_CAPACITY_TIER_3)
			return WEIGHT_CLASS_BULKY
	return WEIGHT_CLASS_SMALL

/proc/zad_tier_label(tier)
	switch(tier)
		if(ZAD_CAPACITY_TIER_1)
			return "1 zad (small / tiny)"
		if(ZAD_CAPACITY_TIER_2)
			return "2 zads (normal-sized, pouch)"
		if(ZAD_CAPACITY_TIER_3)
			return "3 zads (bulky, large container)"
	return ""

/obj/item/roguemachine/zadcote/proc/scan_payload_items(mob/user)
	var/list/found = list()
	if(!user)
		return found
	var/obj/item/active = user.get_active_held_item()
	if(!active)
		return found
	if(istype(active, /obj/item/zadcage))
		return found
	if(istype(active, /obj/item/zadpack))
		return found
	if(istype(active, /obj/item/bomb))
		return found
	found += active
	return found

/obj/item/roguemachine/zadcote/proc/dispatch(datum/zadlink/link, zad_count, message_text, list/payload_refs, bomb_count, mob/operator, bomb_caw = "")
	if(!link || link.severed)
		if(operator)
			to_chat(operator, span_warning("That zadlink is severed."))
		return FALSE
	var/obj/item/zadcage/cage = link.resolve_cage()
	if(!cage)
		if(operator)
			to_chat(operator, span_warning("That zadlink has no bonded zadcage."))
		return FALSE
	if(link.resolve_flight())
		if(operator)
			to_chat(operator, span_warning("A flight is already on that slot."))
		return FALSE
	if(cage.current_occupancy)
		if(operator)
			to_chat(operator, span_warning("That zadcage is already occupied. Wait for it to return."))
		return FALSE
	if(length(cage.held_payload))
		if(operator)
			to_chat(operator, span_warning("Unclaimed parcels still sit in that zadcage. Wait for the holder to retrieve them."))
		return FALSE
	zad_count = clamp(zad_count, ZAD_CAPACITY_TIER_1, ZAD_CAPACITY_TIER_3)
	bomb_count = clamp(bomb_count, 0, ZAD_CAPACITY_TIER_3)
	if(bomb_count > 0 && !can_send_bombs())
		if(operator)
			to_chat(operator, span_warning("The zads refuse - you may only send a bombs flight every 5 minutes, you maniac."))
		return FALSE
	if(bomb_count > bomb_stock)
		if(operator)
			to_chat(operator, span_warning("The zadcote has only [bomb_stock] bottlebombs stored."))
		return FALSE
	if(bomb_count > 0 && bomb_count != zad_count)
		zad_count = bomb_count
	if(reserve < zad_count)
		if(operator)
			to_chat(operator, span_warning("Only [reserve] zads remain in the cote."))
		return FALSE
	if(flight_count() >= ZADCOTE_FLIGHT_CAP)
		if(operator)
			to_chat(operator, span_warning("Too many flights in the air."))
		return FALSE
	var/list/payload_items = list()
	if(bomb_count == 0 && length(payload_refs) && operator)
		var/list/held_items = scan_payload_items(operator)
		for(var/ref_id in payload_refs)
			for(var/obj/item/I in held_items)
				if("\ref[I]" == ref_id)
					payload_items += I
					break
	var/max_weight = zad_max_weight_for_tier(zad_count)
	for(var/obj/item/I in payload_items)
		if(I.w_class > max_weight)
			if(operator)
				to_chat(operator, span_warning("[I] is too heavy for [zad_count] zad\s. Use a larger tier or send a smaller parcel."))
			return FALSE
	consume_reserve(zad_count)
	if(bomb_count > 0)
		bomb_stock -= bomb_count
		start_bomb_cooldown()
	var/datum/zad_flight/flight = new(src, link, zad_count, message_text, payload_items, bomb_count)
	if(operator && operator.client)
		flight.sender_ckey = operator.client.ckey
	if(bomb_count > 0)
		flight.bomb_caw = bomb_caw
	pending_outbound += flight
	link.pending_flight = WEAKREF(flight)
	playsound(loc, 'sound/vo/mobs/bird/birdfly.ogg', 65, TRUE, 2)
	playsound(loc, pick('sound/vo/mobs/bird/CROW_01.ogg','sound/vo/mobs/bird/CROW_02.ogg','sound/vo/mobs/bird/CROW_03.ogg'), 55, TRUE, 2)
	visible_message(span_notice("[zad_count] zad\s leap from [src] and beat for the sky."))
	play_zad_ascend(src, zad_count, payload_items, bomb_count)
	var/list/sent_names = list()
	for(var/obj/item/I in payload_items)
		sent_names += I.name
	log_sent(link.slot_index, link.get_label(), message_text, sent_names, zad_count, bomb_count)
	if(operator)
		on_dispatched(flight, operator)
	return TRUE

/obj/item/roguemachine/zadcote/proc/on_dispatched(datum/zad_flight/flight, mob/operator)
	return

/obj/item/roguemachine/zadcote/process()
	if(!anchored)
		return
	advance_outbound_flights()
	advance_return_flights()

/obj/item/roguemachine/zadcote/proc/advance_outbound_flights()
	for(var/datum/zad_flight/flight in pending_outbound)
		if(!flight.turnback_checked && world.time >= flight.launch_time + ZAD_FLIGHT_TURNBACK_CHECK)
			flight.turnback_checked = TRUE
			var/datum/zadlink/link = flight.resolve_target_link()
			if(!link || !link.resolve_cage())
				resolve_turnback(flight)
				continue
		if(world.time >= flight.arrival_time)
			resolve_arrival(flight)

/obj/item/roguemachine/zadcote/proc/advance_return_flights()
	for(var/datum/zad_flight/flight in pending_return)
		if(world.time >= flight.arrival_time)
			resolve_return(flight)

/obj/item/roguemachine/zadcote/proc/resolve_turnback(datum/zad_flight/flight)
	var/turf/T = get_turf(src)
	flight.drop_payload(T)
	restock(flight.zads_used)
	if(flight.bombs > 0)
		bomb_stock = min(bomb_stock + flight.bombs, ZADCOTE_BOMB_STOCK_CAP)
	var/datum/zadlink/link = flight.resolve_target_link()
	if(link)
		link.pending_flight = null
	pending_outbound -= flight
	visible_message(span_warning("The zads return to [src] - there was nowhere to land."))

/obj/item/roguemachine/zadcote/proc/resolve_arrival(datum/zad_flight/flight)
	var/datum/zadlink/link = flight.resolve_target_link()
	if(!link)
		pending_outbound -= flight
		return
	var/obj/item/zadcage/cage = link.resolve_cage()
	if(!cage)
		resolve_turnback(flight)
		return
	cage.receive_flight(flight)
	pending_outbound -= flight
	addtimer(CALLBACK(src, PROC_REF(clear_link_pending), link), ZAD_DESCEND_DURATION)
	var/mob/holder = cage.holder_mob()
	if(!holder)
		visible_message(span_warning("[src] chimes. The zads report Zadcage #[link.slot_index] is not on a person."))

/obj/item/roguemachine/zadcote/proc/clear_link_pending(datum/zadlink/link)
	if(link)
		link.pending_flight = null

/obj/item/roguemachine/zadcote/proc/receive_return(datum/zad_flight/flight)
	pending_return += flight

/obj/item/roguemachine/zadcote/proc/resolve_return(datum/zad_flight/flight)
	var/precomputed_lost = 0
	if(flight.bombs == 0)
		for(var/i in 1 to flight.zads_used)
			if(attrition_roll())
				precomputed_lost++
	flight.precomputed_lost = precomputed_lost
	var/live_zads = flight.zads_used - precomputed_lost
	play_zad_descend(src, live_zads, flight.payload_items)
	if(precomputed_lost > 0)
		play_zad_plummet(src, precomputed_lost)
	if(live_zads > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(play_zad_arrival), src, live_zads), ZAD_DESCEND_DURATION)
	addtimer(CALLBACK(src, PROC_REF(complete_return), flight), ZAD_DESCEND_DURATION)
	playsound(src, 'sound/vo/mobs/bird/birdfly.ogg', 60, TRUE, 2)
	playsound(src, pick('sound/vo/mobs/bird/CROW_01.ogg','sound/vo/mobs/bird/CROW_02.ogg','sound/vo/mobs/bird/CROW_03.ogg'), 50, TRUE, 2)
	pending_return -= flight

/obj/item/roguemachine/zadcote/proc/complete_return(datum/zad_flight/flight)
	if(!flight)
		return
	var/datum/zadlink/link = flight.resolve_target_link()
	var/sender_label = link ? link.get_label() : "an unknown slot"
	var/slot_index = link ? link.slot_index : 0
	var/list/item_names = list()
	for(var/obj/item/I in flight.payload_items)
		item_names += I.name
	var/turf/T = get_turf(src)
	flight.drop_payload(T)
	var/lost = max(0, flight.precomputed_lost)
	if(flight.bombs == 0)
		var/recovered = flight.zads_used - lost
		if(recovered > 0)
			restock(recovered)
		if(lost > 0)
			var/loss_text
			if(flight.zads_used == 1)
				loss_text = "the zad perished of exhaustion."
			else if(lost == flight.zads_used)
				loss_text = "all [lost] zads perished of exhaustion."
			else
				loss_text = "[lost] of [flight.zads_used] zads dropped from the sky, exhausted - [flight.zads_used - lost] returned home."
			visible_message(span_warning("[src] reports [loss_text]"))
	log_mail(slot_index, sender_label, flight.message_text, item_names, lost, flight.zads_used)
	if(length(flight.message_text) || length(item_names))
		var/list/parts = list()
		var/display_name = link ? link.display_name : ""
		var/slot_header = length(display_name) ? "Slot [slot_index] ([display_name])" : "Slot [slot_index]"
		parts += slot_header
		if(length(flight.message_text))
			parts += "says: \"[flight.message_text]\""
		if(length(item_names))
			parts += "brings: [english_list(item_names)]"
		visible_message(span_notice("A zad returns to [src] - [parts.Join(" ")]"))
		playsound(src, 'sound/misc/notice.ogg', 60, FALSE, -1)
	else if(lost == 0)
		visible_message(span_notice("A zad returns to [src] - empty-clawed."))

/obj/item/roguemachine/zadcote/proc/log_mail(slot_index, sender_label, message_text, list/item_names, lost = 0, zads_used = 0)
	mail_log.Insert(1, list(list(
		"stamp" = station_time_timestamp("hh:mm"),
		"slot" = slot_index,
		"sender" = sender_label,
		"message" = message_text,
		"items" = item_names ? item_names.Copy() : list(),
		"lost" = lost,
		"zads_used" = zads_used,
		"kind" = "returned",
	)))
	if(length(mail_log) > 20)
		mail_log.Cut(21)

/obj/item/roguemachine/zadcote/proc/log_sent(slot_index, sender_label, message_text, list/item_names, zads_used, bombs, summoned = FALSE)
	mail_log.Insert(1, list(list(
		"stamp" = station_time_timestamp("hh:mm"),
		"slot" = slot_index,
		"sender" = sender_label,
		"message" = message_text,
		"items" = item_names ? item_names.Copy() : list(),
		"zads_used" = zads_used,
		"bombs" = bombs,
		"summoned" = summoned,
		"kind" = "sent",
	)))
	if(length(mail_log) > 20)
		mail_log.Cut(21)
