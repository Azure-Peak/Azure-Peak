/obj/item/roguemachine/zadcote
	name = "zadcote"
	desc = "A great coop of wood and iron where carrier zads are kept, fed, and dispatched abroad."
	icon = 'icons/roguetown/misc/zadcote.dmi'
	icon_state = "zadcote"
	density = FALSE
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	max_integrity = 0
	blade_dulling = DULLING_BASH
	var/faction = ZADCOTE_FACTION_MERCHANT
	var/motto = "ZADCOTE"
	var/list/operator_jobs = list()
	var/operator_trait
	var/list/datum/zadlink/slots = list()
	var/list/datum/zad_flight/pending_outbound = list()
	var/list/datum/zad_flight/pending_return = list()
	var/reserve = ZADCOTE_RESERVE_START
	var/bomb_stock = 0
	var/bomb_cooldown_until = 0
	var/allows_voyeur = FALSE
	var/voyeur_fund = 0
	var/zadcage_dir = null
	var/list/mail_log = list()

/obj/item/roguemachine/zadcote/Initialize()
	. = ..()
	for(var/i in 1 to ZADCOTE_SLOT_CAP)
		slots += new /datum/zadlink(src, i)
	START_PROCESSING(SSroguemachine, src)
	addtimer(CALLBACK(src, PROC_REF(spawn_starter_cages)), 1)

/obj/item/roguemachine/zadcote/proc/spawn_starter_cages()
	var/turf/forced_tile = null
	if(!isnull(zadcage_dir))
		var/turf/T = get_step(src, zadcage_dir)
		if(T && !T.density)
			forced_tile = T
	for(var/datum/zadlink/link in slots)
		if(link.resolve_cage())
			continue
		var/turf/spawn_at = forced_tile || get_turf(src)
		var/obj/item/zadcage/cage = new(spawn_at)
		cage.pixel_x = 1
		cage.pixel_y = 0
		attach_cage(cage, null)

/obj/item/roguemachine/zadcote/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	for(var/datum/zadlink/link in slots)
		link.sever()
	slots.Cut()
	pending_outbound.Cut()
	pending_return.Cut()
	return ..()

/obj/item/roguemachine/zadcote/examine()
	. = ..()
	. += span_notice(motto)
	. += span_info("Reserve: [reserve] zads. Flights: [flight_count()] / [ZADCOTE_FLIGHT_CAP].")
	if(bomb_stock)
		. += span_info("Bombs stored: [bomb_stock] / [ZADCOTE_BOMB_STOCK_CAP].")

