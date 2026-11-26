/datum/quest_faction/forest_goblin
	id = QUEST_FACTION_FOREST_GOBLIN
	name_singular = "feral goblin"
	name_plural = "feral goblins"
	group_word = "band"
	faction_tag = FACTION_ORCS
	can_blockade = FALSE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush = 63,
		/mob/living/carbon/human/species/goblin/npc/archer = 16, // archer+slinger+bomber ~30% of goblins
		/mob/living/carbon/human/species/goblin/npc/slinger = 6,
		/mob/living/carbon/human/species/goblin/npc/bomber = 7,
		/mob/living/carbon/human/species/goblin/npc/large = 5,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 15,
		/mob/living/carbon/human/species/goblin/npc/magos = 4,
		/mob/living/carbon/human/species/goblin/npc/brickomancer = 3,
		/mob/living/carbon/human/species/goblin/npc/knifomancer = 3,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/large = 100,
	)
	variant_chances = list(
		/datum/quest_faction_variant/goblin_magi = 10,
	)
	boss_name_file = "strings/rt/names/other/goblinm.txt"
