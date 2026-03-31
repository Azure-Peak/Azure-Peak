/**
 # Rite of Progressive Dominion

 Zizo-themed usurpation rite.

 Design intent: A mirror of the Lunar Ascension. Zizo is the mistress of Progress - this also allows for those with arcyne power to vote. But Zizo, being so progressive, and also the mistress of undead and left-handed magick, will allow the undead (Who is under your sway, surely), a vote. So, with this dead voter manipulation, it is technically one of the easiest rite to get the assent for. But of course, by invoking the most heretical and hated path, you are sure to draw everyone's ires - good luck contesting the throne after that. 

 This is meant as the path for a lich - but they also have path through Lunar Ascension, and it is a thematical choice that makes it easier for them if they cannot gather 5 mages on their side, in exchange for making their claim to power much less palatable. Thematic however, and gives them a "win" condition instead of just hyperwar - now they can become the rightful Grand Duke and roleplay a world under the lich's rule.

 Accessible to outlaws and undead, technically.

 No, this is not a political dig. It just so happens that Zizo is the Goddess of Progress and also Undeath. 
 
 Zizo, Zizo, Zizo! Goddess of Progress! Goddess of Progress! Bring us lyfe from whence comes death! 
 
 Zizo, Zizo, Zizo! Grants the dead their democratic rights to vote! 
 
 Zizo, Zizo, Zizo! The future is bright under your progressive rule!
 
 */

/datum/usurpation_rite/progressive_dominion
	name = "Rite of Progressive Dominion"
	desc = "The rule of the ignorant must end! Only those who are not beholden to the past, who progress the world toward a bright future, shall rule!"
	explanation = {"<p>A mage of sufficient power, a follower of Zizo, or the undead, may claim the throne through the assent of those who embrace progress.</p>\
<p><b>Who may invoke:</b> Any mage with Apprentice-level Arcyne Training or higher, any follower of Zizo, or any undead.</p>\
<p><b>How it works:</b> Mages trained in the Arcyne arts, followers of Zizo, or those touched by undeath, must gather near the throne and speak the words 'I assent' to support your claim.</p>\
<p><b>Completion condition:</b> <b>5</b> voices must speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> None. All who seek progress are welcome — the living, the undead, the outlaw.</p>\
<p><b>Realm type if successful:</b> Dominion, ruled by an Exarch.</p>"}
	new_ruler_title = "Exarch"
	new_ruler_title_f = "Exarch"
	new_realm_type = "Dominion"
	new_realm_type_short = "Dominion"

/// Any mage with T2+ arcyne training, any Zizite follower, or any undead, can invoke.
/datum/usurpation_rite/progressive_dominion/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	// Undead can invoke without arcyne training — their existence is Zizo's will
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return TRUE
	// Zizite followers can invoke — Zizo is their goddess
	if(istype(user.patron, /datum/patron/inhumen/zizo))
		return TRUE
	// Living need T2+ arcyne training
	if(get_user_spell_tier(user) >= 2)
		return TRUE
	return FALSE

/datum/usurpation_rite/progressive_dominion/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. Mages, followers of Zizo, and the undead must now speak 'I assent' near the throne. You require [DOMINION_REQUIRED_ASSENTS] voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/progressive_dominion/on_gathering_timeout()
	fail("The voices of progress did not grant sufficient assent.")

/// Override: mages, Zizite followers, and undead assent. Any arcyne training, Zizo patron, OR undead status qualifies.
/datum/usurpation_rite/progressive_dominion/try_assent(mob/living/carbon/human/supporter)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(supporter))
		return FALSE
	if(supporter.stat != CONSCIOUS)
		return FALSE
	if(supporter == invoker)
		to_chat(supporter, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(!is_qualified_voice(supporter))
		to_chat(supporter, span_warning("Only those trained in the arcyne arts, followers of Zizo, or touched by undeath may speak assent to this rite."))
		return FALSE
	if(assenters[supporter])
		to_chat(supporter, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(supporter, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[supporter] = TRUE
	on_assent_accepted(supporter)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/progressive_dominion/on_assent_accepted(mob/living/carbon/human/supporter)
	supporter.visible_message( \
		span_notice("[supporter.real_name] speaks their assent to the Rite of Progressive Dominion."), \
		span_notice("You speak your assent. Progress demands no less."))
	to_chat(invoker, span_notice("[supporter.real_name] has assented. ([length(assenters)]/[DOMINION_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/progressive_dominion/check_assent_threshold()
	if(length(assenters) >= DOMINION_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/progressive_dominion/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Progressive Dominion!\n\n" + \
		"In the name of Zizo, Mistress of Progress, a claim is made upon the throne of [SSticker.realm_name].\n\n" + \
		"A Council of the Enlightened has affirmed this claim.\n\n" + \
		"The future shall be decided in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.\n\n", \
		"Rite of Progressive Dominion", \
		sound_contesting)
	to_chat(invoker, span_notice("The enlightened have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/progressive_dominion/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	if(HAS_TRAIT(invoker, TRAIT_ROTMAN) || (invoker.mob_biotypes & MOB_UNDEAD))
		roundend_epilogue = \
			"One can conquer a realm on a tide of bones. " + \
			"But the dead bear no children and hold no true will. " + \
			"How long will the living -- even those who follow the Mistress of Progress -- tolerate their rule?"
	else
		roundend_epilogue = \
			"And as suddenly as the Celestial Empire has fallen, " + \
			"it has seemingly returned in [SSticker.realm_name]. " + \
			"O Zizo! Dame of Progress! The future will be bright under your rule! " + \
			"Grant us armaments! Grant us power! " + \
			"Let us stand fast against the darkness of stagnation! " + \
			"Let us stand fast against the rot of the old order! " + \
			"Long live [invoker.real_name], [new_ruler_title] of [SSticker.realm_name]!"
	..()
	priority_announce( \
		"To cling to the past is to rot in place. Progress waits for no one.\n\n" + \
		"A Council of the Enlightened, under the gaze of Zizo, Mistress of Progress, " + \
		"declares [invoker.real_name] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a PROGRESSIVE rule of arcane enlightenment.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found wanting in vision, " + \
		"and their claim to rulership crumbles before the march of progress.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The future bends to your will. The throne is yours."))

/datum/usurpation_rite/progressive_dominion/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Rite of Progressive Dominion has failed. [reason] Progress is halted — for now.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Rite of Progressive Dominion has failed. [reason]"))


/datum/usurpation_rite/progressive_dominion/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The Rite of Progressive Dominion is underway. [length(assenters)]/[DOMINION_REQUIRED_ASSENTS] voices have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The Council of the Enlightened has affirmed [invoker?.real_name]'s claim. The future approaches."
	return null

/datum/usurpation_rite/progressive_dominion/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne in the name of progress. Speak your assent -- or stop them. ([length(assenters)]/[DOMINION_REQUIRED_ASSENTS] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The Council of the Enlightened has spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null

/// Returns TRUE if the mob is a mage (any arcyne training), a Zizite follower, or undead.
/datum/usurpation_rite/progressive_dominion/proc/is_qualified_voice(mob/living/carbon/human/user)
	if(get_user_spell_tier(user) >= 1)
		return TRUE
	if(istype(user.patron, /datum/patron/inhumen/zizo))
		return TRUE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return TRUE
	return FALSE
