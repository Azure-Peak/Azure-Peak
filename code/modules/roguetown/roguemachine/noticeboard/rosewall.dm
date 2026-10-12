/*
The Rosewall. A bathhouse service board, spiritually kin to the mercenary statue
(talkstatue_mercenary.dm): bathhouse workers pin an advert for their services, and any
passerby may peruse the board, examine a worker's headshot, or send them an offer.

- Only Bathmasters and Bathhouse Attendants may pin/edit/remove an advert or set a status.
- Statuses: Available / Hired / Do not Disturb. A worker set to Do not Disturb cannot be sent offers (the button is hidden client-side and enforced server-side).
- Offers are delivered as a whisper to the worker with YAE/NAE response hrefs, handled in Topic() below (same pattern as the mercenary statue's direct responses).
- "Examine Headshot" opens the poster's /datum/examine_panel (the examine closer window), the same datum used by the examine chat link.
- Icon state rises with the number of pinned adverts: noticeboardbh0 -> noticeboardbh3.
*/

#define ROSEWALL_STATUS_AVAILABLE "Available"
#define ROSEWALL_STATUS_HIRED "Hired"
#define ROSEWALL_STATUS_DND "Do not Disturb"

/obj/structure/roguemachine/rosewall
	name = "The Rosewall"
	desc = "A rosewood board scented with bath-oils, hung with perfumed slips of parchment. The bathhouse's workers pin their offerings here for any passerby to peruse."
	icon = 'icons/roguetown/structure/noticeboard32.dmi'
	icon_state = "noticeboardbh0"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	layer = ABOVE_MOB_LAYER
	pixel_y = 32

	/// All adverts currently pinned to the Rosewall, keyed by the worker's real_name. Shared by every Rosewall board.
	var/static/list/rosewall_adverts = list()
	/// Pending YAE/NAE offer responses, keyed by response id.
	var/static/list/pending_offer_responses = list()
	/// Per sender/target cooldowns for sending offers.
	var/static/list/sender_cooldowns = list()
	var/static/response_id_counter = 0
	var/message_char_limit = 300
	var/response_timeout = 2 MINUTES
	var/offer_cooldown = 10 MINUTES

/obj/structure/roguemachine/rosewall/Initialize(mapload)
	. = ..()
	SSroguemachine.rosewalls += src
	update_icon()

/obj/structure/roguemachine/rosewall/Destroy()
	SSroguemachine.rosewalls -= src
	return ..()

/obj/structure/roguemachine/rosewall/update_icon()
	. = ..()
	switch(length(rosewall_adverts))
		if(0)
			icon_state = "noticeboardbh0"
		if(1 to 3)
			icon_state = "noticeboardbh1"
		if(4 to 6)
			icon_state = "noticeboardbh2"
		else
			icon_state = "noticeboardbh3"

/// Refreshes every mapped Rosewall so a new advert shows up on all of them.
/obj/structure/roguemachine/rosewall/proc/update_all_boards()
	for(var/obj/structure/roguemachine/rosewall/board in SSroguemachine.rosewalls)
		board.update_icon()

/obj/structure/roguemachine/rosewall/proc/is_bathhouse_worker(mob/living/carbon/human/H)
	return istype(H) && (H.job in list("Bathmaster", "Bathhouse Attendant"))

/obj/structure/roguemachine/rosewall/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/rosewall/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/rosewall/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Rosewall", name)
		ui.open()

/// Prunes stale entries from the static lists: adverts whose worker is gone or
/// disconnected, offer responses past their timeout (whose expiry timer may have
/// died with a destroyed board), and offer cooldowns that have already elapsed.
/// Returns TRUE if any adverts were pruned.
/obj/structure/roguemachine/rosewall/proc/prune_stale_adverts()
	for(var/response_id in pending_offer_responses)
		var/list/response_data = pending_offer_responses[response_id]
		if(!response_data["expires"] || world.time > response_data["expires"])
			pending_offer_responses -= response_id
	for(var/cooldown_key in sender_cooldowns)
		if(sender_cooldowns[cooldown_key] + offer_cooldown < world.time)
			sender_cooldowns -= cooldown_key
	var/list/stale_keys = list()
	for(var/advert_key in rosewall_adverts)
		var/list/advert_data = rosewall_adverts[advert_key]
		var/mob/living/carbon/human/worker = advert_data["mob"]
		if(!worker || QDELETED(worker) || !worker.ckey)
			stale_keys += advert_key
	if(!length(stale_keys))
		return FALSE
	for(var/key in stale_keys)
		rosewall_adverts -= key
	return TRUE

