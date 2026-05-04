/datum/quest_faction/madman
	id = QUEST_FACTION_MADMAN
	name_singular = "madman"
	name_plural = "madmen"
	group_word = "madness"
	faction_tag = FACTION_MADMEN
	can_blockade = TRUE
	category = FACTION_CAT_HUMANOID
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 100,
	)
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_RAID)
