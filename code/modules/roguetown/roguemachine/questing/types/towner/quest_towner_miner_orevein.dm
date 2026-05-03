/datum/quest/towner/miner_orevein
	quest_type = QUEST_TOWNER_MINER_OREVEIN

/datum/quest/towner/miner_orevein/get_title()
	if(title)
		return title
	return "A Miner's Lead"

/datum/quest/towner/miner_orevein/get_objective_text()
	return "Escort the miner, slay the guardian elementals, and let them work the vein."
