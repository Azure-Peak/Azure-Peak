#define SONGBOOK_UNLEARN_COOLDOWN 2 MINUTES

GLOBAL_LIST_INIT(learnable_songs, list(
	// Buff Melodies
	/datum/action/cooldown/spell/song/furtive_fortissimo,
	/datum/action/cooldown/spell/song/resolute_refrain,
	/datum/action/cooldown/spell/song/intellectual_interval,
	/datum/action/cooldown/spell/song/fervor_song,
	/datum/action/cooldown/spell/song/recovery_song,
	/datum/action/cooldown/spell/song/accelakathist,
	/datum/action/cooldown/spell/song/rejuvenation_song,
	// Debuff Dirges
	/datum/action/cooldown/spell/song/discordant_dirge,
	/datum/action/cooldown/spell/song/enervating_elegy,
	/datum/action/cooldown/spell/song/rattling_requiem,
))

/mob/living/carbon/human/proc/open_songbook()
	set name = "Songbook"
	set category = "Inspiration"

	if(!inspiration)
		return
	if(!mind)
		return
	var/datum/songbook_ui/picker = new(src)
	picker.ui_interact(src)

// ---- Songbook TGUI Backend ----

/datum/songbook_ui
	var/mob/living/carbon/human/owner

/datum/songbook_ui/New(mob/living/carbon/human/H)
	. = ..()
	owner = H

/datum/songbook_ui/Destroy()
	owner = null
	return ..()

/datum/songbook_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/songbook_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BardSongbook", "Songbook")
		ui.open()

/datum/songbook_ui/proc/can_unlearn()
	if(!owner)
		return FALSE
	var/last_unlearn = owner.mob_timers["songbook_unlearn"]
	if(last_unlearn && world.time < last_unlearn + SONGBOOK_UNLEARN_COOLDOWN)
		return FALSE
	return TRUE

/datum/songbook_ui/ui_data(mob/user)
	var/list/data = list()

	// Songs
	var/list/song_list = list()
	for(var/songpath in GLOB.learnable_songs)
		var/datum/action/cooldown/spell/song/S = songpath
		var/already_known = FALSE
		if(owner?.mind)
			for(var/datum/action/cooldown/spell/song/known in owner.mind.spell_list)
				if(known.type == songpath)
					already_known = TRUE
					break
		song_list += list(list(
			"name" = initial(S.name),
			"desc" = initial(S.desc),
			"type_path" = "[songpath]",
			"known" = already_known,
		))
	data["songs"] = song_list
	data["song_slots_remaining"] = owner?.inspiration ? (owner.inspiration.maxsongs - owner.inspiration.songsbought) : 0

	// Rhythms
	var/list/rhythm_list = list()
	var/list/available_rhythms = list(
		/datum/action/cooldown/spell/rhythm/resonating,
		/datum/action/cooldown/spell/rhythm/concussive,
		/datum/action/cooldown/spell/rhythm/frigid,
	)
	if(owner?.inspiration?.level >= BARD_T2)
		available_rhythms += /datum/action/cooldown/spell/rhythm/regenerating

	var/list/existing_rhythm_types = list()
	if(owner?.mind)
		for(var/datum/action/cooldown/spell/rhythm/existing in owner.mind.spell_list)
			existing_rhythm_types += existing.type

	for(var/rhythm_path in available_rhythms)
		var/datum/action/cooldown/spell/rhythm/R = rhythm_path
		rhythm_list += list(list(
			"name" = initial(R.name),
			"desc" = initial(R.desc),
			"type_path" = "[rhythm_path]",
			"known" = (rhythm_path in existing_rhythm_types),
		))

	var/max_picks = owner?.inspiration?.level >= BARD_T2 ? RHYTHM_PICKS_T2 : RHYTHM_PICKS_T1
	data["rhythms"] = rhythm_list
	data["rhythm_slots_remaining"] = max_picks - existing_rhythm_types.len
	data["can_unlearn"] = can_unlearn()
	if(!can_unlearn())
		var/last_unlearn = owner.mob_timers["songbook_unlearn"]
		var/remaining = round((last_unlearn + SONGBOOK_UNLEARN_COOLDOWN - world.time) / 10)
		var/mins = round(remaining / 60)
		var/secs = remaining % 60
		data["unlearn_cooldown_text"] = "On cooldown ([mins]m [secs]s)"
	else
		data["unlearn_cooldown_text"] = ""
	return data

