GLOBAL_LIST_EMPTY(material_baseline_prices)
GLOBAL_LIST_EMPTY(derived_sellprices)
GLOBAL_LIST_EMPTY(derived_categories)
GLOBAL_LIST_EMPTY(item_cat_markups)

/proc/init_item_cat_markups()
	GLOB.item_cat_markups = list(
		ITEM_CAT_ARMOR_HELMETS = 2.0,
		ITEM_CAT_ARMOR_CHESTPIECES = 2.0,
		ITEM_CAT_ARMOR_LEGS = 2.0,
		ITEM_CAT_ARMOR_NECK = 2.0,
		ITEM_CAT_ARMOR_BOOTS = 2.0,
		ITEM_CAT_ARMOR_GLOVES = 2.0,
		ITEM_CAT_ARMOR_MASKS = 2.0,
		ITEM_CAT_ARMOR_BRACERS = 2.0,
		ITEM_CAT_ARMOR_BELTS = 2.0,
		ITEM_CAT_ARMOR_BARDING = 2.0,
		ITEM_CAT_WEAPONS_SWORDS = 2.0,
		ITEM_CAT_WEAPONS_DAGGERS = 2.0,
		ITEM_CAT_WEAPONS_AXES = 2.0,
		ITEM_CAT_WEAPONS_POLEARMS = 2.0,
		ITEM_CAT_WEAPONS_MACES = 2.0,
		ITEM_CAT_WEAPONS_FLAILS = 2.0,
		ITEM_CAT_WEAPONS_SHIELDS = 2.0,
		ITEM_CAT_WEAPONS_AMMO = 2.0,
		ITEM_CAT_TOOLS_COOKWARE = 2.0,
		ITEM_CAT_TOOLS_FIELD = 2.0,
		ITEM_CAT_TOOLS_WORKSHOP = 2.0,
		ITEM_CAT_TOOLS_SUNDRIES = 2.0,
		ITEM_CAT_TOOLS_ROGUE = 2.0,
		ITEM_CAT_VALUABLES_RINGS = 2.0,
		ITEM_CAT_VALUABLES_HOLY = 2.0,
		ITEM_CAT_DECORATION = 2.0,
		ITEM_CAT_POTTERY = 2.0,
		ITEM_CAT_COMPONENTS = 2.0,
		ITEM_CAT_SMITHING_MISC = 2.0,
		ITEM_CAT_ENG_MACHINERY = 2.0,
		ITEM_CAT_ENG_CONSTRUCTION = 2.0,
		ITEM_CAT_ENG_COMBAT = 2.0,
		ITEM_CAT_ENG_TRIGGERS = 2.0,
		ITEM_CAT_ENG_MISC = 2.0,
		ITEM_CAT_GARMENT_COMMON = 2.0,
		ITEM_CAT_GARMENT_FINE = 2.0,
		ITEM_CAT_GARMENT_LUXURY = 2.0,
		ITEM_CAT_FOODSTUFF_FRESH = 2.0,
		ITEM_CAT_FOODSTUFF_PRESERVED = 2.0,
		ITEM_CAT_POTION = 2.0,
		ITEM_CAT_BEVERAGE = 2.0,
		ITEM_CAT_BOOK_WRIT = 2.0,
		ITEM_CAT_INSTRUMENT = 2.0,
		ITEM_CAT_TROPHY = 2.0,
		ITEM_CAT_RAW_MATERIAL_MINERAL = 1.0,
		ITEM_CAT_RAW_MATERIAL_ORGANIC = 1.0,
		ITEM_CAT_REAGENT_ALCHEMICAL = 1.0,
		ITEM_CAT_REAGENT_ARCANE = 1.0,
		ITEM_CAT_SALVAGE = 1.0,
		ITEM_CAT_LIVESTOCK = 1.0,
		ITEM_CAT_MISCELLANEOUS = 1.0,
	)

