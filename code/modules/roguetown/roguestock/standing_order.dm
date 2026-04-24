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
	/// Relative weight when the daily roller picks a template from a region's pool. Finished-
	/// goods orders (equipment, potions) are more interesting than raw stockpile baskets, so
	/// they weight higher. Raw-goods subtypes keep the default 1.
	var/roll_weight = 1

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
	mix[TRADE_GOOD_GRAIN] = rand(25, 40)
	if(prob(60))
		mix[TRADE_GOOD_MEAT] = rand(6, 12)
	if(prob(60))
		mix[TRADE_GOOD_CHEESE] = rand(4, 10)
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
	mix[TRADE_GOOD_IRON_INGOT] = rand(8, 14)
	if(prob(60))
		mix[TRADE_GOOD_STEEL_INGOT] = rand(3, 7)
	if(prob(60))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(5, 10)
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
	mix[TRADE_GOOD_CLOTH] = rand(30, 50)
	if(prob(75))
		mix[TRADE_GOOD_FIBERS] = rand(15, 30)
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
	mix[TRADE_GOOD_IRON_INGOT] = rand(8, 14)
	if(prob(70))
		mix[TRADE_GOOD_COPPER_INGOT] = rand(5, 10)
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
	mix[TRADE_GOOD_STONE] = rand(40, 70)
	if(prob(70))
		mix[TRADE_GOOD_WOOD] = rand(12, 25)
	if(prob(50))
		mix[TRADE_GOOD_IRON_INGOT] = rand(3, 7)
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
	mix[TRADE_GOOD_DENDOR_ESSENCE] = rand(3, 6)
	if(prob(60))
		mix[TRADE_GOOD_SILK] = rand(8, 15)
	if(prob(60))
		mix[TRADE_GOOD_VISCERA] = rand(8, 15)
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
	mix[TRADE_GOOD_FISH_FILET] = rand(25, 40)
	if(prob(80))
		mix[TRADE_GOOD_SALT] = rand(8, 15)
	if(prob(50))
		mix[TRADE_GOOD_SALMON] = rand(5, 10)
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
	mix[TRADE_GOOD_APPLE] = rand(25, 45)
	if(prob(70))
		mix[TRADE_GOOD_JACKSBERRY] = rand(15, 28)
	if(prob(60))
		mix[TRADE_GOOD_CALENDULA] = rand(5, 12)
	return mix

/datum/standing_order/demand_orchard/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ORCHARD DEMAND"

/datum/standing_order/demand_orchard/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] needs orchard produce and healing calendula."
	return "A preserver or apothecary in [region.name] is buying orchard goods."


// ============================================================================
// urgent - emergency requisition spawned by a shortage economic event.
// Carries a weakref to its source event; item mix and payout are set by
// SSeconomy.spawn_urgent_for_event() from the event's affected_goods.
// ============================================================================
/datum/standing_order/urgent
	var/datum/weakref/source_event_ref

/datum/standing_order/urgent/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - URGENT REQUISITION"

/datum/standing_order/urgent/generate_description(datum/economic_region/region)
	var/list/buyers = list("Local notables", "A merchants' consortium", "The guild elders", "A desperate burgher", "Local magnates")
	var/buyer = pick(buyers)
	var/datum/economic_event/E = source_event_ref?.resolve()
	if(E)
		return "<b>URGENT:</b> [region.name] is suffering from [E.name]. [buyer] are paying a premium to resolve the crisis."
	return "<b>URGENT:</b> [buyer] in [region.name] have declared an emergency requisition."


// ============================================================================
// demand_equipment_armaments - finished weapons for a garrison
// ============================================================================
/datum/standing_order/demand_equipment_armaments
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("the admiralty", "the coastal garrison", "the navy armory"),
		TRADE_REGION_NORTHFORT = list("the border guard", "the northern garrison", "the tarichean watch"),
		TRADE_REGION_HEARTFELT = list("the march guard", "the retinue", "the garrison armory"),
		TRADE_REGION_KINGSFIELD = list("the Crown's armory", "a local armsmaster"),
	)
	var/list/one_ingot_pool = list(
		TRADE_GOOD_STEEL_ARMING_SWORD,
		TRADE_GOOD_STEEL_SHORTSWORD,
		TRADE_GOOD_STEEL_FALCHION,
		TRADE_GOOD_STEEL_MESSER,
		TRADE_GOOD_STEEL_SABRE,
		TRADE_GOOD_STEEL_MACE,
		TRADE_GOOD_STEEL_FLANGED_MACE,
		TRADE_GOOD_STEEL_FLAIL,
	)
	var/list/two_ingot_pool = list(
		TRADE_GOOD_STEEL_LONGSWORD,
		TRADE_GOOD_STEEL_BROADSWORD,
		TRADE_GOOD_STEEL_WARHAMMER,
		TRADE_GOOD_STEEL_BATTLEAXE,
		TRADE_GOOD_HURLBAT,
	)

