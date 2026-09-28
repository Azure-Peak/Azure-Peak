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
	ambush_factions = list(
		QUEST_FACTION_FOREST_GOBLIN = 63,
		QUEST_FACTION_HIGHWAYMAN = 13,
		QUEST_FACTION_GREAT_BEAST = 13,
		QUEST_FACTION_MINOTAUR = 13,
	)
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 75,
		/mob/living/carbon/human/species/skeleton/npc/ambush = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 25,
	)
	converted_type = /area/rogue/outdoors/caves
	area_sniff_message = "You smell the distant stench of the sewer, muddied by a damp and murky scent."

/area/rogue/under/cave/peace
	icon_state = "caves"
	droning_sound = 'sound/music/area/peace.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	area_sniff_message = "You smell sweetly scenter water and old roots."

// Shameless copy of peace cave since someone liked it so much.
/area/rogue/under/cave/abyssor
	name = "abyssal grotto"
	icon_state = "caves"
	droning_sound = 'sound/music/area/peace.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	area_sniff_message = "You smell strange chemicals and paints."

// Can use the normal caves music
/area/rogue/under/cave/abyssor/inner
	name = "inner abyssal grotto"
	first_time_text = "THE ABYSSAL GROTTO"
	area_sniff_message = "You smell strange chemicals and paints."

/area/rogue/outdoors/caves
	icon_state = "caves"
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/cave/spider
	icon_state = "spider"
	first_time_text = "ARAIGNÉE"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/spider = 100,
	)
	droning_sound = 'sound/music/area/spidercave.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/spidercave
	loot_budget = LOOT_BUDGET_ARAIGNEE
	area_sniff_message = "You smell raw spidersilk and corpses since long preserved."

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
	ambush_factions = list(
		QUEST_FACTION_FOREST_GOBLIN = 63,
		QUEST_FACTION_HIGHWAYMAN = 13,
		QUEST_FACTION_GREAT_BEAST = 13,
		QUEST_FACTION_MINOTAUR = 13,
	)
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 75,
		/mob/living/carbon/human/species/skeleton/npc/ambush = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 25,
	)
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
		/mob/living/simple_animal/hostile/retaliate/rogue/spider = 100,
	)
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
