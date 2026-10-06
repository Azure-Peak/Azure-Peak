GLOBAL_LIST_EMPTY(gm_spawn_roster)
GLOBAL_LIST_EMPTY(gm_spawn_roster_factions)
GLOBAL_LIST_EMPTY(gm_spawn_filters)
GLOBAL_LIST_EMPTY(gm_spawn_filter_counts)
GLOBAL_LIST_EMPTY(gm_spawn_roster_threats)
GLOBAL_LIST_EMPTY(gm_spawn_roster_names)
GLOBAL_LIST_EMPTY(gm_warband_roster)
GLOBAL_LIST_EMPTY(gm_warband_filters)
GLOBAL_LIST_EMPTY(gm_warband_factions)
GLOBAL_LIST_EMPTY(gm_warband_threats)
GLOBAL_LIST_EMPTY(gm_warband_filter_counts)

GLOBAL_LIST_INIT(gm_roster_abstract_types, list(
	/mob/living,
	/mob/living/carbon,
	/mob/living/carbon/human,
	/mob/living/simple_animal,
	/mob/living/simple_animal/hostile,
	/mob/living/simple_animal/hostile/retaliate,
	/mob/living/simple_animal/hostile/retaliate/rogue,
	/mob/living/simple_animal/hostile/rogue,
	/mob/living/simple_animal/hostile/boss,
))

// Filter out any display names to avoid cluttering it with placeholders
GLOBAL_LIST_INIT(gm_roster_name_blocklist, list(
	"placeholder",
	"template",
	"unfinished",
	"unused",
))

GLOBAL_LIST_INIT(gm_roster_path_stopwords, list(
	"mob",
	"living",
	"carbon",
	"human",
	"simple_animal",
	"hostile",
	"retaliate",
	"rogue",
	"species",
	"northern",
	"ambush",
	"npc",
))


/proc/sorted_keys(list/source)
	var/list/keys = list()
	for(var/key in source)
		keys += key
	return sortList(keys)

/proc/gm_roster_titlecase(input)
	var/list/words = list()
	for(var/word in splittext(replacetext(replacetext("[input]", "-", " "), "_", " "), " "))
		if(!word)
			continue
		words += capitalize(word)
	return jointext(words, " ")

/proc/gm_roster_label_from_path(mob_type)
	var/list/kept = list()
	for(var/segment in splittext("[mob_type]", "/"))
		if(!segment || (segment in GLOB.gm_roster_path_stopwords))
			continue
		kept += segment

	if(!length(kept))
		return "[mob_type]"

	while(length(kept) > GM_ROSTER_NAME_SEGMENTS)
		kept.Cut(1, 2)

	return gm_roster_titlecase(jointext(kept, " "))

/proc/is_blocklisted_roster_name(display_name)
	var/lowered = LOWER_TEXT(display_name)
	for(var/blocked in GLOB.gm_roster_name_blocklist)
		if(findtext(lowered, blocked))
			return TRUE
	return FALSE

/proc/gm_roster_declares_own_name(mob/living/mob_type)
	var/mob/living/parent_type = type2parent(mob_type)
	if(!parent_type)
		return TRUE
	return initial(mob_type.name) != initial(parent_type.name)