/obj/structure/roguemachine/rosewall/ui_data(mob/user)
	var/list/data = list()
	if(prune_stale_adverts())
		update_all_boards()
	var/mob/living/carbon/human/H = user
	data["is_bathhouse"] = is_bathhouse_worker(H) ? TRUE : FALSE
	data["my_key"] = istype(H) ? H.real_name : ""
	data["message_char_limit"] = message_char_limit
	data["status_options"] = list(ROSEWALL_STATUS_AVAILABLE, ROSEWALL_STATUS_HIRED, ROSEWALL_STATUS_DND)
	var/list/adverts = list()
	for(var/advert_key in rosewall_adverts)
		var/list/advert_data = rosewall_adverts[advert_key]
		var/mob/living/carbon/human/worker = advert_data["mob"]
		adverts += list(list(
			"key" = advert_key,
			"name" = worker.real_name,
			"status" = advert_data["status"] || ROSEWALL_STATUS_AVAILABLE,
			"message" = advert_data["message"] || "",
			"advjob" = worker.advjob || "",
		))
	data["adverts"] = adverts
	return data

/obj/structure/roguemachine/rosewall/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!Adjacent(H))
		to_chat(H, span_warning("I need to be closer to the board."))
		return
	switch(action)
		if("set_status")
			if(!is_bathhouse_worker(H))
				return
			var/new_status = params["status"]
			if(!(new_status in list(ROSEWALL_STATUS_AVAILABLE, ROSEWALL_STATUS_HIRED, ROSEWALL_STATUS_DND)))
				return
			var/list/advert_data = rosewall_adverts[H.real_name]
			if(!advert_data)
				advert_data = list("status" = ROSEWALL_STATUS_AVAILABLE, "mob" = H, "message" = "")
				rosewall_adverts[H.real_name] = advert_data
			advert_data["status"] = new_status
			advert_data["mob"] = H
			to_chat(H, span_notice("I set my Rosewall status to: <b>[new_status]</b>"))
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			log_admin_private("[key_name(H)] set Rosewall status to [new_status]")
			update_all_boards()
			return TRUE
		if("edit_advert")
			if(!is_bathhouse_worker(H))
				return
			var/list/advert_data = rosewall_adverts[H.real_name]
			if(!advert_data)
				advert_data = list("status" = ROSEWALL_STATUS_AVAILABLE, "mob" = H, "message" = "")
				rosewall_adverts[H.real_name] = advert_data
			var/current_msg = advert_data["message"] || ""
			var/new_msg = stripped_input(H, "Compose my advert for the Rosewall (max [message_char_limit] characters):", "Rosewall Advert", current_msg, message_char_limit)
			if(new_msg == null)
				return
			if(!Adjacent(H))
				to_chat(H, span_warning("I moved too far from the board."))
				return
			advert_data["message"] = new_msg
			advert_data["mob"] = H
			to_chat(H, span_notice("My advert has been pinned to the Rosewall."))
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			log_admin_private("[key_name(H)] set Rosewall advert: \"[new_msg]\"")
			update_all_boards()
			return TRUE
		if("remove_advert")
			if(!is_bathhouse_worker(H))
				return
			if(!rosewall_adverts[H.real_name])
				to_chat(H, span_warning("I have no advert pinned here."))
				return
			rosewall_adverts -= H.real_name
			to_chat(H, span_notice("I take my advert down from the Rosewall."))
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			log_admin_private("[key_name(H)] removed their Rosewall advert")
			update_all_boards()
			return TRUE
		if("send_offer")
			var/target_key = params["key"]
			if(!target_key || target_key == H.real_name)
				return
			send_offer(H, target_key)
			return TRUE
		if("examine_headshot")
			var/target_key = params["key"]
			if(!target_key)
				return
			examine_headshot(H, target_key)
			return TRUE

