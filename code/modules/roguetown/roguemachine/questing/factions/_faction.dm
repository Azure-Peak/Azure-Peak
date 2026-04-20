GLOBAL_LIST_EMPTY(quest_factions)

/datum/quest_faction
	var/id
	var/name_singular
	var/name_plural
	var/group_word
	var/faction_tag
	var/list/mob_types = list()

/datum/quest_faction/New()
	if(!id)
		CRASH("Quest faction created without id: [type]")

/datum/quest_faction/proc/describe_group_count(n)
	if(n <= 0)
		return "no [name_plural]"
	return "[n] [group_word][n == 1 ? "" : "s"] of [name_plural]"

/datum/quest_faction/proc/pick_mob_type()
	if(!length(mob_types))
		return null
	return pickweight(mob_types)

/proc/init_quest_factions()
	GLOB.quest_factions = list()
	for(var/path in subtypesof(/datum/quest_faction))
		var/datum/quest_faction/F = new path()
		if(GLOB.quest_factions[F.id])
			CRASH("Duplicate quest_faction id: [F.id]")
		GLOB.quest_factions[F.id] = F

/proc/get_quest_faction(id)
	return GLOB.quest_factions[id]
