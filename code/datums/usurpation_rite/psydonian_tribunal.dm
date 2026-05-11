/**
 # Rite of Psydonian Tribunal

 Psydon-themed Inquisition usurpation rite.

 Design intent: This is probably one of the hardest to design properly. Psydon is probably dead or sleeping (left ambigious in lore), but definitely not quite present in the world. The Inquisition was designed to be a threat to the town and a form of soft antagonist, but our playerbase seldomly do so - and don't really emphasize the Grenzelhoftian - Otavan political rivalry enough. 

 This gives them a unique path to usurp the throne, with the lowest assent requirements (allowing a full house to assent and start it themselves). It has one of the most restrictive requirements for who can assent and invoke, but how "easy" it is to pull off will keep this as an option in the back of players' minds, that if worst come to worst, with other Psydonites support, the Inquisition can make a very risky gambit to seize power, hopefully driving in round conflicts.

 Only the Inquisition (Inquisitor, Absolver, Orthodoxist) can invoke. Any Psydonites who is not an undead (sorry Psydonite skeleton) can assent - so Psydon Heretics can participate with Inquisition members.

The epilogue implies an impending war with Grenzelhoft - for breaking the status quo and the balance of power. But we don't want admins or events to actually diminish the impact within the round, so it is implied to be a threat from the outside after the week is over (and the round reset). Unlike the Sacred Supercession version, this one is framed as far less legitimate and troublesome as the Inquisition is not the established or majority religion of the land.

*/

/datum/usurpation_rite/psydonian_tribunal
	name = "Rite of Psydonian Tribunal"
	desc = "Order has fallen! The Inquisition must act to restore order and pass judgment upon the people in the name of Psydon!"
	explanation = {"<p>The Inquisition may claim the throne through appeal to other Psydonites - provided they can hold the realm against any opposition.</p>\
<p><b>Who may invoke:</b> Members of the Inquisition (Inquisitor, Absolver, Orthodoxist).</p>\
<p><b>How it works:</b> Followers of Psydon must gather near the throne and speak the words 'I assent' to support your claim.</p>\
<p><b>Completion condition:</b> Only <b>4</b> followers of Psydon may speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Only followers of Psydon may invoke or assent. The undead are excluded, but not outlaws.</p>\
<p><b>Realm type if successful:</b> Ordinate, ruled by a Grand Inquisitor.</p>"}
	new_ruler_title = "Grand Inquisitor"
	new_ruler_title_f = "Grand Inquisitor"
	new_realm_type = "Ordinate"
	new_realm_type_short = "Ordinate"
	roundend_epilogue = \
		"The Inquisition has seized power in the name of Psydon. " + \
		"An oddity that no one saw coming. " + \
		"The Inquisition - fanatics, criminals, assassins, the best and the dregs of His faithful - " + \
		"now rule in His name, over a realm of Tennites who have long since abandoned Psydon " + \
		"for His children that will listen to their prayers. " + \
		"How long can this rule last?" + \
		"\n\n" + \
		"To the north, the smoke of a signal fire rises. " + \
		"Through this takeover, the Inquisition has broken the balance of power that kept the realm sovereign. " + \
		"How can a wretched sect of Psydonian fanatics rule a realm of Tennites, " + \
		"once the proud heart of the very Celestial Empire, the very place of Comet Syon, " + \
		"where it is said that the very gods were created, from the shard of His divinity? " + \
		"Grenzelhoft will not stand idle while Otavan fanatics rule the heart of the realm, " + \
		"and neither will the many Tennite nobles of the land, eager to reclaim the throne for themselves. " + \
		"War is coming." + \
		"\n\n" + \
		"But just as Psydon stirs and endures for His return, " + \
		"so does the Inquisition endure to re-establish His rule upon Psydonia."

/// Only Inquisition members (Inquisitor, Absolver, Orthodoxist) who follow Psydon can invoke. No undead.
/datum/usurpation_rite/psydonian_tribunal/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return FALSE
	if(!(user.job in GLOB.inquisition_positions))
		return FALSE
	if(!istype(user.patron, /datum/patron/old_god))
		return FALSE
	return TRUE

/datum/usurpation_rite/psydonian_tribunal/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. Followers of Psydon must now speak 'I assent' near the throne. You require [TRIBUNAL_REQUIRED_ASSENTS] voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/psydonian_tribunal/on_gathering_timeout()
	fail("The followers of Psydon did not grant sufficient assent.")

/// Override: Psydon followers or Heresiarchs can assent. No undead.
/datum/usurpation_rite/psydonian_tribunal/try_assent(mob/living/carbon/human/follower)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(follower))
		return FALSE
	if(follower.stat != CONSCIOUS)
		return FALSE
	if(follower == invoker)
		to_chat(follower, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(HAS_TRAIT(follower, TRAIT_ROTMAN) || (follower.mob_biotypes & MOB_UNDEAD))
		to_chat(follower, span_warning("Psydon does not suffer the undead."))
		return FALSE
	if(!istype(follower.patron, /datum/patron/old_god))
		to_chat(follower, span_warning("Only the faithful of Psydon may speak assent to this tribunal."))
		return FALSE
	if(assenters[follower])
		to_chat(follower, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(follower, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[follower] = TRUE
	on_assent_accepted(follower)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/psydonian_tribunal/on_assent_accepted(mob/living/carbon/human/follower)
	follower.visible_message( \
		span_notice("[follower.real_name] speaks their assent to the Psydonian Tribunal."), \
		span_notice("You speak your assent. Psydon acknowledges your judgment."))
	to_chat(invoker, span_notice("[follower.real_name] has assented. ([length(assenters)]/[TRIBUNAL_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/psydonian_tribunal/check_assent_threshold()
	if(length(assenters) >= TRIBUNAL_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/psydonian_tribunal/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Psydonian Tribunal!\n\n" + \
		"In the name of Psydon, the Inquisition passes judgment upon the throne of [SSticker.realm_name].\n\n" + \
		"The faithful have affirmed this claim.\n\n" + \
		"The Tribunal's verdict shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.", \
		"Rite of Psydonian Tribunal", \
		sound_contesting)
	to_chat(invoker, span_notice("The faithful have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/psydonian_tribunal/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	priority_announce( \
		"There are many gods, but only one who was truly, wholly good.\n\n" + \
		"The Inquisition, in His name, declares [invoker.real_name] the rightful [SSticker.rulertype] of [SSticker.realm_name], restoring ORDER to this realm.\n\n" + \
		"[old_ruler_name], unable to contest this judgment, shall be cast to the dustbin of history, " + \
		"and their authority is hereby annulled.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The judgment of Psydon is rendered. The throne is yours."))

/datum/usurpation_rite/psydonian_tribunal/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Psydonian Tribunal has failed. [reason] A dead god has no place amongst the living.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Psydonian Tribunal has failed. [reason]"))


/datum/usurpation_rite/psydonian_tribunal/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The Psydonian Tribunal is underway. [length(assenters)]/[TRIBUNAL_REQUIRED_ASSENTS] voices have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The Inquisition has affirmed [invoker?.real_name]'s claim. The Tribunal's verdict approaches."
	return null

/datum/usurpation_rite/psydonian_tribunal/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by Psydon's judgment. Faithful, speak your assent -- or stop them. ([length(assenters)]/[TRIBUNAL_REQUIRED_ASSENTS] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The Inquisition has spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null
