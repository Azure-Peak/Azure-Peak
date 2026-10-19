/datum/quest/kill/gm
	quest_type = QUEST_GM_KILL
	chronicle_order = QUEST_CHRONICLE_ORDER_GM
	quest_difficulty = QUEST_DIFFICULTY_SPECIAL
	var/list/quest_mobs = list()

/datum/quest/kill/gm/get_objective_text()
	return "Eliminate dire threats."

/datum/quest/kill/gm/pick_region_faction_for(datum/threat_region/TR)
	return get_quest_faction(QUEST_FACTION_GM)

/datum/quest/kill/gm/estimate_mob_count()
	return max(length(quest_mobs), 1)

/datum/quest/kill/gm/compose_warband()
	return quest_mobs.Copy()
