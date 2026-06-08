/obj/structure/roguemachine/talkstatue/mercenary/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/talkstatue/mercenary/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/talkstatue/mercenary/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Talkstatue", name)
		ui.open()

/obj/structure/roguemachine/talkstatue/mercenary/proc/set_role_status(mob/living/carbon/human/user, list/registry, list/states, default_state, new_status)
	if(!(new_status in states))
		return
	var/list/data = registry[user.real_name]
	if(!data)
		data = list("status" = default_state, "mob" = user, "message" = "")
		registry[user.real_name] = data
	data["status"] = new_status
	data["mob"] = user
	to_chat(user, span_notice("I set my status to: <b>[new_status]</b>"))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	log_admin_private("[key_name(user)] set statue status to [new_status]")

/obj/structure/roguemachine/talkstatue/mercenary/proc/edit_role_message(mob/living/carbon/human/user, list/registry, default_state)
	var/list/data = registry[user.real_name]
	if(!data)
		data = list("status" = default_state, "mob" = user, "message" = "")
		registry[user.real_name] = data
	var/current_msg = data["message"] || ""
	var/new_msg = stripped_input(user, "Enter my custom message (max [message_char_limit] characters):", "Statue Message", current_msg, message_char_limit)
	if(new_msg == null)
		return
	if(!Adjacent(user))
		to_chat(user, span_warning("I moved too far from the statue."))
		return
	data["message"] = new_msg
	to_chat(user, span_notice("My statue message has been updated."))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	log_admin_private("[key_name(user)] set statue custom message: \"[new_msg]\"")

/obj/structure/roguemachine/talkstatue/mercenary/proc/edit_wretch_nom_de_guerre(mob/living/carbon/human/user)
	var/list/data = wretch_status[user.real_name]
	if(!data)
		data = list("status" = "Available", "mob" = user, "message" = "", "nom_de_guerre" = "")
		wretch_status[user.real_name] = data
	var/current = data["nom_de_guerre"] || ""
	var/new_nom = stripped_input(user, "Choose my nom de guerre (max 60 characters). Empty to clear.", "Nom de Guerre", current, 60)
	if(new_nom == null)
		return
	if(!Adjacent(user))
		to_chat(user, span_warning("I moved too far from the statue."))
		return
	data["nom_de_guerre"] = new_nom
	to_chat(user, span_notice("My nom de guerre is set to: <b>[new_nom ? new_nom : "(real name)"]</b>"))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	log_admin_private("[key_name(user)] set wretch nom de guerre: \"[new_nom]\"")

/obj/structure/roguemachine/talkstatue/mercenary/proc/leave_roster(mob/living/carbon/human/user, list/registry)
	if(!registry[user.real_name])
		to_chat(user, span_warning("I am not listed here."))
		return
	registry -= user.real_name
	to_chat(user, span_notice("I have taken myself off the roster."))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	log_admin_private("[key_name(user)] removed self from statue roster")

