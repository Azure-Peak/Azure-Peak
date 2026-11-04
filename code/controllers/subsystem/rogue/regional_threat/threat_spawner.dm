/*
*	So, here's the general idea behind these:
*	These are static threat spawners. They routinely will, at random, generate enemies
*	in the same way that ambushes spawn them - that is, spawning them around random
*	trees/mushrooms/etc within view of the spawner. However, unlike ambushes, THESE
*	mobs will actually stick around and not despawn!
*
*	After a specified time into the round, the threat spawners become "active," and will
*	start a cooldown that is randomized between the min and max time. When the cooldown
*	hits 0, it spawns lingering enemies around any valid targets in much the same way
*	that ambushes spawn enemies. Then it goes on a randomized cooldown again, and the
*	cycle repeats for the rest of the round.
*
*	Spawners only fire at night when they can see the sky, so underground ones run all day.
*	A lit light source anywhere in range stops a spawner. Killing a spawner's whole wave
*	removes one band of threat from its region.
*/

GLOBAL_LIST_INIT(threat_spawner_quantities, list(
	list(1, 2) = 40,
	list(2, 3) = 15,
	list(3, 4) = 3,
	list(4, 6) = 1,
))

GLOBAL_LIST_INIT(threat_spawner_budget_mults, alist(
	0.25 = 50,
	0.35 = 20,
	0.5 = 10,
	1 = 1,
))

/obj/effect/landmark/threatspawner
	name = "static threat spawner"
	icon = 'icons/effects/threat_spawners.dmi'
	icon_state = "threatspawner"
	invisibility = INVISIBILITY_OBSERVER
	var/initial_cooldown = THREAT_SPAWNER_INITIAL_COOLDOWN
	var/spawn_range = THREAT_SPAWNER_RANGE
	var/next_spawn_time = 0
	var/list/mob/living/our_living_mobs = list()

/obj/effect/landmark/threatspawner/Initialize()
	. = ..()
	next_spawn_time = world.time + initial_cooldown
	START_PROCESSING(SSprocessing, src)

/obj/effect/landmark/threatspawner/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/landmark/threatspawner/process()
	if(world.time > next_spawn_time)
		consider_spawning()

/obj/effect/landmark/threatspawner/proc/consider_spawning()
	var/turf/T = get_turf(src)
	if(!T)
		next_spawn_time = world.time + INFINITY
		CRASH("Threat spawner [src] has no turf")
	if(GLOB.tod != "night" && T.can_see_sky())
		next_spawn_time = world.time + THREAT_SPAWNER_RETRY_DELAY
		return FALSE
	if(our_living_mobs.len > 0)
		next_spawn_time = world.time + THREAT_SPAWNER_RETRY_DELAY
		return FALSE

	var/area/AR = get_area(src)
	if(!AR)
		return FALSE

	var/datum/threat_region/TR = null
	if(AR.threat_region)
		TR = SSregionthreat.get_region(AR.threat_region)

	if(!length(AR.ambush_mobs) && isnull(AR.ambush_factions))
		return FALSE
	if(TR && TR.get_danger_level() == DANGER_LEVEL_SAFE)
		start_cooldown()
		return FALSE

	for(var/mob/living/carbon/human/L in range(src, THREAT_SPAWNER_PLAYER_CHECK_RANGE))
		if(L.mind)
			next_spawn_time = world.time + THREAT_SPAWNER_RETRY_DELAY
			return FALSE

	var/lights_around = FALSE
	for(var/obj/O in range(spawn_range, src))
		if(istype(O, /obj/item/flashlight/flare))
			var/obj/item/flashlight/flare/F = O
			if(F.on)
				lights_around = TRUE
				break
		if(istype(O, /obj/machinery/light/rogue))
			var/obj/machinery/light/rogue/L = O
			if(L.on)
				lights_around = TRUE
				break
	if(lights_around)
		start_cooldown()
		return FALSE
	return spawn_threats(AR, TR)

