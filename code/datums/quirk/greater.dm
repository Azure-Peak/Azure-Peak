/*
 * Greater quirks: small, character-flavor traits too small to be a virtue, but too impactful to be given out as easily as lesser quirks.
 * You need to give up your statpack AND take a second vice to get access so they get to be _slightly_ stronger.
*/

/datum/quirk/goodcrafter
	name = "Deft Hands"
	desc = "I've kept my hands busy and my mind sharp. I can craft things quicker than most."
	added_traits = list(TRAIT_GOODCRAFTER)
	greater = TRUE
	ui_fa_icon = "hammer"

/datum/quirk/noble
	name = "Unlanded Noble"
	desc = "By birth or deeds, I've a high place in Astrata's order. My holdings, however, are too small or too far away to grant much benefit beyond a title."
	mechdesc = "Grants the noble trait, but no other benefits."
	added_traits = list(TRAIT_NOBLE)
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
