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
	/// Italicized one-liner shown beneath the region name in the Lore Primer's
	/// AZURIA'S REGIONS section. The steward UI ignores it; only `description` shows there.
	var/subtitle = ""
	var/description = ""
	var/subroute
	var/list/region_types = list()
	var/list/produces = list()
	var/list/demands = list()
	var/list/supply_sources = list()
	var/list/demand_sources = list()
	var/list/gifts = list()
	var/list/possible_standing_order_types = list()
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
		for(var/datum/standing_order/template as anything in region_type.standing_orders)
			possible_standing_order_types[template] = initial(template.roll_weight)
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
		if(region.subtitle)
			parts += "<em>[region.subtitle]</em>"
			parts += "<br><br>"
		parts += region.description
		parts += "<br>"
		parts += "</details>"
	parts += "<br><br>"
	parts += "</details>"
	return jointext(parts, "\n")
