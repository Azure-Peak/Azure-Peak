/**
 # Rite of Golden Accord

 Republic-coded usurpation rite. Subtly Matthios coded.

 Design intent: Makes the merchant class a political threat. Makes steward an insider threat, and gives the Merchant in particular a path to the throne. Guildmaster and Bathmatron can also invoke it. No god is invoked - originally I intended for Matthios to be invoked but that would immediately make them valid in the eyes of everyone. So instead, any reference or accusation of heresy is tangential and this is framed as a purely secular assertion of commercial power. 
 
 The assenter needs 200 mammons in their bank account at the time of invocation / assent. (Not the invoker, that was too inconvenient from my own testing). Steward should have the easiest time by just assigning paper money to would be plotter - and merchant can hand out money. This means a Steward could in theory, stop such a plot easily through fining.

 Not accessible to outlaws and undead.
 */

/datum/usurpation_rite/golden_accord
	name = "Rite of Golden Accord"
	desc = "The old ways of noble blood and divine right are outdated. End rule by blood and establish a republic, where those who earn their wealth through wits and grit can claim the throne!"
	explanation = {"<p>No god is invoked here (Or is there...?) — only the weight of coin and the will of the people who move it.</p>\
<p><b>Who may invoke:</b> The Steward, Merchant, Guildmaster, or Bathmaster — the coinmaster, and the natural leader(s) of the burghers.</p>\
<p><b>How it works:</b> Anyone with a total of at least 200 mammons in their bank account or person must gather near the throne and speak the words 'I assent' to support your claim.</p>\
<p><b>Completion condition:</b> <b>7</b> citizens must speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Outlaws and the undead may not invoke or assent to this rite.</p>\
<p><b>Realm type if successful:</b> Republic, ruled by a Grand Consul.</p>"}
	new_ruler_title = "Grand Consul"
	new_ruler_title_f = "Grand Consul"
	new_realm_type = "Republic"
	new_realm_type_short = "Republic"
	roundend_epilogue = "The quill has proven mightier than the sword. " + \
		"The old order has been overthrown, replaced by a democratic, prosperous republic -- " + \
		"where only worthy burghers with coin earned by their own merit can claim the throne, " + \
		"elected by a Council of their peers. " + \
		"Foreign rulers whisper of heresy, of Matthiosite plots, " + \
		"but the people know the truth -- " + \
		"that power belongs to those who bring prosperity to the realm!"

/// Steward, Merchant, Guildmaster, or Bathmaster with 200+ mammon. No outlaws or undead.
/datum/usurpation_rite/golden_accord/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!(user.job in list("Steward", "Merchant", "Guildmaster", "Bathmaster")))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return FALSE
	return TRUE

/datum/usurpation_rite/golden_accord/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. Citizens with bank accounts must now speak 'I assent' near the throne. You require [GOLDEN_REQUIRED_ASSENTS] voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/golden_accord/on_gathering_timeout()
	fail("The burghers of the realm did not grant sufficient assent.")

/// Override: citizens with bank accounts assent, not nobles.
/datum/usurpation_rite/golden_accord/try_assent(mob/living/carbon/human/burgher)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(burgher))
		return FALSE
	if(burgher.stat != CONSCIOUS)
		return FALSE
	if(burgher == invoker)
		to_chat(burgher, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(get_total_wealth(burgher) < GOLDEN_REQUIRED_WEALTH)
		to_chat(burgher, span_warning("You need at least [GOLDEN_REQUIRED_WEALTH] mammons to your name to speak assent, pauper."))
		return FALSE
	if(HAS_TRAIT(burgher, TRAIT_OUTLAW))
		to_chat(burgher, span_warning("Outlaws have no standing in matters of commerce."))
		return FALSE
	if(HAS_TRAIT(burgher, TRAIT_ROTMAN) || (burgher.mob_biotypes & MOB_UNDEAD))
		to_chat(burgher, span_warning("The dead hold no contracts."))
		return FALSE
	if(assenters[burgher])
		to_chat(burgher, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(burgher, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[burgher] = TRUE
	on_assent_accepted(burgher)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/golden_accord/on_assent_accepted(mob/living/carbon/human/burgher)
	burgher.visible_message( \
		span_notice("[burgher.real_name] speaks their assent to the Golden Accord."), \
		span_notice("You speak your assent. The ledger marks your name."))
	to_chat(invoker, span_notice("[burgher.real_name] has assented. ([length(assenters)]/[GOLDEN_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/golden_accord/check_assent_threshold()
	if(length(assenters) >= GOLDEN_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/golden_accord/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Golden Accord!\n\n" + \
		"The people of [SSticker.realm_name] has spoken — a merchant republic shall be established, and [invoker.real_name] elected its first Chancellor!\n\n" + \
		"A Council of Burghers has affirmed this claim.\n\n" + \
		"The Accord shall be sealed in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.", \
		"Rite of Golden Accord", \
		sound_contesting)
	to_chat(invoker, span_notice("The burghers have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/golden_accord/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	priority_announce( \
		"Power belongs to those who bring prosperity to the realm.\n\n" + \
		"The Council of Burghers declares [invoker.real_name] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a PROSPEROUS republic of free commerce.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found wanting in stewardship, " + \
		"and their authority is hereby rendered insolvent.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The weight of coin settles in your hands. The throne is yours."))

/datum/usurpation_rite/golden_accord/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Golden Accord has failed. [reason] The ledger is closed.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Golden Accord has failed. [reason]"))


/datum/usurpation_rite/golden_accord/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The Golden Accord is underway. [length(assenters)]/[GOLDEN_REQUIRED_ASSENTS] burghers have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The Council of Burghers has affirmed [invoker?.real_name]'s claim. The Accord approaches."
	return null

/datum/usurpation_rite/golden_accord/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by weight of coin. Burghers, speak your assent -- or stop them. ([length(assenters)]/[GOLDEN_REQUIRED_ASSENTS] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The Council of Burghers has spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null

/// Returns the total mammon value on the mob's person plus their bank account.
/datum/usurpation_rite/golden_accord/proc/get_total_wealth(mob/living/carbon/human/user)
	var/total = 0
	// Count coins on person
	for(var/obj/item/roguecoin/coin in user.GetAllContents())
		total += coin.get_real_price()
	// Count bank account
	if(user in SStreasury.bank_accounts)
		total += SStreasury.bank_accounts[user]
	return total
