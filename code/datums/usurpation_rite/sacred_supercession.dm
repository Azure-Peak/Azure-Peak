/**
 # Rite of Sacred Supercession.

 Church / Astrata themed usurpation rite. 

 Design intent: This is meant to give the Church an internal path to taking over power - and is only accessible to them as a result. It requires membership of in the town Church faction to invoke. Anyone who is a clergy (I.e. miracles access) can assent - and like the noble counterpart, wanderers / adventurers can also serve as a backup (In fact, given Church's lack of number you probably want adventurers on your side not just to reach the assent threshold but to fight the retinue if needed). Bishop - Duke conflict is probably the most common internal conflict (alongside Inquisition and Everyone) especially when the Grand Duke runs a gimmick or tyrannical law. This should encourage some follow through on conflicts and start shifting AP players mindset to "Can I coup?"

 The epilogue implies an impending war with Otava - for breaking the status quo and the balance of power. But we don't want admins or events to actually diminish the impact within the round, so it is implied to be a threat from the outside after the week is over (and the round reset).

 Not accessible to outlaws and undead, of course.
 */
/datum/usurpation_rite/sacred_supercession
	name = "Rite of Sacred Supercession"
	desc = "When a king fails to uphold the divine order, the faithful must act. Reluctantly, the church must claim temporal power, to shepherd the faithful back on an orderly path."
	explanation = {"<p>A member of the Church of the Ten may claim the throne through divine mandate.</p>\
<p><b>Who may invoke:</b> Any member of the Church of the Ten who follows one of the divine patrons.</p>\
<p><b>How it works:</b> Members of the Church of the Ten, or those who have reached the First Tier of Divine devotion, must gather near the throne and speak the words 'I assent' to support your claim. Only followers of the Ten may participate.</p>\
<p><b>Completion condition:</b> <b>5</b> weighted voices must speak their assent. Foreign or wandering clergy count as only half a voice. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Only followers of the Ten may invoke or assent. Outlaws and the undead are shunned.</p>\
<p><b>Realm type if successful:</b> Prince-Bishopric, ruled by a Prince-Bishop.</p>"}
	new_ruler_title = "Prince-Bishop"
	new_ruler_title_f = "Princess-Bishop"
	new_realm_type = "Prince-Bishopric"
	new_realm_type_short = "Prince-Bishopric"
	roundend_epilogue = "Astrata's sacred order has been restored, but with a twist. " + \
		"For as long as most faithful can remember, realms of Psydonia were ruled by the blue-blooded, " + \
		"those who derive their power from Astrata's divinity, but never wielded Her power directly. " + \
		"Now, the Church itself has taken the throne. " + \
		"Is this truly Astrata's will? To mix temporal and spiritual power in one ruler? " + \
		"The Sun Goddess is silent, or perhaps she has acquiesced to this new order." + \
		"\n\n" + \
		"To the west, the smoke of a signal fire rises. " + \
		"Through this takeover, the Church has broken the balance of power that kept the realm sovereign - " + \
		"the Tens, the faith of the majority, Psydon, the faith of a minority. " + \
		"Each tolerated the other and kept each other in check. " + \
		"The ruler may believe themselves sovereign, " + \
		"but Otava believes Grenzelhoft have won a battle, and will not let them win the war. " + \
		"War is coming."

/// Any member of the Church of the Ten with a divine patron. No outlaws or undead.
/datum/usurpation_rite/sacred_supercession/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!(user.job in GLOB.church_positions))
		return FALSE
	if(!istype(user.patron, /datum/patron/divine))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return FALSE
	return TRUE

