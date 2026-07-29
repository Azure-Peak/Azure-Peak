/// TGUI Character Sheet - modern replacement for the ShowChoices() browser window.
/// Reuses process_link() for all actions so behavior is identical to the legacy menu.
/// While a client has the tgui sheet open (charsheet_tgui_active), ShowChoices() calls
/// made by legacy code paths are converted into tgui data refreshes instead of
/// reopening the old browser window.

#define CHARSHEET_PREVIEW_MAP "charsheet_preview_map"

/datum/preferences
	/// TRUE while this client is using the tgui character sheet instead of the legacy window.
	var/charsheet_tgui_active = FALSE

/client/verb/character_sheet_tgui()
	set name = "Character Sheet (TGUI)"
	set category = "OOC"
	set desc = "Open the tgui character setup window."
	if(!prefs)
		return
	prefs.open_charsheet(mob)

/datum/preferences/proc/open_charsheet(mob/user)
	charsheet_tgui_active = TRUE
	ui_interact(user)

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterSheet")
		// All mutations flow through ui_act/process_link, which refresh the UI;
		// the per-second autoupdate would rebuild the job/keybind payload for nothing.
		ui.set_autoupdate(FALSE)
		ui.open()
		update_preview_icon()

/datum/preferences/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/preferences/ui_close(mob/user)
	. = ..()
	charsheet_tgui_active = FALSE
	user?.client?.clear_character_previews()

/datum/preferences/proc/charsheet_virtue_data(datum/virtue/V)
	if(!V)
		return null
	var/list/data = list(
		"name" = "[V]",
		"picked" = list(),
		"can_pick_more" = FALSE,
		"next_cost" = 0,
		"tri_cost" = 0,
	)
	var/tricost = 0
	if(length(V.extra_choices) && length(V.picked_choices))
		for(var/i in 1 to length(V.picked_choices))
			tricost += V.choice_costs[i]
	data["tri_cost"] = tricost
	if(length(V.picked_choices))
		for(var/i in 1 to length(V.picked_choices))
			var/choice = V.picked_choices[i]
			data["picked"] += list(list(
				"name" = "[choice]",
				"index" = i,
				"has_tooltip" = !!LAZYACCESS(V.choice_tooltips, choice),
			))
	if(length(V.picked_choices) < V.max_choices && length(V.choice_costs) > length(V.picked_choices))
		data["can_pick_more"] = TRUE
		data["next_cost"] = V.choice_costs[length(V.picked_choices) + 1]
	return data