/datum/standing_order/demand_equipment_armaments/generate_item_mix()
	var/list/mix = list()
	var/primary_one = pick(one_ingot_pool)
	mix[primary_one] = rand(3, 5)
	if(prob(55))
		var/secondary_two = pick(two_ingot_pool)
		mix[secondary_two] = rand(1, 2)
	// Bows are cheap and plentiful — garrison archer lines want quivers of them.
	if(prob(55))
		mix[TRADE_GOOD_RECURVE_BOW] = rand(4, 8)
	return mix

/datum/standing_order/demand_equipment_armaments/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ARMS ORDER"

/datum/standing_order/demand_equipment_armaments/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires finished arms, to be left at the warehouse."
	return "A garrison at [region.name] requires finished arms, to be left at the warehouse."


// ============================================================================
// demand_equipment_armor - finished armor for a garrison
// ============================================================================
/datum/standing_order/demand_equipment_armor
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("the admiralty", "the coastal garrison", "the navy armory"),
		TRADE_REGION_NORTHFORT = list("the border guard", "the northern garrison", "the tarichean watch"),
		TRADE_REGION_HEARTFELT = list("the march guard", "the retinue", "the garrison armory"),
		TRADE_REGION_KINGSFIELD = list("the Crown's armory", "a knightly house"),
	)
	var/list/soft_pool = list(
		TRADE_GOOD_PADDED_GAMBESON,
		TRADE_GOOD_HEAVY_LEATHER_COAT,
	)
	var/list/chain_pool = list(
		TRADE_GOOD_STEEL_CHAINMAIL,
		TRADE_GOOD_STEEL_HAUBERK,
		TRADE_GOOD_BRIGANDINE,
		TRADE_GOOD_BRIGANDINE_HEAVY,
	)
	var/list/plate_pool = list(
		TRADE_GOOD_STEEL_CUIRASS,
		TRADE_GOOD_STEEL_COATPLATES,
		TRADE_GOOD_STEEL_HALFPLATE,
		TRADE_GOOD_STEEL_FULLPLATE,
	)
	var/list/helm_pool = list(
		TRADE_GOOD_STEEL_HELM_KNIGHT,
		TRADE_GOOD_STEEL_HELM_BASCINET,
		TRADE_GOOD_STEEL_HELM_KETTLE,
	)
	var/list/extremity_pool = list(
		TRADE_GOOD_STEEL_MASK,
		TRADE_GOOD_CHAIN_GLOVES,
		TRADE_GOOD_PLATE_GAUNTLETS,
		TRADE_GOOD_STEEL_PLATE_LEGS,
	)

/datum/standing_order/demand_equipment_armor/generate_item_mix()
	var/list/mix = list()
	// Armor orders stay small in qty — a garrison outfits a handful of soldiers per order,
	// not a whole company. Payout per piece is high enough that 1-2 units is valuable.
	var/chain_or_plate = prob(60) ? chain_pool : plate_pool
	var/core = pick(chain_or_plate)
	mix[core] = rand(1, 2)
	if(prob(60))
		var/soft = pick(soft_pool)
		mix[soft] = rand(1, 2)
	if(prob(55))
		var/helm = pick(helm_pool)
		mix[helm] = rand(1, 2)
	if(prob(45))
		var/extremity = pick(extremity_pool)
		mix[extremity] = rand(1, 3)
	return mix

/datum/standing_order/demand_equipment_armor/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - HARNESS ORDER"

/datum/standing_order/demand_equipment_armor/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires finished harness, to be left at the warehouse."
	return "A garrison at [region.name] requires finished harness, to be left at the warehouse."


// ============================================================================
// demand_salt - bulk salt requisition for the salting-houses
// Only ever rolls for Saltwick (producer) and Kingsfield (major consumer).
// ============================================================================
/datum/standing_order/demand_salt
	var/list/project_by_region = list(
		TRADE_REGION_SALTWICK = list("the salting-houses", "the curing sheds", "the preservers' guild"),
		TRADE_REGION_KINGSFIELD = list("a market preserver", "a village smokehouse", "the chapel almoners"),
	)

/datum/standing_order/demand_salt/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SALT] = rand(30, 55)
	return mix

/datum/standing_order/demand_salt/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - SALT REQUISITION"

/datum/standing_order/demand_salt/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] require salt in bulk for the preserving of flesh and fish."
	return "Preservers in [region.name] require salt in bulk."


