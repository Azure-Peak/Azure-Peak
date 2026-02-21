/**
 # Rite of Martial Supercession

 Ravox-themed usurpation rite.

 Design intent: A military junta in all but name to makes a disloyal garrison a threat. The retinue (Marshal, Knight, Squire) and garrison (Sergeant, Man at Arms) can invoke this to seize the throne by rallying anyone with Expert weapon skill — guards, veterans, mercenaries, adventurers. Requires 7 assents due to the relative abundance of combat-skilled characters, making it a broad coalition play.

 Outlaws and the undead are explicitly excluded from this path - there's alternative paths for true antagonists.
 */
/datum/usurpation_rite/martial_supercession
	name = "Rite of Martial Supercession"
	desc = "A crown means nothing if it cannot be defended. When the realm's ruler falters in their duty to protect the realm, true warriors must step up and take the mantle."
	explanation = {"<p>A member of the retinue or garrison may claim the throne, rallying those proven in battle to their cause.</p>\
<p><b>Who may invoke:</b> Members of the retinue (Marshal, Knight, Squire) or non-warden garrison (Sergeant, Man at Arms).</p>\
<p><b>How it works:</b> Warriors with Expert-level weapon skill or higher must gather near the throne and speak the words 'I assent' to support your claim. Any weapon skill counts.</p>\
<p><b>Completion condition:</b> <b>6</b> warriors must speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Outlaws and the undead may not invoke or assent to this rite.</p>\
<p><b>Realm type if successful:</b> Sovereign Order, ruled by a Grand Master.</p>"}
	new_ruler_title = "Grand Master"
	new_ruler_title_f = "Grand Master"
	new_realm_type = "Sovereign Order"
	new_realm_type_short = "Sovereign Order"
	roundend_epilogue = "The realm has been seized by the strong, " + \
		"who claims to be just, to rule in Ravox's name. " + \
		"It is said that the first King and Queen of the world were great warriors, " + \
		"who won the throne through conquest and bled to keep it. " + \
		"But will this new Grand Master be able to defend the realm against its enemies, " + \
		"both foreign and domestic? " + \
		"Only time will tell if their rule will be marked by glory, tyranny or obscurity."

/// Retinue and senior garrison can invoke. No outlaws or undead.
/datum/usurpation_rite/martial_supercession/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!(user.job in GLOB.retinue_positions) && !(user.job in list("Sergeant", "Man at Arms")))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return FALSE
	return TRUE

/datum/usurpation_rite/martial_supercession/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. Warriors with Expert weapon skill must now speak 'I assent' near the throne. You require [MARTIAL_REQUIRED_ASSENTS] voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/martial_supercession/on_gathering_timeout()
	fail("The warriors of the realm did not grant sufficient assent.")

/// Override: warriors assent, not nobles. Check Expert+ combat skill instead of TRAIT_NOBLE.
/datum/usurpation_rite/martial_supercession/try_assent(mob/living/carbon/human/warrior)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(warrior))
		return FALSE
	if(warrior.stat != CONSCIOUS)
		return FALSE
	if(warrior == invoker)
		to_chat(warrior, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(!has_expert_combat_skill(warrior))
		to_chat(warrior, span_warning("Only those who have proven themselves as expert warriors may speak assent to this rite."))
		return FALSE
	if(HAS_TRAIT(warrior, TRAIT_OUTLAW))
		to_chat(warrior, span_warning("Outlaws stand outside the law. There is no justice for the lawless."))
		return FALSE
	if(HAS_TRAIT(warrior, TRAIT_ROTMAN) || (warrior.mob_biotypes & MOB_UNDEAD))
		to_chat(warrior, span_warning("The dead cannot serve justice."))
		return FALSE
	if(assenters[warrior])
		to_chat(warrior, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(warrior, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[warrior] = TRUE
	on_assent_accepted(warrior)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/martial_supercession/on_assent_accepted(mob/living/carbon/human/warrior)
	warrior.visible_message( \
		span_notice("[warrior.real_name] speaks their assent to the Rite of Martial Supercession."), \
		span_notice("You speak your assent. Ravox acknowledges your voice."))
	to_chat(invoker, span_notice("[warrior.real_name] has assented. ([length(assenters)]/[MARTIAL_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/martial_supercession/check_assent_threshold()
	if(length(assenters) >= MARTIAL_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/martial_supercession/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Martial Supercession!\n\n" + \
		"In the name of Ravox, God of War and Justice, a claim is made upon the throne of [SSticker.realm_name].\n\n" + \
		"A Council of Warriors has affirmed this claim.\n\n" + \
		"Ravox's judgment shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.", \
		"Rite of Martial Supercession", \
		sound_contesting)
	to_chat(invoker, span_notice("The warriors have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/martial_supercession/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	priority_announce( \
		"Those who fail to defend their throne do not deserve to sit upon it.\n\n" + \
		"A Council of Arms, in the name of Ravox, " + \
		"declares [invoker.real_name] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a JUST rule of law.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been judged unfit to lead, " + \
		"and their authority is hereby revoked.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name]!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("Ravox's iron gaze settles upon you. The throne is yours."))

/datum/usurpation_rite/martial_supercession/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Rite of Martial Supercession has failed. [reason] The sword has been sheathed.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Rite of Martial Supercession has failed. [reason]"))


/datum/usurpation_rite/martial_supercession/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The Rite of Martial Supercession is underway. [length(assenters)]/[MARTIAL_REQUIRED_ASSENTS] warriors have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The Council of Arms has affirmed [invoker?.real_name]'s claim. Ravox's judgment approaches."
	return null

/datum/usurpation_rite/martial_supercession/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by right of arms. Warriors, speak your assent -- or stop them. ([length(assenters)]/[MARTIAL_REQUIRED_ASSENTS] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The Council of Arms has spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null

/// Returns TRUE if the mob has Expert (4+) in any combat skill.
/datum/usurpation_rite/martial_supercession/proc/has_expert_combat_skill(mob/living/carbon/human/user)
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill_ref = SSskills.all_skills[skill_type]
		if(!istype(skill_ref, /datum/skill/combat))
			continue
		if(user.get_skill_level(skill_type) >= SKILL_LEVEL_EXPERT)
			return TRUE
	return FALSE
