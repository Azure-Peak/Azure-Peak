GLOBAL_LIST_EMPTY(standing_order_pool)

/datum/standing_order
	var/name
	var/description
	var/region_id
	var/list/required_items = list()
	var/total_payout = 0
	var/day_issued = 0
	var/day_expires = 0
	var/is_fulfilled = FALSE
	var/unfulfillable = FALSE

/// Returns assoc list of trade_good_id -> quantity. Randomized mix.
/datum/standing_order/proc/generate_item_mix()
	return list()

/// Called after region_id is set. Return the order's display name.
/datum/standing_order/proc/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - STANDING ORDER"

/// Called after region_id is set. Return a flavor paragraph.
/// Subtypes can define per-region overrides via a project_by_region list and fall back to generic.
/datum/standing_order/proc/generate_description(datum/economic_region/region)
	return "A standing order has been posted from [region.name]."


// ============================================================================
// demand_rations - garrison/feast food demand
// ============================================================================
/datum/standing_order/demand_rations
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("the admiralty", "the coastal garrison", "the navy quartermaster"),
		TRADE_REGION_NORTHFORT = list("the border guard", "the northern garrison", "the tarichean watch"),
		TRADE_REGION_HEARTFELT = list("the march guard", "the retinue", "the chapel almoners"),
		TRADE_REGION_KINGSFIELD = list("a market town", "a village feast", "a local granary"),
	)

/datum/standing_order/demand_rations/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_GRAIN] = rand(15, 25)
	if(prob(40))
		mix[TRADE_GOOD_MEAT] = rand(5, 10)
	if(prob(30))
		mix[TRADE_GOOD_CHEESE] = rand(3, 8)
	return mix

/datum/standing_order/demand_rations/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - RATIONS REQUISITION"

/datum/standing_order/demand_rations/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] calls for provisions urgently."
	return "Provisioners in [region.name] require rations to feed their charges."


// ============================================================================
// demand_armaments - garrison weapons + armor
// ============================================================================
/datum/standing_order/demand_armaments
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("the admiralty", "the coastal garrison", "the navy armory"),
		TRADE_REGION_NORTHFORT = list("the border guard", "the northern garrison", "the tarichean watch"),
		TRADE_REGION_HEARTFELT = list("the march guard", "the retinue", "the garrison armory"),
	)

/datum/standing_order/demand_armaments/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_INGOT] = rand(5, 10)
	if(prob(50))
		mix[TRADE_GOOD_STEEL_INGOT] = rand(2, 5)
	if(prob(50))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(3, 6)
	return mix

/datum/standing_order/demand_armaments/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ARMAMENT REQUISITION"

/datum/standing_order/demand_armaments/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] must be rearmed before the next campaign season."
	return "The arms-masters of [region.name] require ingots and hide to outfit soldiers."


// ============================================================================
// demand_textile - tailors guild cloth + fiber
// ============================================================================
/datum/standing_order/demand_textile
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a local tailor", "a market stall", "a travelling merchant"),
		TRADE_REGION_HEARTFELT = list("chapel vestments", "heraldic tabards", "banner commissions"),
	)

/datum/standing_order/demand_textile/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_CLOTH] = rand(10, 20)
	if(prob(50))
		mix[TRADE_GOOD_FIBERS] = rand(5, 10)
	return mix

/datum/standing_order/demand_textile/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - TAILORS' REQUISITION"

/datum/standing_order/demand_textile/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires bolts of cloth and fiber."
	return "A tailors' guild in [region.name] is accepting commissions of cloth and fibers."


// ============================================================================
// demand_smithing - smithy guild ingots
// ============================================================================
/datum/standing_order/demand_smithing
	var/list/project_by_region = list(
		TRADE_REGION_DAFTSMARCH = list("the smiths' guild", "the foundry works", "the master smithy"),
		TRADE_REGION_KINGSFIELD = list("a village smithy", "a farm-tool maker", "a local farrier"),
	)

/datum/standing_order/demand_smithing/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_INGOT] = rand(5, 10)
	if(prob(50))
		mix[TRADE_GOOD_COPPER_INGOT] = rand(3, 6)
	return mix

/datum/standing_order/demand_smithing/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - SMITHY SUPPLY"

/datum/standing_order/demand_smithing/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] seeks ingots for the month's labor."
	return "A smithy in [region.name] is ordering ingots for the month's labor."


