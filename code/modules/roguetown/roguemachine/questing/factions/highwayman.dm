/datum/quest_faction/highwayman
	id = QUEST_FACTION_HIGHWAYMAN
	name_singular = "highwayman"
	name_plural = "highwaymen"
	group_word = "gang"
	faction_tag = FACTION_BANDITS
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 70,
		/mob/living/carbon/human/species/human/northern/militia/deserter = 30,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/outlaw_duelist = 50,
		/mob/living/carbon/human/species/human/northern/outlaw_ranger = 50,
	)
	boss_title_templates = list(
		"%N the Cutthroat",
		"%N the Quick",
		"%N the Wolf",
		"%N Bloodhand",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
