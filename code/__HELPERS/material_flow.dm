GLOBAL_LIST_EMPTY(material_demand_fulfilled)
GLOBAL_LIST_EMPTY(material_scrap_supplied)
GLOBAL_LIST_EMPTY(material_scrap_value)

/proc/material_flow_name(path)
	if(!path)
		return "Unknown"
	var/atom/A = path
	return capitalize(initial(A.name))

// Cancelled, expired or rejecfted order won't count
/proc/record_material_demand_fulfilled(path, amount = 1)
	if(!path || amount <= 0)
		return
	GLOB.material_demand_fulfilled[path] = (GLOB.material_demand_fulfilled[path] || 0) + amount
	record_round_statistic(STATS_COMMISSION_MATERIALS_FULFILLED, amount)

/proc/record_material_scrapped(path, units = 1, value = 0)
	if(!path || units <= 0)
		return
	GLOB.material_scrap_supplied[path] = (GLOB.material_scrap_supplied[path] || 0) + units
	record_round_statistic(STATS_SCRAP_UNITS_SUPPLIED, units)
	if(value > 0)
		GLOB.material_scrap_value[path] = (GLOB.material_scrap_value[path] || 0) + value
		record_round_statistic(STATS_SCRAP_MAMMONS_PAID, value)

// We will also count any live order at roundend as part of the demand
/proc/build_material_demand_outstanding()
	var/list/out = list()
	for(var/obj/structure/roguemachine/escrow/E in GLOB.escrow_machines)
		for(var/datum/escrow_order/O in E.orders)
			if(O.status == "complete")
				continue
			var/list/tally = O.material_tally(E)
			for(var/path in tally)
				out[path] = (out[path] || 0) + tally[path]
	return out

/proc/cmp_material_demand_desc(list/a, list/b)
	return b["demanded"] - a["demanded"]

/proc/cmp_material_supply_desc(list/a, list/b)
	return b["units"] - a["units"]
