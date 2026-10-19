GLOBAL_LIST_INIT(towner_clay_deposit_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_UNDERDARK,
))

GLOBAL_LIST_INIT(towner_clay_deposit_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_SEA_GOBLIN,
	QUEST_FACTION_GRONNMAN,
))

GLOBAL_LIST_INIT(towner_clay_deposit_varieties, list(
	DEPOSIT_VARIETY_CLAY = list(
		"label" = "Pottering Materials",
		"blurb" = "A large deposit of clay, alongside some glass and coal.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/natural/clay, "min" = 24, "max" = 30, "noun" = "clay"),
				list("path" = /obj/item/natural/glass, "min" = 10, "max" = 14, "noun" = "glass"),
				list("path" = /obj/item/rogueore/coal, "min" = 5, "max" = 8, "noun" = "coal"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/natural/clay, "min" = 35, "max" = 45, "noun" = "clay"),
				list("path" = /obj/item/natural/glass, "min" = 20, "max" = 25, "noun" = "glass"),
				list("path" = /obj/item/rogueore/coal, "min" = 10, "max" = 15, "noun" = "coal"),
			),
		),
	),
))

/*
GLOBAL_LIST_INIT(towner_caravan_tier_tp, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_CARAVAN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_CARAVAN_TP_BUDGET_HARD,
))
*/

/datum/quest/kill/recovery/towner/clay_deposit
	quest_type = QUEST_TOWNER_CLAY_DEPOSIT
	parcel_label = "recovered materials"

/datum/quest/kill/recovery/towner/clay_deposit/get_eligible_regions()
	return GLOB.towner_clay_deposit_regions

/datum/quest/kill/recovery/towner/clay_deposit/get_varieties()
	return GLOB.towner_clay_deposit_varieties

/datum/quest/kill/recovery/towner/clay_deposit/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/clay_deposit/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Deposit"
	return "A Clay Deposit"

/datum/quest/kill/recovery/towner/clay_deposit/get_objective_text()
	return "Clear the digsite and carry the strongbox back to [quest_giver_name || "the potter"]."

/datum/quest/kill/recovery/towner/clay_deposit/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The potter"]'s deposit was taken by [raiders] in [region]. They call for hands to get their materials back."

/datum/quest/kill/recovery/towner/clay_deposit/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/clay_deposit/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		if(!(id in GLOB.towner_missing_runner_factions))
			continue
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/datum/quest/kill/recovery/towner/clay_deposit/build_bundle()
	var/list/meta = GLOB.towner_clay_deposit_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
