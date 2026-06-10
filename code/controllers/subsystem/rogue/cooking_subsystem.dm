SUBSYSTEM_DEF(cooking)
	name = "Cooking Controller"
	flags = SS_NO_FIRE
	var/list/recipe_index = list() // Key: base_item path | Value: list of recipe datums

/datum/controller/subsystem/cooking/Initialize()
	init_recipes()
	return ..()

/datum/controller/subsystem/cooking/proc/init_recipes()
	for(var/R in typesof(/datum/food_recipe) - /datum/food_recipe)
		var/datum/food_recipe/recipe = new R()
		if(!recipe.base_item)
			continue
		for(var/base in (islist(recipe.base_item) ? recipe.base_item : list(recipe.base_item)))
			if(!recipe_index[base])
				recipe_index[base] = list()
			recipe_index[base] += recipe

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
