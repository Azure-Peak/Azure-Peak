/datum/decree/noc_pestra_covenant
	id = DECREE_NOC_PESTRA_COVENANT
	name = "The Covenant of Noc & Pestra"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "Caps poll tax for university and apothecary staff, and floors their wages: Court Magician 40m, Archivist 20m, Magicians Associate 10m, Head Physician 80m, Apothecary 40m."
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
	var/static/list/wage_floors = list(
		"Court Magician" = 40,
		"Archivist" = 20,
		"Magicians Associate" = 10,
		"Head Physician" = 80,
		"Apothecary" = 40,
	)
	flavor_text = {"This Covenant of Noc & Pestra, sworne under the watchful eye of Noc and the merciful hand of Pestra, witnesseth that the scholars of the University and the healers of the Apothecary shall bear no greater levy than the lightest measure upon their heads, and shall be paid from the Crown's purse an honest minimum of their due whilst this Covenant standeth.

In exchange, the chartered scholars of the University shall keep the lore and knowledge of the Realm, preserve it, and teach it unto those worthy and of bright minds, for Noc granted humen the gift of magick and wisdom that we may pass it on. And the chartered healers of the Apothecary, agents of Pestra, shall tend the hurt of every subject who cometh to their door, be they beggar or burgher, and shall never refuse the wounded for want of coin, for Pestra is merciful and taught us medicine that we may care for one another.

Yeven under the seal of the Crown, in witness of Noc and Pestra."}
	revoke_text = "The %RULER% has suspended the Covenant of Noc & Pestra. The scholars and healers of Azuria now bear the Crown's common levy in full - and Noc and Pestra may reckon how long their mercy lasts without their chartered hands."
	restore_text = "The %RULER% has affirmed the Covenant of Noc & Pestra. The scholars and healers of Azuria resume their sheltered station, that the Realm may keep both its lore and its mercy."

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

/datum/decree/noc_pestra_covenant/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(!is_protected(payer))
		return current_rate
	return min(current_rate, NOC_PESTRA_POLL_CAP)

/datum/decree/noc_pestra_covenant/apply_wage_floor(job_title, current_floor)
	var/mandated = wage_floors[job_title] || 0
	return max(current_floor, mandated)

/datum/decree/noc_pestra_covenant/wage_floored_jobs()
	return wage_floors

/datum/decree/noc_pestra_covenant/on_restore()
	. = ..()
	SStreasury.steward_machine?.enforce_wage_floors()
