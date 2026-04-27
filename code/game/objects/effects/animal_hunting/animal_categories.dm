/datum/hunting_category
	var/name = "Generic"
	/// List of animal type paths associated with their relative weights: list(/mob/path = 10)
	var/list/animals = list()
	/// Weight of this category being picked based on skill level (0 to 6)
	var/list/skill_weights = list(0, 0, 0, 0, 0, 0, 0)
	/// Preferred track icon_state for specific animals: list(/mob/path = "ursine")
	var/list/preferred_tracks = list()
	/// Areas where this category is likely to appear
	var/list/preferred_areas = list()
	/// Amount of bonus animals group hunts can spawn
	var/bonus_animal_amount = 1

/datum/hunting_category/low_tier
	name = "Small Game"
	skill_weights = list(100, 80, 50, 20, 10, 5, 5) // Common for beginners, rare for experts
	bonus_animal_amount = 8
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = 8,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 10
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = "canine",
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = "small"
	)
	preferred_areas = list(
		/area/rogue/outdoors/woods = 30,
		/area/rogue/outdoors/woods/north = 30,
		/area/rogue/outdoors/woods/northeast = 30,
		/area/rogue/outdoors/woods/southeast = 30,
		/area/rogue/outdoors/woods/south = 30,
		/area/rogue/outdoors/woods/southwest = 30,
		/area/rogue/outdoors/woods/northwest = 30,
		/area/rogue/outdoors/rtfield = 50
	)

/datum/hunting_category/mid_tier
	name = "Forest Denizens"
	skill_weights = list(10, 40, 100, 80, 50, 30, 10)
	bonus_animal_amount = 5
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/goat = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/goatmale = 15
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = "canine",
		/mob/living/simple_animal/hostile/retaliate/rogue/goat = "cervine"
	)
	preferred_areas = list(
		/area/rogue/outdoors/woods = 50,
		/area/rogue/outdoors/woods/north = 50,
		/area/rogue/outdoors/woods/northeast = 50,
		/area/rogue/outdoors/woods/southeast = 50,
		/area/rogue/outdoors/woods/south = 50,
		/area/rogue/outdoors/woods/southwest = 50,
		/area/rogue/outdoors/woods/northwest = 50
	)

/datum/hunting_category/high_tier
	name = "Great Beasts"
	skill_weights = list(0, 5, 20, 50, 100, 120, 150) // Only highly skilled hunters find these
	bonus_animal_amount = 8
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga/game = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 5,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll = 3,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 5,
		/mob/living/simple_animal/hostile/retaliate/rogue/boar = 5,
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear = "ursine",
		/mob/living/simple_animal/hostile/retaliate/rogue/troll = "ursine",
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = "ursine",
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga/game = "cervine",
		/mob/living/simple_animal/hostile/retaliate/rogue/boar = "suidae",
	)
	preferred_areas = list(
		/area/rogue/outdoors/woods = 20,
		/area/rogue/outdoors/woods/north = 20,
		/area/rogue/outdoors/woods/northeast = 20,
		/area/rogue/outdoors/woods/southeast = 20,
		/area/rogue/outdoors/woods/south = 20,
		/area/rogue/outdoors/woods/southwest = 20,
		/area/rogue/outdoors/woods/northwest = 20,
		/area/rogue/outdoors/mountains/decap = 50
	)

/datum/hunting_category/cursed
	name = "Undead Signs"
	skill_weights = list(50, 30, 20, 15, 15, 10, 10) // Low static chance
	bonus_animal_amount = 10
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,
		/mob/living/simple_animal/hostile/retaliate/smallrat = 1
	)
	preferred_areas = list(
		/area/rogue/outdoors/beach/forest = 50,
		/area/rogue/outdoors/beach/forest/north = 50,
		/area/rogue/outdoors/beach/forest/south = 50
	)

/datum/hunting_category/spiders
	name = "Common Arachnids"
	skill_weights = list(30, 30, 30, 25, 20, 10, 5)
	bonus_animal_amount = 3
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/spider = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 10
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/spider = "small"
	)
	preferred_areas = list(
		/area/rogue/under/underdark = 40,
		/area/rogue/under/underdark/south = 40,
		/area/rogue/under/underdark/north = 40,
		/area/rogue/under/cavewet = 40
	)

/datum/hunting_category/mire_spiders
	name = "Mire Dwellers"

	skill_weights = list(30, 30, 30, 25, 25, 20, 20)
	bonus_animal_amount = 6
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = 30,
		/mob/living/simple_animal/hostile/rogue/mirespider_lurker = 20,
		/mob/living/simple_animal/hostile/rogue/mirespider_lurker/mushroom = 5,
		/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = 10
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = "small",
		/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = "small"
	)
	preferred_areas = list(
		/area/rogue/outdoors/bog = 60,
		/area/rogue/outdoors/bog/north = 60,
		/area/rogue/outdoors/bog/south = 60,
		/area/rogue/under/cavewet/bogcaves = 60,
		/area/rogue/under/cavewet/bogcaves/west = 60,
		/area/rogue/under/cavewet/bogcaves/central = 60,
		/area/rogue/under/cavewet/bogcaves/south = 60,
		/area/rogue/under/cavewet/bogcaves/north = 60,
		/area/rogue/under/cavewet/bogcaves/coastcaves = 60
	)

// HUNTING MAP PREFERRED CATEGORIES

/datum/hunting_category/white_stag
	// Named the same as to make it impossible to tell when a stag is there.
	name = "Great Beasts"
	// May become even rarer down the line.
	skill_weights = list(1, 1, 1, 1, 1, 1, 2) // Stumbling into this aimlessly is nigh-impossible
	bonus_animal_amount = 0 // Hahahhaa No.
	animals = list(
		/mob/living/carbon/human/species/wildshape/white_stag = 1
	)
	preferred_tracks = list(
		/mob/living/carbon/human/species/wildshape/white_stag = "cervine"
	)
	preferred_areas = list()

/datum/hunting_category/boars
	name = "Fierce Boars"
	skill_weights = list(1, 1, 1, 1, 1, 1, 1)
	bonus_animal_amount = 10
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/boar = 1
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/boar = "suidae"
	)
	preferred_areas = list()
