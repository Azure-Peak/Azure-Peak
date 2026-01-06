/area/rogue/under/underdark
	name = "Central Underdark" // Northern is Sunken City
	icon_state = "cavewet"
	warden_area = FALSE
	drow_area = TRUE
	first_time_text = "The Underdark" // This is where most people will enter Underdark
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
				/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 25,
				/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15,
				/mob/living/simple_animal/hostile/retaliate/rogue/drider = 10,
	)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "an acid-scarred depths"
	detail_text = DETAIL_TEXT_UNDERDARK

/area/rogue/under/underdark/south
	name = "Southern Underdark"
	first_time_text = "The Southern Underdark"
	detail_text = DETAIL_TEXT_SOUTHERN_UNDERDARK

/area/rogue/under/underdark/north
	name = "Melted Undercity"
	first_time_text = "MELTED UNDERCITY"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	detail_text = DETAIL_TEXT_MELTED_UNDERCITY
