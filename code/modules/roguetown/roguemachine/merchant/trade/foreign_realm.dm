/datum/foreign_realm
	var/id
	var/name
	var/roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	var/list/ship_name_words = list()
	/// If TRUE, compound ship names use a single word instead of two (e.g. "Sakura-Maru" not "Sakura Sora-Maru").
	var/single_word_base = FALSE
	var/list/proper_names = list()
	var/list/captain_first_names = list()
	var/list/captain_last_names = list()
	var/list/ship_types = list()
	/// Entries support text / text_male+text_female / requires_proper_name. First entry whose chance fires wins.
	var/list/name_prefixes = list()
	var/list/name_suffixes = list()
	var/list/city_tags = list()
	var/city_tag_chance = 0
	var/list/cultural_goods = list()
	var/list/bulk_demand_pool_base = list()
	var/list/bulk_supply_pool_base = list()
	var/list/bulk_demand_modifiers = list()
	var/list/bulk_supply_modifiers = list()
	var/list/cultural_stock_pool = list()
	var/list/demanded_categories = list()
	var/list/cultural_overrides = list()
	var/list/victualling_fresh_pool = list()
	var/list/victualling_preserved_pool = list()
	var/list/victualling_drinks_pool = list()
	var/list/hail_lines = list()

/datum/foreign_realm/proc/get_effective_demand_pool()
	return build_effective_pool(bulk_demand_pool_base, bulk_demand_modifiers)

/datum/foreign_realm/proc/get_effective_supply_pool()
	return build_effective_pool(bulk_supply_pool_base, bulk_supply_modifiers)

/datum/foreign_realm/proc/build_effective_pool(list/base, list/modifiers)
	var/list/result = list()
	var/list/removed_goods = list()
	for(var/list/mod as anything in modifiers)
		if(mod["op"] == CONDITION_OP_REMOVE)
			removed_goods[mod["good"]] = TRUE
	for(var/list/entry as anything in base)
		if(removed_goods[entry["good"]])
			continue
		var/list/working = entry.Copy()
		for(var/list/mod as anything in modifiers)
			if(mod["op"] != CONDITION_OP_MODIFY)
				continue
			if(mod["good"] != entry["good"])
				continue
			if(mod["price_mod"])
				working["price_mod"] = (working["price_mod"] || 1.0) * mod["price_mod"]
			if(mod["qty_mod"])
				working["qty_min"] = max(1, round((working["qty_min"] || BULK_QTY_SMALL_MIN) * mod["qty_mod"]))
				working["qty_max"] = max(working["qty_min"], round((working["qty_max"] || BULK_QTY_SMALL_MAX) * mod["qty_mod"]))
		result += list(working)
	for(var/list/mod as anything in modifiers)
		if(mod["op"] != CONDITION_OP_ADD)
			continue
		result += list(list(
			"good" = mod["good"],
			"qty_min" = mod["qty_min"] || BULK_QTY_SMALL_MIN,
			"qty_max" = mod["qty_max"] || BULK_QTY_SMALL_MAX,
			"price_mod" = mod["price_mod"] || BULK_PRICE_FAIR,
			"always" = mod["always"] || FALSE,
		))
	return result

/// Returns UI-friendly summary: list of dicts {good, name, always, removed, delta_steps} where delta_steps counts net + (positive price_mods) and - (negative price_mods) condition effects.
/datum/foreign_realm/proc/get_pool_ui_summary(want_supply)
	var/list/base = want_supply ? bulk_supply_pool_base : bulk_demand_pool_base
	var/list/modifiers = want_supply ? bulk_supply_modifiers : bulk_demand_modifiers
	var/list/result = list()
	var/list/base_goods = list()
	for(var/list/entry as anything in base)
		base_goods[entry["good"]] = TRUE
		var/datum/trade_good/TG = GLOB.trade_goods?[entry["good"]]
		if(!TG)
			continue
		var/removed = FALSE
		var/delta_steps = 0
		for(var/list/mod as anything in modifiers)
			if(mod["good"] != entry["good"])
				continue
			if(mod["op"] == CONDITION_OP_REMOVE)
				removed = TRUE
			else if(mod["op"] == CONDITION_OP_MODIFY)
				var/p = mod["price_mod"]
				if(!p)
					continue
				if(p > 1.0)
					delta_steps += 1
				else if(p < 1.0)
					delta_steps -= 1
		result += list(list(
			"good" = entry["good"],
			"name" = TG.name,
			"always" = entry["always"] ? TRUE : FALSE,
			"removed" = removed,
			"delta_steps" = delta_steps,
			"added_only" = FALSE,
		))
	for(var/list/mod as anything in modifiers)
		if(mod["op"] != CONDITION_OP_ADD)
			continue
		if(base_goods[mod["good"]])
			continue
		var/datum/trade_good/TG = GLOB.trade_goods?[mod["good"]]
		if(!TG)
			continue
		result += list(list(
			"good" = mod["good"],
			"name" = TG.name,
			"always" = mod["always"] ? TRUE : FALSE,
			"removed" = FALSE,
			"delta_steps" = 1,
			"added_only" = TRUE,
		))
	return result

