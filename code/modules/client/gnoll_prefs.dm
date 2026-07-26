// Gnoll customization preferences, ported from Emerald Summit. Client-level (not per-character slot):
// a datum on /datum/preferences holding the player's gnoll form, applied to the mob by
// apply_gnoll_preferences() when they spawn as (or revert to) a gnoll.
/datum/gnoll_prefs
	var/gnoll_name = ""
	var/pelt_type = "firepelt"
	var/list/genitals = list(
		"penis" = FALSE,
		"vagina" = FALSE,
		"breasts" = FALSE
	)
	var/descriptor_height     = /datum/mob_descriptor/height/moderate
	var/descriptor_body       = /datum/mob_descriptor/body/muscular
	var/descriptor_fur        = /datum/mob_descriptor/fur/coarse
	var/descriptor_voice      = /datum/mob_descriptor/voice/growly
	var/descriptor_muzzle     = /datum/mob_descriptor/face/gnoll/long_muzzle
	var/descriptor_expression = /datum/mob_descriptor/face_exp/gnoll/alert

	/// Gnoll-specific flavor text (overrides player's normal flavor when in gnoll form).
	var/gnoll_flavortext
	var/gnoll_flavortext_cached
	/// Gnoll-specific OOC notes (overrides player's normal OOC notes when in gnoll form).
	var/gnoll_ooc_notes
	var/gnoll_ooc_notes_cached

	// Gnoll-specific examine/OOC metadata — parity with the main flavor-text fields so a gnoll carries
	// its own headshot, music, ERP settings, etc. instead of inheriting the base slot's. Applied to the
	// mob in apply_gnoll_preferences when set. IC rumour/gossip are intentionally excluded (gnolls blank those).
	var/gnoll_headshot_link
	var/gnoll_nsfwflavortext
	var/gnoll_nsfwflavortext_cached
	var/gnoll_erpprefs
	var/gnoll_erpprefs_cached
	var/gnoll_ooc_extra
	var/gnoll_song_title
	var/gnoll_song_artist
	var/list/gnoll_img_gallery = list()
	var/list/gnoll_nsfw_img_gallery = list()

/datum/gnoll_prefs/New()
	. = ..()
	ensure_gnoll_name()

/datum/gnoll_prefs/proc/generate_random_gnoll_name()
	return "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"

/datum/gnoll_prefs/proc/ensure_gnoll_name()
	if(!gnoll_name)
		gnoll_name = generate_random_gnoll_name()
	return gnoll_name

/datum/gnoll_prefs/proc/get_pelt_options()
	var/static/list/pelt_options = list(
		"Firepelt" = "firepelt",
		"Rotpelt" = "rotpelt",
		"Whitepelt" = "whitepelt",
		"Bloodpelt" = "bloodpelt",
		"Nightpelt" = "nightpelt",
		"Darkpelt" = "darkpelt"
	)
	return pelt_options