/datum/songbook_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("learn_song")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			if(owner.inspiration.songsbought >= owner.inspiration.maxsongs)
				return TRUE
			var/song_path = text2path(params["type_path"])
			if(!song_path || !(song_path in GLOB.learnable_songs))
				return TRUE
			for(var/datum/action/cooldown/spell/song/known in owner.mind.spell_list)
				if(known.type == song_path)
					return TRUE
			var/datum/action/cooldown/spell/song/new_song = new song_path
			owner.mind.AddSpell(new_song)
			owner.inspiration.songsbought += 1
			return TRUE

		if("unlearn_song")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			if(!can_unlearn())
				to_chat(owner, span_warning("I need more time before I can forget another song."))
				return TRUE
			var/song_path = text2path(params["type_path"])
			if(!song_path || !(song_path in GLOB.learnable_songs))
				return TRUE
			// Cancel active song if playing
			for(var/datum/status_effect/buff/playing_melody/melody in owner.status_effects)
				owner.remove_status_effect(melody)
			for(var/datum/status_effect/buff/playing_dirge/dirge in owner.status_effects)
				owner.remove_status_effect(dirge)
			owner.mind.RemoveSpell(song_path)
			owner.inspiration.songsbought = max(0, owner.inspiration.songsbought - 1)
			owner.mob_timers["songbook_unlearn"] = world.time
			to_chat(owner, span_info("I forget the melody..."))
			return TRUE

		if("learn_rhythm")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			var/rhythm_path = text2path(params["type_path"])
			if(!rhythm_path)
				return TRUE
			var/list/valid = list(
				/datum/action/cooldown/spell/rhythm/resonating,
				/datum/action/cooldown/spell/rhythm/concussive,
				/datum/action/cooldown/spell/rhythm/frigid,
				/datum/action/cooldown/spell/rhythm/regenerating,
			)
			if(!(rhythm_path in valid))
				return TRUE
			for(var/datum/action/cooldown/spell/rhythm/existing in owner.mind.spell_list)
				if(existing.type == rhythm_path)
					return TRUE
			var/max_picks = owner.inspiration.level >= BARD_T2 ? RHYTHM_PICKS_T2 : RHYTHM_PICKS_T1
			var/existing_count = 0
			for(var/datum/action/cooldown/spell/rhythm/R in owner.mind.spell_list)
				existing_count++
			if(existing_count >= max_picks)
				return TRUE

			if(!owner.inspiration.rhythm_tracker)
				owner.inspiration.rhythm_tracker = new /datum/rhythm_tracker()

			var/datum/action/cooldown/spell/rhythm/new_rhythm = new rhythm_path()
			new_rhythm.tracker = owner.inspiration.rhythm_tracker
			owner.mind.AddSpell(new_rhythm)
			to_chat(owner, span_info("I attune my blade to the [new_rhythm.name] rhythm."))

			// Grant Crescendo to T2 bards after all rhythm picks
			if((existing_count + 1) >= max_picks)
				if(owner.inspiration.level >= BARD_T2 && !owner.inspiration.rhythm_tracker.crescendo_action)
					var/datum/action/cooldown/spell/crescendo/C = new()
					C.tracker = owner.inspiration.rhythm_tracker
					owner.inspiration.rhythm_tracker.crescendo_action = C
					owner.mind.AddSpell(C)
			return TRUE

		if("unlearn_rhythm")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			if(!can_unlearn())
				to_chat(owner, span_warning("I need more time before I can forget another rhythm."))
				return TRUE
			var/rhythm_path = text2path(params["type_path"])
			if(!rhythm_path)
				return TRUE
			// Cancel prime if active
			for(var/datum/action/cooldown/spell/rhythm/R in owner.mind.spell_list)
				if(R.type == rhythm_path)
					if(R.primed)
						R.rhythm_fizzle()
					break
			owner.mind.RemoveSpell(rhythm_path)
			owner.mob_timers["songbook_unlearn"] = world.time
			// Clean up Crescendo if no rhythms remain
			var/rhythm_count = 0
			for(var/datum/action/cooldown/spell/rhythm/R in owner.mind.spell_list)
				rhythm_count++
			if(rhythm_count == 0 && owner.inspiration.rhythm_tracker)
				if(owner.inspiration.rhythm_tracker.crescendo_action)
					owner.mind.RemoveSpell(/datum/action/cooldown/spell/crescendo)
					owner.inspiration.rhythm_tracker.crescendo_action = null
				QDEL_NULL(owner.inspiration.rhythm_tracker)
			to_chat(owner, span_info("I forget the rhythm..."))
			return TRUE

#undef SONGBOOK_UNLEARN_COOLDOWN
