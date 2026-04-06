/obj/effect/landmark/quest_spawner
	name = "quest landmark"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "quest_marker"
	var/min_contract_tier = QUEST_TIER_ROUTINE
	var/max_contract_tier = QUEST_TIER_MYTHIC
	var/list/contract_types = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_HUNT, QUEST_BOSS)

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
	var/list/possible_turfs = list()

	for(var/turf/open/floor/T in view(7, src))
		if(T.density || istransparentturf(T))
			continue

		for(var/obj/O in get_turf(T))
			if(O.density) //No more spawning in metal bars or trees...
				continue

		if(get_area(T) != get_area(src)) // Keep the quest clustered around its chosen landmark.
			continue

		possible_turfs += T

	return length(possible_turfs) ? pick(possible_turfs) : get_turf(src)

/obj/effect/landmark/quest_spawner/proc/supports_contract_type(contract_type)
	return contract_type in contract_types

/obj/effect/landmark/quest_spawner/proc/supports_contract_tier(contract_tier)
	return contract_tier >= min_contract_tier && contract_tier <= max_contract_tier

/obj/effect/landmark/quest_spawner/proc/get_tier_gap(contract_tier)
	if(supports_contract_tier(contract_tier))
		return 0
	if(contract_tier < min_contract_tier)
		return min_contract_tier - contract_tier
	return contract_tier - max_contract_tier

/obj/effect/landmark/quest_spawner/proc/get_default_contract_tier()
	return round((min_contract_tier + max_contract_tier) / 2)

/obj/effect/landmark/quest_spawner/easy
	name = "low-tier quest landmark"
	icon_state = "quest_marker_low"
	min_contract_tier = QUEST_TIER_ROUTINE
	max_contract_tier = QUEST_TIER_RISKY
	contract_types = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_HUNT)

/obj/effect/landmark/quest_spawner/medium
	name = "mid-tier quest landmark"
	icon_state = "quest_marker_mid"
	min_contract_tier = QUEST_TIER_RISKY
	max_contract_tier = QUEST_TIER_DEADLY
	contract_types = list(QUEST_RETRIEVAL, QUEST_COURIER, QUEST_HUNT, QUEST_CLEAR_OUT)

/obj/effect/landmark/quest_spawner/hard
	name = "high-tier quest landmark"
	icon_state = "quest_marker_high"
	min_contract_tier = QUEST_TIER_DEADLY
	max_contract_tier = QUEST_TIER_MYTHIC
	contract_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOSS)