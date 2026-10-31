GLOBAL_LIST_EMPTY(azure_round_stats)

#define CONTRACT_STAT_POSTED "posted"
#define CONTRACT_STAT_TAKEN "taken"
#define CONTRACT_STAT_LAPSED "lapsed"
#define CONTRACT_STAT_COMPLETED "completed"
#define CONTRACT_STAT_FAILED "failed"
#define CONTRACT_STAT_ABANDONED "abandoned"
#define CONTRACT_STAT_WITHDRAWN "withdrawn"
#define CONTRACT_STAT_PAID "paid"
#define CONTRACT_STAT_WAIT_DS "wait_ds"
#define CONTRACT_STAT_RUN_DS "run_ds"
#define CONTRACT_STAT_PARTY "party"
#define CONTRACT_STAT_DEATHS "deaths"

GLOBAL_LIST_INIT(contract_source_stats, list(
	QUEST_SOURCE_POOL = list(
		CONTRACT_STAT_POSTED = STATS_CONTRACTS_GENERATED_POOL,
		CONTRACT_STAT_TAKEN = STATS_CONTRACTS_TAKEN_POOL,
		CONTRACT_STAT_COMPLETED = STATS_CONTRACTS_COMPLETED_POOL,
		CONTRACT_STAT_LAPSED = STATS_CONTRACTS_LAPSED_POOL,
	),
	QUEST_SOURCE_RUMOR = list(
		CONTRACT_STAT_POSTED = STATS_CONTRACTS_GENERATED_RUMOR,
		CONTRACT_STAT_TAKEN = STATS_CONTRACTS_TAKEN_RUMOR,
		CONTRACT_STAT_COMPLETED = STATS_CONTRACTS_COMPLETED_RUMOR,
		CONTRACT_STAT_LAPSED = STATS_CONTRACTS_LAPSED_RUMOR,
	),
	QUEST_SOURCE_DEFENSE = list(
		CONTRACT_STAT_POSTED = STATS_CONTRACTS_GENERATED_DEFENSE,
		CONTRACT_STAT_TAKEN = STATS_CONTRACTS_TAKEN_DEFENSE,
		CONTRACT_STAT_COMPLETED = STATS_CONTRACTS_COMPLETED_DEFENSE,
		CONTRACT_STAT_LAPSED = STATS_CONTRACTS_LAPSED_DEFENSE,
	),
))

/proc/record_source_statistic(datum/quest/Q, metric)
	var/list/stats = GLOB.contract_source_stats[Q?.source]
	if(stats && stats[metric])
		record_round_statistic(stats[metric])

#define CONTRACT_AXIS_TYPE "type"
#define CONTRACT_AXIS_REGION "region"
#define CONTRACT_AXIS_GROUP "group"

#define CONTRACT_GROUP_NOBILITY "Nobility & Court"
#define CONTRACT_GROUP_GARRISON "Garrison"
#define CONTRACT_GROUP_CLERGY "Clergy"
#define CONTRACT_GROUP_BURGHERS "Burghers"
#define CONTRACT_GROUP_PEASANTS "Peasants"
#define CONTRACT_GROUP_OUTLAWS "Outlaws"
#define CONTRACT_GROUP_OTHER "Other"

GLOBAL_LIST_EMPTY(contract_stats)
GLOBAL_LIST_EMPTY(contract_signers)
GLOBAL_LIST_INIT(contract_stat_group_order, list(
	CONTRACT_GROUP_NOBILITY,
	CONTRACT_GROUP_GARRISON,
	CONTRACT_GROUP_CLERGY,
	CONTRACT_GROUP_BURGHERS,
	CONTRACT_GROUP_PEASANTS,
	CONTRACT_GROUP_OUTLAWS,
	CONTRACT_GROUP_OTHER,
))

/proc/contract_signer_group(mob/user)
	var/datum/job/J = user?.job ? SSjob.GetJob(user.job) : null
	if(!J)
		return CONTRACT_GROUP_OTHER
	switch(J.department_flag)
		if(NOBLEMEN, COURTIERS, RETINUE)
			return CONTRACT_GROUP_NOBILITY
		if(GARRISON)
			return CONTRACT_GROUP_GARRISON
		if(CHURCHMEN, INQUISITION)
			return CONTRACT_GROUP_CLERGY
		if(BURGHERS, ATC)
			return CONTRACT_GROUP_BURGHERS
		if(PEASANTS)
			return CONTRACT_GROUP_PEASANTS
		if(SIDEFOLK, WANDERERS)
			return J.title
		if(ANTAGONIST)
			return CONTRACT_GROUP_OUTLAWS
	return CONTRACT_GROUP_OTHER

