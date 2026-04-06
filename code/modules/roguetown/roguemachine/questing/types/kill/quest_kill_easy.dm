// Hunt quests
/datum/quest/kill/hunt
	quest_type = QUEST_HUNT
	contract_group = QUEST_GROUP_BOUNTIES
	mob_types_to_spawn = QUEST_KILL_MOBS_LIST
	count_min = 1
	count_max = 3
	minimum_tier = QUEST_TIER_ROUTINE
	maximum_tier = QUEST_TIER_DANGEROUS
	base_reward_value = QUEST_BASE_REWARD_HUNT

/datum/quest/kill/hunt/get_title()
	if(title)
		return title
	return "Slay [pick("a dangerous", "a fearsome", "a troublesome", "an elusive")] [pick("beast", "monster", "brigand", "creature")]"

/datum/quest/kill/hunt/get_objective_text()
	return "Slay [progress_required] [initial(target_mob_type.name)]."

/datum/quest/kill/hunt/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	if(!spawn_kill_mobs(landmark))
		return FALSE

	return TRUE