/datum/quest_faction/drow
	id = QUEST_FACTION_DROW
	name_singular = "drow raider"
	name_plural = "drow raiders"
	group_word = "patrol"
	faction_tag = FACTION_DROW
	can_blockade = TRUE
	category = FACTION_CAT_DROW
	mob_types = list(
		/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 70,
		/mob/living/simple_animal/hostile/retaliate/rogue/drider = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 5,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/elf/dark/drowraider/sword_test = 60,
		/mob/living/carbon/human/species/elf/dark/drowraider/spear_test = 40,
	)
	boss_title_templates = list(
		"%N the Venomed",
		"%N of the Shadow",
		"Matron %N",
		"%N the Spiderkin",
	)
	boss_name_file = "strings/rt/names/elf/elfdm.txt"
