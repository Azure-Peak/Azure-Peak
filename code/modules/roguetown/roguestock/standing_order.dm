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
	/// Spawned by a Steward petition. Payout is shaved by PETITION_TAX_MULT and the UI tags it.
	var/petitioned = FALSE

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
		TRADE_REGION_BLEAKCOAST = list("a ship's company victualling", "a privateer's crew", "the harbor watch"),
		TRADE_REGION_NORTHFORT = list("a frontier garrison", "a watch sergeant restocking", "a militia muster"),
		TRADE_REGION_HEARTFELT = list("the count's retinue", "a roving warden party", "a local adventuring fellowship"),
		TRADE_REGION_KINGSFIELD = list("a market town", "a village feast committee", "a granary keeper"),
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
		TRADE_REGION_BLEAKCOAST = list("a galley's fighting men", "a corsair's company outfitting", "the harbor watch"),
		TRADE_REGION_NORTHFORT = list("a frontier garrison", "a band of border irregulars", "a watch sergeant"),
		TRADE_REGION_HEARTFELT = list("the count's retinue", "a local mercenary band", "a roving warden party"),
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
		TRADE_REGION_HEARTFELT = list("a banner-maker's commission", "a tabard-maker outfitting a retinue", "a name-day wardrobe order"),
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
		TRADE_REGION_DAFTSMARCH = list("the smiths' guild", "the foundry works", "a master smith with a backlog"),
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
		TRADE_REGION_BLEAKCOAST = list("a harbor wall reinforcement", "a coastal garrison's repairs"),
		TRADE_REGION_NORTHFORT = list("a frontier garrison expanding its keep", "a watchtower rebuild"),
		TRADE_REGION_HEARTFELT = list("a cathedral renovation", "a count's hall expansion"),
		TRADE_REGION_KINGSFIELD = list("a market town's roadworks", "a granary expansion"),
		TRADE_REGION_DAFTSMARCH = list("a mine shaft reinforcement", "the foundry's expansion"),
		TRADE_REGION_ROSAWOOD = list("a lumber mill rebuild", "a trade road repair"),
		TRADE_REGION_ROCKHILL = list("a terraced wall rebuild", "a press house expansion"),
		TRADE_REGION_BLACKHOLT = list("a tower rebuild after a working went wrong", "an outer sanctum rebuild"),
		TRADE_REGION_SALTWICK = list("a salt-house rebuild", "wharf reinforcements"),
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
		TRADE_REGION_BLACKHOLT = list("a wizards' coven", "a hermit reagent-buyer", "an oddly pale aristocrat with academic interests"),
		TRADE_REGION_ROSAWOOD = list("a druidic circle", "a forest hermit", "a wandering hedge witch"),
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
		TRADE_REGION_SALTWICK = list("the fishmongers' guild", "a salt-curer with a backlog", "a wharf-side preserver"),
		TRADE_REGION_BLEAKCOAST = list("a ship's company victualling", "a privateer's crew", "the harbor watch"),
		TRADE_REGION_KINGSFIELD = list("a market fishmonger", "a village preserver", "a travelling fish-trader"),
	)

/datum/standing_order/demand_fishery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_FISH_FILET] = rand(15, 25)
	mix[TRADE_GOOD_SALT] = rand(8, 15)
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
		TRADE_REGION_ROCKHILL = list("an orchard-master's harvest", "a valley apothecary", "a cider press"),
		TRADE_REGION_KINGSFIELD = list("a market preserver", "a village apothecary", "a travelling herbalist"),
		TRADE_REGION_HEARTFELT = list("a chapel almsgiving", "a garrison apothecary", "a hospitaller buying for the road"),
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
		return "[region.name] is suffering from [E.name]. [buyer] are paying a premium to resolve the crisis."
	return "[buyer] in [region.name] have declared an emergency requisition."


// ============================================================================
// demand_equipment_armaments - finished weapons for a garrison
// ============================================================================
/datum/standing_order/demand_equipment_armaments
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("a privateer captain outfitting", "a corsair's company", "a harbor watch armsmaster"),
		TRADE_REGION_NORTHFORT = list("a frontier garrison", "a watch sergeant outfitting", "a band of border irregulars"),
		TRADE_REGION_HEARTFELT = list("the count's retinue", "a local mercenary band", "a warband outfitting for the road"),
		TRADE_REGION_KINGSFIELD = list("a market armsmaster", "a knight-errant outfitting", "a back-room arms-broker"),
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
		mix[TRADE_GOOD_RECURVE_BOW] = rand(3, 6)
	return mix

