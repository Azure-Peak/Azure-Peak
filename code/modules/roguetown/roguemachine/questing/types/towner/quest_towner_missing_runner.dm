GLOBAL_LIST_INIT(towner_missing_runner_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_missing_runner_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_ORC,
	QUEST_FACTION_FOREST_GOBLIN,
))

GLOBAL_LIST_INIT(towner_missing_runner_varieties, list(
	CARAVAN_VARIETY_DRUGS = list(
		"label" = "Drugs",
		"blurb" = "A collection of mind and body altering substances.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/reagent_containers/powder/moondust, "min" = 1, "max" = 2, "noun" = "moondust"),
				list("path" = /obj/item/reagent_containers/powder/ozium, "min" = 3, "max" = 5, "noun" = "ozium"),
				list("path" = /obj/item/reagent_containers/powder/spice, "min" = 2, "max" = 4, "noun" = "spice"),
				list("path" = /obj/item/reagent_containers/powder/starsugar, "min" = 2, "max" = 4, "noun" = "spice"),
				list("path" = /obj/item/reagent_containers/powder/herozium, "min" = 1, "max" = 2, "noun" = "herozium"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/reagent_containers/powder/moondust_purest, "min" = 3, "max" = 5, "noun" = "pure moondust"),
				list("path" = /obj/item/reagent_containers/powder/ozium, "min" = 5, "max" = 7, "noun" = "ozium"),
				list("path" = /obj/item/reagent_containers/powder/spice, "min" = 4, "max" = 6, "noun" = "spice"),
				list("path" = /obj/item/reagent_containers/powder/starsugar, "min" = 4, "max" = 6, "noun" = "spice"),
				list("path" = /obj/item/reagent_containers/powder/herozium, "min" = 3, "max" = 5, "noun" = "herozium"),
			),
		),
	),
	CARAVAN_VARIETY_BOOZE = list(
		"label" = "Booze",
		"blurb" = "A selection of potent spirits and brews.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk, "min" = 2, "max" = 4, "noun" = "schnapps"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead, "min" = 2, "max" = 4, "noun" = "mead"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf, "min" = 2, "max" = 4, "noun" = "fireleaf"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/redwine, "min" = 2, "max" = 4, "noun" = "red wine"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk, "min" = 2, "max" = 5, "noun" = "schnapps"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead, "min" = 2, "max" = 5, "noun" = "mead"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf, "min" = 2, "max" = 5, "noun" = "fireleaf"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/redwine, "min" = 2, "max" = 5, "noun" = "red wine"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/elfblue, "min" = 1, "max" = 1, "noun" = "valmora blue"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/nocshine, "min" = 2, "max" = 5, "noun" = "nocshine"),
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

/datum/quest/kill/recovery/towner/missing_runner
	quest_type = QUEST_TOWNER_MISSING_RUNNER
	parcel_label = "recovered fun supplies"

/datum/quest/kill/recovery/towner/missing_runner/get_eligible_regions()
	return GLOB.towner_missing_runner_regions

/datum/quest/kill/recovery/towner/missing_runner/get_varieties()
	return GLOB.towner_missing_runner_varieties

/datum/quest/kill/recovery/towner/missing_runner/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/missing_runner/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Runner"
	return "A Runner Gone Missing"

/datum/quest/kill/recovery/towner/missing_runner/get_objective_text()
	return "Get revenge and carry the strongbox back to [quest_giver_name || "the client"]."

/datum/quest/kill/recovery/towner/missing_runner/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The client"]'s runner was taken by [raiders] on the road within [region]. They call for hands to get their stuff back."

/datum/quest/kill/recovery/towner/missing_runner/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/missing_runner/pick_region_faction_for(datum/threat_region/TR)
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

/datum/quest/kill/recovery/towner/missing_runner/build_bundle()
	var/list/meta = GLOB.towner_missing_runner_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
