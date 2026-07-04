// Literally just a subsystem to throttle farming processing to every 10 seconds
PROCESSING_SUBSYSTEM_DEF(farming)
	name = "Farming"
	priority = FIRE_PRIORITY_FARMING
	wait = 100 // 10 seconds
	stat_tag = "FARM"
	flags = SS_BACKGROUND
