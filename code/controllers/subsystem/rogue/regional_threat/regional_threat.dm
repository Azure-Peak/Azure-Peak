SUBSYSTEM_DEF(regionthreat)
	name = "Regional Threat"
	wait = 30 MINUTES
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	// SS fires every 30 minutes = 6 ticks per 3-hour round.
	// Highpop tick = THREAT_HIGHPOP_TICK_RATE (20%) of max_ambush. Each tick is a maintenance fight's worth of threat.
	// Lowpop tick = THREAT_LOWPOP_TICK_RATE (10%) of max_ambush.
	// Basin & Grove & Terrorbog are fully tameable (min 0). Coast & Decap stay dangerous (min > 0).
	// Budget = player_factor * pool * 3%. Solo combat budgets shown at max pool.
	// Additive group drain: 5-man party drains at 3x/player_factor efficiency (0.5x per extra player).
	var/list/threat_regions = list(
		new /datum/threat_region(
			_region_name = THREAT_REGION_AZURE_BASIN,
			_latent_ambush = 150,
			_min_ambush = 0,
			_max_ambush = 375,
			_fixed_ambush = FALSE,
			_ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION,
			_lowpop_tick = 375 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 375 * THREAT_HIGHPOP_TICK_RATE,
			_faction_weights = list(
				QUEST_FACTION_HIGHWAYMAN = 60,
				QUEST_FACTION_FOREST_GOBLIN = 25,
				QUEST_FACTION_WILD_BEAST = 15,
			),
			_tp_budget_multiplier = 0.75,
			_kill_target_floor = 3,
			_evergreen_target = 2,
			_allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY),
		),
		new /datum/threat_region(
			_region_name = THREAT_REGION_AZURE_GROVE,
			_latent_ambush = 375,
			_min_ambush = 0,
			_max_ambush = 750,
			_fixed_ambush = FALSE,
			_ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION,
			_lowpop_tick = 750 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 750 * THREAT_HIGHPOP_TICK_RATE,
			_faction_weights = list(
				QUEST_FACTION_FOREST_GOBLIN = 40,
				QUEST_FACTION_HIGHWAYMAN = 30,
				QUEST_FACTION_STRAY_DEADITE = 20,
				QUEST_FACTION_WILD_BEAST = 10,
			),
			_tp_budget_multiplier = 1.0,
			_kill_target_floor = 4,
			_evergreen_target = 2
			// allowed_quest_types: default (all)
		),
		new /datum/threat_region(
			_region_name = THREAT_REGION_TERRORBOG,
			_latent_ambush = 1500,
			_min_ambush = 0, // Fully tameable — a warden can engage in a long war to tame the terrorbog.
			_max_ambush = 1500,
			_fixed_ambush = FALSE,
			_lowpop_tick = 1500 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 1500 * THREAT_HIGHPOP_TICK_RATE,
			_faction_weights = list(
				QUEST_FACTION_BOGMAN = 40,
				QUEST_FACTION_MIRESPIDER = 25,
				QUEST_FACTION_BOG_DEADITE = 20,
				QUEST_FACTION_BOG_TROLL = 10,
				QUEST_FACTION_FOREST_GOBLIN = 5,
			),
			_tp_budget_multiplier = 1.5,
			_allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY),
			_kill_target_floor = 3,
			_evergreen_target = 2
		),
		// Coast & Decap stay somewhat dangerous no matter what
		new /datum/threat_region(
			_region_name = THREAT_REGION_AZUREAN_COAST,
			_latent_ambush = 500,
			_min_ambush = 225,
			_max_ambush = 800,
			_fixed_ambush = FALSE,
			_lowpop_tick = 800 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 800 * THREAT_HIGHPOP_TICK_RATE,
			_faction_weights = list(
				QUEST_FACTION_ORC = 30,
				QUEST_FACTION_SEA_GOBLIN = 25,
				QUEST_FACTION_GRONNMAN = 20,
				QUEST_FACTION_BLEAKISLE_REAVER = 15,
				QUEST_FACTION_HIGHWAYMAN = 10,
			),
			_tp_budget_multiplier = 1.2,
			_allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY),
			_kill_target_floor = 2
		),
		new /datum/threat_region(
			_region_name = THREAT_REGION_MOUNT_DECAP,
			_latent_ambush = 600,
			_min_ambush = 300,
			_max_ambush = 1000,
			_fixed_ambush = FALSE,
			_lowpop_tick = 1000 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 1000 * THREAT_HIGHPOP_TICK_RATE,
			_faction_weights = list(
				QUEST_FACTION_HELL_GOBLIN = 25,
				QUEST_FACTION_TARICHEA_DEADITE = 20,
				QUEST_FACTION_MOUNT_REAVER = 20,
				QUEST_FACTION_MOUNTAIN_TROLL = 15,
				QUEST_FACTION_MINOTAUR = 10,
				QUEST_FACTION_GREAT_BEAST = 5,
				QUEST_FACTION_MADMAN = 5,
			),
			_tp_budget_multiplier = 1.5,
			_allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY),
			_kill_target_floor = 2
		),
		// Underdark cannot be tamed — min_ambush is high, keeping the region permanently dangerous.
		new /datum/threat_region(
			_region_name = THREAT_REGION_UNDERDARK,
			_latent_ambush = 600,
			_min_ambush = 400, // Hard floor — drow and spider nests are eternal
			_max_ambush = 1200,
			_fixed_ambush = FALSE,
			_lowpop_tick = 1200 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 1200 * THREAT_HIGHPOP_TICK_RATE,
			_faction_weights = list(
				QUEST_FACTION_DROW = 30,
				QUEST_FACTION_MIRESPIDER = 25,
				QUEST_FACTION_MOON_GOBLIN = 25,
				QUEST_FACTION_LICH_DEADITE = 10,
				QUEST_FACTION_MINOTAUR = 10,
			),
			_tp_budget_multiplier = 1.5,
			_allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY),
			_kill_target_floor = 2
		)
	)

