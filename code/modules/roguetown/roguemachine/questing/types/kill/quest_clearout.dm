/datum/quest/kill/clearout
	quest_type = QUEST_CLEAR_OUT
	tp_budget = QUEST_TP_BUDGET_CLEAR_OUT
	threat_bands_cleared = QUEST_BANDS_CLEAR_OUT

/datum/quest/kill/clearout/get_title()
	if(title)
		return title
	if(!faction)
		return "Clear out a nest of monsters"
	return "Clear out a [faction.group_word] of [faction.name_plural]"

/datum/quest/kill/clearout/get_objective_text()
	if(!faction)
		return "Eliminate ~[progress_required] [initial(target_mob_type.name)]."
	return "Eliminate ~[progress_required] [faction.name_plural]."

/datum/quest/kill/clearout/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	return TRUE
