GLOBAL_VAR_INIT(OOC_COLOR, null)//If this is null, use the CSS for OOC. Otherwise, use a custom colour.
GLOBAL_VAR_INIT(normal_ooc_colour, "#002eb8")

//client/verb/ooc(msg as text)

/client/verb/ooc(msg as text)
	set name = "OOC"
	set category = "OOC"
	set desc = "Talk with other players in the lobby."
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	if(CONFIG_GET(flag/usewhitelist))
		if(whitelisted() != 1)
			to_chat(src, span_danger("I can't use that."))
			return

	if(blacklisted())
		to_chat(src, span_danger("I can't use that."))
		return

	if(get_playerquality(ckey) <= -5)
		to_chat(src, span_danger("I can't use that."))
		return

	if(!holder)
		if(SSticker.current_state < GAME_STATE_FINISHED && !istype(mob, /mob/dead/new_player))
			to_chat(src, span_danger("OOC is lobby-only during the round. After the round ends it re-opens to everyone."))
			return
		if(!GLOB.ooc_allowed)
			to_chat(src, span_danger("OOC is globally muted."))
			return
		// Allow lobby new_player usage regardless of dooc settings; preserve dead restriction for non-lobby via earlier check.
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("I cannot use OOC (muted)."))
			return
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger("I have been banned from OOC."))
		return
	if(QDELETED(src))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	//msg = emoji_parse(msg)


	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>FOOL</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("I have OOC muted."))
		return

	mob.log_talk(raw_msg, LOG_OOC)

	var/keyname = key
	/*if(ckey in GLOB.anonymize)
		keyname = get_fake_key(ckey)*/
//	if(prefs.unlock_content)
//		if(prefs.toggles & MEMBER_PUBLIC)
//			keyname = "<font color='[prefs.ooccolor ? prefs.ooccolor : GLOB.normal_ooc_colour]'>[icon2html('icons/member_content.dmi', world, "blag")][keyname]</font>"
	//The linkify span classes and linkify=TRUE below make ooc text get clickable chat href links if you pass in something resembling a url
	var/color2use = prefs.voice_color
	if(!color2use)
		color2use = "#FFFFFF"
	else
		color2use = "#[color2use]"
	var/chat_color = "#c5c5c5"
	var/msg_to_send = ""

	for(var/client/C in GLOB.clients)
		// Treat anything at or beyond GAME_STATE_FINISHED as post-round for OOC visibility.
		var/post_round = (SSticker.current_state >= GAME_STATE_FINISHED)
		if(!post_round)
			// Non-admin: must be lobby new_player during active round
			if(!C.holder && !istype(C.mob, /mob/dead/new_player))
				continue
			// Admin: they can opt out while not in lobby
			if(C.holder && !C.show_lobby_ooc && !istype(C.mob, /mob/dead/new_player))
				continue
		if(!(C.prefs.chat_toggles & CHAT_OOC))
			continue
		var/real_key = C.holder ? "([key])" : ""
		// Precedence: sender-admin (blue) > recipient-admin non-lobby (green/small) > default gray
		var/is_admin_nonlobby = (C.holder && !istype(C.mob, /mob/dead/new_player) && !post_round)
		var/sender_nonlobby = (!istype(mob, /mob/dead/new_player) && !post_round)
		var/sender_is_admin = holder
		// Choose color: admin-sent stays blue; otherwise if admin recipient non-lobby, use green; else default gray
		var/message_color = sender_is_admin ? "#4972bc" : (is_admin_nonlobby ? "#4CAF50" : chat_color)
		var/base_msg = "<font color='[color2use]'><EM>[keyname][real_key]:</EM></font> <font color='[message_color]'><span class='message linkify'>[msg]</span></font>"
		// Apply size reduction: if recipient is admin non-lobby OR (sender is admin non-lobby)
		if(is_admin_nonlobby || (sender_is_admin && sender_nonlobby))
			msg_to_send = "<span style='font-size:70%'>[base_msg]</span>"
		else
			msg_to_send = base_msg
		to_chat(C, msg_to_send)

//				if(!holder.fakekey || C.holder)
//					if(check_rights_for(src, R_ADMIN))
//						to_chat(C, "<span class='adminooc'><EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></span></font>")
//					else
//						to_chat(C, span_adminobserverooc("<EM>[keyname]:</EM> <span class='message linkify'>[msg]</span>"))
//				else
//					if(GLOB.OOC_COLOR)
//						to_chat(C, "<font color='[GLOB.OOC_COLOR]'><b><EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></b></font>")
//					else
//						to_chat(C, span_ooc("<EM>[keyname]:</EM> <span class='message linkify'>[msg]</span>"))