/datum/controller/subsystem/regionthreat/fire(resumed)
	var/player_count = GLOB.player_list.len
	var/ishighpop = player_count >= LOWPOP_THRESHOLD
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		if(ishighpop)
			TR.increase_latent_ambush(TR.highpop_tick)
		else
			TR.increase_latent_ambush(TR.lowpop_tick)

/datum/controller/subsystem/regionthreat/proc/get_region(region_name)
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		if(TR.region_name == region_name)
			return TR
	return null

/// Weighted pick of a region that allows the given quest type, weighted by fill ratio
/// (latent_ambush / max_ambush). Regions with more relative threat are picked more often, so
/// as adventurers clear a region its quest share naturally drops. Returns null if no region
/// allows the type.
/datum/controller/subsystem/regionthreat/proc/pick_region_for_quest(quest_type)
	var/list/weights = list()
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		if(!TR.allows_quest_type(quest_type))
			continue
		var/weight = TR.get_threat_weight()
		if(weight <= 0)
			continue
		weights[TR] = weight
	if(!length(weights))
		// Fall back: any region that allows the type, ignoring fill ratio.
		for(var/T in threat_regions)
			var/datum/threat_region/TR = T
			if(TR.allows_quest_type(quest_type))
				weights[TR] = 1
		if(!length(weights))
			return null
	return pickweight(weights)

/datum/threat_region_display
	var/region_name
	var/danger_level
	var/danger_color
	var/list/ic_description = list()

/datum/controller/subsystem/regionthreat/proc/get_threat_regions_for_display()
	var/list/threat_region_displays = list()
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		var/datum/threat_region_display/TRS = new /datum/threat_region_display
		TRS.region_name = TR.region_name
		TRS.danger_level = TR.get_danger_level()
		TRS.danger_color = TR.get_danger_color()
		TRS.ic_description = TR.get_ic_description()
		threat_region_displays += TRS
	return threat_region_displays
