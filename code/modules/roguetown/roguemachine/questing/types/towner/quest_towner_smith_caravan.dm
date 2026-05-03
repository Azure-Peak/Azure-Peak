/datum/quest/towner/smith_caravan
	quest_type = QUEST_TOWNER_SMITH_CARAVAN
	writ_type = WRIT_TYPE_RECOVERY

/datum/quest/towner/smith_caravan/get_title()
	if(title)
		return title
	return "A Caravan Gone Missing"

/datum/quest/towner/smith_caravan/get_objective_text()
	return "Escort the smith and recover their caravan."
