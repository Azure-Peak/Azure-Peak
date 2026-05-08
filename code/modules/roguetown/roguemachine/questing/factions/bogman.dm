/datum/quest_faction/bogman
	id = QUEST_FACTION_BOGMAN
	name_singular = "bogman"
	name_plural = "bogmen"
	group_word = "warband"
	faction_tag = FACTION_BANDITS
	can_blockade = TRUE
	category = FACTION_CAT_BOG_DESERTER
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 80,
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/outlaw_tank = 100,
	)
	boss_title_templates = list(
		"Sergeant %N",
		"Captain %N",
		"%N the Bogman",
		"%N the Marshwalker",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
