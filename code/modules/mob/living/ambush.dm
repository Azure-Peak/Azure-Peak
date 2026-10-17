GLOBAL_VAR_INIT(ambush_chance_pct, 20) // Please don't raise this over 100 admins :')
GLOBAL_VAR_INIT(ambush_mobconsider_cooldown, 2 MINUTES) // Cooldown for each individual mob being considered for an ambush

GLOBAL_LIST_INIT(melee_combat_skills, list( \
	/datum/skill/combat/swords, \
	/datum/skill/combat/axes, \
	/datum/skill/combat/maces, \
	/datum/skill/combat/polearms, \
	/datum/skill/combat/knives, \
	/datum/skill/combat/whipsflails, \
	/datum/skill/combat/staves, \
	/datum/skill/combat/shields, \
	/datum/skill/combat/unarmed, \
	/datum/skill/combat/wrestling \
))

/proc/is_combat_capable(mob/living/L)
	if(!ishuman(L))
		return FALSE
	var/mob/living/carbon/human/H = L
	if(HAS_TRAIT(H, TRAIT_DODGEEXPERT))
		return TRUE
	if(HAS_TRAIT(H, TRAIT_HEAVYARMOR) || HAS_TRAIT(H, TRAIT_MEDIUMARMOR))
		return TRUE
	if(isarcyne(H))
		return TRUE
	if(H.devotion)
		return TRUE
	for(var/skill in GLOB.melee_combat_skills)
		if(H.get_skill_level(skill) >= SKILL_LEVEL_EXPERT)
			return TRUE
	return FALSE

/proc/get_threat_point(entry)
	if(ispath(entry, /mob/living))
		var/mob/living/M = entry
		return initial(M.threat_point)
	var/datum/npc_warband/warband = get_npc_part(entry)
	if(warband)
		return warband.threat_point
	return 0

/proc/get_faction_tag(entry)
	if(ispath(entry, /mob/living))
		var/mob/living/M = entry
		var/tag = initial(M.ambush_faction)
		if(tag)
			return tag
		// Ensure Archetype have a faction tag, otherwise fallback to the mob's faction list
		var/datum/npc_archetype/archetype = get_npc_part(initial(M.npc_archetype))
		return archetype ? archetype.faction_tag : ""
	var/datum/npc_warband/warband = get_npc_part(entry)
	if(warband)
		return warband.faction_tag
	return ""

/proc/affordable_ambush_entries(list/candidates, budget)
	. = list()
	for(var/entry in candidates)
		if(get_threat_point(entry) <= budget)
			.[entry] = candidates[entry]

/proc/build_ambush_pool(area/AR, datum/threat_region/TR, list/group_pools, list/group_weights)
	. = list()
	var/list/faction_map = AR.ambush_factions
	if(faction_map && !length(faction_map) && TR)
		faction_map = TR.faction_weights

	for(var/fid in faction_map)
		var/datum/quest_faction/F = get_quest_faction(fid)
		if(!F)
			stack_trace("area [AR.type] lists unknown ambush faction [fid]")
			continue
		var/list/sub = list()
		for(var/entry in F.mob_types)
			if(AR.ambush_tp_ceiling && get_threat_point(entry) > AR.ambush_tp_ceiling)
				continue
			sub[entry] = F.mob_types[entry]
			.[entry] += F.mob_types[entry] * faction_map[fid]
		if(!length(sub))
			continue
		group_pools[fid] = sub
		group_weights[fid] = faction_map[fid]

	for(var/entry in AR.ambush_mobs)
		if(AR.ambush_tp_ceiling && get_threat_point(entry) > AR.ambush_tp_ceiling)
			continue
		var/weight = AR.ambush_mobs[entry]
		var/key = get_faction_tag(entry)
		if(!key)
			key = "independent"
		LAZYINITLIST(group_pools[key])
		group_pools[key][entry] += weight
		group_weights[key] += weight
		.[entry] += weight

/proc/cheapest_ambush_entry(list/candidates)
	var/best
	var/best_tp = INFINITY
	for(var/entry in candidates)
		var/tp = get_threat_point(entry)
		if(tp < best_tp)
			best_tp = tp
			best = entry
	return best

/mob/living/proc/ambushable()
	if(stat)
		return FALSE
	if(!mind)
		return FALSE
	return ambushable

