/*
Talking statues. A means of giving communication to certain spheres
(Church, Mercenaries) without overloading them into the SCOM ecosystem.

Ideally, these machines will encourage gathering in a "centralized" area.
Hopefully they are more useful than just writing a letter via HERMES.
*/

/obj/structure/roguemachine/talkstatue
	name = "talking statue"
	desc = "Don't map this one! Map the others!"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mercstatue" //done by zyras :3
	density = FALSE
	anchored = TRUE
	max_integrity = 0

/obj/structure/roguemachine/talkstatue/mercenary
	name = "mercenary statue"
	desc = "A gilbronze warrior erupts from the stone bell that homes them; foreign garb, horns of stone, claws of deathly metals. The perfect central-point of a proud warrior extrinsic to this place and tyme. \n\ \n\ I can place silver in to message one mercenary, and gold for all of them. A faint inscription reads: 'Silver for one, Gold for all.'"
	var/static/list/mercenary_status = list() // Stores: list(mob.key = list("status" = status, "mob" = mob, "message" = message))
	var/static/list/pending_registrations = list() // Stores: list(mob.key = mob) for remote registrations that haven't expired
	var/static/list/pending_message_links = list() // Stores: list(mob.key = mob) for remote message setting that haven't expired
	var/static/list/pending_broadcast_responses = list() // Stores: list("response_id" = list("responder" = mob, "sender" = mob)) for time-limited broadcast responses
	var/static/list/pending_direct_responses = list() // Stores: list("response_id" = list("responder" = mob, "sender" = mob)) for time-limited direct message responses
	var/static/list/sender_cooldowns = list() // Stores: list(sender.key = world.time) for message cooldowns
	var/message_char_limit = 300 // Character limit for coin messages
	var/response_timeout = 2 MINUTES // How long response links are valid
	var/sender_cooldown = 30 SECONDS // Cooldown between sending messages
	var/static/response_id_counter = 0 // Counter to ensure unique response IDs

/obj/structure/roguemachine/talkstatue/mercenary/Initialize()
	. = ..()
	if(SSroguemachine.mercenary_statue == null)
		SSroguemachine.mercenary_statue = src
	SSroguemachine.mercenary_statues |= src

/obj/structure/roguemachine/talkstatue/mercenary/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return

	// Cull invalid mercenary references first
	cull_invalid_mercenaries()

	// Check if the user is a mercenary
	if(user.mind && user.mind.assigned_role == "Mercenary")
		// Show UI with option to cycle status
		show_mercenary_ui(user, is_mercenary = TRUE)
	else
		// Show read-only UI for non-mercenaries
		show_mercenary_ui(user, is_mercenary = FALSE)

/obj/structure/roguemachine/talkstatue/mercenary/attackby(obj/item/P, mob/living/carbon/human/user, params)
	// Proximity check - user must be adjacent to the statue
	if(!Adjacent(user))
		to_chat(user, span_warning("I need to be closer to the statue."))
		return

	if(istype(P, /obj/item/roguecoin/silver))
		// Silver coin - message a specific mercenary
		var/obj/item/roguecoin/silver/coin = P
		if(coin.quantity > 1)
			to_chat(user, span_warning("I need to use a single ziliqua."))
			return
		message_single_mercenary(user, coin)
		return

	if(istype(P, /obj/item/roguecoin/gold))
		// Gold coin - broadcast to all mercenaries
		var/obj/item/roguecoin/gold/coin = P
		if(coin.quantity > 1)
			to_chat(user, span_warning("I need to use a single zenar."))
			return
		broadcast_to_mercenaries(user, coin)
		return

	return ..()

