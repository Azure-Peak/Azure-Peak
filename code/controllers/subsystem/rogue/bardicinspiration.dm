// Unified Songbook - all songs available to all bard tiers, effect strength scales by tier
GLOBAL_LIST_INIT(learnable_songs, list(
	// Buff Melodies
	/datum/action/cooldown/spell/song/furtive_fortissimo,
	/datum/action/cooldown/spell/song/resolute_refrain,
	/datum/action/cooldown/spell/song/fervor_song,
	/datum/action/cooldown/spell/song/recovery_song,
	/datum/action/cooldown/spell/song/accelakathist,
	/datum/action/cooldown/spell/song/rejuvenation_song,
	// Debuff Dirges
	/datum/action/cooldown/spell/song/discordant_dirge,
	/datum/action/cooldown/spell/song/enervating_elegy,
	/datum/action/cooldown/spell/song/rattling_requiem,
))

/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 3
	var/list/audience = list()
	var/maxsongs = 2
	var/songsbought = 0
	var/learning_song = FALSE
	var/datum/rhythm_tracker/rhythm_tracker = null

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
	QDEL_NULL(rhythm_tracker)
	STOP_PROCESSING(SSobj, src)

/mob/living/carbon/human/proc/in_audience(mob/living/carbon/human/audiencee)
	if(!src.mind)
		return FALSE
	if(!src.inspiration)
		return FALSE
	if(audiencee in src.inspiration.audience)
		return TRUE
	return FALSE

/datum/inspiration/proc/grant_inspiration(mob/living/carbon/human/H, bard_tier)
	if(!H || !H.mind)
		return
	level = bard_tier
	switch(bard_tier)
		if(BARD_T1)
			maxaudience = 4
			maxsongs = 2
		if(BARD_T2)
			maxaudience = 6
			maxsongs = 4
	audience |= H // Bard is always in their own audience
	H.verbs += list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs, /mob/living/carbon/human/proc/pickrhythm, /mob/living/carbon/human/proc/explain_bard)

/mob/living/carbon/human/proc/setaudience()
	set name = "Audience Choice"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	// Self doesn't count toward audience cap
	var/audience_count = inspiration.audience.len - 1 // -1 for self
	if(audience_count >= inspiration.maxaudience)
		to_chat(src, "I cannot maintain an audience larger than [inspiration.maxaudience]!")
		return FALSE
	var/list/folksnearby = list()
	for(var/mob/living/carbon/human/folks in view(7, loc))
		if(folks == src) // Can't add self, already always included
			continue
		if(!src.in_audience(folks))
			folksnearby += folks

	if(!folksnearby)
		return
	var/target = tgui_input_list(src, "Who will you perform for?", "Audience Choice", folksnearby)
	if(target)
		inspiration.audience |= target

	return TRUE

/mob/living/carbon/human/proc/clearaudience()
	set name = "Clear Audience"
	set category = "Inspiration"
	if(!inspiration)
		return FALSE
	if(src.has_status_effect(/datum/status_effect/buff/playing_melody) || src.has_status_effect(/datum/status_effect/buff/playing_dirge)) // cant clear while a song is active
		return
	inspiration.audience = list(src) // Keep self in audience

	return TRUE

/mob/living/carbon/human/proc/checkaudience()
	set name = "Check Audience"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	var/text = ""
	for(var/mob/living/carbon/human/folks in inspiration.audience)
		text += "[folks.real_name], "
	if(!text)
		return
	to_chat(src, "My audience members are: [text]")
	return TRUE

/mob/living/carbon/human/proc/explain_bard()
	set name = "Explain Bardic Inspiration"
	set category = "Inspiration"
	if(!inspiration)
		return FALSE
	var/tier_name = inspiration.level == BARD_T2 ? "Full Bard" : "Lesser Bard"
	to_chat(src, span_info("Bardic Inspiration allows you to inspire your allies with music. \
	Set your audience using the 'Audience Choice' verb, then select songs from your Songbook using 'Fill Songbook'. \
	To activate a song, hold an instrument in one hand and toggle the song from your action bar. \
	Songs are mutually exclusive - activating a new song replaces the current one."))
	to_chat(src, span_info("Rhythm: Choose a rhythm style with 'Choose Rhythm'. Activate a rhythm, then strike within 8 seconds to proc its effect. \
	All rhythms share a cooldown. Full Bards can build toward a Crescendo - a powerful cone attack after 3 rhythm procs."))
	to_chat(src, span_smallnotice("You're a [tier_name] and can have up to [inspiration.maxaudience] audience members and know [inspiration.maxsongs] songs."))

	return TRUE

/datum/inspiration/New(mob/living/carbon/human/holder)
	. = ..()
	src.holder = holder
	holder?.inspiration = src
	ADD_TRAIT(holder, TRAIT_INSPIRING_MUSICIAN, "inspiration")

/mob/living/carbon/human/proc/picksongs()
	set name = "Fill Songbook"
	set category = "Inspiration"

	if(!inspiration)
		return
	if(!mind)
		return
	if(inspiration.songsbought >= inspiration.maxsongs)
		to_chat(src, span_warning("My songbook is full! I already know [inspiration.maxsongs] songs."))
		return

	var/datum/songbook_picker/picker = new(src)
	picker.ui_interact(src)

// ---- Songbook TGUI Picker ----

/datum/songbook_picker
	var/mob/living/carbon/human/owner

/datum/songbook_picker/New(mob/living/carbon/human/H)
	. = ..()
	owner = H

/datum/songbook_picker/Destroy()
	owner = null
	return ..()

