//These ones are meant to be flavour, more than anything actually useful.
GLOBAL_LIST_INIT(towner_noble_trinket_regions, list(
	THREAT_REGION_MOUNT_DECAP,
	THREAT_REGION_AZUREAN_COAST,
	THREAT_REGION_TERRORBOG,
	THREAT_REGION_UNDERDARK,
))

GLOBAL_LIST_INIT(towner_noble_trinket_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_SEA_GOBLIN,
	QUEST_FACTION_GRONNMAN,
	QUEST_FACTION_FOREST_GOBLIN,
	QUEST_FACTION_ORC,
	QUEST_FACTION_BOGMAN,
	QUEST_FACTION_HELL_GOBLIN,
	QUEST_FACTION_MOUNT_REAVER,
	QUEST_FACTION_MADMAN,
	QUEST_FACTION_DROW,
	QUEST_FACTION_BLEAKISLE_REAVER,
))

/obj/item/paper/scroll/fake_evidence
	name = "Personal Documents"
	desc = "A document containing information very important to someone."
	info = "\[This document contains information that is very important to someone. It is likely that they would pay handsomely for its return.\]"

GLOBAL_LIST_INIT(towner_noble_trinket_varieties, list(
	CARAVAN_VARIETY_HEIRLOOM = list(
		"label" = "Heirloom",
		"blurb" = "An irreplacable family heirloom.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/clothing/neck/roguetown/ornateamulet/noble, "min" = 1, "max" = 1, "noun" = "heirloom amulet"),
				list("path" = /obj/item/rogueweapon/sword/long/heirloom, "min" = 1, "max" = 1, "noun" = "old longsword"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/clothing/ring/diamond, "min" = 1, "max" = 1, "noun" = "valuable heirloom ring"),
				list("path" = /obj/item/roguestatue/gold, "min" = 1, "max" = 2, "noun" = "golden statuette"),
			),
		),
	),
	CARAVAN_VARIETY_GEMS = list(
		"label" = "Gems",
		"blurb" = "A selection of precious gems.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/roguegem/ruby, "min" = 1, "max" = 1, "noun" = "rontz"),
				list("path" = /obj/item/roguegem/yellow, "min" = 0, "max" = 2, "noun" = "toper"),
				list("path" = /obj/item/roguegem/onyxa, "min" = 0, "max" = 2, "noun" = "onyxa"),
				list("path" = /obj/item/roguegem/amber, "min" = 0, "max" = 1, "noun" = "amber"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/roguegem/diamond, "min" = 1, "max" = 1, "noun" = "dorpel"),
				list("path" = /obj/item/roguegem/jade, "min" = 0, "max" = 2, "noun" = "jade"),
				list("path" = /obj/item/roguegem/violet, "min" = 0, "max" = 2, "noun" = "saffira"),
				list("path" = /obj/item/roguegem/green, "min" = 0, "max" = 3, "noun" = "gemerald"),
			),
		),
	),
	CARAVAN_VARIETY_COIN = list(
		"label" = "Coin",
		"blurb" = "Stolen Coin.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/roguecoin/gold/virtuepile, "min" = 1, "max" = 1, "noun" = "gold pile"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/roguecoin/gold/aspirantpile, "min" = 1, "max" = 1, "noun" = "gold pile"),
				list("path" = /obj/item/roguecoin/silver/pile, "min" = 1, "max" = 1, "noun" = "silver pile"),
			),
		),
	),
	CARAVAN_VARIETY_EVIDENCE = list(
		"label" = "Evidence",
		"blurb" = "Stolen documents containing compromising information.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/paper/scroll/fake_evidence, "min" = 1, "max" = 1, "noun" = "Document"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/paper/scroll/fake_evidence, "min" = 1, "max" = 1, "noun" = "Document"),
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

/datum/quest/kill/recovery/towner/noble_trinket
	quest_type = QUEST_TOWNER_VALUABLES
	parcel_label = "recovered trinkets"

/datum/quest/kill/recovery/towner/noble_trinket/get_eligible_regions()
	return GLOB.towner_noble_trinket_regions

/datum/quest/kill/recovery/towner/noble_trinket/get_varieties()
	return GLOB.towner_noble_trinket_varieties

/datum/quest/kill/recovery/towner/noble_trinket/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/noble_trinket/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Valuables"
	return "Missing Valuables"

/datum/quest/kill/recovery/towner/noble_trinket/get_objective_text()
	return "Clear the wreck and carry the strongbox back to [quest_giver_name || "the noble"]."

/datum/quest/kill/recovery/towner/noble_trinket/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The noble"]'s valuables were taken by [raiders] on the road within [region]. They call for hands to get their valuables back."

/datum/quest/kill/recovery/towner/noble_trinket/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/noble_trinket/pick_region_faction_for(datum/threat_region/TR)
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

/datum/quest/kill/recovery/towner/noble_trinket/build_bundle()
	var/list/meta = GLOB.towner_noble_trinket_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