/datum/standing_order/demand_equipment_armaments/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ARMS ORDER"

/datum/standing_order/demand_equipment_armaments/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires finished arms, to be left at the warehouse."
	return "A garrison at [region.name] requires finished arms, to be left at the warehouse."


// ============================================================================
// demand_equipment_armor_heavy - finished metallic harness for a garrison
// (smith-fulfillable, no tailor goods required)
// ============================================================================
/datum/standing_order/demand_equipment_armor_heavy
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("a galley's fighting men", "a privateer captain outfitting", "a harbor watch armsmaster"),
		TRADE_REGION_NORTHFORT = list("a frontier garrison", "a watch sergeant outfitting", "a relieved company restocking"),
		TRADE_REGION_HEARTFELT = list("the count's retinue", "a local mercenary band", "a knightly house outfitting"),
		TRADE_REGION_KINGSFIELD = list("a market armsmaster", "a knightly house", "a tournament-bound knight"),
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

/datum/standing_order/demand_equipment_armor_heavy/generate_item_mix()
	var/list/mix = list()
	// Armor orders stay small in qty — a garrison outfits a handful of soldiers per order,
	// not a whole company. Payout per piece is high enough that 1-2 units is valuable.
	var/chain_or_plate = prob(60) ? chain_pool : plate_pool
	var/core = pick(chain_or_plate)
	mix[core] = rand(1, 2)
	if(prob(65))
		var/helm = pick(helm_pool)
		mix[helm] = rand(1, 2)
	if(prob(50))
		var/extremity = pick(extremity_pool)
		mix[extremity] = rand(1, 3)
	return mix

/datum/standing_order/demand_equipment_armor_heavy/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - HARNESS ORDER"

/datum/standing_order/demand_equipment_armor_heavy/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires finished plate harness, to be left at the warehouse."
	return "A garrison at [region.name] requires finished plate harness, to be left at the warehouse."


// ============================================================================
// demand_equipment_armor_light - finished light/leather kit for a company
// (tailor-fulfillable, no smith goods required). Mixes finished gambesons,
// hardened-leather pieces, and a small bundle of cured leather + cloth raw
// stock — orders that the tailor and the leatherworker can cover end-to-end
// without the smithy.
// ============================================================================
/datum/standing_order/demand_equipment_armor_light
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("the harbor watch", "a coastal levy mustering", "a corsair's company outfitting"),
		TRADE_REGION_NORTHFORT = list("a watch sergeant outfitting", "a band of border irregulars", "a frontier reservist call-up"),
		TRADE_REGION_HEARTFELT = list("a roving warden party", "the count's footsergeants", "a local adventuring fellowship"),
		TRADE_REGION_KINGSFIELD = list("a country muster", "a market company", "a yeoman captain outfitting"),
	)
	var/list/body_pool = list(
		TRADE_GOOD_PADDED_GAMBESON,
		TRADE_GOOD_HEAVY_LEATHER_COAT,
	)

/datum/standing_order/demand_equipment_armor_light/generate_item_mix()
	var/list/mix = list()
	var/primary_body = pick(body_pool)
	mix[primary_body] = rand(2, 3)
	if(prob(55))
		// The other body piece, so a single order can include both gambesons and coats.
		var/list/secondary_pool = body_pool - primary_body
		if(length(secondary_pool))
			mix[pick(secondary_pool)] = rand(1, 2)
	if(prob(65))
		mix[TRADE_GOOD_HARDENED_LEATHER_HELMET] = rand(1, 2)
	if(prob(50))
		mix[TRADE_GOOD_HARDENED_LEATHER_GORGET] = rand(1, 2)
	if(prob(45))
		mix[TRADE_GOOD_HEAVY_LEATHER_GLOVES] = rand(1, 3)
	if(prob(50))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(4, 8)
	if(prob(40))
		mix[TRADE_GOOD_CLOTH] = rand(4, 8)
	return mix

/datum/standing_order/demand_equipment_armor_light/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - COMPANY TUNICS"

/datum/standing_order/demand_equipment_armor_light/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires sewn and boiled-leather kit, to be left at the warehouse."
	return "A company at [region.name] requires sewn and boiled-leather kit, to be left at the warehouse."


