/datum/quest_faction/moon_goblin
	id = QUEST_FACTION_MOON_GOBLIN
	name_singular = "moon goblin"
	name_plural = "moon goblins"
	group_word = "warband"
	faction_tag = FACTION_ORCS
	can_blockade = TRUE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 80,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 10,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/large/moon = 100,
	)
	boss_title_templates = list(
		"Moonchief %N",
		"%N-Under-the-Dark",
		"%N the Pale",
		"%N of the Vaults",
	)
	boss_name_file = "strings/rt/names/other/goblinm.txt"
