GLOBAL_LIST_INIT(drink_with_qualities, init_drinks_with_qualities())
GLOBAL_LIST_INIT(food_with_faretypes, init_food_with_faretypes())

GLOBAL_LIST_EMPTY(cached_food_flat_icons)
GLOBAL_LIST_EMPTY(cached_drink_flat_icons)

/proc/init_drinks_with_qualities()
	var/list/blacklisted_drinks = list(
		/datum/reagent/consumable,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/nutriment,
		/datum/reagent/consumable/eggyolk,
		/datum/reagent/consumable/sodiumchloride,
		/datum/reagent/consumable/nutriment/vitamin,
		/datum/reagent/consumable/honey,
		/datum/reagent/consumable/caffeine,
		/datum/reagent/consumable/blackpepper,
		/datum/reagent/consumable/sugar,
		/datum/reagent/consumable/sugar/molasses,
		/datum/reagent/consumable/oil,
		/datum/reagent/consumable/oil/tallow,
		/datum/reagent/consumable/milk,
		/datum/reagent/consumable/milk/salted,
		/datum/reagent/consumable/pumpkinspice,
	)

	var/list/drink_types = subtypesof(/datum/reagent/consumable)\
		- typesof(/datum/reagent/consumable/soup)\
		- blacklisted_drinks

	var/list/filtered_drink_types = list()
	var/list/name_to_type = list()

	for(var/drink_type in drink_types)
		var/datum/reagent/consumable/drink_instance = drink_type
		var/drink_name = initial(drink_instance.name)

		if(!name_to_type[drink_name])
			name_to_type[drink_name] = drink_type
			filtered_drink_types += drink_type
		else
			var/existing_type = name_to_type[drink_name]
			if(ispath(existing_type, drink_type))
				name_to_type[drink_name] = drink_type
				filtered_drink_types -= existing_type
				filtered_drink_types += drink_type

	var/list/drink_with_qualities = list()
	for(var/drink_type in filtered_drink_types)
		var/datum/reagent/consumable/drink_instance = drink_type
		var/drink_quality = initial(drink_instance.quality)
		var/drink_name = initial(drink_instance.name)
		drink_with_qualities += list(list("type" = drink_type, "quality" = drink_quality, "name" = drink_name))

	drink_with_qualities = sortTim(drink_with_qualities, /proc/cmp_drink_by_quality_and_name)
	return drink_with_qualities

