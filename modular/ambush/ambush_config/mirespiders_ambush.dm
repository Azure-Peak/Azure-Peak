/datum/ambush_config
	var/list/mob_types = list()
	var/threat_point = 0 // Threat Point cost for the budget system
	var/faction_tag = "" // Faction identifier for same/wrong-faction ambush logic

/datum/ambush_config/mirespiders_ambush
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = 2,
		/mob/living/simple_animal/hostile/rogue/mirespider_lurker = 1
	)
	threat_point = 2 * THREAT_TRASH + THREAT_ELITE
	faction_tag = "mirespiders"

/datum/ambush_config/mirespiders_crawlers
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = 4,
	)
	threat_point = 4 * THREAT_TRASH
	faction_tag = "mirespiders"

/datum/ambush_config/mirespiders_aragn
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = 2,
		/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = 1
	)
	threat_point = 2 * THREAT_TRASH + THREAT_ELITE
	faction_tag = "mirespiders"

/datum/ambush_config/mirespiders_unfair
	mob_types = list(
		/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = 2,
		/mob/living/simple_animal/hostile/rogue/mirespider_lurker = 1
	)
	threat_point = 3 * THREAT_ELITE
	faction_tag = "mirespiders"
