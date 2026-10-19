GLOBAL_LIST_INIT(gm_quest_destinations, list(
	/area/rogue/indoors/town/tavern,
	/area/rogue/indoors/town/bath,
	/area/rogue/indoors/town/church,
	/area/rogue/indoors/town/dwarfin,
	/area/rogue/indoors/town/shop,
	/area/rogue/indoors/town/manor,
	/area/rogue/indoors/town/magician,
	/area/rogue/indoors/town/physician,
	/area/rogue/indoors/town,
))

GLOBAL_LIST_EMPTY(gm_quest_item_index)

/proc/get_gm_quest_item_index()
	if(!length(GLOB.gm_quest_item_index))
		for(var/obj/item/item_type as anything in typesof(/obj/item))
			GLOB.gm_quest_item_index[item_type] = "[initial(item_type.name)] [item_type]"
	return GLOB.gm_quest_item_index

/proc/gm_quest_static_data()
	var/list/destinations = list()
	for(var/area/area_type as anything in GLOB.gm_quest_destinations)
		destinations += list(list("path" = "[area_type]", "name" = initial(area_type.name)))
	var/datum/quest/proto = GLOB.quest_prototypes[QUEST_GM_KILL]
	var/datum/quest_faction/gm_faction = get_quest_faction(QUEST_FACTION_GM)
	return list(
		"default_group_word" = gm_faction?.group_word,
		"default_foe_name" = gm_faction?.name_plural,
		"foe_len" = MAX_NAME_LEN,
		"kill_kind" = QUEST_GM_KILL,
		"recovery_kind" = QUEST_GM_RECOVERY,
		"destinations" = destinations,
		"max_reward" = GM_QUEST_MAX_REWARD,
		"title_len" = GM_QUEST_TITLE_LEN,
		"description_len" = GM_QUEST_DESCRIPTION_LEN,
		"crimes_len" = GM_QUEST_CRIMES_LEN,
		"kill_objective" = proto?.get_objective_text(),
		"mob_cap" = QUEST_KILL_MAX_MOBS,
		"item_cap" = GM_QUEST_MAX_ITEMS,
		"max_threat_bands" = GM_QUEST_MAX_THREAT_BANDS,
		"max_fellowship" = GM_QUEST_MAX_FELLOWSHIP,
		"guild_cut_rate" = proto?.guild_cut_rate || 0,
	)

/datum/gm_quest_draft
	var/quest_type = QUEST_GM_KILL
	var/title = ""
	var/description = ""
	var/group_word = ""
	var/foe_name = ""
	var/reward = GM_QUEST_DEFAULT_REWARD
	var/threat_bands = 1
	var/region
	var/crimes_text = ""
	var/fellowship_size = 1
	var/on_floor = FALSE
	var/list/mobs = list()
	var/shipment_name = ""
	var/area/destination
	var/list/items = list()
	var/item_query = ""
	var/list/item_results = list()
	var/posted = FALSE

/datum/gm_quest_draft/proc/clean_text(value, limit)
	return trim(STRIP_HTML_SIMPLE("[value]", limit))

/datum/gm_quest_draft/proc/total_count(list/counts)
	. = 0
	for(var/path in counts)
		. += counts[path]

/datum/gm_quest_draft/proc/set_count(list/counts, path, count, cap)
	posted = FALSE
	var/others = total_count(counts) - (counts[path] || 0)
	count = clamp(round(count), 0, cap - others)
	if(count > 0)
		counts[path] = count
	else
		counts -= path

/datum/gm_quest_draft/proc/add_count(list/counts, path, count, cap)
	set_count(counts, path, (counts[path] || 0) + count, cap)

/datum/gm_quest_draft/proc/set_field(field, value)
	posted = FALSE
	switch(field)
		if("kind")
			if(value in list(QUEST_GM_KILL, QUEST_GM_RECOVERY))
				quest_type = value
		if("title")
			title = clean_text(value, GM_QUEST_TITLE_LEN)
		if("description")
			description = clean_text(replacetext("[value]", "\n", " "), GM_QUEST_DESCRIPTION_LEN)
		if("group_word")
			group_word = clean_text(value, MAX_NAME_LEN)
		if("foe_name")
			foe_name = clean_text(value, MAX_NAME_LEN)
		if("reward")
			reward = clamp(round(text2num(value) || 0), 0, GM_QUEST_MAX_REWARD)
		if("threat_bands")
			threat_bands = clamp(round(text2num(value) || 0), 0, GM_QUEST_MAX_THREAT_BANDS)
		if("region")
			if(SSregionthreat.get_region(value))
				region = value
		if("crimes")
			crimes_text = clean_text(value, GM_QUEST_CRIMES_LEN)
		if("fellowship_size")
			fellowship_size = clamp(round(text2num(value) || 1), 1, GM_QUEST_MAX_FELLOWSHIP)
		if("on_floor")
			on_floor = !!value
		if("shipment_name")
			shipment_name = clean_text(value, GM_QUEST_TITLE_LEN)
		if("destination")
			var/area/area_type = text2path(value)
			if(area_type in GLOB.gm_quest_destinations)
				destination = area_type

