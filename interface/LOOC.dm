/datum/keybinding/looc
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("Y")
	name = "LOOC"
	full_name = "LOOC Chat"
	description = "Local OOC Chat."

/datum/keybinding/looc/down(client/user)
	user.get_looc()
	return TRUE

/client/proc/get_looc()
	var/msg = input(src, "", "looc") as text|null
	do_looc(msg, FALSE)
	

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	do_looc(msg, FALSE)

/client/verb/loocwp(msg as text)
	set name = "LOOC (Wall Pierce)"
	set desc = "Local OOC, seen by all in range."
	set category = "OOC"

	do_looc(msg, TRUE)

/client/verb/subtlelooc(msg as text)
	set name = "LOOC (Subtle)"
	set desc = "Local OOC only for a specific target or 1 tile range."
	set category = "OOC"
	do_subtlelooc(msg)

/client/proc/do_subtlelooc(msg as text)

	if(GLOB.say_disabled)
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(prefs.muted & MUTE_LOOC)
		to_chat(src, span_danger("I cannot use LOOC (temp muted)."))
		return

	if(is_banned_from(ckey, "LOOC"))
		to_chat(src, span_danger("I cannot use LOOC (perma muted)."))
		return

	if(isobserver(mob) && !holder)
		to_chat(src, span_danger("I cannot use LOOC while dead."))
		return

	if(!holder && istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("I cannot use LOOC while in the lobby. Join the round or observe first."))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("You have OOC muted."))
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in SLOOC: [msg]")
			return

	var/mob/S = mob
	var/s_name = S.name
	var/s_ckey = ckey
	var/pfx = "SLOOC"
	var/distance = 4
	var/list/hearers = get_hearers_in_view(distance, S)
	var/list/recipient_choices = list("1-Tile Range", "Same Tile")

	for(var/mob/living/L in hearers)
		if(L.stat == CONSCIOUS && L != S)
			if(!L.rogue_sneaking && L.name != "Unknown")
				recipient_choices += L

	var/recipient_choice = input(src, "Pick a target?", "Subtle Emote") in recipient_choices
	if(!recipient_choice)
		return

	mob.log_talk(msg, LOG_LOOC)

	var/recipient_label
	var/recipient_admin_label
	if(recipient_choice == "1-Tile Range")
		recipient_label = "1-Tile"
		recipient_admin_label = recipient_label
	else if(recipient_choice == "Same Tile")
		recipient_label = "Same Tile"
		recipient_admin_label = recipient_label
	else
		var/mob/target = recipient_choice
		recipient_label = target.name
		if(target.ckey)
			recipient_admin_label = "[recipient_label] ([target.ckey])"
		else
			recipient_admin_label = recipient_label

	var/admin_info = " ([s_ckey]) [ADMIN_FLW(S)] <A href='?_src_=holder;[HrefToken()];mute=[s_ckey];mute_type=[MUTE_LOOC]'><font color='[(prefs.muted & MUTE_LOOC) ? "red" : "blue"]'>\[MUTE\]</font></a>"
	var/prefix_text = span_prefix("[pfx]:")

	var/msg_reg = "<font color='#9DCCFF'><b>[prefix_text] <EM>[s_name] → [recipient_label]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_adm = "<font color='#9DCCFF'><b>[prefix_text] <EM>[s_name][admin_info] → [recipient_admin_label]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_rem = "<font color='#2F74A8'><b>(R) [prefix_text] <EM>[s_name][admin_info] → [recipient_admin_label]:</EM> <span class='message'>[msg]</span></b></font>"

	var/list/seen = list()

	if(recipient_choice == "1-Tile Range" || recipient_choice == "Same Tile")
		var/limit = (recipient_choice == "1-Tile Range") ? 1 : 0
		for(var/mob/M in hearers)
			if(get_dist(get_turf(M), get_turf(S)) > limit)
				continue
			var/client/C = M.client
			if(!C || !(C.prefs.chat_toggles & CHAT_OOC))
				continue

			seen[C] = TRUE
			var/outgoing_msg = ((C in GLOB.admins) && (C.prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(C, outgoing_msg, type = MESSAGE_TYPE_OOC)
	else
		var/mob/target = recipient_choice
		if(get_dist(get_turf(target), get_turf(S)) > distance)
			to_chat(src, span_boldwarning("The subtle LOOC target moved out of view, try again."))
			return
		var/client/target_client = target?.client
		if(target_client && (target_client.prefs.chat_toggles & CHAT_OOC))
			seen[target_client] = TRUE
			var/target_msg = ((target_client in GLOB.admins) && (target_client.prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(target_client, target_msg, type = MESSAGE_TYPE_OOC)

		if((prefs.chat_toggles & CHAT_OOC) && !(src in seen))
			seen[src] = TRUE
			var/self_msg = ((src in GLOB.admins) && (prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(src, self_msg, type = MESSAGE_TYPE_OOC)

	for(var/client/C in GLOB.admins)
		if(seen[C] || !(C.prefs.admin_chat_toggles & CHAT_ADMIN_SLOOC) || !(C.prefs.chat_toggles & CHAT_OOC))
			continue

		to_chat(C, msg_rem, type = MESSAGE_TYPE_OOC)

/client/proc/do_looc(msg as text, wp)

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(prefs.muted & MUTE_LOOC)
		to_chat(src, span_danger("I cannot use LOOC (temp muted)."))
		return

	if(is_banned_from(ckey, "LOOC"))
		to_chat(src, span_danger("I cannot use LOOC (perma muted)."))
		return
	
	if(isobserver(mob) && !holder)
		to_chat(src, span_danger("I cannot use LOOC while dead."))
		return

	// Lobby restriction: disable LOOC for normal players still in the lobby (new_player)
	if(!holder && istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("I cannot use LOOC while in the lobby. Join the round or observe first."))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	// If the LOOC message starts with @, route it to Subtle LOOC (SLOOC).
	if(copytext(msg, 1, 2) == "@")
		var/slooc_msg = copytext(msg, 2)
		if(length(slooc_msg) && copytext(slooc_msg, 1, 2) == " ")
			slooc_msg = copytext(slooc_msg, 2)
		do_subtlelooc(slooc_msg)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("You have OOC muted."))
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return


	//msg = emoji_parse(msg)

	var/prefix = ""

	mob.log_talk(msg, LOG_LOOC)

	if(wp == 0)
		prefix = "LOOC"
	else
		prefix = "LOOC (WP)"


	var/list/mobs = list()
	for(var/mob/M in GLOB.player_list)
		var/added_text
		var/is_admin = FALSE
		var/client/C = M.client
		if(!M.client)
			continue
		if((C in GLOB.admins) && (C.prefs.admin_chat_toggles & CHAT_ADMINLOOC))
			added_text += " ([mob.ckey]) [ADMIN_FLW(mob)]"
			is_admin = 1
		mobs += C
		if(C.prefs.chat_toggles & CHAT_OOC)
			var/turf/speakturf = get_turf(M)
			var/turf/sourceturf = get_turf(usr)
			if(wp == 1 && (M in range (7, src)))
				to_chat(C, "<font color='["#6699CC"]'><b><span class='prefix'>[prefix]:</span> <EM>[src.mob.name][added_text]:</EM> <span class='message'>[msg]</span></b></font>", type = MESSAGE_TYPE_OOC)
			else if(speakturf in get_hear(7, sourceturf))
				to_chat(C, "<font color='["#6699CC"]'><b><span class='prefix'>[prefix]:</span> <EM>[src.mob.name][added_text]:</EM> <span class='message'>[msg]</span></b></font>", type = MESSAGE_TYPE_OOC)
			else if(is_admin == 1)
				to_chat(C, "<font color='["#6699CC"]'><b>(R) <span class='prefix'>[prefix]:</span> <EM>[src.mob.name][added_text]:</EM> <span class='message'>[msg]</span></b></font>", type = MESSAGE_TYPE_OOC)
