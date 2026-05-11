GLOBAL_VAR_INIT(ambush_chance_pct, 20) // Please don't raise this over 100 admins :')
GLOBAL_VAR_INIT(ambush_mobconsider_cooldown, 2 MINUTES) // Cooldown for each individual mob being considered for an ambush

/// Melee combat skills that count for is_combat_capable(). Ranged skills (bows, crossbows, slings) deliberately excluded.
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

/// Returns TRUE if the mob is considered combat-capable for ambush budget weighting.
/// Combat-capable players count as 1.0 weight (full-strength ambush), non-combat as 0.5 (mercy).
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

/// Helper: get threat_point from an ambush_mobs entry (either a mob path or an ambush_config instance)
/proc/get_threat_point(entry)
	if(ispath(entry, /mob/living))
		var/mob/living/M = entry
		return initial(M.threat_point)
	if(istype(entry, /datum/ambush_config))
		var/datum/ambush_config/AC = entry
		return AC.threat_point
	return 0

/// Helper: get faction_tag from an ambush_mobs entry
/proc/get_faction_tag(entry)
	if(ispath(entry, /mob/living))
		var/mob/living/M = entry
		return initial(M.ambush_faction)
	if(istype(entry, /datum/ambush_config))
		var/datum/ambush_config/AC = entry
		return AC.faction_tag
	return ""

// Instead of setting it on area and hoping no one forgets it on area we're just doing this

/mob/living/proc/ambushable()
	if(stat)
		return FALSE
	if(!mind)
		return FALSE
	return ambushable