/proc/record_contract_axis(axis, key, metric, amount)
	var/list/by_key = GLOB.contract_stats[axis]
	if(!by_key)
		by_key = list()
		GLOB.contract_stats[axis] = by_key
	var/list/row = by_key[key]
	if(!row)
		row = list()
		by_key[key] = row
	row[metric] = (row[metric] || 0) + amount

/proc/record_contract_stat(datum/quest/Q, metric, amount = 1)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!Q || !metric)
		return
	if(Q.quest_type)
		record_contract_axis(CONTRACT_AXIS_TYPE, Q.quest_type, metric, amount)
	if(Q.region)
		record_contract_axis(CONTRACT_AXIS_REGION, Q.region, metric, amount)
	if(Q.signer_group)
		record_contract_axis(CONTRACT_AXIS_GROUP, Q.signer_group, metric, amount)

/proc/record_contract_signer_axis(axis, key, ckey)
	if(!key)
		return
	var/list/by_key = GLOB.contract_signers[axis]
	if(!by_key)
		by_key = list()
		GLOB.contract_signers[axis] = by_key
	var/list/signers = by_key[key]
	if(!signers)
		signers = list()
		by_key[key] = signers
	signers[ckey] = TRUE

/proc/record_contract_signer(datum/quest/Q, ckey)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!Q || !ckey)
		return
	record_contract_signer_axis(CONTRACT_AXIS_TYPE, Q.quest_type, ckey)
	record_contract_signer_axis(CONTRACT_AXIS_REGION, Q.region, ckey)
	record_contract_signer_axis(CONTRACT_AXIS_GROUP, Q.signer_group, ckey)

/proc/get_contract_stat(axis, key, metric)
	var/list/by_key = GLOB.contract_stats[axis]
	var/list/row = by_key?[key]
	return row ? (row[metric] || 0) : 0

/proc/count_contract_signers(axis, key)
	var/list/by_key = GLOB.contract_signers[axis]
	return length(by_key?[key])

/proc/count_all_contract_signers()
	var/list/everyone = list()
	var/list/by_type = GLOB.contract_signers[CONTRACT_AXIS_TYPE]
	for(var/quest_type in by_type)
		everyone |= by_type[quest_type]
	return length(everyone)

/proc/contract_group_order()
	var/list/titles = list()
	for(var/group in GLOB.contract_stats[CONTRACT_AXIS_GROUP])
		if(!(group in GLOB.contract_stat_group_order))
			titles += group
	sortTim(titles, GLOBAL_PROC_REF(cmp_text_asc))
	var/list/order = GLOB.contract_stat_group_order.Copy()
	order.Insert(order.Find(CONTRACT_GROUP_OUTLAWS), titles)
	return order

// Same as above but for regions
/proc/contract_region_order()
	var/list/order = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat?.threat_regions)
		order += TR.region_name
	for(var/region in GLOB.contract_stats[CONTRACT_AXIS_REGION])
		order |= region
	return order

GLOBAL_LIST_EMPTY(patron_follower_counts)

// Featured stats of the round
#define FEATURED_STATS_TREE_FELLERS "tree_fellers"
#define FEATURED_STATS_THIEVES "thieves"
#define FEATURED_STATS_ALCHEMISTS "alchemists"
#define FEATURED_STATS_TAX_PAYERS "tax_payers"
#define FEATURED_STATS_ALCOHOLICS "alcohol_drinkers"
#define FEATURED_STATS_SMOKERS "smokers"
#define FEATURED_STATS_SPEAKERS "speakers"
#define FEATURED_STATS_FISHERS "fishers"
#define FEATURED_STATS_GOURMETS "gourmets"
#define FEATURED_STATS_SCREAMERS "screamers"
#define FEATURED_STATS_EMOS "emos"
#define FEATURED_STATS_MINERS "miners"
#define FEATURED_STATS_CRIMINALS "criminals"
#define FEATURED_STATS_MAGES "mages"
#define FEATURED_STATS_CRAFTERS "crafters"
#define FEATURED_STATS_FARMERS "farmers"
#define FEATURED_STATS_STORYTELLERS "storytellers"
#define FEATURED_STATS_VIRTUES	"virtues"
#define FEATURED_STATS_SUBVIRTUES	"subvirtues"
#define FEATURED_STATS_QUIRKS	"quirks"
#define FEATURED_STATS_ORIGINS	"origins"
#define FEATURED_STATS_STATPACKS "statpacks"
#define FEATURED_STATS_VICES	"vices"

// Featured objects stats
#define FEATURED_STATS_CRAFTED_ITEMS "crafted_items"
#define FEATURED_STATS_SPELLS "spells"
#define FEATURED_STATS_DRINKS "drinks"