/datum/gm_quest_draft/proc/search_items(query)
	item_query = clean_text(query, MAX_NAME_LEN)
	item_results = list()
	if(length(item_query) < GM_QUEST_ITEM_SEARCH_MIN)
		return
	var/list/index = get_gm_quest_item_index()
	for(var/obj/item/item_type as anything in index)
		if(!findtext(index[item_type], item_query))
			continue
		item_results += list(list("path" = "[item_type]", "name" = initial(item_type.name)))
		if(length(item_results) >= GM_QUEST_ITEM_SEARCH_LIMIT)
			return

/datum/gm_quest_draft/proc/is_ready()
	if(!title || !SSregionthreat.get_region(region) || !length(mobs))
		return FALSE
	if(quest_type == QUEST_GM_RECOVERY)
		return !!(length(items) && shipment_name && destination)
	return TRUE

/datum/gm_quest_draft/proc/build_quest()
	var/datum/quest/kill/Q = SSquestpool.create_issued_quest(quest_type, QUEST_SOURCE_GM)
	if(!Q)
		return null
	Q.title = title
	Q.threat_bands_cleared = threat_bands
	if(!on_floor && fellowship_size > 1)
		Q.required_fellowship_size = fellowship_size
	var/list/crime_lines = list()
	for(var/line in splittext(crimes_text, "\n"))
		line = trim(line)
		if(line)
			crime_lines += line
	if(length(crime_lines))
		Q.rolled_crimes = crime_lines
	var/list/mob_list = list()
	for(var/mob_type in mobs)
		for(var/i in 1 to mobs[mob_type])
			mob_list += mob_type
	if(istype(Q, /datum/quest/kill/gm))
		var/datum/quest/kill/gm/kill_quest = Q
		kill_quest.quest_mobs = mob_list
		kill_quest.objective_text = description
		kill_quest.group_word = group_word
		kill_quest.foe_name = foe_name
	else if(istype(Q, /datum/quest/kill/recovery/gm))
		var/datum/quest/kill/recovery/gm/recovery_quest = Q
		recovery_quest.quest_mobs = mob_list
		recovery_quest.objective_text = description
		recovery_quest.group_word = group_word
		recovery_quest.foe_name = foe_name
		recovery_quest.quest_items = items.Copy()
		recovery_quest.shipment_name = shipment_name
		recovery_quest.override_destination = destination
	return Q

/datum/gm_quest_draft/proc/build_ui_data()
	var/list/mob_rows = list()
	for(var/mob/living/mob_type as anything in mobs)
		mob_rows += list(list(
			"path" = "[mob_type]",
			"name" = gm_roster_name_for_type(mob_type),
			"count" = mobs[mob_type],
			"threat" = initial(mob_type.threat_point),
		))
	var/list/item_rows = list()
	for(var/obj/item/item_type as anything in items)
		item_rows += list(list(
			"path" = "[item_type]",
			"name" = initial(item_type.name),
			"count" = items[item_type],
		))
	var/list/region_rows = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		region_rows += list(list(
			"name" = TR.region_name,
			"free_landmarks" = count_available_quest_landmarks(TR.region_name),
		))
	return list(
		"kind" = quest_type,
		"title" = title,
		"description" = description,
		"group_word" = group_word,
		"foe_name" = foe_name,
		"reward" = reward,
		"threat_bands" = threat_bands,
		"region" = region,
		"crimes" = crimes_text,
		"fellowship_size" = fellowship_size,
		"on_floor" = on_floor,
		"mobs" = mob_rows,
		"mob_total" = total_count(mobs),
		"shipment_name" = shipment_name,
		"destination" = destination ? "[destination]" : null,
		"items" = item_rows,
		"item_total" = total_count(items),
		"item_query" = item_query,
		"item_results" = item_results,
		"regions" = region_rows,
		"ready" = is_ready(),
		"posted" = posted,
	)

