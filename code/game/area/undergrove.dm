/area/rogue/under/cavewet
	name = "The Undergrove"
	icon_state = "cavewet"
	warden_area = TRUE
	first_time_text = "The Undergrove"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/sea = 20,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "root-bound caverns"
	detail_text = DETAIL_TEXT_UNDERGROVE

/area/rogue/under/cavewet/bogcaves
	name = "The Undergrove"
	first_time_text = "The Undergrove"

/area/rogue/under/cavewet/bogcaves/west
	name = "Western Undergrove"
	first_time_text = "Western Undergrove"

/area/rogue/under/cavewet/bogcaves/central
	name = "Central Undergrove"
	first_time_text = "Central Undergrove"

/area/rogue/under/cavewet/bogcaves/camp
	name = "Undergrove Camp"
	first_time_text = "Undergrove Camp"
	detail_text = DETAIL_TEXT_UNDERGROVE_CAMP

/area/rogue/under/cavewet/bogcaves/south
	name = "Southern Undergrove"
	first_time_text = "Southern Undergrove"

/area/rogue/under/cavewet/bogcaves/north
	name = "Northern Undergrove"
	first_time_text = "Northern Undergrove"

/area/rogue/under/cavewet/bogcaves/coastcaves
	name = "South Coast Caves"
	first_time_text = "South Coast Caves"

/area/rogue/under/cave/goblindungeon
	name = "Goblin Camp"
	icon_state = "under"
	first_time_text = "GOBLIN CAMP"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	deathsight_message = "root-bound caverns"
	detail_text = DETAIL_TEXT_GOBLIN_CAMP

/area/rogue/under/cave/skeletoncrypt
	name = "Skeleton Crypt"
	icon_state = "under"
	first_time_text = "SKELETON CRYPT"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	ceiling_protected = TRUE
	deathsight_message = "root-bound caverns"
	detail_text = DETAIL_TEXT_SKELETON_CRYPT