//			else if(!(key in C.prefs.ignoring))
//				if(GLOB.OOC_COLOR)
//					to_chat(C, "<font color='[GLOB.OOC_COLOR]'><b><EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></b></font>")
//				else
//					to_chat(C, span_ooc("<EM>[keyname]:</EM> <span class='message linkify'>[msg]</span>"))


/client/proc/lobbyooc(msg as text)
	set category = "OOC"
	set name = "OOC"
	set desc = "Talk with the other players."

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	if(CONFIG_GET(flag/usewhitelist))
		if(whitelisted() != 1)
			to_chat(src, span_danger("I can't use that."))
			return

	if(blacklisted())
		to_chat(src, span_danger("I can't use that."))
		return

	if(get_playerquality(ckey) <= -5)
		to_chat(src, span_danger("I can't use that."))
		return

	if(!holder)
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("I cannot use OOC (muted)."))
			return
		if(!GLOB.ooc_allowed)
			to_chat(src, span_danger("OOC is currently disabled."))
			return
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger("I have been banned from OOC."))
		return
	if(QDELETED(src))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	//msg = emoji_parse(msg)


	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>FOOL</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("I have OOC muted."))
		return

	mob.log_talk(raw_msg, LOG_OOC)

	var/keyname = key
	/*if(ckey in GLOB.anonymize)
		keyname = get_fake_key(ckey)*/
//	if(prefs.unlock_content)
//		if(prefs.toggles & MEMBER_PUBLIC)
//			keyname = "<font color='[prefs.ooccolor ? prefs.ooccolor : GLOB.normal_ooc_colour]'>[icon2html('icons/member_content.dmi', world, "blag")][keyname]</font>"
	//The linkify span classes and linkify=TRUE below make ooc text get clickable chat href links if you pass in something resembling a url
	var/color2use = prefs.voice_color
	if(!color2use)
		color2use = "#FFFFFF"
	else
		color2use = "#[color2use]"
	var/chat_color = "#c5c5c5"
	var/msg_to_send = ""

	for(var/client/C in GLOB.clients)
		if(!(C.prefs.chat_toggles & CHAT_OOC))
			continue
		var/post_round = (SSticker.current_state >= GAME_STATE_FINISHED)
		if(!post_round)
			if(!C.holder && !istype(C.mob, /mob/dead/new_player))
				continue
			if(C.holder && !C.show_lobby_ooc && !istype(C.mob, /mob/dead/new_player))
				continue
		var/real_key = C.holder ? "([key])" : ""
		// Precedence: sender-admin (blue) > recipient-admin non-lobby (green/small) > default gray
		var/is_admin_nonlobby = (C.holder && !istype(C.mob, /mob/dead/new_player) && !post_round)
		var/sender_nonlobby = (!istype(mob, /mob/dead/new_player) && !post_round)
		var/sender_is_admin = holder
		var/message_color = sender_is_admin ? "#4972bc" : (is_admin_nonlobby ? "#4CAF50" : chat_color)
		var/base_msg = "<font color='[color2use]'><EM>[keyname][real_key]:</EM></font> <font color='[message_color]'><span class='message linkify'>[msg]</span></font>"
		if(is_admin_nonlobby || (sender_is_admin && sender_nonlobby))
			msg_to_send = "<span style='font-size:70%'>[base_msg]</span>"
		else
			msg_to_send = base_msg
		to_chat(C, msg_to_send)


/proc/toggle_ooc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling ooc
		if(toggle != GLOB.ooc_allowed)
			GLOB.ooc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.ooc_allowed = !GLOB.ooc_allowed
	message_admins("<B>The OOC channel has been globally [GLOB.ooc_allowed ? "enabled" : "disabled"].</B>")

/proc/toggle_dooc(toggle = null)
	if(toggle != null)
		if(toggle != GLOB.dooc_allowed)
			GLOB.dooc_allowed = toggle
		else
			return
	else
		GLOB.dooc_allowed = !GLOB.dooc_allowed

/client/proc/set_ooc(newColor as color)
	set name = "Set Player OOC Color"
	set desc = ""
	set category = "-Fun-"
	set hidden = 1
	if(!holder)
		return
	GLOB.OOC_COLOR = sanitize_ooccolor(newColor)
	if(!check_rights(0))
		return

