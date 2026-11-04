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
*/

GLOBAL_VAR_INIT(threatspawner_cd_min, 10 MINUTES)
GLOBAL_VAR_INIT(threatspawner_cd_max, 17 MINUTES)
// Determines different min/max possible ranges for # of enemies spawned.
// Makes it much more common that only a couple enemies spawn
// while making it unlikely but possible that a bunch of enemies spawn as a !!FUN SURPRISE!!
GLOBAL_LIST_INIT(threatspawner_quantities, list(
	list(1,2) = 40,
	list(2,3) = 15,
	list(3,4) = 3,
	list(4,6) = 1,
))


/obj/effect/landmark/threatspawner
	name = "static threat spawner"
	icon = 'icons/effects/threat_spawners.dmi'
	icon_state = "threatspawner"
	invisibility = INVISIBILITY_OBSERVER
	/// How long we wait at round start before becoming active
	var/inital_cooldown = 30 MINUTES
	/// Max range around us to search for spots to spawn mobs
	var/spawn_range = 5
	/// The time at which we will spawn more mobs
	var/next_spawn_time = 0
	/// List of our spawned mobs who are still able to fight
	var/list/mob/living/our_living_mobs = list()

/obj/effect/landmark/threatspawner/Initialize()
	. = ..()
	next_spawn_time = world.time + inital_cooldown
	START_PROCESSING(SSprocessing, src)

/obj/effect/landmark/threatspawner/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/effect/landmark/threatspawner/process()
	if(world.time > next_spawn_time)
		consider_spawning()

/obj/effect/landmark/threatspawner/proc/consider_spawning()
	var/turf/T = get_turf(src)
	if(!T)
		next_spawn_time = world.time + INFINITY
		CRASH("A threat spawner doesn't have a valid turf... SOMEHOW!")
	// If we're an outdoors spawner and it's not nighttime, we'll wait a bit and check again
	// This way spawners in places like the Underdark are effectively active 24/7
	// Dangers that rely on the dark thrive where it is always dark
	if(GLOB.tod != "night" && T.can_see_sky())
		next_spawn_time = world.time + 1 MINUTES
		return FALSE
	// If we have spawned mobs that are still alive, wait a while longer.
	if(our_living_mobs.len > 0)
		next_spawn_time = world.time + 1 MINUTES
		return FALSE

	var/area/AR = get_area(src)
	if(!AR)
		return FALSE

	var/datum/threat_region/TR = null
	if(AR.threat_region)
		TR = SSregionthreat.get_region(AR.threat_region)

	if(!length(AR.ambush_mobs) && isnull(AR.ambush_factions))
		return FALSE
	// Check our threat region, and if it has anything for us to spawn
	if(TR)
		if(TR.get_danger_level() == DANGER_LEVEL_SAFE)
			// If it's safe then I guess we won't be active anytime soon
			start_cooldown()
			return FALSE

	// Make sure no living player is able to see us or anything we might spawn!
	for(var/mob/living/carbon/human/L in range(src, spawn_range + 7))
		if(L.mind)
			// If there are viewers, we'll just wait a bit and then try again.
			next_spawn_time = world.time + 1 MINUTES
			return FALSE
	// Now, make sure we don't have any lit objects around us!
	// (This way we don't wind up spawning dudes in a space a player might be building in)
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
		// If there are, well, guess we'll wait a good while before checking again.
		start_cooldown()
		return FALSE
	return spawn_threats(AR, TR)

