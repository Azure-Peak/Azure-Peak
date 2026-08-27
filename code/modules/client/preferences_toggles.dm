//this works as is to create a single checked item, but has no back end code for toggleing the check yet
#define TOGGLE_CHECKBOX(PARENT, CHILD) PARENT/CHILD/abstract = TRUE;PARENT/CHILD/checkbox = CHECKBOX_TOGGLE;PARENT/CHILD/verb/CHILD

//Example usage TOGGLE_CHECKBOX(datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()
#ifdef TESTING
//override because we don't want to save preferences twice.
/datum/verbs/menu/Settings/Set_checked(client/C, verbpath)
	if (checkbox == CHECKBOX_GROUP)
		C.prefs.menuoptions[type] = verbpath
	else if (checkbox == CHECKBOX_TOGGLE)
		var/checked = Get_checked(C)
		C.prefs.menuoptions[type] = !checked
		winset(C, "[verbpath]", "is-checked = [!checked]")
#endif

/client/verb/setup_character()
	set name = "Game Preferences"
	set category = "Preferences.Options"
	set desc = ""
	if(prefs)
		prefs.ShowChoices(usr, PREFERENCE_TAB_GAME_SETTINGS)

/client/verb/toggle_fullscreen()
	set name = "Toggle Fullscreen"
	set category = "Preferences.Options"
	set desc = ""
	if(prefs)
		prefs.toggles ^= TOGGLE_FULLSCREEN
		prefs.save_preferences()
		toggle_fullscreeny(prefs.toggles & TOGGLE_FULLSCREEN)

/client/verb/toggle_screenshake()
	set category = "Preferences.Options"
	set name = "Toggle Screen Shake"
	if(prefs)
		prefs.shake = !prefs.shake
		prefs.save_preferences()
		if(prefs.shake)
			to_chat(src, "Screen shake enabled.")
		else
			to_chat(src, "Screen shake disabled.")

/client/verb/masked_examine()
	set category = "Preferences.Options"
	set name = "Toggle Masked Examine"
	if(prefs)
		prefs.masked_examine = !prefs.masked_examine
		prefs.save_preferences()
		if(prefs.masked_examine)
			to_chat(src, "Your character information will be viewable when masked.")
		else
			to_chat(src, "Your character information will no longer be viewable when masked.")

/client/verb/toggle_instruments()
	set category = "Preferences.Options"
	set name = "Toggle Instrument Sounds"
	if(prefs)
		prefs.toggles ^= SOUND_INSTRUMENTS
		prefs.save_preferences()
	to_chat(src, "You will[(prefs.toggles & SOUND_INSTRUMENTS) ? "" : " no longer"] hear instrument-played songs.")

/client/verb/toggle_midis()
	set category = "Preferences.Options"
	set name = "Toggle Admin Midis"
	if(prefs)
		prefs.toggles ^= SOUND_MIDI
		prefs.save_preferences()
	to_chat(src, "You will[prefs.toggles & SOUND_MIDI ? "" : " no longer"] hear admin-played sounds.")

/client/verb/mute_animal_emotes()
	set category = "Preferences.Options"
	set name = "Toggle Animal Noise Emotes"
	if(prefs)
		prefs.mute_animal_emotes = !prefs.mute_animal_emotes
		prefs.save_preferences()
		if(prefs.mute_animal_emotes)
			to_chat(src, "You can no longer hear animal sound emotes.")
		else
			to_chat(src, "You will now hear animal sound emotes.")

/client/verb/autoconsume()
	set category = "Preferences.Options"
	set name = "Toggle AutoConsume"
	if(prefs)
		prefs.autoconsume = !prefs.autoconsume
		prefs.save_preferences()
		if(prefs.autoconsume)
			to_chat(src, "You will now try to repeatedly consume/feed food/drinks")
		else
			to_chat(src, "You will no longer try to repeatedly consume/feed food/drinks")

/client/verb/toggle_ERP() // Alters if other people can use the ERP panel ON you.
	set category = "Preferences.Options"
	set name = "Toggle ERP Panel"
	if(prefs)
		prefs.sexable = !prefs.sexable
		prefs.save_preferences()
		if(prefs.sexable)
			to_chat(src, "Others can play with you.")
		else
			to_chat(src, "Others can't touch you.")

