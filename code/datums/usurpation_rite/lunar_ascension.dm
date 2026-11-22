/**
 * Rite of Lunar Ascension
 *
 * Noc-themed usurpation rite.
 *
 * Design intent: Makes the university a threat and give mage a unique path to usurp the throne without nobility. It requires six mages total (The invoker + 5 more to assent). So technically a full house university plus one can initiate a coup but good luck holding it. Its	existence and implicit threat may lend some weight to displeasing the university, and perhaps encourage in town conflict over magical law as couping to declare a magocracy is now a theoretical possibility in response to excessive restrictions on magic - especially with outsider / adventurer mage help.
 *
 * Accessible to outlaws and undead, technically.
 */
/datum/usurpation_rite/lunar_ascension
	name = "Rite of Lunar Ascension"
	desc = "The rule of the ignorant must end! Only those who are truly enlightened in the way of the arcyne arts shall rule!"
	explanation = {"<p>A mage of sufficient power may claim the throne through appeal to arcane powers, overthrowing the old ways of divine kingship.</p>\
<p><b>Who may invoke:</b> Any mage with Apprentice-level Arcyne Training (The trait) or higher.</p>\
<p><b>How it works:</b> Mages trained in the Arcyne arts must gather near the throne and speak the words 'I assent' to support your claim. Any level of Arcyne Training is sufficient to assent.</p>\
<p><b>Completion condition:</b> <b>5</b> mages must speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Realm type if successful:</b> Magocracy, ruled by an Archmagos.</p>"}
	new_ruler_title = "Archmagos"
	new_ruler_title_f = "Archmagos"
	new_realm_type = "Magocracy"
	new_realm_type_short = "Magocracy"
	roundend_epilogue = "For the first time in centuries, " + \
		"an Archmagos rules openly without the assent of Astrata or the pretensions of wealth. " + \
		"They say their rule is enlightened, but foreign rulers only see the vestige of the Celestial Empire. " + \
		"Hubris, heresy. " + \
		"Will the rule of mages bring about a new golden age, " + \
		"or will it be a brief, shining moment before the realm burns in arcane fire?"
	required_assents = LUNAR_REQUIRED_MAGES
	assenter_group = "mages"
	council_name = "the Council of Magos"
	claim_basis = "by Noc's wisdom"

/// Any mage with arcyne training can invoke — no noble blood required.
/datum/usurpation_rite/lunar_ascension/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_ARCYNE))
		return FALSE
	return TRUE

/datum/usurpation_rite/lunar_ascension/can_assent(mob/living/carbon/human/mage)
	if(!HAS_TRAIT(mage, TRAIT_ARCYNE))
		to_chat(mage, span_warning("Only those trained in the Arcyne arts may speak assent to this rite."))
		return FALSE
	return ..()

/datum/usurpation_rite/lunar_ascension/get_contest_announcement()
	return "In the name of Noc, God of Magic, a claim is made upon the throne of [SSticker.realm_name], to bring enlightened rule to the realm.\n\n" + \
		"A Council of Magos has affirmed this claim.\n\n" + \
		"The Moon's judgment shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is extinguished."

/datum/usurpation_rite/lunar_ascension/get_victory_announcement(old_ruler_name)
	return "Noc granted us the arcyne arts so humen may seize their own destiny.\n\n" + \
		"A Council of Magos, under Noc's watchful gaze, declares [invoker.get_unmasked_name()] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a rule of true enlightenment.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found wanting in wisdom, " + \
		"and their claim to rulership fades like starlight at dawn.\n\n" + \
		"Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name]!"
