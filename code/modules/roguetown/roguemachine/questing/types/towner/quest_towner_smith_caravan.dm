GLOBAL_LIST_INIT(towner_smith_caravan_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_smith_caravan_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_MOUNT_REAVER,
	QUEST_FACTION_BLEAKISLE_REAVER,
))

GLOBAL_LIST_INIT(towner_smith_caravan_bundle_ranges, list(
	TOWNER_POSTING_TIER_EASY = list(
		"iron" = list(6, 9),
		"bronze" = list(3, 5),
		"steel" = list(2, 4),
	),
	TOWNER_POSTING_TIER_MEDIUM = list(
		"iron" = list(11, 15),
		"bronze" = list(5, 8),
		"steel" = list(5, 8),
	),
	TOWNER_POSTING_TIER_HARD = list(
		"iron" = list(18, 24),
		"bronze" = list(9, 13),
		"steel" = list(10, 14),
	),
))

GLOBAL_LIST_INIT(towner_caravan_tier_tp, list(
	TOWNER_POSTING_TIER_EASY = TOWNER_CARAVAN_TP_BUDGET_EASY,
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_CARAVAN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_CARAVAN_TP_BUDGET_HARD,
))

/datum/quest/kill/recovery/towner/smith_caravan
	quest_type = QUEST_TOWNER_SMITH_CARAVAN
	parcel_label = "recovered ingots"

/datum/quest/kill/recovery/towner/smith_caravan/get_eligible_regions()
	return GLOB.towner_smith_caravan_regions

/datum/quest/kill/recovery/towner/smith_caravan/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_EASY

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
	var/list/ranges = GLOB.towner_smith_caravan_bundle_ranges[posting_tier] || GLOB.towner_smith_caravan_bundle_ranges[TOWNER_POSTING_TIER_EASY]
	var/list/bundle = list()
	bundle[/obj/item/ingot/iron] = rand(ranges["iron"][1], ranges["iron"][2])
	bundle[/obj/item/ingot/bronze] = rand(ranges["bronze"][1], ranges["bronze"][2])
	bundle[/obj/item/ingot/steel] = rand(ranges["steel"][1], ranges["steel"][2])
	return bundle
