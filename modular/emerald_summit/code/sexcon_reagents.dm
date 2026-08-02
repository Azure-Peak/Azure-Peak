// Emerald Summit port — emberwine reagent (simplified)
// ES version hooked into the sexcon/addiction/mood systems, which Valmorian does not have.

/datum/reagent/erpjuice
	name = "Fluid"
	color = "#ffffe0"

/datum/reagent/erpjuice/cum
	name = "Cum"
	color = "#ffffe0"
	var/nutriment_factor = 8
	var/hydration = 6

/datum/reagent/erpjuice/femcum
	name = "Female Cum"
	color = "#ffffe0"
	var/nutriment_factor = 6
	var/hydration = 8

/datum/reagent/consumable/ethanol/beer/emberwine
	name = "Emberwine"
	boozepwr = 80
	taste_description = "searing sweetness"
	taste_mult = 0.5
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.02 * REAGENTS_METABOLISM
	overdose_threshold = 18
	color = "#721a46"
