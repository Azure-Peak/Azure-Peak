/datum/quest/kill/recovery/gm
	quest_type = QUEST_GM_RECOVERY
	chronicle_order = QUEST_CHRONICLE_ORDER_GM
	quest_difficulty = QUEST_DIFFICULTY_SPECIAL
	pool_kind = null
	pool_weight = 0
	rumor_cost = 0
	eligible_regions = list()
	var/list/quest_mobs = list()
	var/list/quest_items = list()

/datum/quest/kill/recovery/gm/pick_region_faction_for(datum/threat_region/TR)
	return get_quest_faction(QUEST_FACTION_GM)

/datum/quest/kill/recovery/gm/pick_shipment()
	target_delivery_location = override_destination
	return !!target_delivery_location

/datum/quest/kill/recovery/gm/compose_warband()
	return quest_mobs.Copy()

/datum/quest/kill/recovery/gm/build_bundle()
	return quest_items.Copy()
