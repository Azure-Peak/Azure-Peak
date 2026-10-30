/datum/quest/kill/recovery/gm
	quest_type = QUEST_GM_RECOVERY
	chronicle_order = QUEST_CHRONICLE_ORDER_GM
	quest_difficulty = QUEST_DIFFICULTY_SPECIAL
	pool_kind = null
	pool_weight = 0
	rumor_cost = 0
	eligible_regions = list()
	lapses = FALSE
	var/list/quest_mobs = list()
	var/list/quest_items = list()
	var/objective_text
	var/group_word
	var/foe_name

/datum/quest/kill/recovery/gm/get_objective_text()
	return objective_text || ..()

/datum/quest/kill/recovery/gm/materialize(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(.)
		message_admins("A custom quest ([title]) has spawned its landmark at [ADMIN_VERBOSEJMP(landmark)].")

/datum/quest/kill/recovery/gm/pick_region_faction_for(datum/threat_region/TR)
	return new /datum/quest_faction/gm(group_word, foe_name)

/datum/quest/kill/recovery/gm/pick_shipment()
	target_delivery_location = override_destination
	return !!target_delivery_location

/datum/quest/kill/recovery/gm/compose_warband()
	return quest_mobs.Copy()

/datum/quest/kill/recovery/gm/build_bundle()
	return quest_items.Copy()
