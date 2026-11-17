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

/datum/standing_order/request
	var/good_id

/datum/standing_order/request/generate_name(datum/economic_region/region)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	return "[uppertext(region.name)] - [uppertext(tg ? tg.name : good_id)]"

/datum/standing_order/request/generate_description(datum/economic_region/region)
	return ""


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
	var/list/buyers = list("Local notables", "The town's merchants", "The guild elders", "Desperate burghers", "Local magnates")
	var/buyer = pick(buyers)
	var/datum/economic_event/E = source_event_ref?.resolve()
	if(E)
		return "[region.name] is suffering from [E.name]. [buyer] are paying a premium for relief."
	return "[buyer] in [region.name] need goods urgently and will pay extra."


// ============================================================================
// demand_equipment_armaments - finished weapons for a garrison
// ============================================================================
/datum/standing_order/demand_equipment_armaments
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKISLES = list("a privateer captain", "a corsair's company", "a harbor watch armsmaster"),
		TRADE_REGION_NORTHMARCH = list("a frontier garrison", "a watch sergeant", "a band of border irregulars"),
		TRADE_REGION_HEARTFELT = list("the count's retinue", "a mercenary band", "a warband"),
		TRADE_REGION_KINGSFIELD = list("an armsmaster", "a wandering knight", "an arms dealer"),
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
		return "[capitalize(pick(projects))] at [region.name] needs finished arms. Leave them at the warehouse."
	return "A garrison at [region.name] needs finished arms. Leave them at the warehouse."


// ============================================================================
// demand_equipment_armor_heavy - finished metallic harness for a garrison
// (smith-fulfillable, no tailor goods required)
// ============================================================================
/datum/standing_order/demand_equipment_armor_heavy
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKISLES = list("a galley's crew", "a privateer captain", "a harbor watch armsmaster"),
		TRADE_REGION_NORTHMARCH = list("a frontier garrison", "a watch sergeant", "a relief company"),
		TRADE_REGION_HEARTFELT = list("the count's retinue", "a mercenary band", "a knightly house"),
		TRADE_REGION_KINGSFIELD = list("an armsmaster", "a knightly house", "a knight bound for the tournament"),
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
		return "[capitalize(pick(projects))] at [region.name] needs finished armor. Leave it at the warehouse."
	return "A garrison at [region.name] needs finished armor. Leave it at the warehouse."


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
		TRADE_REGION_BLEAKISLES = list("the harbor watch", "a levy mustering", "a corsair's company"),
		TRADE_REGION_NORTHMARCH = list("a watch sergeant", "a band of border irregulars", "a company of reservists"),
		TRADE_REGION_HEARTFELT = list("a warden party", "the count's footsergeants", "an adventuring fellowship"),
		TRADE_REGION_KINGSFIELD = list("a levy", "a town militia", "a yeoman captain"),
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
	return "[uppertext(region.name)] - LEVY TUNICS"

/datum/standing_order/demand_equipment_armor_light/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] needs finished gambesons and leather armor. Leave them at the warehouse."
	return "A levy at [region.name] needs finished gambesons and leather armor. Leave them at the warehouse."


