//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN	18

//This is the current version, anything below this will attempt to update (if it's not obsolete)
//	You do not need to raise this if you are adding new values that have sane defaults.
//	Only raise this value when changing the meaning/format/name/layout of an existing value
//	where you would want the updater procs below to run

//	This also works with decimals.
#define SAVEFILE_VERSION_MAX	36

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd=="/" is preferences, S.cd=="/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/
/datum/preferences/proc/savefile_needs_update(savefile/S)
	var/savefile_version
	S["version"] >> savefile_version

	if(savefile_version < SAVEFILE_VERSION_MIN)
		S.dir.Cut()
		return -2
	if(savefile_version < SAVEFILE_VERSION_MAX)
		return savefile_version
	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, savefile/S)
	if(current_version < 29)
		key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key)
		parent.update_movement_keys()
		to_chat(parent, span_danger("Empty keybindings, setting default to Hotkey mode"))
	if(current_version < 31) // RAISE THIS TO SAVEFILE_VERSION_MAX (and make sure to add +1 to the version) EVERY TIME YOU ADD SERVER-CHANGING KEYBINDS LIKE CHANGING HOW SAY WORKS!!
		force_reset_keybindings_direct()
		addtimer(CALLBACK(src, PROC_REF(force_reset_keybindings_direct)), 30)

/datum/preferences/proc/update_character(current_version, savefile/S)
	if(current_version < 30)
		S["voice_color"]		>> voice_color
	if(current_version < 34) // Update races
		var/species_name
		S["species"] >> species_name

		if(species_name)
			var/newtype = GLOB.species_list[species_name]
			if(!newtype)
				switch(species_name)
					if("Sissean")

						species_name = "Zardman"
					if("Vulpkian")

						species_name = "Venardine"
		_load_species(S, species_name)
	if(current_version < 35) // Migrate old 3-slot loadout to gear_list
		gear_list = list()
		var/list/old_keys = list(
			list("loadout", "loadout_1_hex"),
			list("loadout2", "loadout_2_hex"),
			list("loadout3", "loadout_3_hex"),
		)
		for(var/list/pair in old_keys)
			var/loadout_type
			S[pair[1]] >> loadout_type
			if(!loadout_type || !ispath(loadout_type))
				continue
			var/datum/loadout_item/LI = GLOB.loadout_items[loadout_type]
			if(!LI || LI.name == "Parent loadout datum")
				continue
			var/list/meta = list()
			var/old_hex
			S[pair[2]] >> old_hex
			if(old_hex)
				if(old_hex[1] != "#")
					old_hex = "#[old_hex]"
				meta["color"] = old_hex
			gear_list[LI.name] = meta
	if(current_version < 36) // Strip the old per-item favorite/hated food & drink data now that preferences are category flags
		S.dir.Remove("culinary_preferences")

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/datum/preferences/proc/load_preferences()
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE

	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		return FALSE

	//general preferences
	S["favorited_slots"]	>> favorited_slots
	S["asaycolor"]			>> asaycolor
	S["lastchangelog"]		>> lastchangelog
	S["showrolls"]			>> showrolls
	S["chatheadshot"]		>> chatheadshot
	S["tgui_lock"]			>> tgui_lock
	S["tgui_theme"]			>> tgui_theme
	S["parchment_skin"]		>> parchment_skin
	S["statbrowser_theme"]	>> statbrowser_theme
	S["preferred_ui_language"] >> preferred_ui_language
	S["windowflash"]		>> windowflashing
	S["be_special"]		>> be_special
	S["no_storyteller_events"] >> no_storyteller_events
	S["verbose_character_creator"] >> verbose_character_creator
	S["musicvol"]			>> musicvol
	S["lobbymusicvol"]		>> lobbymusicvol
	S["ambiencevol"]		>> ambiencevol
	S["anonymize"]			>> anonymize
	S["stopdroning"]		>> stopdroning
	S["masked_examine"]		>> masked_examine
	S["full_examine"]		>> full_examine
	S["mute_animal_emotes"]	>> mute_animal_emotes
	S["autoconsume"]		>> autoconsume
	S["no_examine_blocks"]	>> no_examine_blocks
	S["no_autopunctuate"]	>> no_autopunctuate
	S["no_language_fonts"]	>> no_language_fonts
	S["no_language_icon"]	>> no_language_icon
	S["no_redflash"]		>> no_redflash
	S["top_examine"]		>> top_examine
	S["crt"]				>> crt
	S["grain"]				>> grain
	S["sexable"]			>> sexable
	S["shake"]				>> shake
	S["mastervol"]			>> mastervol
	S["compliance_notifs"]  >> compliance_notifs

	S["default_slot"]		>> default_slot
	S["chat_toggles"]		>> chat_toggles
	S["toggles"]			>> toggles
	S["combat_toggles"]		>> combat_toggles
	S["ghost_toggles"]		>> ghost_toggles
	S["admin_chat_toggles"]	>> admin_chat_toggles
	S["clientfps"]			>> clientfps
	S["ambientocclusion"]	>> ambientocclusion
	S["auto_fit_viewport"]	>> auto_fit_viewport
	S["menuoptions"]		>> menuoptions
	S["attack_blip_frequency"] >> attack_blip_frequency

	// Custom hotkeys
	S["key_bindings"]		>> key_bindings

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		update_preferences(needs_update, S)		//needs_update = savefile_version if we need an update (positive integer)

	//Sanitize
	sanitize_preferences()

	return TRUE

