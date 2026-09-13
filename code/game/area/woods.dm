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
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/goblin/npc/archer = 7,
				/mob/living/carbon/human/species/human/northern/militia/deserter = 20,
				/mob/living/carbon/human/species/hobgoblin/npc/ambush = 15,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 10)
	first_time_text = "THE AZURE GROVE"
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the wilds"
	threat_region = THREAT_REGION_AZURE_GROVE
	detail_text = DETAIL_TEXT_AZURE_GROVE

/area/rogue/indoors/shelter/woods
	name = "Azure Grove"
	icon_state = "woods"
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	threat_region = THREAT_REGION_AZURE_GROVE
	deathsight_message = "somewhere in the wilds"


/area/rogue/outdoors/woods/north
	name = "Azure Grove - North"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 20,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 15,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/northeast
	name = "Azure Grove - Northeast"
	ambush_mobs = list(
			/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
			/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
			/mob/living/carbon/human/species/skeleton/npc/easy = 10,
			/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
			/mob/living/carbon/human/species/goblin/npc/ambush = 20,
			/mob/living/carbon/human/species/goblin/npc/archer = 5,
			/mob/living/carbon/human/species/goblin/npc/sea = 10,
			/mob/living/carbon/human/species/hobgoblin/npc/ambush = 12,
			/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/southeast
	name = "Azure Grove - Southeast"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 10,
		/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 20,
		/mob/living/carbon/human/species/goblin/npc/archer = 5,
		/mob/living/carbon/human/species/goblin/npc/sea = 10,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 12,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)

/area/rogue/outdoors/woods/south
	name = "Azure Grove - South"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 18,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)

/area/rogue/outdoors/woods/southwest
	name = "Azure Grove - Southwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 18,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)

/area/rogue/outdoors/woods/northwest
	name = "Azure Grove - Northwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 18,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)

/area/rogue/outdoors/woods/vampire_lair
	warden_area = FALSE
	ambush_times = list()
	ambush_mobs = null
	threat_region = ""

/area/rogue/outdoors/woods/wretch_lair
	warden_area = FALSE
	ambush_times = list()
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
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/goblin/npc/archer = 7,
				/mob/living/carbon/human/species/human/northern/militia/deserter = 20,
				/mob/living/carbon/human/species/hobgoblin/npc/ambush = 15,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 10)
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
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 20,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 15,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	threat_region = THREAT_REGION_AZURE_GROVE
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	deathsight_message = "somewhere in the wilds of jaggedjaw grove, near a curling river and jagged inlet cliffs"

/area/rogue/outdoors/woods/grim/northeast
	name = "Jaggedjaw Grove - Northeast"
	ambush_mobs = list(
			/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
			/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
			/mob/living/carbon/human/species/skeleton/npc/easy = 10,
			/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
			/mob/living/carbon/human/species/goblin/npc/ambush = 20,
			/mob/living/carbon/human/species/goblin/npc/archer = 5,
			/mob/living/carbon/human/species/goblin/npc/sea = 10,
			/mob/living/carbon/human/species/hobgoblin/npc/ambush = 12,
			/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
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
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 10,
		/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 20,
		/mob/living/carbon/human/species/goblin/npc/archer = 5,
		/mob/living/carbon/human/species/goblin/npc/sea = 10,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 12,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'

/area/rogue/outdoors/woods/grim/south
	name = "Jaggedjaw Grove - South"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 18,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)
	droning_sound = list(, 'sound/music/area/grimdrama.ogg', 'sound/music/area/grimtwilight.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'

/area/rogue/outdoors/woods/grim/southwest
	name = "Jaggedjaw Grove - Southwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 18,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'

/area/rogue/outdoors/woods/grim/northwest
	name = "Jaggedjaw Grove - Northwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/archer = 7,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 18,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)
	droning_sound = list(, 'sound/music/area/grimtwilight.ogg', 'sound/music/area/grimdrama.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimforest.ogg'
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
//PILGRIM END
