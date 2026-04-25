/datum/decree/guild_charter_of_arms
	id = DECREE_GUILD_CHARTER_OF_ARMS
	name = "The Guild Charter of Arms"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "Mercenaries get a capped poll tax at 15m; Guild remits a daily tribute to the Burgher Pledge."
	flavor_text = {"This Guild Charter of Arms, drawn under Ravox's banner and entered unto between the Crown of Azuria and the Guild of Arms, witnesseth that the Crown recognizeth the Guild as a chartered foreign body, self-governing in its own affairs and answerable only to its own captains. Its sworn mercenaries shall bear no common levy save the lightest head-count upon them.

The Crown commandeth no oath of service from the Guild, and oweth it no service in return. The Crown shall not intervene in the contracts the Guild undertaketh, and shall protect its adherents' right to bear arms and to intervene in private warfare as they see fit, so long as the peace of the Realm be not disturbed thereby, and so long as they undertake no contracts of piracy, brigandry, nor such as directly threaten the Crown's interests.

In recognition of this standing, the Guild's treasury, collected from amongst its members as a fee, shall remit a daily tribute unto the Burgher Pledge as a gesture of good will and contribution toward the common wealth of the Realm, as bearers of arms and agents of Ravox for the dispensation of justice therein. And should an outlaw be found wearing the Guild's colours, the Guild answereth for none of it, and the Crown's justice against that individual proceedeth unimpeded.

Yeven under the seal of the Crown and the mark of the Guild."}
	revoke_text = "The %RULER% has suspended the Guild Charter of Arms. The mercenaries of Azuria now bear the Crown's common levy in full - and the Guild's tribute to the Pledge ceases until the compact is renewed."
	restore_text = "The %RULER% has affirmed the Guild Charter of Arms. The Guild's recognition is restored, and its tribute to the Pledge resumes."

/datum/decree/guild_charter_of_arms/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(30, 80)

/// Returns TRUE if the payer is a chartered mercenary under this charter.
/datum/decree/guild_charter_of_arms/proc/is_protected(mob/living/payer)
	if(!active || !payer)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	return payer.job == "Mercenary"

/datum/decree/guild_charter_of_arms/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(poll_category != POLL_TAX_CAT_MERCENARY)
		return current_rate
	if(!is_protected(payer))
		return current_rate
	return min(current_rate, GUILD_CHARTER_OF_ARMS_POLL_CAP)