/datum/preferences/proc/sanitize_preferences()
	// bools
	showrolls			= sanitize_bool(showrolls, initial(showrolls))
	chatheadshot		= sanitize_bool(chatheadshot, initial(chatheadshot))
	tgui_lock			= sanitize_bool(tgui_lock, initial(tgui_lock))
	windowflashing		= sanitize_bool(windowflashing, initial(windowflashing))
	ambientocclusion	= sanitize_bool(ambientocclusion, initial(ambientocclusion))
	auto_fit_viewport	= sanitize_bool(auto_fit_viewport, initial(auto_fit_viewport))
	shake				= sanitize_bool(shake, initial(shake))
	sexable				= sanitize_bool(sexable, initial(sexable))
	compliance_notifs	= sanitize_bool(compliance_notifs, initial(compliance_notifs))
	stopdroning			= sanitize_bool(stopdroning, initial(stopdroning))
	anonymize			= sanitize_bool(anonymize, initial(anonymize))
	masked_examine		= sanitize_bool(masked_examine, initial(masked_examine))
	full_examine		= sanitize_bool(full_examine, initial(full_examine))
	mute_animal_emotes	= sanitize_bool(mute_animal_emotes, initial(mute_animal_emotes))
	autoconsume			= sanitize_bool(autoconsume, initial(autoconsume))
	no_examine_blocks	= sanitize_bool(no_examine_blocks, initial(no_examine_blocks))
	no_autopunctuate	= sanitize_bool(no_autopunctuate, initial(no_autopunctuate))
	no_language_fonts	= sanitize_bool(no_language_fonts, initial(no_language_fonts))
	no_language_icon	= sanitize_bool(no_language_icon, initial(no_language_icon))
	no_redflash			= sanitize_bool(no_redflash, initial(no_redflash))
	top_examine			= sanitize_bool(top_examine, initial(top_examine))
	crt					= sanitize_bool(crt, initial(crt))
	grain				= sanitize_bool(grain, initial(grain))
	dnr_pref			= sanitize_bool(dnr_pref, initial(dnr_pref))
	qsr_pref			= sanitize_bool(qsr_pref, initial(qsr_pref))
	no_storyteller_events = sanitize_bool(no_storyteller_events, initial(no_storyteller_events))
	verbose_character_creator = sanitize_bool(verbose_character_creator, initial(verbose_character_creator))

	// ints
	default_slot		= sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
	toggles				= sanitize_integer(toggles, 0, INFINITY, initial(toggles))
	combat_toggles		= sanitize_integer(combat_toggles, 0, INFINITY, initial(combat_toggles))
	ghost_toggles		= sanitize_integer(ghost_toggles, 0, INFINITY, initial(ghost_toggles))
	admin_chat_toggles	= sanitize_integer(admin_chat_toggles, 0, INFINITY, initial(admin_chat_toggles))
	chat_toggles		= sanitize_integer(chat_toggles, 0, INFINITY, initial(chat_toggles))
	clientfps			= sanitize_integer(clientfps, 0, 1000, initial(clientfps))
	musicvol			= sanitize_integer(musicvol, 0, 100, initial(musicvol))
	lobbymusicvol		= sanitize_integer(lobbymusicvol, 0, 100, initial(lobbymusicvol))
	ambiencevol			= sanitize_integer(ambiencevol, 0, 100, initial(ambiencevol))
	mastervol			= sanitize_integer(mastervol, 0, 100, initial(mastervol))
	domhand				= sanitize_integer(domhand, 1, 2, initial(domhand))
	attack_blip_frequency = sanitize_integer(attack_blip_frequency, 0, 100, ATTACK_BLIP_PREF_DEFAULT)

	// lists
	favorited_slots		= SANITIZE_LIST(favorited_slots)
	tgui_theme			= sanitize_inlist(tgui_theme, GLOB.tgui_themes, initial(tgui_theme))
	parchment_skin		= sanitize_inlist(parchment_skin, GLOB.parchment_skins, "leatherbound")
	statbrowser_theme	= sanitize_inlist(statbrowser_theme, GLOB.statbrowser_themes, "dark")
	exp					= SANITIZE_LIST(exp)
	menuoptions			= SANITIZE_LIST(menuoptions)
	be_special			= SANITIZE_LIST(be_special)
	key_bindings 		= SANITIZE_LIST(key_bindings)

	// etc
	asaycolor			= sanitize_ooccolor(sanitize_hexcolor(asaycolor, 6, TRUE, initial(asaycolor)))
	lastchangelog		= sanitize_text(lastchangelog, initial(lastchangelog))
	preferred_ui_language = sanitize_preferred_ui_language(preferred_ui_language)

	if(parent && is_banned_from(parent.ckey, ROLE_SYNDICATE))
		be_special = list()
	verify_keybindings_valid()


