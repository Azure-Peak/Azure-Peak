/mob/proc/has_antagooc_access()
	if(flags_1 & ANTAGOOC_ACCESS_1)
		return TRUE
	if(!length(mind?.antag_datums))
		return FALSE
	// Wretches are gated entirely, even with other antag datums (e.g. Licker vampires).
	return GLOB.antagooc_wretches || !mind.has_antag_datum(/datum/antagonist/wretch)

/client/proc/can_use_antagooc()
	if(GLOB.say_disabled)	
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return FALSE

	if(!mob)
		return FALSE

	if(CONFIG_GET(flag/usewhitelist))
		if(whitelisted() != 1)
			to_chat(src, span_danger("I can't use that."))
			return FALSE

	if(!holder)
		if(!GLOB.antagooc_allowed)
			to_chat(src, span_danger("AntagOOC is currently disabled."))
			return FALSE
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("I cannot use AntagOOC (muted)."))
			return FALSE
		if(!mob.has_antagooc_access())
			to_chat(src, span_danger("I don't have access to AntagOOC."))
			return FALSE
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger("I have been banned from OOC."))
		return FALSE
	if(prefs.chat_toggles & CHAT_OOC_MUTED)
		to_chat(src, span_danger("I have OOC hidden. Use Show / Hide OOC to see it again."))
		return FALSE
	return TRUE

// No verb argument: BYOND would prompt for it before these checks could run.
/client/verb/antagooc()
	set name = "AntagOOC"
	set category = "OOC"
	set desc = "An OOC channel exclusive to antagonists."
	if(!can_use_antagooc())
		return

	var/msg = input(src, null, "AntagOOC \"text\"") as text|null
	if(!msg || QDELETED(src) || !can_use_antagooc())
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return

	mob.log_talk(raw_msg, LOG_OOC, tag="(AntagOOC)")

	for(var/client/C in GLOB.clients)
		if(C.prefs.chat_toggles & CHAT_OOC_MUTED)
			continue
		if(!C.holder && !C.mob?.has_antagooc_access())
			continue
		var/shown_name = (holder?.fakekey && !C.holder) ? holder.fakekey : "[key]—[mob.name]"
		to_chat(C, "<font color='[PATRON_COLOR_ZIZO]'><b>AntagOOC—</b><EM>[shown_name]:</EM> <span class='message linkify'>[msg]</span></font>", type = MESSAGE_TYPE_OOC)
