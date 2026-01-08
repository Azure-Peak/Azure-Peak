/mob/living/carbon/human/proc/is_noble()
	var/noble = FALSE
	if (job in GLOB.noble_positions)
		noble = TRUE
	if (HAS_TRAIT(src, TRAIT_NOBLE))
		noble = TRUE
	if(HAS_TRAIT(src, TRAIT_DEFILED_NOBLE))
		noble = FALSE

	return noble

/mob/living/carbon/human/proc/is_yeoman()
	return job in GLOB.burgher_positions

/mob/living/carbon/human/proc/is_courtier()
	return job in GLOB.courtier_positions