// ============================================================================
// demand_salt - bulk salt requisition for the salting-houses
// Only ever rolls for Saltwick (producer) and Kingsfield (major consumer).
// ============================================================================
/datum/standing_order/demand_salt
	var/list/project_by_region = list(
		TRADE_REGION_SALTWICK = list("a salt-curer's bulk order", "a curing-shed expansion", "the preservers' guild"),
		TRADE_REGION_KINGSFIELD = list("a market preserver", "a village smokehouse", "a roadside chapmen restocking"),
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
		"The wharvesmen at [region.name] need victuals for a month at sea.",
		"A captain at [region.name] takes on stores before his vessel sails.",
	)
	return pick(flavors)


// ============================================================================
// demand_victualling_garrison - preserved rations for the garrisons
// ============================================================================
/datum/standing_order/demand_victualling_garrison
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_NORTHFORT = list("a frontier garrison", "a watch sergeant restocking", "a keep's quartermaster"),
		TRADE_REGION_BLEAKCOAST = list("a ship's company victualling", "a coastal garrison's larder", "a privateer's crew"),
		TRADE_REGION_HEARTFELT = list("the count's retinue", "a roving warden party", "a local adventuring fellowship"),
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
		TRADE_REGION_HEARTFELT = list("a chapel infirmary", "a hospitaller buying for the road", "a garrison surgeon"),
		TRADE_REGION_BLACKHOLT = list("a wizards' coven", "a hermit reagent-buyer", "an oddly red-eyed aristocrat"),
		TRADE_REGION_BLEAKCOAST = list("a galley's surgeon", "a privateer's crew laying in stores", "a coastal garrison's apothecary"),
		TRADE_REGION_NORTHFORT = list("a frontier surgeon", "a watch sergeant restocking", "a band of border irregulars"),
		TRADE_REGION_KINGSFIELD = list("a market apothecary", "a village healer", "a travelling herbalist"),
	)
	// Mana lives in the premium pool only - keeping it in both used to let a premium roll
	// overwrite the larger primary qty when the same id was picked twice.
	var/list/medicinal_pool = list(
		TRADE_GOOD_HEALTH_POTION,
		TRADE_GOOD_STAM_POTION,
		TRADE_GOOD_ANTIDOTE_POTION,
	)
	var/list/premium_pool = list(
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_STRONG_MANA_POTION,
		TRADE_GOOD_STRONG_STAM_POTION,
		TRADE_GOOD_STRONG_ANTIDOTE_POTION,
		TRADE_GOOD_MANA_POTION,
	)

/datum/standing_order/demand_alchemical/generate_item_mix()
	var/list/mix = list()
	var/primary = pick(medicinal_pool)
	mix[primary] = rand(4, 8)
	if(prob(60))
		var/premium = pick(premium_pool)
		// max() guard so a colliding pick can never downgrade a larger earlier qty.
		mix[premium] = max(mix[premium] || 0, rand(3, 6))
	return mix

/datum/standing_order/demand_alchemical/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - APOTHECARY ORDER"

/datum/standing_order/demand_alchemical/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires finished potions, to be left at the warehouse."
	return "An apothecary at [region.name] will pay handsomely for finished potions, left at the warehouse."

// ============================================================================
// demand_alchemical_warband - elite buff-potion order for adventurers, the conclave,
// and chosen retinues. Stat-buff potions plus a backbone of strong-* support potions.
// ============================================================================
/datum/standing_order/demand_alchemical_warband
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_BLACKHOLT = list("a wizards' coven", "a battle-mage's hireling outfit", "a sun-starved aristocrat's hunting party"),
		TRADE_REGION_HEARTFELT = list("the count's chosen retinue", "a temple's champions", "a roving warden party"),
		TRADE_REGION_KINGSFIELD = list("a knight-errants' convocation", "a mercenary captain's warband", "a noble's hunting party"),
		TRADE_REGION_NORTHFORT = list("a frontier strike-band", "a watch sergeant's chosen", "a local adventuring fellowship"),
	)
	var/list/buff_pool = list(
		TRADE_GOOD_STRENGTH_POTION,
		TRADE_GOOD_PERCEPTION_POTION,
		TRADE_GOOD_INTELLIGENCE_POTION,
		TRADE_GOOD_SPEED_POTION,
	)
	var/list/support_pool = list(
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_STRONG_MANA_POTION,
		TRADE_GOOD_STRONG_STAM_POTION,
		TRADE_GOOD_STRONG_ANTIDOTE_POTION,
	)