// ============================================================================
// demand_alchemical - finished potions for a chapel infirmary, conclave, or watch
// Delivered to the warehouse: any container holding the right reagent at the right
// volume satisfies a unit. Matched containers are consumed in full.
// ============================================================================
/datum/standing_order/demand_alchemical
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("an infirmarer", "a hospitaller", "a garrison surgeon"),
		TRADE_REGION_BLACKHOLT = list("a wizards' coven", "an alchemist", "a physician"),
		TRADE_REGION_BLEAKISLES = list("a galley's surgeon", "a privateer's crew", "a garrison apothecary"),
		TRADE_REGION_NORTHMARCH = list("a surgeon", "a watch sergeant", "a band of border irregulars"),
		TRADE_REGION_KINGSFIELD = list("an apothecary", "a healer", "a herbalist"),
	)
	// Mana lives in the premium pool only - keeping it in both used to let a premium roll
	// overwrite the larger primary qty when the same id was picked twice.
	var/list/medicinal_pool = list(
		TRADE_GOOD_HEALTH_POTION,
		TRADE_GOOD_ANTIDOTE_POTION,
	)
	var/list/premium_pool = list(
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_STRONG_MANA_POTION,
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
		return "[capitalize(pick(projects))] at [region.name] needs finished potions. Leave them at the warehouse."
	return "An apothecary at [region.name] needs finished potions. Leave them at the warehouse."

// ============================================================================
// demand_alchemical_warband - elite buff-potion order for adventurers, the conclave,
// and chosen retinues. Stat-buff potions and stamina potions plus a backbone of strong-* support potions.
// ============================================================================
/datum/standing_order/demand_alchemical_warband
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_BLACKHOLT = list("a wizards' coven", "a battle mage's retinue", "a noble's hunting party"),
		TRADE_REGION_HEARTFELT = list("the count's chosen retinue", "a temple's champion", "a warden party"),
		TRADE_REGION_KINGSFIELD = list("a band of wandering knights", "a mercenary captain's warband", "a noble's hunting party"),
		TRADE_REGION_NORTHMARCH = list("a raiding band", "a watch sergeant's squad", "an adventuring fellowship"),
	)
	var/list/buff_pool = list(
		TRADE_GOOD_PERCEPTION_POTION,
		TRADE_GOOD_INTELLIGENCE_POTION,
		TRADE_GOOD_SPEED_POTION,
		TRADE_GOOD_STAM_POTION,
		TRADE_GOOD_STRONG_STAM_POTION,
	)
	var/list/support_pool = list(
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_STRONG_MANA_POTION,
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
		return "[capitalize(pick(projects))] at [region.name] needs finished fortifying draughts and strong potions. Leave them at the warehouse."
	return "An elite party at [region.name] needs finished fortifying draughts and strong potions. Leave them at the warehouse."


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
		TRADE_REGION_BLEAKISLES = list("Lord Captain Vesarion of Saltreef"),
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
		return "[pick(celebrants)] of [region.name] has a name day coming. Their household is buying gifts."
	return "A noble of [region.name] has a name day coming. Their household is buying gifts."


// ============================================================================
// demand_frontier_gear - finished light/medium kit for the wardens and watch
// ============================================================================
/datum/standing_order/demand_frontier_gear
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_NORTHMARCH = list("a watch sergeant", "a band of border irregulars", "a company of reservists"),
		TRADE_REGION_BLEAKISLES = list("the harbor watch", "a coastal patrol mustering", "a privateer's crew"),
		TRADE_REGION_HEARTFELT = list("a warden party", "a temple's guard", "an adventuring fellowship"),
		TRADE_REGION_KINGSFIELD = list("a sheriff's posse", "the militia", "a yeoman captain"),
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
		mix[TRADE_GOOD_RECURVE_BOW] = rand(1, 5)
	return mix

/datum/standing_order/demand_frontier_gear/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - FRONTIER GARRISON KIT"

/datum/standing_order/demand_frontier_gear/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] needs finished light armor and bows. Leave them at the warehouse."
	return "A frontier company at [region.name] needs finished light armor and bows. Leave them at the warehouse."


// ============================================================================
// demand_court_finery - finished tailoring for the court and its lesser houses
// ============================================================================
/datum/standing_order/demand_court_finery
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a noble household's wardrobe", "a court tailor's rush order", "a tailor's window"),
		TRADE_REGION_HEARTFELT = list("the count's wardrobe", "a noble investiture", "a wedding"),
		TRADE_REGION_ROCKHILL = list("an estate's spring wardrobe", "a noble's name day", "a baron's wedding"),
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
		return "[region.name] needs finished court clothes for [pick(projects)]. Leave them at the warehouse."
	return "[region.name] needs finished court clothes for a noble household. Leave them at the warehouse."