/proc/init_food_with_faretypes()
	var/list/blacklisted_food = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/reagent_containers/food/snacks/grown/oat,
		/obj/item/reagent_containers/food/snacks/grown/rice,
		/obj/item/reagent_containers/food/snacks/grown/vegetable,
		/obj/item/reagent_containers/food/snacks/grown/fruit,
		/obj/item/reagent_containers/food/snacks/rogue,
		/obj/item/reagent_containers/food/snacks/rogue/eggplantmeat,
		/obj/item/reagent_containers/food/snacks/rogue/pie,
		/obj/item/reagent_containers/food/snacks/rogue/meat,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince,
		/obj/item/reagent_containers/food/snacks/rogue/dough_base,
		/obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked,
		/obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked,
		/obj/item/reagent_containers/food/snacks/rogue/cookie,
		/obj/item/reagent_containers/food/snacks/rogue/rbread_half,
		/obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw,
		/obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw,
		/obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw,
		/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw,
		/obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked,
		/obj/item/reagent_containers/food/snacks/rogue/stuffeggraw,
		/obj/item/reagent_containers/food/snacks/rogue/stuffeggraw,
		/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw,
		/obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw,
		/obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fatty,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage,
		/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf,
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
		/obj/item/reagent_containers/food/snacks/rogue/ricewet,
		/obj/item/reagent_containers/food/snacks/rogue/meat/spider,
		/obj/item/reagent_containers/food/snacks/rogue/dough,
		/obj/item/reagent_containers/food/snacks/rogue/cake_base,
		/obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked,
		/obj/item/reagent_containers/food/snacks/rogue/preserved,
		/obj/item/reagent_containers/food/snacks/rogue/fruit,
		/obj/item/reagent_containers/food/snacks/rogue/veg,
		/obj/item/reagent_containers/food/snacks/rogue/sandwich,
		/obj/item/reagent_containers/food/snacks/store,
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/reagent_containers/food/snacks/clothing,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison,
		/obj/item/reagent_containers/food/snacks/eoran_aril,
		/obj/item/reagent_containers/food/snacks/organ,,
		/obj/item/reagent_containers/food/snacks/grown/sugarcane,
		/obj/item/reagent_containers/food/snacks/grown/sunflower,
		/obj/item/reagent_containers/food/snacks/grown/rogue,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry,
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius,
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied,
		/obj/item/reagent_containers/food/snacks/grown/rogue/poppy,
		/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry,
		/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground,
		/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals,
		/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/reagent_containers/food/snacks/smallrat,
		/obj/item/reagent_containers/food/snacks/grown/tea,
		/obj/item/reagent_containers/food/snacks/crow,
		/obj/item/reagent_containers/food/snacks/tallow,
		/obj/item/reagent_containers/food/snacks/tallow/red,
		/obj/item/reagent_containers/food/snacks/veg,
		/obj/item/reagent_containers/food/snacks/butter,
		/obj/item/reagent_containers/food/snacks/deadmouse,
		/obj/item/reagent_containers/food/snacks/sugar,
		/obj/item/reagent_containers/food/snacks/grown/berries,
		/obj/item/reagent_containers/food/snacks/grown/onion,
		/obj/item/reagent_containers/food/snacks/grown/cabbage,
		/obj/item/reagent_containers/food/snacks/grown/potato,
		/obj/item/reagent_containers/food/snacks/grown/garlick,
		/obj/item/reagent_containers/food/snacks/fat,
	)

	var/list/slice_paths = list()
	for(var/food_type in subtypesof(/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/F = food_type
		var/slice_path = initial(F.slice_path)
		if(slice_path)
			slice_paths |= slice_path

	var/list/food_types = subtypesof(/obj/item/reagent_containers/food/snacks)\
		- typesof(/obj/item/reagent_containers/food/snacks/rogue/foodbase)\
		- typesof(/obj/item/reagent_containers/food/snacks/fish)\
		- subtypesof(/obj/item/reagent_containers/food/snacks/rogue/honey/spider)\
		- typesof(/obj/item/reagent_containers/food/snacks/eoran_aril)\
		- typesof(/obj/item/reagent_containers/food/snacks/organ)\
		- typesof(/obj/item/reagent_containers/food/snacks/crow/dead)\
		- typesof(/obj/item/reagent_containers/food/snacks/smallrat)\
		- blacklisted_food\
		- slice_paths

	var/list/filtered_food_types = list()
	var/list/name_to_type = list()

	for(var/food_type in food_types)
		var/obj/item/reagent_containers/food/snacks/food_instance = food_type
		var/food_name = initial(food_instance.name)

		if(!name_to_type[food_name])
			name_to_type[food_name] = food_type
			filtered_food_types += food_type
		else
			var/existing_type = name_to_type[food_name]
			if(ispath(existing_type, food_type))
				name_to_type[food_name] = food_type
				filtered_food_types -= existing_type
				filtered_food_types += food_type

	var/list/food_with_faretypes = list()
	for(var/food_type in filtered_food_types)
		var/obj/item/reagent_containers/food/snacks/food_instance = food_type
		var/food_faretype = initial(food_instance.faretype)
		var/food_name = initial(food_instance.name)
		food_with_faretypes += list(list("type" = food_type, "faretype" = food_faretype, "name" = food_name))

	food_with_faretypes = sortTim(food_with_faretypes, /proc/cmp_food_by_faretype_and_name)
	return food_with_faretypes

/proc/cmp_food_by_faretype_and_name(list/a, list/b)
	var/faretype_a = a["faretype"]
	var/faretype_b = b["faretype"]

	if(faretype_a != faretype_b)
		return faretype_a - faretype_b

	var/name_a = a["name"]
	var/name_b = b["name"]
	return sorttext(name_a, name_b)

/proc/cmp_drink_by_quality_and_name(list/a, list/b)
	var/quality_a = a["quality"]
	var/quality_b = b["quality"]

	if(quality_a != quality_b)
		return quality_a - quality_b

	var/name_a = a["name"]
	var/name_b = b["name"]
	return sorttext(name_a, name_b)
