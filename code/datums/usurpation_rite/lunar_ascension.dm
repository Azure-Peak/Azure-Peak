/**
 # Rite of Lunar Ascension

 Noc-themed usurpation rite. 

 Design intent: Makes the university a threat and give mage a unique path to usurp the throne without nobility. It requires six mages total (The invoker + 5 more to assent). So technically a full house university plus one can initiate a coup but good luck holding it. Its  existence and implicit threat may lend some weight to displeasing the university, and perhaps encourage in town conflict over magical law as couping to declare a magocracy is now a theoretical possibility in response to excessive restrictions on magic - especially with outsider / adventurer mage help.

 Accessible to outlaws and undead, technically.
 
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

/// Any mage with T2+ arcyne training can invoke — no noble blood required.
/datum/usurpation_rite/lunar_ascension/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(get_user_spell_tier(user) < 2)
		return FALSE
	return TRUE

/datum/usurpation_rite/lunar_ascension/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. Those trained in the arcyne arts must now speak 'I assent' near the throne. You require [LUNAR_REQUIRED_MAGES] mage voice(s) within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/lunar_ascension/on_gathering_timeout()
	fail("The mages of the realm did not grant sufficient assent.")

/// Override: mages assent, not nobles. Check arcyne training instead of TRAIT_NOBLE.
/datum/usurpation_rite/lunar_ascension/try_assent(mob/living/carbon/human/mage)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(mage))
		return FALSE
	if(mage.stat != CONSCIOUS)
		return FALSE
	if(mage == invoker)
		to_chat(mage, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(get_user_spell_tier(mage) < 1)
		to_chat(mage, span_warning("Only those trained in the Arcyne arts may speak assent to this rite."))
		return FALSE
	if(assenters[mage])
		to_chat(mage, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(mage, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[mage] = TRUE
	on_assent_accepted(mage)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/lunar_ascension/on_assent_accepted(mob/living/carbon/human/mage)
	mage.visible_message( \
		span_notice("[mage.real_name] speaks their assent to the Rite of Lunar Ascension."), \
		span_notice("You speak your assent. Noc acknowledges your voice."))
	to_chat(invoker, span_notice("[mage.real_name] has assented. ([length(assenters)]/[LUNAR_REQUIRED_MAGES])"))

/datum/usurpation_rite/lunar_ascension/check_assent_threshold()
	if(length(assenters) >= LUNAR_REQUIRED_MAGES)
		start_contesting()

/datum/usurpation_rite/lunar_ascension/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Lunar Ascension!\n\n" + \
		"In the name of Noc, God of Magic, a claim is made upon the throne of [SSticker.realm_name], to bring enlightened rule to the realm.\n\n" + \
		"A Council of Magos has affirmed this claim.\n\n" + \
		"The Moon's judgment shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is extinguished.",
		"Rite of Lunar Ascension", \
		sound_contesting)
	to_chat(invoker, span_notice("The mages have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/lunar_ascension/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	priority_announce( \
		"Noc granted us the arcyne arts so humen may seize their own destiny.\n\n" + \
		"A Council of Magos, under Noc's watchful gaze, declares [invoker.real_name] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a rule of true enlightenment.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found wanting in wisdom, " + \
		"and their claim to rulership fades like starlight at dawn.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The pale light of Noc settles upon you. The throne is yours."))

/datum/usurpation_rite/lunar_ascension/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Rite of Lunar Ascension has failed. [reason] The moon turns its gaze away.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Rite of Lunar Ascension has failed. [reason]"))


/datum/usurpation_rite/lunar_ascension/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The Rite of Lunar Ascension is underway. [length(assenters)]/[LUNAR_REQUIRED_MAGES] mages have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The Council of Magos has affirmed [invoker?.real_name]'s claim. The moon's judgment approaches."
	return null

/datum/usurpation_rite/lunar_ascension/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by Noc's wisdom. Mages, speak your assent -- or stop them. ([length(assenters)]/[LUNAR_REQUIRED_MAGES] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The Council of Magos has spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null