/client/proc/reset_ooc()
	set name = "Reset Player OOC Color"
	set desc = ""
	set category = "-Fun-"
	set hidden = 1
	if(!holder)
		return
	GLOB.OOC_COLOR = null
	if(!check_rights(0))
		return
/client/verb/colorooc()
	set name = "Set Your OOC Color"
	set category = "Preferences"
	set hidden = 1
	if(!holder)
		return
	if(!check_rights(0))
		return
	if(!holder || !check_rights_for(src, R_ADMIN))
		if(!is_content_unlocked())
			return

	var/new_ooccolor = input(src, "Please select your OOC color.", "OOC color", prefs.ooccolor) as color|null
	if(new_ooccolor)
		prefs.ooccolor = sanitize_ooccolor(new_ooccolor)
		prefs.save_preferences()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set OOC Color") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/verb/resetcolorooc()
	set name = "Reset Your OOC Color"
	set desc = ""
	set category = "Preferences"
	set hidden = 1
	if(!holder)
		return
	if(!check_rights(0))
		return
	if(!holder || !check_rights_for(src, R_ADMIN))
		if(!is_content_unlocked())
			return

		prefs.ooccolor = initial(prefs.ooccolor)
		prefs.save_preferences()

/client/verb/toggle_ooc_anonymize()
	set name = "Toggle OOC Anonymize"
	set category = "OOC"
	set desc = "Use a random anonymized handle or show your real ckey in Lobby OOC."
	if(!mob)
		return
	// Flip preference
	prefs.anonymize = !prefs.anonymize
	if(prefs.anonymize)
		GLOB.anonymize |= ckey
	else
		GLOB.anonymize -= ckey
	prefs.save_preferences()
	to_chat(src, span_notice("OOC Anonymize is now [prefs.anonymize ? "ENABLED (your handle will be randomized)" : "DISABLED (your ckey will be shown)"]."))

//Checks admin notice
/client/verb/admin_notice()
	set name = "Adminnotice"
	set category = "-Admin-"
	set desc ="Check the admin notice if it has been set"
	set hidden = 1
	if(!holder)
		return
	if(!check_rights(0))
		return
	if(GLOB.admin_notice)
		to_chat(src, "<span class='boldnotice'>Admin Notice:</span>\n \t [GLOB.admin_notice]")
	else
		to_chat(src, span_notice("There are no admin notices at the moment."))
#ifdef TESTSERVER
/client/verb/smiteselfverily()
	set name = "KillSelf"
	set category = "DEBUGTEST"
/*
	set hidden = 1
	if(!check_rights(0))
		return*/
	var/confirm = alert(src, "Should I really kill myself?", "Feed the crows", "Yes", "No")
	if(confirm == "Yes")
		log_admin("[key_name(usr)] used killself.")
		message_admins(span_adminnotice("[key_name_admin(usr)] used killself."))
		mob.death()
#endif

/proc/CheckJoinDate(ckey)
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond member page to age check [ckey]")
		return "2022"
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4})")
		if(R.Find(F))
			. = R.group[1]
		else
			return "2022" //can't find join date, either a scuffed name or a guest but let it through anyway

/proc/CheckIPCountry(ipaddress)
	set background = 1
	if(!ipaddress)
		return
	var/list/vl = world.Export("http://ip-api.com/json/[ipaddress]")
	if (!("CONTENT" in vl) || vl["STATUS"] != "200 OK")
		return
	var/jd = html_encode(file2text(vl["CONTENT"]))
	var/parsed = ""
	var/pos = 1
	var/search = findtext(jd, "country", pos)
	parsed += copytext(jd, pos, search)
	if(search)
		pos = search
		search = findtext(jd, ",", pos+1)
		if(search)
			return lowertext(copytext(jd, pos+9, search))

/client/verb/html_chat()
	set name = "{Old Chat}"
	set category = "Options"
	set hidden = FALSE

	to_chat(src, "Going back to old chat.")
	winset(src, "outputwindow.legacy_output_selector", "left=output_legacy")

/client/verb/motd()
	set name = "MOTD"
	set category = "OOC"
	set desc ="Check the Message of the Day"
	set hidden = 1
	if(!holder)
		return
	if(!check_rights(0))
		return
	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)
	else
		to_chat(src, span_notice("The Message of the Day has not been set."))

