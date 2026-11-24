GLOBAL_LIST_INIT(economic_regions, init_economic_regions())

/proc/init_economic_regions()
	var/list/result = list()
	for(var/datum/economic_region/er as anything in subtypesof(/datum/economic_region))
		var/datum/economic_region/instance = new er()
		if(!instance.region_id)
			continue
		result[instance.region_id] = instance
	return result

/datum/economic_region
	var/region_id
	var/name
	var/description = ""
	var/subroute
	var/list/region_types = list()
	var/list/produces = list()
	var/list/demands = list()
	var/list/supply_sources = list()
	var/list/demand_sources = list()
	var/list/tribute_goods = list()
	var/list/estate_goods = list()
	var/list/gifts = list()
	var/tribute_day = -1
	var/list/request_kinds = list()
	var/associated_marker_id
	var/is_region_blockaded = FALSE
	/// Null = this region cannot be blockaded.
	var/threat_region_id

	/// -1 = never cleared. Otherwise the cooldown window runs from this day.
	var/day_last_cleared = -1

/datum/economic_region/New()
	. = ..()
	if(subroute)
		threat_region_id = get_subroute_threat_region(subroute)
	build_trade_lists()
	if(!associated_marker_id)
		associated_marker_id = "[region_id]_blockade"

/datum/economic_region/proc/build_trade_lists()
	var/list/supply = list()
	var/list/demand = list()
	for(var/type_path in region_types)
		var/multiplier = region_types[type_path]
		var/datum/region_type/region_type = new type_path()
		add_type_volumes(supply, supply_sources, region_type, region_type.produces, multiplier)
		add_type_volumes(demand, demand_sources, region_type, region_type.demands, multiplier)
		for(var/datum/request_kind/kind as anything in region_type.request_kinds)
			request_kinds[kind] = initial(kind.roll_weight)
	for(var/good_id in supply)
		demand -= good_id
		demand_sources -= good_id
	produces = supply
	demands = demand

/datum/economic_region/proc/add_type_volumes(list/into, list/sources, datum/region_type/region_type, list/volumes, multiplier)
	for(var/good_id in volumes)
		var/volume = scaled_volume(volumes[good_id], multiplier)
		if(volume <= (into[good_id] || 0))
			continue
		into[good_id] = volume
		sources[good_id] = region_type

/datum/economic_region/proc/scaled_volume(volume, multiplier)
	return max(1, round(volume * multiplier, 1))

/datum/economic_region/proc/trade_type_rows(list/volumes, list/sources, demand = FALSE)
	var/list/by_type = list()
	for(var/good_id in volumes)
		if(!GLOB.trade_goods[good_id])
			continue
		var/datum/region_type/source = sources[good_id]
		if(!source)
			continue
		var/list/row = by_type[source.type]
		if(!row)
			row = list("type" = source.name, "size" = region_size_label(region_types[source.type]), "goods" = list())
			by_type[source.type] = row
		var/list/goods = row["goods"]
		var/share = demand ? SSeconomy.good_demand_share(good_id, region_id) : SSeconomy.good_supply_share(good_id, region_id)
		goods += list(list("good_id" = good_id, "share" = share, "volume" = volumes[good_id]))
	var/list/rows = list()
	for(var/type_path in region_types)
		if(by_type[type_path])
			rows += list(by_type[type_path])
	return rows

/proc/region_size_label(multiplier)
	if(multiplier <= REGION_SIZE_SMALL)
		return "small"
	if(multiplier <= REGION_SIZE_MEDIUM)
		return "medium"
	if(multiplier <= REGION_SIZE_LARGE)
		return "large"
	if(multiplier <= REGION_SIZE_HUGE)
		return "huge"
	return "massive"

/datum/economic_region/proc/tribute_units()
	var/list/units = list()
	if(!length(tribute_goods))
		return units
	var/value = TRIBUTE_VALUE * SSeconomy.tribute_pop_mult() / length(tribute_goods)
	for(var/good_id in tribute_goods)
		var/price = SSeconomy.good_steady_price(good_id)
		if(price <= 0)
			continue
		units[good_id] = max(1, round(value / price))
	return units

/datum/economic_region/proc/tribute_blocker()
	if(!length(tribute_goods))
		return "[name] has no tribute."
	if(is_region_blockaded)
		return "[name] is blockaded. No tribute will come through until it is cleared."
	if(tribute_day == ECONOMY_DAY)
		return "[name] has already sent its tribute today."
	return null

/datum/economic_region/proc/take_tribute()
	tribute_day = ECONOMY_DAY
	return tribute_units()

/datum/economic_region/proc/deliver_tribute(list/units)
	for(var/good_id in units)
		var/datum/roguestock/D = SSeconomy.find_stockpile_by_trade_good(good_id)
		if(!D)
			continue
		D.royal_stock += units[good_id]
		record_material_flow(MATERIAL_FLOW_IN, MATERIAL_SOURCE_LOCAL_IMPORT, D.item_type, units[good_id])
	deliver_gifts()

/datum/economic_region/proc/deliver_gifts()
	if(!length(gifts))
		return
	var/turf/drop = SSeconomy.warehouse_drop_turf()
	if(!drop)
		return
	var/obj/item/smallDelivery/parcel = new(drop)
	parcel.name = "gift from [name]"
	var/gift_type = pick(gifts)
	var/obj/item/gift = new gift_type(parcel)
	gift.mark_as_gift()

/proc/gift_names(list/gift_types)
	var/list/names = list()
	for(var/obj/item/gift_type as anything in gift_types)
		names += initial(gift_type.name)
	return names

/// Builds the AZURIA'S REGIONS section of the Lore Primer from the economic_region datums,
/// so steward UI prose and primer prose stay in sync from a single source.
/proc/build_regions_primer_html()
	var/list/parts = list()
	parts += "<details>"
	parts += "<summary><strong><span style='font-size:130%'> REGIONS OF AZURIA </span></strong></summary>"
	parts += "<strong><span style='font-size:115%'> THE INTERNAL VASSALS AND DEMESNES </span></strong>"
	parts += "<br><br>"
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region)
			continue
		parts += "<details>"
		parts += "<summary><strong> [uppertext(region.name)] </strong></summary>"
		parts += "<br>"
		parts += region.description
		parts += "<br>"
		parts += "</details>"
	parts += "<br><br>"
	parts += "</details>"
	return jointext(parts, "\n")
