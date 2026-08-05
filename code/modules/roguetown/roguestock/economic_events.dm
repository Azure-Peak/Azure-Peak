GLOBAL_LIST_EMPTY(active_economic_events)

/datum/economic_event
	var/name
	var/description
	var/announcement
	var/list/affected_goods
	var/price_mod = 1.0
	var/event_type
	var/duration_days = ECON_EVENT_DURATION
	var/day_started = 0
	var/day_expires = 0
	var/datum/weakref/urgent_order_ref
	var/saturation_target = 0
	var/saturation_progress = 0
	var/relief_triggered = FALSE

/datum/economic_event/proc/on_apply()
	for(var/good_id in affected_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg)
			tg.global_price_mod *= price_mod
	refresh_affected_stockpile_caches()
	if(event_type == ECON_EVENT_SHORTAGE)
		var/effective_pop = SSeconomy ? SSeconomy.get_effective_player_count() : get_active_player_count()
		var/pop_mult = min(REGION_POP_SCALE_MAX, 1.0 + (effective_pop * REGION_POP_SCALE_PER_PLAYER))
		var/demand_sum = 0
		var/demand_count = 0
		for(var/good_id in affected_goods)
			var/total_demand = 0
			for(var/region_id in GLOB.economic_regions)
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				total_demand += region.demands[good_id] || 0
			if(total_demand <= 0)
				continue
			demand_sum += total_demand * pop_mult * duration_days
			demand_count++
		saturation_target = demand_count > 0 ? clamp(round(demand_sum * ECON_EVENT_SATURATION_MULT / demand_count), ECON_EVENT_SATURATION_MIN, ECON_EVENT_SATURATION_MAX) : 1
	if(announcement && !(SSeconomy?.daily_report_diff))
		scom_announce(announcement)

/datum/economic_event/proc/on_expire()
	for(var/good_id in affected_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg && price_mod != 0)
			tg.global_price_mod /= price_mod
	refresh_affected_stockpile_caches()
	// Withdraw auto-price ratchets downward only, so a glut that pushed it below
	// baseline never recovers on its own. When an oversupply ends, snap any
	// auto-priced stockpile entry back to the restored market.
	if(event_type != ECON_EVENT_OVERSUPPLY)
		return
	for(var/datum/roguestock/D as anything in SStreasury.stockpile_datums)
		if(!D.automatic_price || !D.trade_good_id)
			continue
		if(!(D.trade_good_id in affected_goods))
			continue
		D.snap_auto_prices()

/// Refresh cached market reference prices and (for auto-priced entries) the live
/// payout/withdraw prices on every stockpile entry whose trade good was affected by
/// this event. Replaces the per-tick refresh_auto_price + get_market_*_price work
/// the stewardry UI used to do for every good every tick.
/datum/economic_event/proc/refresh_affected_stockpile_caches()
	for(var/datum/roguestock/D as anything in SStreasury.stockpile_datums)
		if(!D.trade_good_id || !(D.trade_good_id in affected_goods))
			continue
		var/datum/trade_good/tg = GLOB.trade_goods[D.trade_good_id]
		if(!tg)
			continue
		D.recompute_market_reference_prices(tg)
		if(D.automatic_price)
			D.compute_auto_prices(tg)
	SStreasury.dirty_market_view()

/datum/economic_event/proc/end_with_relief()
	if(relief_triggered)
		return
	relief_triggered = TRUE
	on_expire()
	GLOB.active_economic_events -= src
	if(SSeconomy)
		SSeconomy.event_path_cooldowns[type] = GLOB.dayspassed + ECON_EVENT_REROLL_COOLDOWN_DAYS
	record_round_statistic(STATS_SHORTAGES_ENDED, 1)
	var/list/diff = SSeconomy?.daily_report_diff
	if(diff)
		var/list/relieved = diff["events_relieved"]
		if(!relieved)
			relieved = list()
			diff["events_relieved"] = relieved
		relieved += name
	else
		scom_announce("<font color='#5cb85c'>RELIEF: [name] eased by relief efforts. Prices return to normal.</font>")

/proc/credit_economic_event_saturation(good_id, units)
	if(!good_id || units <= 0)
		return
	var/list/relieved = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.event_type != ECON_EVENT_SHORTAGE)
			continue
		if(E.relief_triggered)
			continue
		if(!(good_id in E.affected_goods))
			continue
		E.saturation_progress += units
		if(E.saturation_progress >= E.saturation_target)
			relieved += E
	for(var/datum/economic_event/E as anything in relieved)
		E.end_with_relief()