/datum/standing_order/demand_alchemical_warband/generate_item_mix()
	var/list/mix = list()
	var/buff_primary = pick(buff_pool)
	mix[buff_primary] = rand(2, 3)
	if(prob(55))
		var/buff_secondary = pick(buff_pool)
		mix[buff_secondary] = max(mix[buff_secondary] || 0, rand(2, 3))
	var/support = pick(support_pool)
	mix[support] = max(mix[support] || 0, rand(2, 3))
	return mix

/datum/standing_order/demand_alchemical_warband/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - WARBAND DRAUGHTS"

/datum/standing_order/demand_alchemical_warband/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] commissions draughts of stat and strong potion."
	return "An elite party at [region.name] commissions draughts of stat and strong potion."


// ============================================================================
// demand_birthday_gift - a named noble's name-day gift basket
// ============================================================================
/datum/standing_order/demand_birthday_gift
	roll_weight = 2
	var/list/celebrants_by_region = list(
		TRADE_REGION_KINGSFIELD = list(
			"Lady Marisol of Cherrybrook",
			"Lord Berenger the Younger",
			"Dame Vesalia Sundermark",
			"Sir Aldwin of Aubergrove",
		),
		TRADE_REGION_ROCKHILL = list(
			"Lord Hadrius Vespermill",
			"Lady Aurinde Greengable",
		),
		TRADE_REGION_HEARTFELT = list(
			"Count Eduard Harlause",
			"Sir Ardent of the March",
		),
		TRADE_REGION_ROSAWOOD = list("Lady Sylvarine Briarmoss"),
		TRADE_REGION_DAFTSMARCH = list("Lord Korgrad of Pickleridge"),
		TRADE_REGION_BLEAKCOAST = list("Lord Captain Vesarion of Saltreef"),
		TRADE_REGION_BLACKHOLT = list("Huntsmarshal Ostran"),
	)
	var/list/jewelry_pool = list(
		TRADE_GOOD_AMBER_RING,
		TRADE_GOOD_GOLD_RING,
		TRADE_GOOD_AMBER_AMULET,
		TRADE_GOOD_JADE_AMULET,
	)
	var/list/garment_pool = list(
		TRADE_GOOD_NOBLECOAT,
		TRADE_GOOD_SILK_TUNIC,
		TRADE_GOOD_SEASONAL_GOWN,
	)

/datum/standing_order/demand_birthday_gift/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SILK] = rand(3, 6)
	mix[TRADE_GOOD_JACKSBERRY] = rand(8, 14)
	if(prob(70))
		var/exotic = pick(TRADE_GOOD_LEMON, TRADE_GOOD_LIME, TRADE_GOOD_TANGERINE, TRADE_GOOD_PLUM)
		mix[exotic] = rand(3, 6)
	if(prob(70))
		var/jewel = pick(jewelry_pool)
		mix[jewel] = 1
	if(prob(60))
		var/garment = pick(garment_pool)
		mix[garment] = 1
	return mix

/datum/standing_order/demand_birthday_gift/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - BIRTHDAY TRIBUTE"

/datum/standing_order/demand_birthday_gift/generate_description(datum/economic_region/region)
	var/list/celebrants = celebrants_by_region[region.region_id]
	if(length(celebrants))
		return "A name-day approaches for [pick(celebrants)] of [region.name]. Their household commissions a fitting tribute."
	return "A noble of [region.name] keeps a name-day. Their household commissions a fitting tribute."


// ============================================================================
// demand_great_feast - heavy butter + meat feast spread, 1/3 chance Lord Harlause
// ============================================================================
/datum/standing_order/demand_great_feast
	roll_weight = 2
	var/list/feast_for_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a market town's harvest feast", "the manor of a country knight", "a wedding banquet"),
		TRADE_REGION_HEARTFELT = list("the count's high table", "a chapter feast of the march guard"),
		TRADE_REGION_BLEAKCOAST = list("a sea-lord's high table", "a captains' banquet aboard the flagship", "a privateer's homecoming feast"),
		TRADE_REGION_NORTHFORT = list("the garrison's midwinter feast", "a watchcommander's table"),
		TRADE_REGION_ROCKHILL = list("the orchard-masters' harvest hall", "a press-house celebration"),
	)

