/datum/quest_faction/orc
	id = QUEST_FACTION_ORC
	name_singular = "orc"
	name_plural = "orcs"
	group_word = "warband"
	faction_tag = FACTION_ORCS
	can_blockade = TRUE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/orc/npc/footsoldier = 40,
		/mob/living/carbon/human/species/orc/npc/berserker = 22,
		/mob/living/carbon/human/species/orc/npc/marauder = 18,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 7,
		/mob/living/carbon/human/species/orc/npc/warlord = 3,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/orc/npc/warlord = 100,
	)
	boss_title_templates = list(
		"Warlord %N",
		"%N Skullcleaver",
		"%N the Mighty",
		"Chieftain %N",
	)
	boss_name_file = "strings/rt/names/other/halforcm.txt"
