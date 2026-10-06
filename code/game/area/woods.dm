// Azure Grove - the areas to the south of the map

/area/rogue/outdoors/woods
	name = "The Azure Grove"
	icon_state = "woods"
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	soundenv = 15
	warden_area = TRUE
	ambush_factions = list()
	first_time_text = "THE AZURE GROVE"
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the wilds"
	threat_region = THREAT_REGION_AZURE_GROVE
	detail_text = DETAIL_TEXT_AZURE_GROVE
	area_sniff_message = "You smell old, mighty trees."

/area/rogue/indoors/shelter/woods
	name = "Azure Grove"
	icon_state = "woods"
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	threat_region = THREAT_REGION_AZURE_GROVE
	deathsight_message = "somewhere in the wilds"
	area_sniff_message = "You smell old, mighty trees... But someone cut them into planks."

/area/rogue/outdoors/woods/north
	name = "Azure Grove - North"
	ambush_factions = list()
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/northeast
	name = "Azure Grove - Northeast"
	ambush_factions = list()
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/pirate = 6,
		/mob/living/carbon/human/species/goblin/npc/sea = 6,
	)
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/southeast
	name = "Azure Grove - Southeast"
	ambush_factions = list()
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/pirate = 6,
		/mob/living/carbon/human/species/goblin/npc/sea = 6,
	)

/area/rogue/outdoors/woods/south
	name = "Azure Grove - South"
	ambush_factions = list()

/area/rogue/outdoors/woods/southwest
	name = "Azure Grove - Southwest"
	ambush_factions = list()

/area/rogue/outdoors/woods/northwest
	name = "Azure Grove - Northwest"
	ambush_factions = list()

/area/rogue/outdoors/woods/vampire_lair
	warden_area = FALSE
	ambush_mobs = null
	threat_region = ""

/area/rogue/outdoors/woods/wretch_lair
	warden_area = FALSE
	ambush_mobs = null
	threat_region = ""
//PILGRIM

/area/rogue/outdoors/woods/grim
	name = "The Jaggedjaw Grove"
	icon_state = "woods"
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = list('sound/music/area/grimmorning.ogg', 'sound/music/area/grimtwilight.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	soundenv = 15
	warden_area = TRUE
	ambush_factions = list()
	first_time_text = "JAGGEDJAW GROVE"
	converted_type = /area/rogue/indoors/shelter/woods/grim
	deathsight_message = "somewhere in the wilds of jaggedjaw grove"
	threat_region = THREAT_REGION_AZURE_GROVE
	detail_text = DETAIL_TEXT_AZURE_GROVE

/area/rogue/indoors/shelter/woods/grim
	name = "Jaggedjaw Grove shelter"
	icon_state = "woods"
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	threat_region = THREAT_REGION_AZURE_GROVE
	deathsight_message = "somewhere in the wilds of jaggedjaw grove, shrouded under cover"

/area/rogue/outdoors/woods/grim/north
	name = "Jaggedjaw Grove - North"
	ambush_factions = list()
	threat_region = THREAT_REGION_AZURE_GROVE
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	deathsight_message = "somewhere in the wilds of jaggedjaw grove, near a curling river and jagged inlet cliffs"

/area/rogue/outdoors/woods/grim/northeast
	name = "Jaggedjaw Grove - Northeast"
	ambush_factions = list()
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/pirate = 6,
		/mob/living/carbon/human/species/goblin/npc/sea = 6,
	)
	threat_region = THREAT_REGION_AZURE_GROVE
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'

/area/rogue/outdoors/woods/grim/northeast/wardenscheckpoint
	name = "Warden's Checkpoint"
	first_time_text = "WARDEN'S CHECKPOINT"

/area/rogue/indoors/shelter/woods/grim/northeast/wardenscheckpoint
	name = "Warden's Checkpoint"
	icon_state = "woods"
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	threat_region = THREAT_REGION_AZURE_GROVE
	deathsight_message = "somewhere in the wilds of jaggedjaw grove, within battered walls"

/area/rogue/outdoors/woods/grim/southeast
	name = "Jaggedjaw Grove - Southeast"
	ambush_factions = list()
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/pirate = 6,
		/mob/living/carbon/human/species/goblin/npc/sea = 6,
	)
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'

/area/rogue/outdoors/woods/grim/south
	name = "Jaggedjaw Grove - South"
	ambush_factions = list()
	droning_sound = list(, 'sound/music/area/grimdrama.ogg', 'sound/music/area/grimtwilight.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'

/area/rogue/outdoors/woods/grim/southwest
	name = "Jaggedjaw Grove - Southwest"
	ambush_factions = list()
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'

/area/rogue/outdoors/woods/grim/northwest
	name = "Jaggedjaw Grove - Northwest"
	ambush_factions = list()
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
//PILGRIM END