/datum/usurpation_rite/sacred_supercession/on_gathering_started()
	var/required = BISHOPRIC_REQUIRED_ASSENTS
	to_chat(invoker, span_notice("The rite has begun. The faithful must now speak 'I assent' near the throne. You require [required] voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Foreign clergy count as half a voice. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/sacred_supercession/on_gathering_timeout()
	fail("The faithful of the realm did not grant sufficient assent.")

/// Override: church faithful assent, not nobles. Must follow a divine patron. Church position OR T1+ Divine devotion.
/datum/usurpation_rite/sacred_supercession/try_assent(mob/living/carbon/human/faithful)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(faithful))
		return FALSE
	if(faithful.stat != CONSCIOUS)
		return FALSE
	if(faithful == invoker)
		to_chat(faithful, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(!istype(faithful.patron, /datum/patron/divine))
		to_chat(faithful, span_warning("Only followers of the Ten may speak assent to this rite."))
		return FALSE
	if(!is_qualified_faithful(faithful))
		to_chat(faithful, span_warning("Only ordained members of the Church or those who have proven their devotion may speak assent."))
		return FALSE
	if(HAS_TRAIT(faithful, TRAIT_OUTLAW))
		to_chat(faithful, span_warning("Astrata shuns those who stand outside the order."))
		return FALSE
	if(HAS_TRAIT(faithful, TRAIT_ROTMAN) || (faithful.mob_biotypes & MOB_UNDEAD))
		to_chat(faithful, span_warning("The sun has no place for the living dead."))
		return FALSE
	if(assenters[faithful])
		to_chat(faithful, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(faithful, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[faithful] = TRUE
	on_assent_accepted(faithful)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/sacred_supercession/on_assent_accepted(mob/living/carbon/human/faithful)
	var/weight = get_vote_weight(faithful)
	var/voice_desc = weight >= BISHOPRIC_VOTE_RESIDENT ? "a full voice" : "half a voice"
	faithful.visible_message( \
		span_notice("[faithful.real_name] speaks their assent to the Rite of Sacred Supercession."), \
		span_notice("You speak your assent. Astrata acknowledges your devotion."))
	to_chat(invoker, span_notice("[faithful.real_name] has assented as [voice_desc]. ([get_assent_total()]/[BISHOPRIC_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/sacred_supercession/check_assent_threshold()
	if(get_assent_total() >= BISHOPRIC_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/sacred_supercession/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Sacred Supercession!\n\n" + \
		"In the name of Astrata, Goddess of Order, the Church reluctantly makes a claim upon the throne of [SSticker.realm_name], to restore order and faith!\n\n" + \
		"The faithful have affirmed this claim.\n\n" + \
		"The Sun's judgment shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.", \
		"Rite of Sacred Supercession", \
		sound_contesting)
	to_chat(invoker, span_notice("The faithful have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/sacred_supercession/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	priority_announce( \
		"The sun rises on a new order.\n\n" + \
		"The faithful of Astrata declare [invoker.real_name] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a HOLY reign.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found lacking in faith, " + \
		"and their divine mandate is hereby revoked.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The radiance of Astrata crowns you. The throne is yours."))

/datum/usurpation_rite/sacred_supercession/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Rite of Sacred Supercession has failed. [reason] The sun sets on this claim.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Rite of Sacred Supercession has failed. [reason]"))


/datum/usurpation_rite/sacred_supercession/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The Rite of Sacred Supercession is underway. [get_assent_total()]/[BISHOPRIC_REQUIRED_ASSENTS] voices have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The faithful have affirmed [invoker?.real_name]'s claim. The Sun's judgment approaches."
	return null

/datum/usurpation_rite/sacred_supercession/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by Astrata's mandate. Faithful, speak your assent -- or stop them. ([get_assent_total()]/[BISHOPRIC_REQUIRED_ASSENTS] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The faithful have spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null

/// Returns TRUE if the mob qualifies: either a church position holder, or has T1+ Divine devotion.
/datum/usurpation_rite/sacred_supercession/proc/is_qualified_faithful(mob/living/carbon/human/user)
	if(user.job in GLOB.church_positions)
		return TRUE
	if(user.devotion?.level >= CLERIC_T1)
		return TRUE
	return FALSE

/// Returns the vote weight: resident faithful count full, foreign/wanderer count half.
/datum/usurpation_rite/sacred_supercession/proc/get_vote_weight(mob/living/carbon/human/faithful)
	if(faithful.job in GLOB.foreign_positions)
		return BISHOPRIC_VOTE_FOREIGNER
	return BISHOPRIC_VOTE_RESIDENT

/// Returns the total assent vote weight accumulated so far.
/datum/usurpation_rite/sacred_supercession/proc/get_assent_total()
	var/total = 0
	for(var/mob/living/carbon/human/faithful in assenters)
		total += get_vote_weight(faithful)
	return total
