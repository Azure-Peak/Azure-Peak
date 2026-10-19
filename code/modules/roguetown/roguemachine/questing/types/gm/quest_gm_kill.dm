/datum/quest/kill/gm
	quest_type = QUEST_GM_KILL
	chronicle_order = QUEST_CHRONICLE_ORDER_GM
	quest_difficulty = QUEST_DIFFICULTY_SPECIAL
	lapses = FALSE
	var/list/quest_mobs = list()
	var/objective_text
	var/group_word
	var/foe_name

/datum/quest/kill/gm/get_objective_text()
	return objective_text || "Eliminate dire threats."

/datum/quest/kill/gm/materialize(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(.)
		message_admins("A custom quest ([title]) has spawned its landmark at [ADMIN_VERBOSEJMP(landmark)].")

/datum/quest/kill/gm/pick_region_faction_for(datum/threat_region/TR)
	return new /datum/quest_faction/gm(group_word, foe_name)

/datum/quest/kill/gm/estimate_mob_count()
	return max(length(quest_mobs), 1)

/datum/quest/kill/gm/compose_warband()
	return quest_mobs.Copy()
