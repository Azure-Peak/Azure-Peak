GLOBAL_LIST_EMPTY(material_baseline_prices)
GLOBAL_LIST_EMPTY(derived_sellprices)
GLOBAL_LIST_EMPTY(derived_categories)
GLOBAL_LIST_EMPTY(item_cat_markups)
GLOBAL_LIST_EMPTY(bulk_trade_item_types)

/proc/init_item_cat_markups()
	GLOB.item_cat_markups = list(
		ITEM_CAT_ARMOR_HELMETS = MARKUP_ARMOR_HELMETS,
		ITEM_CAT_ARMOR_CHESTPIECES = MARKUP_ARMOR_CHESTPIECES,
		ITEM_CAT_ARMOR_LEGS = MARKUP_ARMOR_LEGS,
		ITEM_CAT_ARMOR_NECK = MARKUP_ARMOR_NECK,
		ITEM_CAT_ARMOR_BOOTS = MARKUP_ARMOR_BOOTS,
		ITEM_CAT_ARMOR_GLOVES = MARKUP_ARMOR_GLOVES,
		ITEM_CAT_ARMOR_MASKS = MARKUP_ARMOR_MASKS,
		ITEM_CAT_ARMOR_BRACERS = MARKUP_ARMOR_BRACERS,
		ITEM_CAT_ARMOR_BELTS = MARKUP_ARMOR_BELTS,
		ITEM_CAT_ARMOR_BARDING = MARKUP_ARMOR_BARDING,
		ITEM_CAT_ARMOR_LIGHT = MARKUP_ARMOR_LIGHT,
		ITEM_CAT_WEAPONS_SWORDS = MARKUP_WEAPONS_SWORDS,
		ITEM_CAT_WEAPONS_DAGGERS = MARKUP_WEAPONS_DAGGERS,
		ITEM_CAT_WEAPONS_AXES = MARKUP_WEAPONS_AXES,
		ITEM_CAT_WEAPONS_POLEARMS = MARKUP_WEAPONS_POLEARMS,
		ITEM_CAT_WEAPONS_MACES = MARKUP_WEAPONS_MACES,
		ITEM_CAT_WEAPONS_FLAILS = MARKUP_WEAPONS_FLAILS,
		ITEM_CAT_WEAPONS_SHIELDS = MARKUP_WEAPONS_SHIELDS,
		ITEM_CAT_WEAPONS_AMMO = MARKUP_WEAPONS_AMMO,
		ITEM_CAT_TOOLS_COOKWARE = MARKUP_TOOLS_COOKWARE,
		ITEM_CAT_TOOLS_FIELD = MARKUP_TOOLS_FIELD,
		ITEM_CAT_TOOLS_WORKSHOP = MARKUP_TOOLS_WORKSHOP,
		ITEM_CAT_TOOLS_SUNDRIES = MARKUP_TOOLS_SUNDRIES,
		ITEM_CAT_TOOLS_ROGUE = MARKUP_TOOLS_ROGUE,
		ITEM_CAT_VALUABLES_RINGS = MARKUP_VALUABLES_RINGS,
		ITEM_CAT_VALUABLES_HOLY = MARKUP_VALUABLES_HOLY,
		ITEM_CAT_DECORATION = MARKUP_DECORATION,
		ITEM_CAT_POTTERY = MARKUP_POTTERY,
		ITEM_CAT_COMPONENTS = MARKUP_COMPONENTS,
		ITEM_CAT_SMITHING_MISC = MARKUP_SMITHING_MISC,
		ITEM_CAT_ENG_MACHINERY = MARKUP_ENG_MACHINERY,
		ITEM_CAT_ENG_CONSTRUCTION = MARKUP_ENG_CONSTRUCTION,
		ITEM_CAT_ENG_COMBAT = MARKUP_ENG_COMBAT,
		ITEM_CAT_ENG_TRIGGERS = MARKUP_ENG_TRIGGERS,
		ITEM_CAT_ENG_MISC = MARKUP_ENG_MISC,
		ITEM_CAT_GARMENT_COMMON = MARKUP_GARMENT_COMMON,
		ITEM_CAT_GARMENT_FINE = MARKUP_GARMENT_FINE,
		ITEM_CAT_TAILOR_MISC = MARKUP_GARMENT_COMMON,
		ITEM_CAT_CLOTH_MASK = MARKUP_GARMENT_COMMON,
		ITEM_CAT_FOODSTUFF_FRESH = MARKUP_FOODSTUFF_FRESH,
		ITEM_CAT_FOODSTUFF_PRESERVED = MARKUP_FOODSTUFF_PRESERVED,
		ITEM_CAT_POTION = MARKUP_POTION,
		ITEM_CAT_BOOK_WRIT = MARKUP_BOOK_WRIT,
		ITEM_CAT_INSTRUMENT = MARKUP_INSTRUMENT,
		ITEM_CAT_TROPHY = MARKUP_TROPHY,
		ITEM_CAT_RAW_MATERIAL_MINERAL = MARKUP_RAW_MATERIAL_MINERAL,
		ITEM_CAT_RAW_MATERIAL_ORGANIC = MARKUP_RAW_MATERIAL_ORGANIC,
		ITEM_CAT_REAGENT_ALCHEMICAL = MARKUP_REAGENT_ALCHEMICAL,
		ITEM_CAT_REAGENT_ARCANE = MARKUP_REAGENT_ARCANE,
		ITEM_CAT_ARCYNE_GEARS = MARKUP_ARCYNE_GEARS,
		ITEM_CAT_SALVAGE = MARKUP_SALVAGE,
		ITEM_CAT_LIVESTOCK = MARKUP_LIVESTOCK,
		ITEM_CAT_MISCELLANEOUS = MARKUP_MISCELLANEOUS,
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
	GLOB.material_baseline_prices[/obj/item/ingot/bronze] = round(SELLPRICE_COPPER_INGOT * INGOT_BRONZE_FROM_COPPER + SELLPRICE_TIN_INGOT * INGOT_BRONZE_FROM_TIN)
	GLOB.material_baseline_prices[/obj/item/ingot/silverblessed] = round(SELLPRICE_SILVER_INGOT * INGOT_SILVERBLESSED_MULT)
	GLOB.material_baseline_prices[/obj/item/ingot/silverblessed/bullion] = round(SELLPRICE_SILVER_INGOT * INGOT_SILVERBLESSED_MULT)
	GLOB.material_baseline_prices[/obj/item/ingot/steelholy] = round(SELLPRICE_STEEL_INGOT * INGOT_STEELHOLY_MULT)
	GLOB.material_baseline_prices[/obj/item/ingot/blacksteel] = round(SELLPRICE_STEEL_INGOT * INGOT_BLACKSTEEL_FROM_STEEL + SELLPRICE_SILVER_INGOT * INGOT_BLACKSTEEL_FROM_SILVER)
	GLOB.material_baseline_prices[/obj/item/ingot/lithmyc] = round(SELLPRICE_STEEL_INGOT * INGOT_LITHMYC_MULT)
	GLOB.material_baseline_prices[/obj/item/ingot/purifiedaalloy] = round(SELLPRICE_STEEL_INGOT * INGOT_PURIFIEDAALLOY_MULT)
	GLOB.material_baseline_prices[/obj/item/ingot/aalloy] = round(SELLPRICE_IRON_INGOT * INGOT_AALLOY_MULT)
	GLOB.material_baseline_prices[/obj/item/ingot/drow] = round(SELLPRICE_STEEL_INGOT * INGOT_DROW_MULT)
	GLOB.material_baseline_prices[/obj/item/grown/log/tree/small] = SELLPRICE_WOOD
	GLOB.material_baseline_prices[/obj/item/grown/log/tree/stick] = 1
	GLOB.material_baseline_prices[/obj/item/natural/wood/plank] = round(SELLPRICE_WOOD * MATERIAL_PLANK_FROM_WOOD)
	GLOB.material_baseline_prices[/obj/item/natural/glass] = SELLPRICE_GLASS_BATCH
	GLOB.material_baseline_prices[/obj/item/roguegear] = round(SELLPRICE_STEEL_INGOT * MATERIAL_ROGUEGEAR_FROM_STEEL)
	GLOB.material_baseline_prices[/obj/item/reagent_containers/food/snacks/pepper] = 4
	GLOB.material_baseline_prices[/obj/item/reagent_containers/food/snacks/pumpkinspice] = 4
	GLOB.material_baseline_prices[/obj/item/reagent_containers/food/snacks/sugar] = 3

/proc/init_derived_sellprices(force_audits = FALSE)
	GLOB.derived_sellprices = list()
	GLOB.derived_categories = list()
	var/list/trade_good_lookup = list()
	var/list/sticky_trade_goods = list()
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(!TG.item_type)
			continue
		trade_good_lookup[TG.item_type] = TG
		if(!TG.derive_price)
			sticky_trade_goods[TG.item_type] = TG
			if(TG.base_price > 0)
				GLOB.derived_sellprices[TG.item_type] = TG.base_price
	apply_trade_good_categories()
	var/list/missing_materials = list()
	var/list/audit_lines
	var/dump_audits = force_audits
#ifdef PRICING_ENGINE_DUMP_AUDITS
	dump_audits = TRUE
#endif
	if(dump_audits)
		audit_lines = list()
		audit_lines += csv_row(list("kind", "name", "output", "category", "category_missing", "material_cost", "derived_price", "missing_reqs"))
	derived_pass(audit_lines, missing_materials, sticky_trade_goods)
	for(var/typepath in trade_good_lookup)
		var/datum/trade_good/TG = trade_good_lookup[typepath]
		if(!TG.derive_price)
			continue
		var/derived = GLOB.derived_sellprices[typepath]
		if(derived && derived > 0)
			TG.base_price = derived
			TG.low_price = round(derived * 0.6)
			TG.high_price = derived * 2
	if(dump_audits)
		fdel("pricing_engine_audit.csv")
		text2file(jointext(audit_lines, "\n"), "pricing_engine_audit.csv")
		dump_trade_good_audit(trade_good_lookup)
		dump_baseline_audit()
		dump_category_audit()
		dump_hardcode_override_audit()
		dump_uncategorized_items_audit()
		log_world("Pricing engine: derived [length(GLOB.derived_sellprices)] prices, [length(missing_materials)] unique missing materials. Audits at pricing_engine_*.csv (project root).")
	else
		log_world("Pricing engine: derived [length(GLOB.derived_sellprices)] prices, [length(missing_materials)] unique missing materials. (audit dumps disabled)")

/proc/run_pricing_audits_runtime()
	init_derived_sellprices(force_audits = TRUE)
	rebuild_crafting_recipe_display_cache()

/proc/dump_uncategorized_items_audit()
	var/list/rows = list()
	rows += csv_row(list("typepath", "name", "sellprice", "parent"))
	var/uncategorized = 0
	var/total = 0
	for(var/obj/item/path as anything in subtypesof(/obj/item))
		total++
		if(GLOB.derived_categories && GLOB.derived_categories[path])
			continue
		uncategorized++
		var/parent_str = "[type2parent(path)]"
		rows += csv_row(list("[path]", initial(path.name), initial(path.sellprice), parent_str))
	fdel("pricing_engine_uncategorized_audit.csv")
	text2file(jointext(rows, "\n"), "pricing_engine_uncategorized_audit.csv")
	log_world("Pricing engine: [uncategorized] / [total] item subtypes are uncategorized -> pricing_engine_uncategorized_audit.csv")

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
	audit_lines += csv_row(list("name", "id", "typepath", "behavior", "category", "old_base_price", "new_derived_price", "delta", "delta_pct"))
	for(var/list/row in rows)
		audit_lines += csv_row(list(row["name"], row["id"], row["typepath"], row["behavior"], row["category"], row["old"], row["new"], row["delta"], "[row["delta_pct"]]%"))
	fdel("pricing_engine_trade_audit.csv")
	text2file(jointext(audit_lines, "\n"), "pricing_engine_trade_audit.csv")

/proc/cmp_trade_audit_row_by_delta_pct(list/a, list/b)
	return abs(b["delta_pct"]) - abs(a["delta_pct"])

/proc/dump_baseline_audit()
	var/list/lines = list()
	lines += csv_row(list("section", "name", "price_or_value", "extra"))
	var/list/baseline_rows = list()
	for(var/path in GLOB.material_baseline_prices)
		baseline_rows += list(list("path" = "[path]", "price" = GLOB.material_baseline_prices[path]))
	sortTim(baseline_rows, GLOBAL_PROC_REF(cmp_baseline_row_by_price_desc))
	for(var/list/row in baseline_rows)
		lines += csv_row(list("baseline", row["path"], row["price"], ""))
	var/list/baseline_consumers = list()
	for(var/path in GLOB.material_baseline_prices)
		baseline_consumers["[path]"] = list()
	for(var/datum/anvil_recipe/AR as anything in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.created_item || !AR.req_bar)
			continue
		var/derived = GLOB.derived_sellprices[AR.created_item]
		if(!derived)
			continue
		var/key = "[AR.req_bar]"
		if(key in baseline_consumers)
			baseline_consumers[key] += list(list("name" = AR.name, "out" = "[AR.created_item]", "price" = derived))
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				var/k2 = "[path]"
				if(k2 in baseline_consumers)
					baseline_consumers[k2] += list(list("name" = AR.name, "out" = "[AR.created_item]", "price" = derived))
	for(var/datum/crafting_recipe/CR as anything in GLOB.crafting_recipes)
		if(CR.hides_from_books)
			continue
		var/result_path = pick_recipe_result(CR)
		if(!result_path)
			continue
		var/derived = GLOB.derived_sellprices[result_path]
		if(!derived)
			continue
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				var/key = "[path]"
				if(key in baseline_consumers)
					baseline_consumers[key] += list(list("name" = CR.name, "out" = "[result_path]", "price" = derived))
	for(var/list/row in baseline_rows)
		var/path_str = row["path"]
		var/list/consumers = baseline_consumers[path_str]
		if(!length(consumers))
			continue
		sortTim(consumers, GLOBAL_PROC_REF(cmp_consumer_row_by_price_desc))
		var/shown = 0
		for(var/list/c in consumers)
			lines += csv_row(list("consumer_of:[path_str]", c["name"], c["price"], c["out"]))
			shown++
			if(shown >= 10)
				break
	var/list/ingot_paths = list(
		"copper" = /obj/item/ingot/copper,
		"tin" = /obj/item/ingot/tin,
		"bronze" = /obj/item/ingot/bronze,
		"iron" = /obj/item/ingot/iron,
		"steel" = /obj/item/ingot/steel,
		"blacksteel" = /obj/item/ingot/blacksteel,
		"steelholy" = /obj/item/ingot/steelholy,
		"silver" = /obj/item/ingot/silver,
		"silverblessed" = /obj/item/ingot/silverblessed,
		"gold" = /obj/item/ingot/gold,
		"lithmyc" = /obj/item/ingot/lithmyc,
		"purifiedaalloy" = /obj/item/ingot/purifiedaalloy,
		"aalloy" = /obj/item/ingot/aalloy,
	)
	for(var/name in ingot_paths)
		var/p = ingot_paths[name]
		lines += csv_row(list("ingot_tier", name, GLOB.material_baseline_prices[p] || 0, ""))
	var/list/ore_ingot_pairs = list(
		"iron" = list("ore" = /obj/item/rogueore/iron, "ingot" = /obj/item/ingot/iron),
		"copper" = list("ore" = /obj/item/rogueore/copper, "ingot" = /obj/item/ingot/copper),
		"tin" = list("ore" = /obj/item/rogueore/tin, "ingot" = /obj/item/ingot/tin),
		"gold" = list("ore" = /obj/item/rogueore/gold, "ingot" = /obj/item/ingot/gold),
		"silver" = list("ore" = /obj/item/rogueore/silver, "ingot" = /obj/item/ingot/silver),
	)
	for(var/name in ore_ingot_pairs)
		var/list/pair = ore_ingot_pairs[name]
		var/ore_price = GLOB.material_baseline_prices[pair["ore"]] || 0
		var/ingot_price = GLOB.material_baseline_prices[pair["ingot"]] || 0
		var/ratio_str = ore_price > 0 ? "[ingot_price / ore_price]x" : "n/a"
		lines += csv_row(list("smelt_ratio", name, "[ore_price]ore_[ingot_price]ingot", ratio_str))
	fdel("pricing_engine_baseline_audit.csv")
	text2file(jointext(lines, "\n"), "pricing_engine_baseline_audit.csv")

/proc/cmp_baseline_row_by_price_desc(list/a, list/b)
	return b["price"] - a["price"]

/proc/cmp_consumer_row_by_price_desc(list/a, list/b)
	return b["price"] - a["price"]

/proc/dump_hardcode_override_audit()
	var/list/rows = list()
	for(var/typepath in GLOB.derived_sellprices)
		var/obj/item/I = typepath
		if(!ispath(typepath, /obj/item))
			continue
		var/hardcoded = initial(I.sellprice)
		if(!hardcoded || hardcoded <= 0)
			continue
		var/derived = GLOB.derived_sellprices[typepath]
		if(!derived || derived <= 0)
			continue
		if(hardcoded == derived)
			continue
		var/delta = derived - hardcoded
		var/delta_pct = hardcoded > 0 ? round((delta / hardcoded) * 100) : 9999
		rows += list(list("path" = "[typepath]", "name" = initial(I.name), "hardcoded" = hardcoded, "derived" = derived, "delta" = delta, "delta_pct" = delta_pct))
	sortTim(rows, GLOBAL_PROC_REF(cmp_override_row_by_delta_pct))
	var/list/lines = list()
	lines += csv_row(list("typepath", "name", "hardcoded_sellprice", "engine_derived_price", "delta", "delta_pct"))
	for(var/list/row in rows)
		lines += csv_row(list(row["path"], row["name"], row["hardcoded"], row["derived"], row["delta"], "[row["delta_pct"]]%"))
	fdel("pricing_engine_hardcode_overrides.csv")
	text2file(jointext(lines, "\n"), "pricing_engine_hardcode_overrides.csv")

/proc/cmp_override_row_by_delta_pct(list/a, list/b)
	return abs(b["delta_pct"]) - abs(a["delta_pct"])

/proc/dump_category_audit()
	var/list/by_category = list()
	for(var/typepath in GLOB.derived_sellprices)
		var/cat = GLOB.derived_categories[typepath] || "(uncategorized)"
		if(!by_category[cat])
			by_category[cat] = list()
		by_category[cat] += list(list("path" = "[typepath]", "price" = GLOB.derived_sellprices[typepath]))
	var/list/cat_names = list()
	for(var/cat in by_category)
		cat_names += cat
	sortList(cat_names)
	var/list/lines = list()
	lines += csv_row(list("category", "typepath", "price", "looted_price"))
	for(var/cat in cat_names)
		var/list/rows = by_category[cat]
		sortTim(rows, GLOBAL_PROC_REF(cmp_consumer_row_by_price_desc))
		for(var/list/row in rows)
			var/looted_price = max(1, round(row["price"] * LOOTED_SELL_MULT))
			lines += csv_row(list(cat, row["path"], row["price"], looted_price))
	fdel("pricing_engine_category_audit.csv")
	text2file(jointext(lines, "\n"), "pricing_engine_category_audit.csv")

/proc/derived_pass(list/audit_lines, list/missing_materials, list/trade_good_lookup)
	var/new_derivations = 0
	for(var/datum/anvil_recipe/AR as anything in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.created_item || !AR.req_bar)
			continue
		if(trade_good_lookup && trade_good_lookup[AR.created_item])
			continue
		var/category = AR.display_category
		var/cat_missing = FALSE
		if(!category)
			category = ITEM_CAT_SMITHING_MISC
			cat_missing = TRUE
		var/list/local_missing = list()
		var/list/breakdown = list()
		var/material_cost = build_input_breakdown(AR.req_bar, 1, local_missing, breakdown)
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				material_cost += build_input_breakdown(path, 1, local_missing, breakdown)
		if(missing_materials)
			for(var/m in local_missing)
				if(!(m in missing_materials))
					missing_materials += m
		var/yield = max(1, AR.createditem_num)
		var/derived = derive_price_from_cost(material_cost, category, yield)
		var/markup = GLOB.item_cat_markups[category] || PRICING_ENGINE_DEFAULT_MARKUP
		if(audit_lines)
			audit_lines += csv_row(list("anvil", AR.name, "[AR.created_item]", category, cat_missing ? "MISSING" : "", "[material_cost]", "[markup]", "[yield]", "[derived]", jointext(breakdown, " + "), jointext(local_missing, ",")))
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
		if(trade_good_lookup && trade_good_lookup[result_path])
			continue
		var/category = CR.display_category
		var/cat_missing = FALSE
		if(!category)
			category = ITEM_CAT_MISCELLANEOUS
			cat_missing = TRUE
		var/material_cost = 0
		var/list/local_missing = list()
		var/list/breakdown = list()
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				var/qty = CR.reqs[path]
				if(!isnum(qty))
					qty = 1
				material_cost += build_input_breakdown(path, qty, local_missing, breakdown)
		if(missing_materials)
			for(var/m in local_missing)
				if(!(m in missing_materials))
					missing_materials += m
		var/recipe_yield = recipe_result_yield(CR, result_path)
		var/derived = derive_price_from_cost(material_cost, category, recipe_yield)
		var/markup = GLOB.item_cat_markups[category] || PRICING_ENGINE_DEFAULT_MARKUP
		if(audit_lines)
			audit_lines += csv_row(list("crafting", CR.name, "[result_path]", category, cat_missing ? "MISSING" : "", "[material_cost]", "[markup]", "[recipe_yield]", "[derived]", jointext(breakdown, " + "), jointext(local_missing, ",")))
		if(derived <= 0)
			continue
		if(register_derived_price(result_path, derived, category))
			new_derivations++
		if(ispath(result_path, /obj/item/natural/clay))
			var/obj/item/natural/clay/raw_proto = result_path
			var/cooked_path = initial(raw_proto.cooked_type)
			if(cooked_path && register_derived_price(cooked_path, derived, category))
				new_derivations++
	new_derivations += food_recipe_derive_pass(audit_lines, missing_materials, trade_good_lookup)
	return new_derivations

/proc/food_recipe_derive_pass(list/audit_lines, list/missing_materials, list/trade_good_lookup)
	var/total_new = 0
	var/list/recipe_paths = subtypesof(/datum/food_recipe)
	for(var/iteration in 1 to PRICING_ENGINE_FOOD_RECIPE_MAX_PASSES)
		var/this_pass = 0
		for(var/datum/food_recipe/recipe_path as anything in recipe_paths)
			var/base = initial(recipe_path.base_item)
			var/result_path = initial(recipe_path.result_type)
			if(!base || !result_path)
				continue
			if(trade_good_lookup && trade_good_lookup[result_path])
				continue
			if(GLOB.derived_sellprices[result_path])
				continue
			var/category = initial(recipe_path.display_category) || ITEM_CAT_FOODSTUFF_FRESH
			var/list/local_missing = list()
			var/list/breakdown = list()
			var/material_cost = build_input_breakdown(base, 1, local_missing, breakdown)
			var/list/ingredient_list = initial(recipe_path.ingredients)
			if(islist(ingredient_list))
				for(var/path in ingredient_list)
					if(ispath(path, /datum/reagent))
						continue
					material_cost += build_input_breakdown(path, 1, local_missing, breakdown)
			if(missing_materials)
				for(var/m in local_missing)
					if(!(m in missing_materials))
						missing_materials += m
			var/derived = derive_price_from_cost(material_cost, category, 1)
			var/markup = GLOB.item_cat_markups[category] || PRICING_ENGINE_DEFAULT_MARKUP
			if(audit_lines)
				audit_lines += csv_row(list("food[iteration]", initial(recipe_path.name), "[result_path]", category, "", "[material_cost]", "[markup]", "1", "[derived]", jointext(breakdown, " + "), jointext(local_missing, ",")))
			if(derived <= 0)
				continue
			if(register_derived_price(result_path, derived, category))
				this_pass++
				if(ispath(result_path, /obj/item/reagent_containers/food/snacks))
					var/obj/item/reagent_containers/food/snacks/result_proto = result_path
					var/cooked_path = initial(result_proto.cooked_type)
					if(cooked_path && register_derived_price(cooked_path, derived, category))
						this_pass++
		total_new += this_pass
		if(!this_pass)
			break
	return total_new

/proc/build_input_breakdown(path, qty, list/missing_materials_log, list/breakdown)
	var/unit_cost = recipe_material_cost_for(path, missing_materials_log)
	var/atom/A = path
	var/short_name = initial(A.name) || "[path]"
	if(unit_cost <= 0)
		breakdown += "[short_name]×[qty] (UNPRICED)"
		return 0
	var/total = unit_cost * qty
	breakdown += "[short_name]×[qty] @[unit_cost]m = [total]m"
	return total

/proc/csv_row(list/cells)
	var/list/escaped = list()
	for(var/cell in cells)
		var/s = "[cell]"
		if(findtext(s, ",") || findtext(s, "\"") || findtext(s, "\n"))
			s = replacetext(s, "\"", "\"\"")
			s = "\"[s]\""
		escaped += s
	return jointext(escaped, ",")

/proc/recipe_material_cost_for(path, list/missing_materials_log)
	if(!path)
		return 0
	var/cost = GLOB.material_baseline_prices[path]
	if(cost)
		return cost
	for(var/known_path in GLOB.material_baseline_prices)
		if(ispath(path, known_path))
			return GLOB.material_baseline_prices[known_path]
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

/proc/recipe_result_yield(datum/crafting_recipe/CR, result_path)
	if(!islist(CR.result))
		return 1
	var/list/rl = CR.result
	var/count = 0
	for(var/path in rl)
		if(path == result_path)
			count++
	return max(1, count)

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
		apply_trade_good_categories()
		rebuild_crafting_recipe_display_cache()
		log_world("Pricing engine: loaded [length(GLOB.derived_sellprices)] cached prices. [(t_baseline - t_start) * 100]ms baseline + [(t_fingerprint - t_baseline) * 100]ms fingerprint + [(t_loaded - t_fingerprint) * 100]ms cache load = [(t_loaded - t_start) * 100]ms total.")
		return
	init_derived_sellprices()
	var/t_derived = world.timeofday
	save_pricing_cache(fingerprint)
	rebuild_crafting_recipe_display_cache()
	var/t_saved = world.timeofday
	log_world("Pricing engine: full walk. [(t_baseline - t_start) * 100]ms baseline + [(t_fingerprint - t_baseline) * 100]ms fingerprint + [(t_derived - t_fingerprint) * 100]ms walk + [(t_saved - t_derived) * 100]ms cache save = [(t_saved - t_start) * 100]ms total.")

/proc/rebuild_crafting_recipe_display_cache()
	for(var/datum/crafting_recipe/R as anything in GLOB.crafting_recipes)
		R.build_display_cache()

/proc/apply_trade_good_categories()
	GLOB.bulk_trade_item_types = list()
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(!TG.item_type)
			continue
		if(TG.behavior == TRADE_BEHAVIOR_RAW || TG.behavior == TRADE_BEHAVIOR_INTERMEDIARY)
			for(var/subtype in typesof(TG.item_type))
				GLOB.bulk_trade_item_types[subtype] = TG.id
		if(!TG.display_category)
			continue
		for(var/subtype in typesof(TG.item_type))
			GLOB.derived_categories[subtype] = TG.display_category
	for(var/path in subtypesof(/datum/trade_good))
		var/datum/trade_good/proto = path
		var/proto_id = initial(proto.id)
		var/proto_cat = initial(proto.display_category)
		var/proto_type = initial(proto.item_type)
		if(proto_id || !proto_cat || !proto_type)
			continue
		for(var/subtype in typesof(proto_type))
			if(!GLOB.derived_categories[subtype])
				GLOB.derived_categories[subtype] = proto_cat

/proc/pricing_engine_fingerprint()
	var/list/parts = list()
	var/list/source_files = list(
		"code/modules/roguetown/roguestock/pricing_engine.dm",
		"code/__DEFINES/pricing_defines.dm",
		"code/__DEFINES/item_categories.dm",
		"code/__DEFINES/trade_goods.dm",
		"code/controllers/subsystem/rogue/cooking/cooking_recipes.dm",
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
		recipe_keys += "c:[result_path]|[reqs]|[CR.display_category]|y[recipe_result_yield(CR, result_path)]"
	for(var/datum/food_recipe/FR as anything in subtypesof(/datum/food_recipe))
		var/base = initial(FR.base_item)
		var/result_path = initial(FR.result_type)
		if(!base || !result_path)
			continue
		var/ingr = ""
		var/list/ingredient_list = initial(FR.ingredients)
		if(islist(ingredient_list))
			var/list/sorted_ingr = list()
			for(var/p in ingredient_list)
				sorted_ingr += "[p]"
			ingr = jointext(sortList(sorted_ingr), ",")
		recipe_keys += "f:[result_path]|[base]|[ingr]|[initial(FR.display_category)]"
	parts += "recipes:[jointext(sortList(recipe_keys), "|")]"
	var/list/sellprice_keys = list()
	for(var/datum/anvil_recipe/AR as anything in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.created_item)
			continue
		var/obj/item/I = AR.created_item
		sellprice_keys += "[AR.created_item]=[initial(I.sellprice)]"
	for(var/datum/crafting_recipe/CR as anything in GLOB.crafting_recipes)
		if(CR.hides_from_books)
			continue
		var/result_path = pick_recipe_result(CR)
		if(!result_path)
			continue
		var/obj/item/I2 = result_path
		sellprice_keys += "[result_path]=[initial(I2.sellprice)]"
	parts += "itemprices:[jointext(sortList(sellprice_keys), "|")]"
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
