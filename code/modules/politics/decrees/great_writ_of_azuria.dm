/datum/decree/great_writ
	id = DECREE_GREAT_WRIT
	name = "The Great Writ of Azuria"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "Nobles pay no taxes nor fines."
	flavor_text = {"This Great Writ of Azuria, pronounced under Astrata's Sun and with Ravox as witness, declareth that the nobility of this land, and the blue blood of foreign realms sojourning within it, being of lineage blessed by Astrata's grace, shall bear no tax nor levy upon their persons or estates.

In return, the nobles of Azuria shall undertake the duty of arms - to defend the Realm in their own person and with their retainers, to answer the Crown's call to war in whatsoever hour it cometh, and to render unto the throne the fealty that is owed by blood and by oath.

Yeven under the seal of the Crown, in witness of the Ten."}
	revoke_text = "The %RULER% has set aside the Great Writ. The nobility of Azuria shall contribute to the Crown, in both blood and gold - let no lineage be too blessed to pay."
	restore_text = "The %RULER% has renewed the Great Writ. The blue blood of Azuria is freed again from the levy, that the nobility may serve the Realm in arms, not in coin."

/datum/decree/great_writ/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(100, 200)

/datum/decree/great_writ/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_NOBLE))
		return TRUE
	return FALSE
