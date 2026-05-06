/datum/vampire_clan_i18n
	var/language_code
	var/list/strings = list()

GLOBAL_LIST_INIT(vampire_clan_selection_i18n, build_vampire_clan_selection_i18n())

/proc/build_vampire_clan_selection_i18n()
	. = list()
	for(var/path in subtypesof(/datum/vampire_clan_i18n))
		var/datum/vampire_clan_i18n/inst = new path
		if(inst.language_code && length(inst.strings))
			.[inst.language_code] = inst.strings.Copy()
		qdel(inst)

/datum/vampire_clan_selection_menu
	var/datum/antagonist/vampire/antag
	var/mob/living/carbon/human/vampdude
	var/selected_clan_type
	var/selected_is_custom = FALSE
	var/pending_custom_name = ""

/datum/vampire_clan_selection_menu/New(datum/antagonist/vampire/source_antag, mob/living/carbon/human/source_user)
	. = ..()
	antag = source_antag
	vampdude = source_user
	selected_clan_type = /datum/clan/nosferatu

/datum/vampire_clan_selection_menu/Destroy()
	antag = null
	vampdude = null
	return ..()

/datum/vampire_clan_selection_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/vampire_clan_selection_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VampireClanSelection")
		ui.open()

/datum/vampire_clan_selection_menu/ui_close(mob/user)
	if(antag && !antag.clan_selected)
		INVOKE_ASYNC(antag, TYPE_PROC_REF(/datum/antagonist/vampire, finalize_default_clan_selection), vampdude)
	qdel(src)

/datum/vampire_clan_selection_menu/ui_data(mob/user)
	var/list/data = list()
	var/list/clans = list()

	for(var/clan_type in subtypesof(/datum/clan))
		var/datum/clan/C = new clan_type
		if(C.selectable_by_vampires)
			clans += list(clan_to_ui(clan_type, C))
		qdel(C)

	clans += list(list(
		"id" = "custom",
		"name" = "Customised Caitiff Clan",
		"desc" = "Forge your own cursed bloodline outside the ancient houses. The elders will not claim you, but neither will their chains bind you.",
		"curse" = "Unstable legacy.",
		"downside" = "Have no ancient house to shelter your name.",
		"bloodPreference" = "Your hunger is your own.",
		"tagline" = "Forge your own cursed bloodline",
		"icon" = null,
		"isCustom" = TRUE,
		"covens" = list(),
		"lordTitle" = "Caitiff Lord",
		"lordForm" = null,
		"lordTraits" = list(),
		"clanTraits" = list(),
		"vitaeBonus" = 0
	))

	var/lang = user?.client?.preferred_ui_language || DEFAULT_PREFERRED_UI_LANGUAGE
	data["clans"] = clans
	data["selectedClanId"] = selected_is_custom ? "custom" : "[selected_clan_type]"
	data["pendingCustomName"] = pending_custom_name
	data["defaultClanName"] = "Nosferatu"
	data["language"] = lang
	data["i18nOverrides"] = GLOB.vampire_clan_selection_i18n[lang]
	return data

/datum/vampire_clan_selection_menu/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!antag || !vampdude)
		return

	switch(action)
		if("select_clan")
			var/clan_id = params["clan_id"]
			if(clan_id == "custom")
				selected_is_custom = TRUE
				selected_clan_type = null
				return TRUE

			var/clan_type = text2path(clan_id)
			if(!is_valid_selectable_clan(clan_type))
				return TRUE

			selected_is_custom = FALSE
			selected_clan_type = clan_type
			return TRUE

		if("set_custom_name")
			var/raw_name = params["name"]
			if(!istext(raw_name))
				raw_name = ""
			pending_custom_name = copytext(raw_name, 1, MAX_NAME_LEN + 1)
			return TRUE

		if("accept_clan")
			if(selected_is_custom)
				var/final_name = trim(pending_custom_name)
				antag.create_custom_clan(vampdude, length(final_name) ? final_name : null)
			else
				var/clan_type = selected_clan_type
				if(!is_valid_selectable_clan(clan_type))
					clan_type = /datum/clan/nosferatu
				antag.finalize_clan_selection(vampdude, clan_type)

			SStgui.close_uis(src)
			qdel(src)
			return TRUE

		if("close")
			antag.finalize_default_clan_selection(vampdude)
			SStgui.close_uis(src)
			qdel(src)
			return TRUE