GLOBAL_LIST_INIT(featured_stats, list(
	FEATURED_STATS_TREE_FELLERS = list(
		"name" = "TOP Lumberjacks",
		"color" = "#9b6937",
		"entries" = list()
	),
	FEATURED_STATS_TAX_PAYERS = list(
		"name" = "TOP Tax Payers",
		"color" = "#f1e35d",
		"entries" = list()
	),
	FEATURED_STATS_CRIMINALS = list(
		"name" = "TOP Criminals",
		"color" = "#bb6976",
		"entries" = list()
	),
	FEATURED_STATS_SPEAKERS = list(
		"name" = "TOP Speakers",
		"color" = "#93cabe",
		"entries" = list()
	),
	FEATURED_STATS_MINERS = list(
		"name" = "TOP Miners",
		"color" = "#bd8e60",
		"entries" = list()
	),
	FEATURED_STATS_ALCHEMISTS = list(
		"name" = "TOP Alchemists",
		"color" = "#3bac5d",
		"entries" = list()
	),
	FEATURED_STATS_STORYTELLERS = list(
		"name" = "TOP Reigning Gods",
		"color" = "#eeca2c",
		"entries" = list()
	),
	FEATURED_STATS_GOURMETS = list(
		"name" = "TOP Gourmets",
		"color" = "#6765cf",
		"entries" = list()
	),
	FEATURED_STATS_CRAFTED_ITEMS = list(
		"name" = "TOP Crafted Items",
		"color" = "#a5953a",
		"entries" = list(),
		"object_stat" = TRUE
	),
	FEATURED_STATS_FISHERS = list(
		"name" = "TOP Fishers",
		"color" = "#559bbb",
		"entries" = list()
	),
	FEATURED_STATS_CRAFTERS = list(
		"name" = "TOP Crafters",
		"color" = "#a8a24e",
		"entries" = list()
	),
	FEATURED_STATS_FARMERS = list(
		"name" = "TOP Farmers",
		"color" = "#50eb77",
		"entries" = list()
	),
	FEATURED_STATS_DRINKS = list(
		"name" = "TOP Beverages",
		"color" = "#5487c0",
		"entries" = list(),
		"object_stat" = TRUE
	),
	FEATURED_STATS_SCREAMERS = list(
		"name" = "TOP Screamers",
		"color" = "#d34747",
		"entries" = list()
	),
	FEATURED_STATS_EMOS = list(
		"name" = "TOP Emotionals",
		"color" = "#48505e", // im blue da ba de ba da die
		"entires" = list()
	),
	FEATURED_STATS_THIEVES = list(
		"name" = "TOP Thieves",
		"color" = "#6e4a25",
		"entries" = list()
	),
	FEATURED_STATS_ALCOHOLICS = list(
		"name" = "TOP Alcoholics",
		"color" = "#945d96",
		"entries" = list()
	),
	FEATURED_STATS_SMOKERS = list(
		"name" = "TOP Blacklungs",
		"color" = "#2e201c",
		"entries" = list()
	),
	FEATURED_STATS_MAGES = list(
		"name" = "TOP Mages",
		"color" = "#9eaceb",
		"entries" = list()
	),
	FEATURED_STATS_SPELLS = list(
		"name" = "TOP Spells",
		"color" = "#6375c5",
		"entries" = list(),
		"object_stat" = TRUE
	),
	FEATURED_STATS_ORIGINS = list(
		"name" = "TOP Origins",
		"color" = "#602d91",
		"entries" = list(),
		"object_stat" = TRUE,
	),
	FEATURED_STATS_VIRTUES = list(
		"name" = "TOP Virtues",
		"color" = "#df5cb8",
		"entries" = list(),
		"object_stat" = TRUE,
		"admin_only" = TRUE
	),
	FEATURED_STATS_SUBVIRTUES = list(
		"name" = "TOP Subvirtues",
		"color" = "#8d3c75",
		"entries" = list(),
		"object_stat" = TRUE,
		"admin_only" = TRUE
	),
	FEATURED_STATS_QUIRKS = list(
		"name" = "TOP Quirks",
		"color" = "#f09fd6",
		"entries" = list(),
		"object_stat" = TRUE,
		"admin_only" = TRUE
	),
	FEATURED_STATS_STATPACKS = list(
		"name" = "TOP Statpacks",
		"color" = "#3aa4e2",
		"entries" = list(),
		"object_stat" = TRUE,
		"admin_only" = TRUE
	),
	FEATURED_STATS_VICES = list(
		"name" = "TOP 10 Vices",
		"color" = "#791368",
		"entries" = list(),
		"object_stat" = TRUE
	),))