// ============================================================================
// SHORTAGES
// ============================================================================

/datum/economic_event/black_oak_rebellion
	name = "Black Oak Rebellion"
	description = "The Black Oaks have risen in Rosawood again - loggers found nailed to trees, woodcutters refuse to enter the deep groves without Crown escort."
	announcement = "<font color='#c44'>BLACK OAK REBELLION: Rosawood's logging camps lie abandoned. Wood prices surge.</font>"
	affected_goods = list(TRADE_GOOD_WOOD)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/ironmongers_strike
	name = "Ironmongers' Strike"
	description = "The ironmongers' guild has walked out over unpaid commissions - smelters sit cold."
	announcement = "<font color='#c44'>IRONMONGERS' STRIKE: Iron ore supply chokes. Smelted stock commands a premium.</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_IRON_INGOT, TRADE_GOOD_STEEL_INGOT)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/daftsmarch_cavein
	name = "Daftsmarch Cave-In"
	description = "A deep shaft collapse in Daftsmarch has shut mining operations across three veins."
	announcement = "<font color='#c44'>DAFTSMARCH CAVE-IN: Mines shuttered. Iron, coal, stone, and smelted stock all grow scarce.</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_COAL, TRADE_GOOD_STONE, TRADE_GOOD_IRON_INGOT, TRADE_GOOD_STEEL_INGOT)
	price_mod = ECON_SHORTAGE_NORMAL
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/wheat_blight
	name = "Wheat Blight"
	description = "A black rot has crept through the grain stores of the Kingsfield farmsteads."
	announcement = "<font color='#c44'>WHEAT BLIGHT: Grain and oats rot in the silos. Bread prices soar.</font>"
	affected_goods = list(TRADE_GOOD_GRAIN, TRADE_GOOD_OATS, TRADE_GOOD_RICE, TRADE_GOOD_MAIZE)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/saltwick_storm
	name = "Saltwick Storm"
	description = "A vicious gale has battered the Saltwick wharves - fishing fleets are grounded for days."
	announcement = "<font color='#c44'>SALTWICK STORM: Fishing fleets grounded. Fresh and cured fish alike grow dear.</font>"
	affected_goods = list(TRADE_GOOD_FISH_FILET, TRADE_GOOD_DRIED_FISH, TRADE_GOOD_FISH_MINCE)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/fur_trapping_frost
	name = "Trappers' Frost"
	description = "An unseasonal freeze has driven the game deep into the wilds - trappers return empty-handed."
	announcement = "<font color='#c44'>TRAPPERS' FROST: Fur, hide, and worked leather supply dries up. Tanners panic.</font>"
	affected_goods = list(TRADE_GOOD_FUR, TRADE_GOOD_HIDE, TRADE_GOOD_CURED_LEATHER)
	price_mod = ECON_SHORTAGE_NORMAL
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/cloth_smuggler_purge
	name = "Cloth Smuggler Purge"
	description = "A crown crackdown on black-market cloth has choked the legitimate supply as well."
	announcement = "<font color='#c44'>CLOTH SMUGGLER PURGE: Cloth and fibers seized from wagons. Tailors despair.</font>"
	affected_goods = list(TRADE_GOOD_CLOTH, TRADE_GOOD_FIBERS)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/essence_scarcity
	name = "Essence Scarcity"
	description = "The essence harvests in the Terrorbog have faltered - arcane reagents grow dear."
	announcement = "<font color='#c44'>ESSENCE SCARCITY: Dendor's essence and viscera run short. Wizards fume.</font>"
	affected_goods = list(TRADE_GOOD_DENDOR_ESSENCE, TRADE_GOOD_VISCERA)
	price_mod = ECON_SHORTAGE_CRISIS
	event_type = ECON_EVENT_SHORTAGE


// ============================================================================
// OVERSUPPLIES
// ============================================================================

