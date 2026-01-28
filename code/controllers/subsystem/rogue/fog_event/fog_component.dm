/datum/component/fogged
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/ambush_chance = 5
	var/last_ambush_time = 0
	var/fog_enter_time = 0
	var/ambush_in_progress = FALSE
	var/ambush_grace_period = 5 SECONDS

/datum/component/fogged/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	fog_enter_time = world.time
	var/mob/living/L = parent
	if(!HAS_TRAIT(L, TRAIT_FOG_WARDED))
		L.apply_status_effect(/datum/status_effect/debuff/fog_chilled)
	// Listen for movement
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_moved)
	RegisterSignal(parent, COMSIG_WARDED_TRAIT_CHANGE, .proc/handle_ward_change)

/datum/component/fogged/Destroy()
	var/mob/living/L = parent
	L.remove_status_effect(/datum/status_effect/debuff/fog_chilled)
	return ..()

/datum/component/fogged/proc/on_moved()
	if(HAS_TRAIT(parent, TRAIT_FOG_WARDED))
		return FALSE
	// If there's no fog event, get rid of the component!
	if(!SSevent_scheduler.fog_active)
		qdel(src)

	var/mob/living/L = parent
	if(L.mob_timers["ambush_cooldown"] && world.time < L.mob_timers["ambush_cooldown"])
		return

	// Roll dice
	if(prob(ambush_chance))
		trigger_ambush()

/datum/component/fogged/proc/trigger_ambush()
	// Let's make sure people can at least get across small distances, hmm?
	if(world.time - ambush_grace_period < fog_enter_time)
		return
	// Calculating a big ambush is expensive, so let's make sure it doesn't trigger multiple times.
	if(ambush_in_progress)
		return

	ambush_in_progress = TRUE
	var/mob/living/victim_prime = parent
	var/turf/T = get_turf(victim_prime)

	var/list/mob/living/valid_victims = list()
	var/total_ambush_score = 20

	for(var/mob/living/potential in view(7, victim_prime))
		if(potential.stat == DEAD)
			continue

		// Must have the fog component to contribute to the "Fog Ambush"
		var/datum/component/fogged/F = potential.GetComponent(/datum/component/fogged)
		if(!F)
			continue

		// Must not be on cooldown
		if(potential.mob_timers["ambush_cooldown"] && world.time < potential.mob_timers["ambush_cooldown"])
			continue

		valid_victims += potential

		// Calculate Score per Victim
		total_ambush_score += calculate_victim_score(potential, F.fog_enter_time)

	if(!length(valid_victims))
		ambush_in_progress = FALSE
		return // No valid targets

	var/list/spawn_candidates = get_fog_ambush_spawn(2, 6)
	playsound(T, 'sound/misc/jumpscare (1).ogg', 75, TRUE)

	if(!length(spawn_candidates))
		ambush_in_progress = FALSE
		return // Nowhere to spawn

	var/cooldown_penalty = 0
	// Just in case people do something silly, I'd rather not melt the server.
	var/max_mobs = 8
	var/current_mobs = 0

	while(total_ambush_score > 0 && current_mobs < max_mobs)
		var/datum/ambush_entry/encounter = select_ambush_encounter(total_ambush_score)

		if(!encounter)
			break // Nothing left that we can afford

		var/turf/spawn_turf = pick(spawn_candidates)
		var/list/spawned_mobs = encounter.spawn_at(spawn_turf)

		for(var/mob/living/simple_animal/hostile/H in spawned_mobs)
			H.faction += "ambush"
			// Appears to be bugged sire
			//H.GiveTarget(pick(valid_victims))
			current_mobs++

		// Deduct from budget and track for cooldown
		total_ambush_score -= encounter.unlock_score
		cooldown_penalty += encounter.point_cost

	if(current_mobs <= 0)
		ambush_in_progress = FALSE
		return

	var/final_cooldown = 40 SECONDS + (cooldown_penalty * 0.2 SECONDS)

	for(var/mob/living/V in valid_victims)
		V.mob_timers["ambush_cooldown"] = world.time + final_cooldown
		to_chat(V, span_userdanger("The fog churns violently... something has found you!"))
		shake_camera(V, 2, 2)
	
	ambush_in_progress = FALSE

/datum/component/fogged/proc/calculate_victim_score(mob/living/victim, time_entered)
	var/score = 0

	// 1 point for every 5 seconds spent in fog
	var/time_delta = world.time - time_entered
	score += round(time_delta / (5 SECONDS))

	// Job Factor
	var/job_title = victim.job

	// High Threat (Combat/Antag/Leaders) - 25 Points
	if((job_title in GLOB.garrison_positions) || \
	   (job_title in GLOB.retinue_positions) || \
	   (job_title in GLOB.inquisition_positions) || \
	   (job_title in GLOB.antagonist_positions))
		score += 25

	// Medium Threat (Nobles/Court/Magic) - 15 Points
	else if((job_title in GLOB.noble_positions) || \
			(job_title in GLOB.courtier_positions) || \
			(job_title in GLOB.church_positions))
		score += 15

	// Low Threat (Civilians) - 5 Points
	else
		score += 5
	return score

// --- Selection Logic ---

/datum/component/fogged/proc/select_ambush_encounter(budget)
	var/list/valid_entries = list()

	// Filter by budget
	for(var/datum/ambush_entry/entry in GLOB.ambush_encounters)
		if(budget >= entry.unlock_score)
			valid_entries[entry] = entry.weight

	if(!length(valid_entries))
		return null

	return pickweight(valid_entries)

/datum/component/fogged/proc/get_fog_ambush_spawn(min_dist = 2, max_dist = 7)
	var/mob/living/L = parent
	var/list/possible_targets = list()

	for(var/turf/T in orange(max_dist, L))
		if(is_blocked_turf(T))
			continue
		if(!isturf(T) || get_dist(T, L) < min_dist)
			continue

		var/area/A = get_area(T)
		if(A.fog_protected)
			continue

		for(var/turf/AT in get_adjacent_turfs(T))
			if(AT.density || T.LinkBlockedWithAccess(AT, null))
				continue

			// Check the area of the adjacent turf too, just in case of area borders
			var/area/AA = get_area(AT)
			if(AA.fog_protected)
				continue
			possible_targets += AT

	return possible_targets

/datum/component/fogged/proc/handle_ward_change()
	var/mob/living/L = parent
	if(HAS_TRAIT(L, TRAIT_FOG_WARDED))
		L.remove_status_effect(/datum/status_effect/debuff/fog_chilled)
	else
		L.apply_status_effect(/datum/status_effect/debuff/fog_chilled)