/datum/preferences/ui_data(mob/user)
	var/list/data = list()

	// The legacy menu initialized these inside its render; the tgui sheet must do
	// the same or virtue clicks and virtue-restricted job checks runtime on null.
	if(!virtue)
		virtue = GLOB.virtues[/datum/virtue/none]
	if(!virtuetwo)
		virtuetwo = GLOB.virtues[/datum/virtue/none]

	// Header badges
	var/list/pq_display = get_playerquality_display(get_playerquality(user.ckey))
	data["pq"] = pq_display["label"]
	data["pq_color"] = pq_display["color"]
	data["triumphs"] = user.get_triumphs()
	data["triumph_buys_enabled"] = SStriumphs.triumph_buys_enabled
	data["age_verified"] = user.check_agevet()

	// Bans / warnings
	data["appearance_banned"] = is_banned_from(user.ckey, "Appearance")
	data["name_banned"] = check_nameban(user.ckey)
	data["species_invalid"] = !spec_check(user)

	// Quirks
	data["quirks_enabled"] = CONFIG_GET(flag/roundstart_traits)
	data["quirks"] = all_quirks

	// Identity
	data["real_name"] = real_name
	data["nickname"] = nickname
	data["pronouns"] = pronouns
	data["titles_pref"] = titles_pref
	data["clothes_pref"] = clothes_pref
	data["species_name"] = pref_species?.base_name
	data["subspecies_name"] = pref_species?.sub_name
	data["origin"] = "[virtue_origin]"
	data["age"] = age
	data["statpack"] = statpack?.name
	data["statpack_virtuous"] = statpack?.virtuous

	var/lang_output = "None"
	if(ispath(extra_language, /datum/language))
		var/datum/language/L = extra_language
		lang_output = initial(L.name)
	data["extra_language"] = lang_output

	// Race bonus (species custom selection)
	data["has_race_bonus"] = !!length(pref_species?.custom_selection)
	var/race_bonus_display
	if(race_bonus && length(pref_species?.custom_selection))
		for(var/bonus in pref_species.custom_selection)
			if(bonus == race_bonus)
				race_bonus_display = bonus
				break
	data["race_bonus"] = race_bonus_display || "None"

	// Body type / gender
	data["agender_species"] = (AGENDER in pref_species?.species_traits)
	var/disp_gender = "Other"
	if(gender == MALE)
		disp_gender = "Masculine"
	else if(gender == FEMALE)
		disp_gender = "Feminine"
	data["body_type"] = disp_gender
	data["show_random_body"] = !!(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG])
	data["random_gender"] = !!randomise[RANDOM_GENDER]
	data["random_gender_antag"] = !!randomise[RANDOM_GENDER_ANTAG]

	// Taur
	data["taur_allowed"] = !!LAZYLEN(pref_species?.allowed_taur_types)
	if(data["taur_allowed"])
		var/obj/item/bodypart/taur/T = taur_type
		data["taur_name"] = ispath(T) ? T::name : "None"
		data["taur_color"] = taur_color

	// Virtues & vices
	data["virtue"] = charsheet_virtue_data(virtue)
	data["virtuetwo"] = charsheet_virtue_data(virtuetwo)
	var/list/flaw_list = list()
	var/has_extra_vice = FALSE
	for(var/datum/charflaw/cf in charflaws)
		if(!cf.needs_extra_vice)
			has_extra_vice = TRUE
	for(var/i in 1 to length(charflaws))
		var/datum/charflaw/cf = charflaws[i]
		if(!cf)
			continue
		flaw_list += list(list(
			"name" = "[cf]",
			"desc" = cf.desc,
			"index" = i,
			"warning" = (cf.needs_extra_vice && !has_extra_vice),
		))
	data["charflaws"] = flaw_list
	data["can_add_vice"] = length(charflaws) < MAX_VICES
	var/has_averse = FALSE
	for(var/datum/charflaw/cf in charflaws)
		if(istype(cf, /datum/charflaw/averse))
			has_averse = TRUE
			break
	data["has_averse"] = has_averse
	data["averse_faction"] = averse_chosen_faction || "Inquisition"

	// Faith
	var/datum/faith/selected_faith = GLOB.faithlist[selected_patron?.associated_faith]
	data["faith"] = selected_faith?.name || "None"
	data["patron"] = selected_patron?.name || "None"
	data["domhand"] = (domhand == 1) ? "Left-handed" : "Right-handed"

	// Misc identity-column entries
	var/musicname = combat_music ? (combat_music.shortname ? combat_music.shortname : combat_music.name) : "None"
	data["combat_music"] = musicname
	data["dnr"] = !!dnr_pref

	// Voice & bark
	data["voice_type"] = voice_type
	data["voice_pack"] = voice_pack || "Default"
	data["voice_pitch"] = voice_pitch
	var/datum/bark/B = GLOB.bark_list[bark_id]
	data["bark_name"] = B ? initial(B.name) : "INVALID"
	data["bark_speed"] = bark_speed
	data["bark_pitch"] = bark_pitch
	data["bark_variance"] = bark_variance

	// Body section
	data["update_mutant_colors"] = !!update_mutant_colors
	data["use_skintones"] = !!pref_species?.use_skintones
	data["skin_tone_wording"] = pref_species?.skin_tone_wording || "Skin Tone"
	data["mutcolors"] = ((MUTCOLORS in pref_species?.species_traits) || (MUTCOLORS_PARTSONLY in pref_species?.species_traits))
	data["mcolor"] = features["mcolor"]
	data["mcolor2"] = features["mcolor2"]
	data["mcolor3"] = features["mcolor3"]
	data["body_size"] = features["body_size"] * 100
	data["headshot"] = headshot_link

	var/examine_theme_name = "None (Use Viewer's)"
	if(examine_theme)
		var/list/all_themes = get_tgui_themes()
		examine_theme_name = all_themes[examine_theme] || examine_theme
	data["examine_theme"] = examine_theme_name

	// Flavor & OOC
	data["flavortext_short"] = length(flavortext) < MINIMUM_FLAVOR_TEXT
	data["ooc_notes_short"] = length(ooc_notes) < MINIMUM_OOC_NOTES

	// Preview map
	data["preview_map"] = CHARSHEET_PREVIEW_MAP

	// Footer / lobby state
	data["is_guest"] = IsGuestKey(user.key)
	var/mob/dead/new_player/N = user
	data["is_new_player"] = istype(N)
	if(istype(N))
		data["pregame"] = (SSticker.current_state <= GAME_STATE_PREGAME)
		data["ready"] = N.ready
		data["is_migrant"] = is_active_migrant()

	data["jobs"] = charsheet_jobs_data(user)
	data["villains"] = charsheet_villains_data(user)
	data["settings"] = charsheet_settings_data(user)
	data["ooc"] = charsheet_ooc_data(user)
	data["keybinds"] = charsheet_keybinds_data()

	return data

