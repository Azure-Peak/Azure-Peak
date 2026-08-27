GLOBAL_LIST_EMPTY(preferences_datums)

GLOBAL_LIST_EMPTY(chosen_names)

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 60
	var/loaded_slot = 1
	var/savefile_write_locked = FALSE // guard against simultaneous savefile writes from the UI causing any sort of horrors

	//non-preference stuff
	var/muted = 0
	// Commend variable on prefs instead of client to prevent reconnect abuse (is persistant on prefs, opposed to not on client)
	var/commendedsomeone = FALSE
	var/db_flags

	//game-preferences
	var/favorited_slots = list()
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/asaycolor = "#ff4500"			//This won't change the color for current admins, only incoming ones.

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/showrolls = TRUE

	// Custom Keybindings
	var/list/key_bindings = list()

	var/tgui_lock = TRUE
	var/tgui_theme = "azure_default"
	var/parchment_skin = "leatherbound"
	var/statbrowser_theme = "dark"
	var/windowflashing = TRUE
	var/verbose_character_creator = TRUE // Output chat messages for every change you make as a psuedo-history

	var/toggles = TOGGLES_DEFAULT
	var/ghost_toggles
	var/combat_toggles = TOGGLES_TEXT_DEFAULT
	var/admin_chat_toggles = TOGGLES_DEFAULT_CHAT_ADMIN
	var/chat_toggles = TOGGLES_DEFAULT_CHAT

	var/topjob = null

	//character preferences
	var/real_name						//our character's name
	var/gender = MALE					//gender of character (well duh) (LETHALSTONE EDIT: this no longer references anything but whether the masculine or feminine model is used)
	var/pronouns = HE_HIM				// LETHALSTONE EDIT: character's pronouns (well duh)
	var/titles_pref = TITLES_M
	var/clothes_pref = CLOTHES_M
	var/voice_pack = VOICE_PACK_DEFAULT
	var/voice_type = VOICE_TYPE_MASC	// LETHALSTONE EDIT: the type of soundpack the mob should use
	var/datum/statpack/statpack	= new /datum/statpack/wildcard/fated // LETHALSTONE EDIT: the statpack we're giving our char instead of racial bonuses
	var/datum/virtue/virtue = new /datum/virtue/none // LETHALSTONE EDIT: the virtue we get for not picking a statpack
	var/datum/virtue/virtuetwo = new /datum/virtue/none
	var/datum/virtue/virtue_origin = new /datum/virtue/origin/unknown
	var/age = AGE_ADULT						//age of character
	var/skin_tone = "caucasian1"		//Skin color
	var/vampire_skin = null
	var/vampire_eyes = null
	var/vampire_hair = null
	var/vampire_ears = null
	var/extra_language = "None" // Extra language
	var/voice_color = "#a0a0a0"
	var/voice_pitch = 1
	var/datum/species/pref_species = new /datum/species/human/northern()	//Mutant race
	var/static/datum/species/default_species = new /datum/species/human/northern()
	var/datum/patron/selected_patron
	var/static/datum/patron/default_patron = /datum/patron/divine/undivided
	var/list/features = MANDATORY_FEATURE_LIST
	var/shake = TRUE
	var/sexable = FALSE
	var/compliance_notifs = TRUE

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()
	/// Preferences specific to a job. Alist, job title = (some object, usually a list)
	var/list/job_subprefs = list()

	// Want randomjob if preferences already filled - Donkie
	var/joblessrole = RETURNTOLOBBY  //defaults to 1 for fewer assistants

	var/clientfps = 100//0 is sync

	var/ambientocclusion = TRUE
	var/auto_fit_viewport = FALSE

	var/musicvol = 50
	var/lobbymusicvol = 50
	var/ambiencevol = 50
	var/mastervol = 50
	var/stopdroning = FALSE

	var/anonymize = TRUE
	var/masked_examine = FALSE
	var/full_examine = FALSE
	var/mute_animal_emotes = FALSE
	var/autoconsume = FALSE
	var/no_examine_blocks = FALSE
	var/no_autopunctuate = FALSE
	var/no_language_fonts = FALSE
	var/no_language_icon = FALSE
	var/no_redflash = FALSE
	var/no_storyteller_events = FALSE
	var/top_examine = FALSE

	var/list/exp = list()
	var/list/menuoptions

	var/datum/migrant_pref/migrant

	var/domhand = 2
	var/nickname = "Please Change Me"
	var/highlight_color = "#FF0000"
	var/list/charflaws = list()

	var/static/default_cmusic_type = /datum/combat_music/default
	var/datum/combat_music/combat_music
	var/combat_music_helptext_shown = FALSE

	var/crt = FALSE
	var/grain = TRUE
	var/dnr_pref = FALSE
	var/qsr_pref = FALSE

	var/list/customizer_entries = list()
	var/list/list/body_markings = list()
	var/update_mutant_colors = TRUE // if TRUE, resets accessory and marking colors when mutant colors change

	var/headshot_link
	var/lich_headshot_link
	var/vampire_headshot_link
	var/werewolf_headshot_link //not used but setting up for the future
	var/chatheadshot = FALSE
	var/ooc_extra
	var/song_artist
	var/song_title
	var/list/descriptor_entries = list()
	var/list/custom_descriptors = list()
	COOLDOWN_DECLARE(descriptor_preview)

	var/list/gear_list = list()	// Assoc list: item_name = list("color"=..., "custom_name"=..., "custom_desc"=...)

	var/flavortext
	var/flavortext_cached

	var/ooc_notes
	var/ooc_notes_cached

	var/nsfwflavortext
	var/nsfwflavortext_cached

	var/erpprefs
	var/erpprefs_cached

	var/rumour
	var/rumour_cached

	var/noble_gossip
	var/noble_gossip_cached

	var/list/img_gallery = list()
	var/list/nsfw_img_gallery = list()

	var/datum/familiar_prefs/familiar_prefs

	var/taur_type = null
	var/taur_color = "#ffffff"

	var/favorite_cuisine = NONE
	var/favorite_dish = NONE
	var/favorite_drink = NONE

	var/race_bonus

	var/preset_bounty_enabled = FALSE
	var/preset_bounty_poster_key
	var/preset_bounty_severity_key
	var/preset_bounty_severity_b_key
	var/preset_bounty_severity_v_key
	var/preset_bounty_crime


	var/averse_chosen_faction = "Inquisition"

	var/attack_blip_frequency = ATTACK_BLIP_PREF_DEFAULT

	/// Per-character theme override for examine panel viewers
	var/examine_theme

	// Vocal bark prefs
	var/bark_id = "mutedc3"
	var/bark_speed = 4
	var/bark_pitch = 1
	var/bark_variance = 0.2
	COOLDOWN_DECLARE(bark_previewing)
	var/mute_barks = FALSE

