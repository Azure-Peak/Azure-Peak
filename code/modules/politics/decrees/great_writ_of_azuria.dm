/datum/decree/great_writ
	id = DECREE_GREAT_WRIT
	name = "The Great Writ of Azuria"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "Nobles pay no direct taxes nor fines."
	flavor_text = {"This Great Writ of Azuria, pronounced under Astrata's Sun and with Ravox as witness, declareth that from this dae henceforth the Grand Duke of Azuria shall be elected by the Peers of the Realm upon the death of the Grand Duke, to end the woeful anarchy and war that hath grasped this realm and thrown it into discord. And that all nobles of this land shall support the rightful rule of the Grand Duke of Azuria, Lord of Lords of the Azurian, who from this point forth shall receive the assent of the Peers and of the Holy Church.

And the Grand Duke, in their magnanimity, shall exempt those who bleed their blue blood for the Realm: the nobility of this land, and the blue blood of foreign realms sojourning within it, being of lineage blessed by Astrata's grace, shall bear no tax nor levy upon their persons or estates, excepting where they bear arms for hire and not in duty, whereupon they shall pay shield-monee.

In return, the nobles of Azuria shall undertake the duty of arms - to defend the Realm in their own person and with their retainers, to answer the Crown's call to war in whatsoever hour it cometh, and to render unto the throne the fealty that is owed by blood and by oath.

Yeven under the seal of the Crown, in witness of the Ten."}
	revoke_text = "The %RULER% has set aside the Great Writ. The laws of Astrata shall apply to the nobility of Azuria, who shall pay taxes and fines as anyone else."
	restore_text = "The %RULER% has renewed the Great Writ. The privileges of the nobles have been restored, and they shall no longer be subject to unjust taxes or fines."

/datum/decree/great_writ/roll_initial_year()
	return 1315

/datum/decree/great_writ/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(tax_category == TAX_CATEGORY_CONTRACT_LEVY)
		return FALSE
	if(tax_category == TAX_CATEGORY_POLL_LEVY && SStreasury.get_poll_levy_category(payer) != POLL_LEVY_CAT_NOBLE)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_NOBLE))
		return TRUE
	return FALSE
