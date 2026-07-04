/datum/round_event_control/hostile_animal_migration
	name = "Hostile Animal Migration"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/animal_migration/hostile
	weight = 5
	max_occurrences = 0	//Broken runtimes, can't figure out the fix. Fuck it.
	min_players = 0
	earliest_start = 7 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_CURSE,
		TAG_COMBAT,
	)

/datum/round_event/animal_migration/hostile
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf,
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole,
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat,
		/mob/living/simple_animal/hostile/retaliate/rogue/fox,
	)
