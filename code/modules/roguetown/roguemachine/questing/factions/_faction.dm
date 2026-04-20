GLOBAL_LIST_EMPTY(quest_factions)

/datum/quest_faction
	var/id
	var/name_singular
	var/name_plural
	var/group_word
	var/faction_tag
	var/list/mob_types = list()
	var/list/allowed_quest_types
	var/list/boss_mob_types = list()
	var/list/boss_title_templates = list()
	var/boss_name_file

/datum/quest_faction/New()
	if(!id)
		CRASH("Quest faction created without id: [type]")
	if(!allowed_quest_types)
		allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_RECOVERY)
		if(length(boss_mob_types))
			allowed_quest_types += QUEST_BOUNTY

/datum/quest_faction/proc/allows_quest_type(quest_type)
	return (quest_type in allowed_quest_types)

/datum/quest_faction/proc/pick_boss_mob_type()
	if(!length(boss_mob_types))
		return null
	return pickweight(boss_mob_types)

/datum/quest_faction/proc/pick_boss_name()
	if(!boss_name_file)
		return null
	var/list/names = world.file2list(boss_name_file)
	if(!length(names))
		return null
	return pick(names)

/datum/quest_faction/proc/generate_boss_name()
	var/template = length(boss_title_templates) ? pick(boss_title_templates) : "%N"
	var/name = pick_boss_name()
	if(!name)
		return "a notorious [name_singular]"
	return replacetext(template, "%N", name)

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
