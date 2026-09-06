// Please please split up those caves if you can and stop using the generic define AGH.
/area/rogue/under/cave
	name = "cave"
	warden_area = TRUE
	icon_state = "cave"
	loot_budget = LOOT_BUDGET_CAVE_DEFAULT
	ambientsounds = AMB_GENCAVE
	ambientnight = AMB_GENCAVE
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 20,
				/mob/living/carbon/human/species/goblin/npc/archer/cave = 5,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 10,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 5,
				/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 5,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 5,
				/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 10)
	converted_type = /area/rogue/outdoors/caves

/area/rogue/under/cave/peace
	icon_state = "caves"
	droning_sound = 'sound/music/area/peace.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

// Shameless copy of peace cave since someone liked it so much.
/area/rogue/under/cave/abyssor
	name = "abyssal grotto"
	icon_state = "caves"
	droning_sound = 'sound/music/area/peace.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

// Can use the normal caves music
/area/rogue/under/cave/abyssor/inner
	name = "inner abyssal grotto"
	first_time_text = "THE ABYSSAL GROTTO"

/area/rogue/outdoors/caves
	icon_state = "caves"
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/cave/spider
	icon_state = "spider"
	first_time_text = "ARAIGNÉE"
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 100)
	droning_sound = 'sound/music/area/spidercave.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/spidercave
	loot_budget = LOOT_BUDGET_ARAIGNEE

/area/rogue/outdoors/spidercave
	icon_state = "spidercave"
	droning_sound = 'sound/music/area/spidercave.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/spiderbase
	name = "spiderbase"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	icon_state = "spiderbase"
	droning_sound = 'sound/music/area/spidercave.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/spidercave

/area/rogue/outdoors/spidercave
	icon_state = "spidercave"
	droning_sound = 'sound/music/area/spidercave.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

//PILGRIM
/area/rogue/under/cave/grim
	name = "cave"
	warden_area = TRUE
	icon_state = "cave"
	loot_budget = LOOT_BUDGET_CAVE_DEFAULT
	ambientsounds = AMB_GENCAVE
	ambientnight = AMB_GENCAVE
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/grimcaves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 20,
				/mob/living/carbon/human/species/goblin/npc/archer/cave = 5,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 10,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 5,
				/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 5,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 5,
				/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 10)
	converted_type = /area/rogue/outdoors/caves

/area/rogue/under/cave/grim/hamlet
	name = "hamtunnels"
	icon_state = "cave"
	loot_budget = LOOT_BUDGET_HAMTUNNELS
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	deathsight_message = "basements and tunnels thick with the misty humidity of the hamlet's coast"
	droning_sound = 'sound/music/area/grimcaves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/caves

/area/rogue/under/cave/spider/grim
	name = "infested cave"
	icon_state = "spider"
	first_time_text = "INFESTED TUNNELS"
	deathsight_message = "a tunnel writhing with the movement of shadowed arachnids"
	droning_sound = 'sound/music/area/grimcaves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/cave/peace/grim
	icon_state = "caves"
	droning_sound = 'sound/music/area/grimfountain.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/cave/spider/lost
	name = "lost crypt"
	icon_state = "spider"
	first_time_text = "LOST CRYPT"
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 100)
	droning_sound = 'sound/music/area/grimcaves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "a lost, writhing crypt, active with the movement of shadowed arachnids"
	converted_type = /area/rogue/outdoors/spidercave
	loot_budget = LOOT_BUDGET_LOSTCRYPT

/area/rogue/under/cave/abyssor/inner/grim
	name = "abyssal sanctum"
	first_time_text = "THE ABYSSAL SANCTUM"

//PILGRIM END