/datum/foreign_realm/proc/pick_ship_type()
	if(!length(ship_types))
		return null
	var/list/weighted = list()
	for(var/list/entry as anything in ship_types)
		weighted[entry] = entry["weight"] || 1
	return pickweight(weighted)

/datum/foreign_realm/proc/generate_ship_name()
	var/list/picked_prefix = pick_prefix()
	var/base
	var/picked_gender
	if(picked_prefix && picked_prefix["requires_proper_name"] && length(proper_names))
		var/list/eligible = filter_proper_names_for_prefix(picked_prefix)
		var/list/proper = length(eligible) ? pick(eligible) : pick(proper_names)
		if(islist(proper))
			base = proper["name"]
			picked_gender = proper["gender"]
		else
			base = proper
	else
		base = make_compound_name()
	var/prefix_text = ""
	if(picked_prefix)
		if(picked_gender == "f" && picked_prefix["text_female"])
			prefix_text = picked_prefix["text_female"]
		else if(picked_gender == "m" && picked_prefix["text_male"])
			prefix_text = picked_prefix["text_male"]
		else if(picked_prefix["text"])
			prefix_text = picked_prefix["text"]
		else if(picked_prefix["text_male"])
			prefix_text = picked_prefix["text_male"]
	var/suffix_text = roll_simple_affix(name_suffixes)
	return "[prefix_text][base][suffix_text]"

/datum/foreign_realm/proc/generate_port_of_origin()
	if(!length(city_tags) || !prob(city_tag_chance))
		return ""
	return pick(city_tags)

/datum/foreign_realm/proc/filter_proper_names_for_prefix(list/prefix)
	var/has_male = !!prefix["text_male"]
	var/has_female = !!prefix["text_female"]
	var/has_neutral = !!prefix["text"]
	if(has_neutral && has_male && has_female)
		return proper_names
	var/list/out = list()
	for(var/list/entry as anything in proper_names)
		var/g = islist(entry) ? entry["gender"] : null
		if(!g)
			if(has_neutral)
				out += list(entry)
			continue
		if(g == "m" && has_male)
			out += list(entry)
		else if(g == "f" && has_female)
			out += list(entry)
	return out

/datum/foreign_realm/proc/make_compound_name()
	if(!length(ship_name_words))
		return "Vessel"
	if(single_word_base || length(ship_name_words) == 1)
		return pick(ship_name_words)
	var/word_a = pick(ship_name_words)
	var/word_b = pick(ship_name_words)
	while(word_b == word_a)
		word_b = pick(ship_name_words)
	return "[word_a] [word_b]"

/datum/foreign_realm/proc/pick_prefix()
	if(!length(name_prefixes))
		return null
	for(var/list/entry as anything in name_prefixes)
		var/chance = entry["chance"] || 0
		if(chance > 0 && prob(chance))
			return entry
	return null

/datum/foreign_realm/proc/roll_simple_affix(list/affixes)
	if(!length(affixes))
		return ""
	for(var/list/entry as anything in affixes)
		var/chance = entry["chance"] || 0
		if(chance > 0 && prob(chance))
			return entry["text"]
	return ""

/datum/foreign_realm/proc/generate_captain_name()
	var/first = length(captain_first_names) ? pick(captain_first_names) : "Unnamed"
	var/last = length(captain_last_names) ? pick(captain_last_names) : "Captain"
	return "[first] [last]"

/datum/foreign_realm/proc/pick_hail_line()
	if(!length(hail_lines))
		return null
	return pick(hail_lines)

/datum/foreign_realm/proc/typical_provisions()
	var/list/parts = list()
	for(var/list/entry as anything in victualling_fresh_pool)
		var/atom/A = entry["typepath"]
		if(A)
			parts += initial(A.name)
	for(var/list/entry as anything in victualling_preserved_pool)
		var/atom/A = entry["typepath"]
		if(A)
			parts += initial(A.name)
	for(var/list/entry as anything in victualling_drinks_pool)
		var/datum/brewing_recipe/recipe = entry["recipe"]
		if(recipe)
			parts += initial(recipe.bottle_name)
	return english_list(parts, "nothing in particular")

