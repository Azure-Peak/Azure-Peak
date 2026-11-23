/**
 * Rite of Martial Supercession
 *
 * Ravox-themed usurpation rite.
 *
 * Design intent: A military junta in all but name to makes a disloyal garrison a threat. The retinue (Marshal, Knight, Squire) and garrison (Sergeant, Man at Arms) can invoke this to seize the throne by rallying anyone with Expert weapon skill — guards, veterans, mercenaries, adventurers. Requires 6 assents due to the relative abundance of combat-skilled characters, making it a broad coalition play.
 *
 * The undead are explicitly excluded from this path - there's alternative paths for true antagonists.
 */
/datum/usurpation_rite/martial_supercession
	name = "Rite of Martial Supercession"
	desc = "A crown means nothing if it cannot be defended. When the realm's ruler falters in their duty to protect the realm, true warriors must step up and take the mantle."
	explanation = {"<p>A member of the retinue or garrison may claim the throne, rallying those proven in battle to their cause.</p>\
<p><b>Who may invoke:</b> Members of the retinue (Marshal, Knight, Squire) or non-warden garrison (Sergeant, Man at Arms).</p>\
<p><b>How it works:</b> Warriors with Expert-level weapon skill or higher must gather near the throne and speak the words 'I assent' to support your claim. Any weapon skill counts.</p>\
<p><b>Completion condition:</b> <b>6</b> warriors must speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> The undead may not invoke or assent to this rite. Outlaws may not invoke, but may assent.</p>\
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
	required_assents = MARTIAL_REQUIRED_ASSENTS
	invoke_bars = RITE_BAR_OUTLAW | RITE_BAR_UNDEAD
	assent_bars = RITE_BAR_UNDEAD
	undead_rejection = "The dead cannot serve justice."
	assenter_group = "warriors"
	council_name = "the Council of Arms"
	claim_basis = "by right of arms"

/// Retinue and senior garrison can invoke. No outlaws or undead.
/datum/usurpation_rite/martial_supercession/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!(user.job in GLOB.retinue_positions) && !(user.job in list("Sergeant", "Man at Arms")))
		return FALSE
	return TRUE

/datum/usurpation_rite/martial_supercession/can_assent(mob/living/carbon/human/warrior)
	if(!has_expert_combat_skill(warrior))
		to_chat(warrior, span_warning("Only those who have proven themselves as expert warriors may speak assent to this rite."))
		return FALSE
	return ..()

/datum/usurpation_rite/martial_supercession/get_contest_announcement()
	return "In the name of Ravox, God of War and Justice, a claim is made upon the throne of [SSticker.realm_name].\n\n" + \
		"A Council of Warriors has affirmed this claim.\n\n" + \
		"Ravox's judgment shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down."

/datum/usurpation_rite/martial_supercession/get_victory_announcement(old_ruler_name)
	return "Those who fail to defend their throne do not deserve to sit upon it.\n\n" + \
		"A Council of Arms, in the name of Ravox, " + \
		"declares [invoker.get_unmasked_name()] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a JUST rule of law.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been judged unfit to lead, " + \
		"and their authority is hereby revoked.\n\n" + \
		"Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name]!"

/// Returns TRUE if the mob has Expert (4+) in any combat skill.
/datum/usurpation_rite/martial_supercession/proc/has_expert_combat_skill(mob/living/carbon/human/user)
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill_ref = SSskills.all_skills[skill_type]
		if(!istype(skill_ref, /datum/skill/combat))
			continue
		if(user.get_skill_level(skill_type) >= SKILL_LEVEL_EXPERT)
			return TRUE
	return FALSE
