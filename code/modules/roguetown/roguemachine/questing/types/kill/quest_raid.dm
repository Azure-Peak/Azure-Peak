/datum/quest/kill/raid
	quest_type = QUEST_RAID
	tp_budget = QUEST_TP_BUDGET_RAID
	threat_bands_cleared = QUEST_BANDS_RAID
	required_fellowship_size = 2

/datum/quest/kill/raid/get_title()
	if(title)
		return title
	if(!faction)
		return "Rout an incoming raid"
	return "Rout a [faction.group_word] of [faction.name_plural]"

/datum/quest/kill/raid/get_objective_text()
	if(!faction)
		return "Eliminate ~[progress_required] [initial(target_mob_type.name)]."
	return "Eliminate ~[progress_required] [faction.name_plural]."

/datum/quest/kill/raid/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	return TRUE
