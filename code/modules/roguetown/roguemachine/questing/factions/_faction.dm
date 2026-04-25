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
	/// Blockade defense pool. Bestial factions stay out — multi-wave timed fights need
	/// mobs that can pathfind and coordinate.
	var/can_blockade = FALSE
	var/category = FACTION_CAT_HUMANOID
	var/list/crime_weights
	var/progress_noun = "malefactors"

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

/// At least one non-petty crime is guaranteed when any are available, so a writ
/// composed from a pool that includes petty entries still reads as a real death-warrant.
/datum/quest_faction/proc/pick_crimes(count = 3)
	if(!length(crime_weights) || count <= 0)
		return list()
	var/list/picked = list()
	var/list/pool = crime_weights.Copy()
	var/list/serious_pool = list()
	for(var/id in pool)
		var/datum/quest_crime/C = get_quest_crime(id)
		if(C && C.tier >= CRIME_TIER_COMMON)
			serious_pool[id] = pool[id]
	if(length(serious_pool))
		var/serious_id = pickweight(serious_pool)
		if(serious_id)
			picked += serious_id
			pool -= serious_id
	while(length(picked) < count && length(pool))
		var/id = pickweight(pool)
		if(!id)
			break
		picked += id
		pool -= id
	return picked

/datum/quest_faction/proc/render_crimes(list/ids)
	var/list/out = list()
	for(var/id in ids)
		var/datum/quest_crime/C = get_quest_crime(id)
		if(!C)
			continue
		var/phrase = C.render()
		if(phrase)
			out += phrase
	return out

/datum/quest_faction/proc/crimes_invoke_tens(list/ids)
	for(var/id in ids)
		var/datum/quest_crime/C = get_quest_crime(id)
		if(!C)
			continue
		if(C.tier >= CRIME_TIER_SACRAL)
			return TRUE
	return FALSE

/datum/quest_faction/proc/crimes_invoke_oath(list/ids)
	for(var/id in ids)
		var/datum/quest_crime/C = get_quest_crime(id)
		if(!C)
			continue
		if(C.tier == CRIME_TIER_OATH)
			return TRUE
	return FALSE

/proc/init_quest_factions()
	init_quest_crimes()
	init_writ_circumstances()
	GLOB.quest_factions = list()
	for(var/path in subtypesof(/datum/quest_faction))
		var/datum/quest_faction/F = new path()
		if(GLOB.quest_factions[F.id])
			CRASH("Duplicate quest_faction id: [F.id]")
		GLOB.quest_factions[F.id] = F

/proc/get_quest_faction(id)
	return GLOB.quest_factions[id]
