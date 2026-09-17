/// Get the currently used voicepack accounting for species and prefs
/datum/preferences/proc/get_effective_voicepack()
	if(voice_pack != "Default")
		var/datum/voicepack/VP = GLOB.voice_packs[GLOB.voice_packs_list[voice_pack]]
		return VP

	var/datum/voicepack/VP
	if(gender == FEMALE && pref_species.soundpack_f)
		VP = pref_species.soundpack_f
	else if(pref_species.soundpack_m)
		VP = pref_species.soundpack_m
	if(voice_type)
		switch(voice_type)
			if(VOICE_TYPE_MASC)
				VP = pref_species.soundpack_m
			else
				if(pref_species.soundpack_f)
					VP = pref_species.soundpack_f
				else
					VP = pref_species.soundpack_m

	if(!istype(VP))
		VP = GLOB.voice_packs[VP]
	if(!istype(VP))
		VP = GLOB.voice_packs[/datum/voicepack/male]

	return VP

/// This closes all of the possible subwindows we might have opened
/datum/preferences/proc/close_subwindows(mob/user)
	if(!user?.client)
		return

	user << browse(null, "window=familiar_prefs")
	user << browse(null, "window=playerquality")
	user << browse(null, "window=triumph_leaderboard")
	user << browse(null, "window=classhelp")
	user << browse(null, "window=capturekeypress")

	for(var/datum/tgui/ui in user.tgui_open_uis)
		if(istype(ui.src_object, /datum/loadout_menu))
			ui.close()

	migrant.hide_ui()
	SStriumphs.remove_triumph_buy_menu(user.client)


/// This proc is used in every single act() to notify the user what they have changed.
/// Keeps a history log for this session viewable in the menu.
/datum/preferences/proc/verbose_pref_log(user, log_entry, chat_log_entry)
	if(verbose_character_creator)
		to_chat(user, chat_log_entry)
	history_log += "[worldtime2text()]: [log_entry]"
	if(LAZYLEN(history_log) > MAX_HISTORY_ENTRIES)
		history_log.Cut(1,2)

/datum/preferences/proc/stylize_log_entry(log_entry, span)
	switch(span)
		if("notice")
			. = span_notice(log_entry)
		if("warning")
			. = span_warning(log_entry)
		if("danger")
			. = span_danger(log_entry)
		else
			// Notice is the default but log an error.
			stack_trace("Invalid span \"[span]\". Did you forget to pass one?")
			. = span_notice(log_entry)
	. = "[span_notice("Character Creator:")] [.]"

/datum/preferences/proc/verbose_pref_log_change(user, span, pref, before, after)
	var/log_entry = "\"[real_name]\" updated. \"[pref]\" switched from \"[before]\" to \"[after]\"."
	verbose_pref_log(user, log_entry, stylize_log_entry(log_entry, span))

/datum/preferences/proc/verbose_pref_log_notification(user, span, message)
	var/log_entry = "\"[real_name]\" updated. [message]."
	verbose_pref_log(user, log_entry, stylize_log_entry(log_entry, span))