/datum/economic_event/bumper_harvest
	name = "Bumper Harvest"
	description = "Kingsfield reports its finest grain harvest - granaries overflow."
	announcement = "<font color='#5cb85c'>BUMPER HARVEST: Grain and oats flood the markets. Prices collapse.</font>"
	affected_goods = list(TRADE_GOOD_GRAIN, TRADE_GOOD_OATS, TRADE_GOOD_RICE, TRADE_GOOD_MAIZE)
	price_mod = ECON_OVERSUPPLY_SEVERE
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/rosawood_overcut
	name = "Rosawood Overcut"
	description = "Rosawood's lumber camps have exceeded their quotas - barges choke the river with timber."
	announcement = "<font color='#5cb85c'>ROSAWOOD OVERCUT: Timber glut on the river. Wood prices slump.</font>"
	affected_goods = list(TRADE_GOOD_WOOD)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/herring_swarm
	name = "Herring Swarm"
	description = "A titanic shoal of fish has wandered into Saltwick waters - the nets come up full."
	announcement = "<font color='#5cb85c'>HERRING SWARM: Saltwick nets bursting. Fresh and cured fish both sell for pennies.</font>"
	affected_goods = list(TRADE_GOOD_FISH_FILET, TRADE_GOOD_DRIED_FISH, TRADE_GOOD_FISH_MINCE)
	price_mod = ECON_OVERSUPPLY_GLUT
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/unseasonal_fur
	name = "Unseasonal Fur"
	description = "Trappers report massive herds migrating through the borderlands - pelts pile in the warehouses."
	announcement = "<font color='#5cb85c'>UNSEASONAL FUR: Pelts pile up in the warehouses. Furrier prices tumble.</font>"
	affected_goods = list(TRADE_GOOD_FUR)
	price_mod = ECON_OVERSUPPLY_NORMAL
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/quarry_windfall
	name = "Quarry Windfall"
	description = "A rich new seam has been struck at the Mount Decapitation quarries - carts roll in from dawn to dusk."
	announcement = "<font color='#5cb85c'>QUARRY WINDFALL: Stone and coal flood the yards. Builders rejoice, quarrymen grumble.</font>"
	affected_goods = list(TRADE_GOOD_STONE, TRADE_GOOD_COAL)
	price_mod = ECON_OVERSUPPLY_MINOR
	event_type = ECON_EVENT_OVERSUPPLY


// ============================================================================
// SHORTAGES - additional
// ============================================================================

/datum/economic_event/murrain
	name = "Cattle Murrain"
	description = "A wasting sickness has swept the herds of the Kingsfield pastures. Meat, dairy, and cured sausage turn scarce."
	announcement = "<font color='#c44'>CATTLE MURRAIN: Herds sicken across the pastures. Meat, dairy, and cured sausage all grow dear.</font>"
	affected_goods = list(TRADE_GOOD_MEAT, TRADE_GOOD_BUTTER, TRADE_GOOD_CHEESE, TRADE_GOOD_SAUSAGE)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/saltmine_flooding
	name = "Salt-Mine Flooding"
	description = "Groundwater has broken through the Daftsmarch salt workings, drowning the lower galleries."
	announcement = "<font color='#c44'>SALT-MINE FLOODING: The Daftsmarch galleries drown. Salt grows precious.</font>"
	affected_goods = list(TRADE_GOOD_SALT)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/copper_tin_embargo
	name = "Copper and Tin Embargo"
	description = "A foreign crown has barred the export of its copper and tin. Bronze-smiths scramble."
	announcement = "<font color='#c44'>COPPER AND TIN EMBARGO: Foreign shipments halted. Ore and smelted ingots alike grow scarce.</font>"
	affected_goods = list(TRADE_GOOD_COPPER_ORE, TRADE_GOOD_TIN_ORE, TRADE_GOOD_COPPER_INGOT, TRADE_GOOD_TIN_INGOT)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/tanners_plague
	name = "Tanners' Plague"
	description = "A skin-rotting sickness has forced the tanneries to dump half-cured hides for burning."
	announcement = "<font color='#c44'>TANNERS' PLAGUE: Hides burned by the wagonload. Leather grows dear.</font>"
	affected_goods = list(TRADE_GOOD_CURED_LEATHER, TRADE_GOOD_HIDE)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/glass_furnace_failure
	name = "Glass Furnace Failure"
	description = "The great furnace at the glassworks has cracked. The craft has halted until it is rebuilt."
	announcement = "<font color='#c44'>GLASS FURNACE FAILURE: The great glassworks go dark. Glass batch grows rare.</font>"
	affected_goods = list(TRADE_GOOD_GLASS_BATCH)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/orchard_locusts
	name = "Orchard Locusts"
	description = "A swarm has stripped the Rockhill orchards bare. What little remains is sold at ransom."
	announcement = "<font color='#c44'>ORCHARD LOCUSTS: The orchards stripped bare. Apples, pears, and berries grow costly.</font>"
	affected_goods = list(TRADE_GOOD_APPLE, TRADE_GOOD_PEAR, TRADE_GOOD_JACKSBERRY)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/silk_moth_collapse
	name = "Silk Moth Collapse"
	description = "Blackholt's spider-silk harvest has collapsed. Arachnological misfortune, the conclave says."
	announcement = "<font color='#c44'>SILK MOTH COLLAPSE: Blackholt's silk harvest fails. Tailors grind their teeth.</font>"
	affected_goods = list(TRADE_GOOD_SILK)
	price_mod = ECON_SHORTAGE_CRISIS
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/clay_pit_collapse
	name = "CLAY PIT COLLAPSE"
	description = "The Blackholt clay pits have caved in, swallowing wagons and diggers alike. Potters are turned away empty-handed."
	announcement = "<font color='#c44'>CLAY PIT COLLAPSE: Blackholt's clay pits cave in. Potters and brickmakers cry out for stock.</font>"
	affected_goods = list(TRADE_GOOD_CLAY)
	price_mod = ECON_SHORTAGE_MINOR
	event_type = ECON_EVENT_SHORTAGE


