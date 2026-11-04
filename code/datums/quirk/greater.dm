/*
 * Greater quirks: small, character-flavor traits too small to be a virtue, but too impactful to be given out as easily as lesser quirks.
 * You need to give up your statpack AND take a second vice to get access so they get to be _slightly_ stronger.
*/

/datum/quirk/noble
	name = "Unlanded Noble"
	desc = "By birth or deeds, I've a high place in Astrata's order. My holdings, however, are too small or too far away to grant much benefit beyond a title."
	mechdesc = "Grants the noble trait, but no other benefits. You will also need to behave more strictly 'noble' than those in noble roles; for example, sleeping outdoors or on a poor-quality bed, using scavenged or poorly forged equipment, and similar will debuff your mood."
	added_traits = list(TRAIT_NOBLE, TRAIT_NOBLE_UNLANDED)
	greater = TRUE
	restricted_species = list(/datum/species/construct/metal, /datum/species/dullahan, /datum/species/ooze)
	ui_fa_icon = "crown"

/datum/quirk/wyldeater // not quite as good as inhumen digestion but maybe slightly less likely to get you flagged as a graggarite?
	name = "Wyld Metabolism"
	desc = "Dendor's touch lies heavier upon me than most. I can eat things most would fail to stomach."
	added_traits = list(TRAIT_WILD_EATER)
	allowed_species = list(/datum/species/anthromorph, /datum/species/anthromorphsmall, /datum/species/lupian, /datum/species/tabaxi, /datum/species/akula, /datum/species/vulpkanin)
	greater = TRUE
	ui_fa_icon = "drumstick-bite"

/datum/quirk/linguist // if this is too much, it can be changed to make it ONLY the 'patron language for clerics' thing, but... it's one extra language. we have so many unused languages
	name = "Linguist"
	desc = "I like to read more than most, and keep my horizons broad."
	mechdesc = "Grants your choice of one additional language. If you have access to miracles, your patron's language - Abyssal for Abyssor, Beastish for Dendor, and the Chant for Zizo - may be selected."
	greater = TRUE
	ui_fa_icon = "person-chalkboard"
	var/list/allowed_languages = list( // same as intellectual virtue, i.e. only commonly-available languages
		"Elvish" = /datum/language/elvish,
		"Dwarvish" = /datum/language/dwarvish,
		"Orcish" = /datum/language/orcish,
		"Infernal" = /datum/language/hellspeak,
		"Draconic" = /datum/language/draconic,
		"Celestial" = /datum/language/celestial,
		"Ranesheni" = /datum/language/raneshi,
		"Grenzelhoftian" = /datum/language/grenzelhoftian,
		"Kazengunese" = /datum/language/kazengunese,
		"Lingyuese" = /datum/language/lingyuese,
		"Undercommon" = /datum/language/undercommon,
		"Otavan" = /datum/language/otavan,
		"Etruscan" = /datum/language/etruscan,
		"Gronnic" = /datum/language/gronnic,
		"Aavnic" = /datum/language/aavnic
	)
	var/list/patron_languages = list(
		/datum/patron/divine/abyssor = /datum/language/abyssal,
		/datum/patron/divine/dendor = /datum/language/beast,
		/datum/patron/inhumen/zizo = /datum/language/undead,
	)

/datum/quirk/linguist/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/list/choices = allowed_languages.Copy()
	if(recipient.devotion && (recipient.patron.type in patron_languages))
		var/datum/language/lang = patron_languages[recipient.patron.type]
		choices[lang::name] = lang
	var/datum/language_holder/holder = recipient.get_language_holder()
	var/list/already_known = list()
	for(var/path in choices)
		if(holder.has_language(choices[path]))
			already_known[path] = choices[path]
	choices.Remove(already_known)
	var/datum/language/langpath = choices[tgui_input_list(recipient, "Which language do you study?", "LINGUISTIC BOON", choices)]
	if(langpath && ispath(langpath, /datum/language))
		holder.grant_language(langpath)
