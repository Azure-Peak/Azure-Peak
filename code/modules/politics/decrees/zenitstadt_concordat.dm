/datum/decree/zenitstadt_concordat
	id = DECREE_ZENITSTADT_CONCORDAT
	name = "The Zenitstadt Concordat"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "Church clergy and declared Benefactors of the Faith pay no taxes."
	flavor_text = {"This Zenitstadt Concordat, sworne under the Ten's Grace and with Ravox as witness, witnesseth that the Church of Azuria, consecrated beneath the Ten and quickened by Astrata's light, shall keep the peace of the gods upon this land: to pray for the safety and prosperity of the Realm by daye and by night, to maintain the favor of the Ten through proper sacrament and offering, to levy tithe from amongst its own brethren, to shelter the poor and downtrodden, and to furnish its own knightly order of templars that the common defense of the Realm be not wanting.

In exchange, as the sacred envoys of the gods and sworn servants of the Ten, the clergy of the Church of Azuria shall bear no tax nor levy, neither upon their persons nor upon the properties of the Faith; nor shall the Crown intrude upon the internal discipline of the Church, save by lawful counsel taken with the Church of the Ten.

Yeven under the seal of the Crown, in witness of the Ten."}
	revoke_text = "The %RULER% has rescinded the Zenitstadt Concordat. The Church's wealth shall serve the greater good of the Realm - let the Ten judge who betrayed whom."
	restore_text = "The %RULER% has affirmed the Zenitstadt Concordat. The hand of the Crown shall meddle no more in the disposition of the Church's worldly wealth."

/datum/decree/zenitstadt_concordat/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(50, 120)

/datum/decree/zenitstadt_concordat/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(payer.job in GLOB.church_positions)
		return TRUE
	if(HAS_TRAIT(payer, TRAIT_DECLARED_BENEFACTOR))
		return TRUE
	return FALSE
