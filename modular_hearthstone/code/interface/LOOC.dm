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
	var/muted = prefs.muted
	for(var/mob/M in GLOB.player_list)
		var/added_text
		var/is_admin = FALSE
		var/client/C = M.client
		if(!M.client)
			continue
		if((C in GLOB.admins) && (C.prefs.admin_chat_toggles & CHAT_ADMINLOOC))
			added_text += " ([mob.ckey]) [ADMIN_FLW(mob)] <A href='?_src_=holder;[HrefToken()];mute=[ckey];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"blue"]'>\[MUTE\]</font></a>"
			is_admin = 1
		mobs += C
		if(C.prefs.chat_toggles & CHAT_OOC)
			var/turf/speakturf = get_turf(M)
			var/turf/sourceturf = get_turf(usr)
			if(wp == 1 && (M in range (7, src)))
				to_chat(C, "<font color='["#6699CC"]'><b><span class='prefix'>[prefix]:</span> <EM>[src.mob.name][added_text]:</EM> <span class='message'>[msg]</span></b></font>")
			else if(speakturf in get_hear(7, sourceturf))
				to_chat(C, "<font color='["#6699CC"]'><b><span class='prefix'>[prefix]:</span> <EM>[src.mob.name][added_text]:</EM> <span class='message'>[msg]</span></b></font>")
			else if(is_admin == 1)
				to_chat(C, "<font color='["#6699CC"]'><b>(R) <span class='prefix'>[prefix]:</span> <EM>[src.mob.name][added_text]:</EM> <span class='message'>[msg]</span></b></font>")
