/obj/effect/landmark/quest_spawner
	name = "quest landmark"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "quest_marker"
	var/quest_difficulty = list(QUEST_DIFFICULTY_EASY, QUEST_DIFFICULTY_MEDIUM, QUEST_DIFFICULTY_HARD)
	var/quest_type = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_KILL_EASY, QUEST_OUTLAW)

/obj/effect/landmark/quest_spawner/Initialize()
	. = ..()
	GLOB.quest_landmarks_list += src

/obj/effect/landmark/quest_spawner/Destroy()
	GLOB.quest_landmarks_list -= src
	return ..()

/obj/effect/landmark/quest_spawner/proc/add_quest_faction_to_nearby_mobs(turf/center)
	for(var/mob/living/M in view(7, center))
		if(!M.ckey && !("quest" in M.faction))
			M.faction |= "quest"

/obj/effect/landmark/quest_spawner/proc/get_safe_spawn_turf()
	var/list/possible_landmarks = list()
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if((quest_difficulty in landmark.quest_difficulty) || (landmark.quest_difficulty in quest_difficulty))
			possible_landmarks += landmark

	if(!length(possible_landmarks))
		possible_landmarks += src
	
	var/obj/effect/landmark/quest_spawner/selected_landmark = pick(possible_landmarks)
	var/list/possible_turfs = list()

	for(var/turf/open/floor/T in view(7, selected_landmark))
		if(T.density || istransparentturf(T))
			continue
			
		for(var/obj/O in get_turf(T))
			if(O.density) //No more spawning in metal bars or trees...
				continue

		if(get_area(T) != get_area(selected_landmark)) //No more spawning in guild room...
			continue

		possible_turfs += T

	return length(possible_turfs) ? pick(possible_turfs) : get_turf(src)

/obj/effect/landmark/quest_spawner/easy
	name = "easy quest landmark"
	icon_state = "quest_marker_low"
	quest_difficulty = "Easy"
	quest_type = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_KILL_EASY)

/obj/effect/landmark/quest_spawner/medium
	name = "medium quest landmark"
	icon_state = "quest_marker_mid"
	quest_difficulty = "Medium"
	quest_type = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT)

/obj/effect/landmark/quest_spawner/hard
	name = "hard quest landmark"
	icon_state = "quest_marker_high"
	quest_difficulty = "Hard"
	quest_type = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_OUTLAW)

/// Pick a quest_spawner landmark matching the given difficulty and type. Prefers landmarks with
/// no players in visual range so the spawned content isn't witnessed mid-creation. Falls back to
/// any landmark matching just the difficulty if no type-matching landmark is clear.
/proc/find_quest_landmark(difficulty, type)
	var/list/type_matches = list()
	GLOB.quest_landmarks_list = shuffle(GLOB.quest_landmarks_list)
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if(landmark.quest_difficulty != difficulty || !(type in landmark.quest_type))
			continue
		if(quest_landmark_has_client_witness(landmark))
			continue
		type_matches += landmark
	if(length(type_matches))
		return pick(type_matches)

	var/list/difficulty_matches = list()
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if(landmark.quest_difficulty != difficulty)
			continue
		if(quest_landmark_has_client_witness(landmark))
			continue
		difficulty_matches += landmark
	if(length(difficulty_matches))
		return pick(difficulty_matches)

	return null

/proc/quest_landmark_has_client_witness(obj/effect/landmark/quest_spawner/landmark)
	for(var/mob/M in get_hearers_in_view(world.view, landmark))
		if(M.client)
			return TRUE
	return FALSE
