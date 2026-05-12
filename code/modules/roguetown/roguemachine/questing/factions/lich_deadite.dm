/datum/quest_faction/lich_deadite
	id = QUEST_FACTION_LICH_DEADITE
	name_singular = "lich-bound deadite"
	name_plural = "lich-bound deadites"
	group_word = "horde"
	faction_tag = FACTION_LICH
	can_blockade = TRUE
	category = FACTION_CAT_UNDEAD
	mob_types = list(
		/mob/living/carbon/human/species/skeleton/npc/mediumspread = 50,
		/mob/living/carbon/human/species/skeleton/npc/hardspread = 50,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/skeleton/npc/dungeon/lich = 100,
	)
	boss_title_templates = list(
		"%N the Unsleeping",
		"%N the Bound",
		"Sir %N",
		"%N the Forsworn",
	)
	boss_name_file = "strings/rt/names/other/deaditenpcfirst.txt"