/client/proc/self_notes()
	set name = "View Admin Remarks"
	set category = "OOC"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	if(!check_rights(0))
		return
	if(!CONFIG_GET(flag/see_own_notes))
		to_chat(usr, span_notice("Sorry, that function is not enabled on this server."))
		return

	browse_messages(null, usr.ckey, null, TRUE)

/client/proc/self_playtime()
	set name = "View tracked playtime"
	set category = "OOC"
	set desc = ""

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, span_notice("Sorry, tracking is currently disabled."))
		return

	var/list/body = list()
	body += "<html><head><title>Playtime for [key]</title></head><BODY><BR>Playtime:"
	body += get_exp_report()
	body += "</BODY></HTML>"
	usr << browse(body.Join(), "window=playerplaytime[ckey];size=550x615")

/client/proc/ignore_key(client, displayed_key)
	var/client/C = client
	if(C.key in prefs.ignoring)
		prefs.ignoring -= C.key
	else
		prefs.ignoring |= C.key
	to_chat(src, "You are [(C.key in prefs.ignoring) ? "now" : "no longer"] ignoring [displayed_key] on the OOC channel.")
	prefs.save_preferences()

/client/verb/select_ignore()
	set name = "Ignore"
	set category = "Options"
	set desc ="Ignore a player's messages on the OOC channel"
	set hidden = 1
	if(!holder)
		return

	var/see_ghost_names = isobserver(mob)
	var/list/choices = list()
	var/displayed_choicename = ""
	for(var/client/C in GLOB.clients)
		if(C.holder?.fakekey)
			displayed_choicename = C.holder.fakekey
		else
			displayed_choicename = C.key
		if(isobserver(C.mob) && see_ghost_names)
			choices["[C.mob]([displayed_choicename])"] = C
		else
			choices[displayed_choicename] = C
	choices = sortList(choices)
	var/selection = input("Please, select a player!", "Ignore", null, null) as null|anything in choices
	if(!selection || !(selection in choices))
		return
	displayed_choicename = selection // ckey string
	selection = choices[selection] // client
	if(selection == src)
		to_chat(src, "You can't ignore myself.")
		return
	ignore_key(selection, displayed_choicename)

/client/proc/show_previous_roundend_report()
	set name = "Your Last Round"
	set category = "OOC"
	set desc = ""

	SSticker.show_roundend_report(src, TRUE)

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.split", "splitter=[pct]")

/client/verb/combat_music() // if you touch this, touch the option in game preferences too
	set name = "Combat Mode Music"
	set category = "Options"
	set desc = ""
	if(!isliving(mob))
		to_chat(src, span_warning("You're not alive yet. Set this in your Game Preferences instead."))
		return
	var/mob/living/L = mob
	var/track_select = input(src, "Choose a combat music track to use TEMPORARILY.\n\
									You can set this permanently in Game Preferences.\
									", "Combat Music", L.cmode_music_override_name)\
									as null|anything in GLOB.cmode_tracks_by_name
	if(track_select)
		if(!isliving(mob)) // mob might've changed between then and now
			return
		L = mob
		var/datum/combat_music/combat_music
		combat_music = GLOB.cmode_tracks_by_name[track_select]
		to_chat(src, span_notice("Selected track: <b>[track_select]</b>."))
		if(combat_music.desc)
			to_chat(src, "<i>[combat_music.desc]</i>")
		if(combat_music.credits)
			to_chat(src, span_info("Song name: <b>[combat_music.credits]</b>"))
		// also change it for Werewolf & Wildshape transformations, else it'd be annoying to keep changing this (lol)
		var/mob/living/carbon/human/H
		var/mob/living/S
		if(ishuman(mob))
			H = mob
			if(isliving(H.stored_mob))
				S = H.stored_mob
		L.cmode_music_override = combat_music.musicpath
		L.cmode_music_override_name = combat_music.name
		if(S)
			S.cmode_music_override = combat_music.musicpath
			S.cmode_music_override_name = combat_music.name
	return

/client/verb/policy()
	set name = "Show Policy"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	if(!holder)
		return

	//Collect keywords
	var/list/keywords = mob.get_policy_keywords()
	var/header = get_policy(POLICY_VERB_HEADER)
	var/list/policytext = list(header,"<hr>")
	var/anything = FALSE

	for(var/keyword in keywords)
		var/p = get_policy(keyword)
		if(p)
			policytext += p
			policytext += "<hr>"
			anything = TRUE
	if(!anything)
		policytext += "No related rules found."

	usr << browse(policytext.Join(""),"window=policy")