/proc/init_material_baseline_prices()
	GLOB.material_baseline_prices = list()
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(!TG.item_type || !TG.base_price)
			continue
		if(!(TG.behavior == TRADE_BEHAVIOR_RAW || TG.behavior == TRADE_BEHAVIOR_INTERMEDIARY || TG.behavior == TRADE_BEHAVIOR_GEM))
			continue
		GLOB.material_baseline_prices[TG.item_type] = TG.base_price
	GLOB.material_baseline_prices[/obj/item/ingot/iron] = SELLPRICE_IRON_INGOT
	GLOB.material_baseline_prices[/obj/item/ingot/copper] = SELLPRICE_COPPER_INGOT
	GLOB.material_baseline_prices[/obj/item/ingot/tin] = SELLPRICE_TIN_INGOT
	GLOB.material_baseline_prices[/obj/item/ingot/steel] = SELLPRICE_STEEL_INGOT
	GLOB.material_baseline_prices[/obj/item/ingot/gold] = SELLPRICE_GOLD_INGOT
	GLOB.material_baseline_prices[/obj/item/ingot/silver] = SELLPRICE_SILVER_INGOT
	GLOB.material_baseline_prices[/obj/item/ingot/bronze] = round(SELLPRICE_COPPER_INGOT + SELLPRICE_TIN_INGOT * 0.5)
	GLOB.material_baseline_prices[/obj/item/ingot/silverblessed] = round(SELLPRICE_SILVER_INGOT * 2)
	GLOB.material_baseline_prices[/obj/item/ingot/silverblessed/bullion] = round(SELLPRICE_SILVER_INGOT * 2)
	GLOB.material_baseline_prices[/obj/item/ingot/steelholy] = round(SELLPRICE_STEEL_INGOT * 4)
	GLOB.material_baseline_prices[/obj/item/ingot/blacksteel] = round(SELLPRICE_STEEL_INGOT * 4)
	GLOB.material_baseline_prices[/obj/item/ingot/lithmyc] = round(SELLPRICE_STEEL_INGOT * 12)
	GLOB.material_baseline_prices[/obj/item/ingot/purifiedaalloy] = round(SELLPRICE_STEEL_INGOT * 20)
	GLOB.material_baseline_prices[/obj/item/ingot/aalloy] = round(SELLPRICE_IRON_INGOT * 0.5)
	GLOB.material_baseline_prices[/obj/item/grown/log/tree/small] = SELLPRICE_WOOD
	GLOB.material_baseline_prices[/obj/item/natural/wood/plank] = round(SELLPRICE_WOOD * 1.5)
	GLOB.material_baseline_prices[/obj/item/natural/glass] = SELLPRICE_GLASS_BATCH
	GLOB.material_baseline_prices[/obj/item/roguegear] = round(SELLPRICE_STEEL_INGOT * 1.0)

/proc/init_derived_sellprices()
	GLOB.derived_sellprices = list()
	GLOB.derived_categories = list()
	var/list/trade_good_lookup = list()
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(!TG.item_type)
			continue
		trade_good_lookup[TG.item_type] = TG
	var/max_passes = 6
	for(var/pass in 1 to max_passes)
		var/passed = derived_pass(null, null)
		if(!passed)
			break
	var/list/missing_materials = list()
	var/list/audit_lines = list()
	audit_lines += "kind\tname\toutput\tcategory\tcategory_missing\tmaterial_cost\tderived_price\tmissing_reqs"
	derived_pass(audit_lines, missing_materials)
	fdel("data/pricing_engine_audit.txt")
	text2file(jointext(audit_lines, "\n"), "data/pricing_engine_audit.txt")
	dump_trade_good_audit(trade_good_lookup)
	for(var/typepath in trade_good_lookup)
		if(!GLOB.derived_sellprices[typepath])
			var/datum/trade_good/TG = trade_good_lookup[typepath]
			if(TG.base_price > 0)
				GLOB.derived_sellprices[typepath] = TG.base_price
	log_world("Pricing engine: derived [length(GLOB.derived_sellprices)] prices, [length(missing_materials)] unique missing materials. Audit at data/pricing_engine_audit.txt, trade audit at data/pricing_engine_trade_audit.txt.")

/proc/dump_trade_good_audit(list/trade_good_lookup)
	var/list/rows = list()
	for(var/typepath in trade_good_lookup)
		var/datum/trade_good/TG = trade_good_lookup[typepath]
		var/old_price = TG.base_price || 0
		var/new_price = GLOB.derived_sellprices[typepath] || 0
		var/delta = new_price - old_price
		var/delta_pct = old_price > 0 ? round((delta / old_price) * 100) : (new_price > 0 ? 9999 : 0)
		rows += list(list("name" = TG.name, "id" = TG.id, "typepath" = "[typepath]", "old" = old_price, "new" = new_price, "delta" = delta, "delta_pct" = delta_pct, "behavior" = TG.behavior, "category" = TG.category))
	sortTim(rows, GLOBAL_PROC_REF(cmp_trade_audit_row_by_delta_pct))
	var/list/audit_lines = list()
	audit_lines += "name\tid\ttypepath\tbehavior\tcategory\told_base_price\tnew_derived_price\tdelta\tdelta_pct"
	for(var/list/row in rows)
		audit_lines += "[row["name"]]\t[row["id"]]\t[row["typepath"]]\t[row["behavior"]]\t[row["category"]]\t[row["old"]]\t[row["new"]]\t[row["delta"]]\t[row["delta_pct"]]%"
	fdel("data/pricing_engine_trade_audit.txt")
	text2file(jointext(audit_lines, "\n"), "data/pricing_engine_trade_audit.txt")

