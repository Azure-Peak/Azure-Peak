/datum/quest_faction/bleakisle_reaver
	id = QUEST_FACTION_BLEAKISLE_REAVER
	name_singular = "Bleakisle reaver"
	name_plural = "Bleakisle reavers"
	group_word = "warband"
	faction_tag = FACTION_GRONNMEN
	can_blockade = TRUE
	category = FACTION_CAT_GRONN
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 60,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
		/mob/living/carbon/human/species/human/northern/militia/deserter = 10,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/outlaw_tank = 100,
	)
	boss_title_templates = list(
		"%N Saltbone",
		"%N the Wavesworn",
		"Captain %N",
		"%N of the Grey Isles",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
