/**
 * Rite of Progressive Dominion
 *
 * Zizo-themed usurpation rite.
 *
 * Design intent: A mirror of the Lunar Ascension. Zizo is the mistress of Progress - this also allows for those with arcyne power to vote. But Zizo, being so progressive, and also the mistress of undead and left-handed magick, will allow the undead (Who is under your sway, surely), a vote. So, with this dead voter manipulation, it is technically one of the easiest rite to get the assent for. But of course, by invoking the most heretical and hated path, you are sure to draw everyone's ires - good luck contesting the throne after that.
 *
 * This is meant as the path for a lich - but they also have path through Lunar Ascension, and it is a thematical choice that makes it easier for them if they cannot gather 5 mages on their side, in exchange for making their claim to power much less palatable. Thematic however, and gives them a "win" condition instead of just hyperwar - now they can become the rightful Grand Duke and roleplay a world under the lich's rule.
 *
 * Accessible to outlaws and undead, technically.
 *
 * No, this is not a political dig. It just so happens that Zizo is the Goddess of Progress and also Undeath.
 *
 * Zizo, Zizo, Zizo! Goddess of Progress! Goddess of Progress! Bring us lyfe from whence comes death!
 *
 * Zizo, Zizo, Zizo! Grants the dead their democratic rights to vote!
 *
 * Zizo, Zizo, Zizo! The future is bright under your progressive rule!
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
	required_assents = DOMINION_REQUIRED_ASSENTS
	assenter_group = "enlightened"
	council_name = "the Council of the Enlightened"
	claim_basis = "in the name of progress"

/// Any mage with T2+ arcyne training, any Zizite follower, or any undead, can invoke.
/datum/usurpation_rite/progressive_dominion/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	// Undead can invoke without arcyne training — their existence is Zizo's will
	if(is_undead(user))
		return TRUE
	// Zizite followers can invoke — Zizo is their goddess
	if(istype(user.patron, /datum/patron/inhumen/zizo))
		return TRUE
	// Living need arcyne training
	if(HAS_TRAIT(user, TRAIT_ARCYNE))
		return TRUE
	return FALSE

/datum/usurpation_rite/progressive_dominion/can_assent(mob/living/carbon/human/supporter)
	if(!is_qualified_voice(supporter))
		to_chat(supporter, span_warning("Only those trained in the arcyne arts, followers of Zizo, or touched by undeath may speak assent to this rite."))
		return FALSE
	return ..()

/datum/usurpation_rite/progressive_dominion/get_contest_announcement()
	return "In the name of Zizo, Mistress of Progress, a claim is made upon the throne of [SSticker.realm_name].\n\n" + \
		"A Council of the Enlightened has affirmed this claim.\n\n" + \
		"The future shall be decided in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.\n\n"

/datum/usurpation_rite/progressive_dominion/get_roundend_epilogue()
	if(is_undead(invoker))
		return "One can conquer a realm on a tide of bones. " + \
			"But the dead bear no children and hold no true will. " + \
			"How long will the living -- even those who follow the Mistress of Progress -- tolerate their rule?"
	return "And as suddenly as the Celestial Empire has fallen, " + \
		"it has seemingly returned in [SSticker.realm_name]. " + \
		"O Zizo! Dame of Progress! The future will be bright under your rule! " + \
		"Grant us armaments! Grant us power! " + \
		"Let us stand fast against the darkness of stagnation! " + \
		"Let us stand fast against the rot of the old order! " + \
		"Long live [invoker.get_unmasked_name()], [new_ruler_title] of [SSticker.realm_name]!"

/datum/usurpation_rite/progressive_dominion/get_victory_announcement(old_ruler_name)
	return "To cling to the past is to rot in place. Progress waits for no one.\n\n" + \
		"A Council of the Enlightened, under the gaze of Zizo, Mistress of Progress, " + \
		"declares [invoker.get_unmasked_name()] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a PROGRESSIVE rule of arcane enlightenment.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found wanting in vision, " + \
		"and their claim to rulership crumbles before the march of progress.\n\n" + \
		"Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name]!"

/// Returns TRUE if the mob is a mage (any arcyne training), a Zizite follower, or undead.
/datum/usurpation_rite/progressive_dominion/proc/is_qualified_voice(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_ARCYNE))
		return TRUE
	if(istype(user.patron, /datum/patron/inhumen/zizo))
		return TRUE
	if(is_undead(user))
		return TRUE
	return FALSE
