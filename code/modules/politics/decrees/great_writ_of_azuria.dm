/datum/decree/great_writ
	id = DECREE_GREAT_WRIT
	name = "The Great Writ of Azuria"
	flavor_text = {"Under Astrata's Sun, with Ravox as witness, be it known that the nobility of this land, and the blue blood of foreign lands, being blessed by Astrata in their divine lineage, shall bear no tax nor levy.

In return, the nobles of Azuria undertake the duty of arms - to defend the Realm in person and with their retainers, to answer the Crown's call to war, and to render the fealty owed by blood to the throne."}
	revoke_text = "The %RULER% has set aside the Great Writ. The nobility of Azuria shall contribute to the Crown, in both blood and gold."
	restore_text = "The %RULER% has renewed the Great Writ. The blue blood of Azuria shall not have their divinely-sanctioned wealth seized anymore."

/datum/decree/great_writ/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(100, 200)

/datum/decree/great_writ/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_NOBLE))
		return TRUE
	return FALSE