// ============================================================================
// demand_victualling_fleet - Saltwick fishing fleet's ration stores
// ============================================================================
/datum/standing_order/demand_victualling_fleet
	roll_weight = 2

/datum/standing_order/demand_victualling_fleet/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_GRAIN] = rand(20, 35)
	mix[TRADE_GOOD_DRIED_FISH] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_MEAT] = rand(5, 10)
	if(prob(60))
		mix[TRADE_GOOD_CHEESE] = rand(4, 8)
	return mix

/datum/standing_order/demand_victualling_fleet/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - FLEET VICTUALLING"

/datum/standing_order/demand_victualling_fleet/generate_description(datum/economic_region/region)
	var/list/flavors = list(
		"The fishing fleet at [region.name] lays in stores for the season's run.",
		"The wharvesmen at [region.name] need victuals sufficient for a month at sea.",
		"A captain at [region.name] takes on stores before his vessel sails.",
	)
	return pick(flavors)


// ============================================================================
// demand_victualling_garrison - preserved rations for the garrisons
// ============================================================================
/datum/standing_order/demand_victualling_garrison
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_NORTHFORT = list("the border garrison", "the tarichean watch", "the northern keep"),
		TRADE_REGION_BLEAKCOAST = list("the admiralty stores", "the coastal garrison", "the navy quartermaster"),
		TRADE_REGION_HEARTFELT = list("the march garrison", "the retinue", "the chapel guard"),
	)

/datum/standing_order/demand_victualling_garrison/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SALUMOI] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_SAUSAGE] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_GRAIN] = rand(15, 25)
	if(prob(50))
		mix[TRADE_GOOD_CHEESE] = rand(4, 8)
	return mix

/datum/standing_order/demand_victualling_garrison/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - GARRISON VICTUALLING"

/datum/standing_order/demand_victualling_garrison/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] calls for preserved rations that will last the garrison."
	return "A garrison at [region.name] lays in preserved rations for the next rotation."


// ============================================================================
// demand_victualling_mines - Daftsmarch miners' long-shift provisions
// ============================================================================
/datum/standing_order/demand_victualling_mines
	roll_weight = 2

/datum/standing_order/demand_victualling_mines/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SALUMOI] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_OATS] = rand(15, 25)
	if(prob(55))
		mix[TRADE_GOOD_SAUSAGE] = rand(4, 7)
	if(prob(45))
		mix[TRADE_GOOD_BUTTER] = rand(2, 4)
	return mix

/datum/standing_order/demand_victualling_mines/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - MINERS' VICTUALLING"

/datum/standing_order/demand_victualling_mines/generate_description(datum/economic_region/region)
	var/list/flavors = list(
		"The foremen at [region.name] feed the miners through the long night-shifts underground.",
		"The mineworks at [region.name] need stout fare to see their crews through the week.",
		"A shift-boss at [region.name] lays in dry goods that will not spoil in the shafts.",
	)
	return pick(flavors)


// ============================================================================
// demand_alchemical - finished potions for a chapel infirmary, conclave, or watch
// Delivered to the warehouse: any container holding the right reagent at the right
// volume satisfies a unit. Matched containers are consumed in full.
// ============================================================================
/datum/standing_order/demand_alchemical
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("the chapel infirmary", "the pilgrim hostel", "the garrison surgeon"),
		TRADE_REGION_BLACKHOLT = list("the wizards' conclave", "the lexicarium", "the archmagi's household"),
		TRADE_REGION_BLEAKCOAST = list("the admiralty surgeon", "the coastal garrison", "the navy apothecary"),
		TRADE_REGION_NORTHFORT = list("the border surgeon", "the northern garrison", "the tarichean watch"),
		TRADE_REGION_KINGSFIELD = list("a market apothecary", "a village healer"),
	)
	var/list/medicinal_pool = list(
		TRADE_GOOD_HEALTH_POTION,
		TRADE_GOOD_STAM_POTION,
		TRADE_GOOD_ANTIDOTE_POTION,
	)
	var/list/premium_pool = list(
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_MANA_POTION,
	)

/datum/standing_order/demand_alchemical/generate_item_mix()
	var/list/mix = list()
	var/primary = pick(medicinal_pool)
	mix[primary] = rand(3, 5)
	if(prob(50))
		var/premium = pick(premium_pool)
		mix[premium] = rand(1, 2)
	return mix

/datum/standing_order/demand_alchemical/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - APOTHECARY ORDER"

/datum/standing_order/demand_alchemical/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires finished potions, to be left at the warehouse."
	return "An apothecary at [region.name] will pay the Crown for finished potions, left at the warehouse."
