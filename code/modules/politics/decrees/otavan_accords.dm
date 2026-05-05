/datum/decree/otavan_accords
	id = DECREE_OTAVAN_ACCORDS
	name = "The Otavan Accords"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "Inquisition members pay no taxes."
	flavor_text = {"In the name of the Ten, under the Almighty Allfather's watch, be it known that the Holy Otavan Inquisition, sworn servants of Psydon and emissaries of the Orthodoxy, shall keep vigil against heresy upon this land: to defend and protect the Duchy of Azuria from those who would do it harm, and to counsel and advise the leaders and peoples of the nation. The Inquisition is hereby granted the right to try foreigners, those sanctioned and outlawed by the Duchy for crimes of high heresy, or those who are handed over by order of Crown and Court. The Holy Inquisition is to be granted permission to aid in trials of citizenry alongside the lawful authorities of the land, save for the Nobility, who must be tried before the Crown.

In exchange, as foreign adherents sanctioned by treaty, the Inquisition shall bear no tax nor levy, neither upon their persons nor upon the instruments of their office; nor shall the Crown hinder their holy duty, save by lawful cause shown before the Bishop or Council.

Yeven under the seal of the Crown, in witness of Psydon and the Ten."}
	revoke_text = "The %RULER% has broken the Otavan Accords. The Inquisition is stripped of its treaty protections - and Otava shall not take such an insult lightly."
	restore_text = "The %RULER% has affirmed the Otavan Accords. The Holy Otavan Inquisition resumes its duty to purge the land of heretics, free from the Crown's interference."

/datum/decree/otavan_accords/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(20, 60)

/datum/decree/otavan_accords/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(payer.job in GLOB.inquisition_positions)
		return TRUE
	return FALSE