/proc/build_gm_spawn_roster()
	var/list/roster = list()
	var/list/roster_factions = list()
	var/list/roster_threats = list()

	for(var/mob/living/mob_type as anything in typesof(/mob/living))
		if(mob_type in GLOB.gm_roster_abstract_types)
			continue
		if(findtext("[mob_type]", "_test") || findtext("[mob_type]", "/dummy"))
			continue

		if(initial(mob_type.gm_hidden))
			continue

		var/override_name = initial(mob_type.gm_name)
		var/override_category = initial(mob_type.gm_category)
		var/threat = initial(mob_type.threat_point)
		var/tag = initial(mob_type.ambush_faction)
		var/datum/npc_archetype/archetype = get_npc_part(initial(mob_type.npc_archetype))
		if(archetype)
			if(!override_name)
				override_name = archetype.name
			if(!override_category)
				override_category = archetype.category
			if(!threat)
				threat = archetype.threat_point
			if(!tag)
				tag = archetype.faction_tag
		var/explicit = override_name || override_category || threat > 0 || tag
		var/has_ai = initial(mob_type.ai_controller)

		if(!explicit)
			if(!has_ai && !ispath(mob_type, /mob/living/simple_animal))
				continue
			if(!has_ai && !gm_roster_declares_own_name(mob_type))
				continue

		var/category = override_category || gm_category_for_type(mob_type) || tag || GM_CATEGORY_UNAFFILIATED

		var/display_name = override_name
		if(!display_name)
			var/mob_name = initial(mob_type.name)
			if(!mob_name || LOWER_TEXT(mob_name) == "unknown" || !gm_roster_declares_own_name(mob_type))
				display_name = gm_roster_label_from_path(mob_type)
			else
				display_name = gm_roster_titlecase(mob_name)

		var/mob/living/existing_type = roster[display_name]
		if(existing_type)
			if(threat > 0 && roster_threats[display_name] <= 0)
				roster[display_name] = mob_type
				roster_factions[display_name] = category
				roster_threats[display_name] = threat
				continue
			if(type2top(mob_type) in GLOB.gm_roster_path_stopwords)
				continue
			display_name = "[display_name] ([gm_roster_titlecase(type2top(mob_type))])"
			if(roster[display_name])
				continue

		roster[display_name] = mob_type
		roster_factions[display_name] = category
		roster_threats[display_name] = threat

	GLOB.gm_spawn_roster = list()
	GLOB.gm_spawn_roster_factions = list()
	GLOB.gm_spawn_filter_counts = list()
	GLOB.gm_spawn_roster_threats = list()
	GLOB.gm_spawn_roster_names = list()
	var/list/filters = list()
	for(var/display_name in sorted_keys(roster))
		var/mob/living/rostered_type = roster[display_name]
		GLOB.gm_spawn_roster[display_name] = rostered_type
		GLOB.gm_spawn_roster_names[rostered_type] = display_name
		GLOB.gm_spawn_roster_threats[display_name] = roster_threats[display_name]
		var/category = roster_factions[display_name]
		GLOB.gm_spawn_roster_factions[display_name] = category
		filters |= category
		GLOB.gm_spawn_filter_counts[category] += 1

	GLOB.gm_spawn_filter_counts[GM_FILTER_ALL] = length(GLOB.gm_spawn_roster)
	GLOB.gm_spawn_filters = list(GM_FILTER_ALL) + sortList(filters)

/proc/gm_category_for_mob(mob/living/checked_mob)
	if(!checked_mob)
		return null
	return checked_mob.gm_category || gm_category_for_type(checked_mob.type) || checked_mob.ambush_faction || GM_CATEGORY_UNAFFILIATED

/proc/get_gm_spawn_roster()
	if(!length(GLOB.gm_spawn_roster))
		build_gm_spawn_roster()
	return GLOB.gm_spawn_roster

/proc/build_gm_warband_roster()
	var/list/roster = list()
	for(var/datum/npc_warband/warband_type as anything in subtypesof(/datum/npc_warband))
		if(IS_ABSTRACT(warband_type))
			continue
		var/datum/npc_warband/warband = get_npc_part(warband_type)
		if(!warband || warband.gm_hidden || !length(warband.members))
			continue
		roster[warband.name] = warband_type

	GLOB.gm_warband_roster = list()
	GLOB.gm_warband_factions = list()
	GLOB.gm_warband_threats = list()
	GLOB.gm_warband_filter_counts = list()
	var/list/filters = list()
	for(var/display_name in sorted_keys(roster))
		var/datum/npc_warband/warband = get_npc_part(roster[display_name])
		var/category = warband.category || GM_CATEGORY_UNAFFILIATED
		GLOB.gm_warband_roster[display_name] = roster[display_name]
		GLOB.gm_warband_factions[display_name] = category
		GLOB.gm_warband_threats[display_name] = warband.threat_point
		filters |= category
		GLOB.gm_warband_filter_counts[category] += 1

	GLOB.gm_warband_filter_counts[GM_FILTER_ALL] = length(GLOB.gm_warband_roster)
	GLOB.gm_warband_filters = list(GM_FILTER_ALL) + sortList(filters)

/proc/get_gm_warband_roster()
	if(!length(GLOB.gm_warband_roster))
		build_gm_warband_roster()
	return GLOB.gm_warband_roster

/proc/gm_roster_name_for_type(mob/living/mob_type)
	get_gm_spawn_roster()
	return GLOB.gm_spawn_roster_names[mob_type] || gm_roster_label_from_path(mob_type)

/proc/gm_filter_known(filter)
	return (filter in GLOB.gm_spawn_filters) || (filter in GLOB.gm_warband_filters)