// ============================================================================
// demand_construction - masons + carpenters, merged
// ============================================================================
/datum/standing_order/demand_construction
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("the coastal garrison", "the harbor works"),
		TRADE_REGION_NORTHFORT = list("the northern garrison", "the border watchtower"),
		TRADE_REGION_HEARTFELT = list("the cathedral", "the garrison hall"),
		TRADE_REGION_KINGSFIELD = list("a market town", "a local granary"),
		TRADE_REGION_DAFTSMARCH = list("a mine shaft", "the foundry"),
		TRADE_REGION_ROSAWOOD = list("the lumber mill", "a trade road"),
		TRADE_REGION_ROCKHILL = list("a terraced wall", "the press house"),
		TRADE_REGION_BLACKHOLT = list("the conclave tower", "an outer sanctum"),
		TRADE_REGION_SALTWICK = list("the salt-house", "the wharves"),
	)

/datum/standing_order/demand_construction/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_STONE] = rand(10, 20)
	if(prob(60))
		mix[TRADE_GOOD_WOOD] = rand(5, 15)
	if(prob(30))
		mix[TRADE_GOOD_IRON_INGOT] = rand(2, 5)
	return mix

/datum/standing_order/demand_construction/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - CONSTRUCTION ORDER"

/datum/standing_order/demand_construction/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires construction materials urgently."
	return "Builders in [region.name] require stone, timber, and hardware."


// ============================================================================
// demand_exotic - wizards / alchemists
// ============================================================================
/datum/standing_order/demand_exotic
	var/list/project_by_region = list(
		TRADE_REGION_BLACKHOLT = list("the wizards' conclave", "the lexicarium"),
		TRADE_REGION_ROSAWOOD = list("a druidic circle", "a forest hermitage"),
	)

/datum/standing_order/demand_exotic/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_DENDOR_ESSENCE] = rand(1, 3)
	if(prob(40))
		mix[TRADE_GOOD_SILK] = rand(2, 5)
	if(prob(40))
		mix[TRADE_GOOD_VISCERA] = rand(3, 8)
	return mix

/datum/standing_order/demand_exotic/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - WIZARDS' REQUISITION"

/datum/standing_order/demand_exotic/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires exotic reagents without delay."
	return "An arcane party in [region.name] is paying well for exotic reagents."


// ============================================================================
// demand_fishery - fishmongers, salting houses
// ============================================================================
/datum/standing_order/demand_fishery
	var/list/project_by_region = list(
		TRADE_REGION_SALTWICK = list("the fishmongers' guild", "the salting houses", "the drying wharves"),
		TRADE_REGION_BLEAKCOAST = list("the admiralty", "the navy quartermaster", "the coastal garrison"),
		TRADE_REGION_KINGSFIELD = list("a market fishmonger", "a village preserver"),
	)

/datum/standing_order/demand_fishery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_FISH_FILET] = rand(10, 20)
	if(prob(60))
		mix[TRADE_GOOD_SALT] = rand(5, 10)
	if(prob(30))
		mix[TRADE_GOOD_SALMON] = rand(3, 6)
	return mix

/datum/standing_order/demand_fishery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - FISHMONGERS' ORDER"

/datum/standing_order/demand_fishery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] has laid in an order for fish and salt."
	return "A fishmongers' shop in [region.name] is taking orders for fish and salt."


// ============================================================================
// demand_orchard - chefs, apothecaries
// ============================================================================
/datum/standing_order/demand_orchard
	var/list/project_by_region = list(
		TRADE_REGION_ROCKHILL = list("the orchard-masters' hall", "the valley apothecary", "a cider pressing"),
		TRADE_REGION_KINGSFIELD = list("a market preserver", "a village apothecary"),
		TRADE_REGION_HEARTFELT = list("the chapel infirmary", "the garrison apothecary", "the pilgrim hostel"),
	)

/datum/standing_order/demand_orchard/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_APPLE] = rand(10, 20)
	if(prob(50))
		mix[TRADE_GOOD_JACKSBERRY] = rand(8, 15)
	if(prob(50))
		mix[TRADE_GOOD_CALENDULA] = rand(3, 8)
	return mix

/datum/standing_order/demand_orchard/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ORCHARD DEMAND"

/datum/standing_order/demand_orchard/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] needs orchard produce and healing calendula."
	return "A preserver or apothecary in [region.name] is buying orchard goods."
