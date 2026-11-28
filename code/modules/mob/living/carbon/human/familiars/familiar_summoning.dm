/// proc for pulling a ghost in, creating a mob according to their prefs, then returning the new mob. summontype is used in the verbiage of some to_chats. plane must be a valid plane ("fae" "elemental" "infernal" or "void" currently)
/proc/awaken_familiar(mob/living/carbon/human/user, plane, summontype, where)
	var/list/candidates = pollGhostCandidates("Do you want to play as a [summontype] for [user.real_name] ([user.get_role_title()])? You will materialize as [(plane == "infernal" || plane == "elemental")?"an":"a"] [plane] familiar.", ROLE_FAMILIAR, null, null, 10 SECONDS, POLL_IGNORE_MAGE_SUMMON)
	if(!LAZYLEN(candidates))
		to_chat(user,span_warning("No candidate players available."))
		return FALSE
	var/list/preferred_candidates = list()
	for(var/mob/candidate in candidates)
		var/client/client_ref = candidate.client
		if(client_ref && client_ref.prefs && client_ref.prefs.familiar_prefs)
			if(!client_ref.prefs.familiar_prefs.familiar_species) // this is an old familiar prefs object again, woe! fix that shit
				client_ref.prefs.familiar_prefs.New(client_ref.prefs)
				to_chat(candidate, span_warning("Set your familiar prefs to be summoned as a [summontype]!"))
				continue // we skip the rest of the checks because they are not going to have prefs
			if(client_ref.prefs.familiar_prefs.familiar_species[plane] && client_ref.prefs.familiar_prefs.familiar_names[plane])
				if(client_ref.prefs.familiar_prefs.familiar_names[plane] in GLOB.chosen_names)
					// special case: realname conflict
					to_chat(client_ref, span_warning("Your familiar's name is already claimed, this round!"))
				else
					// you have all the required fields set for a familiar of this type, congrats you can be summoned
					preferred_candidates += candidate
		else
			// if not, we give you a hint to set your prefs so you can be summoned
			to_chat(candidate,span_warning("Set your familiar prefs to be summoned as a [summontype]!"))
	if(LAZYLEN(preferred_candidates)) // we found someone with settings for the correct planar origin: it's go time
		var/list/familiar_choices = list()
		for(var/mob/famcand in preferred_candidates)
			var/fam_species = GLOB.familiar_display_names[famcand.client.prefs.familiar_prefs.familiar_species[plane]]
			familiar_choices["[famcand.client.prefs.familiar_prefs.familiar_names[plane]] ([fam_species])"] = famcand
		var/pretty_choice = (length(familiar_choices) == 1 ? familiar_choices[1] : tgui_input_list(user,"Select a candidate to summon","ACROSS THE VEIL", familiar_choices))
		if(!pretty_choice)
			return FALSE // this can only happen iffff the summoner disconnects at a bad time so we handle it gracefully
		var/mob/chosen = familiar_choices[pretty_choice]
		if(!chosen) //what the fuck
			to_chat(user, span_warning("Chosen target not found; maybe they disconnected?"))
			return FALSE
		var/mob/living/carbon/human/species/familiar/fam = chosen.summon_as_familiar(plane, user, where)
		if(fam)
			log_game("[key_name(user)] has summoned [key_name(chosen)] as '[fam.name]' ([initial(fam.name)]), \a [summontype].")
			return fam
	return FALSE // no candidates: sorry, no luck

/// plane: see familiars.dm in defines for valid values. user: technically optional for debugging. where: if it's null they'll be sent to nullspace so make sure you can get them out
/mob/proc/summon_as_familiar(plane, mob/living/carbon/human/user, where)
	var/datum/familiar_prefs/prefs = client?.prefs?.familiar_prefs
	if(!istype(prefs)) // uh oh
		to_chat(user, span_warning("Summoning failed: target has no valid familiar prefs, somehow."))
		return FALSE
	stop_sound_channel(CHANNEL_LOBBYMUSIC)
	var/to_summon = prefs.familiar_species[plane]
	var/mob/living/carbon/human/species/familiar/fam = new to_summon(where)
	fam.familiar_summoner = user
	fam.fully_replace_character_name(null, prefs.familiar_names[plane])
	fam.pronouns = (prefs.familiar_pronouns[plane] || THEY_THEM)
	fam.voice_color = prefs.familiar_voice_colors[plane]
	fam.gender = FEMALE // allows them to wear clothing, needed because of legacy code. i hate - whatever
	fam.visible_message(span_notice("[fam.summoning_emote]"))
	if(isnewplayer(src))
		var/mob/dead/new_player/new_src = src
		new_src.close_spawn_windows()
	if(!key)
		to_chat(user, span_warning("Summoning failed: src candidate has no key!"))
		return FALSE
	fam.key = src.key
	var/datum/mind/mind_datum = fam.mind
	if(!mind_datum)
		to_chat(user, span_warning("Summoning failed: mind transfer failed"))
		return FALSE
	if(fam.client)
		remove_verb(fam.client, GLOB.ghost_verbs)
	fam.client?.init_verbs()
	mind_datum.RemoveAllSpells()
	if(user)
		mind_datum.AddSpell(new /datum/action/cooldown/spell/message_summoner())
		user.mind?.AddSpell(new /datum/action/cooldown/spell/message_familiar())
	if(fam.inherent_spell)
		for(var/spell_path in fam.inherent_spell)
			if(ispath(spell_path))
				var/datum/action/cooldown/spell/spell_instance = new spell_path
				if(spell_instance)
					mind_datum.AddSpell(spell_instance)
	fam.cmode = FALSE
	fam.mind.i_know_person(user)
	user?.mind?.i_know_person(fam)
	fam.STASPD = min((user?.STASPD || 10), 20) // so they can always keep up with their summoner
	var/faction_to_add = "[user?.mind?.current.real_name]_faction"
	fam.faction |= faction_to_add
	GLOB.chosen_names += fam.real_name
	GLOB.character_ckey_list[fam.real_name] = fam.ckey
	return fam