/datum/standing_order/demand_great_feast/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_BUTTER] = rand(8, 15)
	mix[TRADE_GOOD_GRAIN] = rand(30, 50)
	mix[TRADE_GOOD_MEAT] = rand(15, 25)
	mix[TRADE_GOOD_CHEESE] = rand(8, 15)
	if(prob(70))
		var/fruit = pick(TRADE_GOOD_APPLE, TRADE_GOOD_PEAR, TRADE_GOOD_JACKSBERRY)
		mix[fruit] = rand(8, 14)
	if(prob(50))
		mix[TRADE_GOOD_POULTRY] = rand(5, 10)
	if(prob(40))
		mix[TRADE_GOOD_PORK] = rand(5, 10)
	return mix

/datum/standing_order/demand_great_feast/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - THE GREAT FEAST"

/datum/standing_order/demand_great_feast/generate_description(datum/economic_region/region)
	if(prob(33))
		return "Lord Harlause sets the table at [region.name]. His house calls for butter, beef, and bread."
	var/list/feasts = feast_for_by_region[region.region_id]
	if(length(feasts))
		return "[capitalize(pick(feasts))] at [region.name] calls for butter, beef, and bread."
	return "A great feast at [region.name] calls for butter, beef, and bread."


// ============================================================================
// demand_frontier_gear - finished light/medium kit for the wardens and watch
// ============================================================================
/datum/standing_order/demand_frontier_gear
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_NORTHFORT = list("a watch sergeant outfitting", "a band of border irregulars", "a frontier reservist call-up"),
		TRADE_REGION_BLEAKCOAST = list("the harbor watch", "a coastal patrol mustering", "a privateer's crew outfitting"),
		TRADE_REGION_HEARTFELT = list("a roving warden party", "a temple's guard", "a local adventuring fellowship"),
		TRADE_REGION_KINGSFIELD = list("a country sheriff's posse", "a local muster", "a yeoman captain outfitting"),
	)
	var/list/body_pool = list(
		TRADE_GOOD_PADDED_GAMBESON,
		TRADE_GOOD_HEAVY_LEATHER_COAT,
	)

/datum/standing_order/demand_frontier_gear/generate_item_mix()
	var/list/mix = list()
	mix[pick(body_pool)] = rand(2, 4)
	if(prob(70))
		mix[TRADE_GOOD_HARDENED_LEATHER_HELMET] = rand(2, 4)
	if(prob(55))
		mix[TRADE_GOOD_HEAVY_LEATHER_GLOVES] = rand(2, 4)
	if(prob(45))
		mix[TRADE_GOOD_RECURVE_BOW] = rand(3, 6)
	return mix

/datum/standing_order/demand_frontier_gear/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - FRONTIER GARRISON KIT"

/datum/standing_order/demand_frontier_gear/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires light kit fit for irregular service."
	return "A frontier muster at [region.name] requires light kit for the watch."


// ============================================================================
// demand_court_finery - finished tailoring for the court and its lesser houses
// ============================================================================
/datum/standing_order/demand_court_finery
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a noble household's wardrobe", "a court tailor's commission", "a market tailor"),
		TRADE_REGION_HEARTFELT = list("the count's wardrobe", "a noble investiture", "a wedding-bound house"),
		TRADE_REGION_ROCKHILL = list("a country estate's spring wardrobe", "a noble's name-day finery", "a sun-shy aristocrat's seasonal fitting"),
	)
	var/list/finery_pool = list(
		TRADE_GOOD_NOBLECOAT,
		TRADE_GOOD_SILK_TUNIC,
		TRADE_GOOD_SEASONAL_GOWN,
		TRADE_GOOD_MAID_DRESS,
	)

/datum/standing_order/demand_court_finery/generate_item_mix()
	var/list/mix = list()
	mix[pick(finery_pool)] = rand(2, 4)
	if(prob(50))
		var/second = pick(finery_pool)
		mix[second] = rand(1, 3)
	if(prob(20))
		mix[TRADE_GOOD_ROYAL_DRESS] = 1
	return mix

/datum/standing_order/demand_court_finery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - COURT FINERY ORDER"

/datum/standing_order/demand_court_finery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] commissions finished tailoring for the season."
	return "A noble household at [region.name] commissions finished tailoring."


// ============================================================================
// demand_fine_joinery - wood + leather + iron + cloth, joiner's commission
// ============================================================================
/datum/standing_order/demand_fine_joinery
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a country estate's joiner", "a manor house refurnish", "a temple's furnishings order"),
		TRADE_REGION_ROSAWOOD = list("a master joiner's workshop", "a roadside furniture maker"),
		TRADE_REGION_ROCKHILL = list("an orchard estate's joiner", "a press-house refit"),
		TRADE_REGION_HEARTFELT = list("the count's hall furnishings", "a garrison hall refit"),
	)