// Chronicle statistics
#define CHRONICLE_STATS_STRONGEST_PERSON "strongest_person"
#define CHRONICLE_STATS_WISEST_PERSON "wisest_person"
#define CHRONICLE_STATS_RICHEST_PERSON "richest_person"
#define CHRONICLE_STATS_LUCKIEST_PERSON "luckiest_person"
#define CHRONICLE_STATS_FASTEST_PERSON "fastest_person"
#define CHRONICLE_STATS_DUMBEST_PERSON "dumbest_person"
#define CHRONICLE_STATS_SLOWEST_PERSON "slowest_person"
#define CHRONICLE_STATS_UNLUCKIEST_PERSON "unluckiest_person"

GLOBAL_LIST_EMPTY(chronicle_stats)

/// Increment a round statistic by a given amount
/proc/record_round_statistic(name, amount = 1)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!name)
		return

	GLOB.azure_round_stats[name] = (GLOB.azure_round_stats[name] || 0) + amount

/// Force set a value of a specific round statistic to a given value
/proc/force_set_round_statistic(name, value)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!name)
		return

	GLOB.azure_round_stats[name] = value

/proc/format_top_stats(stat_category)
	var/list/stat_data = GLOB.featured_stats[stat_category]
	if(!stat_data || !stat_data["entries"])
		return "Nobody"

	var/list/entries = list()
	for(var/key in stat_data["entries"])
		entries += list(list("name" = key, "count" = stat_data["entries"][key]))

	sortTim(entries, GLOBAL_PROC_REF(cmp_stat_count_desc))

	var/list/result = list()
	for(var/i in 1 to min(14, entries.len))
		var/list/entry = entries[i]
		var/rounded_count = round(entry["count"])
		result += "[i]. [entry["name"]] - [rounded_count]"

	return result.Join("<br>")

/proc/format_top_stats_objects(stat_category)
	var/list/stat_data = GLOB.featured_stats[stat_category]
	if(!stat_data || !stat_data["entries"])
		return "None"

	var/list/entries = list()
	for(var/key in stat_data["entries"])
		entries += list(list("name" = key, "count" = stat_data["entries"][key]))

	sortTim(entries, GLOBAL_PROC_REF(cmp_stat_count_desc))

	var/list/result = list()
	for(var/i in 1 to min(14, entries.len))
		var/list/entry = entries[i]
		var/rounded_count = round(entry["count"])
		result += "[i]. [entry["name"]] - [rounded_count]"

	return result.Join("<br>")

/proc/cmp_stat_count_desc(list/a, list/b)
	return b["count"] - a["count"]

/proc/cmp_realm_hails_desc(list/a, list/b)
	return b["hails"] - a["hails"]

/proc/record_featured_stat(stat_category, mob/living/user, increment = 1)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!stat_category || !user?.real_name || !GLOB.featured_stats[stat_category])
		return
	if(!user)
		return

	var/list/stat_data = GLOB.featured_stats[stat_category]
	var/job_title = ""

	if(user.mind?.assigned_role)
		if(user.gender == FEMALE && user.mind.assigned_role)
			job_title = " ([user.mind.assigned_role])"
		else
			job_title = " ([user.mind.assigned_role])"
	else if(user.mind?.special_role)
		job_title = " ([user.mind.special_role])"
	else if(user.job && user.job != "Unassigned")
		job_title = " ([user.job])"

	var/key = "[user.real_name][job_title]"

	if(!stat_data["entries"])
		stat_data["entries"] = list()

	stat_data["entries"][key] = (stat_data["entries"][key] || 0) + increment

/proc/record_featured_object_stat(stat_category, object_name, increment = 1)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!stat_category || !object_name || !GLOB.featured_stats[stat_category])
		return

	var/list/stat_data = GLOB.featured_stats[stat_category]

	if(!stat_data["entries"])
		stat_data["entries"] = list()

	stat_data["entries"][object_name] = (stat_data["entries"][object_name] || 0) + increment

/// Records a chronicle stat (weakref to an atom/mob)
/proc/set_chronicle_stat(stat_name, atom/target)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return
	if(!stat_name || !target || !GLOB.chronicle_stats)
		return

	GLOB.chronicle_stats[stat_name] = WEAKREF(target)

/// Gets the recorded chronicle stat holder (returns the resolved weakref or null)
/proc/get_chronicle_stat_holder(stat_name)
	if(!stat_name || !GLOB.chronicle_stats)
		return null

	var/datum/weakref/ref = GLOB.chronicle_stats[stat_name]
	return ref?.resolve()
