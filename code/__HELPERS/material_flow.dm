#define MATERIAL_SOURCE_COMMISSIONER "Commissioner"
#define MATERIAL_SOURCE_TAILOR_COMMISSIONER "Tailoring Commissioner"
#define MATERIAL_SOURCE_SMITH_SCRAPPER "Smith's Scrapper"
#define MATERIAL_SOURCE_RAG_PICKER "Rag-Picker"

GLOBAL_LIST_INIT(material_flow_source_order, list(
	MATERIAL_SOURCE_COMMISSIONER,
	MATERIAL_SOURCE_TAILOR_COMMISSIONER,
	MATERIAL_SOURCE_SMITH_SCRAPPER,
	MATERIAL_SOURCE_RAG_PICKER,
))

GLOBAL_LIST_EMPTY(material_demand_fulfilled)
GLOBAL_LIST_EMPTY(material_scrap_supplied)
GLOBAL_LIST_EMPTY(material_scrap_value)
GLOBAL_LIST_EMPTY(commission_mammons_paid)

/proc/material_flow_name(path)
	if(!path)
		return "Unknown"
	var/atom/A = path
	return capitalize(initial(A.name))

/proc/material_flow_add(list/store, source, path, amount)
	if(!store || !source || !path || amount <= 0)
		return
	var/list/bucket = store[source]
	if(!bucket)
		bucket = list()
		store[source] = bucket
	bucket[path] = (bucket[path] || 0) + amount

// Cancelled, expired or rejecfted order won't count
/proc/record_material_demand_fulfilled(source, path, amount = 1)
	if(!source || !path || amount <= 0)
		return
	material_flow_add(GLOB.material_demand_fulfilled, source, path, amount)
	record_round_statistic(STATS_COMMISSION_MATERIALS_FULFILLED, amount)

/proc/record_commission_mammons(source, amount)
	if(!source || amount <= 0)
		return
	GLOB.commission_mammons_paid[source] = (GLOB.commission_mammons_paid[source] || 0) + amount
	record_round_statistic(STATS_COMMISSION_MAMMONS_PAID, amount)

/proc/record_material_scrapped(source, path, units = 1, value = 0)
	if(!source || !path || units <= 0)
		return
	material_flow_add(GLOB.material_scrap_supplied, source, path, units)
	record_round_statistic(STATS_SCRAP_UNITS_SUPPLIED, units)
	if(value > 0)
		material_flow_add(GLOB.material_scrap_value, source, path, value)
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
				material_flow_add(out, E.flow_source, path, tally[path])
	return out

/proc/cmp_material_demand_desc(list/a, list/b)
	return b["demanded"] - a["demanded"]

/proc/cmp_material_supply_desc(list/a, list/b)
	return b["units"] - a["units"]
