GLOBAL_LIST_EMPTY(brewing_recipe_by_reagent)

/proc/brew_recipe_for_reagent(reagent_path)
	if(!reagent_path)
		return null
	if(!GLOB.brewing_recipe_by_reagent.len)
		for(var/datum/brewing_recipe/R as anything in subtypesof(/datum/brewing_recipe))
			var/produced = initial(R.reagent_to_brew)
			if(produced && !GLOB.brewing_recipe_by_reagent[produced])
				GLOB.brewing_recipe_by_reagent[produced] = R
	return GLOB.brewing_recipe_by_reagent[reagent_path]

/proc/brew_recipe_needs_distiller(datum/brewing_recipe/recipe_path)
	var/guard = 0
	while(recipe_path && guard < 10)
		if(initial(recipe_path.heat_required))
			return TRUE
		var/prereq = initial(recipe_path.pre_reqs)
		if(!prereq)
			return FALSE
		recipe_path = brew_recipe_for_reagent(prereq)
		guard++
	return FALSE

/datum/trade_ship
	var/ship_id
	var/realm_id
	var/ship_name
	var/captain_name
	var/port_of_origin = ""
	var/ship_type
	var/tonnage = TRADE_SHIP_DEFAULT_TONNAGE
	var/expected_favor
	var/spawned_at
	var/dock_state = TRADE_SHIP_STATE_AVAILABLE
	var/docked_at = 0
	var/dock_expires_at = 0
	var/dock_expiry_timer_id
	var/favor_earned = 0
	var/auto_hailed = FALSE
	var/list/bulk_demands = list()
	var/list/bulk_supplies = list()
	var/list/cultural_stock = list()

/datum/trade_ship/New(datum/foreign_realm/realm)
	if(!realm)
		return
	src.realm_id = realm.id
	var/list/picked_type = realm.pick_ship_type()
	var/listed_tonnage = TRADE_SHIP_DEFAULT_TONNAGE
	if(picked_type)
		src.ship_type = picked_type["name"]
		listed_tonnage = picked_type["tonnage"] || TRADE_SHIP_DEFAULT_TONNAGE
	var/tonnage_swing = listed_tonnage * TRADE_SHIP_TONNAGE_VARIANCE
	src.tonnage = round(listed_tonnage + rand(-tonnage_swing, tonnage_swing))
	src.ship_name = realm.generate_ship_name()
	src.captain_name = realm.generate_captain_name()
	src.port_of_origin = realm.generate_port_of_origin()
	src.spawned_at = world.time
	src.ship_id = "[world.time]_[ref(src)]"
	src.expected_favor = round(TRADE_SHIP_EXPECTED_FAVOR * tonnage_scale_mult())
	roll_bulk_lines(realm)
	roll_victualling_lines(realm)
	roll_cultural_stock(realm)

/datum/trade_ship/proc/tonnage_scale_mult()
	var/raw = 1.0 + (tonnage - TRADE_SHIP_DEFAULT_TONNAGE) / TRADE_SHIP_TONNAGE_SCALE_SPAN
	return clamp(raw, 1.0, TRADE_SHIP_TONNAGE_SCALE_CAP)

/datum/trade_ship/proc/roll_bulk_lines(datum/foreign_realm/realm)
	bulk_demands = roll_bulk_pool(realm.get_effective_demand_pool(), FALSE)
	bulk_supplies = roll_bulk_pool(realm.get_effective_supply_pool(), TRUE)

/datum/trade_ship/proc/roll_bulk_pool(list/pool, is_supply)
	var/list/result = list()
	if(!length(pool))
		return result
	var/list/always_entries = list()
	var/list/rare_entries = list()
	for(var/list/entry as anything in pool)
		if(entry["always"])
			always_entries += list(entry)
		else
			rare_entries += list(entry)
	for(var/list/entry as anything in always_entries)
		var/list/line = build_bulk_line(entry, is_supply)
		if(line)
			result += list(line)
	if(length(rare_entries))
		var/n_rare = rand(TRADE_SHIP_BULK_LINES_MIN, min(TRADE_SHIP_BULK_LINES_MAX, length(rare_entries)))
		var/list/picks = rare_entries.Copy()
		for(var/i in 1 to n_rare)
			if(!length(picks))
				break
			var/list/entry = pick(picks)
			picks -= list(entry)
			var/list/line = build_bulk_line(entry, is_supply)
			if(line)
				result += list(line)
	return result

/datum/trade_ship/proc/build_bulk_line(list/entry, is_supply)
	var/datum/trade_good/TG = GLOB.trade_goods[entry["good"]]
	if(!TG)
		return null
	var/qty_mult = tonnage_scale_mult() * (is_supply ? TRADE_SHIP_SUPPLY_QTY_FRACTION : 1.0)
	var/qty = round(rand(entry["qty_min"], entry["qty_max"]) * qty_mult)
	var/jitter = 0.9 + (rand() * 0.2)
	var/offered_price = round(TG.base_price * entry["price_mod"] * jitter)
	return list(
		"good" = entry["good"],
		"good_name" = TG.name,
		"qty_target" = max(1, qty),
		"qty_fulfilled" = 0,
		"offered_price" = offered_price,
	)

/datum/trade_ship/proc/roll_victualling_lines(datum/foreign_realm/realm)
	if(!realm)
		return
	var/n_fresh = rand(TRADE_VICTUALLING_FRESH_LINES_MIN, TRADE_VICTUALLING_FRESH_LINES_MAX)
	bulk_demands += build_victualling_lines(realm.victualling_fresh_pool, n_fresh, TRADE_VICTUALLING_TAG_FRESH)
	var/n_preserved = rand(TRADE_VICTUALLING_PRESERVED_LINES_MIN, TRADE_VICTUALLING_PRESERVED_LINES_MAX)
	bulk_demands += build_victualling_lines(realm.victualling_preserved_pool, n_preserved, TRADE_VICTUALLING_TAG_PRESERVED)
	var/n_drinks = rand(TRADE_VICTUALLING_DRINKS_LINES_MIN, TRADE_VICTUALLING_DRINKS_LINES_MAX)
	bulk_demands += build_drinks_lines(realm.victualling_drinks_pool, n_drinks)

