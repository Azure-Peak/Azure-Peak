/*
 * Greater quirks: small, character-flavor traits too small to be a virtue, but too impactful to be given out as easily as lesser quirks.
 * You need to give up your statpack AND take a second vice to get access so they get to be _slightly_ stronger.
*/

/datum/quirk/goodcrafter
	name = "Deft Hands"
	desc = "I've kept my hands busy and my mind sharp. I can craft things quicker than most."
	added_traits = list(TRAIT_GOODCRAFTER)
	greater = TRUE

/datum/quirk/feytouched
	name = "Feytouched"
	desc = "While I may not be as changed as some, I'm bound by pact or nature to the hag's cause."
	mechdesc = "You and the hag will know each other automatically and can communicate. You're expected to cooperate with them."
	greater = TRUE

/datum/quirk/feytouched/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient.mind)
		return
	for(var/mob/living/hag_mob in GLOB.active_hags)
		var/datum/mind/hag_mind = hag_mob.mind
		if(!hag_mind)
			continue
		hag_mind.i_know_person(recipient)
		recipient.mind.i_know_person(hag_mind)
		if(hag_mind.current)
			to_chat(hag_mind.current, span_boldnotice("A familiar rhythm pulses in the roots... [recipient.real_name] is walking the lands this week."))
	to_chat(recipient, span_boldnotice("The Mossmother's gaze lingers upon you. You are recognized by her daughters."))

/datum/quirk/noble
	name = "Unlanded Noble"
	desc = "By birth or deeds, I've a high place in Astrata's order. My holdings, however, are too small or too far away to grant much benefit beyond a title."
	mechdesc = "Grants the noble trait, but no other benefits."
	added_traits = list(TRAIT_NOBLE)
	greater = TRUE
	restricted_species = list(/datum/species/construct, /datum/species/dullahan, /datum/species/ooze)
	restricted_traits = list(TRAIT_OUTLAW) // just like noble virtue you can't take this on wretches and thelike

/datum/quirk/wyldeater // not quite as good as inhumen digestion but maybe slightly less likely to get you flagged as a graggarite?
	name = "Wyld Metabolism"
	desc = "Dendor's touch lies heavier upon me than most. I can eat things most would fail to stomach."
	added_traits = list(TRAIT_WILD_EATER)
	allowed_species = list(/datum/species/anthromorph, /datum/species/anthromorphsmall)
	greater = TRUE