// ============================================================================
// OVERSUPPLIES - additional
// ============================================================================

/datum/economic_event/dairy_surplus
	name = "Dairy Surplus"
	description = "A mild season has flooded the Kingsfield dairies with butter and cheese."
	announcement = "<font color='#5cb85c'>DAIRY SURPLUS: Butter and cheese overflow the churns. Prices slump.</font>"
	affected_goods = list(TRADE_GOOD_BUTTER, TRADE_GOOD_CHEESE)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/foreign_pig_iron_glut
	name = "Foreign Pig-Iron Glut"
	description = "A foreign crown has dumped its surplus ore on the open market. Wagons of pig-iron, copper, and tin roll in below cost."
	announcement = "<font color='#5cb85c'>FOREIGN PIG-IRON GLUT: Foreign ore floods the yards. Daftsmarch miners grumble; smiths stockpile cheap.</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_COPPER_ORE, TRADE_GOOD_TIN_ORE)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/salt_caravan
	name = "Salt Caravan Arrives"
	description = "A distant caravan has rolled in with wagons of salt - prices fall until the reserves clear."
	announcement = "<font color='#5cb85c'>SALT CARAVAN ARRIVES: Wagons of salt reach the markets. Preservers cheer.</font>"
	affected_goods = list(TRADE_GOOD_SALT)
	price_mod = ECON_OVERSUPPLY_SEVERE
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/cloth_fair
	name = "Cloth Fair"
	description = "The seasonal cloth fair has flooded the markets with raw fibers and bolts of fabric at cut-rate prices."
	announcement = "<font color='#5cb85c'>CLOTH FAIR: Raw fibers and bolts of fabric flood the markets. Tailors rejoice.</font>"
	affected_goods = list(TRADE_GOOD_CLOTH, TRADE_GOOD_FIBERS)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/fat_hog_season
	name = "Fat Hog Season"
	description = "The pig farmers have slaughtered early - pork and fat are cheap this week."
	announcement = "<font color='#5cb85c'>FAT HOG SEASON: Pork, fat, and cured swine-meats all go cheap. Butchers work through the night.</font>"
	affected_goods = list(TRADE_GOOD_PORK, TRADE_GOOD_FAT, TRADE_GOOD_TALLOW, TRADE_GOOD_SAUSAGE, TRADE_GOOD_SALUMOI)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/cidering_season
	name = "Cidering Season"
	description = "The Rockhill presses groan under a glut of fruit. Vendors dump the excess at any price."
	announcement = "<font color='#5cb85c'>CIDERING SEASON: Fruit piles outside the presses. Orchard goods go cheap.</font>"
	affected_goods = list(TRADE_GOOD_APPLE, TRADE_GOOD_PEAR, TRADE_GOOD_JACKSBERRY)
	price_mod = ECON_OVERSUPPLY_SEVERE
	event_type = ECON_EVENT_OVERSUPPLY
