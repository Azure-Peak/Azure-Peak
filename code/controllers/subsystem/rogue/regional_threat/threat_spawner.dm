/*
*	These are static threat spawners. They routinely will, at random, generate enemies
*	in a similar way as an ambush, although instead it spawns them on "open" (non-obstructed)
*   terrain. However, unlike ambushes, THESE mobs will actually stick around and not despawn!
*
*	After a specified grace period at round start, the threat spawners become "active," and will
*	start a cooldown that is randomized between the min and max time. When the cooldown
*	hits 0, it spawns lingering enemies on any valid terrain surrounding the spawner if there are
*	no players around to witness the enemies being spawned, (to make it appear as though the
*	enemies had always been there.)
*	It then goes on a randomized cooldown again, and the cycle repeats for the rest of the round.
*
*	However, if a lit object (i.e. brazier, torch, etc.) is in the "area of effect" of a spawner, it will
*	not spawn threats - with a caveat. The caveat being that there is a chance the spawner will
*	extinguish all lit objects in its range and force a mob spawning right afterward, (so long as
*	there are no players around to witness this.)
*
*	The philosophy behind these is that these should be placed in locations where one should expect
*	some level of danger, (threat regions are mandatory for them to work.) Ambushes and contracts
*	don't really give you much of a sense of how "dangerous" a region is and feel rather gamey.
*	With these, there are actual, unpredictable, lingering threats that routinely appear. These give
*	the player a textured view of how dangerous a region is and make the world feel more organic and
*	alive, as well as feel more responsive and representative of the threat level system. Their inner
*	workings have RNG within RNG within RNG by design, to keep them unpredictable and difficult to
*	metagame beyond their locations and the intended way of suppressing them. And even when they are
*	"Suppressed," there is no guarantee of safety... Because this world is never an entirely safe one.
*
*/

GLOBAL_LIST_INIT(threat_spawner_budget_mults, alist(
	0.25 = 50, // 25% of our budget will be the most common budget allowance for mob spawning
	0.35 = 20, // 35%
	0.5 = 10, // 50%
	1 = 1, // Very rarely we'll actually have our entire budget and will be MEAN with it
))

/obj/effect/landmark/threatspawner
	name = "static threat spawner"
	icon = 'icons/effects/threat_spawners.dmi'
	icon_state = "threatspawner"
	invisibility = INVISIBILITY_OBSERVER
	/// Initial grace period at round start before we start spawning mobs.
	var/initial_cooldown = THREAT_SPAWNER_INITIAL_COOLDOWN
	var/spawn_range = THREAT_SPAWNER_RANGE
	var/next_spawn_time = 0
	var/list/mob/living/our_living_mobs = list()
	var/wave_tp_spent = 0
	/// The % chance that every time we consider spawning mobs, we'll knock out all lights around us to force spawning.
	var/lights_extinguish_chance = 20
	/// List of types of lights that will be ignored when looking for lights that keep our spawning functionality disabled.
	var/list/ignored_light_types = list(
		/obj/machinery/light/roguestreet, // Literally cannot be turned off and are all over the Underdark and mountain, so we'll just ignore these
	)

/obj/effect/landmark/threatspawner/Initialize(mapload = FALSE)
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
#ifndef SPAWNER_DEBUGGING_MODE
	if(GLOB.tod != "night" && T.can_see_sky())
		next_spawn_time = world.time + THREAT_SPAWNER_RETRY_DELAY
		return FALSE