/proc/cmp_trade_audit_row_by_delta_pct(list/a, list/b)
	return abs(b["delta_pct"]) - abs(a["delta_pct"])

/proc/derived_pass(list/audit_lines, list/missing_materials)
	var/new_derivations = 0
	for(var/datum/anvil_recipe/AR as anything in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.created_item || !AR.req_bar)
			continue
		var/category = AR.display_category
		var/cat_missing = FALSE
		if(!category)
			category = ITEM_CAT_SMITHING_MISC
			cat_missing = TRUE
		var/list/local_missing = list()
		var/material_cost = recipe_material_cost_for(AR.req_bar, local_missing)
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				material_cost += recipe_material_cost_for(path, local_missing)
		if(missing_materials)
			for(var/m in local_missing)
				if(!(m in missing_materials))
					missing_materials += m
		var/yield = max(1, AR.createditem_num)
		var/derived = derive_price_from_cost(material_cost, category, yield)
		if(audit_lines)
			audit_lines += "anvil\t[AR.name]\t[AR.created_item]\t[category]\t[cat_missing ? "MISSING" : ""]\t[material_cost]\t[derived]\t[length(local_missing) ? jointext(local_missing, ",") : ""]"
		if(derived <= 0)
			continue
		if(register_derived_price(AR.created_item, derived, category))
			new_derivations++
	for(var/datum/crafting_recipe/CR as anything in GLOB.crafting_recipes)
		if(CR.hides_from_books)
			continue
		var/result_path = pick_recipe_result(CR)
		if(!result_path)
			continue
		var/category = CR.display_category
		var/cat_missing = FALSE
		if(!category)
			category = ITEM_CAT_MISCELLANEOUS
			cat_missing = TRUE
		var/material_cost = 0
		var/list/local_missing = list()
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				var/qty = CR.reqs[path]
				if(!isnum(qty))
					qty = 1
				material_cost += recipe_material_cost_for(path, local_missing) * qty
		if(missing_materials)
			for(var/m in local_missing)
				if(!(m in missing_materials))
					missing_materials += m
		var/derived = derive_price_from_cost(material_cost, category, 1)
		if(audit_lines)
			audit_lines += "crafting\t[CR.name]\t[result_path]\t[category]\t[cat_missing ? "MISSING" : ""]\t[material_cost]\t[derived]\t[length(local_missing) ? jointext(local_missing, ",") : ""]"
		if(derived <= 0)
			continue
		if(register_derived_price(result_path, derived, category))
			new_derivations++
	return new_derivations

/proc/recipe_material_cost_for(path, list/missing_materials_log)
	if(!path)
		return 0
	var/cost = GLOB.material_baseline_prices[path]
	if(cost)
		return cost
	cost = GLOB.derived_sellprices[path]
	if(cost)
		return cost
	for(var/known_path in GLOB.material_baseline_prices)
		if(ispath(path, known_path))
			return GLOB.material_baseline_prices[known_path]
	for(var/known_path in GLOB.derived_sellprices)
		if(ispath(path, known_path))
			return GLOB.derived_sellprices[known_path]
	if(missing_materials_log && !("[path]" in missing_materials_log))
		missing_materials_log += "[path]"
	return 0

/proc/derive_price_from_cost(material_cost, category, yield)
	if(material_cost <= 0)
		return 0
	var/markup = GLOB.item_cat_markups[category] || PRICING_ENGINE_DEFAULT_MARKUP
	var/derived = (material_cost * markup) / max(1, yield)
	derived = round(derived)
	return max(PRICING_ENGINE_MIN_DERIVED_PRICE, derived)

/proc/pick_recipe_result(datum/crafting_recipe/CR)
	if(!CR.result)
		return null
	if(islist(CR.result))
		var/list/rl = CR.result
		if(length(rl))
			return rl[1]
		return null
	return CR.result

/proc/register_derived_price(path, price, category)
	if(!path)
		return FALSE
	var/existing = GLOB.derived_sellprices[path]
	if(existing && existing <= price)
		return FALSE
	GLOB.derived_sellprices[path] = price
	GLOB.derived_categories[path] = category
	return TRUE

/proc/init_pricing_engine()
	var/t_start = world.timeofday
	init_item_cat_markups()
	init_material_baseline_prices()
	var/t_baseline = world.timeofday
	var/fingerprint = pricing_engine_fingerprint()
	var/t_fingerprint = world.timeofday
	if(load_pricing_cache(fingerprint))
		var/t_loaded = world.timeofday
		log_world("Pricing engine: loaded [length(GLOB.derived_sellprices)] cached prices. [(t_baseline - t_start) * 100]ms baseline + [(t_fingerprint - t_baseline) * 100]ms fingerprint + [(t_loaded - t_fingerprint) * 100]ms cache load = [(t_loaded - t_start) * 100]ms total.")
		return
	init_derived_sellprices()
	var/t_derived = world.timeofday
	save_pricing_cache(fingerprint)
	var/t_saved = world.timeofday
	log_world("Pricing engine: full walk. [(t_baseline - t_start) * 100]ms baseline + [(t_fingerprint - t_baseline) * 100]ms fingerprint + [(t_derived - t_fingerprint) * 100]ms walk + [(t_saved - t_derived) * 100]ms cache save = [(t_saved - t_start) * 100]ms total.")

