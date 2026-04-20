/datum/quest/kill/bounty
	quest_type = QUEST_BOUNTY
	count_min = 1
	count_max = 1
	threat_bands_cleared = QUEST_BANDS_BOUNTY
	/// Generated boss name for title/objective. Set at preview.
	var/boss_name

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
	target_mob_type = faction.pick_boss_mob_type()
	if(!target_mob_type)
		return FALSE
	progress_required = 1
	boss_name = faction.generate_boss_name()
	if(!title)
		title = get_title()
	return TRUE

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

/datum/quest/kill/bounty/get_location_text()
	return target_spawn_area ? "Last seen in [target_spawn_area] region." : "Location unknown."

/datum/quest/kill/bounty/get_additional_reward(turf/origin_turf, turf/target_turf)
	if(!target_mob_type)
		return 0
	var/threat = initial(target_mob_type.threat_point) || 0
	return threat * QUEST_BOUNTY_THREAT_MULT + QUEST_REWARD_BOUNTY_HEAD

/datum/quest/kill/bounty/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!faction)
		return FALSE
	spawn_kill_mobs(landmark)
	spawn_goons(landmark)
	// Rename the boss mob in-world so turn-in and examine read as the generated name.
	for(var/datum/weakref/ref in tracked_atoms)
		var/mob/living/M = ref.resolve()
		if(M && istype(M, target_mob_type))
			M.real_name = boss_name
			M.name = boss_name
	return TRUE

/// Spawn 2-5 gang members of the same faction to accompany the bounty target.
/datum/quest/kill/bounty/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark)
	var/goon_type = faction.pick_mob_type()
	if(!goon_type)
		return
	for(var/i in 1 to rand(2, 5))
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
