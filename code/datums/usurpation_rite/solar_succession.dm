/**
# Rite of Solar Succession

The "legitimate" path to the throne — a noble council of peers under Astrata's authority.

Design intent: Enables insider threats within the ducal family or close advisors. The Prince
Heartfelt, Consort, Hand, Steward and Councillors can all invoke this rite's easier version. Steward have an 
overlap with Golden Accord but this is fine as they dip both end. I want to increase the threat
posed by the Steward, Hand and Councillor (Which is an off role for these two roles), especially
because of the prevalence of the greedy Steward / Hand character archetype. This should
encourage more plotting and backstabbing RP within the court.

Insideres can stage a palace coup with just 3 noble voices — e.g. convincing
3 of the 4 knights or hand or prince etc. is enough. Outsiders (any other noble) need a larger quorum of 5,
making it a harder but still viable path.

Non-resident nobles (foreign envoys, Heartfelt) count as half a vote each.
This serves as a backup mechanism if hyperwar thin the local nobility —
non-resident nobles can be brought in to fill the gap, but at reduced weight.

Outlaws and undead are shunned by Astrata outside of her order. They may not invoke or assent to this rite.
*/
/datum/usurpation_rite/solar_succession
	name = "Rite of Solar Succession"
	desc = "When the throne falters, it is the right, no, the duty of the noble to step in and restore order."
	explanation = {"<p>A noble may claim the throne through the assent of their peers. An ancient tradition upheld by the order ordained by Astrata.</p>\
<p><b>Who may invoke:</b> Any noble.</p>\
<p><b>How it works:</b> Nobles of the realm must then gather near the throne and speak the words 'I assent' to support your claim.</p>\
<p><b>Completion condition:</b> Members of the ducal family (Consort, Prince), Insiders (Hand, Steward, Councillor) and those with Heartfelt ties need only <b>3</b> noble voices — a palace coup. All other nobles require a quorum of <b>5</b> voices. Resident nobles of Azure Peak count as a full voice; foreign (wanderer) nobles count as only half. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Outlaws and those touched by the stench of undead may not invoke or assent.</p>\
<p><b>Realm type if successful:</b> Grand Duchy, ruled by a Grand Duke / Grand Duchess.</p>"}

/datum/usurpation_rite/solar_succession/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_NOBLE))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return FALSE
	return TRUE

/datum/usurpation_rite/solar_succession/on_gathering_started()
	var/required = get_required_assents()
	to_chat(invoker, span_notice("The rite has begun. The nobles of the realm must now speak 'I assent' near the throne. You require [required] voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Foreign nobles count as half a voice. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/solar_succession/on_assent_accepted(mob/living/carbon/human/noble)
	var/weight = get_vote_weight(noble)
	var/voice_desc = weight >= SOLAR_VOTE_RESIDENT ? "a full voice" : "half a voice"
	noble.visible_message( \
		span_notice("[noble.real_name] speaks their assent to the Rite of Solar Succession."), \
		span_notice("You speak your assent. Astrata acknowledges your voice."))
	to_chat(invoker, span_notice("[noble.real_name] has assented as [voice_desc]. ([get_assent_total()]/[get_required_assents()])"))

/datum/usurpation_rite/solar_succession/check_assent_threshold()
	if(get_assent_total() >= get_required_assents())
		start_contesting()

/datum/usurpation_rite/solar_succession/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Solar Succession!\n\n" + \
		"In the name of Astrata, Goddess of Order, a claim is made upon the throne of [SSticker.realm_name].\n\n" + \
		"A Council of Lords has affirmed this claim.\n\n" + \
		"The Sun's judgement shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.\n\n", \
		"Rite of Solar Succession", \
		sound_contesting)
	to_chat(invoker, span_notice("The council has spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/solar_succession/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	priority_announce( \
		"The sun must set so that dawn may come again.\n\n" + \
		"The Council of Lords, under Astrata's watchful gaze, " + \
		"declares [invoker.real_name] the rightful [SSticker.rulertype] of [SSticker.realm_name], in an ORDERLY transfer of power.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has surely lost the favor of the Sun Goddess, " + \
		"and their divine right to rulership!\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The warmth of Astrata's gaze settles upon you. The throne is yours."))

/datum/usurpation_rite/solar_succession/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Rite of Solar Succession has failed. [reason] The sun sets on this claim.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Rite of Solar Succession has failed. [reason]"))


/datum/usurpation_rite/solar_succession/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by Astrata's light. Nobles, speak your assent -- or stop them. ([get_assent_total()]/[get_required_assents()] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The Council of Lords has spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null

/datum/usurpation_rite/solar_succession/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The Rite of Solar Succession is underway. [get_assent_total()]/[get_required_assents()] voices have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The Council of Lords has affirmed [invoker?.real_name]'s claim. The Sun's judgment approaches."
	return null

/// Returns the number of assent voices required based on the invoker's position.
/// Insiders need fewer (insider / diplomatic coup).
/datum/usurpation_rite/solar_succession/proc/get_required_assents()
	if(invoker.job == "Consort" || invoker.job == "Prince" || invoker.job == "Hand" || \
	invoker.job == "Steward" || invoker.job == "Councillor" || HAS_TRAIT(invoker, TRAIT_HEARTFELT))
		return SOLAR_REQUIRED_ASSENTS_INSIDER
	return SOLAR_REQUIRED_ASSENTS_OUTSIDER

/// Returns the vote weight for a noble: resident nobles count full, foreign nobles count half.
/datum/usurpation_rite/solar_succession/proc/get_vote_weight(mob/living/carbon/human/noble)
	if((noble.job in GLOB.foreign_positions) || HAS_TRAIT(noble, TRAIT_HEARTFELT))
		return SOLAR_VOTE_FOREIGNER
	return SOLAR_VOTE_RESIDENT

/// Returns the total assent vote weight accumulated so far.
/datum/usurpation_rite/solar_succession/proc/get_assent_total()
	var/total = 0
	for(var/mob/living/carbon/human/noble in assenters)
		total += get_vote_weight(noble)
	return total