/obj/structure/roguemachine/talkstatue/mercenary/proc/cycle_mercenary_status(mob/living/carbon/human/user)
	// Get or create the status entry for this mercenary
	var/list/merc_data = mercenary_status[user.key]
	var/first_time = FALSE
	if(!merc_data)
		first_time = TRUE
		merc_data = list("status" = "Available", "mob" = user, "message" = "")
		mercenary_status[user.key] = merc_data

	var/current_status = merc_data["status"]
	var/new_status

	if(first_time)
		new_status = "Available"
	else
		switch(current_status)
			if("Available")
				new_status = "Contracted"
			if("Contracted")
				new_status = "Do not Disturb"
			if("Do not Disturb")
				new_status = "Available"

	merc_data["status"] = new_status
	merc_data["mob"] = user // Update mob reference
	to_chat(user, span_notice("I set my status to: <b>[new_status]</b>"))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/talkstatue/mercenary/proc/message_single_mercenary(mob/living/carbon/human/sender, obj/item/roguecoin/silver/coin)
	// Check sender cooldown
	if(sender_cooldowns[sender.key])
		var/time_left = sender_cooldowns[sender.key] + sender_cooldown - world.time
		if(time_left > 0)
			to_chat(sender, span_warning("I need to wait [round(time_left / 10)] seconds before sending another message."))
			return

	// Get list of available mercenaries from the status list
	var/list/available_mercenaries = list()

	for(var/merc_key in mercenary_status)
		var/list/merc_data = mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]

		// Validate the mercenary is still valid
		if(!merc || merc.stat == DEAD)
			continue
		if(merc_data["status"] == "Do not Disturb")
			continue

		var/status_text = merc_data["status"] || "Available"
		var/display_name = "[merc.real_name] ([status_text])"
		available_mercenaries[display_name] = merc

	if(!available_mercenaries.len)
		to_chat(sender, span_warning("There are no mercenaries currently available."))
		return

	var/choice = input(sender, "Which mercenary do I wish to contact?", "Mercenary Contact") as null|anything in available_mercenaries
	if(!choice)
		return

	var/mob/living/carbon/human/target_merc = available_mercenaries[choice]

	// Proximity check again before allowing message input
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I need to stay close to the statue."))
		return

	var/message = stripped_input(sender, "What message do I wish to send? (Max [message_char_limit] characters)", "Mercenary Contact", "", message_char_limit)
	if(!message)
		return

	// Final proximity and coin checks
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I moved too far from the statue."))
		return

	if(!(coin in sender.held_items))
		to_chat(sender, span_warning("I need to hold the ziliqua!"))
		return

	// Consume the coin
	qdel(coin)
	playsound(loc, 'sound/foley/coinphy (1).ogg', 100, FALSE, -1)

	// Set sender cooldown
	sender_cooldowns[sender.key] = world.time

	// Send the message with time-limited response links
	response_id_counter++
	var/response_id = "[target_merc.key]_[world.time]_[response_id_counter]"
	if(!QDELETED(target_merc) && !QDELETED(sender))
		pending_direct_responses[response_id] = list("responder" = target_merc, "sender" = sender)
		addtimer(CALLBACK(src, PROC_REF(expire_direct_response), response_id), response_timeout)

	to_chat(target_merc, span_boldnotice("The mercenary statue whispers in my mind: <i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];direct_response=yae;response_id=[response_id]'>\[YAE\]</a> | <a href='?src=[REF(src)];direct_response=nae;response_id=[response_id]'>\[NAE\]</a>"))
	to_chat(sender, span_notice("My message has been sent to [target_merc.real_name]."))
	playsound(target_merc.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

	// Admin logging - log on both sender and recipient like mindlink does
	sender.log_talk(message, LOG_SAY, tag="mercenary statue (to [key_name(target_merc)])")
	target_merc.log_talk(message, LOG_SAY, tag="mercenary statue (from [key_name(sender)])", log_globally=FALSE)

/obj/structure/roguemachine/talkstatue/mercenary/proc/broadcast_to_mercenaries(mob/living/carbon/human/sender, obj/item/roguecoin/gold/coin)
	// Check sender cooldown
	if(sender_cooldowns[sender.key])
		var/time_left = sender_cooldowns[sender.key] + sender_cooldown - world.time
		if(time_left > 0)
			to_chat(sender, span_warning("I need to wait [round(time_left / 10)] seconds before sending another message."))
			return

	// Proximity check before allowing message input
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I need to stay close to the statue."))
		return

	// Build list of valid recipients in a single pass
	var/list/valid_recipients = list()
	for(var/merc_key in mercenary_status)
		var/list/merc_data = mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]

		if(!merc || merc.stat == DEAD)
			continue
		// Skip Do not Disturb mercenaries
		if(merc_data["status"] == "Do not Disturb")
			continue

		valid_recipients += merc

	if(valid_recipients.len == 0)
		to_chat(sender, span_warning("There are no mercenaries available to broadcast to."))
		return

	var/message = stripped_input(sender, "What message do I wish to broadcast to all mercenaries? (Max [message_char_limit] characters)", "Mercenary Broadcast", "", message_char_limit)
	if(!message)
		return

	// Final proximity and coin checks
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I moved too far from the statue."))
		return

	if(!(coin in sender.held_items))
		to_chat(sender, span_warning("I need to hold the zenar!"))
		return

	// Consume the coin
	qdel(coin)
	playsound(loc, 'sound/foley/coinphy (1).ogg', 100, FALSE, -1)

	// Set sender cooldown
	sender_cooldowns[sender.key] = world.time

	// Build recipient keys list for logging
	var/list/recipient_keys = list()
	for(var/mob/living/carbon/human/merc in valid_recipients)
		recipient_keys += key_name(merc)

	// Broadcast the message to all valid recipients
	for(var/mob/living/carbon/human/merc in valid_recipients)
		// Create unique response ID for this recipient
		response_id_counter++
		var/response_id = "[merc.key]_[world.time]_[response_id_counter]"
		if(!QDELETED(merc) && !QDELETED(sender))
			pending_broadcast_responses[response_id] = list("responder" = merc, "sender" = sender)
			addtimer(CALLBACK(src, PROC_REF(expire_broadcast_response), response_id), response_timeout)

		to_chat(merc, span_boldannounce("The mercenary statue calls out: <i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];broadcast_interest=[response_id]'>\[Signal Interest\]</a>"))
		playsound(merc.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

	var/merc_count = valid_recipients.len
	to_chat(sender, span_notice("My message has been broadcast to [merc_count] mercenary[merc_count == 1 ? "" : "s"]."))
	src.bark(1)

	// Admin logging for broadcast - log on sender with all recipients
	sender.log_talk(message, LOG_SAY, tag="mercenary statue broadcast (to [recipient_keys.Join(", ")])")

/obj/structure/roguemachine/talkstatue/mercenary/proc/cull_invalid_mercenaries()
	// Remove mercenaries whose mob references are invalid (logged out, far traveled, etc.)
	var/list/keys_to_remove = list()

	for(var/merc_key in mercenary_status)
		var/list/merc_data = mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]

		// Check if mob is invalid (deleted, null, or client disconnected and not coming back)
		if(QDELETED(merc) || !merc.ckey)
			keys_to_remove += merc_key

	// Remove all invalid entries
	for(var/key in keys_to_remove)
		mercenary_status -= key

