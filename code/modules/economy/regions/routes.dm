/datum/trade_route
	var/name
	var/threat_region_id

/datum/trade_route/northern_seaway
	name = "Northern Seaway"
	threat_region_id = THREAT_REGION_AZUREAN_COAST

/datum/trade_route/southern_seaway
	name = "Southern Seaway"
	threat_region_id = THREAT_REGION_AZURE_GROVE

/datum/trade_route/ore_road
	name = "The Ore Road"
	threat_region_id = THREAT_REGION_UNDERDARK

/datum/trade_route/river_azur
	name = "River Azur"
	threat_region_id = THREAT_REGION_MOUNT_DECAP

/datum/trade_subroute
	var/name
	var/route

/proc/get_subroute_threat_region(subroute)
	var/datum/trade_subroute/subroute_path = subroute
	var/datum/trade_route/route_path = initial(subroute_path.route)
	return initial(route_path.threat_region_id)

/proc/get_subroute_regions(subroute)
	. = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(region.subroute == subroute)
			. += region

/proc/get_subroute_name(subroute)
	var/datum/trade_subroute/subroute_path = subroute
	return initial(subroute_path.name)

/proc/get_subroute_region_names(subroute)
	var/list/names = list()
	for(var/datum/economic_region/region as anything in get_subroute_regions(subroute))
		names += region.name
	return english_list(names)

/datum/trade_subroute/rossan_coast
	name = "Rossan Coast"
	route = /datum/trade_route/northern_seaway

/datum/trade_subroute/eastern_shores
	name = "Eastern Shores"
	route = /datum/trade_route/northern_seaway

/datum/trade_subroute/kingsfield_circuit
	name = "Kingsfield Circuit"
	route = /datum/trade_route/southern_seaway

/datum/trade_subroute/southern_shore
	name = "Southern Shore"
	route = /datum/trade_route/southern_seaway

/datum/trade_subroute/syonic_passes
	name = "Syonic Passes"
	route = /datum/trade_route/ore_road

/datum/trade_subroute/terrorbog_causeway
	name = "Terrorbog Causeway"
	route = /datum/trade_route/ore_road

/datum/trade_subroute/riverine_azuria
	name = "Riverine Azuria"
	route = /datum/trade_route/river_azur

/datum/trade_subroute/east_bank_of_arwin
	name = "East Bank of Arwin"
	route = /datum/trade_route/river_azur

/proc/get_region_route(datum/economic_region/region)
	if(!region?.subroute)
		return null
	var/datum/trade_subroute/subroute_path = region.subroute
	return initial(subroute_path.route)

/proc/get_route_name(route)
	var/datum/trade_route/route_path = route
	return initial(route_path.name)
