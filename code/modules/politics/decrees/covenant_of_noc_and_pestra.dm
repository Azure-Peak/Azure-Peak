/datum/decree/noc_pestra_covenant
	id = DECREE_NOC_PESTRA_COVENANT
	name = "The Covenant of Noc & Pestra"
	/// Jobs covered by the scholarly half of the covenant (Noc's mantle).
	var/static/list/university_jobs = list(
		"Court Magician",
		"Archivist",
		"Magicians Associate",
	)
	/// Jobs covered by the healing half of the covenant (Pestra's mantle).
	var/static/list/apothecary_jobs = list(
		"Apothecary",
		"Head Physician",
	)
	flavor_text = {"Under the watchful eye of Noc and the merciful hand of Pestra, be it known that the scholars of the University and the healers of the Apothecary shall bear no greater levy than the lightest measure.

In exchange, the chartered scholars of the University shall keep the lore and knowledge of the Realm, preserve it, and teach it to those worthy and of bright minds, for Noc granted humen the gift of magick and wisdom so we may pass it on. And the chartered healers of the Apothecary, agents of Pestra, shall tend the hurt of every subject who comes to their door, be they beggar or burgher, and shall never refuse the wounded for want of coin, for Pestra is merciful and taught us medicine so that we may care for each other."}
	revoke_text = "The %RULER% has suspended the Covenant of Noc & Pestra. The scholars and healers of Azuria now bear the Crown's common levy in full."
	restore_text = "The %RULER% has affirmed the Covenant of Noc & Pestra. The scholars and healers of Azuria resume their sheltered station."

/datum/decree/noc_pestra_covenant/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(20, 60)

/// Returns TRUE if the payer is a member of one of the two chartered rosters.
/datum/decree/noc_pestra_covenant/proc/is_protected(mob/living/payer)
	if(!active || !payer)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	if(payer.job in university_jobs)
		return TRUE
	if(payer.job in apothecary_jobs)
		return TRUE
	return FALSE

/// Cap poll tax at NOC_PESTRA_POLL_CAP for covered jobs. Applied after the base category rate and
/// any other decree adjustments (so this stacks as the tighter of whatever came before).
/datum/decree/noc_pestra_covenant/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(!is_protected(payer))
		return current_rate
	return min(current_rate, NOC_PESTRA_POLL_CAP)
