/datum/quest_faction/forest_goblin
	id = QUEST_FACTION_FOREST_GOBLIN
	name_singular = "feral goblin"
	name_plural = "feral goblins"
	group_word = "band"
	faction_tag = FACTION_ORCS
	can_blockade = TRUE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush = 90,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 5,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/large = 100,
	)
	boss_title_templates = list(
		"Chief %N",
		"Grug-%N",
		"%N-Biter",
		"Big %N",
	)
	boss_name_file = "strings/rt/names/other/goblinm.txt"