/datum/game_master/proc/get_quest_draft()
	if(!quest_draft)
		quest_draft = new
	return quest_draft

/datum/game_master/proc/quest_ui_data()
	var/datum/gm_quest_draft/draft = get_quest_draft()
	var/list/data = draft.build_ui_data()
	data["levy_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
	return data

/datum/game_master/proc/gm_quest_rows()
	. = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool | get_scroll_quests())
		if(QDELETED(Q) || Q.source != QUEST_SOURCE_GM)
			continue
		var/list/row = GLOB.quest_debug_panel.quest_row(Q)
		row["reward"] = Q.reward_amount
		. += list(row)

/datum/game_master/proc/locate_gm_quest(ref)
	var/datum/quest/Q = locate(ref)
	if(!istype(Q) || QDELETED(Q) || Q.source != QUEST_SOURCE_GM)
		return null
	return Q

/datum/game_master/proc/gm_quest_act(action, datum/quest/Q, mob/user)
	var/label = "[Q.quest_type] ([Q.get_title()])"
	switch(action)
		if("quest_gm_jump")
			var/turf/T = GLOB.quest_debug_panel.get_jump_turf(Q)
			if(!T)
				to_chat(user, span_warning("That contract has nothing to jump to."))
				return
			user.forceMove(T)
			admin_log_fiscal("admin jumped to contract [label]", "GM Quest Jump")
		if("quest_gm_complete")
			if(Q.complete)
				return
			Q.force_complete()
			admin_log_fiscal("admin force completed contract [label]", "GM Quest Complete")
		if("quest_gm_withdraw")
			if(SSquestpool.withdraw_gm_quest(Q, user))
				admin_log_fiscal("admin withdrew contract [label]", "GM Quest Withdraw")

/datum/game_master/proc/quest_add_selected(count)
	var/datum/gm_quest_draft/draft = get_quest_draft()
	if(selected_view == GM_VIEW_WARBAND)
		var/datum/npc_warband/warband = get_selected_warband()
		if(!warband)
			return
		for(var/mob/living/member as anything in warband.members)
			draft.add_count(draft.mobs, member, warband.members[member] * count, QUEST_KILL_MAX_MOBS)
		return
	var/mob/living/mob_type = get_selected_mob_type()
	if(mob_type)
		draft.add_count(draft.mobs, mob_type, count, QUEST_KILL_MAX_MOBS)

/datum/game_master/proc/quest_act(action, list/params, mob/user)
	var/datum/gm_quest_draft/draft = get_quest_draft()
	switch(action)
		if("quest_set_field")
			draft.set_field(params["field"], params["value"])
		if("quest_add_selected")
			quest_add_selected(clamp(round(text2num(params["count"]) || 1), 1, QUEST_KILL_MAX_MOBS))
		if("quest_set_mob_count")
			var/mob_type = text2path(params["path"])
			if(mob_type in draft.mobs)
				draft.set_count(draft.mobs, mob_type, text2num(params["count"]) || 0, QUEST_KILL_MAX_MOBS)
		if("quest_search_items")
			draft.search_items(params["query"])
		if("quest_add_item")
			var/item_type = text2path(params["path"])
			if(ispath(item_type, /obj/item))
				draft.add_count(draft.items, item_type, clamp(round(text2num(params["count"]) || 1), 1, GM_QUEST_MAX_ITEMS), GM_QUEST_MAX_ITEMS)
		if("quest_set_item_count")
			var/item_type = text2path(params["path"])
			if(item_type in draft.items)
				draft.set_count(draft.items, item_type, text2num(params["count"]) || 0, GM_QUEST_MAX_ITEMS)
		if("quest_reset")
			QDEL_NULL(quest_draft)
		if("quest_post")
			post_gm_quest(user)
		if("quest_gm_jump", "quest_gm_complete", "quest_gm_withdraw")
			var/datum/quest/Q = locate_gm_quest(params["ref"])
			if(Q)
				gm_quest_act(action, Q, user)
	return TRUE

/datum/game_master/proc/post_gm_quest(mob/user)
	var/datum/gm_quest_draft/draft = get_quest_draft()
	if(draft.posted || !draft.is_ready())
		return
	var/datum/quest/Q = draft.build_quest()
	var/datum/threat_region/TR = SSregionthreat.get_region(draft.region)
	if(!SSquestpool.issue_gm_quest(Q, TR, draft.reward, draft.on_floor ? get_turf(user) : null, user))
		to_chat(user, span_warning("No landmark"))
		return
	draft.posted = TRUE
