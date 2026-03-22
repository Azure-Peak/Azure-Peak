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
			_region_name = THREAT_REGION_AZURE_BASIN, // Solo: 7.5 TP → 1 wolf | 5-party: 37 TP → 3-4 wolves
			_latent_ambush = 100,
			_min_ambush = 0,
			_max_ambush = 250,
			_fixed_ambush = FALSE,
			_lowpop_tick = 250 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 250 * THREAT_HIGHPOP_TICK_RATE
		),
		new /datum/threat_region(
			_region_name = THREAT_REGION_AZURE_GROVE, // Solo: 15 TP → 1-2 mixed | 5-party: 75 TP → 5-6 mixed
			_latent_ambush = 250,
			_min_ambush = 0,
			_max_ambush = 500,
			_fixed_ambush = FALSE,
			_lowpop_tick = 500 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 500 * THREAT_HIGHPOP_TICK_RATE
		),
		new /datum/threat_region(
			_region_name = THREAT_REGION_TERRORBOG, // Solo: 45 TP → 2-3 bogmen | 5-party: 225 TP → 11 bogmen
			_latent_ambush = 1500,
			_min_ambush = 0, // Fully tameable — a warden can engage in a long war to tame the terrorbog.
			_max_ambush = 1500,
			_fixed_ambush = FALSE,
			_lowpop_tick = 1500 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 1500 * THREAT_HIGHPOP_TICK_RATE
		),
		// Coast & Decap stay somewhat dangerous no matter what
		new /datum/threat_region(
			_region_name = THREAT_REGION_AZUREAN_COAST, // Solo: 24 TP → 1-2 deepones | 5-party: 120 TP → 6 deepones
			_latent_ambush = 500,
			_min_ambush = 150,
			_max_ambush = 800,
			_fixed_ambush = FALSE,
			_lowpop_tick = 800 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 800 * THREAT_HIGHPOP_TICK_RATE
		),
		new /datum/threat_region(
			_region_name = THREAT_REGION_MOUNT_DECAP, // Solo: 30 TP → 1 minotaur | 5-party: 150 TP → 5 minotaurs
			_latent_ambush = 500,
			_min_ambush = 200,
			_max_ambush = 1000,
			_fixed_ambush = FALSE,
			_lowpop_tick = 1000 * THREAT_LOWPOP_TICK_RATE,
			_highpop_tick = 1000 * THREAT_HIGHPOP_TICK_RATE
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

/datum/threat_region_display
	var/region_name
	var/danger_level
	var/danger_color

/datum/controller/subsystem/regionthreat/proc/get_threat_regions_for_display()
	var/list/threat_region_displays = list()
	for(var/T in threat_regions)
		var/datum/threat_region/TR = T
		var/datum/threat_region_display/TRS = new /datum/threat_region_display
		TRS.region_name = TR.region_name
		TRS.danger_level = TR.get_danger_level()
		TRS.danger_color = TR.get_danger_color()
		threat_region_displays += TRS
	return threat_region_displays
