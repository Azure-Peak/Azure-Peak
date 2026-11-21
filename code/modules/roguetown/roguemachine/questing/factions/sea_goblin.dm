/datum/quest_faction/sea_goblin
	id = QUEST_FACTION_SEA_GOBLIN
	name_singular = "sea goblin"
	name_plural = "sea goblins"
	group_word = "warband"
	faction_tag = FACTION_ORCS
	can_blockade = FALSE
	category = FACTION_CAT_GOBLINOID
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 70,
		/mob/living/carbon/human/species/goblin/npc/archer/sea = 15, // ~30% ranged/special mix
		/mob/living/carbon/human/species/goblin/npc/slinger/sea = 7,
		/mob/living/carbon/human/species/goblin/npc/bomber/sea = 8,
		/mob/living/carbon/human/species/goblin/npc/large/sea = 5,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 15,
		/mob/living/carbon/human/species/goblin/npc/magos/sea = 4,
		/mob/living/carbon/human/species/goblin/npc/brickomancer/sea = 3,
		/mob/living/carbon/human/species/goblin/npc/knifomancer/sea = 3,
	)
	variant_chances = list(
		/datum/quest_faction_variant/goblin_magi/sea = 10,
	)
