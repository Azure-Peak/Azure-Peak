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
		antag.finalize_default_clan_selection(vampdude)
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
		"downside" = "have no ancient house to shelter your name",
		"bloodPreference" = "your hunger is your own",
		"tagline" = "Forge your own cursed bloodline",
		"icon" = null,
		"isCustom" = TRUE,
		"covens" = list()
	))

	data["clans"] = clans
	data["selectedClanId"] = selected_is_custom ? "custom" : "[selected_clan_type]"
	data["pendingCustomName"] = pending_custom_name
	data["defaultClanName"] = "Nosferatu"
	data["warning"] = "If no clan is chosen, Nosferatu will be assigned by default."
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
		"isCustom" = FALSE
	)

/datum/vampire_clan_selection_menu/proc/coven_to_ui(coven_type)
	var/datum/coven/C = new coven_type
	var/list/powers = list()

	if(ispath(C.power_type))
		var/datum/coven_power/proto = new C.power_type
		for(var/power_path in proto.grouped_powers)
			powers += list(power_to_ui(power_path))
		qdel(proto)

	var/list/result = list(
		"name" = C.name,
		"desc" = C.desc,
		"icon" = C.icon_state,
		"powers" = powers
	)
	qdel(C)
	return result

/datum/vampire_clan_selection_menu/proc/power_to_ui(power_type)
	var/datum/coven_power/P = new power_type
	var/list/result = list(
		"name" = P.name,
		"level" = P.level,
		"desc" = P.desc
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