/datum/gnoll_prefs/proc/get_descriptor_options(slot)
	var/static/list/descriptor_options_by_slot = list(
		"height" = list(
				"Moderate" = /datum/mob_descriptor/height/moderate,
				"Middling" = /datum/mob_descriptor/height/middling,
				"Short" = /datum/mob_descriptor/height/short,
				"Tall" = /datum/mob_descriptor/height/tall,
				"Towering" = /datum/mob_descriptor/height/towering,
				"Giant" = /datum/mob_descriptor/height/giant,
				"Tiny" = /datum/mob_descriptor/height/tiny
		),
		"body" = list(
				"Average" = /datum/mob_descriptor/body/average,
				"Athletic" = /datum/mob_descriptor/body/athletic,
				"Muscular" = /datum/mob_descriptor/body/muscular,
				"Herculean" = /datum/mob_descriptor/body/herculean,
				"Toned" = /datum/mob_descriptor/body/toned,
				"Heavy" = /datum/mob_descriptor/body/heavy,
				"Lean" = /datum/mob_descriptor/body/lean,
				"Burly" = /datum/mob_descriptor/body/burly,
				"Gaunt" = /datum/mob_descriptor/body/gaunt,
				"Lanky" = /datum/mob_descriptor/body/lanky
		),
		"fur" = list(
				"Plain" = /datum/mob_descriptor/fur/plain,
				"Short" = /datum/mob_descriptor/fur/short,
				"Coarse" = /datum/mob_descriptor/fur/coarse,
				"Bristly" = /datum/mob_descriptor/fur/bristly,
				"Fluffy" = /datum/mob_descriptor/fur/fluffy,
				"Shaggy" = /datum/mob_descriptor/fur/shaggy,
				"Silky" = /datum/mob_descriptor/fur/silky,
				"Lank" = /datum/mob_descriptor/fur/lank,
				"Mangy" = /datum/mob_descriptor/fur/mangy,
				"Velvety" = /datum/mob_descriptor/fur/velvety,
				"Dense" = /datum/mob_descriptor/fur/dense,
				"Matted" = /datum/mob_descriptor/fur/matted
		),
		"voice" = list(
				"Growly" = /datum/mob_descriptor/voice/growly,
				"Deep" = /datum/mob_descriptor/voice/deep,
				"Booming" = /datum/mob_descriptor/voice/booming,
				"Gravelly" = /datum/mob_descriptor/voice/gravelly,
				"Commanding" = /datum/mob_descriptor/voice/commanding,
				"Monotone" = /datum/mob_descriptor/voice/monotone,
				"Ordinary" = /datum/mob_descriptor/voice/ordinary,
				"Soft" = /datum/mob_descriptor/voice/soft,
				"Grave" = /datum/mob_descriptor/voice/grave,
				"Venomous" = /datum/mob_descriptor/voice/venomous,
				"Dispassionate" = /datum/mob_descriptor/voice/dispassionate,
				"Whiny" = /datum/mob_descriptor/voice/whiny,
				"Drawling" = /datum/mob_descriptor/voice/drawling,
				"Shrill" = /datum/mob_descriptor/voice/shrill,
				"Stilted" = /datum/mob_descriptor/voice/stilted
		),
		"muzzle" = list(
				"Long" = /datum/mob_descriptor/face/gnoll/long_muzzle,
				"Short" = /datum/mob_descriptor/face/gnoll/short_muzzle,
				"Broad" = /datum/mob_descriptor/face/gnoll/broad_muzzle,
				"Narrow" = /datum/mob_descriptor/face/gnoll/narrow_muzzle,
				"Scarred" = /datum/mob_descriptor/face/gnoll/scarred_muzzle,
				"Sharp" = /datum/mob_descriptor/face/gnoll/sharp_muzzle,
				"Worn" = /datum/mob_descriptor/face/gnoll/worn_muzzle,
				"Disfigured" = /datum/mob_descriptor/face/gnoll/disfigured_muzzle
		),
		"expression" = list(
				"Alert" = /datum/mob_descriptor/face_exp/gnoll/alert,
				"Snarling" = /datum/mob_descriptor/face_exp/gnoll/snarling,
				"Predatory" = /datum/mob_descriptor/face_exp/gnoll/predatory,
				"Hollow" = /datum/mob_descriptor/face_exp/gnoll/hollow,
				"Fierce" = /datum/mob_descriptor/face_exp/gnoll/fierce,
				"Vacant" = /datum/mob_descriptor/face_exp/gnoll/vacant,
				"Groveling" = /datum/mob_descriptor/face_exp/gnoll/groveling,
				"Leering" = /datum/mob_descriptor/face_exp/gnoll/leering
		)
	)

	return descriptor_options_by_slot[slot]

/datum/gnoll_prefs/proc/get_selected_label(list/options, value)
	for(var/label in options)
		if(options[label] == value)
			return "[label]"
	return null

/datum/gnoll_prefs/proc/list_has_value(list/options, value)
	for(var/label in options)
		if(options[label] == value)
			return TRUE
	return FALSE

/datum/gnoll_prefs/proc/get_descriptor_value(slot)
	switch(slot)
		if("height")
			return descriptor_height
		if("body")
			return descriptor_body
		if("fur")
			return descriptor_fur
		if("voice")
			return descriptor_voice
		if("muzzle")
			return descriptor_muzzle
		if("expression")
			return descriptor_expression

	return null

/datum/gnoll_prefs/proc/set_descriptor_value(slot, value)
	var/list/options = get_descriptor_options(slot)
	if(!options || !list_has_value(options, value))
		return FALSE

	switch(slot)
		if("height")
			descriptor_height = value
		if("body")
			descriptor_body = value
		if("fur")
			descriptor_fur = value
		if("voice")
			descriptor_voice = value
		if("muzzle")
			descriptor_muzzle = value
		if("expression")
			descriptor_expression = value
		else
			return FALSE

	return TRUE