/datum/vampire_clan_selection_menu/proc/is_valid_selectable_clan(clan_type)
	if(!ispath(clan_type, /datum/clan))
		return FALSE
	var/datum/clan/C = new clan_type
	var/valid = C.selectable_by_vampires
	qdel(C)
	return valid

/datum/vampire_clan_selection_menu/proc/clan_to_ui(clan_type, datum/clan/C)
	var/list/covens = list()
	for(var/coven_type in C.clane_covens)
		covens += list(coven_to_ui(coven_type))

	var/lord_preview_type = lord_preview_type_for(C)
	var/datum/clan_leader/L = lord_preview_type ? new lord_preview_type : null

	var/list/lord_form = L ? lord_form_for(L) : null
	var/list/lord_traits = L ? get_unique_lord_traits(L) : list()
	var/list/clan_traits = get_unique_clan_traits(C)
	var/lord_title = (L && L.lord_title) ? L.lord_title : "Lord"
	var/vitae_bonus = L ? L.vitae_bonus : 0

	if(L)
		qdel(L)

	return list(
		"id" = "[clan_type]",
		"name" = C.name,
		"desc" = C.desc,
		"curse" = C.curse,
		"downside" = C.get_downside_string(),
		"bloodPreference" = C.get_blood_preference_string(),
		"covens" = covens,
		"icon" = C.clanicon,
		"tagline" = get_clan_tagline(C),
		"isCustom" = FALSE,
		"lordTitle" = lord_title,
		"lordForm" = lord_form,
		"lordTraits" = lord_traits,
		"clanTraits" = clan_traits,
		"vitaeBonus" = vitae_bonus
	)

/datum/vampire_clan_selection_menu/proc/coven_to_ui(coven_type)
	var/datum/coven/C = new coven_type
	var/list/powers = list()

	if(ispath(C.power_type))
		var/datum/coven_power/proto = new C.power_type(C)
		for(var/power_path in proto.grouped_powers)
			powers += list(power_to_ui(power_path, C))
		qdel(proto)

	var/list/result = list(
		"name" = C.name,
		"desc" = C.desc,
		"icon" = C.icon_state,
		"powers" = powers
	)
	qdel(C)
	return result

/datum/vampire_clan_selection_menu/proc/power_to_ui(power_type, datum/coven/discipline)
	var/datum/coven_power/P = new power_type(discipline)
	var/list/result = list(
		"name" = P.name,
		"level" = P.level,
		"desc" = initial(P.desc)
	)
	qdel(P)
	return result

/datum/vampire_clan_selection_menu/proc/get_clan_tagline(datum/clan/C)
	switch(C.name)
		if("Nosferatu")
			return "Sewer spies and broken masks"
		if("Vitabella Family")
			return "Beauty, obsession, and adoration"
		if("House Thronleer")
			return "Knowledge, dread, and bad omens"
		if("Children of the Abyss")
			return "Demonic piety and holy weakness"
		if("Crimson Fang")
			return "Assassins, warriors, and diablerists"
	return "An ancient curse carried through blood"

/datum/vampire_clan_selection_menu/proc/lord_preview_type_for(datum/clan/C)
	switch(C.name)
		if("Nosferatu")
			return /datum/clan_leader/nosferatu
		if("House Thronleer")
			return /datum/clan_leader/thronleer
		if("Children of the Abyss")
			return /datum/clan_leader/abyss
		if("Crimson Fang")
			return /datum/clan_leader/crimson_fang
		if("Vitabella Family")
			return /datum/clan_leader/eoran
	return C.leader

/datum/vampire_clan_selection_menu/proc/lord_form_for(datum/clan_leader/L)
	if(!L || !length(L.lord_spells))
		return null
	for(var/spell_type in L.lord_spells)
		var/list/form = lord_form_label(spell_type)
		if(form)
			return form
	return null

/datum/vampire_clan_selection_menu/proc/lord_form_label(spell_type)
	switch(spell_type)
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/rat)
			return list(
				"name" = "Sewer Rat Form",
				"desc" = "Shed your kindred shape for that of a sewer rat — slip through cracks no man could pass."
			)
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat)
			return list(
				"name" = "Bat Form",
				"desc" = "Take wing as a winged shadow — quick, elusive, hard to strike."
			)
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform)
			return list(
				"name" = "Gaseous Form",
				"desc" = "Dissolve into mist — untouchable, but thinly bound to this world."
			)
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit)
			return list(
				"name" = "Cabbit Form",
				"desc" = "A graceful, deceptively meek shape — beauty as camouflage, fang behind a smile."
			)
	return null