/datum/standing_order/demand_fine_joinery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_WOOD] = rand(15, 28)
	mix[TRADE_GOOD_CLOTH] = rand(6, 12)
	if(prob(70))
		mix[TRADE_GOOD_IRON_INGOT] = rand(3, 6)
	if(prob(55))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(4, 8)
	return mix

/datum/standing_order/demand_fine_joinery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - JOINER'S COMMISSION"

/datum/standing_order/demand_fine_joinery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires joinery materials - wood, cloth, and iron."
	return "A joiner at [region.name] requires materials for fine furnishings."


// ============================================================================
// demand_artificery - mixed engineering bundle: glass, copper, tin, coal, mess kit
// ============================================================================
/datum/standing_order/demand_artificery
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_DAFTSMARCH = list("the artificers' guild", "a master smith's workshop", "a foundry-master's commission"),
		TRADE_REGION_KINGSFIELD = list("a court artificer's workshop", "a guild engineer's workshop", "a back-alley contraption maker"),
		TRADE_REGION_BLACKHOLT = list("a coven's contraption shop", "an arcane engineer's workshop", "a hermit tinkerer's bulk order"),
		TRADE_REGION_NORTHFORT = list("a garrison's engineer", "a siege-engineer at the keep", "a frontier sapper outfitting"),
	)

/datum/standing_order/demand_artificery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_COPPER_INGOT] = rand(6, 12)
	mix[TRADE_GOOD_TIN_INGOT] = rand(4, 8)
	mix[TRADE_GOOD_COAL] = rand(8, 14)
	if(prob(70))
		mix[TRADE_GOOD_GLASS_BATCH] = rand(3, 6)
	if(prob(45))
		mix[TRADE_GOOD_MESS_KIT] = rand(2, 4)
	return mix

/datum/standing_order/demand_artificery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ARTIFICER'S WORKSHOP"

/datum/standing_order/demand_artificery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires bronze-stock and tin for the next batch."
	return "An artificer at [region.name] is buying bronze-stock and tin."


// ============================================================================
// demand_jewelry - jeweler's stocking order, mixed rings and amulets
// ============================================================================
/datum/standing_order/demand_jewelry
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a court jeweler", "a master goldsmith", "a noble household's wardrobe"),
		TRADE_REGION_HEARTFELT = list("the count's jeweler", "a temple reliquary's commission", "a wedding-bound house"),
		TRADE_REGION_ROCKHILL = list("a country estate's jeweler", "a name-day finery commission", "a sun-shy aristocrat's heirloom resetting"),
	)
	var/list/jewelry_pool = list(
		TRADE_GOOD_AMBER_RING,
		TRADE_GOOD_GOLD_RING,
		TRADE_GOOD_EMERALD_RING,
		TRADE_GOOD_AMBER_AMULET,
		TRADE_GOOD_JADE_AMULET,
	)

/datum/standing_order/demand_jewelry/generate_item_mix()
	var/list/mix = list()
	mix[pick(jewelry_pool)] = rand(2, 4)
	if(prob(60))
		var/second = pick(jewelry_pool)
		mix[second] = rand(1, 3)
	if(prob(15))
		mix[TRADE_GOOD_DIAMOND_RING] = 1
	return mix

/datum/standing_order/demand_jewelry/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - JEWELERS' COMMISSION"

/datum/standing_order/demand_jewelry/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires finished rings and amulets for their stock."
	return "A jeweler at [region.name] is buying finished rings and amulets."


// ============================================================================
// demand_prosthetic_run - chapel/infirmary order: prosthetics + healing potions
// ============================================================================
/datum/standing_order/demand_prosthetic_run
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("a chapel infirmary", "a hospitaller's wounded-house", "a battlefield surgeon's bulk order"),
		TRADE_REGION_NORTHFORT = list("a frontier surgeon", "a garrison infirmary", "a band of border irregulars come back broken"),
		TRADE_REGION_BLEAKCOAST = list("a galley's surgeon", "a harbor wounded-house", "a privateer's crew limping in"),
	)

