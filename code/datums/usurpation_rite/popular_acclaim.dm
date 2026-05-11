/**
# Rite of Popular Acclaim

Secular populist usurpation rite.

Design Intent: Originally, I wanted a Matthios themed rite accessible to bandits, but realized that just made them even more valid in the eyes of others. And I really wanted to move away from the anachronistic marxist framing of Matthios in old roguetown lore. So instead, inspired by it, I made a purely secular rite that just so happens to be accessible to bandits. Thematically, this is about as close to the "Peasant Rebel" antagonist as I can get with this system, adjusted for AP where this antagonist class is dead and for our own environment. 

Outlaws and bandits count DOUBLE for this - for the risk they take. 

However, of all of the usurpation rites, this one takes the most voices - a total of TEN (10!!) weighted voices - but bandits and outlaws count as two voices each, so it can be achieved with just 5 actual people if they're all outlaws.

The dead has no voice in this. The world is not progressive enough for that.
*/

/datum/usurpation_rite/popular_acclaim
	name = "Rite of Popular Acclaim"
	desc = "Claim the throne through the raw will of the people. No god, no mandate — just enough voices."
	explanation = {"<p>Vox populi, vox dei. The voice of the people is the voice of the gods. When the people speak with one voice, no throne can stand against them.</p>\
<p><b>Who may invoke:</b> Bandits, outlaws (including outlawed nobles), peasants, or sidefolk.</p>\
<p><b>How it works:</b> The people of the realm must gather near the throne and speak the words 'I assent' to support your claim. Anyone may assent.</p>\
<p><b>Completion condition:</b> <b>10</b> weighted voices must speak their assent. Bandits and outlaws count as <b>two</b> voices each — they risked everything to assert their right. All others count as one. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> The undead may not invoke or assent.</p>\
<p><b>Realm type if successful:</b> Republic, ruled by a Tribune.</p>"}
	new_ruler_title = "Tribune"
	new_ruler_title_f = "Tribune"
	new_realm_type = "Republic"
	new_realm_type_short = "Republic"
	roundend_epilogue = "The people have spoken, and the old order has crumbled. " + \
		"The realm is ruled by the people, for the people! " + \
		"The voice of the people is the voice of the gods! " + \
		"Foreign rulers may claim this to be a Matthiosite plot, " + \
		"but the people know the truth -- " + \
		"that power belongs to those who have the courage to seize it, " + \
		"and the people to support it!"

/// Bandits, outlaws (including outlawed nobles), peasants, or sidefolk can invoke. No undead.
/datum/usurpation_rite/popular_acclaim/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return FALSE
	// Bandits and outlaws can invoke — including outlawed nobles
	if(user.job == "Bandit" || HAS_TRAIT(user, TRAIT_OUTLAW))
		return TRUE
	// Peasants and sidefolk can invoke
	if(user.job in GLOB.peasant_positions)
		return TRUE
	if(user.job in GLOB.sidefolk_positions)
		return TRUE
	return FALSE

/datum/usurpation_rite/popular_acclaim/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. The people must now speak 'I assent' near the throne. You require [ACCLAIM_REQUIRED_ASSENTS] weighted voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Bandits and outlaws count as two voices each. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/popular_acclaim/on_gathering_timeout()
	fail("The people of the realm did not grant sufficient assent.")

/// Override: anyone living can assent. Wide pool, weighted by outlaw status.
/datum/usurpation_rite/popular_acclaim/try_assent(mob/living/carbon/human/person)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(person))
		return FALSE
	if(person.stat != CONSCIOUS)
		return FALSE
	if(person == invoker)
		to_chat(person, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(HAS_TRAIT(person, TRAIT_ROTMAN) || (person.mob_biotypes & MOB_UNDEAD))
		to_chat(person, span_warning("The dead have no voice among the living."))
		return FALSE
	if(assenters[person])
		to_chat(person, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(person, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[person] = TRUE
	on_assent_accepted(person)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/popular_acclaim/on_assent_accepted(mob/living/carbon/human/person)
	var/weight = get_vote_weight(person)
	var/voice_desc = weight >= ACCLAIM_VOTE_OUTLAW ? "two voices" : "one voice"
	person.visible_message( \
		span_notice("[person.real_name] speaks their assent to the Rite of Popular Acclaim."), \
		span_notice("You speak your assent. Your voice is heard."))
	to_chat(invoker, span_notice("[person.real_name] has assented as [voice_desc]. ([get_assent_total()]/[ACCLAIM_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/popular_acclaim/check_assent_threshold()
	if(get_assent_total() >= ACCLAIM_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/popular_acclaim/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Popular Acclaim!\n\n" + \
		"The people of [SSticker.realm_name] have spoken — [invoker.real_name] shall step forth as the Tribune of [SSticker.realm_name]. A rule by the people, for the people!\n\n" + \
		"The will of the people shall be settled in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.\n\n", \
		"Rite of Popular Acclaim", \
		sound_contesting)
	to_chat(invoker, span_notice("The people have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/popular_acclaim/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	priority_announce( \
		"A ruler must rule for the benefits of their subjects. And no one is more fit than one elected by their subjects.\n\n" + \
		"The people of [SSticker.realm_name] declare [invoker.real_name] the rightful [SSticker.rulertype], chosen by POPULAR acclaim.\n\n" + \
		"[old_ruler_name], unable to contest this claim, has lost the confidence of the people, " + \
		"and their authority is hereby revoked.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The people stand behind you. The throne is yours."))

/datum/usurpation_rite/popular_acclaim/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Rite of Popular Acclaim has failed. [reason] The old order holds — for now.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Rite of Popular Acclaim has failed. [reason]"))


/datum/usurpation_rite/popular_acclaim/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "A Rite of Popular Acclaim is underway. [get_assent_total()]/[ACCLAIM_REQUIRED_ASSENTS] voices have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The people have affirmed [invoker?.real_name]'s claim. The will of the people approaches."
	return null

/datum/usurpation_rite/popular_acclaim/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by popular will. Speak your assent -- or stop them. ([get_assent_total()]/[ACCLAIM_REQUIRED_ASSENTS] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The people have spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null

/// Returns the vote weight: outlaws/bandits count double, everyone else single.
/datum/usurpation_rite/popular_acclaim/proc/get_vote_weight(mob/living/carbon/human/person)
	if(person.job == "Bandit" || HAS_TRAIT(person, TRAIT_OUTLAW))
		return ACCLAIM_VOTE_OUTLAW
	return ACCLAIM_VOTE_CITIZEN

/// Returns the total assent vote weight accumulated so far.
/datum/usurpation_rite/popular_acclaim/proc/get_assent_total()
	var/total = 0
	for(var/mob/living/carbon/human/person in assenters)
		total += get_vote_weight(person)
	return total
