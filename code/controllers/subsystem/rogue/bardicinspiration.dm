// Bardic Inspiration - Unified Songbook (all songs available to all bards, effect strength scales by tier)
// Unified Songbook - all songs available to all bard tiers, effect strength scales by tier
GLOBAL_LIST_INIT(learnable_songs, list(
	// Buff Melodies
	/obj/effect/proc_holder/spell/invoked/song/furtive_fortissimo,
	/obj/effect/proc_holder/spell/invoked/song/resolute_refrain,
	/obj/effect/proc_holder/spell/invoked/song/fervor_song,
	/obj/effect/proc_holder/spell/invoked/song/recovery_song,
	/obj/effect/proc_holder/spell/invoked/song/accelakathist,
	/obj/effect/proc_holder/spell/invoked/song/rejuvenation_song,
	// Debuff Dirges
	/obj/effect/proc_holder/spell/invoked/song/discordant_dirge,
	/obj/effect/proc_holder/spell/invoked/song/enervating_elegy,
	/obj/effect/proc_holder/spell/invoked/song/rattling_requiem,
))

/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 3
	var/list/audience = list()
	var/maxsongs = 2
	var/songsbought = 0
	var/learning_song = FALSE

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
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
	H.verbs += list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs, /mob/living/carbon/human/proc/explain_bard)

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
	if(inspiration.learning_song)
		to_chat(src, span_warning("I'm already choosing a song!"))
		return
	if(!mind)
		return
	if(inspiration.songsbought >= inspiration.maxsongs)
		to_chat(src, span_warning("My songbook is full! I already know [inspiration.maxsongs] songs."))
		return

	inspiration.learning_song = TRUE

	var/list/choices = list()
	for(var/songpath in GLOB.learnable_songs)
		var/obj/effect/proc_holder/spell/invoked/song/song_item = songpath
		// Skip songs we already know
		var/already_known = FALSE
		for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
			if(knownsong.type == song_item)
				already_known = TRUE
				break
		if(!already_known)
			choices[initial(song_item.name)] = song_item

	if(!choices.len)
		to_chat(src, span_warning("I already know every song!"))
		inspiration.learning_song = FALSE
		return

	var/choice = input("Choose a song") as anything in choices
	var/song_type = choices[choice]

	if(!song_type)
		inspiration.learning_song = FALSE
		return

	var/obj/effect/proc_holder/spell/invoked/song/preview = song_type
	if(alert(src, "[initial(preview.desc)]", "[initial(preview.name)]", "Learn", "Cancel") == "Cancel")
		inspiration.learning_song = FALSE
		return

	var/obj/effect/proc_holder/spell/invoked/song/new_song = new song_type
	mind.AddSpell(new_song)
	inspiration.songsbought += 1

	inspiration.learning_song = FALSE

	if(inspiration.songsbought >= inspiration.maxsongs)
		verbs -= /mob/living/carbon/human/proc/picksongs
