/datum/preferences/proc/ui_act_character_creator_identity(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("real_name")
			var/new_name = tgui_input_text(user, "The name of this vessel?", "IDENTITY", real_name, encode = FALSE)
			if(new_name)
				new_name = reject_bad_name(new_name)
				if(new_name)
					verbose_pref_log_change(user, "notice", "Real Name", real_name, new_name)
					real_name = new_name
				else
					to_chat(user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ', . and ,."))
			return CHARACTER_ACT_DATA_UPDATE

		if("randomize_real_name")
			var/randomized = pref_species.random_name(gender, TRUE)
			verbose_pref_log_change(user, "notice", "Real Name", real_name, "[randomized] (randomized)")
			real_name = randomized
			return CHARACTER_ACT_DATA_UPDATE

		if("randomize_normal")
			if(!COOLDOWN_FINISHED(src, ui_refresh_cooldown))
				to_chat(user, span_warning("You must wait before randomizing again."))
				return
			COOLDOWN_START(src, ui_refresh_cooldown, 2.5 SECONDS)
			verbose_pref_log_notification(user, "danger", "Randomized character with profile: Normal")
			random_character(null, RANDOMIZE_NORMAL)
			return CHARACTER_ACT_PREVIEW_UPDATE

		if("randomize_full")
			if(!COOLDOWN_FINISHED(src, ui_refresh_cooldown))
				to_chat(user, span_warning("You must wait before randomizing again."))
				return
			COOLDOWN_START(src, ui_refresh_cooldown, 5 SECONDS)
			verbose_pref_log_notification(user, "danger", "Randomized character with profile: Full")
			random_character(null, RANDOMIZE_NEW_CHARACTER)
			return CHARACTER_ACT_PREVIEW_UPDATE

		if("nickname")
			var/new_name = tgui_input_text(user, "Choose your character's nickname (For Highlighting):", "NICKNAME", nickname, encode = FALSE)
			if(new_name)
				new_name = reject_bad_name(new_name)
				if(new_name)
					verbose_pref_log_change(user, "notice", "Nickname", nickname, new_name)
					nickname = new_name
				else
					to_chat(user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ', . and ,."))
			return CHARACTER_ACT_DATA_UPDATE

		if("highlight_color")
			var/new_color = tgui_color_picker(user, "Choose your character's nickname highlight color:", "Highlight Color", highlight_color)
			if(new_color)
				verbose_pref_log_change(user, "notice", "Highlight Color", highlight_color, new_color)
				highlight_color = new_color
			return CHARACTER_ACT_DATA_UPDATE

		if("voice_color")
			var/new_voice = tgui_color_picker(user, "Choose your character's voice color:", "Voice Color", voice_color)
			if(new_voice)
				if(color_hex2num(new_voice) < 230)
					to_chat(user, span_warning("This voice color is too dark for mortals."))
					return
				verbose_pref_log_change(user, "notice", "Voice Color", voice_color, new_voice)
				voice_color = new_voice
			return CHARACTER_ACT_DATA_UPDATE

		if("pronouns")
			var/pronouns_input = tgui_input_list(user, "Choose your character's pronouns", "PRONOUNS", GLOB.pronouns_list, pronouns)
			if(pronouns_input)
				verbose_pref_log_change(user, "notice", "Pronouns", pronouns, pronouns_input)
				pronouns = pronouns_input
			return CHARACTER_ACT_DATA_UPDATE

		if("titles")
			handle_title_pref_selection(user)
			return CHARACTER_ACT_DATA_UPDATE

		if("clothespref")
			var/old = clothes_pref
			if(clothes_pref == CLOTHES_M)
				clothes_pref = CLOTHES_F
			else
				clothes_pref = CLOTHES_M
			verbose_pref_log_change(user, "notice", "Clothes", old, clothes_pref)
			return CHARACTER_ACT_DATA_UPDATE

		if("extra_language")
			var/list/choices = list("None")
			for(var/datum/language/language as anything in GLOB.languages_character_selection)
				if(language in pref_species.languages)
					continue
				choices[language::name] = language

			var/datum/language/current = extra_language
			var/chosen_language = tgui_input_list(user, "Choose your character's extra language:", "EXTRA LANGUAGE", choices, current::name)
			if(chosen_language)
				verbose_pref_log_change(user, "notice", "Extra Language", current::name, chosen_language)
				if(chosen_language == "None")
					extra_language = "None"
				else
					extra_language = choices[chosen_language]
			return CHARACTER_ACT_DATA_UPDATE

		if("age")
			var/new_age = tgui_input_list(user, "Choose your character's age (18-[pref_species.max_age])", "YILS LIVED", pref_species.possible_ages, age)
			if(new_age)
				verbose_pref_log_change(user, "notice", "Age", age, new_age)
				age = new_age
				switch(age)
					if(AGE_ADULT)
						to_chat(user, "You preside in your 'prime', whatever this may be, and gain no bonus nor endure any penalty for your time spent alive.")
					if(AGE_MIDDLEAGED)
						to_chat(user, "Muscles ache and joints begin to slow as Aeon's grasp begins to settle upon your shoulders. (-1 SPD, +1 WIL +1 FOR)")
					if(AGE_OLD)
						to_chat(user, "In a place as lethal as PSYDONIA, the elderly are all but marvels... or beneficiaries of the habitually privileged. (-1 STR, -2 SPE, -1 PER, -2 CON, +2 INT, +1 FOR)")
			return CHARACTER_ACT_DATA_UPDATE

		if("domhand")
			if(domhand == 1)
				domhand = 2
			else
				domhand = 1
			verbose_pref_log_change(user, "notice", "Dominant Hand", domhand == 1 ? "Right-handed" : "Left-handed", domhand == 2 ? "Right-handed" : "Left-handed")
			return CHARACTER_ACT_DATA_UPDATE

		if("dnr_pref")
			dnr_pref = !dnr_pref
			verbose_pref_log_change(user, "notice", "Do-Not-Revive Preference", !dnr_pref ? "Do Not Revive" : "Revive", dnr_pref ? "Do Not Revive" : "Revive")
			return CHARACTER_ACT_DATA_UPDATE

		if("set_culinary_axis")
			set_culinary_axis(params["axis"], text2num(params["flag"]))
			verbose_pref_log_notification(user, "notice", "Culinary axis [params["axis"]] changed")
			return CHARACTER_ACT_DATA_UPDATE

		if("familiar_prefs")
			familiar_prefs.fam_show_ui()
			return CHARACTER_ACT_DATA_UPDATE

		if("voicetype")
			var/voicetype_input = tgui_input_list(user, "Choose your character's voice type", "VOICE TYPE", GLOB.voice_types_list, voice_type)
			if(voicetype_input)
				verbose_pref_log_change(user, "notice", "Voice Type", LOWER_TEXT(voice_type), LOWER_TEXT(voicetype_input))
				voice_type = voicetype_input
			return CHARACTER_ACT_DATA_UPDATE

		if("set_voicepack")
			var/voicepack_input = params["voicepack"]
			if(!(voicepack_input in GLOB.voice_packs_list))
				return CHARACTER_ACT_DATA_UPDATE

			verbose_pref_log_change(user, "notice", "Voice Pack", voice_pack, voicepack_input)
			voice_pack = voicepack_input

			if(voice_pack != "Default")
				to_chat(user, span_warning("Your character will now audibly emote with a [LOWER_TEXT(voice_pack)] affect.") + span_notice("<br>This will override your Voice Identity and Class-specific voice packs."))
			else
				to_chat(user, span_warning("Your character will now audibly emote in accordance to their Voice Identity and any Racial / Class-specific voice packs."))
			return CHARACTER_ACT_DATA_UPDATE

		if("set_voice_pitch")
			var/new_voice_pitch = clamp(params["pitch"], MIN_VOICE_PITCH, MAX_VOICE_PITCH)
			verbose_pref_log_change(user, "notice", "Voice Pitch", voice_pitch, new_voice_pitch)
			voice_pitch = new_voice_pitch
			return CHARACTER_ACT_DATA_UPDATE

		if("voicepack_preview")
			var/datum/voicepack/VP = get_effective_voicepack()
			var/modifier
			if(age == AGE_OLD)
				modifier = "old"
			var/voiceline = VP.get_sound(pick(VP.preview), modifier)
			if(islist(voiceline) && length(voiceline) > 1)
				voiceline = pick(voiceline)
			user.playsound_local(user, voiceline, 100, frequency = voice_pitch)
			return CHARACTER_ACT_DATA_UPDATE

		if("voicepack_preview_emote")
			var/datum/voicepack/VP = get_effective_voicepack()
			var/modifier
			if(age == AGE_OLD)
				modifier = "old"

			var/emote_picked = tgui_input_list(user, "Choose emote to preview", "Voicepack Preview", VP.preview)
			if(emote_picked)
				var/voiceline = VP.get_sound(emote_picked, modifier)
				if(islist(voiceline) && length(voiceline) > 1)
					voiceline = pick(voiceline)
				user.playsound_local(user, voiceline, 100, frequency = voice_pitch)
			return CHARACTER_ACT_DATA_UPDATE

		if("subvirtue")
			return ui_act_character_creator_identity_subvirtue(action, params, ui, state)

		if("charflaw_averse_choice")
			var/choice = tgui_input_list(user, "Who do you loathe?", "AVERSION", GLOB.averse_factions, averse_chosen_faction)
			if(choice)
				verbose_pref_log_change(user, "notice", "Averse Chosen Faction", averse_chosen_faction, choice)
				averse_chosen_faction = choice
			return CHARACTER_ACT_DATA_UPDATE

		if("open_loadout")
			var/datum/loadout_menu/LM = new(user.client)
			LM.ui_interact(user)
			return CHARACTER_ACT_DATA_UPDATE

		if("set_barksound")
			var/new_bork = params["barksound"]

			var/list/woof_woof = list()
			for(var/id in GLOB.bark_list)
				var/datum/bark/B = GLOB.bark_list[id]
				if(B::ignore)
					continue
				woof_woof[B::name] = B

			if(!(new_bork in woof_woof))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/bark/old_bark = GLOB.bark_list[bark_id]
			var/datum/bark/new_bark = woof_woof[new_bork]

			bark_id = new_bark::id

			verbose_pref_log_change(user, "notice", "Vocal Bark", old_bark::name, new_bark::name)
			bark_speed = round(clamp(bark_speed, new_bark::minspeed, new_bark::maxspeed), 1)
			bark_pitch = clamp(bark_pitch, new_bark::minpitch, new_bark::maxpitch)
			bark_variance = clamp(bark_variance, new_bark::minvariance, new_bark::maxvariance)
			return CHARACTER_ACT_DATA_UPDATE

		if("set_bark_speed")
			var/datum/bark/B = GLOB.bark_list[bark_id]
			if(!B)
				to_chat(user, span_danger("ERROR: Vocal bark set to an invalid option."))
				return CHARACTER_ACT_DATA_UPDATE
			var/borkset = clamp(params["speed"], B::minspeed, B::maxspeed)
			verbose_pref_log_change(user, "notice", "Bark Speed", bark_speed, borkset)
			bark_speed = borkset
			return CHARACTER_ACT_DATA_UPDATE

		if("set_bark_pitch")
			var/datum/bark/B = GLOB.bark_list[bark_id]
			if(!B)
				to_chat(user, span_danger("ERROR: Vocal bark set to an invalid option."))
				return CHARACTER_ACT_DATA_UPDATE
			var/borkset = clamp(params["pitch"], B::minpitch, B::maxpitch)
			verbose_pref_log_change(user, "notice", "Bark Pitch", bark_pitch, borkset)
			bark_pitch = borkset
			return CHARACTER_ACT_DATA_UPDATE

		if("set_bark_variance")
			var/datum/bark/B = GLOB.bark_list[bark_id]
			if(!B)
				to_chat(user, span_danger("ERROR: Vocal bark set to an invalid option."))
				return CHARACTER_ACT_DATA_UPDATE
			var/borkset = clamp(params["variance"], B::minvariance, B::maxvariance)
			verbose_pref_log_change(user, "notice", "Bark Variance", bark_variance, borkset)
			bark_variance = borkset
			return CHARACTER_ACT_DATA_UPDATE

		if("barkpreview")
			var/datum/bark/B = GLOB.bark_list[bark_id]
			if(!B)
				to_chat(user, span_danger("ERROR: Vocal bark set to an invalid option."))
				return CHARACTER_ACT_DATA_UPDATE
			if(!B::soundpath)
				to_chat(user, span_warning("Your current bark has no sound."))
				return CHARACTER_ACT_DATA_UPDATE

			user.playsound_local(user, B::soundpath, vol = 100, vary = TRUE, frequency = BARK_DO_VARY(bark_pitch, bark_variance))
			return CHARACTER_ACT_DATA_UPDATE

		if("barkpreview_long")
			var/datum/bark/B = GLOB.bark_list[bark_id]
			if(!B)
				to_chat(user, span_danger("ERROR: Vocal bark set to an invalid option."))
				return CHARACTER_ACT_DATA_UPDATE
			if(!B::soundpath)
				to_chat(user, span_warning("Your current bark has no sound."))
				return CHARACTER_ACT_DATA_UPDATE

			var/total_delay = 0
			for(var/i in 1 to (round((32 / bark_speed)) + 1))
				addtimer(CALLBACK(src, PROC_REF(preview_bark), user, B::soundpath, BARK_DO_VARY(bark_pitch, bark_variance)), total_delay)
				total_delay += rand(DS2TICKS(bark_speed/4), DS2TICKS(bark_speed/4) + DS2TICKS(bark_speed/4)) TICKS
			return CHARACTER_ACT_DATA_UPDATE

/datum/preferences/proc/preview_bark(mob/user, soundpath, pitch)
	user.playsound_local(user, soundpath, vol = 100, vary = TRUE, frequency = pitch)

/datum/preferences/proc/process_virtue_text(datum/virtue/V)
	var/dat
	if(V.desc)
		dat += "<font size = 3>[span_purple(V.desc)]</font><br>"
	if(length(V.added_skills))
		if(istype(V, /datum/virtue/origin))
			dat += "<font color = '#a3e2ff'><font size = 3>This Origin adds the following skills: <br>"
		else
			dat += "<font color = '#a3e2ff'><font size = 3>This Virtue adds the following skills: <br>"
		for(var/list/L in V.added_skills)
			var/name
			if(ispath(L[1],/datum/skill))
				var/datum/skill/S = L[1]
				name = initial(S.name)
			dat += "["\Roman[L[2]]"] level[L[2] > 1 ? "s" : ""] of <b>[name]</b>[L[3] ? ", up to <b>[SSskills.level_names_plain[L[3]]]</b>" : ""] <br>"
		dat += "</font>"
	if(V.softcap)
		dat += "<font color = '#a3e2ff'><font size = 3>This is soft capped, and values will give only 1 level above the skill cap<br></font>"
	if(length(V.added_traits))
		if(istype(V, /datum/virtue/origin))
			dat += "<font color = '#a3e2ff'><font size = 3>This Origin grants the following traits: <br>"
		else
			dat += "<font color = '#a3ffe0'><font size = 3>This Virtue grants the following traits: <br>"
		for(var/TR in V.added_traits)
			dat += "[TR] — <font size = 2>[GLOB.roguetraits[TR]]</font><br>"
		dat += "</font>"
	if(length(V.added_stashed_items))
		if(istype(V, /datum/virtue/origin))
			dat += "<font color = '#a3e2ff'><font size = 3>This Origin adds the following items to your stash: <br>"
		else
			dat += "<font color = '#eeffa3'><font size = 3>This Virtue adds the following items to your stash: <br>"
		for(var/I in V.added_stashed_items)
			dat += "<i>[I]</i> <br>"
		dat += "</font>"
	if(length(V.added_languages))
		dat += "<font color ='#a3e2ff'><font size = 3>This [istype(V, /datum/virtue/origin) ? "Origin" : "Virtue"] adds the following languages: <br>"
		for(var/L in V.added_languages)
			var/datum/language/lang = L
			dat += "<i>[initial(lang.name)]</i> <br>"
		dat += "</font>"
	if(V.custom_text)
		if(istype(V, /datum/virtue/origin))
			dat += "<font color = '#a3e2ff'><font size = 3>This Origin has this special behaviour: <br>"
		else
			dat += "<font color = '#ffffff'><font size = 3>This Virtue has this special behaviour: <br>"
		dat += "[V.custom_text]"
		dat += "</font>"
	if(V.stackable)
		dat += "<font color = '#ffeea3'>This virtue can be picked twice using Virtuous.</font><br>"
	return dat

/datum/preferences/proc/handle_title_pref_selection(mob/user)
	var/old = titles_pref
	if(titles_pref == TITLES_M)
		titles_pref = TITLES_F
	else
		titles_pref = TITLES_M
	verbose_pref_log_change(user, "notice", "Titles", old, titles_pref)

// INSTRUCTIONS FOR DOWNSTREAM: put this in your modular folder
// /datum/preferences/handle_title_pref_selection(mob/user)
// 	// do NOT call parent
// 	var/old = titles_pref
// 	// tgui_input_list or whatever
// 	verbose_pref_log_change(user, "notice", "Titles", old, titles_pref)


/datum/preferences/proc/ui_act_character_creator_identity_subvirtue(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	// Note: we are always allowed to select whatever we want for virtuetwo,
	// as apply_prefs_virtue will just ignore it if we're not virtuous.
	var/id = params["id"]
	if(!validate_virtue_index(id))
		return CHARACTER_ACT_DATA_UPDATE

	var/datum/virtue/relevant_virtue = get_virtue_by_index(id)
	if(!relevant_virtue)
		return CHARACTER_ACT_DATA_UPDATE

	var/task = params["task"]
	switch(task)
		if("add")
			if(length(relevant_virtue.picked_choices) < relevant_virtue.max_choices)
				var/list/subchoices = relevant_virtue.extra_choices.Copy()
				for(var/choice in subchoices)
					if(choice in relevant_virtue.picked_choices)
						subchoices.Remove(choice)
				var/result = tgui_input_list(user, "What strength shall you wield?", "VIRTUES", subchoices)
				if(result)
					var/old = relevant_virtue.picked_choices.Join(", ")
					relevant_virtue.picked_choices.Add(result)
					verbose_pref_log_change(user, "notice", "[relevant_virtue.name] strength added", old, relevant_virtue.picked_choices.Join(", "))
		if("remove")
			var/index = text2num(params["index"])
			if(index && (index >= 1) && (index <= relevant_virtue.picked_choices.len))
				var/v_to_remove = relevant_virtue.picked_choices[index]
				var/old = relevant_virtue.picked_choices.Join(", ")
				relevant_virtue.picked_choices.Remove(v_to_remove)
				verbose_pref_log_change(user, "notice", "[relevant_virtue.name] strength removed", old, relevant_virtue.picked_choices.Join(", "))

	return CHARACTER_ACT_DATA_UPDATE