/// budget_multiplier_floor: If set, the budget is floored to (budget_multiplier_floor * region max_ambush * AMBUSH_BUDGET_PCT_REGULAR) TP — i.e. N natural ambush equivalents at full pool. Used by signal horn.
/mob/living/proc/consider_ambush(always = FALSE, ignore_cooldown = FALSE, min_dist = 1, max_dist = 9, silent = FALSE, budget_multiplier_floor = 0)
	var/area/AR = get_area(src)
	if(!AR)
		return FALSE

	if(!AR.ambush_mobs)
		return FALSE

	var/datum/threat_region/TR = null
	if(AR.threat_region)
		TR = SSregionthreat.get_region(AR.threat_region)

	// Gate checks — can an ambush even happen right now?
	// Region is considered "safe" when its danger level is SAFE (at or below DANGER_PCT_SAFE% of max).
	// Signal horn (always=TRUE) can still dip below this floor.
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
		if(world.time > last_client_interact + 0.3 SECONDS)
			return FALSE // unmoving afks can't trigger random ambushes i.e. when being pulled/kicked/etc
	if(get_will_block_ambush())
		return FALSE
	if(mob_timers["ambush_check"] && !ignore_cooldown)
		if(world.time < mob_timers["ambush_check"] + GLOB.ambush_mobconsider_cooldown)
			return FALSE
	mob_timers["ambush_check"] = world.time

	// Count nearby players and calculate player factor
	// Combat-capable players = 1.0 weight (full-strength ambush), non-combat = 0.5 weight (mercy — they can't fight back)
	// Capped at 5 players considered. Only mobs with a mind (real players) count.
	var/player_factor = is_combat_capable(src) ? 1 : 0.5
	var/player_count = 1
	var/list/nearby_victims = list()
	for(var/mob/living/V in view(5, src))
		if(V == src)
			continue
		if(!V.mind) // Only count real players, not NPCs
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

	// ——— Budget Calculation ———
	// budget = player_factor * latent_ambush * AMBUSH_BUDGET_PCT_REGULAR
	// At 3%, a solo combat player in Terrorbog (1500) gets 45 TP ≈ 2-3 bogmen.
	// budget_multiplier_floor guarantees N natural ambush equivalents at the region's full pool.
	// Minimum budget of 10 so something always spawns.
	var/latent_pool = 50 // Fallback if no region
	if(TR)
		latent_pool = TR.latent_ambush
	var/budget = player_factor * latent_pool * AMBUSH_BUDGET_PCT_REGULAR
	if(budget_multiplier_floor && TR)
		budget = max(budget, budget_multiplier_floor * TR.max_ambush * AMBUSH_BUDGET_PCT_REGULAR)
	budget = max(budget, 10) // Floor: always afford at least one trash mob

	// ——— Purchase Loop ———
	// Pick entries from ambush_mobs, spending budget until depleted.
	// First pick sets the "anchor faction". Subsequent picks: 67% same faction, 33% any entry.
	// The last purchase is allowed to exceed the budget (budget can go negative).
	var/list/mobs_to_spawn = list() // flat list of mob type paths to spawn
	var/total_tp_spent = 0
	var/anchor_faction = ""

	// Build same-faction and all-faction candidate sublists for efficiency
	// We do this once, outside the loop
	var/list/all_candidates = list() // entry = weight
	var/list/faction_candidates = list() // populated after first pick sets anchor

	for(var/entry in AR.ambush_mobs)
		all_candidates[entry] = AR.ambush_mobs[entry]

	// First purchase — sets the anchor faction
	var/first_pick = pickweight(all_candidates)
	var/first_tp = max(get_threat_point(first_pick), 1) // Floor 1 TP to prevent infinite loops
	anchor_faction = get_faction_tag(first_pick)
	add_ambush_purchase(first_pick, mobs_to_spawn)
	budget -= first_tp
	total_tp_spent += first_tp

	// Build same-faction sublist now that we know anchor
	if(anchor_faction != "")
		for(var/entry in all_candidates)
			if(get_faction_tag(entry) == anchor_faction)
				faction_candidates[entry] = all_candidates[entry]

	// Continue purchasing while we have budget
	// Safety cap: never spawn more than 15 mobs even if TP values are misconfigured
	while(budget > 0 && mobs_to_spawn.len < 15)
		var/picked
		// 67% same-faction pick if we have faction candidates, 33% any entry ("wrong faction" surprise)
		if(faction_candidates.len && prob(67))
			picked = pickweight(faction_candidates)
		if(!picked) // Fallback to all candidates if faction pick failed or wasn't attempted
			picked = pickweight(all_candidates)
		if(!picked) // Nothing left to pick from at all — bail out
			break

		var/pick_tp = max(get_threat_point(picked), 1) // Floor 1 TP to prevent infinite loops from unconfigured mobs

		// If this pick would overshoot the budget, try a cross-faction pick for something cheaper
		if(pick_tp > budget)
			picked = pickweight(all_candidates)
			if(!picked)
				break
			pick_tp = max(get_threat_point(picked), 1)
			// If even the cross-faction pick overshoots, stop — don't blow the budget
			if(pick_tp > budget)
				break

		add_ambush_purchase(picked, mobs_to_spawn)
		budget -= pick_tp
		total_tp_spent += pick_tp

	// ——— Reduce latent_ambush by total TP spent ———
	// Additive group drain: first player drains at 1x, each additional player adds 0.5x.
	// Solo = 1x, duo = 1.5x, trio = 2x, quad = 2.5x, 5-man = 3x.
	if(TR)
		var/drain_factor = 1 + (player_count - 1) * 0.5
		var/actual_drain = total_tp_spent * (drain_factor / player_factor)
		TR.reduce_latent_ambush(actual_drain)
		TR.last_natural_ambush_time = world.time

	// ——— Spawn the purchased mobs ———
	mob_timers["ambushlast"] = world.time
	for(var/mob/living/V in nearby_victims)
		V.mob_timers["ambushlast"] = world.time

	// Build target pool: triggerer + all nearby victims. Each spawned mob picks a random target.
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
	if(!silent)
		if(mustype == 1)
			playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
		else
			playsound_local(src, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
		shake_camera(src, 2, 2)
	return TRUE

/// Expands an ambush purchase (mob path or ambush_config) into the flat mobs_to_spawn list.
/proc/add_ambush_purchase(entry, list/mobs_to_spawn)
	if(ispath(entry, /mob/living))
		mobs_to_spawn += entry
	else if(istype(entry, /datum/ambush_config))
		var/datum/ambush_config/AC = entry
		for(var/type_path in AC.mob_types)
			var/amt = AC.mob_types[type_path]
			for(var/i in 1 to amt)
				mobs_to_spawn += type_path

// Return whether a mob is blocked from being ambushed
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