/obj/item/roguemachine/zadcote/proc/is_operator(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	if(H.job in operator_jobs)
		return TRUE
	if(operator_trait && HAS_TRAIT(H, operator_trait))
		return TRUE
	return FALSE

/obj/item/roguemachine/zadcote/proc/can_restock(mob/living/carbon/human/H)
	return is_operator(H)

/obj/item/roguemachine/zadcote/proc/flight_count()
	return length(pending_outbound) + length(pending_return)

/obj/item/roguemachine/zadcote/proc/request_summon(datum/zadlink/link, mob/requester, zad_count = ZAD_CAPACITY_TIER_1)
	if(!link || link.severed)
		return FALSE
	if(!link.allow_summons)
		if(requester)
			to_chat(requester, span_warning("The zadcote does not accept summons on this zadlink."))
		return FALSE
	var/obj/item/zadcage/cage = link.resolve_cage()
	if(!cage)
		return FALSE
	if(link.resolve_flight())
		if(requester)
			to_chat(requester, span_warning("A flight is already on this zadlink."))
		return FALSE
	if(cage.current_occupancy)
		if(requester)
			to_chat(requester, span_warning("This zadcage is already occupied."))
		return FALSE
	zad_count = clamp(zad_count, ZAD_CAPACITY_TIER_1, ZAD_CAPACITY_TIER_3)
	if(reserve < zad_count)
		if(requester)
			to_chat(requester, span_warning("Only [reserve] zads remain in the cote."))
		return FALSE
	if(flight_count() >= ZADCOTE_FLIGHT_CAP)
		if(requester)
			to_chat(requester, span_warning("Too many flights in the air. Try again shortly."))
		return FALSE
	consume_reserve(zad_count)
	var/datum/zad_flight/flight = new(src, link, zad_count, "", null, 0)
	if(requester && requester.client)
		flight.sender_ckey = requester.client.ckey
	pending_outbound += flight
	link.pending_flight = WEAKREF(flight)
	playsound(loc, 'sound/vo/mobs/bird/birdfly.ogg', 65, TRUE, 2)
	playsound(loc, pick('sound/vo/mobs/bird/CROW_01.ogg','sound/vo/mobs/bird/CROW_02.ogg','sound/vo/mobs/bird/CROW_03.ogg'), 55, TRUE, 2)
	visible_message(span_notice("[zad_count] zad\s leap from [src], summoned away."))
	play_zad_ascend(src, zad_count)
	log_sent(link.slot_index, link.get_label(), "", list(), zad_count, 0, TRUE)
	return TRUE

/obj/item/roguemachine/zadcote/proc/find_slot_by_index(index)
	if(index < 1 || index > length(slots))
		return null
	return slots[index]

/obj/item/roguemachine/zadcote/proc/find_slot_by_cage(obj/item/zadcage/cage)
	if(!cage)
		return null
	for(var/datum/zadlink/link in slots)
		if(link.resolve_cage() == cage)
			return link
	return null

/obj/item/roguemachine/zadcote/proc/find_free_slot()
	for(var/datum/zadlink/link in slots)
		if(!link.resolve_cage() && !link.severed)
			return link
	for(var/datum/zadlink/link in slots)
		if(link.severed)
			return link
	return null

/obj/item/roguemachine/zadcote/proc/attach_cage(obj/item/zadcage/cage, mob/user)
	if(!cage || !cage.is_unbound())
		return FALSE
	var/datum/zadlink/link = find_free_slot()
	if(!link)
		if(user)
			to_chat(user, span_warning("[src] is full - no free slot to bond this zadcage."))
		return FALSE
	link.attach_cage(cage)
	cage.bind_to_link(src, link)
	if(user)
		to_chat(user, span_notice("The zadcote chirps as the zadcage clicks into bond on slot [link.slot_index]."))
	return TRUE

/obj/item/roguemachine/zadcote/proc/sever_link(datum/zadlink/link, mob/operator)
	if(!link || link.severed)
		return FALSE
	link.sever()
	if(operator)
		to_chat(operator, span_notice("The bond on slot [link.slot_index] withers. The zads will return what is owed, then no more."))
	return TRUE

/obj/item/roguemachine/zadcote/proc/consume_reserve(amount)
	if(reserve < amount)
		return FALSE
	reserve -= amount
	return TRUE

/obj/item/roguemachine/zadcote/proc/restock(amount)
	reserve = min(reserve + amount, ZADCOTE_RESERVE_CAP)

/obj/item/roguemachine/zadcote/proc/can_send_bombs()
	return world.time >= bomb_cooldown_until

/obj/item/roguemachine/zadcote/proc/start_bomb_cooldown()
	bomb_cooldown_until = world.time + ZADCOTE_BOMB_COOLDOWN

/obj/item/roguemachine/zadcote/proc/attrition_roll()
	return prob(ZADCOTE_ATTRITION_PERCENT)

/obj/item/roguemachine/zadcote/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	if(!is_operator(user))
		to_chat(user, span_warning("The zadcote ignores you. Only its owners may operate it."))
		return
	ui_interact(user)

/obj/item/roguemachine/zadcote/attack_right(mob/user)
	if(!anchored)
		return ..()
	if(!is_operator(user))
		return
	ui_interact(user)

/obj/item/roguemachine/zadcote/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/item/roguemachine/zadcote/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Zadcote")
		ui.open()

/obj/item/roguemachine/zadcote/ui_data(mob/user)
	var/list/data = list()
	data["faction"] = faction
	data["motto"] = motto
	data["reserve"] = reserve
	data["reserve_start"] = ZADCOTE_RESERVE_CAP
	data["flights"] = flight_count()
	data["flight_cap"] = ZADCOTE_FLIGHT_CAP
	data["bomb_stock"] = bomb_stock
	data["bomb_stock_cap"] = ZADCOTE_BOMB_STOCK_CAP
	data["bomb_cooldown_remaining"] = max(0, round((bomb_cooldown_until - world.time) / 10))
	data["allows_voyeur"] = allows_voyeur
	data["voyeur_fund"] = voyeur_fund
	data["voyeur_cost"] = ZAD_VOYEUR_COST_MAMMON
	var/list/mail_rows = list()
	for(var/list/entry in mail_log)
		mail_rows += list(list(
			"slot" = entry["slot"],
			"sender" = entry["sender"],
			"message" = entry["message"],
			"items" = entry["items"],
			"stamp" = entry["stamp"],
			"kind" = entry["kind"],
			"lost" = entry["lost"],
			"zads_used" = entry["zads_used"],
			"bombs" = entry["bombs"],
			"summoned" = entry["summoned"],
		))
	data["mail_log"] = mail_rows
	var/list/slot_rows = list()
	for(var/datum/zadlink/link in slots)
		var/obj/item/zadcage/cage = link.resolve_cage()
		var/datum/zad_flight/flight = link.resolve_flight()
		var/list/row = list(
			"slot" = link.slot_index,
			"name" = link.display_name,
			"label" = link.get_label(),
			"severed" = link.severed,
			"bonded" = cage ? TRUE : FALSE,
			"in_flight" = flight ? TRUE : FALSE,
			"cage_occupied" = (cage && cage.current_occupancy) ? TRUE : FALSE,
			"cage_has_payload" = (cage && length(cage.held_payload)) ? TRUE : FALSE,
			"allow_summons" = link.allow_summons,
		)
		if(flight)
			row["flight_zads"] = flight.zads_used
			row["flight_arrival_seconds"] = max(0, round((flight.arrival_time - world.time) / 10))
			row["flight_direction"] = flight.direction
			row["flight_bombs"] = flight.bombs
		slot_rows += list(row)
	data["slots"] = slot_rows
	var/list/payload = list()
	for(var/obj/item/I in scan_payload_items(user))
		payload += list(list(
			"name" = I.name,
			"ref" = "\ref[I]",
			"w_class" = I.w_class,
		))
	data["payload_in_hand"] = payload
	return data

/obj/item/roguemachine/zadcote/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return TRUE
	if(!H.canUseTopic(src, BE_CLOSE))
		return TRUE
	if(!is_operator(H))
		to_chat(H, span_warning("Only the zadcote's faction may operate it."))
		return TRUE
	switch(action)
		if("help")
			open_economy_guidebook(H, "Common", /datum/book_entry/treasury_general/zadcote)
			return TRUE
		if("set_slot_name")
			var/slot_idx = text2num(params["slot"])
			var/new_name = params["name"]
			var/datum/zadlink/link = find_slot_by_index(slot_idx)
			if(!link)
				return TRUE
			if(!new_name)
				new_name = ""
			link.display_name = copytext(sanitize(new_name), 1, 33)
			var/obj/item/zadcage/cage = link.resolve_cage()
			if(cage)
				cage.refresh_label()
			return TRUE
		if("sever")
			var/slot_idx = text2num(params["slot"])
			var/datum/zadlink/link = find_slot_by_index(slot_idx)
			if(!link)
				return TRUE
			sever_link(link, H)
			return TRUE
		if("dispatch")
			var/slot_idx = text2num(params["slot"])
			var/zad_count = text2num(params["zads"]) || 1
			var/bombs = text2num(params["bombs"]) || 0
			var/msg = params["message"] || ""
			var/caw = params["bomb_caw"] || ""
			var/list/refs = params["payload_refs"] || list()
			var/datum/zadlink/link = find_slot_by_index(slot_idx)
			if(!link)
				return TRUE
			msg = copytext(sanitize(msg), 1, 501)
			caw = copytext(sanitize(caw), 1, 41)
			dispatch(link, zad_count, msg, refs, bombs, H, caw)
			return TRUE
		if("voyeur")
			var/slot_idx = text2num(params["slot"])
			var/datum/zadlink/link = find_slot_by_index(slot_idx)
			if(!link)
				return TRUE
			begin_voyeur(link, H)
			return TRUE
		if("toggle_summons")
			var/slot_idx = text2num(params["slot"])
			var/datum/zadlink/link = find_slot_by_index(slot_idx)
			if(!link)
				return TRUE
			link.allow_summons = !link.allow_summons
			return TRUE
		if("withdraw_voyeur")
			withdraw_voyeur(H)
			return TRUE

/obj/item/roguemachine/zadcote/proc/withdraw_voyeur(mob/living/carbon/human/operator)
	if(!allows_voyeur)
		return FALSE
	if(voyeur_fund <= 0)
		to_chat(operator, span_warning("The scrying basin is empty."))
		return FALSE
	var/amount = voyeur_fund
	voyeur_fund = 0
	budget2change(amount, operator)
	to_chat(operator, span_notice("You drain [amount]m from [src]'s scrying basin."))
	playsound(loc, 'sound/misc/gold_misc.ogg', 60, FALSE, -1)
	return TRUE

/obj/item/roguemachine/zadcote/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/zadcage))
		var/obj/item/zadcage/cage = I
		if(!is_operator(user))
			to_chat(user, span_warning("You have no authority to bond a zadcage to this zadcote."))
			return
		if(!cage.is_unbound())
			to_chat(user, span_warning("This zadcage is already bonded elsewhere."))
			return
		attach_cage(cage, user)
		return
	if(istype(I, /obj/item/bomb))
		if(!is_operator(user))
			to_chat(user, span_warning("Only the zadcote's owners may use it."))
			return
		if(bomb_stock >= ZADCOTE_BOMB_STOCK_CAP)
			to_chat(user, span_warning("The zadcote's bomb crate is full."))
			return
		bomb_stock++
		to_chat(user, span_notice("You feed a bottlebomb into [src]'s crate. ([bomb_stock] / [ZADCOTE_BOMB_STOCK_CAP])"))
		playsound(loc, 'sound/items/firelight.ogg', 40, FALSE, -1)
		qdel(I)
		return
	if(istype(I, /obj/item/roguecoin))
		if(!allows_voyeur)
			to_chat(user, span_warning("This zadcote has no scrying basin to feed."))
			return
		var/obj/item/roguecoin/C = I
		var/added = C.sellprice * C.quantity
		if(added <= 0)
			return
		voyeur_fund += added
		to_chat(user, span_notice("You feed [C] into [src]'s scrying basin. ([voyeur_fund]m stored.)"))
		playsound(loc, 'sound/misc/gold_misc.ogg', 60, FALSE, -1)
		qdel(C)
		return
	return ..()