/obj/effect/landmark/threatspawner/proc/spawn_threats(area/AR, datum/threat_region/TR)
	var/list/possible_targets = list()
	// Look for turfs that are unobscured and have nothing in the way!
	var/list/turf/turfs_around = RANGE_TURFS(spawn_range, loc)
	for(var/turf/T in turfs_around)
		// Must be on a valid, standable floor that is not indoors
		// (This still allows them to spawn in the underdark as underdark areas are in /area/rogue/under)
		if(!istype(T, /turf/open/floor) || istype(AR, /area/rogue/indoors))
			continue
		var/valid_turf = TRUE
		for(var/atom/movable/AM in T.contents)
			// Don't spawn them on top of the thing that kills you
			if(istype(AM, /obj/structure/flora/roguegrass/maneater/real))
				valid_turf = FALSE
				break
			// Don't spawn them on obstructed turfs, either
			if(AM.density)
				valid_turf = FALSE
				break
		if(valid_turf)
			possible_targets.Add(T)
	// sanity check. We shouldn't ever have this happen but uuhhhhh??????
	if(!possible_targets.len)
		start_cooldown()
		return FALSE
	// SHAMELESSLY stealing MOST OF THIS from ambush code,
	// since we should be using very similar logic as it for choosing what mobs we spawn!

	// ——— BUDGET PREPARATION ———
	var/latent_pool = 50 // Fallback if no region
	var/budget_pct = AMBUSH_BUDGET_PCT_REGULAR

	// Budget is randomized but is most likely to be low to keep mob spawns reasonable for a static spawner
	// While we're drawing from the ambush pool, We aren't spawning ambushes everywhere.
	// Think of these as "mini-mini ambushes".
	// However, in VERY rare circumstances, we'll spawn a whole-ass regular ambush.
	var/alist/static_spawner_mults = alist(
		0.25 = 50, // Most likely going to be cutting our budget to 25%
		0.35 = 20, // 35%
		0.5 = 10, // 50%
		1 = 1, // 100% of our budget retained. VERY rare outcome that we'll be mean as fuck
	)
	var/chosen_mult = pickweight(static_spawner_mults)
	if(TR)
		latent_pool = TR.latent_ambush
		budget_pct = TR.ambush_budget_pct
	var/budget = chosen_mult * latent_pool * budget_pct
	budget = max(budget, 10) // Floor: always afford at least one trash mob

	// ——— MOB SPAWN POOL PREPARATION / PURCHASE LOOP ———
	var/list/mobs_to_spawn = list() // flat list of mob type paths to spawn
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

	var/list/affordable = affordable_ambush_entries(faction_candidates, budget)
	var/first_pick = length(affordable) ? pickweight(affordable) : cheapest_ambush_entry(faction_candidates)
	if(!first_pick)
		return FALSE
	var/first_tp = max(get_threat_point(first_pick), 1) // Floor 1 TP to prevent infinite loops
	add_ambush_purchase(first_pick, mobs_to_spawn)
	budget -= first_tp
	total_tp_spent += first_tp

	// Determine the minimum and maximum possible quantity of dudes we'll spawn
	var/list/minmax = pickweight(GLOB.threatspawner_quantities)
	var/max_num_mobs = rand(minmax[1], minmax[2])

	// Continue purchasing while we have budget
	// Safety cap: never spawn more than our random cap of mobs even if TP values are misconfigured
	while(budget > 0 && mobs_to_spawn.len < max_num_mobs)
		var/picked
		if(faction_candidates.len)
			picked = pickweight(faction_candidates)
		else // Nothing left to pick from at all — bail out
			break

		var/pick_tp = max(get_threat_point(picked), 1) // Floor 1 TP to prevent infinite loops from unconfigured mobs

		// If this pick would overshoot the budget, stop — don't blow the budget
		if(pick_tp > budget)
			break

		add_ambush_purchase(picked, mobs_to_spawn)
		budget -= pick_tp
		total_tp_spent += pick_tp

	// ——— SPAWNING PHASE ———
	// Now we actually spawn the dudes!!
	var/spawnedtype
	if(mobs_to_spawn.len)
		var/mob_index = rand(1, mobs_to_spawn.len)
		spawnedtype = mobs_to_spawn[mob_index]
		mobs_to_spawn.Cut(mob_index, mob_index + 1)
	else
		return FALSE
	for(var/i in 1 to max_num_mobs)
		var/spawnloc = pick(possible_targets)
		if(spawnloc)
			var/mob/living/spawnedmob = new spawnedtype(spawnloc)
			// Make sure we're properly tracking the spawned mob
			RegisterSignal(spawnedmob, COMSIG_MOB_DEATH, PROC_REF(on_our_mobs_death))
			our_living_mobs.Add(spawnedmob)
			// Also, make it so their organs dust on drop to stop wild animals eating corpses from turning roads into walkways of gore
			if(iscarbon(spawnedmob))
				var/mob/living/carbon/C = spawnedmob
				for(var/obj/item/organ in C.internal_organs)
					organ.AddComponent(/datum/component/item_on_drop/dust)
	start_cooldown()
	return TRUE

/obj/effect/landmark/threatspawner/proc/on_our_mobs_death(mob/living/source)
	our_living_mobs.Remove(source)
	// If that was our last mob...
	if(our_living_mobs.len < 1)
		var/area/AR = get_area(loc)
		var/datum/threat_region/TR = null
		if(AR.threat_region)
			TR = SSregionthreat.get_region(AR.threat_region)
		if(TR)
			// Remove one band of threat from the region.
			TR.reduce_latent_ambush(THREAT_POINTS_PER_BAND)
			// Also notify everyone in sight of the dying mob AND whoever last attacked them
			// We get the last hitter as a separate mob from everyone in view of it in case they aren't actually in view (i.e. sniping from afar)
			var/list/mobs_to_message = list()
			var/mob/living/last_hitter = source.lastattacker_weakref?.resolve()
			if(isliving(last_hitter) && last_hitter.mind)
				mobs_to_message.Add(last_hitter)
			for(var/mob/living/L in view(7, src))
				if(L.mind && L != last_hitter)
					mobs_to_message.Add(L)
			for(var/mob/living/L in mobs_to_message)
				to_chat(L, span_notice("<b>The road is safer.</b> This last slain stalker of the road drove 1 band of threat out of the region. However, leaving a light here would prevent more stalkers from turning up around here."), MESSAGE_TYPE_INFO)
		// Also start a cooldown before we make more mobs!
		start_cooldown()

/// Returns the type of the mob that the spawner will create
/obj/effect/landmark/threatspawner/proc/get_mob_spawn_type(area/AR, datum/threat_region/TR)
	return pickweight(AR.ambush_mobs)

/obj/effect/landmark/threatspawner/proc/start_cooldown()
	next_spawn_time = world.time + rand(GLOB.threatspawner_cd_min, GLOB.threatspawner_cd_max)

// Subtype of threat spawner with a longer initial cooldown,
// intended for places that will probably take a while before being cleared / lit.
/obj/effect/landmark/threatspawner/longinit
	inital_cooldown = 45 MINUTES
	icon_state = "threatspawner-longinit"

// Subtype of threat spawner with a short initial cooldown,
// intended for places that will be cleared out / lit pretty early on in the round.
/obj/effect/landmark/threatspawner/shortinit
	inital_cooldown = 15 MINUTES
	icon_state = "threatspawner-shortinit"

// Subtype of threat spawner that instantly starts attempting
// to spawn its threats at the start of the round.
/obj/effect/landmark/threatspawner/instant
	inital_cooldown = 1 SECONDS
	icon_state = "threatspawner-instant"
