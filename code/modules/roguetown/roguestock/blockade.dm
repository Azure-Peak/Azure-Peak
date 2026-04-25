GLOBAL_LIST_EMPTY(active_blockades)

/datum/blockade
	var/region_id
	var/threat_region_name
	var/faction_id
	var/day_started = 0
	var/datum/weakref/active_scroll_ref

/datum/blockade/proc/get_region()
	return GLOB.economic_regions[region_id]

/datum/blockade/proc/get_threat_region()
	if(!threat_region_name)
		return null
	return SSregionthreat.get_region(threat_region_name)

/datum/blockade/proc/get_faction()
	if(!faction_id)
		return null
	return get_quest_faction(faction_id)

/datum/blockade/proc/has_active_scroll()
	var/obj/item/quest_writ/S = active_scroll_ref?.resolve()
	return !QDELETED(S)
