/datum/quest_faction/wild_beast
	id = QUEST_FACTION_WILD_BEAST
	name_singular = "beast"
	name_plural = "beasts"
	group_word = "pack"
	faction_tag = FACTION_WOLFS
	category = FACTION_CAT_BEAST
	progress_noun = "beasts"
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 5,
	)
	crime_weights = list(
		CRIME_BEAST_SHEEP = 10,
		CRIME_BEAST_CATTLE = 6,
		CRIME_BEAST_TRAVELLER = 6,
		CRIME_BEAST_DOGS = 4,
		CRIME_BEAST_WINTER = 4,
		CRIME_BEAST_CORPSE = 3,
		CRIME_BEAST_CHILD = 2,
	)
