GLOBAL_LIST_EMPTY(anvil_recipe_smelt_cache)

/proc/build_anvil_recipe_smelt_cache()
	for(var/datum/anvil_recipe/recipe as anything in GLOB.anvil_recipes)
		if(!recipe.created_item)
			continue
		if(GLOB.anvil_recipe_smelt_cache[recipe.created_item])
			continue
		if(recipe.createditem_num > 1)
			continue
		var/list/products = list()
		if(ispath(recipe.req_bar, /obj/item/ingot))
			products |= recipe.req_bar
		for(var/path in recipe.additional_items)
			if(ispath(path, /obj/item/ingot))
				products |= path
		if(length(products))
			GLOB.anvil_recipe_smelt_cache[recipe.created_item] = products

/obj/item/proc/get_smelt_products()
	if(!smeltable)
		return null
	if(smeltresult)
		return list(smeltresult)
	if(length(GLOB.anvil_recipes) && !length(GLOB.anvil_recipe_smelt_cache))
		build_anvil_recipe_smelt_cache()
	return GLOB.anvil_recipe_smelt_cache[type]
