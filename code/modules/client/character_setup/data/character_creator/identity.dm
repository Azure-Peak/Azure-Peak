/datum/preferences/proc/ui_data_character_creator_identity(mob/user)
	var/list/data = list(
		"species_base_name" = pref_species.base_name,
		"species_sub_name" = pref_species.sub_name,
		"species_check" = spec_check(user),
		"race_bonus" = null,

		"nickname" = nickname,
		"highlight_color" = highlight_color,
		"age" = age,

		"pronouns" = pronouns,
		"titles_pref" = titles_pref,
		"clothes_pref" = clothes_pref,

		"statpack_name" = statpack.name,
		"domhand" = domhand,
		"combat_music" = (combat_music.shortname ? combat_music.shortname : combat_music.name),
		"dnr_pref" = dnr_pref,

		"favorite_cuisine" = favorite_cuisine,
		"favorite_dish" = favorite_dish,
		"favorite_drink" = favorite_drink,

		"loadout_cost" = 0,
		"loadout_tri_cost" = 0,

		"selected_faith" = null,
		"selected_patron" = null,

		"virtue_origin" = "[virtue_origin]",
		"free_language" = "None",

		"voice_type" = voice_type,
		"voice_color" = voice_color,
		"voice_pack" = voice_pack,
		"voice_pitch" = voice_pitch,

		"bark_id" = bark_id,
		"bark_name" = null,
		"bark_speed" = bark_speed,
		"min_bark_speed" = null,
		"max_bark_speed" = null,
		"bark_pitch" = bark_pitch,
		"min_bark_pitch" = null,
		"max_bark_pitch" = null,
		"bark_variance" = bark_variance,
		"min_bark_variance" = null,
		"max_bark_variance" = null,

		"virtues" = ui_data_character_creator_identity_virtues(user),
	)

	// Subprocs
	data += ui_data_character_creator_identity_charflaws(user)

	// Inline data
	if(LAZYLEN(pref_species.custom_selection))
		var/race_bonus_display
		if(race_bonus)
			for(var/bonus in pref_species.custom_selection)
				if(bonus == race_bonus)
					race_bonus_display = bonus
					break
		data["race_bonus"] = "[race_bonus_display]"

	if(ispath(extra_language, /datum/language))
		var/datum/language/selected_lang = extra_language
		data["free_language"] = selected_lang::name

	var/loadout_cost = 0
	var/loadout_tri_cost = 0
	for(var/item_name in gear_list)
		var/datum/loadout_item/LI = GLOB.loadout_items_by_name[item_name]
		if(!LI)
			continue
		loadout_cost += LI.cost
		if(LI.triumph_cost)
			loadout_tri_cost += LI.triumph_cost

	data["loadout_cost"] = loadout_cost
	data["loadout_tri_cost"] = loadout_tri_cost

	var/datum/faith/selected_faith = GLOB.faithlist[selected_patron.associated_faith]
	data["selected_faith"] = selected_faith.name
	data["selected_patron"] = selected_patron.name

	var/datum/bark/B = GLOB.bark_list[bark_id]
	data["bark_name"] = B::name

	data["min_bark_speed"] = B::minspeed
	data["max_bark_speed"] = B::maxspeed
	data["min_bark_pitch"] = B::minpitch
	data["max_bark_pitch"] = B::maxpitch
	data["min_bark_variance"] = B::minvariance
	data["max_bark_variance"] = B::maxvariance

	return data

/datum/preferences/proc/ui_data_character_creator_identity_charflaws(mob/user)
	var/list/data = list(
		"charflaws" = list(),
		"has_averse" = FALSE,
		"averse_chosen_faction" = averse_chosen_faction,
	)

	var/has_extra_vice = FALSE
	for(var/cf_type in charflaws)
		var/datum/charflaw/cf = GLOB.character_flaws_singletons[cf_type]
		if(!cf)
			continue
		if(!cf.needs_extra_vice)
			has_extra_vice = TRUE

	var/has_averse = FALSE
	var/list/charflaws_data = list()
	for(var/cf_type in charflaws)
		var/datum/charflaw/cf = GLOB.character_flaws_singletons[cf_type]
		if(!cf)
			continue
		if(ispath(cf_type, /datum/charflaw/averse))
			has_averse = TRUE
		UNTYPED_LIST_ADD(charflaws_data, list(
			"name" = "[cf]",
			"type" = "[cf.type]",
			"warning" = cf.needs_extra_vice && !has_extra_vice,
		))

	data["charflaws"] = charflaws_data
	data["has_averse"] = has_averse

	return data

// No downstream override necessary, see data/popup/virtue.dm
/datum/preferences/proc/ui_data_character_creator_identity_virtues(mob/user)
	var/list/data = list()

	var/list/slot_names = get_virtue_slot_names()

	var/index = 1
	for(var/datum/virtue/V as anything in get_all_virtues())
		UNTYPED_LIST_ADD(data, list(
			"id" = index,
			"slot_name" = slot_names[index],
			"virtue" = V.ui_data(user),
			"spawn_error" = virtue_spawn_error(index, V)
		))
		index += 1

	return data

/datum/preferences/proc/virtue_spawn_error(index, datum/virtue/V)
	if(index == 2)
		if(!statpack.virtuous)
			return "This virtue slot will only be used with virtuous stat packs."

	var/heretic = FALSE
	if(istype(selected_patron, /datum/patron/inhumen))
		heretic = TRUE
	if(!virtue_check(V, heretic, pref_species))
		return "Incorrect virtue parameters."

	return null
