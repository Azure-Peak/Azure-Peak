// Used to generate the preferences.json containing metadata for the UI
/datum/asset/json/preferences
	name = "preferences"
	early = TRUE

/datum/asset/json/preferences/generate()
	var/list/data = list(
		// Defines
		"MAX_VICES" = MAX_VICES,
		"MINIMUM_FLAVOR_TEXT" = MINIMUM_FLAVOR_TEXT,
		"MINIMUM_OOC_NOTES" = MINIMUM_OOC_NOTES,
		"MAX_KEYS_PER_KEYBIND" = MAX_KEYS_PER_KEYBIND,
		"MAX_NOTE_SIZE" = MAX_NOTE_SIZE,
		"MAXIMUM_MARKINGS_PER_LIMB" = MAXIMUM_MARKINGS_PER_LIMB,
		"MIN_VOICE_PITCH" = MIN_VOICE_PITCH,
		"MAX_VOICE_PITCH" = MAX_VOICE_PITCH,
		// Lists
		"barksounds" = get_barksounds(),
		"charflaws" = get_charflaws(),
		"classes" = get_classes(),
		"combat_music" = get_combat_music(),
		"culinary" = get_culinary(),
		"customizer_choices" = get_customizer_choices(),
		"customizers" = get_customizers(),
		"descriptor_choices" = get_descriptor_choices(),
		"descriptors" = get_descriptors(),
		"faiths" = get_faiths(),
		"markings_by_zone" = get_markings_by_zone(),
		"patrons" = get_patrons(),
		"preview_backgrounds" = get_preview_bgs(),
		"species" = get_species(),
		"sprite_accessories" = get_sprite_accessories(),
		"statpacks" = get_statpacks(),
		"taur_types" = get_taur_types(),
		"tgui_themes" = GLOB.tgui_themes,
		"virtues" = get_virtues(),
		"voicepacks" = get_voicepacks(),
		// Other data
		"lore_primer" = build_lore_primer_content(),
	)

	return data

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/asset/json/preferences/generate()
	var/list/data = ..()

	data[...] = ...

	return data
*/

/datum/asset/json/preferences/proc/get_barksounds()
	. = list()
	for(var/id in GLOB.bark_list)
		var/datum/bark/B = GLOB.bark_list[id]
		if(B::ignore)
			continue
		. += B::name

/datum/asset/json/preferences/proc/get_charflaws()
	. = list()
	for(var/cf_path in GLOB.character_flaws_singletons)
		var/datum/charflaw/cf = GLOB.character_flaws_singletons[cf_path]
		.["[cf_path]"] = cf.constant_ui_data()

/datum/asset/json/preferences/proc/get_classes()
	. = list()
	// Force SSjob to load occupations
	SSjob.GetJob()

	for(var/datum/job/job as anything in SSjob.occupations)
		// note: this transmits info about all existing jobs with 0 respect for any secrecy
		.["[job.title]"] = job.constant_ui_data()

/datum/asset/json/preferences/proc/get_combat_music()
	. = list()
	for(var/name in GLOB.cmode_tracks_by_name)
		var/datum/combat_music/combat_music = GLOB.cmode_tracks_by_name[name]
		.["[combat_music.name]"] = combat_music.constant_ui_data()

/datum/asset/json/preferences/proc/get_culinary()
	. = list(
		"cuisines" = GLOB.culinary_cuisines,
		"dishes" = GLOB.culinary_dishes,
		"drinks" = GLOB.culinary_drinks,
	)

/datum/asset/json/preferences/proc/get_customizer_choices()
	. = list()
	for(var/type in GLOB.customizer_choices)
		var/datum/customizer_choice/choice = GLOB.customizer_choices[type]
		.[type] = choice.constant_ui_data()

/datum/asset/json/preferences/proc/get_customizers()
	. = list()
	for(var/type in GLOB.customizers)
		var/datum/customizer/customizer = GLOB.customizers[type]
		.[type] = customizer.constant_ui_data()

/datum/asset/json/preferences/proc/get_descriptor_choices()
	. = list()
	for(var/type in GLOB.descriptor_choices)
		var/datum/descriptor_choice/choice = GLOB.descriptor_choices[type]
		.[type] = choice.constant_ui_data()

/datum/asset/json/preferences/proc/get_descriptors()
	. = list()
	for(var/type in GLOB.mob_descriptors)
		var/datum/mob_descriptor/descriptor = GLOB.mob_descriptors[type]
		.[type] = descriptor.constant_ui_data()

/datum/asset/json/preferences/proc/get_faiths()
	. = list()
	for(var/type in GLOB.preference_faiths)
		var/datum/faith/faith = GLOB.preference_faiths[type]
		if(faith.name)
			.[type] = faith.constant_ui_data()

/datum/asset/json/preferences/proc/get_markings_by_zone()
	. = list()
	for(var/zone in GLOB.body_markings_per_limb)
		var/list/data_for_this_zone = list()
		for(var/marking_name in GLOB.body_markings_per_limb[zone])
			var/datum/body_marking/marking = GLOB.body_markings[marking_name]
			UNTYPED_LIST_ADD(data_for_this_zone, marking.constant_ui_data())
		.[zone] = data_for_this_zone

/datum/asset/json/preferences/proc/get_patrons()
	. = list()
	for(var/type in GLOB.preference_patrons)
		var/datum/patron/patron = GLOB.preference_patrons[type]
		if(patron.name)
			.[type] = patron.constant_ui_data()

/datum/asset/json/preferences/proc/get_preview_bgs()
	. = list()
	// icon_states return always gets json_encode'd as assoc despite not being assoc :D
	for(var/state in GLOB.char_preview_bgs)
		. += state

/datum/asset/json/preferences/proc/get_species()
	. = list()

	for(var/species_name in get_selectable_species())
		var/datum/species/species = GLOB.species_list[species_name]
		// fix this one day...
		species = new species()
		UNTYPED_LIST_ADD(., species.constant_ui_data())
		qdel(species)

/datum/asset/json/preferences/proc/get_sprite_accessories()
	. = list()
	for(var/type in GLOB.sprite_accessories)
		var/datum/sprite_accessory/sa = GLOB.sprite_accessories[type]
		.[type] = sa.constant_ui_data()

/datum/asset/json/preferences/proc/get_statpacks()
	. = list()
	for(var/type in GLOB.statpacks)
		var/datum/statpack/statpack = GLOB.statpacks[type]
		if(!statpack.name)
			continue
		.[type] = statpack.constant_ui_data()

/datum/asset/json/preferences/proc/get_taur_types()
	. = list()
	for(var/obj/item/bodypart/taur/tt as anything in GLOB.taur_types)
		.[tt] = list(
			"name" = tt::name,
			"icon" = REF(tt::icon),
			"taur_icon_state" = tt::taur_icon_state,
			"offset_x" = tt::offset_x,
		)

/datum/asset/json/preferences/proc/get_virtues()
	. = list()
	for(var/virtue_path as anything in GLOB.virtues)
		var/datum/virtue/V = GLOB.virtues[virtue_path]
		.["[virtue_path]"] = V.constant_ui_data()

/datum/asset/json/preferences/proc/get_voicepacks()
	. = list()
	for(var/voicepack_name in GLOB.voice_packs_list)
		. += voicepack_name