/client/verb/toggle_compliance_notifs() // The messages need to be on-by-default while this is in its early stages.
	set category = "Preferences.Options"
	set name = "Toggle Compliance Notifs"
	if(prefs)
		prefs.compliance_notifs = !prefs.compliance_notifs
		prefs.save_preferences()
		if(prefs.compliance_notifs)
			to_chat(src, "You will receive chat notifications when enabling or disabling Compliance Mode.")
		else
			to_chat(src, "You will no longer be notified in chat when toggling Compliance Mode.")

/client/verb/toggle_examine_blocks()
	set category = "Preferences.Options"
	set name = "Toggle Examine Blocks"
	if(prefs)
		prefs.no_examine_blocks = !prefs.no_examine_blocks
		prefs.save_preferences()
		if(prefs.no_examine_blocks)
			to_chat(src, "You will no longer see examined items in boxes.")
		else
			to_chat(src, "You will now see examined items in boxes.")

/client/verb/toggle_autopunctuation()
	set category = "Preferences.Options"
	set name = "Toggle Autopunctuation"
	if(prefs)
		prefs.no_autopunctuate = !prefs.no_autopunctuate
		prefs.save_preferences()
		if(prefs.no_autopunctuate)
			to_chat(src, "Your messages will no longer be automatically punctuated.")
		else
			to_chat(src, "Your messages will now be automatically punctuated.")

/client/verb/toggle_language_fonts()
	set category = "Preferences.Options"
	set name = "Toggle Language Fonts"
	if(prefs)
		prefs.no_language_fonts = !prefs.no_language_fonts
		prefs.save_preferences()
		if(prefs.no_language_fonts)
			to_chat(src, "You will no longer see languages in their stylized fonts.")
		else
			to_chat(src, "You will now see languages in their stylized fonts.")

/client/verb/toggle_language_icon()
	set category = "Preferences.Options"
	set name = "Toggle Language Icon"
	if(prefs)
		prefs.no_language_icon = !prefs.no_language_icon
		prefs.save_preferences()
		if(prefs.no_language_icon)
			to_chat(src, "You will no longer see the language icon in front of a language.")
		else
			to_chat(src, "You will now see the language icon in front of a language.")

/client/verb/toggle_redflash()
	set category = "Preferences.Options"
	set name = "Toggle Red Screen Flash"
	if(prefs)
		prefs.no_redflash = !prefs.no_redflash
		prefs.save_preferences()
		var/mob/living/carbon/C = mob
		if(istype(C))
			C.update_damage_hud() // Fixes that the overlay is not removed when toggling if already present.
		to_chat(src, "You will see the red flashing effect [prefs.no_redflash ? "less" : "more"] frequently.")

/client/verb/toggle_topexamine()
	set category = "Preferences.Options"
	set name = "Toggle Top Examine"
	if(prefs)
		prefs.top_examine = !prefs.top_examine
		prefs.save_preferences()
		to_chat(src, "Main Examines will be at the [prefs.top_examine ? "top" : "bottom"].")

/client/verb/toggle_lobby_music()
	set name = "Toggle Lobby Music"
	set category = "Preferences.Options"
	set desc = ""
	if(prefs)
		prefs.toggles ^= SOUND_LOBBY
		prefs.save_preferences()
	if(prefs.toggles & SOUND_LOBBY)
		to_chat(src, "You will now hear music in the lobby.")
		if(isnewplayer(usr))
			playtitlemusic()
	else
		to_chat(src, "You will no longer hear music in the lobby.")
		mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)

/client/verb/stop_sounds_rogue()
	set name = "StopSounds"
	set category = "Preferences.Options"
	set desc = ""
	if(mob)
		SEND_SOUND(mob, sound(null))

