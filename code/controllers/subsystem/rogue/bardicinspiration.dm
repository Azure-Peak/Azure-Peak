// Bardic Inspo time - Datum/definition setup
GLOBAL_LIST_INIT(learnable_songst1, (list(/obj/effect/proc_holder/spell/invoked/song/dirge_fortune,
		/obj/effect/proc_holder/spell/invoked/song/furtive_fortissimo,
		/obj/effect/proc_holder/spell/invoked/song/intellectual_interval,
		)
))


GLOBAL_LIST_INIT(learnable_songst2, (list(/obj/effect/proc_holder/spell/invoked/song/recovery_song,
		/obj/effect/proc_holder/spell/invoked/song/fervor_song,
		/obj/effect/proc_holder/spell/invoked/song/pestilent_piedpiper
		)
))


GLOBAL_LIST_INIT(learnable_songst3, (list(/obj/effect/proc_holder/spell/invoked/song/rejuvenation_song,
		/obj/effect/proc_holder/spell/invoked/song/suffocating_seliloquy,
		/obj/effect/proc_holder/spell/invoked/song/accelakathist,
		)
))


/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 2
	var/list/audience = list()
	var/maxsongs = BARD_T1
	var/songsbought = 0
	var/tier1acquired = FALSE
	var/tier2acquired = FALSE
	var/tier3acquired = FALSE
	var/learning_song = FALSE

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
	STOP_PROCESSING(SSobj, src)



/mob/living/carbon/human/proc/in_audience(var/mob/living/carbon/human/audiencee)
	if(!src.mind)
		return FALSE
	if(!src.inspiration)
		return FALSE
		
	if(audiencee in src.inspiration.audience)
		return TRUE
	else
		return FALSE


/datum/inspiration/proc/grant_inspiration(mob/living/carbon/human/H, bard_tier)
	if(!H || !H.mind)
		return
	level = bard_tier
	maxaudience = 2*bard_tier
	maxsongs = bard_tier
	H.verbs += list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs, /mob/living/carbon/human/proc/explain_bard)

/mob/living/carbon/human/proc/setaudience()
	set name = "Audience Choice"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	if(inspiration.audience.len >= inspiration.maxaudience)
		to_chat(src, "I cannot maintain a audience larger than [inspiration.maxaudience]!")
		return FALSE
	var/list/folksnearby = list()
	for(var/mob/living/carbon/human/folks in view(7, loc))
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
	if(src.has_status_effect(/datum/status_effect/buff/playing_music)) // cant clear while playing
		return
	inspiration.audience = list()

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
	to_chat(src, span_info("Bardic Inspiration allows you to inspire your allies with music. To start \
	 your performance, you must first set your audience using the 'Audience Choice' verb. Then you can select songs from your Songbook using 'Fill Songbook'\
	- picking one per level, once chosen, the choice sticks with you for the rest of the round. \
	To use a bardic Song spell, you must first start playing music with an instrument (use the instrument in your hand), \
	and then activate the song action from your action bar while continuing to play."))
	to_chat(src, span_smallnotice("You're a Level [inspiration.level] Bard and can have up to [inspiration.maxaudience] audience members and know [inspiration.maxsongs] songs."))

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

	inspiration.learning_song = TRUE

	var/list/songs = GLOB.learnable_songst1
	var/list/choices = list()
	var/choosablesongtiers = list()

	switch(inspiration.level)
		if(1)
			choosablesongtiers += ("TIER1")
		if(2)
			choosablesongtiers += ("TIER1")
			choosablesongtiers += ("TIER2")
		if(3)
			choosablesongtiers += ("TIER1")
			choosablesongtiers += ("TIER2")
			choosablesongtiers += ("TIER3")

	if(inspiration.tier1acquired)
		choosablesongtiers -= ("TIER1")
	if(inspiration.tier2acquired)
		choosablesongtiers -= ("TIER2")
	if(inspiration.tier3acquired)
		choosablesongtiers -= ("TIER3")

	var/chosensongtier = tgui_input_list(src, "Choose a tier of song to add to your songbook", "SERENADE", choosablesongtiers)

	if(!chosensongtier)
		inspiration.learning_song = FALSE
		return

	switch(chosensongtier)
		if("TIER1")
			songs = GLOB.learnable_songst1
		if("TIER2")
			songs = GLOB.learnable_songst2
		if("TIER3")
			songs = GLOB.learnable_songst3

	for(var/i = 1, i <= songs.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = songs[i]
		choices["[spell_item.name]"] = spell_item

	var/choice = input("Choose a song") as anything in choices
	var/obj/effect/proc_holder/spell/invoked/song/item = choices[choice]

	if(!item)
		inspiration.learning_song = FALSE
		return     // user canceled;
	if(alert(src, "[item.desc]", "[item.name]", "Learn", "Cancel") == "Cancel") //gives a preview of the spell's description to let people know what a spell does
		inspiration.learning_song = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type == item.type)
			to_chat(span_warning("You already know this one!"))
			inspiration.learning_song = FALSE
			return
	var/obj/effect/proc_holder/spell/invoked/song/new_song = new item
	mind.AddSpell(new_song)
	inspiration.songsbought += 1
	switch(item.song_tier)
		if(1)
			inspiration.tier1acquired = TRUE
		if(2)
			inspiration.tier2acquired = TRUE
		if(3)
			inspiration.tier3acquired = TRUE

	inspiration.learning_song = FALSE

	if(inspiration.songsbought >= inspiration.level)
		verbs -= /mob/living/carbon/human/proc/picksongs