/datum/songbook_picker/ui_state(mob/user)
	return GLOB.always_state

/datum/songbook_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BardSongbook", "Songbook")
		ui.open()

/datum/songbook_picker/ui_data(mob/user)
	var/list/data = list()
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
	data["slots_remaining"] = owner?.inspiration ? (owner.inspiration.maxsongs - owner.inspiration.songsbought) : 0
	return data

/datum/songbook_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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
			// Check not already known
			for(var/datum/action/cooldown/spell/song/known in owner.mind.spell_list)
				if(known.type == song_path)
					return TRUE
			var/datum/action/cooldown/spell/song/new_song = new song_path
			owner.mind.AddSpell(new_song)
			owner.inspiration.songsbought += 1
			if(owner.inspiration.songsbought >= owner.inspiration.maxsongs)
				owner.verbs -= /mob/living/carbon/human/proc/picksongs
				ui.close()
			return TRUE

/mob/living/carbon/human/proc/pickrhythm()
	set name = "Choose Rhythm"
	set category = "Inspiration"

	if(!inspiration)
		return
	if(!mind)
		return

	var/max_picks = inspiration.level >= BARD_T2 ? RHYTHM_PICKS_T2 : RHYTHM_PICKS_T1
	var/existing_count = 0
	for(var/datum/action/cooldown/spell/rhythm/existing in mind.spell_list)
		existing_count++
	if(existing_count >= max_picks)
		to_chat(src, span_warning("I have already chosen all my rhythms! ([existing_count]/[max_picks])"))
		return

	var/datum/rhythm_picker/picker = new(src)
	picker.ui_interact(src)

// ---- Rhythm TGUI Picker ----

/datum/rhythm_picker
	var/mob/living/carbon/human/owner

/datum/rhythm_picker/New(mob/living/carbon/human/H)
	. = ..()
	owner = H

/datum/rhythm_picker/Destroy()
	owner = null
	return ..()

/datum/rhythm_picker/ui_state(mob/user)
	return GLOB.always_state

/datum/rhythm_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BardRhythm", "Choose Rhythm")
		ui.open()

/datum/rhythm_picker/ui_data(mob/user)
	var/list/data = list()
	var/list/rhythm_list = list()

	var/list/available = list(
		/datum/action/cooldown/spell/rhythm/resonating,
		/datum/action/cooldown/spell/rhythm/concussive,
		/datum/action/cooldown/spell/rhythm/frigid,
	)
	if(owner?.inspiration?.level >= BARD_T2)
		available += /datum/action/cooldown/spell/rhythm/regenerating

	var/list/existing_types = list()
	if(owner?.mind)
		for(var/datum/action/cooldown/spell/rhythm/existing in owner.mind.spell_list)
			existing_types += existing.type

	for(var/rhythm_path in available)
		var/datum/action/cooldown/spell/rhythm/R = rhythm_path
		rhythm_list += list(list(
			"name" = initial(R.name),
			"desc" = initial(R.desc),
			"type_path" = "[rhythm_path]",
			"known" = (rhythm_path in existing_types),
		))

	var/max_picks = owner?.inspiration?.level >= BARD_T2 ? RHYTHM_PICKS_T2 : RHYTHM_PICKS_T1
	data["rhythms"] = rhythm_list
	data["slots_remaining"] = max_picks - existing_types.len
	return data

/datum/rhythm_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("learn_rhythm")
			if(!owner?.mind || !owner.inspiration)
				return TRUE
			var/rhythm_path = text2path(params["type_path"])
			if(!rhythm_path)
				return TRUE
			// Verify it's a valid rhythm subtype
			var/list/valid = list(
				/datum/action/cooldown/spell/rhythm/resonating,
				/datum/action/cooldown/spell/rhythm/concussive,
				/datum/action/cooldown/spell/rhythm/frigid,
				/datum/action/cooldown/spell/rhythm/regenerating,
			)
			if(!(rhythm_path in valid))
				return TRUE
			// Check not already known
			for(var/datum/action/cooldown/spell/rhythm/existing in owner.mind.spell_list)
				if(existing.type == rhythm_path)
					return TRUE
			// Check slots
			var/max_picks = owner.inspiration.level >= BARD_T2 ? RHYTHM_PICKS_T2 : RHYTHM_PICKS_T1
			var/existing_count = 0
			for(var/datum/action/cooldown/spell/rhythm/R in owner.mind.spell_list)
				existing_count++
			if(existing_count >= max_picks)
				return TRUE

			// Create shared tracker if needed
			if(!owner.inspiration.rhythm_tracker)
				owner.inspiration.rhythm_tracker = new /datum/rhythm_tracker()

			var/datum/action/cooldown/spell/rhythm/new_rhythm = new rhythm_path()
			new_rhythm.tracker = owner.inspiration.rhythm_tracker
			owner.mind.AddSpell(new_rhythm)
			to_chat(owner, span_info("I attune my blade to the [new_rhythm.name] rhythm."))

			// Check if all picks used
			if((existing_count + 1) >= max_picks)
				owner.verbs -= /mob/living/carbon/human/proc/pickrhythm
				// Grant Crescendo to T2 bards after all rhythm picks
				if(owner.inspiration.level >= BARD_T2 && !owner.inspiration.rhythm_tracker.crescendo_action)
					var/datum/action/cooldown/spell/crescendo/C = new()
					C.tracker = owner.inspiration.rhythm_tracker
					owner.inspiration.rhythm_tracker.crescendo_action = C
					owner.mind.AddSpell(C)
				ui.close()
			return TRUE