/proc/pricing_engine_fingerprint()
	var/list/parts = list()
	var/list/source_files = list(
		"code/modules/roguetown/roguestock/pricing_engine.dm",
		"code/__DEFINES/pricing_engine.dm",
		"code/__DEFINES/item_categories.dm",
		"code/__DEFINES/trade_goods.dm",
	)
	for(var/path in source_files)
		var/hash = rustg_hash_file(RUSTG_HASH_MD5, path)
		if(!hash)
			log_world("Pricing engine WARNING: source file [path] could not be hashed. Cache may be stale.")
			parts += "src:[path]=UNHASHED"
		else
			parts += "src:[path]=[hash]"
	parts += "default_markup=[PRICING_ENGINE_DEFAULT_MARKUP]"
	parts += "min_derived=[PRICING_ENGINE_MIN_DERIVED_PRICE]"
	parts += "commissioner_markup=[PRICING_ENGINE_COMMISSIONER_MARKUP]"
	for(var/cat in GLOB.item_cat_markups)
		parts += "mk:[cat]=[GLOB.item_cat_markups[cat]]"
	var/list/baseline_keys = list()
	for(var/path in GLOB.material_baseline_prices)
		baseline_keys += "[path]=[GLOB.material_baseline_prices[path]]"
	parts += "baseline:[jointext(sortList(baseline_keys), "|")]"
	var/list/trade_good_keys = list()
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(TG.item_type)
			trade_good_keys += "[TG.item_type]=[TG.base_price]"
	parts += "tradegoods:[jointext(sortList(trade_good_keys), "|")]"
	var/list/recipe_keys = list()
	for(var/datum/anvil_recipe/AR as anything in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.created_item || !AR.req_bar)
			continue
		var/extra = ""
		if(islist(AR.additional_items))
			var/list/sorted_extras = list()
			for(var/p in AR.additional_items)
				sorted_extras += "[p]"
			extra = jointext(sortList(sorted_extras), ",")
		recipe_keys += "a:[AR.created_item]|[AR.req_bar]|[extra]|[AR.createditem_num]|[AR.display_category]"
	for(var/datum/crafting_recipe/CR as anything in GLOB.crafting_recipes)
		if(CR.hides_from_books)
			continue
		var/result_path = pick_recipe_result(CR)
		if(!result_path)
			continue
		var/reqs = ""
		if(islist(CR.reqs))
			var/list/sorted_reqs = list()
			for(var/p in CR.reqs)
				sorted_reqs += "[p]=[CR.reqs[p]]"
			reqs = jointext(sortList(sorted_reqs), ",")
		recipe_keys += "c:[result_path]|[reqs]|[CR.display_category]"
	parts += "recipes:[jointext(sortList(recipe_keys), "|")]"
	return md5(jointext(parts, "\n"))

/proc/load_pricing_cache(fingerprint)
	if(!fexists("data/pricing_engine_cache.json"))
		return FALSE
	var/raw = file2text("data/pricing_engine_cache.json")
	if(!raw)
		return FALSE
	var/list/decoded = json_decode(raw)
	if(!islist(decoded))
		return FALSE
	if(decoded["hash"] != fingerprint)
		return FALSE
	var/list/cached_prices = decoded["prices"]
	var/list/cached_categories = decoded["categories"]
	if(!islist(cached_prices) || !islist(cached_categories))
		return FALSE
	GLOB.derived_sellprices = list()
	GLOB.derived_categories = list()
	for(var/path_str in cached_prices)
		var/typepath = text2path(path_str)
		if(!typepath)
			continue
		GLOB.derived_sellprices[typepath] = cached_prices[path_str]
		var/cat = cached_categories[path_str]
		if(cat)
			GLOB.derived_categories[typepath] = cat
	return TRUE

/proc/save_pricing_cache(fingerprint)
	var/list/prices_out = list()
	var/list/categories_out = list()
	for(var/typepath in GLOB.derived_sellprices)
		prices_out["[typepath]"] = GLOB.derived_sellprices[typepath]
		var/cat = GLOB.derived_categories[typepath]
		if(cat)
			categories_out["[typepath]"] = cat
	var/list/payload = list(
		"hash" = fingerprint,
		"prices" = prices_out,
		"categories" = categories_out,
	)
	fdel("data/pricing_engine_cache.json")
	text2file(json_encode(payload), "data/pricing_engine_cache.json")
