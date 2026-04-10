// Map-specific quest configuration: difficulty multipliers, reward multipliers, and ambush pools.
// Each map file is mapped to a config datum that modifies quest behavior when the quest spawns on that map.
// Difficulty and reward values are defined in code/__DEFINES/quests.dm (QUEST_MAP_DIFFICULTY_*, QUEST_MAP_REWARD_*).

/datum/quest_map_config
	/// The map file name (lowercased, e.g. "bogforest.dmm") this config applies to
	var/map_file = ""
	/// Human-readable name for display
	var/map_name = "Unknown"
	/// Difficulty multiplier — drives ambush chance and mob scaling. Defined in quests.dm.
	var/difficulty_modifier = 1.0
	/// Reward multiplier — globally scales quest payout on this map. Defined in quests.dm.
	var/reward_modifier = 1.0
	/// Which QUEST_MAP_FLAG_* bitfield this map corresponds to for mob filtering
	var/map_flag = QUEST_MAP_FLAG_ALL
	/// List of /datum/ambush_config paths that can spawn as quest ambushes on this map
	var/list/ambush_pools = list()
	/// Weight modifier for easy quests (ROUTINE/RISKY) being placed on this map. 1.0 = normal.
	var/easy_quest_weight = 1.0
	/// Weight modifier for medium quests (DANGEROUS/DEADLY) on this map.
	var/medium_quest_weight = 1.0
	/// Weight modifier for hard quests (LETHAL/MYTHIC) on this map.
	var/hard_quest_weight = 1.0

/// Returns the effective ambush chance for this map, derived from difficulty_modifier.
/// Formula: clamp(QUEST_AMBUSH_BASE_CHANCE * difficulty_modifier, MIN, MAX)
/datum/quest_map_config/proc/get_ambush_chance()
	return clamp(round(QUEST_AMBUSH_BASE_CHANCE * difficulty_modifier), QUEST_AMBUSH_MIN_CHANCE, QUEST_AMBUSH_MAX_CHANCE)

/datum/quest_map_config/town
	map_file = "dun_world.dmm"
	map_name = "Azure Peak"
	difficulty_modifier = QUEST_MAP_DIFFICULTY_AZURE
	reward_modifier = QUEST_MAP_REWARD_AZURE
	map_flag = QUEST_MAP_FLAG_AZURE
	ambush_pools = list(
		/datum/ambush_config/bog_guard_deserters,
		/datum/ambush_config/mirespiders_ambush,
	)

/datum/quest_map_config/roguetest
	map_file = "roguetest.dmm"
	map_name = "Roguetest"
	difficulty_modifier = QUEST_MAP_DIFFICULTY_AZURE
	reward_modifier = QUEST_MAP_REWARD_AZURE
	map_flag = QUEST_MAP_FLAG_AZURE

/// Global singleton cache of map configs keyed by lowercased map_file name.
GLOBAL_LIST_EMPTY(quest_map_configs)

/proc/get_quest_map_config(map_file)
	if(!map_file)
		return null

	var/key = lowertext("[map_file]")

	if(!length(GLOB.quest_map_configs))
		initialize_quest_map_configs()

	return GLOB.quest_map_configs[key]

/proc/initialize_quest_map_configs()
	for(var/config_type in subtypesof(/datum/quest_map_config))
		var/datum/quest_map_config/config = new config_type
		if(!config.map_file)
			qdel(config)
			continue
		GLOB.quest_map_configs[lowertext("[config.map_file]")] = config

/proc/get_quest_map_config_for_turf(turf/target_turf)
	if(!target_turf)
		return null
	var/map_file = SSmapping.level_trait(target_turf.z, ZTRAIT_MAP_FILE)
	if(!map_file)
		return null
	return get_quest_map_config(map_file)

/proc/get_quest_map_flag_for_turf(turf/target_turf)
	var/datum/quest_map_config/config = get_quest_map_config_for_turf(target_turf)
	if(!config)
		return QUEST_MAP_FLAG_ALL
	return config.map_flag