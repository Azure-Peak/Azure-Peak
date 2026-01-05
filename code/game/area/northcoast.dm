// Azure Coast - the northern part of the map - may not be actually coast 
/area/rogue/outdoors/beach/forest
	name = "Azure Coast"
	icon_state = "beach"
	icon_state = "woods"
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 15
	ambush_times = list("night","dusk")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/mole = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 15,
				/mob/living/carbon/human/species/human/northern/searaider/ambush = 10,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
				/mob/living/carbon/human/species/orc/npc/footsoldier = 10, 
				/mob/living/carbon/human/species/orc/npc/berserker = 10,
				/mob/living/carbon/human/species/orc/npc/marauder = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush/sea = 40)
	first_time_text = "THE AZURE COAST"
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere betwixt Abyssor's realm and Dendor's bounty"
	threat_region = THREAT_REGION_AZUREAN_COAST
	detail_text = DETAIL_TEXT_NORTH_COAST

/area/rogue/outdoors/beach/forest/hamlet
	name = "The Azure Coast - Hamlet"
	first_time_text = "THE HAMLET"
	ambush_mobs = null // We don't want actual ambushes in Hamlet but we also don't want to misuse outdoors/beach lol
	threat_region = THREAT_REGION_AZUREAN_COAST
	detail_text = DETAIL_TEXT_NORTH_COAST_HAMLET

/area/rogue/outdoors/beach/forest/north
	name = "The Azure Coast - North"
	threat_region = THREAT_REGION_AZUREAN_COAST

/area/rogue/outdoors/beach/forest/south
	name = "The Azure Coast - South"
	threat_region = THREAT_REGION_AZUREAN_COAST

/area/rogue/under/cave/dukecourt
	name = "Mad Duke's Manor"
	icon_state = "duke"
	first_time_text = "MAD DUKE'S MANOR"
	droning_sound = 'sound/music/area/dungeon2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "somewhere betwixt Abyssor's realm and Dendor's bounty"
	threat_region = THREAT_REGION_AZUREAN_COAST
	detail_text = DETAIL_TEXT_MAD_DUKE_COURT