/obj/structure/roguemachine/talkstatue/mercenary/proc/generate_roster_html(mob/living/carbon/human/user = null, is_mercenary = FALSE, is_interactive = TRUE)
	// Unified roster HTML generation
	// user: The viewing user (can be null for non-interactive displays)
	// is_mercenary: Whether the user is a mercenary (only relevant if interactive)
	// is_interactive: Whether to show interactive elements (status change, edit message, etc.)

	var/contents = ""
	contents += "<center><b>MERCENARY ROSTER</b></center>"
	contents += "<hr>"

	if(!is_interactive)
		contents += "<center><i>Information guaranteed current via carrier zad, or your mammon back.</i></center><br>"

	if(is_interactive && is_mercenary && user)
		// Show current status and cycle button for mercenaries
		var/list/merc_data = mercenary_status[user.key]
		var/current_status = merc_data ? merc_data["status"] : null
		var/status_display = current_status || "Not Registered"
		var/custom_message = merc_data ? merc_data["message"] : ""

		contents += "<center>"
		contents += "Your current status: <b>[status_display]</b><br>"
		contents += "<a href='?src=[REF(src)];cycle_status=1'>\[Change Status\]</a> | "
		contents += "<a href='?src=[REF(src)];edit_message=1'>\[Edit Message\]</a><br>"
		if(custom_message)
			contents += "<i>\"[custom_message]\"</i>"
		else
			contents += "<i>No custom message set</i>"
		contents += "</center><hr>"

	// Display list of mercenaries
	contents += "<b>Registered Mercenaries:</b><br>"

	if(!mercenary_status.len)
		contents += "<i>No mercenaries have registered yet.</i><br>"
	else
		var/merc_count = 0
		var/available_count = 0
		var/contracted_count = 0
		var/dnd_count = 0

		// Sort mercenaries by status
		var/list/available_mercs = list()
		var/list/contracted_mercs = list()
		var/list/dnd_mercs = list()

		for(var/merc_key in mercenary_status)
			var/list/merc_data = mercenary_status[merc_key]
			var/mob/living/carbon/human/merc = merc_data["mob"]

			if(!merc)
				continue

			merc_count++
			var/status = merc_data["status"] || "Available"
			var/custom_msg = merc_data["message"] || ""
			var/advjob_title = merc.advjob || "Mercenary"

			var/list/merc_info = list("name" = merc.real_name, "status" = status, "message" = custom_msg, "advjob" = advjob_title)
			switch(status)
				if("Available")
					available_count++
					available_mercs += list(merc_info)
				if("Contracted")
					contracted_count++
					contracted_mercs += list(merc_info)
				if("Do not Disturb")
					dnd_count++
					dnd_mercs += list(merc_info)

		// Summary counts
		contents += "<br><center>"
		contents += "Total: <b>[merc_count]</b> | "
		contents += "<span style='color:green;'>Available: [available_count]</span> | "
		contents += "<span style='color:orange;'>Contracted: [contracted_count]</span> | "
		contents += "<span style='color:red;'>DND: [dnd_count]</span>"
		contents += "</center><br><hr>"

		// Display Available mercenaries
		if(available_mercs.len)
			contents += "<b><span style='color:green;'>Available for Contract:</span></b><br>"
			for(var/list/merc_info in available_mercs)
				contents += "  <b>-</b> [merc_info["name"]] <span style='color:#888;'>([merc_info["advjob"]])</span><br>"
				if(merc_info["message"])
					contents += "    <i>\"[merc_info["message"]]\"</i><br>"
			contents += "<br>"

		// Display Contracted mercenaries
		if(contracted_mercs.len)
			contents += "<b><span style='color:orange;'>Currently Contracted:</span></b><br>"
			for(var/list/merc_info in contracted_mercs)
				contents += "  <b>-</b> [merc_info["name"]] <span style='color:#888;'>([merc_info["advjob"]])</span><br>"
				if(merc_info["message"])
					contents += "    <i>\"[merc_info["message"]]\"</i><br>"
			contents += "<br>"

		// Display Do not Disturb mercenaries
		if(dnd_mercs.len)
			contents += "<b><span style='color:red;'>Do Not Disturb:</span></b><br>"
			for(var/list/merc_info in dnd_mercs)
				contents += "  <b>-</b> [merc_info["name"]] <span style='color:#888;'>([merc_info["advjob"]])</span><br>"
				if(merc_info["message"])
					contents += "    <i>\"[merc_info["message"]]\"</i><br>"

	contents += "<hr>"
	if(is_interactive)
		contents += "<center><i>Silver for one, Gold for all.</i></center>"
	else
		contents += "<center><i>Visit the Mercenary Statue for further contact.</i><br>"
		contents += "<i>Silver for one, Gold for all.</i></center>"

	return contents

