/proc/priority_announce(text, title = "", sound, type , mob/living/sender = null, mob/living/receiver = null, strip_html = TRUE)
	if(!text)
		return

	var/announcement

	if (title && length(title) > 0)
		announcement += "<h1 class='alert'>[title]</h1>"
	if(strip_html)
		announcement += "<br><span class='alert'>[STRIP_HTML_SIMPLE(text, MAX_MESSAGE_LEN)]</span>"
	else
		announcement += "<br><span class='alert'>[text]</span>"

	if (sender)
		sender.log_talk(text, LOG_SAY, tag="priority announcement")
		message_admins("[ADMIN_LOOKUPFLW(sender)] has made a priority announcement.")

	var/s = sound(sound)
	for(var/mob/M in GLOB.player_list)
		if (!M.can_hear())
			return
		if (receiver && !(istype(M, receiver) || (sender && M == sender)))
			return

		to_chat(M, announcement)
		if (M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
			if (!sound)
				return
			M.playsound_local(M, s, 100)

/proc/minor_announce(message, title = "", alert)
	if(!message)
		return

	for(var/mob/M in GLOB.player_list)
		if(M.can_hear())
			to_chat(M, "<span class='big bold'><font color = purple>[html_encode(title)]</font color><BR>[html_encode(message)]</span><BR>")
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				if(alert)
					M.playsound_local(M, 'sound/misc/alert.ogg', 100)
				else
					M.playsound_local(M, 'sound/misc/alert.ogg', 100)
