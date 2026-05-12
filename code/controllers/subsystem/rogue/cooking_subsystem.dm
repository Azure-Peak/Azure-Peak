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
		if(!recipe_index[recipe.base_item])
			recipe_index[recipe.base_item] = list()
		recipe_index[recipe.base_item] += recipe

/datum/controller/subsystem/cooking/proc/get_recipe(obj/item/base, obj/item/ingredient)
	if(!recipe_index[base.type])
		return null
	for(var/datum/food_recipe/R in recipe_index[base.type])
		if(istype(ingredient, R.ingredients[1])) // Check if this starts the recipe
			return R
	return null