/datum/vampire_clan_selection_menu/proc/get_unique_clan_traits(datum/clan/C)
	var/list/base = base_member_traits()
	return diff_traits_to_ui(C.clane_traits, base)

/datum/vampire_clan_selection_menu/proc/get_unique_lord_traits(datum/clan_leader/L)
	var/list/base = base_lord_traits()
	return diff_traits_to_ui(L.lord_traits, base)

/datum/vampire_clan_selection_menu/proc/diff_traits_to_ui(list/source, list/base)
	var/list/seen = list()
	var/list/result = list()
	for(var/trait in source)
		if(trait in base)
			continue
		if(trait in seen)
			continue
		seen += trait
		var/list/label = trait_label(trait)
		if(label)
			result += list(label)
	return result

/datum/vampire_clan_selection_menu/proc/base_member_traits()
	return list(
		TRAIT_STRONGBITE,
		TRAIT_VAMPBITE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SILVER_WEAK,
		TRAIT_VAMPMANSION
	)

/datum/vampire_clan_selection_menu/proc/base_lord_traits()
	return list(
		TRAIT_HEAVYARMOR,
		TRAIT_INFINITE_ENERGY,
		TRAIT_STRENGTH_UNCAPPED
	)

/datum/vampire_clan_selection_menu/proc/trait_label(trait)
	switch(trait)
		if(TRAIT_NASTY_EATER)
			return list("name" = "Nasty Eater", "desc" = "Stomach grim meals without complaint.")
		if(TRAIT_ANTISCRYING)
			return list("name" = "Hidden from Sight", "desc" = "Scrying magics slide off your name.")
		if(TRAIT_UNSEEMLY)
			return list("name" = "Unseemly", "desc" = "Twisted features unsettle anyone who sees them.")
		if(TRAIT_KEENEARS)
			return list("name" = "Keen Ears", "desc" = "Sounds others miss reach you clearly.")
		if(TRAIT_JESTERPHOBIA)
			return list("name" = "Jesterphobia", "desc" = "Mummers, jesters and fools rattle your nerves.")
		if(TRAIT_BAD_MOOD)
			return list("name" = "Brooding Soul", "desc" = "Mood debuffs cut deeper than for others.")
		if(TRAIT_SELF_SUSTENANCE)
			return list("name" = "Self-Sustenance", "desc" = "Long study has taught you to endure on little.")
		if(TRAIT_GOODWRITER)
			return list("name" = "Skilled Hand", "desc" = "Your script is elegant and unforgeable.")
		if(TRAIT_JACKOFALLTRADES)
			return list("name" = "Jack of All Trades", "desc" = "Broad aptitude across many crafts.")
		if(TRAIT_INTELLECTUAL)
			return list("name" = "Intellectual", "desc" = "Sharper mind for arcane and worldly study.")
		if(TRAIT_LIGHT_STEP)
			return list("name" = "Light Step", "desc" = "You move without alerting prey or guards.")
		if(TRAIT_CICERONE)
			return list("name" = "Silver Tongue", "desc" = "Speech sways minds others could not move.")
		if(TRAIT_DEATHSIGHT)
			return list("name" = "Deathsight", "desc" = "You feel the dying — when and where they fall.")
		if(TRAIT_BEAUTIFUL)
			return list("name" = "Beautiful", "desc" = "Inhumanly comely, eyes follow you in any room.")
		if(TRAIT_EMPATH)
			return list("name" = "Empath", "desc" = "Read the moods and small lies of others.")
		if(TRAIT_EXTEROCEPTION)
			return list("name" = "Exteroception", "desc" = "Heightened sense of bodies and surroundings.")
		if(TRAIT_HEAVYARMOR)
			return list("name" = "Heavy Armor Mastery", "desc" = "Plate and chain weigh on you no more.")
		if(TRAIT_INFINITE_ENERGY)
			return list("name" = "Infinite Stamina", "desc" = "Toil and battle do not exhaust you.")
		if(TRAIT_STRENGTH_UNCAPPED)
			return list("name" = "Uncapped Strength", "desc" = "Your raw might has no mortal ceiling.")
		if(TRAIT_SEEPRICES)
			return list("name" = "Appraiser's Eye", "desc" = "You read the worth of any wares at a glance.")
		if(TRAIT_DECEIVING_MEEKNESS)
			return list("name" = "Deceiving Meekness", "desc" = "Foes underestimate you until it is too late.")
	return null