/datum/standing_order/demand_prosthetic_run/generate_item_mix()
	var/list/mix = list()
	var/primary_prosthetic = pick(TRADE_GOOD_BRONZE_PROSTHETIC, TRADE_GOOD_IRON_PROSTHETIC)
	mix[primary_prosthetic] = rand(2, 3)
	if(prob(35))
		mix[TRADE_GOOD_STEEL_PROSTHETIC] = 1
	mix[TRADE_GOOD_HEALTH_POTION] = rand(4, 7)
	if(prob(60))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(4, 8)
	return mix

/datum/standing_order/demand_prosthetic_run/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - INFIRMARY'S ORDER"

/datum/standing_order/demand_prosthetic_run/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] tends many wounded - prosthetics and draughts are needed."
	return "An infirmary at [region.name] tends to wounded soldiers and pilgrims."


// ============================================================================
// demand_artificed_panoply - rare premium order: artificed plate + voltic gauntlets
// ============================================================================
/datum/standing_order/demand_artificed_panoply
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a duke's master-of-arms", "a knight-artificer's commission", "a tournament-bound champion"),
		TRADE_REGION_DAFTSMARCH = list("a master smith's signature contract", "a foundry-master's masterpiece", "a guild's exhibition piece"),
		TRADE_REGION_HEARTFELT = list("the count's chosen champion", "a knightly investiture", "a roving warden captain"),
	)

/datum/standing_order/demand_artificed_panoply/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_ARTIFICED_HALFPLATE] = 1
	if(prob(55))
		mix[TRADE_GOOD_VOLTIC_GAUNTLETS] = 1
	mix[TRADE_GOOD_STEEL_INGOT] = rand(8, 14)
	if(prob(50))
		mix[TRADE_GOOD_GOLD_INGOT] = rand(2, 4)
	return mix

/datum/standing_order/demand_artificed_panoply/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ARTIFICED PANOPLY"

/datum/standing_order/demand_artificed_panoply/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] commissions a panoply of artificed plate. Masterwork pays masterwork's price."
	return "A patron at [region.name] commissions a panoply of artificed plate."


// ============================================================================
// demand_tournament_supply - single fat composite order, deliberately challenging
// ============================================================================
/datum/standing_order/demand_tournament_supply
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("the Tournament of the Three Hills", "the lists at Cherrybrook", "a knight-errants' convocation"),
		TRADE_REGION_HEARTFELT = list("the March Tourney", "the count's lists at Heartfelt"),
		TRADE_REGION_ROCKHILL = list("the Orchard Lists", "a midsummer tourney at Vespermill"),
	)
	var/list/weapon_pool = list(
		TRADE_GOOD_STEEL_ARMING_SWORD,
		TRADE_GOOD_STEEL_LONGSWORD,
		TRADE_GOOD_STEEL_MACE,
		TRADE_GOOD_STEEL_SABRE,
	)
	var/list/armor_pool = list(
		TRADE_GOOD_STEEL_CHAINMAIL,
		TRADE_GOOD_STEEL_HAUBERK,
		TRADE_GOOD_BRIGANDINE,
	)

/datum/standing_order/demand_tournament_supply/generate_item_mix()
	var/list/mix = list()
	mix[pick(weapon_pool)] = rand(3, 5)
	mix[pick(armor_pool)] = rand(2, 3)
	mix[TRADE_GOOD_HEALTH_POTION] = rand(6, 10)
	mix[TRADE_GOOD_MANA_POTION] = rand(3, 5)
	mix[TRADE_GOOD_GRAIN] = rand(20, 35)
	mix[TRADE_GOOD_MEAT] = rand(10, 18)
	mix[TRADE_GOOD_BUTTER] = rand(5, 10)
	if(prob(60))
		mix[TRADE_GOOD_NOBLECOAT] = rand(1, 2)
	if(prob(50))
		mix[TRADE_GOOD_RECURVE_BOW] = rand(3, 5)
	return mix

/datum/standing_order/demand_tournament_supply/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - TOURNAMENT PROVISION"

/datum/standing_order/demand_tournament_supply/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] requires arms, armor, draughts, and feast-fare. The patrons pay accordingly."
	return "A great tournament at [region.name] requires arms, armor, draughts, and feast-fare. The patrons pay accordingly."


