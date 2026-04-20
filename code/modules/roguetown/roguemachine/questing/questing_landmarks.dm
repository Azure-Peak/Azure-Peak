/obj/effect/landmark/quest_spawner
	name = "quest landmark"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "quest_marker"
	var/list/quest_type = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_KILL_EASY, QUEST_BOUNTY)
	var/region

/obj/effect/landmark/quest_spawner/Initialize()
	. = ..()
	GLOB.quest_landmarks_list += src
	if(!region)
		var/area/A = get_area(src)
		if(A)
			region = A.threat_region

/obj/effect/landmark/quest_spawner/Destroy()
	GLOB.quest_landmarks_list -= src
	return ..()

/obj/effect/landmark/quest_spawner/proc/add_quest_faction_to_nearby_mobs(turf/center)
	for(var/mob/living/M in view(7, center))
		if(!M.ckey && !("quest" in M.faction))
			M.faction |= "quest"

/obj/effect/landmark/quest_spawner/proc/get_safe_spawn_turf()
	var/list/possible_turfs = list()
	for(var/turf/open/floor/T in view(7, src))
		if(T.density || istransparentturf(T))
			continue
		for(var/obj/O in get_turf(T))
			if(O.density)
				continue
		if(get_area(T) != get_area(src))
			continue
		possible_turfs += T
	return length(possible_turfs) ? pick(possible_turfs) : get_turf(src)

/obj/effect/landmark/quest_spawner/generic
	name = "generic quest landmark"
	icon_state = "quest_marker_low"
	quest_type = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_KILL_EASY, QUEST_CLEAR_OUT)

/obj/effect/landmark/quest_spawner/defense
	name = "defense quest landmark"
	icon_state = "quest_marker_high"
	quest_type = list()

// Easy / Medium / Hard spawner will be phased out, so we have no override (
// Every quest is eligible)
/obj/effect/landmark/quest_spawner/easy
	name = "easy quest landmark"
	icon_state = "quest_marker_low"

/obj/effect/landmark/quest_spawner/medium
	name = "medium quest landmark"
	icon_state = "quest_marker_mid"

/obj/effect/landmark/quest_spawner/hard
	name = "hard quest landmark"
	icon_state = "quest_marker_high"

/proc/find_quest_landmark(type, region = null)
	GLOB.quest_landmarks_list = shuffle(GLOB.quest_landmarks_list)

	if(region)
		var/list/region_matches = list()
		for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
			if(!(type in landmark.quest_type))
				continue
			if(landmark.region != region)
				continue
			if(quest_landmark_has_client_witness(landmark))
				continue
			region_matches += landmark
		if(length(region_matches))
			return pick(region_matches)

	// Fallback: any landmark whose region allows this quest type. Prevents a Kill Easy
	// generated for Basin from falling through to Coast (which forbids Easy) just because
	// Coast landmarks also accept the type on the landmark side.
	var/list/type_matches = list()
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if(!(type in landmark.quest_type))
			continue
		if(!landmark_region_allows_type(landmark, type))
			continue
		if(quest_landmark_has_client_witness(landmark))
			continue
		type_matches += landmark
	if(length(type_matches))
		return pick(type_matches)

	var/list/any_type_match = list()
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if(!(type in landmark.quest_type))
			continue
		if(!landmark_region_allows_type(landmark, type))
			continue
		any_type_match += landmark
	if(length(any_type_match))
		return pick(any_type_match)

	return null

/proc/landmark_region_allows_type(obj/effect/landmark/quest_spawner/landmark, quest_type)
	if(!landmark.region)
		return TRUE
	var/datum/threat_region/TR = SSregionthreat.get_region(landmark.region)
	if(!TR)
		return TRUE
	return TR.allows_quest_type(quest_type)

/proc/quest_landmark_has_client_witness(obj/effect/landmark/quest_spawner/landmark)
	for(var/mob/M in get_hearers_in_view(world.view, landmark))
		if(M.client)
			return TRUE
	return FALSE
