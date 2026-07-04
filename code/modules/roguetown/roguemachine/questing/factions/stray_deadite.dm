/datum/quest_faction/stray_deadite
	id = QUEST_FACTION_STRAY_DEADITE
	name_singular = "stray deadite"
	name_plural = "stray deadites"
	group_word = "horde"
	faction_tag = FACTION_SKELETON
	can_blockade = TRUE
	category = FACTION_CAT_UNDEAD
	mob_types = list(
		/mob/living/carbon/human/species/skeleton/npc/supereasy = 35,
		/mob/living/carbon/human/species/skeleton/npc/easy = 35,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/archer = 20,
	)
