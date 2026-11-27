/datum/decree/otavan_accords
	id = DECREE_OTAVAN_ACCORDS
	name = "The Otavan Accords"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "Inquisition members pay no taxes."
	flavor_text = {"...Furthermore, by this treaty set forth in Vaucourt, let it be known from this dae forth that no more blood shall be shed between Otava and Azuria, and that peace shall come to the lands upon the Arwin. Azuria shall renounce all her claims west of the River Arwin, and Otava hers to the east, such that the river shall divide the two realms and the toll of Vaucourt be shared between them, that peace may be had for ten thousand yils.

In support of this everlasting friendship, Otava shall send the Holy Otavan Inquisition, sworn servants of Psydon, housed at Otava's expense, to keep vigil against heresy upon this land. The Inquisition may try foreigners, those outlawed by the Duchy for high heresy, and those handed over by Crown and Court, and may aid the lawful authorities in trials of citizenry, save for the Nobility, who answer to the Crown alone.

In exchange, as foreign adherents sanctioned by treaty, the Inquisition shall bear no tax nor levy upon their persons nor the instruments of their office, nor shall the Crown hinder their holy duty, save by lawful cause shown before the Bishop or Council.

Yeven under the seal of the Crown, in witness of Psydon and the Ten."}
	revoke_text = "The %RULER% has broken the Otavan Accords. The Inquisition is stripped of its treaty protections - and Otava shall not take such an insult lightly."
	restore_text = "The %RULER% has affirmed the Otavan Accords. The Holy Otavan Inquisition resumes its duty to purge the land of heretics, free from the Crown's interference."

/datum/decree/otavan_accords/roll_initial_year()
	return 1492 // Canonical year

/datum/decree/otavan_accords/apply_exemption(mob/living/payer, tax_category)
	if(!active)
		return FALSE
	if(payer.job in GLOB.inquisition_positions)
		return TRUE
	return FALSE
