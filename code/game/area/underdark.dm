/area/rogue/under/underdark
	name = "Central Underdark" // Northern is Sunken City
	loot_budget = LOOT_BUDGET_UNDERDARK
	loot_pool_key = "underdark"
	icon_state = "cavewet"
	warden_area = FALSE
	drow_area = TRUE
	first_time_text = "The Underdark" // This is where most people will enter Underdark
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_factions = list()
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 17,
	)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "an acid-scarred depths"
	area_sniff_message = "You smell mushrooms."
	detail_text = DETAIL_TEXT_UNDERDARK
	threat_region = THREAT_REGION_UNDERDARK

/area/rogue/under/underdark/south
	name = "Southern Underdark"
	first_time_text = "The Southern Underdark"
	detail_text = DETAIL_TEXT_SOUTHERN_UNDERDARK

/area/rogue/under/underdark/north
	name = "Melted Undercity"
	loot_budget = LOOT_BUDGET_MELTED_UNDERCITY
	loot_pool_key = "melted_undercity"
	first_time_text = "MELTED UNDERCITY"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	detail_text = DETAIL_TEXT_MELTED_UNDERCITY
	area_sniff_message = "You smell acid."
//PILGRIM

/area/rogue/under/underdark/grim
	name = "Central Grymdark" // Northern is Sunken City
	loot_budget = LOOT_BUDGET_UNDERDARK
	loot_pool_key = "underdark"
	icon_state = "cavewet"
	warden_area = FALSE
	drow_area = TRUE
	first_time_text = "The Grymdark"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/grimdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_factions = list()
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 17,
	)
	converted_type = /area/rogue/under/cave/grim
	deathsight_message = "an acid-scarred depths"
	droning_sound = 'sound/music/area/grimdark.ogg'
	detail_text = DETAIL_TEXT_UNDERDARK
	threat_region = THREAT_REGION_UNDERDARK

/area/rogue/under/underdark/south/grim
	name = "Southern Grymdark"
	first_time_text = "The Southern Grymdark"
	droning_sound = 'sound/music/area/grimdark.ogg'
	detail_text = DETAIL_TEXT_SOUTHERN_UNDERDARK

/area/rogue/under/underdark/north/grim
	name = "Melted crypts"
	loot_budget = LOOT_BUDGET_MELTED_UNDERCITY
	loot_pool_key = "melted_undercity"
	first_time_text = "MELTED CRYPTS"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/grimdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	detail_text = DETAIL_TEXT_MELTED_UNDERCITY
//PILGRIM END
