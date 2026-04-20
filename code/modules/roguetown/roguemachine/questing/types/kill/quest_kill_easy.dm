/datum/quest/kill/easy
	quest_type = QUEST_KILL_EASY
	count_min = 2
	count_max = 4
	threat_bands_cleared = QUEST_BANDS_KILL_EASY

/datum/quest/kill/easy/get_title()
	if(title)
		return title
	if(!faction)
		return "Slay a troublesome creature"
	return "Slay [progress_required] [faction.name_plural]"

/datum/quest/kill/easy/get_objective_text()
	if(!faction)
		return "Slay [progress_required] [initial(target_mob_type.name)]."
	return "Slay [progress_required] [faction.name_plural]."

/datum/quest/kill/easy/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	return TRUE
