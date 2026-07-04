/datum/ambush_config/pair_of_direbear
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 2
	)
	threat_point = 2 * THREAT_DANGEROUS
	faction_tag = "wildlife"

/datum/ambush_config/trio_of_highwaymen
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 3
	)
	threat_point = 3 * THREAT_MODERATE
	faction_tag = "bandits"

/datum/ambush_config/singular_minotaur
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 1
	)
	threat_point = THREAT_DANGEROUS
	faction_tag = "wildlife"

/datum/ambush_config/duo_minotaur
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 2
	)
	threat_point = 2 * THREAT_DANGEROUS
	faction_tag = "wildlife"

/datum/ambush_config/medium_skeleton_party
	mob_types = list(
		/mob/living/carbon/human/species/skeleton/npc/medium = 3
	)
	threat_point = 3 * THREAT_LOW
	faction_tag = "undead"

/datum/ambush_config/heavy_skeleton_party
	mob_types = list(
		/mob/living/carbon/human/species/skeleton/npc/medium = 1,
		/mob/living/carbon/human/species/skeleton/npc/hard = 2
	)
	threat_point = THREAT_LOW + 2 * THREAT_TOUGH
	faction_tag = "undead"
