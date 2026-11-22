/**
 * Rite of Golden Accord
 *
 * Republic-coded usurpation rite. Subtly Matthios coded.
 *
 * Design intent: Makes the merchant class a political threat. Makes steward an insider threat, and gives the Merchant in particular a path to the throne. Guildmaster and Bathmatron can also invoke it. No god is invoked - originally I intended for Matthios to be invoked but that would immediately make them valid in the eyes of everyone. So instead, any reference or accusation of heresy is tangential and this is framed as a purely secular assertion of commercial power.
 *
 * The assenter needs 200 mammons in their bank account at the time of invocation / assent. (Not the invoker, that was too inconvenient from my own testing). Steward should have the easiest time by just assigning paper money to would be plotter - and merchant can hand out money. This means a Steward could in theory, stop such a plot easily through fining.
 *
 * Not accessible to outlaws and undead.
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
	required_assents = GOLDEN_REQUIRED_ASSENTS
	invoke_bars = RITE_BAR_OUTLAW | RITE_BAR_UNDEAD
	assent_bars = RITE_BAR_OUTLAW | RITE_BAR_UNDEAD
	outlaw_rejection = "Outlaws have no standing in matters of commerce."
	undead_rejection = "The dead hold no contracts."
	assenter_group = "burghers"
	council_name = "the Council of Burghers"
	claim_basis = "by weight of coin"

/// Steward, Merchant, Guildmaster, or Bathmaster with 200+ mammon. No outlaws or undead.
/datum/usurpation_rite/golden_accord/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!(user.job in list("Steward", "Merchant", "Guildmaster", "Bathmaster")))
		return FALSE
	return TRUE

/datum/usurpation_rite/golden_accord/can_assent(mob/living/carbon/human/burgher)
	if(get_total_wealth(burgher) < GOLDEN_REQUIRED_WEALTH)
		to_chat(burgher, span_warning("You need at least [GOLDEN_REQUIRED_WEALTH] mammons to your name to speak assent, pauper."))
		return FALSE
	return ..()

/datum/usurpation_rite/golden_accord/get_contest_announcement()
	return "The people of [SSticker.realm_name] have spoken — a merchant republic shall be established, and [invoker.get_unmasked_name()] elected its first [new_ruler_title]!\n\n" + \
		"A Council of Burghers has affirmed this claim.\n\n" + \
		"The Accord shall be sealed in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down."

/datum/usurpation_rite/golden_accord/get_victory_announcement(old_ruler_name)
	return "Power belongs to those who bring prosperity to the realm.\n\n" + \
		"The Council of Burghers declares [invoker.get_unmasked_name()] the rightful [SSticker.rulertype] of [SSticker.realm_name], establishing a PROSPEROUS republic of free commerce.\n\n" + \
		"[old_ruler_name], unable to contest this succession, has been found wanting in stewardship, " + \
		"and their authority is hereby rendered insolvent.\n\n" + \
		"Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name]!"

/// Returns the total mammon value on the mob's person plus their bank account.
/datum/usurpation_rite/golden_accord/proc/get_total_wealth(mob/living/carbon/human/user)
	var/total = 0
	// Count coins on person
	for(var/obj/item/roguecoin/coin in user.GetAllContents())
		total += coin.get_real_price()
	// Count bank account
	total += SStreasury.get_balance(user)
	return total
