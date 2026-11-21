/**
 * Rite of Solar Succession
 *
 * The "legitimate" path to the throne — a noble council of peers under Astrata's authority.
 *
 * Design intent: Enables insider threats within the ducal family or close advisors. The Prince
 * Heartfelt, Consort, Hand, Steward and Councillors can all invoke this rite's easier version. Steward have an
 * overlap with Golden Accord but this is fine as they dip both end. I want to increase the threat
 * posed by the Steward, Hand and Councillor (Which is an off role for these two roles), especially
 * because of the prevalence of the greedy Steward / Hand character archetype. This should
 * encourage more plotting and backstabbing RP within the court.
 *
 * Insiders can stage a palace coup with just 3 noble voices — e.g. convincing
 * 3 of the 4 knights or hand or prince etc. is enough. Outsiders (any other noble) need a larger quorum of 5,
 * making it a harder but still viable path.
 *
 * Non-resident nobles (foreign envoys, Heartfelt) count as half a vote each.
 * This serves as a backup mechanism if hyperwar thin the local nobility —
 * non-resident nobles can be brought in to fill the gap, but at reduced weight.
 *
 * Outlaws and undead are shunned by Astrata outside of her order. They may not invoke or assent to this rite.
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
	required_assents = SOLAR_REQUIRED_ASSENTS_OUTSIDER
	invoke_bars = RITE_BAR_OUTLAW | RITE_BAR_UNDEAD
	assent_bars = RITE_BAR_OUTLAW | RITE_BAR_UNDEAD
	outlaw_rejection = "Astrata shuns those who stand outside the order."
	undead_rejection = "The sun has no place for the living dead."
	vote_weight_note = "Foreign nobles count as half a voice."
	assenter_group = "nobles"
	council_name = "the Council of Lords"
	claim_basis = "by Astrata's light"

/datum/usurpation_rite/solar_succession/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_NOBLE))
		return FALSE
	return TRUE

/datum/usurpation_rite/solar_succession/can_assent(mob/living/carbon/human/noble)
	if(!HAS_TRAIT(noble, TRAIT_NOBLE))
		to_chat(noble, span_warning("Only those of noble blood may speak assent."))
		return FALSE
	return ..()

/datum/usurpation_rite/solar_succession/get_contest_announcement()
	return "In the name of Astrata, Goddess of Order, a claim is made upon the throne of [SSticker.realm_name].\n\n" + \
		"A Council of Lords has affirmed this claim.\n\n" + \
		"The Sun's judgement shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.\n\n"

/datum/usurpation_rite/solar_succession/get_victory_announcement(old_ruler_name)
	return "The sun must set so that dawn may come again.\n\n" + \
		"The Council of Lords, under Astrata's watchful gaze, " + \
		"declares [invoker.get_unmasked_name()] the rightful [SSticker.rulertype] of [SSticker.realm_name], in an ORDERLY transfer of power.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has surely lost the favor of the Sun Goddess, " + \
		"and their divine right to rulership!\n\n" + \
		"Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name]!"

/// Returns the number of assent voices required based on the invoker's position.
/// Insiders need fewer (insider / diplomatic coup).
/datum/usurpation_rite/solar_succession/get_required_assents()
	if(invoker.job == "Consort" || invoker.job == "Prince" || invoker.job == "Hand" || \
	invoker.job == "Steward" || invoker.job == "Councillor" || HAS_TRAIT(invoker, TRAIT_HEARTFELT))
		return SOLAR_REQUIRED_ASSENTS_INSIDER
	return ..()

/// Returns the vote weight for a noble: resident nobles count full, foreign nobles count half.
/datum/usurpation_rite/solar_succession/get_vote_weight(mob/living/carbon/human/noble)
	if((noble.job in GLOB.foreign_positions) || HAS_TRAIT(noble, TRAIT_HEARTFELT))
		return RITE_VOTE_HALF
	return RITE_VOTE_FULL