/datum/preferences/proc/verify_keybindings_valid()
	// Sanitize the actual keybinds to make sure they exist.
	for(var/key in key_bindings)
		if(!islist(key_bindings[key]))
			key_bindings -= key
		var/list/binds = key_bindings[key]
		for(var/bind in binds)
			if(!GLOB.keybindings_by_name[bind])
				binds -= bind
		if(!length(binds))
			key_bindings -= key
	// End

/client/verb/export_savefile()
	set name = "Export Preferences"
	set desc = "Export your preferences to a file."
	set category = "OOC"
	if(!prefs.path)
		return

	if(alert(src, "Are you sure you want to export your preferences? This will create a file on your computer that contains your preferences.", "Export Preferences", "Yes", "No") == "No")
		return

	if(!fexists(prefs.path))
		to_chat(src, span_warning("No savefile, what?!"))
		return

	var/file_name = "[ckey].sav"
	var/exportable_file = file(prefs.path)

	DIRECT_OUTPUT(src, ftp(exportable_file, file_name))

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	WRITE_FILE(S["version"] , SAVEFILE_VERSION_MAX)		//updates (or failing that the sanity checks) will ensure data is not invalid at load. Assume up-to-date

	//general preferences
	WRITE_FILE(S["favorited_slots"], favorited_slots)
	WRITE_FILE(S["asaycolor"], asaycolor)
	WRITE_FILE(S["musicvol"], musicvol)
	WRITE_FILE(S["lobbymusicvol"], lobbymusicvol)
	WRITE_FILE(S["ambiencevol"], ambiencevol)
	WRITE_FILE(S["anonymize"], anonymize)
	WRITE_FILE(S["stopdroning"], stopdroning)
	WRITE_FILE(S["masked_examine"], masked_examine)
	WRITE_FILE(S["full_examine"], full_examine)
	WRITE_FILE(S["mute_animal_emotes"], mute_animal_emotes)
	WRITE_FILE(S["autoconsume"], autoconsume)
	WRITE_FILE(S["no_examine_blocks"], no_examine_blocks)
	WRITE_FILE(S["no_autopunctuate"], no_autopunctuate)
	WRITE_FILE(S["no_language_fonts"], no_language_fonts)
	WRITE_FILE(S["no_language_icon"], no_language_icon)
	WRITE_FILE(S["no_redflash"], no_redflash)
	WRITE_FILE(S["top_examine"], top_examine)
	WRITE_FILE(S["crt"], crt)
	WRITE_FILE(S["grain"], grain)
	WRITE_FILE(S["sexable"], sexable)
	WRITE_FILE(S["shake"], shake)
	WRITE_FILE(S["mastervol"], mastervol)
	WRITE_FILE(S["lastchangelog"], lastchangelog)
	WRITE_FILE(S["showrolls"], showrolls)
	WRITE_FILE(S["chatheadshot"] , chatheadshot)
	WRITE_FILE(S["tgui_lock"], tgui_lock)
	WRITE_FILE(S["tgui_theme"], tgui_theme)
	WRITE_FILE(S["parchment_skin"], parchment_skin)
	WRITE_FILE(S["statbrowser_theme"], statbrowser_theme)
	WRITE_FILE(S["preferred_ui_language"], preferred_ui_language)
	WRITE_FILE(S["windowflash"], windowflashing)
	WRITE_FILE(S["be_special"], be_special)
	WRITE_FILE(S["no_storyteller_events"], no_storyteller_events)
	WRITE_FILE(S["verbose_character_creator"], verbose_character_creator)
	WRITE_FILE(S["default_slot"], default_slot)
	WRITE_FILE(S["toggles"], toggles)
	WRITE_FILE(S["chat_toggles"], chat_toggles)
	WRITE_FILE(S["combat_toggles"], combat_toggles)
	WRITE_FILE(S["ghost_toggles"], ghost_toggles)
	WRITE_FILE(S["admin_chat_toggles"], admin_chat_toggles)
	WRITE_FILE(S["clientfps"], clientfps)
	WRITE_FILE(S["ambientocclusion"], ambientocclusion)
	WRITE_FILE(S["auto_fit_viewport"], auto_fit_viewport)
	WRITE_FILE(S["menuoptions"], menuoptions)
	WRITE_FILE(S["key_bindings"], key_bindings)
	WRITE_FILE(S["attack_blip_frequency"] , attack_blip_frequency)
	WRITE_FILE(S["compliance_notifs"], compliance_notifs)
	return TRUE


/datum/preferences/proc/_load_species(S, species_name = null)
	if(!species_name)
		S["species"] >> species_name

	if(species_name)
		var/newtype = GLOB.species_list[species_name]
		if(newtype)
			pref_species = new newtype
			if(!spec_check())
				testing("spec_check() failed on type [newtype] and name [species_name], defaulting to [default_species].")
				pref_species = new default_species.type()
			else
				testing("spec_check() succeeded on type [newtype] and name [species_name].")
		else

			pref_species = new default_species.type()
	else
		pref_species = new default_species.type()
	if(pref_species.custom_selection)
		S["race_bonus"] >> race_bonus

/datum/preferences/proc/_load_flaw(S)
	S["charflaws"] >> charflaws
	// Sanitize
	charflaws = sanitize_islist(charflaws, list())

	for(var/flaw_type in charflaws)
		if(!ispath(flaw_type, /datum/charflaw))
			charflaws -= flaw_type
			continue

	if(!LAZYLEN(charflaws))
		charflaws = list(/datum/charflaw/noflaw)

