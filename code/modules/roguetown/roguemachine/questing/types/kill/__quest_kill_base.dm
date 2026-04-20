/datum/quest/kill
	var/count_min = 1
	var/count_max = 3
	/// How many "bands" of threat this kill quest type clears on completion. Subtypes override.
	var/threat_bands_cleared = 0

/datum/quest/kill/mark_complete()
	..()
	if(threat_bands_cleared <= 0 || !region)
		return
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return
	TR.reduce_latent_ambush(threat_bands_cleared * THREAT_POINTS_PER_BAND)

/datum/quest/kill/preview(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
	if(!region)
		return FALSE
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return FALSE
	faction = pick_region_faction_for(TR)
	if(!faction)
		return FALSE
	faction_id = faction.id
	target_mob_type = faction.pick_mob_type()
	if(!target_mob_type)
		return FALSE
	progress_required = rand(count_min, count_max)
	return TRUE

/datum/quest/kill/proc/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		if(!F.allows_quest_type(quest_type))
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/datum/quest/kill/proc/spawn_kill_mobs(obj/effect/landmark/quest_spawner/landmark)
	for(var/i in 1 to progress_required)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue

		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/mob/living/new_mob = new target_mob_type(spawn_effect)
		new_mob.faction |= "quest"
		if(faction?.faction_tag)
			new_mob.faction |= faction.faction_tag
		new_mob.AddComponent(/datum/component/quest_object/kill, src)
		// Suppress AI scanning while dormant inside the spawn_effect — without this the AI tries
		// to build a proximity field while not on a turf, fails, and stays catatonic forever.
		ADD_TRAIT(new_mob, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(new_mob, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		spawn_effect.contained_atom = new_mob
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		add_tracked_atom(new_mob)
		landmark.add_quest_faction_to_nearby_mobs(spawn_turf)
		sleep(1)

/datum/quest/kill/get_additional_reward(turf/origin_turf, turf/target_turf)
	if(!target_mob_type)
		return 0
	var/threat = initial(target_mob_type.threat_point) || 0
	return progress_required * (threat * QUEST_KILL_THREAT_MULT + QUEST_REWARD_PER_HEAD)