/obj/structure/roguemachine/talkstatue/mercenary/proc/show_mercenary_ui(mob/living/carbon/human/user, is_mercenary = FALSE)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	// Generate roster HTML using unified proc
	var/contents = generate_roster_html(user, is_mercenary, is_interactive = TRUE)

	var/datum/browser/popup = new(user, "MERCSTATUE", "", 400, 500)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/talkstatue/mercenary/Topic(href, href_list)
	. = ..()

	if(href_list["cycle_status"])
		// Verify user is a mercenary and close to the statue
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/H = usr
		if(!H.mind || H.mind.assigned_role != "Mercenary")
			to_chat(H, span_warning("I am not a mercenary."))
			return

		// Proximity check - must be adjacent to the statue
		if(!Adjacent(H))
			to_chat(H, span_warning("I need to be closer to the statue."))
			return

		// Cycle their status
		cycle_mercenary_status(H)

		// Refresh the UI
		show_mercenary_ui(H, is_mercenary = TRUE)
		return

	if(href_list["edit_message"])
		// Verify user is a mercenary
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/H = usr
		if(!H.mind || H.mind.assigned_role != "Mercenary")
			to_chat(H, span_warning("I am not a mercenary."))
			return

		// Proximity check - must be adjacent to the statue
		if(!Adjacent(H))
			to_chat(H, span_warning("I need to be closer to the statue."))
			return

		// Get or create their data
		var/list/merc_data = mercenary_status[H.key]
		if(!merc_data)
			merc_data = list("status" = "Available", "mob" = H, "message" = "")
			mercenary_status[H.key] = merc_data

		// Prompt for custom message
		var/current_msg = merc_data["message"] || ""
		var/new_msg = stripped_input(H, "Enter my custom message (max 300 characters):", "Mercenary Message", current_msg, 300)

		if(new_msg != null) // Allow empty string to clear message
			if(!Adjacent(H))
				to_chat(H, span_warning("I need to remain closer to the statue."))
				return
			merc_data["message"] = new_msg
			to_chat(H, span_notice("My mercenary message has been updated."))
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		// Refresh the UI
		show_mercenary_ui(H, is_mercenary = TRUE)
		return

	if(href_list["register"])
		var/mob/living/carbon/human/H = locate(href_list["register"])
		if(!H)
			return

		// Verify the user is still valid and pending
		if(!pending_registrations[H.key])
			to_chat(usr, span_warning("That registration link has expired."))
			return

		if(H.mind?.assigned_role != "Mercenary")
			to_chat(usr, span_warning("I am no longer a mercenary."))
			pending_registrations -= H.key
			return

		if(!H.mind)
			return

		// Check if they've selected their advclass yet - fail safe if not
		if(!H.advjob)
			to_chat(H, span_warning("I need to select my mercenary class before registering with the statue."))
			// Keep them in pending_registrations so they can try again
			return

		// Register the mercenary remotely
		var/list/merc_data = list("status" = "Available", "mob" = H, "message" = "")
		mercenary_status[H.key] = merc_data

		// Remove from pending
		pending_registrations -= H.key

		to_chat(H, span_boldnotice("I have registered with the Mercenary Guild! I am now listed as <b>Available</b>."))
		to_chat(H, span_notice("I can visit the statue in person to change my status, or <a href='?src=[REF(src)];set_message_remote=[REF(H)]'>recall my mercenary message</a> from afar. (This link expires in 2 minutes)"))
		playsound(H.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

		// Store the message link with a timer (check if player is still valid)
		if(!QDELETED(H))
			pending_message_links[H.key] = H
			addtimer(CALLBACK(src, PROC_REF(expire_message_link), H.key), 2 MINUTES)
		return

	if(href_list["set_message_remote"])
		var/mob/living/carbon/human/H = locate(href_list["set_message_remote"])
		if(!H)
			return

		// Verify the user clicking is the intended recipient
		if(usr != H)
			to_chat(usr, span_warning("That link is not for me."))
			return

		// Check if the link has expired
		if(!pending_message_links[H.key])
			to_chat(usr, span_warning("That message link has expired."))
			return

		// Verify they're a registered mercenary
		if(!mercenary_status[H.key])
			to_chat(usr, span_warning("I am not registered with the mercenary statue network."))
			pending_message_links -= H.key
			return

		if(H.mind?.assigned_role != "Mercenary")
			to_chat(usr, span_warning("I am no longer a mercenary."))
			pending_message_links -= H.key
			return

		// Get their current data
		var/list/merc_data = mercenary_status[H.key]
		var/current_msg = merc_data["message"] || ""

		// Prompt for new message
		var/new_msg = stripped_input(H, "Enter my mercenary message (max 300 characters):", "Mercenary Message", current_msg, 300)

		if(new_msg != null) // Allow empty string to clear message
			merc_data["message"] = new_msg
			to_chat(H, span_notice("My message has been recalled by the statue. I must visit it to make further changes."))
			playsound(H.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		// Remove from pending after use
		pending_message_links -= H.key
		return

	if(href_list["broadcast_interest"])
		// Handle broadcast interest response
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_id = href_list["broadcast_interest"]

		// Check if response ID is valid and hasn't expired
		if(!pending_broadcast_responses[response_id])
			to_chat(responder, span_warning("That response link has expired or already been used."))
			return

		var/list/response_data = pending_broadcast_responses[response_id]
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		// Verify the person clicking is the intended responder
		if(responder != stored_responder)
			to_chat(responder, span_warning("That response link is not for me."))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("The sender is no longer available."))
			pending_broadcast_responses -= response_id
			return

		// Verify responder is a mercenary
		if(!responder.mind || responder.mind.assigned_role != "Mercenary")
			to_chat(responder, span_warning("I am not a mercenary."))
			return

		// Consume the response token (single use)
		pending_broadcast_responses -= response_id

		// Send interest notification to sender
		to_chat(sender, span_notice("[responder.real_name] signaled [responder.p_their()] interest in my missive."))
		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

		// Confirm to responder
		to_chat(responder, span_notice("I signaled my interest to [sender.real_name]."))
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		// Admin logging
		responder.log_talk("signaled interest", LOG_SAY, tag="mercenary statue broadcast response (to [key_name(sender)])")
		return

	if(href_list["direct_response"])
		// Handle direct message response (YAE/NAE)
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_type = href_list["direct_response"]
		var/response_id = href_list["response_id"]

		// Check if response ID is valid and hasn't expired
		if(!pending_direct_responses[response_id])
			to_chat(responder, span_warning("That response link has expired or already been used."))
			return

		var/list/response_data = pending_direct_responses[response_id]
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		// Verify the person clicking is the intended responder
		if(responder != stored_responder)
			to_chat(responder, span_warning("That response link is not for me."))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("The sender is no longer available."))
			pending_direct_responses -= response_id
			return

		// Verify responder is a mercenary
		if(!responder.mind || responder.mind.assigned_role != "Mercenary")
			to_chat(responder, span_warning("I am not a mercenary."))
			return

		// Consume the response token (single use)
		pending_direct_responses -= response_id

		// Send response to sender
		if(response_type == "yae")
			to_chat(sender, span_notice("[responder.real_name] responded in affirmation to my message."))
			to_chat(responder, span_notice("I responded in affirmation to [sender.real_name]."))
		else // nae
			to_chat(sender, span_notice("[responder.real_name] responded negatively to my message."))
			to_chat(responder, span_notice("I responded negatively to [sender.real_name]."))

		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		// Admin logging
		responder.log_talk("direct response: [response_type]", LOG_SAY, tag="mercenary statue direct response (to [key_name(sender)])")
		return

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_registration(key)
	if(pending_registrations[key])
		pending_registrations -= key

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_message_link(key)
	if(pending_message_links[key])
		pending_message_links -= key

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_broadcast_response(response_id)
	if(pending_broadcast_responses[response_id])
		pending_broadcast_responses -= response_id

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_direct_response(response_id)
	if(pending_direct_responses[response_id])
		pending_direct_responses -= response_id

/obj/structure/roguemachine/talkstatue/mercenary/proc/get_readonly_roster_html()
	// Read-only roster display for noticeboards
	// Cull invalid mercenaries first
	cull_invalid_mercenaries()

	// Generate roster HTML using unified proc in non-interactive mode
	return generate_roster_html(user = null, is_mercenary = FALSE, is_interactive = FALSE)

/obj/structure/roguemachine/talkstatue/mercenary/proc/bark(var/mode)
	if(mode == 1) //Wide broadcast
		var/random = rand(1,4)
		switch(random)
			if(1)
				say("They heard it! Can't guarantee anything else.")
			if(2)
				say("Maybe you'll get a good deal in negotiations.")
			if(3)
				say("So, you goin' to kill somebody? Hee-haw! I'm jestin'.")
			if(4)
				say("What ye end up doin' with your gold is your business.")


/obj/structure/roguemachine/talkstatue/church
	name = "church statue"
	desc = "A blessed stone statue radiating divine presence."
	icon_state = "goldvendor" //TODO: Get proper sprite

/obj/structure/roguemachine/talkstatue/church/Initialize()
	. = ..()
	if(SSroguemachine.church_statue == null) // Only one mapped church statue
		SSroguemachine.church_statue = src

//Code goes here
