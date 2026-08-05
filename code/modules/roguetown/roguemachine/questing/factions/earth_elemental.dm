/datum/quest_faction/earth_elemental
	id = QUEST_FACTION_EARTH_ELEMENTAL
	name_singular = "earth elemental"
	name_plural = "earth elementals"
	group_word = "host"
	progress_noun = "elementals"
	faction_tag = "earth_elemental"
	can_blockade = FALSE
	category = FACTION_CAT_ELEMENTAL
	allowed_quest_types = list(QUEST_TOWNER_MINER_OREVEIN)
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler = 60,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden = 35,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth = 5,
	)
