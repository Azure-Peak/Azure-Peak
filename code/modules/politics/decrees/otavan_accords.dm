/datum/decree/otavan_accords
	id = DECREE_OTAVAN_ACCORDS
	name = "The Otavan Accords"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "Inquisition members pay no taxes."
	flavor_text = {"These Otavan Accords, sworne in the name of the Ten and under the Almighty Allfather's watch, witnesseth that the Holy Otavan Inquisition, sworn servants of Psydon and emissaries of the Orthodoxy, shall keep vigil against heresy upon this land: to hunt the Archenemy's servants and the false gods, to stay their hand from subjects of Azuria untainted by heresy, to try only the common folk, and to never try a burgher nor a nobleman - for whose crimes they shall answer before the Church of the Ten.

In exchange, as foreign adherents sanctioned by treaty, the Inquisition shall bear no tax nor levy, neither upon their persons nor upon the instruments of their office; nor shall the Crown hinder their holy duty, save by lawful cause shown before the Church of the Ten.

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
