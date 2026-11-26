/datum/controller/subsystem/treasury/proc/export_steward_policy()
	var/list/limits = list()
	var/list/autoexport_barred = list()
	var/list/withdraw_barred = list()
	var/list/accept_off = list()
	for(var/datum/roguestock/D as anything in stockpile_datums)
		if(!D.trade_good_id)
			continue
		if(!D.automatic_limit)
			limits[D.trade_good_id] = D.stockpile_limit
		if(D.autoexport_disabled)
			autoexport_barred += D.trade_good_id
		if(D.withdraw_disabled)
			withdraw_barred += D.trade_good_id
		if(!D.accept_toggle_enabled)
			accept_off += D.trade_good_id
	var/list/standing = list()
	for(var/good_id in auto_import_standing)
		standing += good_id
	var/list/auto_import_off = list()
	for(var/good_id in auto_import_disabled)
		auto_import_off += good_id
	return json_encode(list(
		"version" = STEWARD_POLICY_EXPORT_VERSION,
		"limits" = limits,
		"autoexport_barred" = autoexport_barred,
		"withdraw_barred" = withdraw_barred,
		"accept_off" = accept_off,
		"auto_import_standing" = standing,
		"auto_import_off" = auto_import_off,
		"autoexport_percentage" = round(autoexport_percentage * 100),
		"auto_import_purse_floor" = auto_import_purse_floor,
	))

/datum/controller/subsystem/treasury/proc/import_steward_policy(blob)
	if(!istext(blob) || length(blob) > STEWARD_POLICY_IMPORT_MAX_LEN)
		return null
	var/list/data = safe_json_decode(blob)
	if(!islist(data) || !isnum(data["version"]) || data["version"] > STEWARD_POLICY_EXPORT_VERSION)
		return null
	for(var/field in list("limits", "autoexport_barred", "withdraw_barred", "accept_off", "auto_import_standing", "auto_import_off"))
		var/list/entries = data[field]
		if(!isnull(entries) && (!islist(entries) || length(entries) > length(stockpile_datums)))
			return null
	var/list/tally = list("applied" = 0, "skipped" = 0)
	var/list/limits = data["limits"]
	if(islist(limits))
		for(var/good_id in limits)
			var/datum/roguestock/D = istext(good_id) ? SSeconomy.find_stockpile_by_trade_good(good_id) : null
			var/lim = istext(good_id) ? limits[good_id] : null
			if(!D || !isnum(lim))
				tally["skipped"]++
				continue
			D.set_manual_limit(lim)
			tally["applied"]++
	for(var/datum/roguestock/D in import_policy_goods(data["autoexport_barred"], tally))
		D.autoexport_disabled = TRUE
		tally["applied"]++
	for(var/datum/roguestock/D in import_policy_goods(data["withdraw_barred"], tally))
		D.withdraw_disabled = TRUE
		tally["applied"]++
	for(var/datum/roguestock/D in import_policy_goods(data["accept_off"], tally))
		D.accept_toggle_enabled = FALSE
		tally["applied"]++
	for(var/datum/roguestock/D in import_policy_goods(data["auto_import_standing"], tally))
		set_auto_import(D.trade_good_id, TRUE)
		tally["applied"]++
	for(var/datum/roguestock/D in import_policy_goods(data["auto_import_off"], tally))
		set_auto_import(D.trade_good_id, FALSE)
		tally["applied"]++
	var/pct = data["autoexport_percentage"]
	if(isnum(pct))
		autoexport_percentage = clamp(round(pct), 0, 100) * 0.01
		tally["applied"]++
	var/purse_floor = data["auto_import_purse_floor"]
	if(isnum(purse_floor))
		set_auto_import_purse_floor(purse_floor)
		tally["applied"]++
	dirty_market_view()
	return tally

/datum/controller/subsystem/treasury/proc/import_policy_goods(list/ids, list/tally)
	. = list()
	if(!islist(ids))
		return
	for(var/good_id in ids)
		var/datum/roguestock/D = istext(good_id) ? SSeconomy.find_stockpile_by_trade_good(good_id) : null
		if(!D)
			tally["skipped"]++
			continue
		. += D
