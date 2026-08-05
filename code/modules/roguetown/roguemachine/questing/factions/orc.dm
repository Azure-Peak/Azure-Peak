/datum/quest_faction/orc
	id = QUEST_FACTION_ORC
	name_singular = "orc"
	name_plural = "orcs"
	group_word = "warband"
	faction_tag = FACTION_ORCS
	can_blockade = TRUE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/orc/npc/footsoldier = 30,
		/mob/living/carbon/human/species/orc/npc/archer = 31, // ~30% of the orc humanoid line
		/mob/living/carbon/human/species/orc/npc/berserker = 22,
		/mob/living/carbon/human/species/orc/npc/marauder = 18,
		/mob/living/carbon/human/species/orc/npc/warlord = 6,
		/mob/living/carbon/human/species/orc/npc/juggernaut = 6, 
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/orc/npc/warlord = 100,
	)
	boss_title_templates = list(
		"Warlord %N",
		"%N Skullcleaver",
		"%N the Mighty",
		"%N the Pillager",
		"Chieftain %N",
	)
	boss_name_file = "strings/rt/names/other/halforcm.txt"
