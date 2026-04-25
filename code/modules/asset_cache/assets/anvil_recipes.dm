/datum/asset/spritesheet/anvil_recipes
	name = "anvil_recipes"

/datum/asset/spritesheet/anvil_recipes/create_spritesheets()
	var/list/seen_materials = list()
	for(var/datum/anvil_recipe/recipe as anything in GLOB.anvil_recipes)
		var/icon = recipe.created_item::icon
		var/icon_state = recipe.created_item::icon_state

		if(!icon || !icon_state)
			continue

		Insert("[sanitize_css_class_name("recipe_[REF(recipe)]")]", icon, icon_state)

		if(!(recipe.req_bar in seen_materials) && recipe.req_bar::icon && recipe.req_bar::icon_state)
			Insert("[sanitize_css_class_name("material_[recipe.req_bar]")]", recipe.req_bar::icon, recipe.req_bar::icon_state)
			seen_materials += recipe.req_bar

		for(var/atom/material_type as anything in recipe.additional_items)
			if(material_type in seen_materials)
				continue
			if(!material_type::icon || !material_type::icon_state)
				continue
			Insert("[sanitize_css_class_name("material_[material_type]")]", material_type::icon, material_type::icon_state)
			seen_materials += material_type
