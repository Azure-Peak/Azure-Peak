GLOBAL_LIST_EMPTY(active_economic_events)

/datum/economic_event
	var/name
	var/description
	var/fish_crops = FALSE // These are events that can handle fish and crops, which so far is the main type of goods where the producer role can switch production, therefore, they can occur everyday to add varieties
	var/list/exclusive = list() // Events sharing a tag here can't be active at the same time
	var/list/shortage_goods = list()
	var/list/glut_goods = list()
	var/list/affected_goods
	var/duration_days = ECON_EVENT_DURATION
	var/day_started = 0
	var/day_expires = 0
	var/saturation_target = 0
	var/saturation_progress = 0
	var/relief_triggered = FALSE
	var/mixed = FALSE

/datum/economic_event/New()
	. = ..()
	affected_goods = shortage_goods | glut_goods
	mixed = length(shortage_goods) && length(glut_goods)

/datum/economic_event/proc/on_apply()
	shock_market_stock()
	if(length(shortage_goods))
		var/market_value = 0
		for(var/good_id in shortage_goods)
			var/datum/roguestock/D = SStreasury.stockpile_by_trade_good[good_id]
			if(D)
				market_value += D.market_target * SSeconomy.good_steady_price(good_id)
		saturation_target = max(1, round(market_value * ECON_EVENT_RELIEF_PERCENT / 100))
	scom_announce("<font color='[length(shortage_goods) ? ECON_EVENT_SHORTAGE_COLOR : ECON_EVENT_GLUT_COLOR]'>[uppertext(name)]: [description]</font>")

/datum/economic_event/proc/on_expire()
	SStreasury.dirty_market_view()

/datum/economic_event/proc/shock_market_stock()
	for(var/good_id in glut_goods)
		var/datum/roguestock/D = SStreasury.stockpile_by_trade_good[good_id]
		if(D)
			D.market_stock = max(D.market_stock, CEILING(D.market_target * MARKET_GLUT_SHOCK / 100, 1))
	for(var/good_id in shortage_goods)
		var/datum/roguestock/D = SStreasury.stockpile_by_trade_good[good_id]
		if(D)
			D.market_stock = min(D.market_stock, 0)
	SStreasury.dirty_market_view()

/datum/economic_event/proc/relieve_shortage()
	if(relief_triggered || !length(shortage_goods))
		return
	record_round_statistic(STATS_SHORTAGES_ENDED, 1)
	shortage_goods = list()
	relieve_side("shortage")

/datum/economic_event/proc/relieve_glut()
	if(relief_triggered || !length(glut_goods))
		return
	glut_goods = list()
	relieve_side("glut")

/datum/economic_event/proc/relieve_side(side)
	affected_goods = shortage_goods | glut_goods
	announce_relief(mixed ? "[name] [side]" : name)
	if(length(affected_goods))
		SStreasury.dirty_market_view()
		return
	relief_triggered = TRUE
	on_expire()
	GLOB.active_economic_events -= src
	if(SSeconomy)
		SSeconomy.event_path_cooldowns[type] = ECONOMY_DAY + ECON_EVENT_REROLL_COOLDOWN_DAYS

/datum/economic_event/proc/announce_relief(label)
	var/list/diff = SSeconomy?.dawn_digest
	if(diff)
		var/list/relieved = diff["events_relieved"]
		if(!relieved)
			relieved = list()
			diff["events_relieved"] = relieved
		relieved += label
	else
		scom_announce("<font color='[ECON_EVENT_GLUT_COLOR]'>RELIEF: [label] is over. Prices return to normal.</font>")

/proc/credit_economic_event_saturation(good_id, units)
	if(!good_id || units <= 0)
		return
	var/list/relieved = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.relief_triggered || !(good_id in E.shortage_goods))
			continue
		E.saturation_progress = mammon_round(E.saturation_progress + units * SSeconomy.good_steady_price(good_id))
		E.dirty_shortage_rows()
		if(E.saturation_progress >= E.saturation_target)
			relieved += E
	for(var/datum/economic_event/E as anything in relieved)
		E.relieve_shortage()

/proc/debit_economic_event_saturation(good_id, units)
	if(!good_id || units <= 0)
		return
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.relief_triggered || !(good_id in E.shortage_goods))
			continue
		E.saturation_progress = max(0, mammon_round(E.saturation_progress - units * SSeconomy.good_steady_price(good_id)))
		E.dirty_shortage_rows()

/datum/economic_event/proc/dirty_shortage_rows()
	for(var/good_id in shortage_goods)
		var/datum/roguestock/D = SStreasury.stockpile_by_trade_good[good_id]
		if(D)
			D.market_row = null

/proc/trade_good_names(list/good_ids)
	var/list/names = list()
	for(var/good_id in good_ids)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		names += (tg ? tg.name : good_id)
	return names
