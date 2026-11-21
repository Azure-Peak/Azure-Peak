GLOBAL_LIST_EMPTY(active_economic_events)

/datum/economic_event
	var/name
	var/description
	var/announcement
	var/list/affected_goods
	var/event_type
	var/duration_days = ECON_EVENT_DURATION
	var/day_started = 0
	var/day_expires = 0
	var/saturation_target = 0
	var/saturation_progress = 0
	var/relief_triggered = FALSE

/datum/economic_event/proc/on_apply()
	shock_market_stock()
	if(event_type == ECON_EVENT_SHORTAGE)
		var/market_value = 0
		for(var/good_id in affected_goods)
			var/datum/roguestock/D = SStreasury.stockpile_by_trade_good[good_id]
			if(D)
				market_value += D.market_target * SSeconomy.good_steady_price(good_id)
		saturation_target = max(1, round(market_value * ECON_EVENT_RELIEF_PERCENT / 100))
	if(announcement)
		scom_announce(announcement)

/datum/economic_event/proc/on_expire()
	SStreasury.dirty_market_view()

/datum/economic_event/proc/shock_market_stock()
	for(var/good_id in affected_goods)
		var/datum/roguestock/D = SStreasury.stockpile_by_trade_good[good_id]
		if(!D)
			continue
		if(event_type == ECON_EVENT_OVERSUPPLY)
			D.market_stock = max(D.market_stock, CEILING(D.market_target * MARKET_GLUT_SHOCK / 100, 1))
		else if(event_type == ECON_EVENT_SHORTAGE)
			D.market_stock = min(D.market_stock, 0)
	SStreasury.dirty_market_view()

/datum/economic_event/proc/end_with_relief()
	if(relief_triggered)
		return
	relief_triggered = TRUE
	on_expire()
	GLOB.active_economic_events -= src
	if(SSeconomy)
		SSeconomy.event_path_cooldowns[type] = ECONOMY_DAY + ECON_EVENT_REROLL_COOLDOWN_DAYS
	if(event_type == ECON_EVENT_SHORTAGE)
		record_round_statistic(STATS_SHORTAGES_ENDED, 1)
	var/list/diff = SSeconomy?.dawn_digest
	if(diff)
		var/list/relieved = diff["events_relieved"]
		if(!relieved)
			relieved = list()
			diff["events_relieved"] = relieved
		relieved += name
	else
		scom_announce("<font color='#5cb85c'>RELIEF: [name] is over. Prices return to normal.</font>")

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
		E.saturation_progress = mammon_round(E.saturation_progress + units * SSeconomy.good_steady_price(good_id))
		if(E.saturation_progress >= E.saturation_target)
			relieved += E
	for(var/datum/economic_event/E as anything in relieved)
		E.end_with_relief()


// ============================================================================
// SHORTAGES
// ============================================================================

/datum/economic_event/ironmongers_strike
	name = "Ironmongers' Strike"
	description = "The ironmongers' guild has walked out over unpaid commissions."
	announcement = "<font color='#c44'>IRONMONGERS' STRIKE: Iron ore supply chokes. Smelted ingots sell for more.</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_IRON_INGOT, TRADE_GOOD_STEEL_INGOT)
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/fur_trapping_frost
	name = "Trappers' Frost"
	description = "An unseasonal freeze has driven the game deep into hiding. Trappers are coming back with nothing."
	announcement = "<font color='#c44'>TRAPPERS' FROST: Fur, hide, and leather supply dries up.</font>"
	affected_goods = list(TRADE_GOOD_FUR, TRADE_GOOD_HIDE, TRADE_GOOD_CURED_LEATHER)
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/cloth_smuggler_purge
	name = "Cloth Smuggler Purge"
	description = "A Crown crackdown on black market cloth has choked the legitimate supply as well."
	announcement = "<font color='#c44'>CLOTH SMUGGLER PURGE: Cloth and fibers are being seized from wagons. Tailors despair.</font>"
	affected_goods = list(TRADE_GOOD_CLOTH, TRADE_GOOD_FIBERS)
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/essence_scarcity
	name = "Essence Scarcity"
	description = "The essence harvests in the Terrorbog have faltered."
	announcement = "<font color='#c44'>ESSENCE SCARCITY: Dendor's essence and viscera run short.</font>"
	affected_goods = list(TRADE_GOOD_DENDOR_ESSENCE, TRADE_GOOD_VISCERA)
	event_type = ECON_EVENT_SHORTAGE


// ============================================================================
// OVERSUPPLIES
// ============================================================================

/datum/economic_event/quarry_windfall
	name = "Quarry Windfall"
	description = "Quarrymen at Mount Decapitation have struck a rich new seam of quality stone and coal."
	announcement = "<font color='#5cb85c'>QUARRY WINDFALL: New seams found. Quality stone and coal are sold for zennies.</font>"
	affected_goods = list(TRADE_GOOD_STONE, TRADE_GOOD_COAL)
	event_type = ECON_EVENT_OVERSUPPLY


// ============================================================================
// SHORTAGES - additional
// ============================================================================

/datum/economic_event/copper_tin_embargo
	name = "Copper and Tin Embargo"
	description = "A foreign crown has barred the export of its copper and tin. Bronzesmiths are short of metal."
	announcement = "<font color='#c44'>COPPER AND TIN EMBARGO: Foreign copper and tin shipments have stopped. Ore and smelted ingots alike grow scarce.</font>"
	affected_goods = list(TRADE_GOOD_COPPER_ORE, TRADE_GOOD_TIN_ORE, TRADE_GOOD_COPPER_INGOT, TRADE_GOOD_TIN_INGOT)
	event_type = ECON_EVENT_SHORTAGE


// ============================================================================
// OVERSUPPLIES - additional
// ============================================================================

/datum/economic_event/foreign_pig_iron_glut
	name = "Foreign Pig Iron Glut"
	description = "A foreign crown has dumped its surplus ore on the open market. Wagons of pig iron, copper, and tin roll in at low price."
	announcement = "<font color='#5cb85c'>FOREIGN PIG IRON GLUT: Foreign ore floods the market. Guildsmen and smiths rejoice!</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_COPPER_ORE, TRADE_GOOD_TIN_ORE)
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/salt_caravan
	name = "Salt Caravan Arrives"
	description = "A caravan from Naledi has rolled in with wagons of salt. Prices for salt will stay low until it is sold off."
	announcement = "<font color='#5cb85c'>SALT CARAVAN ARRIVES: Wagons of Naledi salt reach the markets. Fishermen cheer.</font>"
	affected_goods = list(TRADE_GOOD_SALT)
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/cloth_fair
	name = "Cloth Fair"
	description = "The seasonal cloth fair has filled the markets with cheap raw fibers and bolts of fabric."
	announcement = "<font color='#5cb85c'>CLOTH FAIR: The seasonal cloth fair is on. Cloth and fibers are cheap.</font>"
	affected_goods = list(TRADE_GOOD_CLOTH, TRADE_GOOD_FIBERS)
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/fat_hog_season
	name = "Fat Hog Season"
	description = "The pigs this season are unusually plump and succulent. Pig farmers have slaughtered them early. Pork and fat are cheap this week."
	announcement = "<font color='#5cb85c'>FAT HOG SEASON: Pork, fat, and cured pork all go cheap. Butchers work through the night.</font>"
	affected_goods = list(TRADE_GOOD_PORK, TRADE_GOOD_FAT, TRADE_GOOD_TALLOW, TRADE_GOOD_SAUSAGE, TRADE_GOOD_SALUMOI)
	event_type = ECON_EVENT_OVERSUPPLY