/mob/living/proc/consider_ambush(always = FALSE, ignore_cooldown = FALSE, min_dist = 1, max_dist = 9, silent = FALSE, budget_multiplier_floor = 0)
	var/area/AR = get_area(src)
	if(!AR)
		return FALSE

	var/datum/threat_region/TR = null
	if(AR.threat_region)
		TR = SSregionthreat.get_region(AR.threat_region)

	if(!length(AR.ambush_mobs) && isnull(AR.ambush_factions))
		return FALSE

	if(TR)
		if(TR.get_danger_level() == DANGER_LEVEL_SAFE && !always)
			return FALSE
	if(TR && !(always && ignore_cooldown) && ((world.time - TR.last_natural_ambush_time) < AMBUSH_REGION_COOLDOWN))
		return FALSE
	if(!always && prob(100 - GLOB.ambush_chance_pct))
		return FALSE
	if(!always)
		if(HAS_TRAIT(src, TRAIT_AZURENATIVE))
			return FALSE
		if(HAS_TRAIT(src, TRAIT_NOPVE))
			return FALSE
		if(HAS_TRAIT(src, TRAIT_BOGWALKER) && istype(get_area(src), /area/rogue/outdoors/bog))
			return FALSE
		if(world.time > last_client_interact + 0.3 SECONDS)
			return FALSE // unmoving afks can't trigger random ambushes i.e. when being pulled/kicked/etc
	if(get_will_block_ambush())
		return FALSE
	if(mob_timers["ambush_check"] && !ignore_cooldown)
		if(world.time < mob_timers["ambush_check"] + GLOB.ambush_mobconsider_cooldown)
			return FALSE
	mob_timers["ambush_check"] = world.time

	var/player_factor = is_combat_capable(src) ? 1 : 0.5
	var/player_count = 1
	var/list/nearby_victims = list()
	for(var/mob/living/V in view(5, src))
		if(V == src)
			continue
		if(!V.mind)
			continue
		if(!V.ambushable())
			continue
		player_count++
		nearby_victims += V
		player_factor += is_combat_capable(V) ? 1 : 0.5
		if(player_count >= 5)
			break

	var/list/possible_targets = get_possible_ambush_spawn(min_dist, max_dist)
	if(!possible_targets.len)
		return FALSE

	var/latent_pool = 50
	var/budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	if(TR)
		latent_pool = TR.latent_ambush
		budget_pct = TR.ambush_budget_pct
	var/budget = player_factor * latent_pool * budget_pct
	if(budget_multiplier_floor && TR)
		budget = max(budget, budget_multiplier_floor * TR.max_ambush * budget_pct)
	budget = max(budget, AMBUSH_BUDGET_FLOOR)

	var/list/mobs_to_spawn = list()
	var/total_tp_spent = 0

	var/list/group_pools = list()
	var/list/group_weights = list()
	var/list/all_candidates = build_ambush_pool(AR, TR, group_pools, group_weights)
	if(!length(all_candidates))
		return FALSE

	var/list/solvent = list()
	for(var/key in group_weights)
		if(length(affordable_ambush_entries(group_pools[key], budget)))
			solvent[key] = group_weights[key]
	var/anchor_faction = length(solvent) ? pickweight(solvent) : pickweight(group_weights)
	var/list/faction_candidates = group_pools[anchor_faction]

	// 33% surprise chance for cross faction - but exclude the factions itself for good reasons.
	var/list/cross_candidates = list()
	for(var/key in group_pools)
		if(key == anchor_faction)
			continue
		var/list/sub = group_pools[key]
		for(var/entry in sub)
			cross_candidates[entry] += sub[entry] * group_weights[key]
	if(!length(cross_candidates))
		cross_candidates = all_candidates

	var/list/affordable = affordable_ambush_entries(faction_candidates, budget)
	var/first_pick = length(affordable) ? pickweight(affordable) : cheapest_ambush_entry(faction_candidates)
	if(!first_pick)
		return FALSE
	var/first_tp = max(get_threat_point(first_pick), 1) // Floor 1 TP to prevent infinite loops
	add_ambush_purchase(first_pick, mobs_to_spawn)
	budget -= first_tp
	total_tp_spent += first_tp

	// Safety cap in case TP values are misconfigured
	while(budget > 0 && mobs_to_spawn.len < 15)
		var/picked
		if(faction_candidates.len && prob(67))
			picked = pickweight(faction_candidates)
		if(!picked)
			picked = pickweight(cross_candidates)
		if(!picked)
			break

		var/pick_tp = max(get_threat_point(picked), 1)

		if(pick_tp > budget)
			picked = pickweight(cross_candidates)
			if(!picked)
				break
			pick_tp = max(get_threat_point(picked), 1)
			if(pick_tp > budget)
				break

		add_ambush_purchase(picked, mobs_to_spawn)
		budget -= pick_tp
		total_tp_spent += pick_tp

	if(TR)
		var/drain_factor = 1 + (player_count - 1) * 0.5
		var/actual_drain = total_tp_spent * (drain_factor / player_factor)
		TR.reduce_latent_ambush(actual_drain)
		TR.last_natural_ambush_time = world.time

	mob_timers["ambushlast"] = world.time
	for(var/mob/living/V in nearby_victims)
		V.mob_timers["ambushlast"] = world.time

	var/list/aggro_targets = list(src) + nearby_victims

	var/mustype = 1 // 1 = monster scare, 2 = human scare
	for(var/mob_type in mobs_to_spawn)
		var/spawnloc = pick(possible_targets)
		if(!spawnloc)
			continue
		var/mob/living/aggro_target = pick(aggro_targets)
		var/mob/spawnedmob = new mob_type(spawnloc)
		if(istype(spawnedmob, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/M = spawnedmob
			M.attack_same = FALSE
			M.del_on_deaggro = 44 SECONDS
			M.faction += "ambush"
			M.GiveTarget(aggro_target)
		if(istype(spawnedmob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = spawnedmob
			H.faction += "ambush"
			mustype = 2
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(apply_ambush_aggro), spawnedmob, aggro_target), AMBUSH_AGGRO_DELAY)
	if(!silent)
		if(mustype == 1)
			playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
		else
			playsound_local(src, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
		shake_camera(src, 2, 2)
	return TRUE

/proc/apply_ambush_aggro(mob/living/ambusher, mob/living/victim)
	if(QDELETED(ambusher) || QDELETED(victim) || ambusher.stat == DEAD)
		return
	var/datum/ai_controller/controller = ambusher.ai_controller
	if(!istype(controller))
		return
	var/datum/component/ai_aggro_system/aggro_comp = ambusher.GetComponent(/datum/component/ai_aggro_system)
	if(aggro_comp)
		aggro_comp.add_threat_to_mob(victim, AMBUSH_AGGRO_THREAT)
		return
	controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, victim)
	controller.wake_for_combat()
	controller.CancelActions()

/proc/add_ambush_purchase(entry, list/mobs_to_spawn)
	if(ispath(entry, /mob/living))
		mobs_to_spawn += entry
		return
	var/datum/npc_warband/warband = get_npc_part(entry)
	if(warband)
		mobs_to_spawn += warband.expand()

/mob/living/proc/get_will_block_ambush()
	if(!ambushable())
		return TRUE
	var/campfires = 0
	for(var/obj/machinery/light/rogue/RF in view(5, src))
		if(RF.on)
			campfires++
	if(campfires > 0)
		return TRUE

/mob/living/proc/get_possible_ambush_spawn(min_dist = 2, max_dist = 7)
	var/list/possible_targets = list()
	for(var/obj/structure/flora/roguetree/RT in orange(max_dist, src))
		if(istype(RT,/obj/structure/flora/roguetree/stump))
			continue
		if(isturf(RT.loc) && !get_dist(RT.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RT.loc)
	for(var/obj/structure/flora/roguegrass/bush/RB in orange(max_dist, src))
		if(isturf(RB.loc) && !get_dist(RB.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RB.loc)
	for(var/obj/structure/flora/rogueshroom/RX in orange(max_dist, src))
		if(isturf(RX.loc) && !get_dist(RX.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RX.loc)
	for(var/obj/structure/flora/newtree/RS in orange(max_dist, src))
		if(!RS.density)
			continue
		if(isturf(RS.loc) && !get_dist(RS.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RS.loc)
	// Ambush mobs can spawn in aquatic foliage, so they can still occur on the coast which lacks all other objects.
	for(var/obj/structure/flora/roguegrass/water/WF in orange(max_dist, src))
		if(isturf(WF.loc) && !get_dist(WF.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(WF.loc)
	return possible_targets

/proc/get_adjacent_ambush_turfs(turf/T)
	var/list/adjacent = list()
	for(var/turf/AT in get_adjacent_turfs(T))
		if(AT.density || T.LinkBlockedWithAccess(AT, null))
			continue
		adjacent += AT
	return adjacent
