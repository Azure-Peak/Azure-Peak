// Actual coastal coastal area - this is for the harbour, which has no ambushes.
/area/rogue/outdoors/beach
	name = "City Harbor"
	loot_budget = LOOT_BUDGET_AZURE_COAST
	icon_state = "beach"
	warden_area = TRUE
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/under/lake
	first_time_text = "CITY HARBOR"
	deathsight_message = "a windswept shore"
	detail_text = DETAIL_TEXT_ACTUAL_COAST

// No sea raiders here! The Central Coast is relatively safe.
/area/rogue/outdoors/beach/central
	name = "Central Coast"
	ambush_mobs = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/carbon/human/species/goblin/npc/archer/sea = 5,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,
		/mob/living/simple_animal/hostile/rogue/deepone = 15,
		new /datum/ambush_config/triple_deepone = 30,
		new /datum/ambush_config/deepone_party = 20,
	)
	first_time_text = "CENTRAL COAST"
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/beach/north
	name = "Northern Coast"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 10,
		/mob/living/carbon/human/species/human/northern/searaider/archer/ambush = 3,
		/mob/living/carbon/human/species/human/northern/searaider/huscarl/ambush = 3,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/carbon/human/species/goblin/npc/archer/sea = 5,
		/mob/living/carbon/human/species/orc/npc/berserker = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 40,
		new /datum/ambush_config/huscarl_raiding_party = 3
	)
	first_time_text = "NORTHERN COAST"
	threat_region = THREAT_REGION_AZUREAN_COAST

/area/rogue/outdoors/beach/south
	name = "Southern Coast"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 5,
		/mob/living/carbon/human/species/human/northern/searaider/archer/ambush = 2,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/carbon/human/species/goblin/npc/archer/sea = 5,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,
		/mob/living/simple_animal/hostile/rogue/deepone = 15,
		new /datum/ambush_config/triple_deepone = 30,
		new /datum/ambush_config/deepone_party = 20,
	)
	first_time_text = "SOUTHERN COAST"
	detail_text = DETAIL_TEXT_CITY_COAST
	threat_region = THREAT_REGION_AZURE_BASIN
//PILGRIM

/area/rogue/outdoors/beach/grim
	name = "Pilgrim Harbor"
	loot_budget = LOOT_BUDGET_AZURE_COAST
	icon_state = "beach"
	warden_area = TRUE
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	droning_sound = list('sound/music/area/townstreets.ogg', 'sound/music/area/townchill.ogg', 'sound/music/area/townstroll.ogg', 'sound/music/area/townwander.ogg')
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = 'sound/music/area/grimnight.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	converted_type = /area/rogue/under/lake
	first_time_text = "PILGRIM HARBOR"
	deathsight_message = "a dock, active with undiscernible people"
	detail_text = DETAIL_TEXT_ACTUAL_COAST

/area/rogue/outdoors/beach/north/grim
	name = "Bilewater Coast"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 10,
		/mob/living/carbon/human/species/human/northern/searaider/archer/ambush = 3,
		/mob/living/carbon/human/species/human/northern/searaider/huscarl/ambush = 3,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/carbon/human/species/goblin/npc/archer/sea = 5,
		/mob/living/carbon/human/species/orc/npc/berserker = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 40,
		new /datum/ambush_config/huscarl_raiding_party = 3
	)
	first_time_text = "BILEWATER COAST"
	droning_sound = 'sound/music/area/grimcoast.ogg'
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	threat_region = THREAT_REGION_AZUREAN_COAST
	deathsight_message = "a shore adjacent a cliff, with a lighthouse in the distance, and a deep cove to the south"

/area/rogue/outdoors/beach/south/grim
	name = "Jaggedjaw Coast"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 5,
		/mob/living/carbon/human/species/human/northern/searaider/archer/ambush = 2,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/carbon/human/species/goblin/npc/archer/sea = 5,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,
		/mob/living/simple_animal/hostile/rogue/deepone = 15,
		new /datum/ambush_config/triple_deepone = 30,
		new /datum/ambush_config/deepone_party = 20,
	)
	first_time_text = "JAGGEDJAW COAST"
	droning_sound = list('sound/music/area/townstreets.ogg', 'sound/music/area/townchill.ogg', 'sound/music/area/townstroll.ogg', 'sound/music/area/townwander.ogg')
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = 'sound/music/area/grimnight.ogg'
	deathsight_message = "a freshwater shore, with a large dock between it and the city"
	detail_text = DETAIL_TEXT_CITY_COAST
	threat_region = THREAT_REGION_AZURE_BASIN
//PILGRIM END
