GLOBAL_LIST_INIT(towner_cheesemaker_caravan_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_cheesemaker_caravan_factions, list(
	QUEST_FACTION_GREAT_BEAST,
	QUEST_FACTION_WILD_BEAST,
	QUEST_FACTION_MINOTAUR,
))

GLOBAL_LIST_INIT(towner_cheesemaker_caravan_varieties, list(
	CARAVAN_VARIETY_CHEESEMAKER = list(
		"label" = "Cheesemaking Supplies",
		"blurb" = "A supply of butter and milk for brewing cheese.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/reagent_containers/powder/salt, "min" = 12, "max" = 16, "noun" = "salt"),
				list("path" = /obj/item/reagent_containers/glass/bottle/waterskin/milk, "min" = 3, "max" = 5, "noun" = "milk skin"),
				list("path" = /obj/item/reagent_containers/food/snacks/butter, "min" = 3, "max" = 5, "noun" = "butter"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/reagent_containers/powder/salt, "min" = 20, "max" = 24, "noun" = "salt"),
				list("path" = /obj/item/reagent_containers/glass/bottle/waterskin/milk, "min" = 5, "max" = 8, "noun" = "milk skin"),
				list("path" = /obj/item/reagent_containers/food/snacks/butter, "min" = 5, "max" = 8, "noun" = "butter"),
				list("path" = /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel, "min" = 1, "max" = 2, "noun" = "cheese wheel"),
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

/datum/quest/kill/recovery/towner/cheesemaker_caravan
	quest_type = QUEST_TOWNER_CHEESEMAKER_CARAVAN
	parcel_label = "recovered cheesemaking supplies"

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_eligible_regions()
	return GLOB.towner_cheesemaker_caravan_regions

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_varieties()
	return GLOB.towner_cheesemaker_caravan_varieties

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Missing"

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_objective_text()
	return "Clear the wreck and carry the cheesy supplies back to [quest_giver_name || "the cheesemaker"]."

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "beasts"
	return "[quest_giver_name || "The cheesemaker"]'s caravan was swarmed by [raiders] on the road within [region]. They call for hands to get their supplies back."

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/cheesemaker_caravan/pick_region_faction_for(datum/threat_region/TR)
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

/datum/quest/kill/recovery/towner/cheesemaker_caravan/build_bundle()
	var/list/meta = GLOB.towner_cheesemaker_caravan_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
