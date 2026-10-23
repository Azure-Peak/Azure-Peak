/datum/quest_faction/wild_beast
	id = QUEST_FACTION_WILD_BEAST
	name_singular = "beast"
	name_plural = "beasts"
	group_word = "pack"
	faction_tag = FACTION_WOLFS
	category = FACTION_CAT_BEAST
	progress_noun = "beasts"
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 75,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/dire = 25, //only volfs+direvolfs instead of all fauna mobs
	)
	crime_weights = list(
		/datum/quest_crime/beast_sheep = 10,
		/datum/quest_crime/beast_cattle = 6,
		/datum/quest_crime/beast_traveller = 6,
		/datum/quest_crime/beast_dogs = 4,
		/datum/quest_crime/beast_winter = 4,
		/datum/quest_crime/beast_corpse = 3,
		/datum/quest_crime/beast_child = 2,
	)
