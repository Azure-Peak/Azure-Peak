#define AUTO_SINGLE_EXEMPT_CATEGORIES list(FOOD_CAT_BASICS, FOOD_CAT_DOUGHS)

SUBSYSTEM_DEF(cooking)
	name = "Cooking Controller"
	flags = SS_NO_FIRE
	var/list/recipe_index = list() // Key: base_item path | Value: list of recipe datums
	var/list/auto_singles = list()
	var/list/auto_single_lookup = list()
	var/list/dish_sources = list()
	var/list/producer_category = list()
	var/list/crafting_producers = list()

/datum/controller/subsystem/cooking/Initialize()
	init_recipes()
	init_auto_singles()
	init_crafting_producers()
	return ..()

/datum/controller/subsystem/cooking/proc/init_crafting_producers()
	for(var/recipe_type in subtypesof(/datum/crafting_recipe/roguetown/cooking))
		if(is_abstract(recipe_type))
			continue
		if(should_hide_recipe(recipe_type))
			continue
		var/result = initial(recipe_type:result)
		if(!result || crafting_producers["[result]"])
			continue
		crafting_producers["[result]"] = "[recipe_type]"

/// Wiki key/path of a non-hidden recipe (food or drying) that produces item_type, for "Start with" links. Null if none.
/datum/controller/subsystem/cooking/proc/get_producer_key(item_type)
	var/datum/food_recipe/pre = get_producing_recipe(item_type)
	if(pre && !pre.hidden)
		return pre.get_wiki_key()
	return crafting_producers["[item_type]"]

/datum/controller/subsystem/cooking/proc/init_recipes()
	for(var/R in typesof(/datum/food_recipe) - /datum/food_recipe)
		var/datum/food_recipe/recipe = new R()
		if(!recipe.base_item)
			continue
		for(var/base in (islist(recipe.base_item) ? recipe.base_item : list(recipe.base_item)))
			if(!recipe_index[base])
				recipe_index[base] = list()
			recipe_index[base] += recipe

/datum/controller/subsystem/cooking/proc/init_auto_singles()
	var/list/covered = list()
	for(var/base_type in recipe_index)
		for(var/datum/food_recipe/R in recipe_index[base_type])
			covered["[base_type]>[R.result_type]"] = TRUE
			producer_category["[R.result_type]"] = R.book_category
			if(!(R.book_category in AUTO_SINGLE_EXEMPT_CATEGORIES))
				dish_sources["[R.result_type]"] = TRUE
	for(var/snack_type in subtypesof(/obj/item/reagent_containers/food/snacks))
		if(is_abstract(snack_type))
			continue
		if(dish_sources["[snack_type]"])
			continue
		for(var/list/T in get_auto_transforms(snack_type))
			add_auto_single(snack_type, T["result"], T["method"], T["generic"], T["category"], covered, T["amount"], T["extra"])
	
/datum/controller/subsystem/cooking/proc/get_auto_transforms(snack_type)
	var/list/out = list()
	var/obj/item/reagent_containers/food/snacks/proto = snack_type
	var/parent_type = type2parent(snack_type)
	var/obj/item/reagent_containers/food/snacks/parent_proto = ispath(parent_type, /obj/item/reagent_containers/food/snacks) ? parent_type : null
	var/baked = initial(proto.cooked_type)
	var/fried = initial(proto.fried_type)
	var/deep = initial(proto.deep_fried_type)
	var/sliced = initial(proto.slice_path)
	var/boiled = initial(proto.boiled_type)
	if(baked == snack_type)
		baked = null
	if(fried == snack_type)
		fried = null
	if(deep == snack_type)
		deep = null
	if(boiled == snack_type)
		boiled = null
	if(sliced == snack_type)
		sliced = null
	if(parent_proto)
		if(baked && initial(parent_proto.cooked_type) == baked)
			baked = null
		if(fried && initial(parent_proto.fried_type) == fried)
			fried = null
		if(deep && initial(parent_proto.deep_fried_type) == deep)
			deep = null
		if(boiled && initial(parent_proto.boiled_type) == boiled)
			boiled = null
		if(sliced && initial(parent_proto.slice_path) == sliced)
			sliced = null
	if(baked && baked == fried)
		out += list(list("result" = baked, "generic" = TRUE, "category" = FOOD_CAT_GENERIC))
	else
		if(baked)
			out += list(list("result" = baked, "method" = COOK_BAKE, "category" = FOOD_CAT_OVEN))
		if(fried)
			out += list(list("result" = fried, "method" = COOK_FRY, "category" = FOOD_CAT_PAN))
	if(deep)
		out += list(list("result" = deep, "method" = COOK_DEEPFRY, "category" = FOOD_CAT_DEEPFRIED))
	if(boiled)
		out += list(list("result" = boiled, "method" = COOK_BOIL, "category" = FOOD_CAT_BOILED))
	if(sliced)
		var/slice_cat = (producer_category["[snack_type]"] == FOOD_CAT_DOUGHS) ? FOOD_CAT_DOUGHS : FOOD_CAT_BASICS
		out += list(list("result" = sliced, "category" = slice_cat, "amount" = max(1, initial(proto.slices_num)), "extra" = "Slice it on a table with a knife (CUT or CHOP intent)"))
	return out

/datum/controller/subsystem/cooking/proc/add_auto_single(source, result, method, generic, category, list/covered, amount, extra_step)
	if(covered["[source]>[result]"])
		return
	covered["[source]>[result]"] = TRUE
	var/datum/food_recipe/single_cook/R = new
	var/atom/res = result
	R.name = lowertext(initial(res.name))
	R.base_item = source
	R.result_type = result
	R.result_amount = amount || 1
	if(generic)
		R.needs_cooking = TRUE
	else if(method)
		R.cook_method = method
	if(extra_step)
		R.extra_steps = list(extra_step)
	R.book_category = category
	R.wiki_key = "autosingle|[source]|[result]"
	auto_singles += R
	auto_single_lookup[R.wiki_key] = R
	if(!recipe_index[source])
		recipe_index[source] = list()
	recipe_index[source] += R

/datum/controller/subsystem/cooking/proc/get_recipe(obj/item/base, obj/item/ingredient)
	if(!recipe_index[base.type])
		return null

	var/datum/food_recipe/best
	var/best_entry
	for(var/datum/food_recipe/R in recipe_index[base.type])
		if(!length(R.ingredients))
			continue
		var/entry = R.ingredients[1]
		if(!R.step_accepts(entry, ingredient))
			continue
		if(!best || recipe_entry_more_specific(entry, best_entry))
			best = R
			best_entry = entry

	return best

/proc/recipe_entry_more_specific(a, b)
	if(ispath(a) && !ispath(b))
		return TRUE
	if(ispath(a) && ispath(b))
		return (a != b) && ispath(a, b)
	return FALSE

/datum/controller/subsystem/cooking/proc/get_producing_recipe(item_type)
	for(var/base_type in recipe_index)
		for(var/datum/food_recipe/R in recipe_index[base_type])
			if(R.result_type == item_type)
				return R
	return null

#undef AUTO_SINGLE_EXEMPT_CATEGORIES
