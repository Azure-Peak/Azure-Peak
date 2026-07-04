/datum/ambush_config/triple_deepone
	mob_types = list(
		/mob/living/simple_animal/hostile/rogue/deepone = 3
	)
	threat_point = 3 * THREAT_HIGH
	faction_tag = "deepones"

/datum/ambush_config/deepone_party
	mob_types = list(
		/mob/living/simple_animal/hostile/rogue/deepone = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 1,
		/mob/living/simple_animal/hostile/rogue/deepone/wiz = 1
	)
	threat_point = THREAT_HIGH + 2 * THREAT_TOUGH
	faction_tag = "deepones"