/datum/preferences/proc/_load_culinary_preferences(S)
	S["favorite_cuisine"] >> favorite_cuisine
	S["favorite_dish"] >> favorite_dish
	S["favorite_drink"] >> favorite_drink
	sanitize_culinary_preferences()

/datum/preferences/proc/_load_statpack(S)
	var/statpack_type
	S["statpack"] >> statpack_type
	statpack = GLOB.statpacks[statpack_type]
	if(!statpack)
		statpack = GLOB.statpacks[/datum/statpack/wildcard/fated]

/datum/preferences/proc/_load_virtue(S)
	var/virtue_type
	var/virtuetwo_type
	var/origin_type
	S["virtue"] >> virtue_type
	S["virtuetwo"] >> virtuetwo_type
	S["virtue_origin"] >> origin_type
	var/list/virtue_choices = list()
	var/list/virtuetwo_choices = list()
	var/virtone
	var/virttwo
	S["virtuechoices"] >> virtone
	S["virtuetwochoices"] >> virttwo
	virtue_choices = virtone
	virtuetwo_choices = virttwo

	// If we still find a living ref, we clean it up. This is deprecated and we shouldn't be saving whole datums.
	if (istype(virtue_type, /datum/virtue))
		var/datum/virtue/V = virtue_type
		virtue = new V.type
		if(length(V.picked_choices))
			virtue.picked_choices = V.picked_choices
		qdel(V)
	else if(ispath(virtue_type, /datum/virtue))
		virtue = new virtue_type
	else
		virtue = new /datum/virtue/none

	// Ditto, but for the second virtue.
	if(istype(virtuetwo_type, /datum/virtue))
		var/datum/virtue/V = virtuetwo_type
		virtuetwo = new V.type
		if(length(V.picked_choices))
			virtuetwo.picked_choices = V.picked_choices
		qdel(V)
	else if(ispath(virtuetwo_type, /datum/virtue))
		virtuetwo = new virtuetwo_type
	else
		virtuetwo = new /datum/virtue/none

	if(length(virtue_choices))
		virtue.picked_choices = virtue_choices.Copy()

	if(length(virtuetwo_choices))
		virtuetwo.picked_choices = virtuetwo_choices.Copy()

	virtue.on_load()
	virtuetwo.on_load()

	if(ispath(origin_type, /datum/virtue/origin))
		virtue_origin = new origin_type
	else
		virtue_origin = new /datum/virtue/origin/unknown

/datum/preferences/proc/_load_gear_list(savefile/S)
	S["gear_list"] >> gear_list
	gear_list = SANITIZE_LIST(gear_list)
	// Validate: remove items that no longer exist
	for(var/item_name in gear_list)
		if(!(item_name in GLOB.loadout_items_by_name))
			gear_list -= item_name

/datum/preferences/proc/_load_combat_music(S)
	var/combat_music_type
	S["combat_music"] >> combat_music_type
	if(GLOB.cmode_tracks_by_type[combat_music_type])
		combat_music = GLOB.cmode_tracks_by_type[combat_music_type]
	else
		combat_music = GLOB.cmode_tracks_by_type[default_cmusic_type]

/datum/preferences/proc/_load_barks(S)
	S["bark_id"] >> bark_id
	S["bark_speed"] >> bark_speed
	S["bark_pitch"] >> bark_pitch
	S["bark_variance"] >> bark_variance
	S["mute_barks"] >> mute_barks

	// this instead of sanitize_inlist because we don't always wanna pick
	if(!(bark_id in GLOB.bark_list))
		bark_id = pick(GLOB.bark_random_list)
	var/datum/bark/B = GLOB.bark_list[bark_id]
	bark_speed = round(clamp(bark_speed, B::minspeed, B::maxspeed), 1)
	bark_pitch = clamp(bark_pitch, B::minpitch, B::maxpitch)
	bark_variance = clamp(bark_variance, B::minvariance, B::maxvariance)
	mute_barks = sanitize_bool(mute_barks, initial(mute_barks))

/datum/preferences/proc/_load_appearence(S)
	S["real_name"]			>> real_name
	S["gender"]				>> gender
	S["domhand"]			>> domhand
	S["age"]				>> age
	S["vampire_skin"]		>> vampire_skin
	S["vampire_hair"]		>> vampire_hair
	S["vampire_eyes"]		>> vampire_eyes
	S["vampire_ears"]		>> vampire_ears
	S["extra_language"]		>> extra_language
	S["voice_color"]		>> voice_color
	S["voice_pitch"]		>> voice_pitch
	S["skin_tone"]			>> skin_tone
	S["feature_mcolor"]		>> features["mcolor"]
	S["feature_mcolor2"]	>> features["mcolor2"]
	S["feature_mcolor3"]	>> features["mcolor3"]
	S["pronouns"]			>> pronouns
	S["titles_pref"]		>> titles_pref
	S["clothes_pref"]		>> clothes_pref
	S["voice_type"]			>> voice_type
	S["voice_pack"]			>> voice_pack
	S["nickname"]			>> nickname
	S["highlight_color"]	>> highlight_color
	S["taur_type"]			>> taur_type
	S["taur_color"]			>> taur_color

