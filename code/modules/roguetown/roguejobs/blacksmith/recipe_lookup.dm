GLOBAL_LIST_EMPTY(anvil_recipe_smelt_cache)

/proc/build_anvil_recipe_smelt_cache()
	for(var/recipe_path in subtypesof(/datum/anvil_recipe))
		var/datum/anvil_recipe/R = recipe_path
		if(initial(R.abstract_type) == recipe_path)
			continue
		var/created = initial(R.created_item)
		if(!created)
			continue
		if(GLOB.anvil_recipe_smelt_cache[created])
			continue
		var/datum/anvil_recipe/instance = new recipe_path
		var/list/products = list()
		if(ispath(instance.req_bar, /obj/item/ingot))
			products |= instance.req_bar
		for(var/path in instance.additional_items)
			if(ispath(path, /obj/item/ingot))
				products |= path
		qdel(instance)
		if(length(products))
			GLOB.anvil_recipe_smelt_cache[created] = products

/obj/item/proc/get_smelt_products()
	if(smeltresult)
		return list(smeltresult)
	if(!length(GLOB.anvil_recipe_smelt_cache))
		build_anvil_recipe_smelt_cache()
	return GLOB.anvil_recipe_smelt_cache[type]