/datum/gnoll_prefs/proc/gnoll_process_link(mob/user, list/href_list)
	if(!user || !user.client)
		return

	var/action = href_list["action"]
	switch(action)
		if("set_name")
			var/new_name = tgui_input_text(user, "Enter a custom name for your gnoll:", "Gnoll Name", gnoll_name)
			if(new_name)
				gnoll_name = sanitize_name(new_name)
				ensure_gnoll_name()

		if("random_name")
			gnoll_name = generate_random_gnoll_name()

		if("choose_pelt")
			var/list/pelt_options = get_pelt_options()
			var/current_pelt = get_selected_label(pelt_options, pelt_type)
			var/selected_pelt = tgui_input_list(user, "Choose pelt pattern", "Gnoll Customization", pelt_options, current_pelt)
			if(!selected_pelt)
				return
			pelt_type = pelt_options[selected_pelt]

		if("choose_descriptor")
			var/slot = href_list["slot"]
			var/list/descriptor_options = get_descriptor_options(slot)
			if(!descriptor_options)
				return
			var/current_descriptor = get_selected_label(descriptor_options, get_descriptor_value(slot))
			var/selected_descriptor = tgui_input_list(user, "Describe my [slot]", "Gnoll Customization", descriptor_options, current_descriptor)
			if(!selected_descriptor)
				return
			set_descriptor_value(slot, descriptor_options[selected_descriptor])

		if("toggle_genital")
			var/genital = href_list["genital"]
			var/toggle = href_list["toggle"]
			if(genital in genitals)
				genitals[genital] = (toggle == "enable")

		if("set_flavortext")
			to_chat(user, "<span class='notice'><b>Flavortext should not include nonphysical nonsensory attributes such as backstory or internal thoughts.</b></span>")
			var/new_flavortext = tgui_input_text(user, "Input your gnoll character description:", "Gnoll Flavor Text", gnoll_flavortext, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_flavortext == null)
				return
			if(new_flavortext == "")
				gnoll_flavortext = null
				gnoll_flavortext_cached = null
			else
				gnoll_flavortext = new_flavortext
				gnoll_flavortext_cached = parsemarkdown_basic(html_encode(gnoll_flavortext), hyperlink = TRUE)
				to_chat(user, "<span class='notice'>Gnoll flavor text updated.</span>")
				log_game("[user] has set their gnoll flavor text.")

		if("clear_flavortext")
			gnoll_flavortext = null
			gnoll_flavortext_cached = null

		if("set_ooc_notes")
			var/new_ooc_notes = tgui_input_text(user, "Input your gnoll OOC preferences:", "Gnoll OOC Notes", gnoll_ooc_notes, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_ooc_notes == null)
				return
			if(new_ooc_notes == "")
				gnoll_ooc_notes = null
				gnoll_ooc_notes_cached = null
			else
				gnoll_ooc_notes = new_ooc_notes
				gnoll_ooc_notes_cached = parsemarkdown_basic(html_encode(gnoll_ooc_notes), hyperlink = TRUE)
				to_chat(user, "<span class='notice'>Gnoll OOC notes updated.</span>")
				log_game("[user] has set their gnoll OOC notes.")

		if("clear_ooc_notes")
			gnoll_ooc_notes = null
			gnoll_ooc_notes_cached = null

		if("set_nsfwflavortext")
			if(!user.check_agevet())
				return
			var/new_val = tgui_input_text(user, "Input your gnoll NSFW description:", "Gnoll NSFW Flavortext", gnoll_nsfwflavortext, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_val == null)
				return
			if(new_val == "")
				gnoll_nsfwflavortext = null
				gnoll_nsfwflavortext_cached = null
			else
				gnoll_nsfwflavortext = new_val
				gnoll_nsfwflavortext_cached = parsemarkdown_basic(html_encode(new_val), hyperlink = TRUE)

		if("clear_nsfwflavortext")
			gnoll_nsfwflavortext = null
			gnoll_nsfwflavortext_cached = null

		if("set_erpprefs")
			if(!user.check_agevet())
				return
			var/new_val = tgui_input_text(user, "Input your gnoll ERP preferences:", "Gnoll ERP Preferences", gnoll_erpprefs, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_val == null)
				return
			if(new_val == "")
				gnoll_erpprefs = null
				gnoll_erpprefs_cached = null
			else
				gnoll_erpprefs = new_val
				gnoll_erpprefs_cached = parsemarkdown_basic(html_encode(new_val), hyperlink = TRUE)

		if("clear_erpprefs")
			gnoll_erpprefs = null
			gnoll_erpprefs_cached = null

		if("set_song_title")
			var/new_title = tgui_input_text(user, "Input your gnoll song's title:", "Gnoll Song Title", gnoll_song_title, encode = FALSE)
			if(new_title == null)
				return
			gnoll_song_title = (new_title == "") ? null : new_title

		if("set_song_artist")
			var/new_artist = tgui_input_text(user, "Input your gnoll song's artist:", "Gnoll Song Artist", gnoll_song_artist, encode = FALSE)
			if(new_artist == null)
				return
			gnoll_song_artist = (new_artist == "") ? null : new_artist

		if("set_song_url")
			if(!user.check_agevet())
				return
			to_chat(user, "<span class='notice'>Add a link from a suitable host (catbox, etc) to an mp3 to embed in your gnoll flavor text. Leave blank to clear.</span>")
			var/new_extra_link = tgui_input_text(user, "Input the accessory link (https, hosts: discord, catbox):", "Gnoll Song URL", gnoll_ooc_extra, encode = FALSE)
			if(new_extra_link == null)
				return
			if(new_extra_link == "")
				gnoll_ooc_extra = null
				to_chat(user, "<span class='notice'>Cleared gnoll song.</span>")
				return
			var/static/list/song_extensions = list("mp3")
			if(!valid_headshot_link(user, new_extra_link, FALSE, song_extensions))
				return
			gnoll_ooc_extra = new_extra_link
			to_chat(user, "<span class='notice'>Successfully updated gnoll Song URL.</span>")
			log_game("[user] has set their gnoll Song URL to '[gnoll_ooc_extra]'.")

		if("set_headshot")
			if(!user.check_agevet())
				return
			to_chat(user, "<span class='notice'>Please use a relatively SFW image of the head and shoulder area. Direct image links only; it will be downsized to a square.</span>")
			var/new_link = tgui_input_text(user, "Input the headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Gnoll Headshot", gnoll_headshot_link, encode = FALSE)
			if(new_link == null)
				return
			if(new_link == "")
				gnoll_headshot_link = null
			else if(!valid_headshot_link(user, new_link))
				gnoll_headshot_link = null
			else
				gnoll_headshot_link = new_link
				to_chat(user, "<span class='notice'>Successfully updated gnoll headshot picture.</span>")
				log_game("[user] has set their gnoll Headshot image to '[gnoll_headshot_link]'.")

		if("img_gallery_add")
			if(!user.check_agevet())
				return
			if(length(gnoll_img_gallery) >= 6)
				to_chat(user, "<span class='warning'>Your gnoll image gallery is full (6 max). Clear it first.</span>")
				return
			var/static/list/sfwgal_ext = list("jpg", "png", "jpeg", "gif")
			var/sfwgal_link = tgui_input_text(user, "Input an image link to add to your gnoll gallery (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Gnoll Image Gallery", encode = FALSE)
			if(!sfwgal_link)
				return
			if(!valid_headshot_link(user, sfwgal_link, FALSE, sfwgal_ext))
				return
			gnoll_img_gallery += sfwgal_link
			to_chat(user, "<span class='notice'>Added image to gnoll gallery.</span>")

		if("img_gallery_clear")
			gnoll_img_gallery = list()
			to_chat(user, "<span class='notice'>Cleared gnoll image gallery.</span>")

		if("nsfw_img_gallery_add")
			if(!user.check_agevet())
				return
			if(length(gnoll_nsfw_img_gallery) >= 6)
				to_chat(user, "<span class='warning'>Your gnoll NSFW image gallery is full (6 max). Clear it first.</span>")
				return
			var/static/list/nsfwgal_ext = list("jpg", "png", "jpeg", "gif")
			var/nsfwgal_link = tgui_input_text(user, "Input an image link to add to your gnoll NSFW gallery (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Gnoll NSFW Image Gallery", encode = FALSE)
			if(!nsfwgal_link)
				return
			if(!valid_headshot_link(user, nsfwgal_link, FALSE, nsfwgal_ext))
				return
			gnoll_nsfw_img_gallery += nsfwgal_link
			to_chat(user, "<span class='notice'>Added image to gnoll NSFW gallery.</span>")

		if("nsfw_img_gallery_clear")
			gnoll_nsfw_img_gallery = list()
			to_chat(user, "<span class='notice'>Cleared gnoll NSFW image gallery.</span>")

	return TRUE