/// Class selection tab - mirrors SetChoices() row for row, including lock reasons.
/datum/preferences/proc/charsheet_jobs_data(mob/user)
	var/list/out = list(
		"joblessrole" = (joblessrole == BERANDOMJOB) ? "Be Random Job" : "Return to Lobby",
		"lastclass" = lastclass,
		"job_change_locked" = SSticker.job_change_locked,
		"list" = list(),
	)
	if(!SSjob || SSjob.occupations.len <= 0)
		return out
	var/static/list/split_jobs = list("Court Magician", "Bishop", "Merchant", "Guildmaster", "Archivist", "Towner", "Grenzelhoft Mercenary", "Beggar", "Prisoner", "Goblin King")
	var/list/job_list = list()
	for(var/datum/job/job in sortList(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc)))
		if(!job.spawn_positions && !job.always_show_on_latechoices)
			continue
		var/rank = job.title
		var/used_name = job.display_title || job.title
		if((titles_pref == TITLES_F) && job.f_title)
			used_name = "[job.f_title]"
		var/list/entry = list(
			"title" = rank,
			"name" = used_name,
			"divider" = (rank in split_jobs),
			"tutorial" = job.tutorial,
			"slots" = job.spawn_positions,
			"rcp" = job.round_contrib_points,
			"has_info" = !!job.class_setup_examine,
			"locked" = null,
			"lock_color" = null,
			"bancheck" = FALSE,
		)
		if(is_banned_from(user.ckey, rank))
			entry["locked"] = "BANNED"
			entry["lock_color"] = "bad"
			entry["bancheck"] = TRUE
			job_list += list(entry)
			continue
		var/required_playtime_remaining = job.required_playtime_remaining(user.client)
		if(required_playtime_remaining)
			entry["locked"] = "\[[get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()]\]"
			entry["lock_color"] = "bad"
			job_list += list(entry)
			continue
		if(!job.player_old_enough(user.client))
			entry["locked"] = "IN [job.available_in_days(user.client)] DAYS"
			entry["lock_color"] = "bad"
			job_list += list(entry)
			continue
		#ifdef USES_PQ
		if(!isnull(job.min_pq) && (get_playerquality(user.ckey) < job.min_pq))
			entry["locked"] = "Min PQ: [job.min_pq]"
			entry["lock_color"] = "average"
			job_list += list(entry)
			continue
		#endif
		if(!isnull(job.max_pq) && (get_playerquality(user.ckey) > job.max_pq))
			entry["locked"] = "Max PQ: [job.max_pq]"
			entry["lock_color"] = "average"
			job_list += list(entry)
			continue
		if(length(job.virtue_restrictions) || length(job.vice_restrictions))
			var/list/restricted_list = list()
			if(length(job.virtue_restrictions))
				if(virtue && (virtue.type in job.virtue_restrictions))
					restricted_list += virtue.name
				if(virtuetwo && (virtuetwo.type in job.virtue_restrictions))
					restricted_list += virtuetwo.name
			if(length(job.vice_restrictions))
				for(var/datum/charflaw/cf in charflaws)
					if(cf.type in job.vice_restrictions)
						restricted_list += cf.name
			if(length(restricted_list))
				entry["locked"] = "Disallowed by Virtue / Vice: [english_list(restricted_list)]"
				entry["lock_color"] = "purple"
				job_list += list(entry)
				continue
		var/job_unavailable = JOB_AVAILABLE
		if(isnewplayer(parent?.mob))
			var/mob/dead/new_player/new_player = parent.mob
			job_unavailable = new_player.IsJobUnavailable(job.title, latejoin = FALSE)
		var/static/list/acceptable_unavailables = list(JOB_AVAILABLE, JOB_UNAVAILABLE_SLOTFULL)
		if(!(job_unavailable in acceptable_unavailables))
			entry["locked"] = get_job_unavailable_error_message(job_unavailable, job.title, user)
			entry["lock_color"] = "grey"
			job_list += list(entry)
			continue
		// Preference level + the click cycle SetChoices used (left = upper, right = lower)
		switch(job_preferences[job.title])
			if(JP_HIGH)
				entry["level"] = "High"
				entry["level_color"] = "blue"
				entry["upper"] = 4
				entry["lower"] = 2
			if(JP_MEDIUM)
				entry["level"] = "Medium"
				entry["level_color"] = "good"
				entry["upper"] = 1
				entry["lower"] = 3
			if(JP_LOW)
				entry["level"] = "Low"
				entry["level_color"] = "average"
				entry["upper"] = 2
				entry["lower"] = 4
			else
				entry["level"] = "NEVER"
				entry["level_color"] = "bad"
				entry["upper"] = 3
				entry["lower"] = 1
		job_list += list(entry)
	out["list"] = job_list
	return out

