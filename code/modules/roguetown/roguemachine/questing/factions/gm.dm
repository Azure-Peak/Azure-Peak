/datum/quest_faction/gm
	id = QUEST_FACTION_GM
	name_singular = "dire threat"
	name_plural = "dire threats"
	group_word = "horde"
	faction_tag = "unknown"
	category = FACTION_CAT_HUMANOID
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
	)

/datum/quest_faction/gm/New(custom_group_word, custom_name_plural)
	. = ..()
	if(custom_group_word)
		group_word = custom_group_word
	if(custom_name_plural)
		name_plural = custom_name_plural
