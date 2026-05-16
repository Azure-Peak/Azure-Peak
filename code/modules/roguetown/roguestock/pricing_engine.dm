GLOBAL_LIST_EMPTY(material_baseline_prices)
GLOBAL_LIST_EMPTY(derived_sellprices)
GLOBAL_LIST_EMPTY(derived_categories)
GLOBAL_LIST_EMPTY(item_cat_markups)

/proc/init_item_cat_markups()
	GLOB.item_cat_markups = list(
		ITEM_CAT_ARMOR_HELMETS = 1.4,
		ITEM_CAT_ARMOR_CHESTPIECES = 1.4,
		ITEM_CAT_ARMOR_LEGS = 1.4,
		ITEM_CAT_ARMOR_NECK = 1.4,
		ITEM_CAT_ARMOR_BOOTS = 1.4,
		ITEM_CAT_ARMOR_GLOVES = 1.4,
		ITEM_CAT_ARMOR_MASKS = 1.4,
		ITEM_CAT_ARMOR_BRACERS = 1.4,
		ITEM_CAT_ARMOR_BELTS = 1.4,
		ITEM_CAT_ARMOR_BARDING = 1.4,
		ITEM_CAT_WEAPONS_SWORDS = 1.4,
		ITEM_CAT_WEAPONS_DAGGERS = 1.4,
		ITEM_CAT_WEAPONS_AXES = 1.4,
		ITEM_CAT_WEAPONS_POLEARMS = 1.4,
		ITEM_CAT_WEAPONS_MACES = 1.4,
		ITEM_CAT_WEAPONS_FLAILS = 1.4,
		ITEM_CAT_WEAPONS_SHIELDS = 1.4,
		ITEM_CAT_WEAPONS_AMMO = 1.2,
		ITEM_CAT_TOOLS_COOKWARE = 1.3,
		ITEM_CAT_TOOLS_FIELD = 1.3,
		ITEM_CAT_TOOLS_WORKSHOP = 1.3,
		ITEM_CAT_TOOLS_SUNDRIES = 1.2,
		ITEM_CAT_TOOLS_ROGUE = 1.5,
		ITEM_CAT_VALUABLES_RINGS = 2.5,
		ITEM_CAT_VALUABLES_HOLY = 2.5,
		ITEM_CAT_DECORATION = 2.0,
		ITEM_CAT_POTTERY = 1.5,
		ITEM_CAT_COMPONENTS = 1.1,
		ITEM_CAT_SMITHING_MISC = 1.2,
		ITEM_CAT_ENG_MACHINERY = 1.5,
		ITEM_CAT_ENG_CONSTRUCTION = 1.2,
		ITEM_CAT_ENG_COMBAT = 1.5,
		ITEM_CAT_ENG_TRIGGERS = 1.5,
		ITEM_CAT_ENG_MISC = 1.2,
		ITEM_CAT_GARMENT_COMMON = 1.5,
		ITEM_CAT_GARMENT_FINE = 2.2,
		ITEM_CAT_GARMENT_LUXURY = 3.0,
		ITEM_CAT_FOODSTUFF_FRESH = 1.3,
		ITEM_CAT_FOODSTUFF_PRESERVED = 1.6,
		ITEM_CAT_POTION = 1.8,
		ITEM_CAT_BEVERAGE = 1.6,
		ITEM_CAT_BOOK_WRIT = 2.0,
		ITEM_CAT_INSTRUMENT = 2.5,
		ITEM_CAT_TROPHY = 2.0,
		ITEM_CAT_SALVAGE = 1.2,
		ITEM_CAT_LIVESTOCK = 1.5,
		ITEM_CAT_RAW_MATERIAL_MINERAL = 1.0,
		ITEM_CAT_RAW_MATERIAL_ORGANIC = 1.0,
		ITEM_CAT_REAGENT_ALCHEMICAL = 1.4,
		ITEM_CAT_REAGENT_ARCANE = 2.0,
		ITEM_CAT_MISCELLANEOUS = 1.2,
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
	var/list/trade_good_typepaths = list()
	for(var/id in GLOB.trade_goods)
		var/datum/trade_good/TG = GLOB.trade_goods[id]
		if(TG.item_type)
			trade_good_typepaths[TG.item_type] = TG.base_price
	var/missing_materials = list()
	var/missing_categories = 0
	var/derived_count = 0
	for(var/datum/anvil_recipe/AR as anything in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.created_item || !AR.req_bar)
			continue
		if(AR.created_item in trade_good_typepaths)
			continue
		var/category = AR.display_category
		if(!category)
			missing_categories++
			category = ITEM_CAT_SMITHING_MISC
		var/material_cost = recipe_material_cost_for(AR.req_bar, missing_materials)
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				material_cost += recipe_material_cost_for(path, missing_materials)
		var/yield = max(1, AR.createditem_num)
		var/derived = derive_price_from_cost(material_cost, category, yield)
		if(derived <= 0)
			continue
		register_derived_price(AR.created_item, derived, category)
		derived_count++
	for(var/datum/crafting_recipe/CR as anything in GLOB.crafting_recipes)
		if(CR.hides_from_books)
			continue
		var/result_path = pick_recipe_result(CR)
		if(!result_path)
			continue
		if(result_path in trade_good_typepaths)
			continue
		var/category = CR.display_category
		if(!category)
			missing_categories++
			category = ITEM_CAT_MISCELLANEOUS
		var/material_cost = 0
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				var/qty = CR.reqs[path]
				if(!isnum(qty))
					qty = 1
				material_cost += recipe_material_cost_for(path, missing_materials) * qty
		var/derived = derive_price_from_cost(material_cost, category, 1)
		if(derived <= 0)
			continue
		register_derived_price(result_path, derived, category)
		derived_count++
	log_world("Pricing engine: derived [derived_count] prices, [length(missing_materials)] unique missing materials, [missing_categories] recipes missing display_category.")
	if(length(missing_materials))
		log_world("Pricing engine missing materials: [english_list(missing_materials)]")

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

/proc/register_derived_price(path, price, category)
	if(!path)
		return
	var/existing = GLOB.derived_sellprices[path]
	if(existing && existing <= price)
		return
	GLOB.derived_sellprices[path] = price
	GLOB.derived_categories[path] = category

/proc/init_pricing_engine()
	init_item_cat_markups()
	init_material_baseline_prices()
	init_derived_sellprices()
