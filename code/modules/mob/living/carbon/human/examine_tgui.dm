/datum/examine_panel
	/// Mob that the examine panel belongs to.
	var/mob/living/carbon/human/holder
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

/datum/examine_panel/familiar/ui_data(mob/user) //altered and condensed version used for familiars. sorry

	var/flavor_text
	var/flavor_text_nsfw //probably breaks if i remove it entirely, just leaving it null
	var/ooc_notes = ""
	var/ooc_notes_nsfw
	var/headshot = ""
	var/list/img_gallery = list()
	var/char_name
	var/song_url
	var/has_song = FALSE
	var/is_vet = FALSE
	var/is_naked = FALSE
	var/obscured = FALSE

	var/datum/preferences/prefs = holder.client?.prefs
	var/datum/familiar_prefs/fam_pref = prefs?.familiar_prefs

	flavor_text = fam_pref.familiar_flavortext
	ooc_notes = fam_pref.familiar_ooc_notes
	headshot = fam_pref.familiar_headshot_link
	char_name = fam_pref.familiar_name
	song_url = prefs.ooc_extra
	is_vet = viewing.check_agevet()
	if(!headshot)
		headshot = "headshot_red.png"

	if(song_url)
		has_song = TRUE

	ooc_notes = html_encode(ooc_notes)
	ooc_notes = parsemarkdown_basic(ooc_notes, hyperlink=TRUE)
	ooc_notes_nsfw = html_encode(ooc_notes_nsfw)
	ooc_notes_nsfw = parsemarkdown_basic(ooc_notes_nsfw, hyperlink=TRUE)
	flavor_text = html_encode(flavor_text)
	flavor_text = parsemarkdown_basic(flavor_text, hyperlink=TRUE)
	flavor_text_nsfw = html_encode(flavor_text_nsfw)
	flavor_text_nsfw = parsemarkdown_basic(flavor_text_nsfw, hyperlink=TRUE)

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
		"is_playing" = is_playing,
		"has_song" = has_song,
		"is_vet" = is_vet,
		"is_naked" = is_naked,
	)
	return data

/datum/examine_panel/ui_data(mob/user)

	var/flavor_text
	var/flavor_text_nsfw
	var/obscured
	var/ooc_notes = ""
	var/ooc_notes_nsfw
	var/headshot = ""
	var/list/img_gallery = list()
	var/char_name
	var/song_url
	var/has_song = FALSE
	var/is_vet = FALSE
	var/is_naked = FALSE
	var/datum/antagonist/vampire/vampireplayer = user.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/lich/lichplayer = user.mind?.has_antag_datum(/datum/antagonist/lich)

	if(ishuman(holder))
		var/mob/living/carbon/human/holder_human = holder
		if(!(holder.wear_armor && holder.wear_armor.flags_inv) && !(holder.wear_shirt && holder.wear_shirt.flags_inv))
			is_naked = TRUE
		obscured = ((!isobserver(user)) && !holder_human.client?.prefs?.masked_examine) && ((holder_human.wear_mask && (holder_human.wear_mask.flags_inv & HIDEFACE)) || (holder_human.head && (holder_human.head.flags_inv & HIDEFACE)))
		flavor_text = obscured ? "Obscured" : holder.flavortext
		flavor_text_nsfw = obscured ? "Obscured" : holder.nsfwflavortext
		ooc_notes += holder.ooc_notes
		ooc_notes_nsfw += holder.erpprefs
		char_name = holder.name
		song_url = holder.ooc_extra
		is_vet = holder.check_agevet()
		if(!obscured)
			if(vampireplayer && (!SEND_SIGNAL(holder, COMSIG_DISGUISE_STATUS))&& !isnull(holder.vampire_headshot_link)) //vampire with their disguise down and a valid headshot
				headshot = holder.vampire_headshot_link
			else if (lichplayer && !isnull(holder.lich_headshot_link))//Lich with a valid headshot
				headshot = holder.lich_headshot_link
			else
				headshot = holder.headshot_link
			img_gallery = holder.img_gallery
		if(!headshot)
			headshot = "headshot_red.png"

	else if(pref)
		is_naked = TRUE
		obscured = FALSE
		flavor_text = pref.flavortext
		flavor_text_nsfw = pref.nsfwflavortext
		ooc_notes = pref.ooc_notes
		ooc_notes_nsfw = pref.erpprefs
		if(vampireplayer && (!SEND_SIGNAL(pref, COMSIG_DISGUISE_STATUS))&& !isnull(pref.vampire_headshot_link)) //vampire with their disguise down and a valid headshot
			headshot = pref.vampire_headshot_link
		else if (lichplayer && !isnull(pref.lich_headshot_link))//Lich with a valid headshot
			headshot = pref.lich_headshot_link
		else
			headshot = pref.headshot_link
		img_gallery = pref.img_gallery
		char_name = pref.real_name
		song_url = pref.ooc_extra
		is_vet = viewing.check_agevet()
		if(!headshot)
			headshot = "headshot_red.png"

	if(song_url)
		has_song = TRUE

	ooc_notes = html_encode(ooc_notes)
	ooc_notes = parsemarkdown_basic(ooc_notes, hyperlink=TRUE)
	ooc_notes_nsfw = html_encode(ooc_notes_nsfw)
	ooc_notes_nsfw = parsemarkdown_basic(ooc_notes_nsfw, hyperlink=TRUE)
	flavor_text = html_encode(flavor_text)
	flavor_text = parsemarkdown_basic(flavor_text, hyperlink=TRUE)
	flavor_text_nsfw = html_encode(flavor_text_nsfw)
	flavor_text_nsfw = parsemarkdown_basic(flavor_text_nsfw, hyperlink=TRUE)

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
		"is_playing" = is_playing,
		"has_song" = has_song,
		"is_vet" = is_vet,
		"is_naked" = is_naked,
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
		web_sound_url = holder.ooc_extra
		if(holder.song_artist)
			artist_name = holder.song_artist
		song_title = holder.song_title

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
