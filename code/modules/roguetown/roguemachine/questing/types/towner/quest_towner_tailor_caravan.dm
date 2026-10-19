GLOBAL_LIST_INIT(towner_tailor_caravan_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_tailor_caravan_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_SEA_GOBLIN,
	QUEST_FACTION_GRONNMAN,
))

GLOBAL_LIST_INIT(towner_tailor_caravan_varieties, list(
	CARAVAN_VARIETY_LEATHERS = list(
		"label" = "Hides & Furs",
		"blurb" = "A supply of hides and furs for leatherworking.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/natural/hide/cured, "min" = 12, "max" = 16, "noun" = "cured hide"),
				list("path" = /obj/item/natural/fur, "min" = 11, "max" = 15, "noun" = "fur"),
				list("path" = /obj/item/reagent_containers/food/snacks/tallow, "min" = 3, "max" = 5, "noun" = "tallow"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/natural/hide/cured, "min" = 18, "max" = 24, "noun" = "cured hide"),
				list("path" = /obj/item/natural/fur, "min" = 18, "max" = 24, "noun" = "fur"),
				list("path" = /obj/item/reagent_containers/food/snacks/tallow, "min" = 6, "max" = 10, "noun" = "tallow"),
				list("path" = /obj/item/natural/fur/direbear, "min" = 1, "max" = 3, "noun" = "dire bear fur"),
			),
		),
	),
	CARAVAN_VARIETY_SILKS = list(
		"label" = "Silks & Cloth",
		"blurb" = "A selection of silks and cloths for tailoring.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/natural/bundle/cloth/roll, "min" = 3, "max" = 5, "noun" = "rolls of cloth"),
				list("path" = /obj/item/natural/silk, "min" = 14, "max" = 20, "noun" = "silk"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/natural/bundle/cloth/roll, "min" = 5, "max" = 8, "noun" = "rolls of cloth"),
				list("path" = /obj/item/natural/silk, "min" = 24, "max" = 30, "noun" = "silk"),
				list("path" = /obj/item/natural/cured/essence, "min" = 3, "max" = 5, "noun" = "essence of wilderness"),
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

/datum/quest/kill/recovery/towner/tailor_caravan
	quest_type = QUEST_TOWNER_TAILOR_CARAVAN
	parcel_label = "recovered materials"

/datum/quest/kill/recovery/towner/tailor_caravan/get_eligible_regions()
	return GLOB.towner_tailor_caravan_regions

/datum/quest/kill/recovery/towner/tailor_caravan/get_varieties()
	return GLOB.towner_tailor_caravan_varieties

/datum/quest/kill/recovery/towner/tailor_caravan/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/tailor_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Missing"

/datum/quest/kill/recovery/towner/tailor_caravan/get_objective_text()
	return "Clear the wreck and carry the strongbox back to [quest_giver_name || "the tailor"]."

/datum/quest/kill/recovery/towner/tailor_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The tailor"]'s caravan was taken by [raiders] on the road within [region]. They call for hands to get their materials back."

/datum/quest/kill/recovery/towner/tailor_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/tailor_caravan/pick_region_faction_for(datum/threat_region/TR)
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

/datum/quest/kill/recovery/towner/tailor_caravan/build_bundle()
	var/list/meta = GLOB.towner_tailor_caravan_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
