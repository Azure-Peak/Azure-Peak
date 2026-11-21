/**
 * Rite of Popular Acclaim
 *
 * Secular populist usurpation rite.
 *
 * Design Intent: Originally, I wanted a Matthios themed rite accessible to bandits, but realized that just made them even more valid in the eyes of others. And I really wanted to move away from the anachronistic marxist framing of Matthios in old roguetown lore. So instead, inspired by it, I made a purely secular rite that just so happens to be accessible to bandits. Thematically, this is about as close to the "Peasant Rebel" antagonist as I can get with this system, adjusted for AP where this antagonist class is dead and for our own environment.
 *
 * Outlaws and bandits count DOUBLE for this - for the risk they take.
 *
 * However, of all of the usurpation rites, this one takes the most voices - a total of TEN (10!!) weighted voices - but bandits and outlaws count as two voices each, so it can be achieved with just 5 actual people if they're all outlaws.
 *
 * The dead has no voice in this. The world is not progressive enough for that.
*/

/datum/usurpation_rite/popular_acclaim
	name = "Rite of Popular Acclaim"
	desc = "Claim the throne through the raw will of the people. No god, no mandate — just enough voices."
	explanation = {"<p>Vox populi, vox dei. The voice of the people is the voice of the gods. When the people speak with one voice, no throne can stand against them.</p>\
<p><b>Who may invoke:</b> Bandits, outlaws (including outlawed nobles), peasants, or sidefolk.</p>\
<p><b>How it works:</b> The people of the realm must gather near the throne and speak the words 'I assent' to support your claim. Anyone may assent.</p>\
<p><b>Completion condition:</b> <b>10</b> weighted voices must speak their assent. Bandits and outlaws count as <b>two</b> voices each — they risked everything to assert their right. All others count as one. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> The undead may not invoke or assent.</p>\
<p><b>Realm type if successful:</b> Kingdom of Freemen, ruled by a Tribune.</p>"}
	new_ruler_title = "Tribune"
	new_ruler_title_f = "Tribune"
	new_realm_type = "Kingdom of Freemen"
	new_realm_type_short = "Kingdom of Freemen"
	roundend_epilogue = "The people have spoken, and the old order has crumbled. " + \
		"The realm is ruled by the people, for the people! " + \
		"The voice of the people is the voice of the gods! " + \
		"Foreign rulers may dismiss this as the ruin of rabble, " + \
		"but the people know the truth -- " + \
		"that power belongs to those who have the courage to seize it, " + \
		"and the people to support it!"
	required_assents = ACCLAIM_REQUIRED_ASSENTS
	invoke_bars = RITE_BAR_UNDEAD
	assent_bars = RITE_BAR_UNDEAD
	undead_rejection = "The dead have no voice among the living."
	vote_weight_note = "Bandits and outlaws count as two voices each."
	assenter_group = "people"
	council_name = "the people"
	claim_basis = "by popular will"

/// Bandits, outlaws (including outlawed nobles), peasants, or sidefolk can invoke. No undead.
/datum/usurpation_rite/popular_acclaim/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	// Bandits and outlaws can invoke — including outlawed nobles
	if(user.job == "Bandit" || HAS_TRAIT(user, TRAIT_OUTLAW))
		return TRUE
	// Peasants and sidefolk can invoke
	if(user.job in GLOB.peasant_positions)
		return TRUE
	if(user.job in GLOB.sidefolk_positions)
		return TRUE
	if(user.job == "Shophand")
		return TRUE
	return FALSE

/datum/usurpation_rite/popular_acclaim/get_contest_announcement()
	return "The people of [SSticker.realm_name] have spoken — [invoker.get_unmasked_name()] shall step forth as the Tribune of [SSticker.realm_name]. A rule by the people, for the people!\n\n" + \
		"The will of the people shall be settled in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.\n\n"

/datum/usurpation_rite/popular_acclaim/on_complete()
	..()
	if(invoker?.mind)
		var/datum/antagonist/prebel/rebel_datum = invoker.mind.has_antag_datum(/datum/antagonist/prebel)
		if(rebel_datum && rebel_datum.rev_team)
			rebel_datum.rev_team.rite_won = TRUE

/datum/usurpation_rite/popular_acclaim/get_victory_announcement(old_ruler_name)
	return "A ruler must rule for the benefits of their subjects. And no one is more fit than one elected by their subjects.\n\n" + \
		"The people of [SSticker.realm_name] declare [invoker.get_unmasked_name()] the rightful [SSticker.rulertype], chosen by POPULAR acclaim.\n\n" + \
		"[old_ruler_name], unable to contest this claim, has lost the confidence of the people, " + \
		"and their authority is hereby revoked.\n\n" + \
		"Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name], raised up by the will of the freefolk!"

/// Returns the vote weight: outlaws/bandits count double, everyone else single.
/datum/usurpation_rite/popular_acclaim/get_vote_weight(mob/living/carbon/human/person)
	if(person.job == "Bandit" || HAS_TRAIT(person, TRAIT_OUTLAW))
		return RITE_VOTE_DOUBLE
	return RITE_VOTE_FULL
