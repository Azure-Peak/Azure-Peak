/obj/structure/roguemachine/talkstatue/mercenary/Initialize()
	. = ..()
	if(SSroguemachine.mercenary_statue == null)
		SSroguemachine.mercenary_statue = src
	SSroguemachine.mercenary_statues |= src

/obj/structure/roguemachine/talkstatue/mercenary/proc/cycle_mercenary_status(mob/living/carbon/human/user)
	var/list/merc_data = mercenary_status[user.real_name]
	var/first_time = FALSE
	if(!merc_data)
		first_time = TRUE
		merc_data = list("status" = "Available", "mob" = user, "message" = "")
		mercenary_status[user.real_name] = merc_data

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
	merc_data["mob"] = user
	to_chat(user, span_notice("I set my status to: <b>[new_status]</b>"))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	log_admin_private("[key_name(user)] set mercenary statue status to [new_status]")

/obj/structure/roguemachine/talkstatue/mercenary/proc/message_single_mercenary(mob/living/carbon/human/sender)
	var/list/available_mercenaries = list()
	var/list/stale_keys = list()

	for(var/merc_key in mercenary_status)
		var/list/merc_data = mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]

		if(!merc || QDELETED(merc))
			stale_keys += merc_key
			continue
		if(merc.stat == DEAD)
			continue
		if(merc_data["status"] == "Do not Disturb")
			continue

		var/status_text = merc_data["status"] || "Available"
		var/display_name = "[merc.real_name] ([status_text])"
		available_mercenaries[display_name] = merc

	for(var/key in stale_keys)
		mercenary_status -= key

	if(!available_mercenaries.len)
		to_chat(sender, span_warning("There are no mercenaries currently available."))
		return

	var/choice = input(sender, "Which mercenary do I wish to contact?", "Mercenary Contact") as null|anything in available_mercenaries
	if(!choice)
		return

	var/mob/living/carbon/human/target_merc = available_mercenaries[choice]

	var/cooldown_key = "[sender.real_name]_[target_merc.real_name]"
	if(sender_cooldowns[cooldown_key])
		var/time_left = sender_cooldowns[cooldown_key] + single_cooldown - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("I need to wait [mins_left] minute[mins_left == 1 ? "" : "s"] before contacting [target_merc.real_name] again."))
			return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("I need to stay close to the statue."))
		return

	var/message = stripped_input(sender, "What message do I wish to send? (Max [message_char_limit] characters)", "Mercenary Contact", "", message_char_limit)
	if(!message)
		return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("I moved too far from the statue."))
		return

	sender_cooldowns[cooldown_key] = world.time

	response_id_counter++
	var/response_id = "[target_merc.real_name]_[world.time]_[response_id_counter]"
	if(!QDELETED(target_merc) && !QDELETED(sender))
		pending_direct_responses[response_id] = list("responder" = target_merc, "sender" = sender)
		addtimer(CALLBACK(src, PROC_REF(expire_direct_response), response_id), response_timeout)

	to_chat(target_merc, span_boldnotice("The mercenary statue whispers in my mind: <i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];direct_response=yae;response_id=[response_id]'>\[YAE\]</a> | <a href='?src=[REF(src)];direct_response=nae;response_id=[response_id]'>\[NAE\]</a>"))
	to_chat(sender, span_notice("My message has been sent to [target_merc.real_name]."))
	playsound(target_merc.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

	sender.log_talk(message, LOG_SAY, tag="mercenary statue (to [key_name(target_merc)])")
	target_merc.log_talk(message, LOG_SAY, tag="mercenary statue (from [key_name(sender)])", log_globally=FALSE)

/obj/structure/roguemachine/talkstatue/mercenary/proc/broadcast_to_mercenaries(mob/living/carbon/human/sender)
	var/broadcast_key = "broadcast_[sender.real_name]"
	if(sender_cooldowns[broadcast_key])
		var/time_left = sender_cooldowns[broadcast_key] + broadcast_cooldown_time - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("I need to wait [mins_left] minute[mins_left == 1 ? "" : "s"] before broadcasting again."))
			return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("I need to stay close to the statue."))
		return

	var/list/valid_recipients = list()
	for(var/merc_key in mercenary_status)
		var/list/merc_data = mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]

		if(!merc || merc.stat == DEAD)
			continue
		if(merc_data["status"] == "Do not Disturb")
			continue

		valid_recipients += merc

	if(valid_recipients.len == 0)
		to_chat(sender, span_warning("There are no mercenaries available to broadcast to."))
		return

	var/message = stripped_input(sender, "What message do I wish to broadcast to all mercenaries? (Max [message_char_limit] characters)", "Mercenary Broadcast", "", message_char_limit)
	if(!message)
		return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("I moved too far from the statue."))
		return

	sender_cooldowns[broadcast_key] = world.time

	var/list/recipient_keys = list()
	for(var/mob/living/carbon/human/merc in valid_recipients)
		recipient_keys += key_name(merc)

	for(var/mob/living/carbon/human/merc in valid_recipients)
		response_id_counter++
		var/response_id = "[merc.real_name]_[world.time]_[response_id_counter]"
		if(!QDELETED(merc) && !QDELETED(sender))
			pending_broadcast_responses[response_id] = list("responder" = merc, "sender" = sender)
			addtimer(CALLBACK(src, PROC_REF(expire_broadcast_response), response_id), response_timeout)

		to_chat(merc, span_boldannounce("The mercenary statue calls out: <i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];broadcast_interest=[response_id]'>\[Signal Interest\]</a>"))
		playsound(merc.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

	var/merc_count = valid_recipients.len
	to_chat(sender, span_notice("My message has been broadcast to [merc_count] mercenary[merc_count == 1 ? "" : "s"]."))
	src.bark(1)

	sender.log_talk(message, LOG_SAY, tag="mercenary statue broadcast (to [recipient_keys.Join(", ")])")

/obj/structure/roguemachine/talkstatue/mercenary/Topic(href, href_list)
	. = ..()

	if(href_list["register"])
		var/mob/living/carbon/human/H = locate(href_list["register"])
		if(!H)
			return
		if(!pending_registrations[H.key])
			to_chat(usr, span_warning("That registration link has expired."))
			return
		if(H.mind?.assigned_role != "Mercenary")
			to_chat(usr, span_warning("I am no longer a mercenary."))
			pending_registrations -= H.key
			return
		if(!H.mind)
			return
		if(!H.advjob)
			to_chat(H, span_warning("I need to select my mercenary class before registering with the statue."))
			return

		var/list/merc_data = list("status" = "Available", "mob" = H, "message" = "")
		mercenary_status[H.real_name] = merc_data
		pending_registrations -= H.key

		to_chat(H, span_boldnotice("I have registered with the Mercenary Guild! I am now listed as <b>Available</b>."))
		to_chat(H, span_notice("I can visit the statue in person to change my status, or <a href='?src=[REF(src)];set_message_remote=[REF(H)]'>recall my mercenary message</a> from afar. (This link expires in 2 minutes)"))
		playsound(H.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

		if(!QDELETED(H))
			pending_message_links[H.key] = H
			addtimer(CALLBACK(src, PROC_REF(expire_message_link), H.key), 2 MINUTES)
		return

	if(href_list["set_message_remote"])
		var/mob/living/carbon/human/H = locate(href_list["set_message_remote"])
		if(!H)
			return
		if(usr != H)
			to_chat(usr, span_warning("That link is not for me."))
			return
		if(!pending_message_links[H.key])
			to_chat(usr, span_warning("That message link has expired."))
			return
		if(!mercenary_status[H.real_name])
			to_chat(usr, span_warning("I am not registered with the mercenary statue network."))
			pending_message_links -= H.key
			return
		if(H.mind?.assigned_role != "Mercenary")
			to_chat(usr, span_warning("I am no longer a mercenary."))
			pending_message_links -= H.key
			return

		var/list/merc_data = mercenary_status[H.real_name]
		var/current_msg = merc_data["message"] || ""
		var/new_msg = stripped_input(H, "Enter my mercenary message (max 300 characters):", "Mercenary Message", current_msg, 300)

		if(new_msg != null)
			merc_data["message"] = new_msg
			to_chat(H, span_notice("My message has been recalled by the statue. I must visit it to make further changes."))
			playsound(H.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		pending_message_links -= H.key
		return

	if(href_list["broadcast_interest"])
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_id = href_list["broadcast_interest"]

		if(!pending_broadcast_responses[response_id])
			to_chat(responder, span_warning("That response link has expired or already been used."))
			return

		var/list/response_data = pending_broadcast_responses[response_id]
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		if(responder != stored_responder)
			to_chat(responder, span_warning("That response link is not for me."))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("The sender is no longer available."))
			pending_broadcast_responses -= response_id
			return

		if(!responder.mind || responder.mind.assigned_role != "Mercenary")
			to_chat(responder, span_warning("I am not a mercenary."))
			return

		pending_broadcast_responses -= response_id

		to_chat(sender, span_notice("[responder.real_name] signaled [responder.p_their()] interest in my missive."))
		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

		to_chat(responder, span_notice("I signaled my interest to [sender.real_name]."))
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		responder.log_talk("signaled interest", LOG_SAY, tag="mercenary statue broadcast response (to [key_name(sender)])")
		return

	if(href_list["direct_response"])
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_type = href_list["direct_response"]
		var/response_id = href_list["response_id"]

		if(!pending_direct_responses[response_id])
			to_chat(responder, span_warning("That response link has expired or already been used."))
			return

		var/list/response_data = pending_direct_responses[response_id]
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		if(responder != stored_responder)
			to_chat(responder, span_warning("That response link is not for me."))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("The sender is no longer available."))
			pending_direct_responses -= response_id
			return

		pending_direct_responses -= response_id

		if(response_type == "yae")
			to_chat(sender, span_notice("[responder.real_name] responded in affirmation to my message."))
			to_chat(responder, span_notice("I responded in affirmation to [sender.real_name]."))
		else
			to_chat(sender, span_notice("[responder.real_name] responded negatively to my message."))
			to_chat(responder, span_notice("I responded negatively to [sender.real_name]."))

		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

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

/obj/structure/roguemachine/talkstatue/mercenary/proc/bark(var/mode)
	if(mode == 1)
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