/datum/trade_ship/proc/build_victualling_lines(list/pool, n_lines, tag)
	var/list/result = list()
	if(!length(pool) || n_lines <= 0)
		return result
	var/list/picks = pool.Copy()
	for(var/i in 1 to min(n_lines, length(picks)))
		var/list/entry = pick(picks)
		picks -= list(entry)
		var/typepath = entry["typepath"]
		if(!typepath)
			continue
		var/atom/A = typepath
		var/name_str = entry["name"] || initial(A.name)
		var/qty = round(rand(entry["qty_min"] || TRADE_VICTUALLING_QTY_PER_LINE_MIN, entry["qty_max"] || TRADE_VICTUALLING_QTY_PER_LINE_MAX) * tonnage_scale_mult())
		var/offered_price = entry["price"] || 10
		result += list(list(
			"typepath" = "[typepath]",
			"good_name" = name_str,
			"qty_target" = max(1, qty),
			"qty_fulfilled" = 0,
			"offered_price" = max(1, offered_price),
			"tag" = tag,
		))
	return result


/datum/trade_ship/proc/build_drinks_lines(list/pool, n_lines)
	var/list/result = list()
	if(!length(pool) || n_lines <= 0)
		return result
	var/list/picks = pool.Copy()
	for(var/i in 1 to min(n_lines, length(picks)))
		var/list/entry = pick(picks)
		picks -= list(entry)
		var/datum/brewing_recipe/recipe = entry["recipe"]
		if(!recipe)
			continue
		var/typepath = initial(recipe.output_bottle_type)
		if(!typepath)
			continue
		var/price_mod = entry["price_mod"] || 1.0
		var/volume_mult = entry["keg_mult"] || 1
		if(brew_recipe_needs_distiller(recipe))
			var/brewed = max(1, initial(recipe.brewed_amount))
			var/per_bottle = max(1, round(initial(recipe.sell_value) / brewed * TRADE_SPIRITS_EXPORT_MARKUP * price_mod))
			var/bottle_qty = max(1, round(rand(TRADE_DRINKS_BOTTLES_MIN, TRADE_DRINKS_BOTTLES_MAX) * volume_mult * tonnage_scale_mult()))
			result += list(list(
				"typepath" = "[typepath]",
				"good_name" = "bottle of [initial(recipe.bottle_name)]",
				"qty_target" = bottle_qty,
				"qty_fulfilled" = 0,
				"offered_price" = per_bottle,
				"tag" = TRADE_VICTUALLING_TAG_DRINKS,
				"by_bottle" = TRUE,
			))
			continue
		var/offered_price = max(1, round(initial(recipe.sell_value) * TRADE_DRINKS_EXPORT_MARKUP * price_mod))
		var/keg_qty = max(1, round(rand(TRADE_DRINKS_KEGS_MIN, TRADE_DRINKS_KEGS_MAX) * volume_mult * tonnage_scale_mult()))
		result += list(list(
			"typepath" = "[typepath]",
			"good_name" = "keg of [initial(recipe.bottle_name)]",
			"qty_target" = keg_qty,
			"qty_fulfilled" = 0,
			"offered_price" = offered_price,
			"tag" = TRADE_VICTUALLING_TAG_DRINKS,
		))
	return result


/datum/trade_ship/proc/roll_cultural_stock(datum/foreign_realm/realm)
	cultural_stock = list()
	for(var/pack_path in realm.cultural_stock_pool)
		var/datum/supply_pack/PA = SSmerchant.supply_packs[pack_path]
		if(!PA)
			continue
		var/key = "[pack_path]"
		var/list/override = realm.cultural_overrides[key]
		var/qty_mult = override ? override["qty_mult"] : 1.0
		var/price_mult = override ? override["price_mult"] : 1.0
		var/qty = round(rand(PA.ship_qty_min, PA.ship_qty_max) * qty_mult)
		if(qty <= 0)
			continue
		cultural_stock += list(list(
			"pack" = "[pack_path]",
			"name" = PA.name,
			"qty" = qty,
			"pack_qty" = PA.no_name_quantity ? 1 : PA.contains.len,
			"base_cost" = round(PA.cost * price_mult),
		))

/datum/trade_ship/Destroy()
	if(dock_expiry_timer_id)
		deltimer(dock_expiry_timer_id)
		dock_expiry_timer_id = null
	return ..()

/datum/trade_ship/proc/dock()
	if(dock_state == TRADE_SHIP_STATE_DOCKED)
		return FALSE
	dock_state = TRADE_SHIP_STATE_DOCKED
	docked_at = world.time
	dock_expires_at = world.time + TRADE_SHIP_DOCK_DURATION
	dock_expiry_timer_id = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(trade_ship_expire_dock), src), TRADE_SHIP_DOCK_DURATION, TIMER_STOPPABLE)
	if(SSmerchant_trade)
		var/datum/foreign_realm/realm = SSmerchant_trade.realms[realm_id]
		SSmerchant_trade.add_ship_demand_for_realm(realm)
	return TRUE

/proc/trade_ship_expire_dock(datum/trade_ship/ship)
	if(!ship || ship.dock_state != TRADE_SHIP_STATE_DOCKED)
		return
	if(SSmerchant_trade)
		SSmerchant_trade.auto_dismiss_ship(ship)
	else
		qdel(ship)
