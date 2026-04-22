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
	var/list/produces = list()
	var/list/demands = list()
	var/list/possible_standing_order_types = list()
	var/associated_marker_id
	var/is_region_blockaded = FALSE

	var/list/produces_today = list()
	var/list/demands_today = list()

/datum/economic_region/New()
	. = ..()
	produces_today = produces.Copy()
	demands_today = demands.Copy()
	if(!associated_marker_id)
		associated_marker_id = "[region_id]_blockade"

/datum/economic_region/kingsfield
	region_id = TRADE_REGION_KINGSFIELD
	name = "Kingsfield"
	produces = list(
		TRADE_GOOD_GRAIN = 8,
		TRADE_GOOD_OATS = 4,
		TRADE_GOOD_RICE = 3,
		TRADE_GOOD_MEAT = 4,
		TRADE_GOOD_PORK = 3,
		TRADE_GOOD_POULTRY = 3,
		TRADE_GOOD_RABBIT = 2,
		TRADE_GOOD_EGG = 5,
		TRADE_GOOD_BUTTER = 2,
		TRADE_GOOD_CHEESE = 3,
		TRADE_GOOD_FAT = 3,
		TRADE_GOOD_TALLOW = 2,
		TRADE_GOOD_CABBAGE = 3,
		TRADE_GOOD_POTATO = 4,
		TRADE_GOOD_ONION = 3,
		TRADE_GOOD_CARROT = 3,
		TRADE_GOOD_TURNIP = 2,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_CLOTH = 3,
		TRADE_GOOD_SALT = 2,
	)

/datum/economic_region/rosawood
	region_id = TRADE_REGION_ROSAWOOD
	name = "Rosawood"
	produces = list(
		TRADE_GOOD_WOOD = 10,
		TRADE_GOOD_FIBERS = 8,
		TRADE_GOOD_HIDE = 3,
		TRADE_GOOD_FUR = 2,
		TRADE_GOOD_CURED_LEATHER = 2,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_GRAIN = 3,
		TRADE_GOOD_SALT = 1,
	)

/datum/economic_region/rockhill
	region_id = TRADE_REGION_ROCKHILL
	name = "Rockhill"
	produces = list(
		TRADE_GOOD_APPLE = 4,
		TRADE_GOOD_PEAR = 3,
		TRADE_GOOD_JACKSBERRY = 4,
		TRADE_GOOD_HERBS = 3,
		TRADE_GOOD_POPPY = 2,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = 1,
		TRADE_GOOD_CLOTH = 2,
		TRADE_GOOD_GRAIN = 2,
	)

/datum/economic_region/daftsmarch
	region_id = TRADE_REGION_DAFTSMARCH
	name = "Daftsmarch"
	produces = list(
		TRADE_GOOD_IRON_ORE = 6,
		TRADE_GOOD_COPPER_ORE = 4,
		TRADE_GOOD_TIN_ORE = 4,
		TRADE_GOOD_STONE = 10,
		TRADE_GOOD_COAL = 6,
		TRADE_GOOD_CINNABAR = 2,
		TRADE_GOOD_GOLD_ORE = 3,
		TRADE_GOOD_SALT = 5,
		TRADE_GOOD_GLASS_BATCH = 2,
	)
	demands = list(
		TRADE_GOOD_GRAIN = 4,
		TRADE_GOOD_MEAT = 3,
		TRADE_GOOD_CLOTH = 2,
	)

/datum/economic_region/blackholt
	region_id = TRADE_REGION_BLACKHOLT
	name = "Blackholt"
	produces = list(
		TRADE_GOOD_SILK = 3,
		TRADE_GOOD_VISCERA = 3,
		TRADE_GOOD_DENDOR_ESSENCE = 1,
		TRADE_GOOD_HERBS = 2,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_CLOTH = 2,
	)

/datum/economic_region/saltwick
	region_id = TRADE_REGION_SALTWICK
	name = "Saltwick"
	produces = list(
		TRADE_GOOD_FISH_FILET = 6,
		TRADE_GOOD_FISH_MINCE = 4,
		TRADE_GOOD_SALMON = 2,
		TRADE_GOOD_COD = 2,
		TRADE_GOOD_CRAB = 2,
		TRADE_GOOD_BASS = 2,
		TRADE_GOOD_CARP = 2,
		TRADE_GOOD_SOLE = 2,
		TRADE_GOOD_CLAM = 2,
		TRADE_GOOD_LOBSTER = 1,
		TRADE_GOOD_SHRIMP = 2,
	)
	demands = list(
		TRADE_GOOD_SALT = 4,
		TRADE_GOOD_FIBERS = 3,
		TRADE_GOOD_CLOTH = 2,
		TRADE_GOOD_WOOD = 2,
		TRADE_GOOD_IRON_INGOT = 1,
	)

/datum/economic_region/bleakcoast
	region_id = TRADE_REGION_BLEAKCOAST
	name = "Bleakcoast"
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = 3,
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_CLOTH = 4,
		TRADE_GOOD_MEAT = 4,
		TRADE_GOOD_GRAIN = 5,
		TRADE_GOOD_CURED_LEATHER = 2,
	)

/datum/economic_region/northfort
	region_id = TRADE_REGION_NORTHFORT
	name = "Northfort"
	produces = list()
	demands = list(
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_STEEL_INGOT = 2,
		TRADE_GOOD_FUR = 2,
		TRADE_GOOD_CLOTH = 3,
		TRADE_GOOD_GRAIN = 4,
		TRADE_GOOD_BUTTER = 1,
		TRADE_GOOD_CHEESE = 2,
	)

/datum/economic_region/heartfelt
	region_id = TRADE_REGION_HEARTFELT
	name = "Heartfelt"
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = 3,
		TRADE_GOOD_IRON_INGOT = 2,
		TRADE_GOOD_MEAT = 3,
		TRADE_GOOD_GRAIN = 4,
		TRADE_GOOD_CURED_LEATHER = 2,
	)
