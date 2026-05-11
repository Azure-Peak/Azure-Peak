/datum/ambush_config/bog_guard_deserters
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 2,
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 1
	)
	threat_point = 3 * THREAT_DANGEROUS
	faction_tag = "bandits"

/datum/ambush_config/bog_guard_deserters/hard
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 2,
		/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 1,
	)
	threat_point = 3 * THREAT_DANGEROUS
	faction_tag = "bandits"
