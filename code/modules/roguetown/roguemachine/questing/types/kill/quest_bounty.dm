GLOBAL_LIST_INIT(quest_bounty_goblin_goons, list(
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc/bomber,
))

/datum/quest/kill/bounty
	quest_type = QUEST_BOUNTY
	chronicle_order = QUEST_CHRONICLE_ORDER_BOUNTY
	quest_difficulty = QUEST_DIFFICULTY_HARD
	pool_kind = QUEST_POOL_KILL
	pool_weight = QUEST_POOL_WEIGHT_BOUNTY
	rumor_cost = RUMOR_COST_MAJOR
	defense_cost = BURGHER_PLEDGE_COST_MAJOR
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_UNDERDARK,
	)
	tp_budget = QUEST_TP_BUDGET_BOUNTY_GOONS
	threat_bands_cleared = QUEST_BANDS_BOUNTY
	required_fellowship_size = 2
	fellowship_threat_rate = QUEST_FELLOWSHIP_THREAT_PER_EXTRA_HARD
	fellowship_reward_rate = QUEST_FELLOWSHIP_REWARD_PER_EXTRA
	var/boss_name
	var/goblin_warlord_variant = FALSE

/datum/quest/kill/bounty/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	bind_landmark(landmark)
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return FALSE
	faction = pick_region_faction_for(TR)
	if(!faction)
		return FALSE
	faction_id = faction.id
	// Scale goon budget by regional danger, then roll variance.
	tp_budget = roll_tp_budget(tp_budget, TR.tp_budget_multiplier)
	// 20% chance: goblin warlord variant overrides boss type and goon pool.
	if(prob(20))
		goblin_warlord_variant = TRUE
		target_mob_type = /mob/living/carbon/human/species/goblin/npc/large
		var/datum/quest_faction/goblin_faction = get_quest_faction(QUEST_FACTION_FOREST_GOBLIN)
		boss_name = goblin_faction ? goblin_faction.generate_boss_name() : "the Goblin Warchief"
	else
		target_mob_type = faction.pick_boss_mob_type()
		if(!target_mob_type)
			return FALSE
		boss_name = faction.generate_boss_name()
	progress_required = 1
	finalize_preview_title()
	return TRUE

/datum/quest/kill/bounty/get_named_target()
	return boss_name

/datum/quest/kill/bounty/get_title()
	if(title)
		return title
	if(!boss_name)
		return "Bring down a notorious outlaw"
	return "Bring down [boss_name]"

/datum/quest/kill/bounty/get_objective_text()
	if(!boss_name)
		return "Slay [initial(target_mob_type.name)]."
	return "Slay [boss_name] and the gang that shelters them."

/datum/quest/kill/bounty/get_additional_reward(turf/origin_turf, turf/target_turf)
	if(!target_mob_type)
		return 0
	var/boss_threat = initial(target_mob_type.threat_point) || 0
	var/goon_threat = (total_spawned_tp > 0) ? total_spawned_tp : round(tp_budget * fellowship_threat_mult)
	return (boss_threat * QUEST_BOUNTY_THREAT_MULT) + (goon_threat * QUEST_KILL_THREAT_MULT)

/datum/quest/kill/bounty/estimate_mob_count()
	return 1

/datum/quest/kill/bounty/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!faction)
		return FALSE
	spawn_hidden_mob(landmark, target_mob_type)
	spawn_goons(landmark)
	progress_required = 1
	addtimer(CALLBACK(src, PROC_REF(apply_boss_name)), 2 SECONDS)
	return TRUE

/datum/quest/kill/bounty/proc/apply_boss_name()
	for(var/datum/weakref/ref in tracked_atoms)
		var/mob/living/M = ref.resolve()
		if(QDELETED(M))
			continue
		if(!istype(M, target_mob_type))
			continue
		M.real_name = boss_name
		M.name = boss_name

/datum/quest/kill/bounty/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark)
	if(goblin_warlord_variant)
		spawn_goblin_horde(landmark)
		return
	var/list/to_spawn = compose_warband()
	total_spawned_tp = 0
	for(var/goon_type in to_spawn)
		var/mob/living/goon = spawn_hidden_mob(landmark, goon_type, is_target = FALSE)
		if(goon)
			total_spawned_tp += initial(goon.threat_point) || 0

/datum/quest/kill/bounty/proc/spawn_goblin_horde(obj/effect/landmark/quest_spawner/landmark)
	total_spawned_tp = 0
	for(var/i in 1 to rand(5, 9))
		var/mob/living/goon = spawn_hidden_mob(landmark, pick(GLOB.quest_bounty_goblin_goons), is_target = FALSE, tag_faction = FALSE)
		if(goon)
			total_spawned_tp += initial(goon.threat_point) || 0

/datum/quest/kill/bounty/faction_fits(datum/quest_faction/F)
	return ..() && length(F.boss_mob_types)