/client/verb/toggle_area_music()
	set category = "Preferences.Options"
	set name = "Toggle Area Music"
	if(prefs)
		prefs.stopdroning = !prefs.stopdroning
		prefs.save_preferences()

		if(prefs.stopdroning)
			to_chat(src, "You will no longer hear looping area music.")
			SSdroning.kill_droning(src)
			SSdroning.kill_loop(src)
		else
			to_chat(src, "You will now hear looping area music.")

/client/verb/cmode_strip()
	set name = "Combat Mode Stripping"
	set category = "Preferences.Options"
	set desc = ""
	if(prefs)
		prefs.combat_toggles ^= CMODE_STRIPPING
		prefs.save_preferences()
	to_chat(src, "You will [prefs.combat_toggles & CMODE_STRIPPING ? "" : "not"] be able to open the strip menu in combat mode.")

/client/verb/antighost()
	set name = "Toggle Antighost"
	set category = "Preferences.Options"
	set desc = ""
	if(prefs)
		prefs.ghost_toggles ^= TOGGLE_ANTIGHOST
		prefs.save_preferences()
	to_chat(src, "You are currently[prefs.ghost_toggles & TOGGLE_ANTIGHOST ? " not" : ""] orbitable.")

/client/verb/mood_messages_in_chat()
	set category = "Preferences.Options"
	set name = "Toggle Mood Messages"

	if(prefs)
		prefs.chat_toggles ^= CHAT_MOODMESSAGES
		prefs.save_preferences()

	to_chat(src, "You will[prefs.chat_toggles & CHAT_MOODMESSAGES ? "" : " not"] see all mood messages \
	in your chat. Sufficiently severe mood messages are shown in chat regardless of this toggle.")

/client/verb/attack_blip_frequency()
	set category = "Preferences.Options"
	set name = "Change Attack Sound Frequency"

	var/choice = input(src, "How often do you wish to hear your character emote on successful hits?", "ATTACK NOISE FREQUENCY") as null|anything in GLOB.attack_blip_pref_list
	if(!choice)
		return

	if(choice && prefs)
		prefs.attack_blip_frequency = GLOB.attack_blip_pref_list[choice]
		prefs.save_preferences()

	var/text = choice
	if(choice == "Half the time (Default)")
		text = "Half the time"

	to_chat(src, "Your character will [text] voice their successful attacks.")

/client/verb/toggle_xptext() // Whether the user can see the balloon XP pop ups.
	set category = "Preferences.Options"
	set name = "Toggle XP Text"
	if(prefs)
		prefs.combat_toggles ^= XP_TEXT
		prefs.save_preferences()
	to_chat(src, "You will[prefs.combat_toggles & XP_TEXT ? "" : " not"] see XP pop ups.")

/client/verb/vocal_barks()
	set name = "Toggle Vocal Barks"
	set category = "Preferences.Options"
	set desc = ""
	if(prefs)
		prefs.mute_barks = !prefs.mute_barks
		prefs.save_preferences()
	to_chat(src, "You will [prefs.mute_barks ? "not " : ""]hear vocal barks.")

/client/verb/toggle_hitzonetext() // Whether the user can see a text popup for where they got hit.
	set category = "Preferences.Options"
	set name = "Toggle Hitzone Text"
	if(prefs)
		prefs.combat_toggles ^= HITZONE_TEXT
		prefs.save_preferences()
	to_chat(src, "You will[prefs.combat_toggles & HITZONE_TEXT ? "" : " not"] see floating text for where you were hit.")

/client/verb/toggle_floatingtext() // Whether the user can see the balloon pop ups at all.
	set category = "Preferences.Options"
	set name = "Toggle Floating Text"
	if(prefs)
		prefs.combat_toggles ^= FLOATING_TEXT
		prefs.save_preferences()
	to_chat(src, "You will [prefs.combat_toggles & FLOATING_TEXT ? "see" : "not see any"] floating text.")

/client/verb/toggle_deadchat() // Whether the user can see DSAY or not.
	set name = "Show/Hide Deadchat"
	set category = "Preferences.Options"
	set desc ="Toggles seeing deadchat"

	if(prefs)
		prefs.chat_toggles ^= CHAT_DSAY
		prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_DSAY) ? "now" : "no longer"] see deadchat.")
	if(holder)
		SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Deadchat Visibility", "[prefs.chat_toggles & CHAT_DSAY ? "Enabled" : "Disabled"]"))

//Admin Preferences
/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Adminhelp Sound", "[prefs.toggles & SOUND_ADMINHELP ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleannouncelogin()
	set name = "Do/Don't Announce Login"
	set category = "Admin.Preferences"
	set desc = ""
	if(!holder)
		return
	prefs.toggles ^= ANNOUNCE_LOGIN
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & ANNOUNCE_LOGIN) ? "now" : "no longer"] have an announcement to other admins when you login.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Login Announcement", "[prefs.toggles & ANNOUNCE_LOGIN ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Admin.Preferences"
	set desc = ""
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Visibility", "[prefs.chat_toggles & CHAT_PRAYER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_prayer_sound()
	set name = "Toggle Prayer Sounds"
	set category = "Admin.Preferences"
	set desc = ""
	if(!holder)
		return
	prefs.toggles ^= SOUND_PRAYERS
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_PRAYERS) ? "now" : "no longer"] hear a sound when prayers arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Sounds", "[usr.client.prefs.toggles & SOUND_PRAYERS ? "Enabled" : "Disabled"]"))

/client/proc/colorasay()
	set name = "Set Asay Color"
	set category = "Admin.Preferences"
	set desc = ""
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	var/new_asaycolor = input(src, "Please select your ASAY color.", "ASAY color", prefs.asaycolor) as color|null
	if(new_asaycolor)
		prefs.asaycolor = sanitize_ooccolor(new_asaycolor)
		prefs.save_preferences()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set ASAY Color")
	return

/client/proc/resetasaycolor()
	set name = "Reset your Admin Say Color"
	set desc = ""
	set category = "Admin.Preferences"
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	prefs.asaycolor = initial(prefs.asaycolor)
	prefs.save_preferences()

/client/proc/hearallasghost()
	set category = "Admin.Preferences"
	set name = "HearAllAsAdmin"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.chat_toggles ^= CHAT_GHOSTEARS
	prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	prefs.save_preferences()
	if(prefs.chat_toggles & CHAT_GHOSTEARS)
		to_chat(src, span_notice("I will hear all now."))
	else
		to_chat(src, span_info("I will hear like a mortal."))

/client/proc/hearglobalLOOC()
	set category = "Admin.Preferences"
	set name = "Show/Hide Global LOOC"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.admin_chat_toggles ^= CHAT_ADMINLOOC
	prefs.save_preferences()
	if(prefs.admin_chat_toggles & CHAT_ADMINLOOC)
		to_chat(src, span_notice("I will now hear all LOOC chatter."))
	else
		to_chat(src, span_info("I will now only hear LOOC chatter around me."))

/client/proc/hearsubtleLOOC()
	set category = "Admin.Preferences"
	set name = "Show/Hide Subtle LOOC"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.admin_chat_toggles ^= CHAT_ADMIN_SLOOC
	prefs.save_preferences()
	if(prefs.admin_chat_toggles & CHAT_ADMIN_SLOOC)
		to_chat(src, span_notice("I will now hear subtle LOOC (SLOOC) chatter I am not part of."))
	else
		to_chat(src, span_info("I will no longer hear subtle LOOC (SLOOC) chatter I am not part of."))

/client/proc/togglespawnmessages()
	set category = "Admin.Preferences"
	set name = "Show/Hide Spawn Logs"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.admin_chat_toggles ^= CHAT_ADMINSPAWN
	prefs.save_preferences()
	to_chat(src, "You will [prefs.admin_chat_toggles & CHAT_ADMINSPAWN ? "see" : "not see any"] spawn logs.")

/client/verb/full_examine()
	set category = "Preferences.Options"
	set name = "Toggle Full Examine"
	if(prefs)
		prefs.full_examine = !prefs.full_examine
		prefs.save_preferences()
		if(prefs.full_examine)
			to_chat(src, "Examines will be fully shown.")
		else
			to_chat(src, "Examines will have some information behind dropdowns.")

#undef TOGGLE_CHECKBOX
