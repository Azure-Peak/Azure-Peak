GLOBAL_LIST_INIT(towner_building_supplies_regions, list(
	THREAT_REGION_MOUNT_DECAP,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_building_supplies_factions, list(
	QUEST_FACTION_TARICHEA_DEADITE,
	QUEST_FACTION_MADMAN,
	QUEST_FACTION_MOUNTAIN_TROLL,
))

GLOBAL_LIST_INIT(towner_building_supplies_varieties, list(
	CARAVAN_VARIETY_BUILDING_SUPPLIES = list(
		"label" = "Building Supplies",
		"blurb" = "A supply of materials for constructing dwellings.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/grown/log/tree/small, "min" = 12, "max" = 16, "noun" = "wood"),
				list("path" = /obj/item/natural/wood/plank, "min" = 10, "max" = 12, "noun" = "plank"),
				list("path" = /obj/item/natural/stone, "min" = 16, "max" = 20, "noun" = "stone"),
				list("path" = /obj/item/natural/stoneblock, "min" = 10, "max" = 12, "noun" = "stone"),
				list("path" = /obj/item/ingot/iron, "min" = 2, "max" = 4, "noun" = "iron ingot"),
				list("path" = /obj/item/rogueore/coal, "min" = 2, "max" = 4, "noun" = "coal"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/grown/log/tree/small, "min" = 20, "max" = 24, "noun" = "wood"),
				list("path" = /obj/item/natural/wood/plank, "min" = 20, "max" = 24, "noun" = "plank"),
				list("path" = /obj/item/natural/stone, "min" = 30, "max" = 35, "noun" = "stone"),
				list("path" = /obj/item/natural/stoneblock, "min" = 20, "max" = 24, "noun" = "stone"),
				list("path" = /obj/item/construction/nail, "min" = 6, "max" = 10, "noun" = "nail"),
				list("path" = /obj/item/ingot/iron, "min" = 4, "max" = 8, "noun" = "iron ingot"),
				list("path" = /obj/item/rogueore/coal, "min" = 4, "max" = 8, "noun" = "coal"),
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

/datum/quest/kill/recovery/towner/building_supplies
	quest_type = QUEST_TOWNER_BUILDING_SUPPLIES
	parcel_label = "recovered building supplies"

/datum/quest/kill/recovery/towner/building_supplies/get_eligible_regions()
	return GLOB.towner_building_supplies_regions

/datum/quest/kill/recovery/towner/building_supplies/get_varieties()
	return GLOB.towner_building_supplies_varieties

/datum/quest/kill/recovery/towner/building_supplies/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/building_supplies/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Supplies"
	return "A Stash of Building Supplies"

/datum/quest/kill/recovery/towner/building_supplies/get_objective_text()
	return "Clear the wreck and carry the building supplies back to [quest_giver_name || "the builder"]."

/datum/quest/kill/recovery/towner/building_supplies/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "beasts"
	return "[quest_giver_name || "The builder"]'s caravan was raided by [raiders] on the road within [region]. They call for hands to get their materials back."

/datum/quest/kill/recovery/towner/building_supplies/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/building_supplies/pick_region_faction_for(datum/threat_region/TR)
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

/datum/quest/kill/recovery/towner/building_supplies/build_bundle()
	var/list/meta = GLOB.towner_building_supplies_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
