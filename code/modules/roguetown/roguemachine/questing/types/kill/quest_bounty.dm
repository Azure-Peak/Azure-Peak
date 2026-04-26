/// Goblin goon pool used when the goblin warlord variant fires on a bounty quest.
GLOBAL_LIST_INIT(quest_bounty_goblin_goons, list(
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc/bomber,
))

/datum/quest/kill/bounty
	quest_type = QUEST_BOUNTY
	tp_budget = QUEST_TP_BUDGET_BOUNTY_GOONS
	threat_bands_cleared = QUEST_BANDS_BOUNTY
	required_fellowship_size = 2
	/// Generated boss name for title/objective. Set at preview.
	var/boss_name
	/// If TRUE, the boss is a large goblin and goons are drawn from quest_bounty_goblin_goons
	/// instead of the region faction. Rolled at preview time.
	var/goblin_warlord_variant = FALSE

/datum/quest/kill/bounty/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region
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
	var/goon_threat = (total_spawned_tp > 0) ? total_spawned_tp : tp_budget
	return (boss_threat * QUEST_BOUNTY_THREAT_MULT) + (goon_threat * QUEST_KILL_THREAT_MULT)

/// Override — bounty progress is fixed at 1 (the boss), regardless of goon count.
/datum/quest/kill/bounty/estimate_mob_count()
	return 1

/datum/quest/kill/bounty/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!faction)
		return FALSE
	spawn_boss(landmark)
	spawn_goons(landmark)
	progress_required = 1
	// Rename the boss mob after a delay so subtype after_creation() doesn't clobber it.
	// Some subtypes (e.g. large_goblin) call after_creation on a 1s timer and set their own name.
	addtimer(CALLBACK(src, PROC_REF(apply_boss_name)), 2 SECONDS)
	return TRUE

/datum/quest/kill/bounty/proc/spawn_boss(obj/effect/landmark/quest_spawner/landmark)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return
	var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
	var/mob/living/boss = new target_mob_type(spawn_effect)
	boss.faction |= "quest"
	if(faction?.faction_tag)
		boss.faction |= faction.faction_tag
	boss.AddComponent(/datum/component/quest_object/kill, src)
	ADD_TRAIT(boss, TRAIT_FRESHSPAWN, "[type]")
	addtimer(TRAIT_CALLBACK_REMOVE(boss, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
	spawn_effect.contained_atom = boss
	spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
	register_spawner(spawn_effect)
	add_tracked_atom(boss)
	landmark.add_quest_faction_to_nearby_mobs(spawn_turf)

/datum/quest/kill/bounty/proc/apply_boss_name()
	for(var/datum/weakref/ref in tracked_atoms)
		var/mob/living/M = ref.resolve()
		if(QDELETED(M))
			continue
		if(!istype(M, target_mob_type))
			continue
		M.real_name = boss_name
		M.name = boss_name

/// Spawn goons alongside the bounty boss. Uses goblin horde pool for the warlord variant;
/// otherwise spends TP budget drawing from the region faction.
/datum/quest/kill/bounty/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark)
	if(goblin_warlord_variant)
		spawn_goblin_horde(landmark)
		return
	var/list/to_spawn = compose_warband()
	total_spawned_tp = 0
	for(var/goon_type in to_spawn)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/mob/living/goon = new goon_type(spawn_effect)
		goon.faction |= "quest"
		if(faction?.faction_tag)
			goon.faction |= faction.faction_tag
		ADD_TRAIT(goon, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(goon, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		spawn_effect.contained_atom = goon
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawn_effect)
		total_spawned_tp += initial(goon.threat_point) || 0

/// Spawns 5-9 mixed goblin goons for the goblin warlord variant.
/datum/quest/kill/bounty/proc/spawn_goblin_horde(obj/effect/landmark/quest_spawner/landmark)
	total_spawned_tp = 0
	for(var/i in 1 to rand(5, 9))
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/goon_path = pick(GLOB.quest_bounty_goblin_goons)
		var/mob/living/goon = new goon_path(spawn_effect)
		goon.faction |= "quest"
		ADD_TRAIT(goon, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(goon, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		spawn_effect.contained_atom = goon
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawn_effect)
		total_spawned_tp += initial(goon.threat_point) || 0
