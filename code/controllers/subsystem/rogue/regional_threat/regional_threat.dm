SUBSYSTEM_DEF(regionthreat)
	name = "Regional Threat"
	wait = 30 MINUTES
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
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
				QUEST_FACTION_FOREST_GOBLIN = 60,
				QUEST_FACTION_SEA_GOBLIN = 40,
				QUEST_FACTION_HIGHWAYMAN = 5, // basically for blockade only
			),
			_tp_budget_multiplier = 0.75,
			_delivery_reward_multiplier = 1.0,
			_kill_target_floor = 8,
			_evergreen_target = 6,
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
			_delivery_reward_multiplier = 1.5,
			_kill_target_floor = 10,
			_evergreen_target = 6
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
			_delivery_reward_multiplier = 1.5,
			_payout_multiplier = 1.1, // Close by, so it is pretty convenient
			_kill_target_floor = 8
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
			_delivery_reward_multiplier = 1.8,
			_payout_multiplier = 1.3, // Farther away, higher implicit threat of antag
			_kill_target_floor = 8,
			_blockade_travel_fee = BLOCKADE_TRAVEL_FEE_COAST
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
			_delivery_reward_multiplier = 2.0,
			_payout_multiplier = 1.35,
			_kill_target_floor = 8,
			_blockade_travel_fee = BLOCKADE_TRAVEL_FEE_MOUNTAIN
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
			_delivery_reward_multiplier = 2.0,
			_payout_multiplier = 1.2,
			_kill_target_floor = 6,
			_blockade_travel_fee = BLOCKADE_TRAVEL_FEE_MOUNTAIN
		)
	)

/datum/controller/subsystem/regionthreat/fire(resumed)
	var/player_count = (SSeconomy && SSeconomy.simulated_player_scalar > 0) ? SSeconomy.simulated_player_scalar : GLOB.player_list.len
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

/datum/controller/subsystem/regionthreat/proc/pick_region_for_quest(quest_type)
	var/list/weights = list()
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		if(!TR.allows_quest_type(quest_type))
			continue
		// Threat level is 0 to 1, but pickweight only works with whole numbers, so scale it to 0 to 100.
		var/weight = round(TR.get_threat_weight() * 100)
		if(weight <= 0)
			continue
		weights[TR] = weight
	if(!length(weights))
		// No allowed region has any threat right now, so pick between them evenly.
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

/datum/controller/subsystem/regionthreat/proc/build_scout_region_rows()
	var/list/rows = list()
	for(var/datum/threat_region/TR as anything in threat_regions)
		var/list/row = list()
		row["region_name"] = TR.region_name
		row["danger_level"] = TR.get_danger_level()
		row["danger_color"] = TR.get_danger_color()
		row["ic_descriptions"] = TR.get_ic_description()
		var/list/blockades = list()
		for(var/datum/blockade/B as anything in GLOB.active_blockades)
			if(B.threat_region_name != TR.region_name)
				continue
			var/datum/quest_faction/F = B.get_faction()
			blockades += list(list(
				"gathering" = FALSE,
				"writ_out" = B.has_active_scroll() ? TRUE : FALSE,
				"faction_label" = F ? "[F.group_word] of [F.name_plural]" : (B.faction_id || ""),
				"region_label" = B.get_region_names(),
				"days_active" = max(0, ECONOMY_DAY - B.day_started),
			))
		for(var/subroute in SSeconomy?.gathering_blockades)
			if(get_subroute_threat_region(subroute) != TR.region_name)
				continue
			var/faction_id = SSeconomy.gathering_blockades[subroute]
			var/datum/quest_faction/F = get_quest_faction(faction_id)
			blockades += list(list(
				"gathering" = TRUE,
				"writ_out" = FALSE,
				"faction_label" = F ? "[F.group_word] of [F.name_plural]" : (faction_id || ""),
				"region_label" = get_subroute_region_names(subroute),
				"days_active" = 0,
			))
		row["blockaded"] = length(blockades) ? TRUE : FALSE
		row["blockades"] = blockades
		rows += list(row)
	return rows