/datum/preferences/proc/_load_familiar_prefs(S)
	S["familiar_names"]					>> familiar_prefs.familiar_names
	S["familiar_pronouns"]				>> familiar_prefs.familiar_pronouns
	S["familiar_species"]				>> familiar_prefs.familiar_species
	S["familiar_voice_colors"]			>> familiar_prefs.familiar_voice_colors
	S["familiar_flavortext"]			>> familiar_prefs.familiar_flavortext
	S["familiar_flavortext_display"]	>> familiar_prefs.familiar_flavortext_display
	S["familiar_headshot_link"]			>> familiar_prefs.familiar_headshot_link
	S["familiar_ooc_notes"]				>> familiar_prefs.familiar_ooc_notes
	S["familiar_ooc_notes_display"]		>> familiar_prefs.familiar_ooc_notes_display
	S["familiar_ooc_extra"]				>> familiar_prefs.familiar_ooc_extra
	S["familiar_ooc_extra_link"]		>> familiar_prefs.familiar_ooc_extra_link

/datum/preferences/proc/load_character(slot)
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		WRITE_FILE(S["default_slot"] , slot)

	S.cd = "/character[slot]"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		return FALSE

	loaded_slot = slot

	//Species
	_load_species(S)

	_load_virtue(S)
	_load_flaw(S)

	_load_culinary_preferences(S)

	// LETHALSTONE edit: jank-ass load our statpack choice
	_load_statpack(S)

	_load_gear_list(S)

	_load_combat_music(S)
	_load_barks(S)

	//Character
	_load_appearence(S)
	_load_familiar_prefs(S)

	var/patron_typepath
	S["selected_patron"]	>> patron_typepath
	if(patron_typepath)
		selected_patron = GLOB.patronlist[patron_typepath]
		if(!selected_patron) //failsafe
			selected_patron = GLOB.patronlist[default_patron]

	//Jobs
	S["joblessrole"] >> joblessrole
	//Load prefs
	S["job_preferences"] >> job_preferences
	S["job_subprefs"] >> job_subprefs

	S["dnr"] >> dnr_pref

	S["update_mutant_colors"] >> update_mutant_colors

	S["headshot_link"]			>> headshot_link
	S["vampire_headshot_link"]	>> vampire_headshot_link
	S["lich_headshot_link"]		>> lich_headshot_link
	//setting up the hooks for this, but not shown yet
	S["werewolf_headshot_link"]	>> werewolf_headshot_link

	S["qsr"] 					>> qsr_pref
	S["flavortext"]				>> flavortext
	S["ooc_notes"]				>> ooc_notes
	S["ooc_extra"]				>> ooc_extra
	S["rumour"]					>> rumour
	S["noble_gossip"]			>> noble_gossip
	S["averse_chosen_faction"]	>> averse_chosen_faction
	S["song_artist"]			>> song_artist
	S["song_title"]				>> song_title
	S["nsfwflavortext"]			>> nsfwflavortext
	S["erpprefs"]				>> erpprefs

	S["preset_bounty_enabled"]			>> preset_bounty_enabled
	S["preset_bounty_poster_key"]		>> preset_bounty_poster_key
	S["preset_bounty_severity_key"]		>> preset_bounty_severity_key
	S["preset_bounty_severity_b_key"]	>> preset_bounty_severity_b_key
	S["preset_bounty_severity_v_key"]	>> preset_bounty_severity_v_key
	S["preset_bounty_crime"]			>> preset_bounty_crime

	S["img_gallery"]		>> img_gallery
	S["nsfw_img_gallery"]	>> nsfw_img_gallery

	S["examine_theme"]		>> examine_theme

	S["body_size"] >> features["body_size"]
	S["body_markings"] >> body_markings

	S["descriptor_entries"] >> descriptor_entries
	S["custom_descriptors"] >> custom_descriptors

	S["customizer_entries"] >> customizer_entries
	S["topjob"] >> topjob

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		update_character(needs_update, S)		//needs_update == savefile_version if we need an update (positive integer)

	// Regenerate cache for flavor texts etc. Must be UNCONDITIONAL because prefs is on client.
	// We use empty string if they are empty, so the previous slot's data don't get kept in the cache.
	flavortext_cached = flavortext ? parsemarkdown_basic(html_encode(flavortext), hyperlink = TRUE) : ""
	ooc_notes_cached = ooc_notes ? parsemarkdown_basic(html_encode(ooc_notes), hyperlink = TRUE) : ""
	nsfwflavortext_cached = nsfwflavortext ? parsemarkdown_basic(html_encode(nsfwflavortext), hyperlink = TRUE) : ""
	erpprefs_cached = erpprefs ? parsemarkdown_basic(html_encode(erpprefs), hyperlink = TRUE) : ""
	rumour_cached = rumour ? parsemarkdown_basic(html_encode(rumour), hyperlink = TRUE) : ""
	noble_gossip_cached = noble_gossip ? parsemarkdown_basic(html_encode(noble_gossip), hyperlink = TRUE) : ""

	//Sanitize: Note, some sanitization is already done in subprocs like _load_combat_music
	sanitize_character(S)
	return TRUE

