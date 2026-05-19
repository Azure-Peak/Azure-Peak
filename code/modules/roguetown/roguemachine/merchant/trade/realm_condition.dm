/datum/realm_condition
	var/id
	var/name = "Generic Condition"
	var/description = "TODO: flavor pass"
	var/weight = 10
	var/list/affected_realms = list()
	var/cross_realm = FALSE
	var/list/supply_modifiers = list()
	var/list/demand_modifiers = list()
	var/list/cultural_modifiers = list()
	var/list/per_realm_modifiers = list()
	var/tone = "neutral"

/datum/realm_condition/proc/apply_to(datum/foreign_realm/R)
	if(!R)
		return
	for(var/list/mod as anything in supply_modifiers)
		apply_pool_modifier(R.bulk_supply_pool, mod)
	for(var/list/mod as anything in demand_modifiers)
		apply_pool_modifier(R.bulk_demand_pool, mod)
	for(var/list/mod as anything in cultural_modifiers)
		apply_cultural_modifier(R, mod)
	var/list/realm_block = per_realm_modifiers[R.id]
	if(islist(realm_block))
		for(var/list/mod as anything in realm_block["supply"])
			apply_pool_modifier(R.bulk_supply_pool, mod)
		for(var/list/mod as anything in realm_block["demand"])
			apply_pool_modifier(R.bulk_demand_pool, mod)
		for(var/list/mod as anything in realm_block["cultural"])
			apply_cultural_modifier(R, mod)

/datum/realm_condition/proc/apply_pool_modifier(list/pool, list/mod)
	var/op = mod["op"]
	switch(op)
		if(CONDITION_OP_MODIFY)
			modify_pool_line(pool, mod["good"], mod["price_mod"], mod["qty_mod"])
		if(CONDITION_OP_REMOVE)
			remove_pool_line(pool, mod["good"])
		if(CONDITION_OP_ADD)
			add_pool_line(pool, mod)

/datum/realm_condition/proc/modify_pool_line(list/pool, good_id, price_mod, qty_mod)
	for(var/list/line in pool)
		if(line["good"] != good_id)
			continue
		if(price_mod)
			line["price_mod"] = (line["price_mod"] || 1.0) * price_mod
		if(qty_mod)
			line["qty_min"] = max(1, round((line["qty_min"] || BULK_QTY_SMALL_MIN) * qty_mod))
			line["qty_max"] = max(line["qty_min"], round((line["qty_max"] || BULK_QTY_SMALL_MAX) * qty_mod))
		return

/datum/realm_condition/proc/remove_pool_line(list/pool, good_id)
	for(var/i in length(pool) to 1 step -1)
		var/list/line = pool[i]
		if(line["good"] == good_id)
			pool.Cut(i, i + 1)

/datum/realm_condition/proc/add_pool_line(list/pool, list/mod)
	pool += list(list(
		"good" = mod["good"],
		"qty_min" = mod["qty_min"] || BULK_QTY_SMALL_MIN,
		"qty_max" = mod["qty_max"] || BULK_QTY_SMALL_MAX,
		"price_mod" = mod["price_mod"] || BULK_PRICE_FAIR,
		"always" = mod["always"] || FALSE,
	))

/datum/realm_condition/proc/apply_cultural_modifier(datum/foreign_realm/R, list/mod)
	var/op = mod["op"]
	var/typepath = mod["typepath"]
	if(!typepath)
		return
	switch(op)
		if(CONDITION_OP_ADD)
			if(!(typepath in R.cultural_stock_pool))
				R.cultural_stock_pool += typepath
		if(CONDITION_OP_REMOVE)
			R.cultural_stock_pool -= typepath
		if(CONDITION_OP_MODIFY_CULTURAL)
			var/key = "[typepath]"
			if(!R.cultural_overrides[key])
				R.cultural_overrides[key] = list("price_mult" = 1.0, "qty_mult" = 1.0)
			if(mod["price_mod"])
				R.cultural_overrides[key]["price_mult"] *= mod["price_mod"]
			if(mod["qty_mod"])
				R.cultural_overrides[key]["qty_mult"] *= mod["qty_mod"]