/// TGUI Gnoll Customization menu — follows the markings/descriptors wrapper-datum pattern.
/// Mutations funnel into gnoll_process_link() so the pickers stay tgui_input modals.
/datum/gnoll_prefs/proc/gnoll_show_ui(mob/user)
	if(!user?.client)
		return
	var/datum/gnoll_menu/menu = new(src)
	menu.ui_interact(user)

/datum/gnoll_menu
	var/datum/gnoll_prefs/gprefs

/datum/gnoll_menu/New(datum/gnoll_prefs/gprefs)
	src.gprefs = gprefs

/datum/gnoll_menu/Destroy()
	gprefs = null
	return ..()

/datum/gnoll_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/gnoll_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GnollCustomizer")
		ui.open()

/datum/gnoll_menu/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/gnoll_menu/ui_data(mob/user)
	var/list/data = list()
	data["name"] = gprefs.ensure_gnoll_name()
	data["pelt"] = gprefs.get_selected_label(gprefs.get_pelt_options(), gprefs.pelt_type) || "Firepelt"
	var/list/genitals = list()
	for(var/genital in gprefs.genitals)
		genitals += list(list(
			"id" = genital,
			"enabled" = !!gprefs.genitals[genital],
		))
	data["genitals"] = genitals
	var/static/list/descriptor_rows = list("height" = "Height", "body" = "Build", "fur" = "Coat", "voice" = "Voice", "muzzle" = "Muzzle Shape", "expression" = "Expression")
	var/list/descriptors = list()
	for(var/slot in descriptor_rows)
		descriptors += list(list(
			"slot" = slot,
			"name" = descriptor_rows[slot],
			"value" = gprefs.get_selected_label(gprefs.get_descriptor_options(slot), gprefs.get_descriptor_value(slot)),
		))
	data["descriptors"] = descriptors
	data["flavortext_len"] = length(gprefs.gnoll_flavortext)
	data["ooc_notes_len"] = length(gprefs.gnoll_ooc_notes)
	data["nsfwflavortext_len"] = length(gprefs.gnoll_nsfwflavortext)
	data["erpprefs_len"] = length(gprefs.gnoll_erpprefs)
	data["headshot"] = gprefs.gnoll_headshot_link
	data["song_url"] = gprefs.gnoll_ooc_extra
	data["song_title"] = gprefs.gnoll_song_title
	data["song_artist"] = gprefs.gnoll_song_artist
	data["img_gallery_len"] = length(gprefs.gnoll_img_gallery)
	data["nsfw_img_gallery_len"] = length(gprefs.gnoll_nsfw_img_gallery)
	data["age_verified"] = user.check_agevet()
	return data

/datum/gnoll_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user?.client || !gprefs)
		return
	var/static/list/allowed_actions = list(
		"set_name", "random_name", "choose_pelt", "choose_descriptor", "toggle_genital",
		"set_flavortext", "clear_flavortext", "set_ooc_notes", "clear_ooc_notes",
		"set_nsfwflavortext", "clear_nsfwflavortext", "set_erpprefs", "clear_erpprefs",
		"set_song_title", "set_song_artist", "set_song_url", "set_headshot",
		"img_gallery_add", "img_gallery_clear", "nsfw_img_gallery_add", "nsfw_img_gallery_clear",
	)
	if(!(action in allowed_actions))
		return
	var/list/href_list = list("action" = action)
	if(params["slot"])
		href_list["slot"] = params["slot"]
	if(params["genital"])
		href_list["genital"] = params["genital"]
	if(params["toggle"])
		href_list["toggle"] = params["toggle"]
	gprefs.gnoll_process_link(user, href_list)
	return TRUE