// ============================================================================
// demand_artificery - mixed engineering bundle: glass, copper, tin, coal, mess kit
// ============================================================================
/datum/standing_order/demand_artificery
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_DAFTSMARCH = list("the artificers' guild", "a master smith", "a forgemaster"),
		TRADE_REGION_KINGSFIELD = list("a court artificer", "a guild engineer", "a clockmaker"),
		TRADE_REGION_BLACKHOLT = list("an artificer", "an arcane engineer", "a tinkerer"),
		TRADE_REGION_NORTHMARCH = list("a garrison engineer", "a siege engineer at the keep", "a company of sappers"),
	)

/datum/standing_order/demand_artificery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_FOLD_TABLE] = rand(1, 3)

	if(prob(70))
		mix[TRADE_GOOD_MOBILE_STOVE] = 1
	else if(prob(50))
		mix[TRADE_GOOD_KEY] = rand(2, 10)
		mix[TRADE_GOOD_LOCK] = rand(2, 10)
	if(prob(45))
		mix[TRADE_GOOD_WATER_PURIFIER] = rand(1, 3)
	if(prob(50))
		mix[TRADE_GOOD_MESS_KIT] = rand(1, 3)
	else if(prob(50))
		mix[TRADE_GOOD_SCISSORS] = rand(1, 3)
	return mix

/datum/standing_order/demand_artificery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ARTIFICER'S WORKSHOP"

/datum/standing_order/demand_artificery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] needs finished artificed goods. Leave them at the warehouse."
	return "An artificer at [region.name] needs finished artificed goods. Leave them at the warehouse."


// ============================================================================
// demand_jewelry - jeweler's stocking order, mixed rings and amulets
// ============================================================================
/datum/standing_order/demand_jewelry
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a court jeweler", "a goldsmith", "a noble household"),
		TRADE_REGION_HEARTFELT = list("the count's jeweler", "a temple's reliquary keeper", "a house preparing for a wedding"),
		TRADE_REGION_ROCKHILL = list("an estate jeweler", "a noble dressing for a name day", "a baron's household"),
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
	mix[pick(jewelry_pool)] = rand(1, 2)
	if(prob(60))
		var/second = pick(jewelry_pool)
		mix[second] = rand(1, 2)
	if(prob(15))
		mix[TRADE_GOOD_DIAMOND_RING] = 1
	return mix

/datum/standing_order/demand_jewelry/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - JEWELERS' COMMISSION"

/datum/standing_order/demand_jewelry/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] needs finished rings and amulets. Leave them at the warehouse."
	return "A jeweler at [region.name] needs finished rings and amulets. Leave them at the warehouse."


// ============================================================================
// demand_prosthetic_run - chapel/infirmary order: prosthetics + healing potions/amputation scissors
// ============================================================================
/datum/standing_order/demand_prosthetic_run
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("an infirmarer", "a hospitaller tending the wounded", "a battlefield surgeon"),
		TRADE_REGION_NORTHMARCH = list("a surgeon", "the garrison's infirmarer", "a band of border irregulars"),
		TRADE_REGION_BLEAKISLES = list("a galley's surgeon", "a bonesetter", "a privateer's crew"),
	)

/datum/standing_order/demand_prosthetic_run/generate_item_mix()
	var/list/mix = list()
	var/primary_prosthetic = pick(TRADE_GOOD_BRONZE_PROSTHETIC, TRADE_GOOD_IRON_PROSTHETIC)
	mix[primary_prosthetic] = rand(2, 3)
	if(prob(35))
		mix[TRADE_GOOD_STEEL_PROSTHETIC] = 1
	if(prob(50))
		mix[TRADE_GOOD_ANTIDOTE_POTION] = rand(4, 7)
	else if(prob(50))
		mix[TRADE_GOOD_AUTO_SHEARS] = 1
	if(prob(60))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(4, 8)
	return mix

/datum/standing_order/demand_prosthetic_run/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - INFIRMARY'S ORDER"

/datum/standing_order/demand_prosthetic_run/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[capitalize(pick(projects))] at [region.name] needs finished prosthetics and potions. Leave them at the warehouse."
	return "An infirmary at [region.name] needs finished prosthetics and potions. Leave them at the warehouse."