// ============================================================================
// demand_arcane_commission - enchantment scrolls commissioned by NON-wizard regions.
// Blackholt is the producer (the conclave) - the demand fires elsewhere, paying the
// Crown to broker. Rolls one of three tiers, weighted toward routine basic-tier orders.
// ============================================================================
/datum/standing_order/demand_arcane_commission
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("a temple's bookbinder", "a knightly house outfitting", "a hospitaller buying for the road"),
		TRADE_REGION_ROCKHILL = list("a viscount's library", "a country estate's curio collector", "an oddly pale-skinned aristocrat with academic interests"),
		TRADE_REGION_KINGSFIELD = list("a knight-errant outfitting for the road", "a guild's bulk order", "a market wand-seller"),
		TRADE_REGION_NORTHFORT = list("a frontier scout-captain", "a band of border irregulars", "a local adventuring fellowship"),
	)
	/// Tier the order rolled. Set in generate_item_mix and read by name/description.
	var/rolled_tier = "basic"

/datum/standing_order/demand_arcane_commission/generate_item_mix()
	var/list/mix = list()
	var/roll = rand(1, 100)
	if(roll <= 55)
		rolled_tier = "basic"
		mix[TRADE_GOOD_ENCHSCROLL_BASIC] = rand(3, 6)
	else if(roll <= 85)
		rolled_tier = "superior"
		mix[TRADE_GOOD_ENCHSCROLL_SUPERIOR] = rand(2, 4)
	else
		rolled_tier = "greater"
		mix[TRADE_GOOD_ENCHSCROLL_GREATER] = rand(1, 3)
	return mix

/datum/standing_order/demand_arcane_commission/generate_name(datum/economic_region/region)
	switch(rolled_tier)
		if("superior")
			return "[uppertext(region.name)] - SUPERIOR ARCANA"
		if("greater")
			return "[uppertext(region.name)] - GREATER ARCANA"
		else
			return "[uppertext(region.name)] - ARCANE COMMISSION"

/datum/standing_order/demand_arcane_commission/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	var/patron = length(projects) ? capitalize(pick(projects)) : "A patron"
	switch(rolled_tier)
		if("superior")
			return "[patron] at [region.name] commissions superior enchantment scrolls - fulfilled at the warehouse, any scrolls will serve."
		if("greater")
			return "[patron] at [region.name] commissions greater enchantment scrolls - fulfilled at the warehouse - any types will serve."
		else
			return "[patron] at [region.name] commissions basic enchantment scrolls - any school of magic, sealed at the warehouse."


/datum/standing_order/demand_trophy_heads
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("the count's manor hall", "a marcher lord's gallery", "a heralds' lodge"),
		TRADE_REGION_ROCKHILL = list("a hunt-master's trophy hall", "the master-of-hounds at Vespermill", "a viscount's trophy room"),
	)
	/// Variant the order rolled. Set in generate_item_mix and read by generate_description.
	var/rolled_variant = "minotaur"

/datum/standing_order/demand_trophy_heads/generate_item_mix()
	var/list/mix = list()
	var/roll = rand(1, 100)
	if(roll <= 30)
		// White Stag — singular, no other heads. The bearer must trigger the boss spawn.
		rolled_variant = "white_stag"
		mix[TRADE_GOOD_TROPHY_WHITE_STAG] = 1
	else if(roll <= 65)
		// Minotaur + a couple of direbears.
		rolled_variant = "minotaur"
		mix[TRADE_GOOD_TROPHY_MINOTAUR] = rand(3, 6)
		if(prob(60))
			mix[TRADE_GOOD_TROPHY_DIREBEAR] = rand(1, 2)
	else
		// Regular troll heads only — exact-type match excludes axe/cave subtypes.
		rolled_variant = "troll"
		mix[TRADE_GOOD_TROPHY_TROLL] = rand(5, 6)
	return mix

/datum/standing_order/demand_trophy_heads/generate_name(datum/economic_region/region)
	switch(rolled_variant)
		if("white_stag")
			return "[uppertext(region.name)] - WHITE STAG TROPHY"
		if("troll")
			return "[uppertext(region.name)] - TROLL HEADS"
		else
			return "[uppertext(region.name)] - MANOR TROPHIES"

/datum/standing_order/demand_trophy_heads/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	var/patron = length(projects) ? capitalize(pick(projects)) : "A noble house"
	switch(rolled_variant)
		if("white_stag")
			return "[patron] at [region.name] would mount the White Stag's head above their hearth. None other will do."
		if("troll")
			return "[patron] at [region.name] would line their hall with troll heads - a warning to any who would test the marches."
		else
			return "[patron] at [region.name] commissions trophies for their gallery - heads of the wild brought to heel."
