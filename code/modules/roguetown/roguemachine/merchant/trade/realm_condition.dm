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
		R.bulk_supply_modifiers += list(mod.Copy())
	for(var/list/mod as anything in demand_modifiers)
		R.bulk_demand_modifiers += list(mod.Copy())
	for(var/list/mod as anything in cultural_modifiers)
		apply_cultural_modifier(R, mod)
	var/list/realm_block = per_realm_modifiers[R.id]
	if(islist(realm_block))
		for(var/list/mod as anything in realm_block["supply"])
			R.bulk_supply_modifiers += list(mod.Copy())
		for(var/list/mod as anything in realm_block["demand"])
			R.bulk_demand_modifiers += list(mod.Copy())
		for(var/list/mod as anything in realm_block["cultural"])
			apply_cultural_modifier(R, mod)

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
