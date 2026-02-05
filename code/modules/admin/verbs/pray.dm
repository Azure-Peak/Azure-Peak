/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"
	set hidden = 1
	if(!usr.client.holder)
		return

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	log_prayer("[src.key]/([src.name]): [msg]")
//	if(usr.client)
//		if(usr.client.prefs.muted & MUTE_PRAY)
//			to_chat(usr, span_danger("I cannot pray (muted)."))
//			return
//		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
//			return

	var/font_color = "purple"
	var/prayer_type = "PRAYER"
	var/deity
	if(ishuman(src))
		var/mob/living/carbon/human/human_user = src
		deity = human_user.patron.name
	if(usr.job == "Chaplain")
		font_color = "blue"
		prayer_type = "CHAPLAIN PRAYER"
		if(GLOB.deity)
			deity = GLOB.deity
	else if(isliving(usr))
		var/mob/living/L = usr
		if(HAS_TRAIT(L, TRAIT_SPIRITUAL))
			font_color = "blue"
			prayer_type = "SPIRITUAL PRAYER"

	var/msg_tmp = msg
	msg = span_adminnotice("[icon2html(GLOB.admins)]<b><font color=[font_color]>[prayer_type][deity ? " (to [deity])" : ""]: </font>[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)]:</b> <span class='linkify'>[msg]</span>")
	for(var/client/C in GLOB.admins)
		if(C.prefs.chat_toggles & CHAT_PRAYER)
			to_chat(C, msg)
			if(C.prefs.toggles & SOUND_PRAYERS)
				if(HAS_TRAIT(usr, TRAIT_CHOSEN))
					SEND_SOUND(C, sound('sound/pray.ogg'))

	for(var/mob/M in GLOB.dead_mob_list)
		if(!M.client)
			continue
//		var/T = get_turf(src)
		if(M.stat == DEAD)
			var/client/J = M.client
			to_chat(J, msg)

	to_chat(usr, span_info("I pray to the gods: \"[msg_tmp]\""))

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Prayer") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/proc/CentCom_announce(text , mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = span_adminnotice("<b><font color=orange>CENTCOM:</font>[ADMIN_FULLMONTY(Sender)] [ADMIN_CENTCOM_REPLY(Sender)]:</b> [msg]")
	to_chat(GLOB.admins, msg)

/proc/Syndicate_announce(text , mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = span_adminnotice("<b><font color=crimson>SYNDICATE:</font>[ADMIN_FULLMONTY(Sender)] [ADMIN_SYNDICATE_REPLY(Sender)]:</b> [msg]")
	to_chat(GLOB.admins, msg)

/proc/Nuke_request(text , mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = span_adminnotice("<b><font color=orange>NUKE CODE REQUEST:</font>[ADMIN_FULLMONTY(Sender)] [ADMIN_CENTCOM_REPLY(Sender)] [ADMIN_SET_SD_CODE]:</b> [msg]")
	to_chat(GLOB.admins, msg)

/mob/proc/roguepray(msg as text)
//	set category = "IC"
//	set name = "Pray"
//	set hidden = 1
//	if(!usr.client.holder)
//		return
//
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	log_prayer("[src.key]/([src.name]): [msg]")

	var/deity = ""
	if(isliving(src))
		var/mob/living/living_user = src
		if(istype(living_user.patron))
			deity = " to [living_user.patron.name]"
	
	var/display_name = "[real_name || src.name]"

	msg = span_info("[display_name] prays[deity] [ADMIN_FLW(src)][ADMIN_SM(src)]: [msg]")
	
	for(var/client/janny in GLOB.admins)
		if(janny.prefs.chat_toggles & CHAT_PRAYER)
			to_chat(janny, msg)
			if(janny.prefs.toggles & SOUND_PRAYERS)
				SEND_SOUND(janny, sound('sound/pray.ogg'))
