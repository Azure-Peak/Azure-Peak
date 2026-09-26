// Areas for Mount Decap
/area/rogue/outdoors/mountains/decap
	name = "Mount Decapitation"
	loot_budget = LOOT_BUDGET_MOUNT_DECAP
	icon_state = "decap"
	ambush_factions = list()
	ambush_mobs = list(
		/datum/npc_warband/pair_of_direbear = 14,
		/datum/npc_warband/trio_of_highwaymen = 5,
		/datum/npc_warband/bandit_band_balanced/lean = 4,
		/datum/npc_warband/bandit_band_balanced = 3,
		/datum/npc_warband/bandit_houndmaster = 1,
		/datum/npc_warband/road_knight_escort = 3,
		/datum/npc_warband/bandit_band_balanced/shieldwall = 1,
		/datum/npc_warband/bandit_band_high = 1,
		/datum/npc_warband/bandit_band_high/knight = 1,
		/datum/npc_warband/singular_minotaur = 14,
		/datum/npc_warband/duo_minotaur = 7,
		/datum/npc_warband/solo_treasure_hunter = 20,
		/datum/npc_warband/duo_treasure_hunter = 3,
		/datum/npc_warband/medium_skeleton_party = 14,
		/datum/npc_warband/heavy_skeleton_party = 7,
	)
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "MOUNT DECAPITATION"
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	deathsight_message = "a twisted tangle of soaring peaks"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP
	area_sniff_message = "You smell ancient bones and pine wood."

/area/rogue/indoors/shelter/mountains/decap
	name = "Mount Decapitation"
	icon_state = "decap"
	loot_budget = LOOT_BUDGET_DECAP_SHELTERS
	loot_pool_key = "decap_shelters"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	threat_region = THREAT_REGION_MOUNT_DECAP
	deathsight_message = "a twisted tangle of soaring peaks"
	detail_text = DETAIL_TEXT_DECAP_TARICHEA
	area_sniff_message = "You smell ancient bones and pine wood planks."

/area/rogue/outdoors/mountains/decap/stepbelow
	name = "Tarichea - Valley of Loss"
	loot_budget = LOOT_BUDGET_TARICHEA
	loot_pool_key = "tarichea"
	icon_state = "decap"
	ambush_factions = list()
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 36,
		/datum/npc_warband/pair_of_direbear = 24,
		/datum/npc_warband/trio_of_highwaymen = 10,
		/datum/npc_warband/bandit_band_balanced/lean = 7,
		/datum/npc_warband/bandit_band_balanced = 5,
		/datum/npc_warband/bandit_houndmaster = 2,
		/datum/npc_warband/road_knight_escort = 10,
		/datum/npc_warband/singular_minotaur = 24,
		/datum/npc_warband/duo_minotaur = 12,
		/datum/npc_warband/solo_treasure_hunter = 12,
		/datum/npc_warband/duo_treasure_hunter = 2,
		/datum/npc_warband/medium_skeleton_party = 48,
		/datum/npc_warband/heavy_skeleton_party = 24,
	)
	droning_sound = 'sound/music/area/decap_deeper.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "TARICHEA, VALLEY OF LOSS"
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_TARICHEA
	area_sniff_message = "You smell sulfur."

/area/rogue/outdoors/mountains/decap/gunduzirak
	name = "Gundu Zirak"
	loot_budget = LOOT_BUDGET_GUNDU_ZIRAK
	loot_pool_key = "gundu_zirak"
	icon_state = "decap"
	ambush_mobs = list(
		/datum/npc_warband/treasure_hunter_posse = 1,
		/mob/living/carbon/human/species/dwarfskeleton/ambush = 30,
	)
	droning_sound = 'sound/music/area/prospector.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "RUINS OF GUNDU-ZIRAK"
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_GUNDU_ZIRAK
	area_sniff_message = "You smell old grudges and copper flakes."

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
	area_sniff_message = "You smell drakynn."

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
	area_sniff_message = "You smell vile daemonspawn."

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
	area_sniff_message = "You smell death and black roses."

/area/rogue/outdoors/mountains/decap/minotaurfort
	name = "Ancient Dwarven Forge"
	loot_budget = LOOT_BUDGET_MINOTAUR_FORT
	icon_state = "decap"
	droning_sound = 'sound/music/area/prospector.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "ANCIENT DWARVEN FORGE"
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_MINOTAUR_FORTRESS
	area_sniff_message = "You smell beef."

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
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	area_sniff_message = "You smell sweaty men, women, and pine wood."

