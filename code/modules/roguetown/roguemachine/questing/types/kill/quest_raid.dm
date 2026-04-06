/datum/quest/kill/raid
	quest_type = QUEST_RAID
	contract_group = QUEST_GROUP_BOUNTIES
	mob_types_to_spawn = QUEST_RAID_LIST
	count_min = 2
	count_max = 6
	minimum_tier = QUEST_TIER_DEADLY
	maximum_tier = QUEST_TIER_LETHAL
	base_reward_value = QUEST_BASE_REWARD_RAID
	type_risk_bonus = QUEST_RAID_RISK_BONUS

/datum/quest/kill/raid/get_title()
	if(title)
		return title
	return "Stop a raid of [pick("slavers", "bandits", "brigands", "raiders")]"

/datum/quest/kill/raid/get_objective_text()
	return "Eliminate [progress_required] [initial(target_mob_type.name)]."

/datum/quest/kill/raid/get_location_text()
	return target_spawn_area ? "Reported raid in [target_spawn_area] region." : "Reported infestations in the Duskmar Duchy region."

/datum/quest/kill/raid/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	if(!spawn_kill_mobs(landmark))
		return FALSE

	return TRUE