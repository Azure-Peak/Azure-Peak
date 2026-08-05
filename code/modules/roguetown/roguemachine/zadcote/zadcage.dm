/obj/item/zadcage
	name = "zadcage"
	desc = "A small cage made to ride on a belt. Empty perches inside. Too awkward to fit in most containers."
	icon = 'icons/roguetown/misc/zadcage.dmi'
	icon_state = "zadcage"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	grid_height = 32
	grid_width = 64
	var/datum/weakref/bonded_cote
	var/datum/weakref/bonded_link
	var/datum/zad_occupancy/current_occupancy
	var/severed_announced = FALSE
	var/list/obj/item/held_payload = list()
	var/datum/weakref/voyeur_screye
	var/datum/weakref/voyeur_holder

/obj/item/zadcage/update_icon()
	cut_overlays()
	if(current_occupancy || length(held_payload))
		var/mutable_appearance/zad_underlay = mutable_appearance('icons/roguetown/mob/monster/crow.dmi', "crow", layer = layer - 0.01)
		zad_underlay.pixel_x = -2
		zad_underlay.pixel_y = 2
		add_overlay(zad_underlay)
	return ..()

/obj/item/zadcage/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	if(voyeur_screye)
		finish_voyeur()
	var/datum/zadlink/link = resolve_link()
	if(link)
		link.cage_ref = null
	current_occupancy = null
	var/turf/T = get_turf(src)
	for(var/obj/item/I in held_payload)
		if(T)
			I.forceMove(T)
		else
			qdel(I)
	held_payload.Cut()
	return ..()

/obj/item/zadcage/process()
	if(!current_occupancy)
		STOP_PROCESSING(SSroguemachine, src)
		return
	if(world.time >= current_occupancy.expires_at)
		auto_depart()

/obj/item/zadcage/proc/auto_depart()
	if(!current_occupancy)
		return
	var/obj/item/roguemachine/zadcote/cote = resolve_cote()
	var/datum/zadlink/link = resolve_link()
	if(cote && link)
		var/datum/zad_flight/empty = new(cote, link, current_occupancy.zads_capacity, "", null, 0)
		empty.direction = "return"
		empty.arrival_time = world.time + ZAD_FLIGHT_OUTBOUND_TIME
		cote.receive_return(empty)
		play_zad_ascend(src, current_occupancy.zads_capacity)
		visible_message(span_warning("The zad lifts from [src] empty - the window closed."))
	clear_occupancy()
	STOP_PROCESSING(SSroguemachine, src)

/obj/item/zadcage/proc/is_unbound()
	return !bonded_cote || !resolve_cote()

/obj/item/zadcage/proc/resolve_cote()
	return bonded_cote ? bonded_cote.resolve() : null

/obj/item/zadcage/proc/resolve_link()
	return bonded_link ? bonded_link.resolve() : null

/obj/item/zadcage/proc/bind_to_link(obj/item/roguemachine/zadcote/cote, datum/zadlink/link)
	if(!cote || !link)
		return
	bonded_cote = WEAKREF(cote)
	bonded_link = WEAKREF(link)
	severed_announced = FALSE
	refresh_label()
	update_icon()

/obj/item/zadcage/proc/on_link_severed()
	severed_announced = FALSE
	refresh_label()
	update_icon()

/obj/item/zadcage/proc/refresh_label()
	var/datum/zadlink/link = resolve_link()
	var/obj/item/roguemachine/zadcote/cote = resolve_cote()
	if(!link || !cote)
		name = initial(name)
		return
	if(link.severed)
		name = "severed zadcage"
		return
	name = "zadcage #[link.slot_index]"

/obj/item/zadcage/proc/receive_flight(datum/zad_flight/flight)
	if(!flight)
		return
	if(flight.bombs > 0)
		begin_bomb_arrival(flight)
		return
	play_zad_descend(src, flight.zads_used, flight.payload_items)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(play_zad_arrival), src, flight.zads_used), ZAD_DESCEND_DURATION)
	addtimer(CALLBACK(src, PROC_REF(complete_arrival), flight), ZAD_DESCEND_DURATION)
	playsound(src, 'sound/vo/mobs/bird/birdfly.ogg', 60, TRUE, 2)
	playsound(src, pick('sound/vo/mobs/bird/CROW_01.ogg','sound/vo/mobs/bird/CROW_02.ogg','sound/vo/mobs/bird/CROW_03.ogg'), 55, TRUE, 2)

/obj/item/zadcage/proc/complete_arrival(datum/zad_flight/flight)
	if(!flight || QDELETED(src))
		return
	current_occupancy = new /datum/zad_occupancy(src, flight.zads_used, flight.bombs > 0)
	visible_message(span_notice("A zad alights on [src]."))
	for(var/obj/item/I in flight.payload_items)
		I.forceMove(src)
		held_payload += I
	flight.payload_items.Cut()
	update_icon()
	START_PROCESSING(SSroguemachine, src)

/obj/item/zadcage/proc/clear_occupancy()
	current_occupancy = null
	update_icon()

/obj/item/zadcage/proc/retrieve_payload(mob/user)
	if(!length(held_payload))
		if(user)
			to_chat(user, span_warning("[src] holds no parcels."))
		return
	for(var/obj/item/I in held_payload)
		if(user && user.put_in_hands(I))
			to_chat(user, span_notice("You take [I] from [src]."))
			continue
		I.forceMove(get_turf(src))
	held_payload.Cut()
	update_icon()

/obj/item/zadcage/proc/dispatch_return(mob/sender, payload_ref)
	if(!current_occupancy)
		return FALSE
	var/datum/zadlink/link = resolve_link()
	if(!link)
		return FALSE
	var/obj/item/roguemachine/zadcote/cote = resolve_cote()
	if(!cote)
		return FALSE
	var/list/items = list()
	if(sender && payload_ref)
		var/obj/item/active = sender.get_active_held_item()
		if(active && active != src && !istype(active, /obj/item/zadcage) && "\ref[active]" == payload_ref)
			var/max_weight = zad_max_weight_for_tier(current_occupancy.zads_capacity)
			if(active.w_class > max_weight)
				to_chat(sender, span_warning("[active] is too heavy for the [current_occupancy.zads_capacity] zad return tier."))
				return FALSE
			items += active
	var/datum/zad_flight/return_flight = new(cote, link, current_occupancy.zads_capacity, current_occupancy.reply_message, items, 0)
	return_flight.direction = "return"
	return_flight.launch_time = world.time
	return_flight.arrival_time = world.time + ZAD_FLIGHT_OUTBOUND_TIME
	cote.receive_return(return_flight)
	play_zad_ascend(src, current_occupancy.zads_capacity, return_flight.payload_items)
	if(sender)
		visible_message(span_notice("The zad lifts from [src] and beats away."))
	clear_occupancy()
	return TRUE

/obj/item/zadcage/proc/holder_mob()
	var/atom/cursor = loc
	while(cursor && !ismob(cursor))
		if(!isatom(cursor))
			return null
		cursor = cursor.loc
	return cursor

/obj/item/zadcage/proc/visible_holder()
	var/atom/cursor = src
	while(cursor.loc && !isturf(cursor.loc))
		cursor = cursor.loc
		if(ismob(cursor))
			return cursor
	return cursor

/obj/item/zadcage/examine(mob/user)
	. = ..()
	var/datum/zadlink/link = resolve_link()
	var/obj/item/roguemachine/zadcote/cote = resolve_cote()
	if(!link || !cote)
		. += span_info("This zadcage has no bond. Strike it against a zadcote to make one.")
		return
	if(link.severed)
		. += span_warning("Bond severed. This zadcage was tied to [cote.name], slot [link.slot_index].")
		if(user && !severed_announced)
			to_chat(user, span_warning("A line of brass on the tag has gone dull. The zadlink has been severed."))
			severed_announced = TRUE
		return
	. += span_info("Bonded to [cote.name].")
	. += span_info("Slot [link.slot_index]: [link.get_label()].")
	if(current_occupancy)
		. += span_notice("A zad is waiting in the cage.")

/obj/item/zadcage/attack_self(mob/user)
	var/datum/zadlink/link = resolve_link()
	if(link && link.severed && !severed_announced)
		to_chat(user, span_warning("The zadlink has been severed."))
		severed_announced = TRUE
		return
	if(current_occupancy || length(held_payload))
		ui_interact(user)
		return
	if(link && !link.severed && link.allow_summons)
		ui_interact(user)
		return
	. = ..()

/obj/item/zadcage/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/zadcage/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Zadcage")
		ui.open()

/obj/item/zadcage/ui_data(mob/user)
	var/list/data = list()
	var/datum/zadlink/link = resolve_link()
	data["bonded"] = link ? TRUE : FALSE
	data["severed"] = link ? link.severed : FALSE
	data["slot_label"] = link ? link.get_label() : ""
	data["slot_index"] = link ? link.slot_index : 0
	var/obj/item/roguemachine/zadcote/cote = resolve_cote()
	data["cote_name"] = cote ? cote.name : ""
	data["cote_motto"] = cote ? cote.motto : ""
	data["allow_summons"] = link ? link.allow_summons : FALSE
	data["pending_flight"] = (link && link.resolve_flight()) ? TRUE : FALSE
	data["occupied"] = current_occupancy ? TRUE : FALSE
	if(current_occupancy)
		data["time_remaining"] = round(current_occupancy.time_remaining() / 10)
		data["warning_tail"] = current_occupancy.in_warning_tail()
		data["capacity"] = current_occupancy.zads_capacity
		data["has_bombs"] = current_occupancy.has_bombs
		data["reply_message"] = current_occupancy.reply_message
	var/list/payload = list()
	if(user)
		var/obj/item/active = user.get_active_held_item()
		if(active && active != src && !istype(active, /obj/item/zadcage))
			payload += list(list("name" = active.name, "ref" = "\ref[active]", "w_class" = active.w_class))
	data["payload_in_hand"] = payload
	var/list/stored = list()
	for(var/obj/item/I in held_payload)
		stored += list(list("name" = I.name))
	data["stored_payload"] = stored
	return data

/obj/item/zadcage/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("help")
			open_economy_guidebook(usr, "Common", /datum/book_entry/treasury_general/zadcote)
			return TRUE
		if("set_reply_message")
			if(!current_occupancy)
				return TRUE
			var/msg = params["message"] || ""
			current_occupancy.reply_message = copytext(sanitize(msg), 1, 501)
			return TRUE
		if("send_reply")
			if(!current_occupancy)
				return TRUE
			var/payload_ref = params["payload_ref"]
			if(do_after(usr, ZAD_MANUAL_SEND_DOAFTER, target = src))
				dispatch_return(usr, payload_ref)
			return TRUE
		if("retrieve")
			retrieve_payload(usr)
			return TRUE
		if("request_summon")
			var/datum/zadlink/link = resolve_link()
			var/obj/item/roguemachine/zadcote/cote = resolve_cote()
			if(!link || !cote)
				return TRUE
			var/zads = text2num(params["zads"]) || ZAD_CAPACITY_TIER_1
			if(do_after(usr, ZAD_MANUAL_SEND_DOAFTER, target = src))
				cote.request_summon(link, usr, zads)
			return TRUE