// takes a savefile for writebacks
/datum/preferences/proc/sanitize_character(savefile/S)
	gender = sanitize_gender(gender)

	// names
	real_name = reject_bad_name(real_name)
	if(!real_name)
		real_name = random_unique_name(gender)

	nickname = reject_bad_name(nickname)
	if(!nickname)
		nickname = initial(nickname)

	// colors
	if(!features["mcolor"] || features["mcolor"] == "#000")
		features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features["mcolor2"] || features["mcolor2"] == "#000")
		features["mcolor2"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features["mcolor3"] || features["mcolor3"] == "#000")
		features["mcolor3"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	features["mcolor"]	= sanitize_hexcolor(features["mcolor"], 6, FALSE)
	features["mcolor2"]	= sanitize_hexcolor(features["mcolor2"], 6, FALSE)
	features["mcolor3"]	= sanitize_hexcolor(features["mcolor3"], 6, FALSE)
	voice_color			= sanitize_hexcolor(voice_color, 6, TRUE, initial(voice_color))
	taur_color			= sanitize_hexcolor(taur_color, 6, TRUE, initial(taur_color))
	vampire_skin = sanitize_hexcolor(vampire_skin, 6, TRUE, null, TRUE)
	vampire_eyes = sanitize_hexcolor(vampire_eyes, 6, TRUE, null, TRUE)
	vampire_hair = sanitize_hexcolor(vampire_hair, 6, TRUE, null, TRUE)
	vampire_ears = sanitize_hexcolor(vampire_ears, 6, TRUE, null, TRUE)
	highlight_color = sanitize_hexcolor(highlight_color, 6, TRUE, initial(highlight_color))

	// floats
	voice_pitch		= sanitize_float(voice_pitch, MIN_VOICE_PITCH, MAX_VOICE_PITCH, 0.01, 1)
	features["body_size"] = sanitize_float(features["body_size"], BODY_SIZE_MIN, BODY_SIZE_MAX, 0.01, BODY_SIZE_NORMAL)

	// lists
	age				= sanitize_inlist(age, pref_species.possible_ages, AGE_ADULT)
	extra_language	= sanitize_inlist(extra_language, GLOB.languages_character_selection, "None") // None just becomes None so it's fine
	pronouns		= sanitize_inlist(pronouns, GLOB.pronouns_list, THEY_THEM)
	titles_pref		= sanitize_inlist(titles_pref, GLOB.titles_list, TITLES_M)
	clothes_pref	= sanitize_inlist(clothes_pref, GLOB.clothespref_list, CLOTHES_M)
	voice_type		= sanitize_inlist(voice_type, GLOB.voice_types_list, VOICE_TYPE_MASC)
	voice_pack		= sanitize_inlist(voice_pack, GLOB.voice_packs_list, VOICE_PACK_DEFAULT)
	race_bonus		= sanitize_inlist_no_pick(race_bonus, pref_species.custom_selection, initial(race_bonus))
	examine_theme	= sanitize_inlist_no_pick(examine_theme, GLOB.tgui_themes, initial(examine_theme))
	taur_type		= sanitize_inlist_no_pick(taur_type, pref_species.get_taur_list(), null)
	averse_chosen_faction = sanitize_inlist(averse_chosen_faction, GLOB.averse_factions, initial(averse_chosen_faction))
	// these are fine: null isn't in list -> becomes null again
	preset_bounty_poster_key		= sanitize_inlist_no_pick(preset_bounty_poster_key, GLOB.bounty_posters, null)
	preset_bounty_severity_key		= sanitize_inlist_no_pick(preset_bounty_severity_key, GLOB.wretch_severities, null)
	preset_bounty_severity_v_key	= sanitize_inlist_no_pick(preset_bounty_severity_v_key, GLOB.vagabond_severities, null)
	preset_bounty_severity_b_key	= sanitize_inlist_no_pick(preset_bounty_severity_b_key, GLOB.bandit_severities, null)

	img_gallery = SANITIZE_LIST(img_gallery)
	nsfw_img_gallery = SANITIZE_LIST(nsfw_img_gallery)
	job_preferences = SANITIZE_LIST(job_preferences)

	// text
	ooc_extra		= sanitize_text(ooc_extra, initial(ooc_extra))
	song_artist		= sanitize_text(song_artist, initial(song_artist))
	song_title		= sanitize_text(song_title, initial(song_title))
	rumour			= sanitize_text(rumour, initial(rumour))
	noble_gossip	= sanitize_text(noble_gossip, initial(noble_gossip))
	joblessrole		= sanitize_text(joblessrole, initial(joblessrole))
	preset_bounty_crime = sanitize_text(preset_bounty_crime, initial(preset_bounty_crime))

	// complex/other stuff
	preset_bounty_enabled = sanitize_bool(preset_bounty_enabled, initial(preset_bounty_enabled))
	update_mutant_colors = sanitize_bool(update_mutant_colors, initial(update_mutant_colors))

	body_markings = SANITIZE_LIST(body_markings)
	validate_body_markings()

	descriptor_entries = SANITIZE_LIST(descriptor_entries)
	custom_descriptors = SANITIZE_LIST(custom_descriptors)
	validate_descriptors()

	var/list/valid_skin_tones = pref_species.get_skin_list()
	var/list/valid_skin_colors = list()
	for(var/skin_tone in valid_skin_tones)
		valid_skin_colors += valid_skin_tones[skin_tone]
	skin_tone = sanitize_inlist(skin_tone, valid_skin_colors, valid_skin_colors[1])

	if(!valid_headshot_link(null, headshot_link, TRUE))
		headshot_link = null

	if(!valid_headshot_link(null, vampire_headshot_link, TRUE))
		vampire_headshot_link = null

	if(!valid_headshot_link(null, lich_headshot_link, TRUE))
		lich_headshot_link = null

	if(!valid_headshot_link(null, werewolf_headshot_link, TRUE))
		werewolf_headshot_link = null

	//Validate job prefs
	var/topjob_found = FALSE
	for(var/j in job_preferences)
		if(job_preferences[j] != JP_LOW && job_preferences[j] != JP_MEDIUM && job_preferences[j] != JP_HIGH)
			job_preferences -= j
		if(job_preferences[j] == JP_HIGH)
			topjob_found = TRUE
			var/datum/job/prefjob = SSjob.GetJob(j)
			if(prefjob)
				topjob = prefjob.title
			WRITE_FILE(S["topjob"], topjob)
	if(!topjob_found && topjob)	// Fallback in case we load a slot that had HIGH set but then it got unset / job got altered.
		topjob = null
		WRITE_FILE(S["topjob"], topjob)

	validate_customizer_entries()

	// Sanitize virtues
	if(!virtue)
		virtue = new /datum/virtue/none
	if(!virtuetwo)
		virtuetwo = new /datum/virtue/none

	if(LAZYLEN(pref_species.restricted_virtues))
		if(virtue.type in pref_species.restricted_virtues)
			virtue = new /datum/virtue/none
		if(virtuetwo.type in pref_species.restricted_virtues)
			virtuetwo = new /datum/virtue/none

	if(istype(virtue, virtuetwo) && !virtue.stackable)
		virtuetwo = new /datum/virtue/none
	if(virtue.virtuous_only && !statpack.virtuous)
		virtue = new /datum/virtue/none

	if(!statpack.virtuous)
		virtuetwo = new /datum/virtue/none


/datum/preferences/proc/save_character()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/character[default_slot]"

	WRITE_FILE(S["version"]			, SAVEFILE_VERSION_MAX)	//load_character will sanitize any bad data, so assume up-to-date.)

	//Character
	WRITE_FILE(S["real_name"]			, real_name)
	WRITE_FILE(S["gender"]				, gender)
	WRITE_FILE(S["domhand"]				, domhand)
	WRITE_FILE(S["age"]					, age)
	WRITE_FILE(S["vampire_skin"]		, vampire_skin)
	WRITE_FILE(S["vampire_hair"]		, vampire_hair)
	WRITE_FILE(S["vampire_eyes"]		, vampire_eyes)
	WRITE_FILE(S["vampire_ears"]		, vampire_ears)
	WRITE_FILE(S["extra_language"]		, extra_language)
	WRITE_FILE(S["voice_color"]			, voice_color)
	WRITE_FILE(S["voice_pitch"]			, voice_pitch)
	WRITE_FILE(S["skin_tone"]			, skin_tone)
	WRITE_FILE(S["species"]				, pref_species.name)
	WRITE_FILE(S["charflaws"]			, charflaws)
	WRITE_FILE(S["feature_mcolor"]		, features["mcolor"])
	WRITE_FILE(S["feature_mcolor2"]		, features["mcolor2"])
	WRITE_FILE(S["feature_mcolor3"]		, features["mcolor3"])
	WRITE_FILE(S["nickname"]			, nickname)
	WRITE_FILE(S["highlight_color"]		, highlight_color)
	WRITE_FILE(S["taur_type"]			, taur_type)
	WRITE_FILE(S["taur_color"]			, taur_color)
	WRITE_FILE(S["favorite_cuisine"]	, favorite_cuisine)
	WRITE_FILE(S["favorite_dish"]		, favorite_dish)
	WRITE_FILE(S["favorite_drink"]		, favorite_drink)
	WRITE_FILE(S["topjob"]				, topjob)

	//Jobs
	WRITE_FILE(S["joblessrole"]		, joblessrole)
	//Write prefs
	WRITE_FILE(S["job_preferences"] , job_preferences)
	WRITE_FILE(S["job_subprefs"] , job_subprefs)

	//Patron
	WRITE_FILE(S["selected_patron"]		, selected_patron.type)

	// Organs
	var/list/packed_hair = list()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(!istype(entry, /datum/customizer_entry/hair))
			continue
		var/datum/customizer_entry/hair/hair_entry = entry
		packed_hair += hair_entry
		hair_pack(hair_entry)
	WRITE_FILE(S["customizer_entries"] , customizer_entries)
	for(var/datum/customizer_entry/hair/hair_entry as anything in packed_hair)
		hair_unpack(hair_entry)
	// Body markings
	WRITE_FILE(S["body_markings"] , body_markings)
	// Descriptor entries
	WRITE_FILE(S["descriptor_entries"] , descriptor_entries)
	WRITE_FILE(S["custom_descriptors"] , custom_descriptors)

	//Barks
	WRITE_FILE(S["bark_id"]					, bark_id)
	WRITE_FILE(S["bark_speed"]				, bark_speed)
	WRITE_FILE(S["bark_pitch"]				, bark_pitch)
	WRITE_FILE(S["bark_variance"]			, bark_variance)
	WRITE_FILE(S["mute_barks"]				, mute_barks)

	WRITE_FILE(S["dnr"] , dnr_pref)
	WRITE_FILE(S["update_mutant_colors"] , update_mutant_colors)
	WRITE_FILE(S["headshot_link"] , headshot_link)
	WRITE_FILE(S["vampire_headshot_link"] , vampire_headshot_link)
	WRITE_FILE(S["werewolf_headshot_link"] , werewolf_headshot_link)
	WRITE_FILE(S["lich_headshot_link"] , lich_headshot_link)
	WRITE_FILE(S["qsr"] , qsr_pref)
	WRITE_FILE(S["preset_bounty_enabled"] , preset_bounty_enabled)
	WRITE_FILE(S["preset_bounty_poster_key"] , preset_bounty_poster_key)
	WRITE_FILE(S["preset_bounty_severity_key"] , preset_bounty_severity_key)
	WRITE_FILE(S["preset_bounty_severity_b_key"] , preset_bounty_severity_b_key)
	WRITE_FILE(S["preset_bounty_severity_v_key"] , preset_bounty_severity_v_key)
	WRITE_FILE(S["preset_bounty_crime"] , preset_bounty_crime)
	WRITE_FILE(S["flavortext"] , html_decode(flavortext))
	WRITE_FILE(S["ooc_notes"] , html_decode(ooc_notes))
	WRITE_FILE(S["ooc_extra"] ,	ooc_extra)
	WRITE_FILE(S["rumour"] , html_decode(rumour))
	WRITE_FILE(S["noble_gossip"] , html_decode(noble_gossip))
	WRITE_FILE(S["averse_chosen_faction"] , html_decode(averse_chosen_faction))
	WRITE_FILE(S["song_artist"] , song_artist)
	WRITE_FILE(S["song_title"] , song_title)
	WRITE_FILE(S["examine_theme"] , examine_theme)
	WRITE_FILE(S["voice_type"] , voice_type)
	WRITE_FILE(S["voice_pack"] , voice_pack)
	WRITE_FILE(S["pronouns"] , pronouns)
	WRITE_FILE(S["titles_pref"] , titles_pref)
	WRITE_FILE(S["clothes_pref"] , clothes_pref)
	WRITE_FILE(S["statpack"] , statpack.type)
	WRITE_FILE(S["virtue"] , virtue.type)
	WRITE_FILE(S["virtuechoices"] , virtue.picked_choices)
	WRITE_FILE(S["virtuetwo"], virtuetwo.type)
	WRITE_FILE(S["virtuetwochoices"] , virtuetwo.picked_choices)
	WRITE_FILE(S["virtue_origin"], virtue_origin.type)
	WRITE_FILE(S["race_bonus"], race_bonus)
	WRITE_FILE(S["combat_music"], combat_music.type)
	WRITE_FILE(S["body_size"] , features["body_size"])
	WRITE_FILE(S["nsfwflavortext"] , html_decode(nsfwflavortext))
	WRITE_FILE(S["erpprefs"] , html_decode(erpprefs))
	WRITE_FILE(S["img_gallery"] , img_gallery)
	WRITE_FILE(S["nsfw_img_gallery"] , nsfw_img_gallery)

	WRITE_FILE(S["gear_list"], gear_list)

	//Familiar Files
	WRITE_FILE(S["familiar_names"] , familiar_prefs.familiar_names)
	WRITE_FILE(S["familiar_pronouns"] , familiar_prefs.familiar_pronouns)
	WRITE_FILE(S["familiar_species"] , familiar_prefs.familiar_species)
	WRITE_FILE(S["familiar_voice_colors"] , familiar_prefs.familiar_voice_colors)
	WRITE_FILE(S["familiar_flavortext"] , familiar_prefs.familiar_flavortext)
	WRITE_FILE(S["familiar_flavortext_display"] , familiar_prefs.familiar_flavortext_display)
	WRITE_FILE(S["familiar_headshot_link"] , familiar_prefs.familiar_headshot_link)
	WRITE_FILE(S["familiar_ooc_notes"] , familiar_prefs.familiar_ooc_notes)
	WRITE_FILE(S["familiar_ooc_notes_display"] , familiar_prefs.familiar_ooc_notes_display)
	WRITE_FILE(S["familiar_ooc_extra"] , familiar_prefs.familiar_ooc_extra)
	WRITE_FILE(S["familiar_ooc_extra_link"] , familiar_prefs.familiar_ooc_extra_link)

	return TRUE

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN

#ifdef TESTING
//DEBUG
//Some crude tools for testing savefiles
//path is the savefile path
/client/verb/savefile_export(path as text)
	set hidden = TRUE
	var/savefile/S = new /savefile(path)
	S.ExportText("/",file("[path].txt"))
//path is the savefile path
/client/verb/savefile_import(path as text)
	set hidden = TRUE
	var/savefile/S = new /savefile(path)
	S.ImportText("/",file("[path].txt"))

#endif