// ============================================================================
// demand_artificed_panoply - rare premium order: voltic gauntlets + steam shield,
// optionally anchored by a smith's steel harness
// ============================================================================
/datum/standing_order/demand_artificed_panoply
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("the Grand Duke's master of arms", "an artificer's patron", "a champion riding in the tournament"),
		TRADE_REGION_DAFTSMARCH = list("a smith's showpiece", "a forgemaster's masterpiece", "a guild exhibition"),
		TRADE_REGION_HEARTFELT = list("the count's champion", "a knight's investiture", "a warden captain"),
	)

/datum/standing_order/demand_artificed_panoply/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_CROSSBOW] = rand(1, 3)
	mix[TRADE_GOOD_BRONZE_INGOT] = rand(1, 4)
	if(prob(55))
		mix[TRADE_GOOD_VOLTIC_GAUNTLETS] = 1
	else
		mix[TRADE_GOOD_STEAM_SHIELD] = 1
	if(prob(50))
		mix[TRADE_GOOD_AUTO_SHEARS] = 1
	else if(prob(50))
		mix[TRADE_GOOD_GRAPPLING_HOOK] = 1
	return mix

/datum/standing_order/demand_artificed_panoply/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - ARTIFICED PANOPLY"

/datum/standing_order/demand_artificed_panoply/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] needs finished artificed war gear for [pick(projects)]. Leave it at the warehouse."
	return "A patron at [region.name] needs finished artificed war gear. Leave it at the warehouse."


// ============================================================================
// demand_tournament
// ============================================================================
/datum/standing_order/demand_tournament_arms
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("a tournament", "a village tourney", "a gathering of wandering knights"),
		TRADE_REGION_HEARTFELT = list("the count's tourney", "the count's lists"),
		TRADE_REGION_ROCKHILL = list("a harvest tourney", "a midsummer tourney"),
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

/datum/standing_order/demand_tournament_arms/generate_item_mix()
	var/list/mix = list()
	mix[pick(weapon_pool)] = rand(3, 5)
	mix[pick(armor_pool)] = rand(2, 3)
	if(prob(50))
		mix[TRADE_GOOD_RECURVE_BOW] = rand(1, 4)
	return mix

/datum/standing_order/demand_tournament_arms/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - TOURNAMENT: ARMS"

/datum/standing_order/demand_tournament_arms/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] needs finished arms and armor for [pick(projects)]. Leave them at the warehouse."
	return "[region.name] needs finished arms and armor for a great tournament. Leave them at the warehouse."

// ============================================================================
// demand_arcane_commission - enchantment scrolls commissioned by NON-wizard regions.
// Blackholt is the producer (the conclave) - the demand fires elsewhere, paying the
// Crown to broker. Rolls one of three tiers, weighted toward routine basic-tier orders.
// ============================================================================
/datum/standing_order/demand_arcane_commission
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("a temple's bookbinder", "a knightly house", "a hospitaller"),
		TRADE_REGION_ROCKHILL = list("a viscount's librarian", "a curio collector", "a scholar"),
		TRADE_REGION_KINGSFIELD = list("a wandering knight", "a merchant buying in bulk", "a wand seller"),
		TRADE_REGION_NORTHMARCH = list("a scout captain", "a band of border irregulars", "an adventuring fellowship"),
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
			return "[patron] at [region.name] needs superior enchantment tinctures of any school. Leave them at the warehouse."
		if("greater")
			return "[patron] at [region.name] needs greater enchantment tinctures of any school. Leave them at the warehouse."
		else
			return "[patron] at [region.name] needs basic enchantment tinctures of any school. Leave them at the warehouse."


/datum/standing_order/demand_trophy_heads
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("the count", "a marcher lord", "a herald"),
		TRADE_REGION_ROCKHILL = list("a huntmaster", "a lord's master of hounds", "a viscount"),
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
			return "[patron] at [region.name] would line their hall with troll heads as a warning to any who would test the marches."
		else
			return "[patron] at [region.name] commissions minotaur heads for their gallery."
