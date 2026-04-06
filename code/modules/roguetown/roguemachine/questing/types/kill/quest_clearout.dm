/datum/quest/kill/clearout
	quest_type = QUEST_CLEAR_OUT
	contract_group = QUEST_GROUP_BOUNTIES
	mob_types_to_spawn = QUEST_KILL_MEDIUM_LIST
	count_min = 3
	count_max = 6
	minimum_tier = QUEST_TIER_RISKY
	maximum_tier = QUEST_TIER_DEADLY
	base_reward_value = QUEST_BASE_REWARD_CLEAR_OUT
	type_risk_bonus = QUEST_CLEAR_OUT_RISK_BONUS

/datum/quest/kill/clearout/get_title()
	if(title)
		return title
	return "Clear out [pick("a nest of", "a den of", "a group of", "a pack of")] [pick("monsters", "bandits", "creatures", "vermin")]"

/datum/quest/kill/clearout/get_objective_text()
	return "Eliminate [progress_required] [initial(target_mob_type.name)]."

/datum/quest/kill/clearout/get_location_text()
	return target_spawn_area ? "Reported infestation in [target_spawn_area] region." : "Reported infestations in Azuria region."

/datum/quest/kill/clearout/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	if(!spawn_kill_mobs(landmark))
		return FALSE

	return TRUE