/// Villains tab - special roles plus antag appearance / preset bounty settings.
/datum/preferences/proc/charsheet_villains_data(mob/user)
	var/list/out = list(
		"banned_all" = FALSE,
		"roles" = list(),
		"storyteller" = !no_storyteller_events,
		"lich_headshot" = lich_headshot_link,
		"vampire_headshot" = vampire_headshot_link,
		"vampire_skin" = vampire_skin,
		"vampire_eyes" = vampire_eyes,
		"vampire_hair" = vampire_hair,
		"vampire_ears" = vampire_ears,
		"qsr" = !!qsr_pref,
		"bounty_enabled" = !!preset_bounty_enabled,
		"bounty_poster" = GLOB.bounty_posters[preset_bounty_poster_key] || "None",
		"bounty_severity" = GLOB.wretch_severities[preset_bounty_severity_key] || "None",
		"bounty_severity_b" = GLOB.bandit_severities[preset_bounty_severity_b_key] || "None",
		"bounty_severity_v" = GLOB.vagabond_severities[preset_bounty_severity_v_key] || "None",
		"bounty_crime" = preset_bounty_crime || "None",
	)
	if(is_banned_from(user.ckey, ROLE_SYNDICATE))
		out["banned_all"] = TRUE
		be_special = list()
		return out
	for(var/i in GLOB.special_roles_rogue)
		var/list/role = list("name" = capitalize(i), "key" = i, "state" = "toggle", "enabled" = (i in be_special))
		if(is_banned_from(user.ckey, i))
			role["state"] = "banned"
		else if(ispath(GLOB.special_roles_rogue[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs))
			var/days_remaining = get_remaining_days(user.client)
			if(days_remaining)
				role["state"] = "days"
				role["days"] = days_remaining
		out["roles"] += list(role)
	return out

/// Game Settings tab - display options.
/datum/preferences/proc/charsheet_settings_data(mob/user)
	var/list/theme_options = list()
	var/list/all_themes = get_tgui_themes()
	for(var/key in all_themes)
		theme_options += list(list("key" = key, "name" = all_themes[key]))
	return list(
		"tgui_theme" = tgui_theme,
		"tgui_theme_options" = theme_options,
		"statbrowser_theme" = get_statbrowser_theme_display_name(),
		"ambientocclusion" = !!ambientocclusion,
		"windowflashing" = !!windowflashing,
		"clientfps" = clientfps,
		"auto_fit_viewport" = !!auto_fit_viewport,
		"show_widescreen" = (CONFIG_GET(string/default_view) != CONFIG_GET(string/default_view_square)),
		"widescreen" = widescreenpref ? "Enabled ([CONFIG_GET(string/default_view)])" : "Disabled ([CONFIG_GET(string/default_view_square)])",
		"schizo_voice" = !!(toggles & SCHIZO_VOICE),
	)

/// OOC tab - ooc color plus admin-only settings.
/datum/preferences/proc/charsheet_ooc_data(mob/user)
	var/client/C = user.client
	var/list/out = list(
		"can_change_color" = !!(unlock_content || check_rights_for(C, R_ADMIN)),
		"ooccolor" = ooccolor || GLOB.normal_ooc_colour,
		"is_admin" = !!C?.holder,
	)
	if(C?.holder)
		out["adminhelp_sounds"] = !!(toggles & SOUND_ADMINHELP)
		out["prayer_sounds"] = !!(toggles & SOUND_PRAYERS)
		out["announce_login"] = !!(toggles & ANNOUNCE_LOGIN)
		out["combohud_lighting"] = !!(toggles & COMBOHUD_LIGHTING)
		out["show_dead_chat"] = !!(chat_toggles & CHAT_DSAY)
		out["show_radio"] = !!(chat_toggles & CHAT_RADIO)
		out["show_prayers"] = !!(chat_toggles & CHAT_PRAYER)
		out["asay_color_allowed"] = !!CONFIG_GET(flag/allow_admin_asaycolor)
		out["asaycolor"] = asaycolor || "#FF4500"
		out["deadmin_forced"] = !!CONFIG_GET(flag/auto_deadmin_players)
		out["deadmin_always"] = !!(toggles & DEADMIN_ALWAYS)
		out["deadmin_antag_forced"] = !!CONFIG_GET(flag/auto_deadmin_antagonists)
		out["deadmin_antag"] = !!(toggles & DEADMIN_ANTAGONIST)
		out["deadmin_head_forced"] = !!CONFIG_GET(flag/auto_deadmin_heads)
		out["deadmin_head"] = !!(toggles & DEADMIN_POSITION_HEAD)
	return out

/// Keybinds tab - every keybinding grouped by category with the user's bound keys.
/datum/preferences/proc/charsheet_keybinds_data()
	var/list/user_binds = list()
	for(var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)
	var/list/categories = list()
	var/list/by_category = list()
	for(var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		by_category[kb.category] += list(kb)
	for(var/category in by_category)
		var/list/binds = list()
		for(var/datum/keybinding/kb as anything in by_category[category])
			var/list/default_keys = hotkeys ? kb.classic_keys : kb.hotkey_keys
			binds += list(list(
				"name" = kb.name,
				"full_name" = kb.full_name,
				"keys" = user_binds[kb.name] || list(),
				"can_add" = length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND,
				"defaults" = LAZYLEN(default_keys) ? default_keys.Join(", ") : "",
			))
		categories += list(list("name" = category, "binds" = binds))
	return categories

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user?.client)
		return
	switch(action)
		// Generic delegation: every legacy '?_src_=prefs;...' link becomes act('link', {...}).
		if("link")
			var/list/href_list = list()
			for(var/key in params)
				href_list[key] = "[params[key]]"
			process_link(user, href_list)
			update_preview_icon()
			return TRUE

		// Theme dropdown: applies instantly to every open window and saves.
		if("set_tgui_theme")
			set_tgui_theme(params["theme"])
			return TRUE

		if("refresh_preview")
			update_preview_icon()
			return TRUE

		// Swap back to the legacy browser preferences window (persists as an opt-out).
		if("open_legacy")
			charsheet_tgui_active = FALSE
			legacy_prefs_menu = TRUE
			save_preferences()
			ui.close()
			ShowChoices(user)
			return TRUE

		// Lobby footer - mirrors /mob/dead/new_player/Topic() ready/late_join handling.
		if("ready")
			var/mob/dead/new_player/N = user
			if(!istype(N))
				return TRUE
			var/tready = isnum(params["state"]) ? params["state"] : text2num(params["state"])
			if(tready == PLAYER_NOT_READY && SSticker.job_change_locked)
				return TRUE
			if(SSticker.current_state <= GAME_STATE_PREGAME)
				if(tready == PLAYER_READY_TO_PLAY)
					if(!length(job_preferences) && joblessrole != BERANDOMJOB)
						to_chat(N, span_boldwarning("You need to select a class before readying up."))
						return TRUE
					if(length(flavortext) < MINIMUM_FLAVOR_TEXT)
						to_chat(N, span_boldwarning("You need a minimum of [MINIMUM_FLAVOR_TEXT] characters in your flavor text in order to play."))
						return TRUE
					if(length(ooc_notes) < MINIMUM_OOC_NOTES)
						to_chat(N, span_boldwarning("You need at least a few words in your OOC notes in order to play."))
						return TRUE
				if(N.ready != tready)
					N.ready = tready
					if(tready != PLAYER_READY_TO_PLAY && SSvote.mode)
						SSvote.remove_vote_for_ckey(N.ckey)
						SSvote.show_vote(N.client)
					if(tready == PLAYER_READY_TO_PLAY)
						log_game("([user || "NO KEY"]) readied as ([real_name])")
			return TRUE

		if("late_join")
			var/mob/dead/new_player/N = user
			if(!istype(N))
				return TRUE
			if(!SSticker?.IsRoundInProgress())
				to_chat(N, span_boldwarning("The game is starting. You cannot join yet."))
				return TRUE
			if(is_active_migrant())
				to_chat(N, span_boldwarning("You are in the migrant queue."))
				return TRUE
			N.LateChoices()
			return TRUE

		// Class info popup (the legacy job-name click).
		if("job_info")
			var/datum/job/job = SSjob?.GetJob(params["title"])
			if(job?.class_setup_examine)
				var/datum/class_info_menu/menu = new(job)
				menu.ui_interact(user)
			return TRUE

/// Refresh open character sheet UIs; called from ShowChoices() when the tgui sheet is active.
/datum/preferences/proc/charsheet_refresh(mob/user)
	SStgui.update_uis(src)
	update_preview_icon()