/obj/structure/roguemachine/talkstatue/mercenary/proc/message_single_adventurer(mob/living/carbon/human/sender, target_key)
	if(!target_key)
		var/list/picker = list()
		for(var/name_key in adventurer_status)
			var/list/d = adventurer_status[name_key]
			var/mob/living/carbon/human/adv = d["mob"]
			if(!adv || adv.stat == DEAD)
				continue
			if(d["status"] == "Do not Disturb")
				continue
			var/status_text = d["status"] || "Available"
			picker["[adv.real_name] ([status_text])"] = adv.real_name
		if(!picker.len)
			to_chat(sender, span_warning("There are no adventurers currently available."))
			return
		var/choice = input(sender, "Which adventurer do I wish to contact?", "Adventurer Contact") as null|anything in picker
		if(!choice)
			return
		target_key = picker[choice]
	var/list/data = adventurer_status[target_key]
	if(!data)
		to_chat(sender, span_warning("My message cannot be delivered for some reason."))
		return
	var/mob/living/carbon/human/target = data["mob"]
	if(!target || QDELETED(target) || target.stat == DEAD || !target.ckey)
		adventurer_status -= target_key
		to_chat(sender, span_warning("My message cannot be delivered for some reason."))
		return
	if(data["status"] == "Do not Disturb")
		to_chat(sender, span_warning("My message cannot be delivered for some reason."))
		return
	var/cooldown_key = "adv_[sender.real_name]_[target.real_name]"
	if(sender_cooldowns[cooldown_key])
		var/time_left = sender_cooldowns[cooldown_key] + single_cooldown - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("I need to wait [mins_left] minute[mins_left == 1 ? "" : "s"] before contacting [target.real_name] again."))
			return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I need to stay close to the statue."))
		return
	var/message = stripped_input(sender, "What message do I wish to send? (Max [message_char_limit] characters)", "Adventurer Contact", "", message_char_limit)
	if(!message)
		return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I moved too far from the statue."))
		return
	sender_cooldowns[cooldown_key] = world.time
	response_id_counter++
	var/response_id = "adv_[target.real_name]_[world.time]_[response_id_counter]"
	if(!QDELETED(target) && !QDELETED(sender))
		pending_direct_responses[response_id] = list("responder" = target, "sender" = sender)
		addtimer(CALLBACK(src, PROC_REF(expire_direct_response), response_id), response_timeout)
	to_chat(target, span_boldnotice("The statue whispers in my mind: <i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];direct_response=yae;response_id=[response_id]'>\[YAE\]</a> | <a href='?src=[REF(src)];direct_response=nae;response_id=[response_id]'>\[NAE\]</a>"))
	to_chat(sender, span_notice("My message has been sent to [target.real_name]."))
	playsound(target.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
	sender.log_talk(message, LOG_SAY, tag="adventurer statue (to [key_name(target)])")
	target.log_talk(message, LOG_SAY, tag="adventurer statue (from [key_name(sender)])", log_globally=FALSE)

/obj/structure/roguemachine/talkstatue/mercenary/proc/message_single_wretch(mob/living/carbon/human/sender, target_key)
	var/role = role_title(sender)
	if(role != "Bathmaster" && role != "Bathhouse Attendant")
		to_chat(sender, span_warning("Only the bathhouse may reach a wretch through this statue."))
		return
	if(!target_key)
		var/list/picker = list()
		for(var/name_key in wretch_status)
			var/list/d = wretch_status[name_key]
			var/mob/living/carbon/human/w = d["mob"]
			if(!w || w.stat == DEAD)
				continue
			if(d["status"] == "Do not Disturb")
				continue
			var/display = d["nom_de_guerre"] || w.real_name
			var/status_text = d["status"] || "Available"
			picker["[display] ([status_text])"] = w.real_name
		if(!picker.len)
			to_chat(sender, span_warning("There are no wretches currently available."))
			return
		var/choice = input(sender, "Which wretch do I wish to contact?", "Wretch Contact") as null|anything in picker
		if(!choice)
			return
		target_key = picker[choice]
	var/list/data = wretch_status[target_key]
	if(!data)
		to_chat(sender, span_warning("My message cannot be delivered for some reason."))
		return
	var/mob/living/carbon/human/target = data["mob"]
	if(!target || QDELETED(target) || target.stat == DEAD || !target.ckey)
		wretch_status -= target_key
		to_chat(sender, span_warning("My message cannot be delivered for some reason."))
		return
	if(data["status"] == "Do not Disturb")
		to_chat(sender, span_warning("My message cannot be delivered for some reason."))
		return
	var/display = data["nom_de_guerre"] || target.real_name
	var/cooldown_key = "wretch_[sender.real_name]_[target.real_name]"
	if(sender_cooldowns[cooldown_key])
		var/time_left = sender_cooldowns[cooldown_key] + single_cooldown - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("I need to wait [mins_left] minute[mins_left == 1 ? "" : "s"] before contacting [display] again."))
			return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I need to stay close to the statue."))
		return
	var/message = stripped_input(sender, "What message do I wish to send? (Max [message_char_limit] characters)", "Wretch Contact", "", message_char_limit)
	if(!message)
		return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("I moved too far from the statue."))
		return
	sender_cooldowns[cooldown_key] = world.time
	response_id_counter++
	var/response_id = "wretch_[target.real_name]_[world.time]_[response_id_counter]"
	if(!QDELETED(target) && !QDELETED(sender))
		pending_direct_responses[response_id] = list("responder" = target, "sender" = sender)
		addtimer(CALLBACK(src, PROC_REF(expire_direct_response), response_id), response_timeout)
	to_chat(target, span_boldnotice("The Bathmaster's whisper reaches me through the statue: <i>[message]</i><br><a href='?src=[REF(src)];direct_response=yae;response_id=[response_id]'>\[YAE\]</a> | <a href='?src=[REF(src)];direct_response=nae;response_id=[response_id]'>\[NAE\]</a>"))
	to_chat(sender, span_notice("My message has been sent to [display]."))
	playsound(target.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
	sender.log_talk(message, LOG_SAY, tag="wretch statue (to [key_name(target)])")
	target.log_talk(message, LOG_SAY, tag="wretch statue (from [key_name(sender)])", log_globally=FALSE)

/obj/structure/roguemachine/talkstatue/mercenary/proc/role_title(mob/M)
	if(!M || !M.mind)
		return ""
	var/r = M.mind.assigned_role
	if(istype(r, /datum/job))
		var/datum/job/J = r
		return J.title
	return "[r]"

/obj/structure/roguemachine/talkstatue/mercenary/proc/role_matches(mob/M, target)
	if(role_title(M) == target)
		return TRUE
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(!H.migrant_type)
		return FALSE
	var/datum/migrant_role/role = MIGRANT_ROLE(H.migrant_type)
	return role?.role_category == target

/obj/structure/roguemachine/talkstatue/mercenary/ui_data(mob/user)
	var/list/data = list()
	var/user_role = ishuman(user) ? role_title(user) : ""
	var/is_merc = ishuman(user) && role_matches(user, "Mercenary")
	var/is_adv = ishuman(user) && role_matches(user, "Adventurer")
	var/is_wretch = user_role == "Wretch"
	var/is_bathhouse = (user_role == "Bathmaster") || (user_role == "Bathhouse Attendant")
	data["is_merc"] = is_merc ? TRUE : FALSE
	data["is_adventurer"] = is_adv ? TRUE : FALSE
	data["is_wretch"] = is_wretch ? TRUE : FALSE
	data["is_bathhouse"] = is_bathhouse ? TRUE : FALSE
	var/mob/living/carbon/human/HU = user
	data["my_key"] = ishuman(user) ? HU.real_name : ""
	data["message_char_limit"] = message_char_limit

	data["merc_status_options"] = list("Available", "Contracted", "Do not Disturb")
	data["adv_status_options"] = list("Available", "Away", "Resting", "Do not Disturb")
	data["wretch_status_options"] = list("Available", "On a Job", "Lying Low", "Do not Disturb")
	data["mercenaries"] = roster_payload(mercenary_status, FALSE)
	data["adventurers"] = roster_payload(adventurer_status, FALSE)
	if(is_wretch || is_bathhouse)
		data["wretches"] = roster_payload(wretch_status, TRUE)
	else
		data["wretches"] = list()
	return data

/obj/structure/roguemachine/talkstatue/mercenary/proc/roster_payload(list/registry, use_nom)
	var/list/out = list()
	for(var/key in registry)
		var/list/d = registry[key]
		var/mob/living/carbon/human/M = d["mob"]
		if(!M)
			continue
		var/display_name = M.real_name
		if(use_nom && d["nom_de_guerre"])
			display_name = d["nom_de_guerre"]
		out += list(list(
			"key" = key,
			"name" = display_name,
			"status" = d["status"] || "Available",
			"message" = d["message"] || "",
			"advjob" = M.advjob || "",
			"nom_de_guerre" = d["nom_de_guerre"] || "",
		))
	return out

/obj/structure/roguemachine/talkstatue/mercenary/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!Adjacent(H))
		to_chat(H, span_warning("I need to be closer to the statue."))
		return
	var/user_role = role_title(H)
	var/is_merc = role_matches(H, "Mercenary")
	var/is_adv = role_matches(H, "Adventurer")
	var/is_wretch = user_role == "Wretch"
	var/is_bathhouse = (user_role == "Bathmaster") || (user_role == "Bathhouse Attendant")
	switch(action)
		if("set_merc_status")
			if(!is_merc)
				return
			set_role_status(H, mercenary_status, list("Available", "Contracted", "Do not Disturb"), "Available", params["status"])
			return TRUE
		if("edit_merc_message")
			if(!is_merc)
				return
			edit_role_message(H, mercenary_status, "Available")
			return TRUE
		if("contact_merc")
			message_single_mercenary(H)
			return TRUE
		if("broadcast_mercs")
			broadcast_to_mercenaries(H)
			return TRUE
		if("set_adv_status")
			if(!is_adv)
				return
			set_role_status(H, adventurer_status, list("Available", "Away", "Resting", "Do not Disturb"), "Available", params["status"])
			return TRUE
		if("edit_adv_message")
			if(!is_adv)
				return
			edit_role_message(H, adventurer_status, "Available")
			return TRUE
		if("leave_adv")
			if(!is_adv)
				return
			leave_roster(H, adventurer_status)
			return TRUE
		if("contact_adventurer")
			message_single_adventurer(H, params["key"])
			return TRUE
		if("pick_adventurer")
			message_single_adventurer(H, null)
			return TRUE
		if("set_wretch_status")
			if(!is_wretch)
				return
			set_role_status(H, wretch_status, list("Available", "On a Job", "Lying Low", "Do not Disturb"), "Available", params["status"])
			return TRUE
		if("edit_wretch_message")
			if(!is_wretch)
				return
			edit_role_message(H, wretch_status, "Available")
			return TRUE
		if("edit_wretch_nom")
			if(!is_wretch)
				return
			edit_wretch_nom_de_guerre(H)
			return TRUE
		if("contact_wretch")
			if(!is_bathhouse)
				return
			message_single_wretch(H, params["key"])
			return TRUE
		if("pick_wretch")
			if(!is_bathhouse)
				return
			message_single_wretch(H, null)
			return TRUE
