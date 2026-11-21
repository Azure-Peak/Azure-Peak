/**
 * Rite of Sacred Supercession.
 *
 * Church / Astrata themed usurpation rite.
 *
 * Design intent: This is meant to give the Church an internal path to taking over power - and is only accessible to them as a result. It requires membership of in the town Church faction to invoke. Anyone who is a clergy (I.e. miracles access) can assent - and like the noble counterpart, wanderers / adventurers can also serve as a backup (In fact, given Church's lack of number you probably want adventurers on your side not just to reach the assent threshold but to fight the retinue if needed). Bishop - Duke conflict is probably the most common internal conflict (alongside Inquisition and Everyone) especially when the Grand Duke runs a gimmick or tyrannical law. This should encourage some follow through on conflicts and start shifting AP players mindset to "Can I coup?"
 *
 * The epilogue implies an impending war with Otava - for breaking the status quo and the balance of power. But we don't want admins or events to actually diminish the impact within the round, so it is implied to be a threat from the outside after the week is over (and the round reset).
 *
 * Not accessible to outlaws and undead, of course.
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
	required_assents = BISHOPRIC_REQUIRED_ASSENTS
	invoke_bars = RITE_BAR_OUTLAW | RITE_BAR_UNDEAD
	assent_bars = RITE_BAR_OUTLAW | RITE_BAR_UNDEAD
	outlaw_rejection = "Astrata shuns those who stand outside the order."
	undead_rejection = "The sun has no place for the living dead."
	vote_weight_note = "Foreign clergy count as half a voice."
	assenter_group = "faithful"
	council_name = "the faithful"
	claim_basis = "by Astrata's mandate"

/// Any member of the Church of the Ten with a divine patron. No outlaws or undead.
/datum/usurpation_rite/sacred_supercession/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!(user.job in GLOB.church_positions))
		return FALSE
	if(!istype(user.patron, /datum/patron/divine))
		return FALSE
	return TRUE

/datum/usurpation_rite/sacred_supercession/can_assent(mob/living/carbon/human/faithful)
	if(!istype(faithful.patron, /datum/patron/divine))
		to_chat(faithful, span_warning("Only followers of the Ten may speak assent to this rite."))
		return FALSE
	if(!is_qualified_faithful(faithful))
		to_chat(faithful, span_warning("Only ordained members of the Church or those who have proven their devotion may speak assent."))
		return FALSE
	return ..()

/datum/usurpation_rite/sacred_supercession/get_contest_announcement()
	return "In the name of Astrata, Goddess of Order, the Church reluctantly makes a claim upon the throne of [SSticker.realm_name], to restore order and faith!\n\n" + \
		"The faithful have affirmed this claim.\n\n" + \
		"The Sun's judgment shall fall in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down."

/datum/usurpation_rite/sacred_supercession/get_victory_announcement(old_ruler_name)
	return "The sun rises on a new order.\n\n" + \
		"The faithful of Astrata declare [invoker.get_unmasked_name()] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a HOLY reign.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found lacking in faith, " + \
		"and their divine mandate is hereby revoked.\n\n" + \
		"Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name]!"

/// Returns TRUE if the mob qualifies: either a church position holder, or has T1+ Divine devotion.
/datum/usurpation_rite/sacred_supercession/proc/is_qualified_faithful(mob/living/carbon/human/user)
	if(user.job in GLOB.church_positions)
		return TRUE
	if(user.devotion?.level >= CLERIC_T1)
		return TRUE
	return FALSE

/// Returns the vote weight: resident faithful count full, foreign/wanderer count half.
/datum/usurpation_rite/sacred_supercession/get_vote_weight(mob/living/carbon/human/faithful)
	if(faithful.job in GLOB.foreign_positions)
		return RITE_VOTE_HALF
	return RITE_VOTE_FULL