/area/rogue/indoors/shelter/mountains/decap/banditcamp
	name = "Bandit Camp"
	icon_state = "decap"
	loot_budget = LOOT_BUDGET_BANDIT_CAMP
	loot_pool_key = "decap_bandit_camp"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "BANDIT CAMP"
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = DETAIL_TEXT_DECAP
	area_sniff_message = "You smell sweat men, women, and pine wood."

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
	area_sniff_message = "You smell beef and undergrowth."

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
	area_sniff_message = "You smell stone floors and sulfur."
//PILGRIM

/area/rogue/outdoors/mountains/decap/grim
	name = "Mount Grymspyre"
	loot_budget = LOOT_BUDGET_MOUNT_GRYMSPYRE
	icon_state = "decap"
	ambush_factions = list()
	ambush_mobs = list(
		/datum/npc_warband/pair_of_direbear = 14,
		/datum/npc_warband/trio_of_highwaymen = 5,
		/datum/npc_warband/bandit_band_balanced/lean = 4,
		/datum/npc_warband/bandit_band_balanced = 3,
		/datum/npc_warband/bandit_houndmaster = 1,
		/datum/npc_warband/road_knight_escort = 3,
		/datum/npc_warband/bandit_band_balanced/shieldwall = 1,
		/datum/npc_warband/bandit_band_high = 1,
		/datum/npc_warband/bandit_band_high/knight = 1,
		/datum/npc_warband/singular_minotaur = 14,
		/datum/npc_warband/duo_minotaur = 7,
		/datum/npc_warband/solo_treasure_hunter = 20,
		/datum/npc_warband/duo_treasure_hunter = 3,
		/datum/npc_warband/medium_skeleton_party = 14,
		/datum/npc_warband/heavy_skeleton_party = 7,
	)
	droning_sound = 'sound/music/area/grimspire.ogg'
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimspyre.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	first_time_text = "MOUNT GRYMSPYRE"
	converted_type = /area/rogue/indoors/shelter/mountains/decap/grim
	deathsight_message = "a spyre of jagged rock and winding crevices, surrounded by snow"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP

/area/rogue/indoors/shelter/mountains/decap/grim
	name = "Mount Grymspyre"
	icon_state = "decap"
	loot_budget = LOOT_BUDGET_GRYMSPYRE_SHELTERS
	loot_pool_key = "decap_shelters"
	droning_sound = 'sound/music/area/grimspire.ogg'
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimspyre.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	threat_region = THREAT_REGION_MOUNT_DECAP
	deathsight_message = "the cover of jagged rock and winding crevices, buried in snow"
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/under/cave/grimspyre
	name = "Grymspyre Caverns"
	icon_state = "decap"
	loot_budget = LOOT_BUDGET_GRYMSPYRE_SHELTERS
	loot_pool_key = "decap_shelters"
	droning_sound = list('sound/music/area/grimcaves.ogg','sound/music/area/grimcaverns.ogg')
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "GRYMSPYRE CAVERNS"
	threat_region = THREAT_REGION_MOUNT_DECAP
	deathsight_message = "deep within jagged rock and winding crevices, volcanic ash in the air"
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/under/cave/grimspyre/depths
	name = "Grymspyre Depths"
	icon_state = "decap"
	loot_budget = LOOT_BUDGET_GRYMSPYRE_DEPTHS
	droning_sound = 'sound/music/area/grimcaves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "GRYMSPYRE DEPTHS"
	threat_region = THREAT_REGION_MOUNT_DECAP
	deathsight_message = "deep within volcanic caverns, air thick with heat distortion"
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/under/cave/grimspyre/depths/ancientforge
	name = "Ancient Dwarven Workshop"
	loot_budget = LOOT_BUDGET_DWARFSHOP
	icon_state = "decap"
	droning_sound = 'sound/music/area/grimdepths.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "ANCIENT DWARVEN WORKSHOP"
/area/rogue/under/cave/grimspyre/depths
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_DWARFSHOP

/area/rogue/under/cave/grimspyre/depths/ancientforge/can_craft_here()
	return FALSE

//PILGRIM END
