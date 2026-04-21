// Areas for Mount Decap
/area/rogue/outdoors/mountains/decap
	name = "Mount Decapitation"
	loot_budget = LOOT_BUDGET_MOUNT_DECAP
	icon_state = "decap"
	ambush_mobs = list(
				// Singles — budget filler across all factions
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 15,
				/mob/living/carbon/human/species/skeleton/npc/medium = 15,
				/mob/living/carbon/human/species/skeleton/npc/hard = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 10,
				// Packs
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
	loot_budget = LOOT_BUDGET_DECAP_SHELTERS
	loot_pool_key = "decap_shelters"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	threat_region = THREAT_REGION_MOUNT_DECAP
	deathsight_message = "a twisted tangle of soaring peaks"
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/outdoors/mountains/decap/stepbelow
	name = "Tarichea - Valley of Loss"
	loot_budget = LOOT_BUDGET_TARICHEA
	loot_pool_key = "tarichea"
	icon_state = "decap"
	ambush_mobs = list(
				// Singles
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 15,
				/mob/living/carbon/human/species/skeleton/npc/medium = 15,
				/mob/living/carbon/human/species/skeleton/npc/hard = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 10,
				// Packs
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
	loot_budget = LOOT_BUDGET_GUNDU_ZIRAK
	loot_pool_key = "gundu_zirak"
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
	loot_budget = LOOT_BUDGET_DRAGON_DEN
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
	loot_budget = LOOT_BUDGET_GOBLIN_FORT
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
	loot_budget = LOOT_BUDGET_NECRAN_LABYRINTH
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
	loot_budget = LOOT_BUDGET_MINOTAUR_FORT
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

/area/rogue/outdoors/mountains/decap/banditcamp
	name = "Bandit Camp"
	icon_state = "decap"
	loot_budget = LOOT_BUDGET_BANDIT_CAMP
	loot_pool_key = "decap_bandit_camp"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "BANDIT CAMP"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP

/area/rogue/indoors/shelter/mountains/decap/banditcamp
	name = "Bandit Camp"
	icon_state = "decap"
	loot_budget = LOOT_BUDGET_BANDIT_CAMP
	loot_pool_key = "decap_bandit_camp"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "BANDIT CAMP"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = DETAIL_TEXT_DECAP

/area/rogue/under/cave/minotaurcave
	name = "Minotaur Cave"
	loot_budget = LOOT_BUDGET_MINOTAUR_CAVE
	icon_state = "under"
	first_time_text = "MINOTAUR CAVE"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "a twisted tangle of soaring peaks"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP

/area/rogue/under/cave/taricheamanor
	name = "Manor of Tarichea"
	loot_budget = LOOT_BUDGET_TARICHEA_MANOR
	icon_state = "under"
	first_time_text = "MANOR OF TARICHEA"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "a twisted tangle of soaring peaks"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_TARICHEA