#endif
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

	// If there are players who are in our range, (or who can potentially see into our area of effect,)
	// do nothing and wait a minute before trying again!
	for(var/mob/living/carbon/human/L in range(src, THREAT_SPAWNER_PLAYER_CHECK_RANGE))
		if(L.mind)
			next_spawn_time = world.time + THREAT_SPAWNER_RETRY_DELAY
			return FALSE

	var/lights_around = FALSE
	// If there are lights around us, there's a chance we may knock the lights out around us
	// so that we can keep spawning mobs.
	// This way we aren't rendered a non-threat for the rest of the round just because
	// someone built a light roundstart and then forgot about us.
	var/is_killing_lights = prob(lights_extinguish_chance)
	for(var/obj/O in range(spawn_range, src))
		for(var/light_type in ignored_light_types)
			if(istype(O, light_type))
				continue
		if(istype(O, /obj/item/flashlight/flare))
			var/obj/item/flashlight/flare/F = O
			if(F.on)
				if(is_killing_lights)
					F.extinguish()
				else
					lights_around = TRUE
					break
		if(istype(O, /obj/machinery/light/rogue))
			var/obj/machinery/light/rogue/L = O
			if(L.on)
				if(is_killing_lights)
					L.extinguish()
				else
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

	// Budget floor for ambush spawner is determined by the region. It is a random slice of the current threat in the region
	// It is floored at a share of the maximum so something always spawn
	var/latent_pool = THREAT_SPAWNER_FALLBACK_LATENT
	var/budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	var/chosen_mult = pickweight(GLOB.threat_spawner_budget_mults)
	var/budget_floor = THREAT_SPAWNER_BUDGET_FLOOR
	if(TR)
		latent_pool = TR.latent_ambush
		budget_pct = TR.ambush_budget_pct
		budget_floor = max(budget_floor, THREAT_SPAWNER_BUDGET_FLOOR_MULT * TR.max_ambush * budget_pct)
	var/budget = max(chosen_mult * latent_pool * budget_pct, budget_floor)

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
	var/total_tp_spent = first_tp

	while(budget > 0 && mobs_to_spawn.len < THREAT_SPAWNER_MAX_MOBS)
		var/list/affordable_now = affordable_ambush_entries(faction_candidates, budget)
		if(!length(affordable_now))
			break
		var/picked = pickweight(affordable_now)
		var/pick_tp = max(get_threat_point(picked), 1)
		add_ambush_purchase(picked, mobs_to_spawn)
		budget -= pick_tp
		total_tp_spent += pick_tp

	if(!mobs_to_spawn.len)
		return FALSE
	wave_tp_spent = total_tp_spent
	for(var/mob_type in mobs_to_spawn)
		var/spawnloc = pick(possible_targets)
		if(!spawnloc)
			continue
		var/mob/living/spawnedmob = new mob_type(spawnloc)
		RegisterSignal(spawnedmob, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), PROC_REF(on_our_mobs_death))
		our_living_mobs.Add(spawnedmob)
		if(iscarbon(spawnedmob))
			var/mob/living/carbon/C = spawnedmob
			for(var/obj/item/organ in C.internal_organs)
				organ.AddComponent(/datum/component/item_on_drop/dust)
	start_cooldown()
	return TRUE

/obj/effect/landmark/threatspawner/proc/on_our_mobs_death(mob/living/source)
	SIGNAL_HANDLER
	if(!(source in our_living_mobs))
		return
	UnregisterSignal(source, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING))
	our_living_mobs.Remove(source)
	if(our_living_mobs.len)
		return
	var/area/AR = get_area(loc)
	var/datum/threat_region/TR = null
	if(AR?.threat_region)
		TR = SSregionthreat.get_region(AR.threat_region)
	if(TR && wave_tp_spent > 0)
		TR.reduce_latent_ambush(wave_tp_spent)
		var/list/mobs_to_message = list()
		var/mob/living/last_hitter = source.lastattacker_weakref?.resolve()
		if(isliving(last_hitter) && last_hitter.mind)
			mobs_to_message.Add(last_hitter)
		for(var/mob/living/L in view(7, src))
			if(L.mind && L != last_hitter)
				mobs_to_message.Add(L)
		for(var/mob/living/L in mobs_to_message)
			to_chat(L, span_notice("<b>The road is safer.</b> The last member of this band is slain, and the threat upon the region ebbs a little. Leaving a light here would keep more from gathering."), MESSAGE_TYPE_INFO)
	wave_tp_spent = 0
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