/obj/item/roguemachine/zadcote/steward
	name = "stewardry zadcote"
	desc = "A zadcote of the stewardry, kept open to any membes of the Royal Court."
	faction = ZADCOTE_FACTION_STEWARD
	motto = "STEWARDRY ZADCOTE"
	operator_jobs = list("Grand Duke", "Regent", "Steward", "Clerk", "Councillor", "Hand")
	allows_voyeur = FALSE

/obj/item/roguemachine/zadcote/merchant
	name = "trading zadcote"
	desc = "An Azurian Trading Company zadcote. The brass plate reads ATC and a tally of late dispatches. The zads are sold exclusively by the Azurian Trading Company (officially), and sourced from the zad training grounds in Rosporth, where elven and humen keepers raise zads and train them to navigate and home in. In the yil 1421, in the nascent yils of the Company during the Actions off Rosporth between the Azurian and Etruscan Trading Company, the Azurian company attempted to use its newly acquired zads to bombard the Etruscan ships. Unfortunately, most of the zads homed back onto the ATC ships, leading to the loss of at least four warships and a hundred men. Since then, ATC has limited the usage of bomb zads to within Azurian territories."
	faction = ZADCOTE_FACTION_MERCHANT
	motto = "COMPANY ZADCOTE"
	operator_jobs = list("Merchant", "Shophand")
	operator_trait = TRAIT_AGENT_MERCHANT
	allows_voyeur = TRUE

/obj/item/roguemachine/zadcote/bathhouse
	name = "bathhouse zadcote"
	desc = "A bathhouse zadcote. The perches are warm with steam, a faint smell of incense in the air."
	faction = ZADCOTE_FACTION_BATHHOUSE
	motto = "BATHHOUSE ZADCOTE"
	operator_jobs = list("Bathmaster", "Bathhouse Attendant")
	operator_trait = TRAIT_AGENT_BATHHOUSE
	allows_voyeur = TRUE