/obj/effect/landmark/threatspawner/proc/spawn_threats(area/AR, datum/threat_region/TR)
	var/list/possible_targets = list()
	for(var/turf/T in RANGE_TURFS(spawn_range, loc))
		if(!istype(T, /turf/open/floor) || istype(AR, /area/rogue/indoors))
			continue
		var/valid_turf = TRUE
		for(var/atom/movable/AM in T.contents)
			if(istype(AM, /obj/structure/flora/roguegrass/maneater/real))
				valid_turf = FALSE
				break
			if(AM.density)
				valid_turf = FALSE
				break
		if(valid_turf)
			possible_targets.Add(T)
	if(!possible_targets.len)
		start_cooldown()
		return FALSE

	var/latent_pool = THREAT_SPAWNER_FALLBACK_LATENT
	var/budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	var/chosen_mult = pickweight(GLOB.threat_spawner_budget_mults)
	if(TR)
		latent_pool = TR.latent_ambush
		budget_pct = TR.ambush_budget_pct
	var/budget = max(chosen_mult * latent_pool * budget_pct, THREAT_SPAWNER_BUDGET_FLOOR)

	var/list/mobs_to_spawn = list()
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

	var/list/affordable = affordable_ambush_entries(faction_candidates, budget)
	var/first_pick = length(affordable) ? pickweight(affordable) : cheapest_ambush_entry(faction_candidates)
	if(!first_pick)
		return FALSE
	var/first_tp = max(get_threat_point(first_pick), 1)
	add_ambush_purchase(first_pick, mobs_to_spawn)
	budget -= first_tp

	var/list/minmax = pickweight(GLOB.threat_spawner_quantities)
	var/max_num_mobs = rand(minmax[1], minmax[2])

	while(budget > 0 && mobs_to_spawn.len < max_num_mobs)
		if(!faction_candidates.len)
			break
		var/picked = pickweight(faction_candidates)
		var/pick_tp = max(get_threat_point(picked), 1)
		if(pick_tp > budget)
			break
		add_ambush_purchase(picked, mobs_to_spawn)
		budget -= pick_tp

	if(!mobs_to_spawn.len)
		return FALSE
	var/spawnedtype = pick(mobs_to_spawn)
	for(var/i in 1 to max_num_mobs)
		var/spawnloc = pick(possible_targets)
		if(!spawnloc)
			continue
		var/mob/living/spawnedmob = new spawnedtype(spawnloc)
		RegisterSignal(spawnedmob, COMSIG_MOB_DEATH, PROC_REF(on_our_mobs_death))
		our_living_mobs.Add(spawnedmob)
		if(iscarbon(spawnedmob))
			var/mob/living/carbon/C = spawnedmob
			for(var/obj/item/organ in C.internal_organs)
				organ.AddComponent(/datum/component/item_on_drop/dust)
	start_cooldown()
	return TRUE

/obj/effect/landmark/threatspawner/proc/on_our_mobs_death(mob/living/source)
	SIGNAL_HANDLER
	our_living_mobs.Remove(source)
	if(our_living_mobs.len)
		return
	var/area/AR = get_area(loc)
	var/datum/threat_region/TR = null
	if(AR?.threat_region)
		TR = SSregionthreat.get_region(AR.threat_region)
	if(TR)
		TR.reduce_latent_ambush(THREAT_POINTS_PER_BAND)
		var/list/mobs_to_message = list()
		var/mob/living/last_hitter = source.lastattacker_weakref?.resolve()
		if(isliving(last_hitter) && last_hitter.mind)
			mobs_to_message.Add(last_hitter)
		for(var/mob/living/L in view(7, src))
			if(L.mind && L != last_hitter)
				mobs_to_message.Add(L)
		for(var/mob/living/L in mobs_to_message)
			to_chat(L, span_notice("<b>The road is safer.</b> This last slain stalker of the road drove 1 band of threat out of the region. However, leaving a light here would prevent more stalkers from turning up around here."), MESSAGE_TYPE_INFO)
	start_cooldown()

/obj/effect/landmark/threatspawner/proc/start_cooldown()
	next_spawn_time = world.time + rand(THREAT_SPAWNER_COOLDOWN_MIN, THREAT_SPAWNER_COOLDOWN_MAX)

/obj/effect/landmark/threatspawner/longinit
	initial_cooldown = THREAT_SPAWNER_INITIAL_COOLDOWN_LONG
	icon_state = "threatspawner-longinit"

/obj/effect/landmark/threatspawner/shortinit
	initial_cooldown = THREAT_SPAWNER_INITIAL_COOLDOWN_SHORT
	icon_state = "threatspawner-shortinit"

/obj/effect/landmark/threatspawner/instant
	initial_cooldown = THREAT_SPAWNER_INITIAL_COOLDOWN_INSTANT
	icon_state = "threatspawner-instant"