/// Opens the poster's examine closer window for the viewer.
/obj/structure/roguemachine/rosewall/proc/examine_headshot(mob/living/carbon/human/viewer, target_key)
	var/list/advert_data = rosewall_adverts[target_key]
	if(!advert_data)
		to_chat(viewer, span_warning("That advert is no longer pinned here."))
		return
	var/mob/living/carbon/human/worker = advert_data["mob"]
	if(!worker || QDELETED(worker))
		rosewall_adverts -= target_key
		update_all_boards()
		to_chat(viewer, span_warning("That advert is no longer pinned here."))
		return
	var/datum/examine_panel/mob_examine_panel = new(worker)
	mob_examine_panel.holder = worker
	mob_examine_panel.viewing = viewer
	mob_examine_panel.ui_interact(viewer)

/// Sends an offer message to the advert's worker, with YAE/NAE response links.
/obj/structure/roguemachine/rosewall/proc/send_offer(mob/living/carbon/human/sender, target_key)
	var/list/advert_data = rosewall_adverts[target_key]
	if(!advert_data)
		to_chat(sender, span_warning("That advert is no longer pinned here."))
		return
	var/mob/living/carbon/human/worker = advert_data["mob"]
	if(!worker || QDELETED(worker) || worker.stat == DEAD || !worker.ckey)
		rosewall_adverts -= target_key
		update_all_boards()
		to_chat(sender, span_warning("My offer cannot be delivered for some reason."))
		return
	if(advert_data["status"] == ROSEWALL_STATUS_DND)
		to_chat(sender, span_warning("[worker.real_name] is not to be disturbed."))
		return
	var/cooldown_key = "rosewall_[sender.real_name]_[worker.real_name]"
	if(sender_cooldowns[cooldown_key])
		var/time_left = sender_cooldowns[cooldown_key] + offer_cooldown - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("I need to wait [mins_left] minute[mins_left == 1 ? "" : "s"] before sending [worker.real_name] another offer."))
			return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I need to stay close to the board."))
		return
	var/message = stripped_input(sender, "What offer do I wish to send? (Max [message_char_limit] characters)", "Rosewall Offer", "", message_char_limit)
	if(!message)
		return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I moved too far from the board."))
		return
	sender_cooldowns[cooldown_key] = world.time
	response_id_counter++
	var/response_id = "rosewall_[worker.real_name]_[world.time]_[response_id_counter]"
	if(!QDELETED(worker) && !QDELETED(sender))
		// Tracked by expiry time rather than an addtimer bound to this board, so the
		// entry cannot leak (holding refs to both mobs) if this board is destroyed.
		pending_offer_responses[response_id] = list("responder" = worker, "sender" = sender, "expires" = world.time + response_timeout)
	to_chat(worker, span_boldnotice("A perfumed slip finds its way to me from the Rosewall: <i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];offer_response=yae;response_id=[response_id]'>\[YAE\]</a> | <a href='?src=[REF(src)];offer_response=nae;response_id=[response_id]'>\[NAE\]</a>"))
	to_chat(sender, span_notice("My offer has been sent to [worker.real_name]."))
	playsound(worker.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
	sender.log_talk(message, LOG_SAY, tag="rosewall offer (to [key_name(worker)])")
	worker.log_talk(message, LOG_SAY, tag="rosewall offer (from [key_name(sender)])", log_globally=FALSE)

/obj/structure/roguemachine/rosewall/Topic(href, href_list)
	. = ..()
	if(href_list["offer_response"])
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_type = href_list["offer_response"]
		var/response_id = href_list["response_id"]

		if(!pending_offer_responses[response_id])
			to_chat(responder, span_warning("That response link has expired or already been used."))
			return

		var/list/response_data = pending_offer_responses[response_id]
		if(world.time > response_data["expires"])
			pending_offer_responses -= response_id
			to_chat(responder, span_warning("That response link has expired or already been used."))
			return
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		if(responder != stored_responder)
			to_chat(responder, span_warning("That response link is not for me."))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("The sender is no longer available."))
			pending_offer_responses -= response_id
			return

		pending_offer_responses -= response_id

		if(response_type == "yae")
			to_chat(sender, span_notice("[responder.real_name] responded in affirmation to my offer."))
			to_chat(responder, span_notice("I responded in affirmation to [sender.real_name]."))
		else
			to_chat(sender, span_notice("[responder.real_name] responded negatively to my offer."))
			to_chat(responder, span_notice("I responded negatively to [sender.real_name]."))

		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		responder.log_talk("offer response: [response_type]", LOG_SAY, tag="rosewall offer response (to [key_name(sender)])")
		return

#undef ROSEWALL_STATUS_AVAILABLE
#undef ROSEWALL_STATUS_HIRED
#undef ROSEWALL_STATUS_DND
