/obj/effect/landmark/quest_spawner
	name = "quest landmark"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "quest_marker"
	var/landmark_kind = QUEST_LANDMARK_GENERIC
	var/list/quest_type
	var/region
	var/datum/weakref/claimed_by
	var/locked_at = 0
	var/cooldown_until = 0

/obj/effect/landmark/quest_spawner/Initialize(mapload)
	. = ..()
	GLOB.quest_landmarks_list += src
	if(!region)
		var/area/A = get_area(src)
		if(A)
			region = A.threat_region
	quest_type = get_quest_types_for_landmark_kind(landmark_kind)
	SSquestpool?.register_landmark(src)

/obj/effect/landmark/quest_spawner/Destroy()
	GLOB.quest_landmarks_list -= src
	SSquestpool?.unregister_landmark(src)
	return ..()

/obj/effect/landmark/quest_spawner/proc/get_safe_spawn_turf()
	var/list/possible_turfs = list()
	var/turf/origin = get_turf(src)
	if(!origin)
		return null
	for(var/turf/open/floor/T in view(7, src))
		if(T.z != origin.z)
			continue

		if(T.density)
			continue

		if(get_area(T) != get_area(src)) //No more spawning in guild room...
			continue

		var/blocked = FALSE
		for(var/obj/O in T)
			if(O.density) //No more spawning in metal bars or trees...
				blocked = TRUE
				break
		if(blocked)
			continue

		possible_turfs += T
	return length(possible_turfs) ? pick(possible_turfs) : origin

/obj/effect/landmark/quest_spawner/generic
	name = "generic quest landmark"
	icon_state = "quest_marker_low"

/obj/effect/landmark/quest_spawner/defense
	name = "defense quest landmark"
	icon_state = "quest_marker_high"
	landmark_kind = QUEST_LANDMARK_DEFENSE

/obj/effect/landmark/quest_spawner/proc/is_available_for_quest()
	if(claimed_by?.resolve())
		return FALSE
	if(world.time < cooldown_until)
		return FALSE
	return TRUE

/proc/find_quest_landmark(type, region = null, datum/quest/claiming_quest = null)
	// Pre-filtered by type via the landmarks_by_type index. The type-in-landmark.quest_type
	// check from the old passes is now implicit in the index membership, and pick() at the
	// end of each pass randomizes without shuffling the full global list every call.
	var/list/candidates = SSquestpool?.landmarks_by_type?[type]
	if(!length(candidates))
		return null

	var/obj/effect/landmark/quest_spawner/picked

	if(region)
		var/list/region_matches = list()
		for(var/obj/effect/landmark/quest_spawner/landmark as anything in candidates)
			if(QDELETED(landmark))
				continue
			if(landmark.region != region)
				continue
			if(!landmark.is_available_for_quest())
				continue
			region_matches += landmark
		if(length(region_matches))
			picked = pick(region_matches)

	if(!picked && !region)
		var/list/type_matches = list()
		for(var/obj/effect/landmark/quest_spawner/landmark as anything in candidates)
			if(QDELETED(landmark))
				continue
			if(!landmark_region_allows_type(landmark, type))
				continue
			if(!landmark.is_available_for_quest())
				continue
			type_matches += landmark
		if(length(type_matches))
			picked = pick(type_matches)

	if(!picked && !region)
		var/list/any_type_match = list()
		for(var/obj/effect/landmark/quest_spawner/landmark as anything in candidates)
			if(QDELETED(landmark))
				continue
			if(!landmark_region_allows_type(landmark, type))
				continue
			any_type_match += landmark
		if(length(any_type_match))
			picked = pick(any_type_match)

	if(picked && claiming_quest)
		picked.claimed_by = WEAKREF(claiming_quest)

	return picked

/proc/landmark_region_allows_type(obj/effect/landmark/quest_spawner/landmark, quest_type)
	if(!landmark.region)
		return TRUE
	var/datum/threat_region/TR = SSregionthreat.get_region(landmark.region)
	if(!TR)
		return TRUE
	return TR.allows_quest_type(quest_type)
