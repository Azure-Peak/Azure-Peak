/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE)
	// Bandaid to undo no arm flaw prosthesis
	if(LAZYLEN(charflaws))
		var/obj/item/bodypart/O = character.get_bodypart(BODY_ZONE_R_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		O = character.get_bodypart(BODY_ZONE_L_ARM)
		if(O)
			O.drop_limb()
			qdel(O)
		character.regenerate_limb(BODY_ZONE_R_ARM)
		character.regenerate_limb(BODY_ZONE_L_ARM)

	var/datum/species/chosen_species
	chosen_species = pref_species.type
	if(!(pref_species.name in GLOB.roundstart_races))
		// this already randomizes
		set_new_race(new /datum/species/human/northern)

	character.age = age
	character.dna.features = features.Copy()
	character.gender = gender
	character.set_species(chosen_species, icon_update = FALSE, pref_load = src)
	character.dna.update_body_size()

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && ((pref_species.id == "human") || (pref_species.id == "humen")))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	if(real_name in GLOB.chosen_names)
		character.real_name = pref_species.random_name(gender)
	else
		character.real_name = real_name
	character.name = character.real_name

	character.domhand = domhand
	character.cmode_music_override = combat_music.musicpath
	character.cmode_music_override_name = combat_music.name
	character.highlight_color = highlight_color
	character.nickname = nickname

	character.voice_color = voice_color
	character.voice_pitch = voice_pitch
	character.skin_tone = skin_tone
	character.vampire_skin = vampire_skin
	character.vampire_eyes = vampire_eyes
	character.vampire_hair = vampire_hair
	character.vampire_ears = vampire_ears
	character.set_patron(selected_patron)

	// done in two loops just in case it matters
	character.charflaws.Cut()
	for(var/cf_type in charflaws)
		character.charflaws += new cf_type()
	for(var/datum/charflaw/cf as anything in character.charflaws)
		cf.on_mob_creation(character)

	character.dna.real_name = character.real_name

	character.headshot_link = headshot_link

	character.lich_headshot_link = lich_headshot_link

	character.vampire_headshot_link = vampire_headshot_link

	character.statpack = statpack

	character.flavortext = flavortext
	character.ooc_notes = ooc_notes
	character.nsfwflavortext = nsfwflavortext
	character.erpprefs = erpprefs
	// Rumours / Noble gossip
	character.rumour = rumour
	character.noble_gossip = noble_gossip

	// Copy the cached version
	character.flavortext_cached = flavortext_cached
	character.ooc_notes_cached = ooc_notes_cached
	character.nsfwflavortext_cached = nsfwflavortext_cached
	character.erpprefs_cached = erpprefs_cached
	// Rumours / Noble gossip
	character.rumour_cached = rumour_cached
	character.noble_gossip_cached = noble_gossip_cached

	character.img_gallery = img_gallery
	character.nsfw_img_gallery = nsfw_img_gallery

	character.examine_theme = examine_theme
	character.ooc_extra = ooc_extra

	character.song_title = song_title

	character.song_artist = song_artist
	// LETHALSTONE ADDITION BEGIN: additional customizations

	character.pronouns = pronouns
	character.titles_pref = titles_pref
	character.clothes_pref = clothes_pref
	character.voice_type = voice_type

	// LETHALSTONE ADDITION END



	// Barks
	character.set_bark(bark_id)
	character.vocal_speed = bark_speed
	character.vocal_pitch = bark_pitch
	character.vocal_pitch_range = bark_variance

	if(parent)
		var/list/L = get_player_curses(parent.ckey)
		if(L)
			for(var/X in L)
				ADD_TRAIT(character, curse2trait(X), TRAIT_GENERIC)

	if(taur_type)
		character.Taurize(taur_type, taur_color)
	else if(character_setup)
		// This should only ever ~do~ anything for previews
		character.ensure_not_taur()

	if(icon_updates)
		character.update_body()
		character.update_hair()
		// we have to force a redraw at the end because the way we apply underwear
		// is completely unhinged and causes race conditions with displaying genitals
		character.update_body_parts(redraw = TRUE)

	// Customizers are already applied inside set_species() (both the species-change path via
	// on_species_gain, and the same-species short-circuit). Re-applying here doubled the work.
	apply_culinary_preferences(character)
