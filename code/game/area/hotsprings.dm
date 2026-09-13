/area/rogue/outdoors/rtfield/eora
	name = "Eoran Shrine"
	icon_state = "eora"
	soundenv = 19
	ambush_times = list("night")
	first_time_text = "EORAN SHRINE"
	droning_sound = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_dusk = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_night = 'sound/newmusic/lovecraft2.ogg'
	ambush_mobs = null
	converted_type = /area/rogue/indoors/shelter/rtfield
	deathsight_message = "somewhere high up in a mountains, where cherry blossoms bloom"
	detail_text = DETAIL_TEXT_EORAN_SHRINE

/area/rogue/outdoors/rtfield/abandonedhotsprings
	name = "Abandoned Hot Springs"
	icon_state = "eora"
	soundenv = 19
	ambush_times = list("night")
	first_time_text = "ABANDONED HOT SPRINGS"
	droning_sound = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_dusk = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_night = 'sound/newmusic/lovecraft2.ogg'
	ambush_mobs = null
	converted_type = /area/rogue/indoors/abandonedhotsprings
	deathsight_message = "somewhere above a swamp, where cherry blossoms bloom and spiders chitter"
	detail_text = DETAIL_TEXT_ABANDONED_HOT_SPRINGS

/area/rogue/indoors/abandonedhotsprings
	icon_state = "eora"
	loot_budget = LOOT_BUDGET_HOT_SPRINGS
	soundenv = 19
	ambush_times = list("night")
	droning_sound = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_dusk = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_night = 'sound/newmusic/lovecraft2.ogg'
//PILGRIM

/area/rogue/outdoors/rtfield/abandonedhotsprings/grim
	name = "Infested Hot Springs"
	icon_state = "eora"
	soundenv = 19
	ambush_times = list("night")
	first_time_text = "INFESTED HOT SPRINGS"
	droning_sound = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimsprings.ogg'
	ambush_mobs = null
	converted_type = /area/rogue/indoors/abandonedhotsprings
	deathsight_message = "somewhere above a swamp, where cherry blossoms bloom and spiders chitter"
	detail_text = DETAIL_TEXT_ABANDONED_HOT_SPRINGS

/area/rogue/indoors/abandonedhotsprings/grim
	icon_state = "eora"
	loot_budget = LOOT_BUDGET_HOT_SPRINGS
	soundenv = 19
	ambush_times = list("night")
	droning_sound = 'sound/newmusic/lovecraft2.ogg'
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimsprings.ogg'
	deathsight_message = "somewhere above a swamp, where cherry blossoms bloom and spiders chitter"

/area/rogue/outdoors/rtfield/eora/grim
	name = "Eoran Shrine"
	icon_state = "eora"
	soundenv = 19
	ambush_times = list("night")
	first_time_text = "EORAN SHRINE"
	droning_sound = list('sound/music/area/grimfountain.ogg', 'sound/music/area/grimpeace.ogg', 'sound/music/area/grimtwilight.ogg')
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = list('sound/music/area/grimfountain.ogg', 'sound/music/area/grimpeace.ogg', 'sound/music/area/grimtwilight.ogg')
	droning_sound_dawn = 'sound/music/area/grimdawn.ogg'
	ambush_mobs = null
	converted_type = /area/rogue/indoors/shelter/rtfield
	deathsight_message = "somewhere surrounded by blooming cherry blossoms, nearby a massive tree."
	detail_text = DETAIL_TEXT_EORAN_SHRINE

//PILGRIM END
