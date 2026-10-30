/datum/decree/great_writ
	id = DECREE_GREAT_WRIT
	name = "The Great Writ of Azuria"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "Nobles pay no direct taxes nor fines."
	flavor_text = {"This Great Writ of Azuria, pronounced under Astrata's Sun and with Ravox as witness, declareth that the nobility of this land, and the blue blood of foreign realms sojourning within it, being of lineage blessed by Astrata's grace, shall bear no tax nor levy upon their persons or estates, excepting where they bear arms for hire and not in duty, whereupon they shall pay shield-monee.

In return, the nobles of Azuria shall undertake the duty of arms - to defend the Realm in their own person and with their retainers, to answer the Crown's call to war in whatsoever hour it cometh, and to render unto the throne the fealty that is owed by blood and by oath.

Yeven under the seal of the Crown, in witness of the Ten."}
	revoke_text = "The %RULER% has set aside the Great Writ. The laws of Astrata shall apply to the nobility of Azuria, who shall pay taxes and fines as anyone else."
	restore_text = "The %RULER% has renewed the Great Writ. The privileges of the nobles have been restored, and they shall no longer be subject to unjust taxes or fines."

/datum/decree/great_writ/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(100, 200)

/datum/decree/great_writ/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(tax_category == TAX_CATEGORY_CONTRACT_LEVY)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_NOBLE))
		return TRUE
	return FALSE
