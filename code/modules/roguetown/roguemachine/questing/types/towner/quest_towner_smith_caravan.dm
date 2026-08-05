GLOBAL_LIST_INIT(towner_smith_caravan_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_smith_caravan_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_MOUNT_REAVER,
	QUEST_FACTION_BLEAKISLE_REAVER,
))

GLOBAL_LIST_INIT(towner_smith_caravan_varieties, list(
	CARAVAN_VARIETY_IRON = list(
		"label" = "Iron & Steel",
		"blurb" = "Iron and steel ingots.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/ingot/iron, "min" = 11, "max" = 15, "noun" = "iron"),
				list("path" = /obj/item/ingot/steel, "min" = 5, "max" = 8, "noun" = "steel"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/ingot/iron, "min" = 18, "max" = 24, "noun" = "iron"),
				list("path" = /obj/item/ingot/steel, "min" = 10, "max" = 14, "noun" = "steel"),
			),
		),
	),
	CARAVAN_VARIETY_BRONZE = list(
		"label" = "Bronze",
		"blurb" = "Cast bronze ingots.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/ingot/bronze, "min" = 8, "max" = 10, "noun" = "bronze"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/ingot/bronze, "min" = 14, "max" = 16, "noun" = "bronze"),
			),
		),
	),
	CARAVAN_VARIETY_BULLION = list(
		"label" = "Bullion",
		"blurb" = "A strongbox of gold bullion.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/ingot/gold, "min" = 3, "max" = 4, "noun" = "gold"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/ingot/gold, "min" = 6, "max" = 7, "noun" = "gold"),
			),
		),
	),
))

GLOBAL_LIST_INIT(towner_caravan_tier_tp, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_CARAVAN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_CARAVAN_TP_BUDGET_HARD,
))

/datum/quest/kill/recovery/towner/smith_caravan
	quest_type = QUEST_TOWNER_SMITH_CARAVAN
	parcel_label = "recovered ingots"

/datum/quest/kill/recovery/towner/smith_caravan/get_eligible_regions()
	return GLOB.towner_smith_caravan_regions

/datum/quest/kill/recovery/towner/smith_caravan/get_varieties()
	return GLOB.towner_smith_caravan_varieties

/datum/quest/kill/recovery/towner/smith_caravan/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/smith_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Gone Missing"

/datum/quest/kill/recovery/towner/smith_caravan/get_objective_text()
	return "Clear the wreck and carry the strongbox back to [quest_giver_name || "the smith"]."

/datum/quest/kill/recovery/towner/smith_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The smith"]'s wagon was lost on the road within [region], taken by [raiders]. They call for hands to clear the wreck and bring the strongbox home."

/datum/quest/kill/recovery/towner/smith_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name] - only they can open it."

/datum/quest/kill/recovery/towner/smith_caravan/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		if(!(id in GLOB.towner_smith_caravan_factions))
			continue
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/datum/quest/kill/recovery/towner/smith_caravan/build_bundle()
	var/list/meta = GLOB.towner_smith_caravan_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
