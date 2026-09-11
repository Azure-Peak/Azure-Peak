/datum/preferences/proc/ui_act_character_creator_villain(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("lich_headshot")
			to_chat(user, span_notice("Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
			to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
			to_chat(user, span_notice("Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look."))
			var/new_lich_headshot_link = tgui_input_text(user, "Input the Lich headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox, file garden):", "Lich Headshot", lich_headshot_link, max_length = MAX_MESSAGE_LEN, encode = FALSE)
			if(new_lich_headshot_link == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_lich_headshot_link == "")
				verbose_pref_log_change(user, "notice", "Lich Headshot", html_encode(lich_headshot_link), "")
				lich_headshot_link = null
				return CHARACTER_ACT_DATA_UPDATE
			if(!valid_headshot_link(user, new_lich_headshot_link))
				to_chat(user, span_notice("Invalid image link. Make sure it's a direct link from a valid host (gyazo, discord, lensdump, imgbox, catbox, file garden)."))
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Lich Headshot", html_encode(lich_headshot_link), html_encode(new_lich_headshot_link))
			lich_headshot_link = new_lich_headshot_link
			to_chat(user, span_notice("Successfully updated lich headshot picture"))
			log_game("[user] has set their lich Headshot image to '[html_encode(lich_headshot_link)]'.")
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_headshot")
			to_chat(user, span_notice("Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
			to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
			to_chat(user, span_notice("Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look."))
			var/new_vampire_headshot_link = tgui_input_text(user, "Input the vampire headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox, file garden):", "Vampire Headshot", vampire_headshot_link, max_length = MAX_MESSAGE_LEN, encode = FALSE)
			if(new_vampire_headshot_link == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_vampire_headshot_link == "")
				verbose_pref_log_change(user, "notice", "Vampire Headshot", html_encode(vampire_headshot_link), "")
				vampire_headshot_link = null
				return CHARACTER_ACT_DATA_UPDATE
			if(!valid_headshot_link(user, new_vampire_headshot_link))
				to_chat(user, span_notice("Invalid image link. Make sure it's a direct link from a valid host (gyazo, discord, lensdump, imgbox, catbox, file garden)."))
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Vampire Headshot", html_encode(vampire_headshot_link), html_encode(new_vampire_headshot_link))
			vampire_headshot_link = new_vampire_headshot_link
			log_game("[user] has set their vampire Headshot image to '[html_encode(vampire_headshot_link)]'.")
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_hair")
			var/new_vampirehair = tgui_color_picker(user, "Choose your character's vampire hair color:", "Vampire Hair Color", vampire_hair)
			if(new_vampirehair)
				verbose_pref_log_change(user, "notice", "Vampire Hair", vampire_hair, new_vampirehair)
				vampire_hair = new_vampirehair
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_eyes")
			var/new_vampireeyes = tgui_color_picker(user, "Choose your character's vampire eye color:", "Vampire Eye Color", vampire_eyes)
			if(new_vampireeyes)
				verbose_pref_log_change(user, "notice", "Vampire Eyes", vampire_eyes, new_vampireeyes)
				vampire_eyes = new_vampireeyes
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_skin")
			var/new_vampireskin = tgui_color_picker(user, "Choose your character's vampire skin color:", "Vampire Skin Color", vampire_skin)
			if(new_vampireskin)
				verbose_pref_log_change(user, "notice", "Vampire Skin", vampire_skin, new_vampireskin)
				vampire_skin = new_vampireskin
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_ears")
			var/new_vampireears = tgui_color_picker(user, "Choose your character's vampire ear color:", "Vampire Ear Color", vampire_ears)
			if(new_vampireears)
				verbose_pref_log_change(user, "notice", "Vampire Ears", vampire_ears, new_vampireears)
				vampire_ears = new_vampireears
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_hair_clear")
			verbose_pref_log_change(user, "notice", "Vampire Hair", vampire_hair, "")
			vampire_hair = null
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_eyes_clear")
			verbose_pref_log_change(user, "notice", "Vampire Eyes", vampire_eyes, "")
			vampire_eyes = null
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_skin_clear")
			verbose_pref_log_change(user, "notice", "Vampire Skin", vampire_skin, "")
			vampire_skin = null
			return CHARACTER_ACT_DATA_UPDATE

		if("vampire_ears_clear")
			verbose_pref_log_change(user, "notice", "Vampire Ears", vampire_ears, "")
			vampire_ears = null
			return CHARACTER_ACT_DATA_UPDATE

		if("qsr_pref")
			qsr_pref = !qsr_pref
			verbose_pref_log_change(user, "notice", "Quicksilver Resistance", !qsr_pref ? "Yes" : "No", qsr_pref ? "Yes" : "No")
			return CHARACTER_ACT_DATA_UPDATE

		if("preset_bounty_toggle")
			preset_bounty_enabled = !preset_bounty_enabled
			verbose_pref_log_change(user, "notice", "Preset Bounty Enabled", !preset_bounty_enabled ? "Yes" : "No", preset_bounty_enabled ? "Yes" : "No")
			return CHARACTER_ACT_DATA_UPDATE

		if("preset_bounty_poster_key")
			var/list/poster_choices = list()
			for(var/key in GLOB.bounty_posters)
				poster_choices[GLOB.bounty_posters[key]] = key
			var/choice = tgui_input_list(user, "Who placed a bounty on you?", "Bounty Poster", poster_choices, GLOB.bounty_posters[preset_bounty_poster_key])
			if(choice)
				verbose_pref_log_change(user, "notice", "Bounty Poster", GLOB.bounty_posters[preset_bounty_poster_key], choice)
				preset_bounty_poster_key = poster_choices[choice]
			return CHARACTER_ACT_DATA_UPDATE

		if("preset_bounty_severity_key")
			var/list/sev_choices = list()
			for(var/key in GLOB.wretch_severities)
				sev_choices[GLOB.wretch_severities[key]] = key
			var/choice = tgui_input_list(user, "How severe are your crimes?", "Wretch Bounty Amount", sev_choices, GLOB.wretch_severities[preset_bounty_severity_key])
			if(choice)
				verbose_pref_log_change(user, "notice", "Bounty Amount", GLOB.wretch_severities[preset_bounty_severity_key], choice)
				preset_bounty_severity_key = sev_choices[choice]
			return CHARACTER_ACT_DATA_UPDATE

		if("preset_bounty_severity_b_key")
			var/list/sev_choices = list()
			for(var/key in GLOB.bandit_severities)
				sev_choices[GLOB.bandit_severities[key]] = key
			var/choice = tgui_input_list(user, "How notorious are you?", "Bounty Amount", sev_choices, GLOB.bandit_severities[preset_bounty_severity_b_key])
			if(choice)
				verbose_pref_log_change(user, "notice", "Bandit Bounty Amount", GLOB.bandit_severities[preset_bounty_severity_b_key], choice)
				preset_bounty_severity_b_key = sev_choices[choice]
			return CHARACTER_ACT_DATA_UPDATE

		if("preset_bounty_severity_v_key")
			var/list/sev_choices = list()
			for(var/key in GLOB.vagabond_severities)
				sev_choices[GLOB.vagabond_severities[key]] = key
			var/choice = tgui_input_list(user, "How notorious are you?", "Bounty Amount", sev_choices, GLOB.vagabond_severities[preset_bounty_severity_v_key])
			if(choice)
				verbose_pref_log_change(user, "notice", "Vagabound Bounty Amount", GLOB.vagabond_severities[preset_bounty_severity_v_key], choice)
				preset_bounty_severity_v_key = sev_choices[choice]
			return CHARACTER_ACT_DATA_UPDATE

		if("preset_bounty_crime")
			var/new_crime = tgui_input_text(user, "What is your crime?", "Crime", preset_bounty_crime, max_length = MAX_NOTE_SIZE)
			if(new_crime == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_crime == "")
				verbose_pref_log_change(user, "notice", "Bounty Crime", "[length(preset_bounty_crime)] characters", "0 characters")
				preset_bounty_crime = null
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Bounty Crime", "[length(preset_bounty_crime)] characters", "[length(new_crime)] characters")
			preset_bounty_crime = new_crime
			return CHARACTER_ACT_DATA_UPDATE