/datum/preferences/New(client/C)
	parent = C
	migrant = new /datum/migrant_pref(src)
	familiar_prefs = new /datum/familiar_prefs(src)

	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			if(C.IsByondMember())
				max_save_slots = 100
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return

	// Set the race to properly run race setter logic
	set_new_race(pref_species, null, skip_random = TRUE)
	// Do a FULL scramble
	random_character(null, RANDOMIZE_NEW_CHARACTER)

	if(!combat_music)
		combat_music = GLOB.cmode_tracks_by_type[default_cmusic_type]
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	C.update_movement_keys()
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

// Only use skip_random if you are immediately going to call random_character(null, RANDOMIZE_MINIMAL) or higher
// Otherwise the preferences will be left in an invalid state!
/datum/preferences/proc/set_new_race(datum/species/new_race, user, skip_random = FALSE)
	pref_species = new_race
	// new species can have job restrictions so merk job prefs
	ResetJobs()
	if(user)
		to_chat(user, span_notice("You have switched your race to [pref_species.desc_title]."))
		to_chat(user, span_red("Classes reset."))

	// get them back to a stable default
	race_bonus = null
	customizer_entries = list()
	validate_customizer_entries()
	// Descriptors depend on species, so we have to reset them
	reset_descriptors()

	// actually randomize if allowed
	if(!skip_random)
		random_character(gender, RANDOMIZE_MINIMAL)

/datum/preferences/proc/spec_check(mob/user)
	if(!istype(pref_species))
		return FALSE
	if(!(pref_species.name in get_selectable_species()))
		return FALSE
	if(!pref_species.check_roundstart_eligible())
		return FALSE
	return TRUE

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["preference"] == "keybindings_set")
		KeybindingSet(
			user,
			href_list["keybinding"],
			text2num(href_list["clear_key"]),
			href_list["old_key"],
			href_list["key"],
			text2num(href_list["alt"]),
			text2num(href_list["ctrl"]),
			text2num(href_list["shift"]),
			text2num(href_list["numpad"])
		)
		return TRUE

/// Does the actual reset
/datum/preferences/proc/force_reset_keybindings_direct()
	var/list/oldkeys = key_bindings
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key)

	for(var/key in oldkeys)
		if(!key_bindings[key])
			key_bindings[key] = oldkeys[key]
	parent?.ensure_keys_set(src)

/datum/preferences/proc/is_active_migrant()
	if(!migrant)
		return FALSE
	if(!migrant.queued_wave)
		return FALSE
	return TRUE
