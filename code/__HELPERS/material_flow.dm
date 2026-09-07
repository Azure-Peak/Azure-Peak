#define MATERIAL_FLOW_IN "in"
#define MATERIAL_FLOW_OUT "out"

#define MATERIAL_SOURCE_DOMESTIC "Town Smelting"
#define MATERIAL_SOURCE_SCRAP "Scrapping"
#define MATERIAL_SOURCE_LOCAL_IMPORT "Local Import"
#define MATERIAL_SOURCE_MERCHANT_IMPORT "Merchant Import"
#define MATERIAL_SOURCE_COMMISSIONER "Commissioner"
#define MATERIAL_SOURCE_SMELTING "Smelted Down"
#define MATERIAL_SOURCE_STANDING_ORDER "Standing Order"
#define MATERIAL_SOURCE_LOCAL_EXPORT "Local Export"
#define MATERIAL_SOURCE_FOREIGN_EXPORT "Foreign Export"
#define MATERIAL_SOURCE_BLACK_MARKET "Black Market"

GLOBAL_LIST_INIT(material_flow_columns, list(
	list("code" = "DOM", "label" = MATERIAL_SOURCE_DOMESTIC, "dir" = MATERIAL_FLOW_IN),
	list("code" = "SCR", "label" = MATERIAL_SOURCE_SCRAP, "dir" = MATERIAL_FLOW_IN),
	list("code" = "LCL", "label" = MATERIAL_SOURCE_LOCAL_IMPORT, "dir" = MATERIAL_FLOW_IN),
	list("code" = "FOR", "label" = MATERIAL_SOURCE_MERCHANT_IMPORT, "dir" = MATERIAL_FLOW_IN),
	list("code" = "CMS", "label" = MATERIAL_SOURCE_COMMISSIONER, "dir" = MATERIAL_FLOW_OUT),
	list("code" = "SMT", "label" = MATERIAL_SOURCE_SMELTING, "dir" = MATERIAL_FLOW_OUT),
	list("code" = "STO", "label" = MATERIAL_SOURCE_STANDING_ORDER, "dir" = MATERIAL_FLOW_OUT),
	list("code" = "LXP", "label" = MATERIAL_SOURCE_LOCAL_EXPORT, "dir" = MATERIAL_FLOW_OUT),
	list("code" = "EXP", "label" = MATERIAL_SOURCE_FOREIGN_EXPORT, "dir" = MATERIAL_FLOW_OUT),
	list("code" = "BM", "label" = MATERIAL_SOURCE_BLACK_MARKET, "dir" = MATERIAL_FLOW_OUT),
))

GLOBAL_LIST_INIT(material_flow_categories, list(
	list("code" = "METAL", "label" = "Metal", "parents" = list(
		/obj/item/ingot,
		/obj/item/rogueore,
	)),
	list("code" = "TAILOR", "label" = "Tailor", "parents" = list(
		/obj/item/natural/cloth,
		/obj/item/natural/silk,
		/obj/item/natural/fibers,
		/obj/item/natural/hide,
		/obj/item/natural/fur,
	)),
	list("code" = "FOOD", "label" = "Food", "parents" = list(
		/obj/item/reagent_containers/food/snacks,
	)),
	list("code" = "WOOD", "label" = "Wood", "parents" = list(
		/obj/item/grown/log,
		/obj/item/natural/wood,
	)),
))

GLOBAL_LIST_EMPTY(material_ledger)
GLOBAL_LIST_EMPTY(material_ledger_value)
GLOBAL_LIST_EMPTY(commission_mammons_paid)

/proc/material_flow_name(path)
	if(!path)
		return "Unknown"
	var/atom/A = path
	return capitalize(initial(A.name))

/proc/material_flow_category(path)
	if(!path)
		return null
	for(var/list/cat in GLOB.material_flow_categories)
		for(var/parent in cat["parents"])
			if(ispath(path, parent))
				return cat["code"]
	return null

/proc/is_tracked_material(path)
	return material_flow_category(path) ? TRUE : FALSE

/proc/material_source_code(source)
	for(var/list/col in GLOB.material_flow_columns)
		if(col["label"] == source)
			return col["code"]
	return null

/proc/record_material_flow(direction, source, path, units = 1, value = 0)
	if(!direction || !source || units <= 0)
		return
	if(!is_tracked_material(path))
		return
	var/list/bucket = GLOB.material_ledger[direction]
	if(!bucket)
		bucket = list()
		GLOB.material_ledger[direction] = bucket
	var/list/by_source = bucket[source]
	if(!by_source)
		by_source = list()
		bucket[source] = by_source
	by_source[path] = (by_source[path] || 0) + units
	if(direction == MATERIAL_FLOW_IN)
		record_round_statistic(STATS_MATERIAL_UNITS_IN, units)
	else
		record_round_statistic(STATS_MATERIAL_UNITS_OUT, units)
	if(value <= 0)
		return
	var/list/vbucket = GLOB.material_ledger_value[direction]
	if(!vbucket)
		vbucket = list()
		GLOB.material_ledger_value[direction] = vbucket
	var/list/vby_source = vbucket[source]
	if(!vby_source)
		vby_source = list()
		vbucket[source] = vby_source
	vby_source[path] = (vby_source[path] || 0) + value

/proc/record_commission_mammons(source, amount)
	if(!source || amount <= 0)
		return
	GLOB.commission_mammons_paid[source] = (GLOB.commission_mammons_paid[source] || 0) + amount
	record_round_statistic(STATS_COMMISSION_MAMMONS_PAID, amount)

/proc/build_material_demand_outstanding()
	var/list/out = list()
	for(var/obj/structure/roguemachine/escrow/E in GLOB.escrow_machines)
		for(var/datum/escrow_order/O in E.orders)
			if(O.status == "complete")
				continue
			var/list/tally = O.material_tally(E)
			for(var/path in tally)
				if(!is_tracked_material(path))
					continue
				out[path] = (out[path] || 0) + tally[path]
	return out

/proc/cmp_material_row_flow_desc(list/a, list/b)
	return (b["in"] + b["out"]) - (a["in"] + a["out"])
