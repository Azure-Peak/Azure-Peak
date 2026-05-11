/datum/examine_panel
	/// Mob that the examine panel belongs to. Will not always be a human.
	var/mob/living/holder
	/// The screen containing the appearance of the mob
	var/atom/movable/screen/map_view/examine_panel_screen/examine_panel_screen

	var/datum/preferences/pref = null

	var/is_playing = FALSE

	var/mob/viewing

/datum/examine_panel/familiar

/datum/examine_panel/New(mob/holder_mob)
	if(holder_mob)
		holder = holder_mob

/datum/examine_panel/Destroy(force)
	holder = null
	viewing = null
	qdel(examine_panel_screen)
	return ..()

/datum/examine_panel/ui_state(mob/user)
	return GLOB.always_state

/atom/movable/screen/map_view/examine_panel_screen
	name = "examine panel screen"

/datum/examine_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExaminePanel")
		ui.open()

/datum/examine_panel/familiar/ui_static_data(mob/user) //altered and condensed version used for familiars. sorry

	var/flavor_text
	var/flavor_text_nsfw //probably breaks if i remove it entirely, just leaving it null
	var/ooc_notes = ""
	var/ooc_notes_nsfw
	var/headshot = ""
	var/list/img_gallery = list()
	var/list/nsfw_img_gallery = list()
	var/char_name
	var/song_url
	var/has_song = FALSE
	var/is_vet = FALSE
	var/is_naked = FALSE
	var/obscured = FALSE

	var/mob/living/simple_animal/pet/familiar/fam = holder
	var/datum/preferences/prefs = holder.client?.prefs
	var/datum/familiar_prefs/fam_pref = prefs?.familiar_prefs

	if(!fam_pref.familiar_headshot_link) // prefs object from the dev period before we had examines; update that shit
		fam_pref.instantiate_examine_prefs()

	flavor_text = fam_pref.familiar_flavortext_display[fam.planar_origin]
	ooc_notes = fam_pref.familiar_ooc_notes_display[fam.planar_origin]
	headshot = fam_pref.familiar_headshot_link[fam.planar_origin]
	char_name = fam_pref.familiar_names[fam.planar_origin]
	song_url = fam_pref.familiar_ooc_extra[fam.planar_origin]
	is_vet = viewing.check_agevet()
	if(!headshot)
		headshot = "headshot_red.png"

	if(song_url)
		has_song = TRUE

	var/list/data = list(
		// Identity
		"character_name" = obscured ? "Unknown" : char_name,
		"headshot" = headshot,
		"obscured" = obscured ? TRUE : FALSE,
		// Descriptions
		"flavor_text" = flavor_text,
		"ooc_notes" = ooc_notes,
		// Descriptions, but requiring manual input to see
		"flavor_text_nsfw" = flavor_text_nsfw,
		"ooc_notes_nsfw" = ooc_notes_nsfw,
		"img_gallery" = img_gallery,
		"nsfw_img_gallery" = nsfw_img_gallery,
		"has_song" = has_song,
		"is_vet" = is_vet,
		"is_donator" = is_donator(holder.ckey),
		"is_naked" = is_naked,
	)

	return data

/datum/examine_panel/familiar/ui_data(mob/user)
	var/list/data = list( 
		"is_playing" = is_playing,
	)
	return data

