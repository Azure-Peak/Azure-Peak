// Areas for Mount Decap
/area/rogue/outdoors/mountains/decap
	name = "Mount Decapitation"
	icon_state = "decap"
	ambush_mobs = list(
				new /datum/ambush_config/pair_of_direbear = 10,
				new /datum/ambush_config/trio_of_highwaymen = 10,
				new /datum/ambush_config/singular_minotaur = 10,
				new /datum/ambush_config/duo_minotaur = 5,
				new /datum/ambush_config/solo_treasure_hunter = 15,
				new /datum/ambush_config/duo_treasure_hunter = 2,
				new /datum/ambush_config/medium_skeleton_party = 10,
				new /datum/ambush_config/heavy_skeleton_party = 5,
				)
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "MOUNT DECAPITATION"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	deathsight_message = "a twisted tangle of soaring peaks"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP

/area/rogue/indoors/shelter/mountains/decap
	icon_state = "decap"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	threat_region = THREAT_REGION_MOUNT_DECAP
	deathsight_message = "a twisted tangle of soaring peaks"
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/outdoors/mountains/decap/stepbelow
	name = "Tarichea - Valley of Loss"
	icon_state = "decap"
	ambush_mobs = list(
				new /datum/ambush_config/pair_of_direbear = 10,
				new /datum/ambush_config/trio_of_highwaymen = 10,
				new /datum/ambush_config/singular_minotaur = 10,
				new /datum/ambush_config/duo_minotaur = 5,
				new /datum/ambush_config/solo_treasure_hunter = 5,
				new /datum/ambush_config/duo_treasure_hunter = 1,
				new /datum/ambush_config/medium_skeleton_party = 20,
				new /datum/ambush_config/heavy_skeleton_party = 10,
				)
	droning_sound = 'sound/music/area/decap_deeper.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "TARICHEA, VALLEY OF LOSS"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/outdoors/mountains/decap/gunduzirak
	name = "Gundu Zirak"
	icon_state = "decap"
	ambush_mobs = list(
				new /datum/ambush_config/treasure_hunter_posse = 1,
				/mob/living/carbon/human/species/dwarfskeleton/ambush = 30,
				)
	droning_sound = 'sound/music/area/prospector.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "RUINS OF GUNDU-ZIRAK"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_GUNDU_ZIRAK

/area/rogue/outdoors/mountains/decap/gunduzirak/bossarena
	name = "Baronness Boss Arena"
	first_time_text = "THE BARONESS"
	detail_text = DETAIL_TEXT_DECAP_GUNDU_ZIRAK


/area/rogue/outdoors/mountains/decap/gunduzirak/bossarena/can_craft_here()
	return FALSE

/area/rogue/under/cave/dragonden
	name = "Den of Dragons"
	icon_state = "under"
	first_time_text = "DEN OF DRAGONS"
	droning_sound = 'sound/music/area/dragonden.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	deathsight_message = "a twisted tangle of soaring peaks"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_DRAGONDEN

/area/rogue/under/cave/dragonden/can_craft_here()
	return FALSE

/area/rogue/under/cave/goblinfort
	name = "Goblin Fortress"
	icon_state = "spidercave"
	first_time_text = "GOBLIN FORTRESS"
	droning_sound = 'sound/music/area/dungeon2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	deathsight_message = "a twisted tangle of soaring peaks"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_GOBLIN_FORTRESS

/area/rogue/under/cave/scarymaze
	name = "Necran Labyrinth"
	icon_state = "spidercave"
	first_time_text = "NECRAN LABYRINTH"
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	droning_sound_dusk = 'sound/music/area/underworlddrone.ogg'
	droning_sound_night = 'sound/music/area/underworlddrone.ogg'
	ceiling_protected = TRUE
	deathsight_message = "a twisted tangle of soaring peaks"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_NECRAN_LABYRINTH

/area/rogue/outdoors/mountains/decap/minotaurfort
	name = "Ancient Dwarven Forge"
	icon_state = "decap"
	droning_sound = 'sound/music/area/prospector.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "ANCIENT DWARVEN FORGE"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_MINOTAUR_FORTRESS

/area/rogue/outdoors/mountains/decap/minotaurfort/can_craft_here()
	return FALSE