// Where MOST of the examine panel data lives because it don't update mid game
/datum/examine_panel/ui_static_data(mob/user)
	var/flavor_text
	var/flavor_text_nsfw
	var/obscured
	var/ooc_notes = ""
	var/ooc_notes_nsfw
	var/headshot = ""
	var/list/img_gallery = list()
	var/list/nsfw_img_gallery = list()
	var/char_name
	var/song_url
	var/has_song = FALSE
	var/is_vet = FALSE
	var/is_naked = FALSE
	var/datum/antagonist/vampire/vampireplayer = user.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/lich/lichplayer = user.mind?.has_antag_datum(/datum/antagonist/lich)

	if(ishuman(holder))
		var/mob/living/carbon/human/holder_human = holder
		if(!(holder_human.wear_armor && holder_human.wear_armor.flags_inv) && !(holder_human.wear_shirt && holder_human.wear_shirt.flags_inv))
			is_naked = TRUE
		obscured = ((!isobserver(user)) && !holder_human.client?.prefs?.masked_examine) && ((holder_human.wear_mask && (holder_human.wear_mask.flags_inv & HIDEFACE)) || (holder_human.head && (holder_human.head.flags_inv & HIDEFACE)))
		flavor_text = obscured ? "Obscured" : holder_human.flavortext_cached
		flavor_text_nsfw = obscured ? "Obscured" : holder_human.nsfwflavortext_cached
		ooc_notes += holder_human.ooc_notes_cached
		ooc_notes_nsfw += holder_human.erpprefs_cached
		char_name = holder_human.name
		song_url = holder_human.ooc_extra
		is_vet = holder_human.check_agevet()
		if(!obscured)
			if(vampireplayer && (!SEND_SIGNAL(holder_human, COMSIG_DISGUISE_STATUS))&& !isnull(holder_human.vampire_headshot_link)) //vampire with their disguise down and a valid headshot
				headshot = holder_human.vampire_headshot_link
			else if (lichplayer && !isnull(holder_human.lich_headshot_link))//Lich with a valid headshot
				headshot = holder_human.lich_headshot_link
			else
				headshot = holder_human.headshot_link
			img_gallery = holder_human.img_gallery
			if(is_naked)
				nsfw_img_gallery = holder_human.nsfw_img_gallery
		if(!headshot)
			headshot = "headshot_red.png"

	else if(pref)
		is_naked = TRUE
		obscured = FALSE
		flavor_text = pref.flavortext_cached
		flavor_text_nsfw = pref.nsfwflavortext_cached
		ooc_notes = pref.ooc_notes_cached
		ooc_notes_nsfw = pref.erpprefs_cached
		if(vampireplayer && (!SEND_SIGNAL(pref, COMSIG_DISGUISE_STATUS))&& !isnull(pref.vampire_headshot_link)) //vampire with their disguise down and a valid headshot
			headshot = pref.vampire_headshot_link
		else if (lichplayer && !isnull(pref.lich_headshot_link))//Lich with a valid headshot
			headshot = pref.lich_headshot_link
		else
			headshot = pref.headshot_link
		img_gallery = pref.img_gallery
		if(is_naked)
			nsfw_img_gallery = pref.nsfw_img_gallery
		char_name = pref.real_name
		song_url = pref.ooc_extra
		is_vet = viewing.check_agevet()
		if(!headshot)
			headshot = "headshot_red.png"

	if(song_url)
		has_song = TRUE

	// Examine theme override — use the viewed character's preference
	var/char_examine_theme
	if(ishuman(holder))
		var/mob/living/carbon/human/holder_human = holder
		char_examine_theme = holder_human.examine_theme
	else if(pref)
		char_examine_theme = pref.examine_theme
	// Validate — reject meme themes and unknown keys, fall back to default
	if(char_examine_theme)
		var/list/valid_themes = get_tgui_themes()
		if(!(char_examine_theme in valid_themes) || char_examine_theme == "trey_liam")
			char_examine_theme = "azure_default"

	var/list/data = list(
		// Identity
		"character_name" = obscured ? "Unknown" : char_name,
		"headshot" = headshot,
		"obscured" = obscured ? TRUE : FALSE,
		// Descriptions
		"flavor_text" = flavor_text,
		"ooc_notes" = ooc_notes,
		// Descriptions, but requiring manual input to see
		"flavor_text_nsfw" = flavor_text_nsfw,
		"ooc_notes_nsfw" = ooc_notes_nsfw,
		"img_gallery" = img_gallery,
		"nsfw_img_gallery" = nsfw_img_gallery,
		"has_song" = has_song,
		"is_vet" = is_vet,
		"is_donator" = is_donator(holder.ckey),
		"is_naked" = is_naked,
		"examine_theme" = char_examine_theme,
	)
	return data

/datum/examine_panel/ui_data(mob/user)
	var/list/data = list(
		"is_playing" = is_playing,
	)
	return data

/datum/examine_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	if(!viewing)
		return

	var/client/C
	var/web_sound_url
	var/artist_name = "Song Artist Hidden"
	var/song_title
	var/list/music_extra_data = list()

	C = viewing.client

	if(ishuman(holder))
		var/mob/living/carbon/human/human_holder = holder
		web_sound_url = human_holder.ooc_extra
		if(human_holder.song_artist)
			artist_name = human_holder.song_artist
		song_title = human_holder.song_title

	else if(pref)
		web_sound_url= pref.ooc_extra
		if(pref.song_artist)
			artist_name = pref.song_artist
		song_title = pref.song_title

	if(!C || !web_sound_url)
		return

	if(!web_sound_url)
		return

	switch(action)
		if("toggle")
			if(!is_playing)
				is_playing = TRUE
				music_extra_data["link"] = web_sound_url
				music_extra_data["title"] = song_title
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = artist_name
				C.tgui_panel?.play_music(web_sound_url, music_extra_data)
			else
				is_playing = FALSE
				C.tgui_panel?.stop_music()
			return TRUE
		if("vet_chat")
			to_chat(viewing, span_boldgreen("This player is age-verified!"))
			return TRUE
		if("donator_chat")
			to_chat(viewing, span_boldgreen("This player is a donator!"))
			return TRUE

/datum/examine_panel/ui_close()
	QDEL_NULL(src)

/datum/examine_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/headshot_imgs),
	)

/datum/asset/simple/headshot_imgs
	assets = list(
		"headshot_background.png" = 'icons/tgui/headshot_background.png',
		"headshot_red.png" = 'icons/tgui/headshot_red.png',
		)
