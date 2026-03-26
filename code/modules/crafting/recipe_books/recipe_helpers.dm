/// Shared helper procs for the recipe book and OOC wiki systems.

/proc/get_recipe_category(path)
	if(!ispath(path))
		return null
	var/datum/temp_recipe
	var/category

	if(ispath(path, /datum/crafting_recipe))
		temp_recipe = new path()
		var/datum/crafting_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/anvil_recipe))
		temp_recipe = new path()
		var/datum/anvil_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/book_entry))
		temp_recipe = new path()
		var/datum/book_entry/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/alch_grind_recipe))
		temp_recipe = new path()
		var/datum/alch_grind_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/alch_cauldron_recipe))
		temp_recipe = new path()
		var/datum/alch_cauldron_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/brewing_recipe))
		temp_recipe = new path()
		var/datum/brewing_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/runeritual))
		temp_recipe = new path()
		var/datum/runeritual/r = temp_recipe
		category = r.category
	else if(ispath(path, /obj/effect/proc_holder/spell))
		var/tier = initial(path:spell_tier)
		category = "Tier [tier]"
		return category

	if(temp_recipe)
		qdel(temp_recipe)
	return category

/proc/should_hide_recipe(path)
	if(ispath(path, /datum/crafting_recipe))
		var/datum/crafting_recipe/recipe = path
		if(initial(recipe.hides_from_books))
			return TRUE
	if(ispath(path, /datum/anvil_recipe))
		var/datum/anvil_recipe/recipe = path
		if(initial(recipe.hides_from_books))
			return TRUE
	if(ispath(path, /datum/runeritual))
		var/datum/runeritual/ritual = path
		if(initial(ritual.blacklisted))
			return TRUE
	return FALSE

/proc/gather_recipe_categories(list/types)
	var/list/categories = list("All")
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			for(var/atom/sub_path as anything in subtypesof(path))
				if(is_abstract(sub_path))
					continue
				var/category = get_recipe_category(sub_path)
				if(category && !(category in categories))
					categories += category
		else
			var/category = get_recipe_category(path)
			if(category && !(category in categories))
				categories += category
	categories = sortTim(categories, GLOBAL_PROC_REF(cmp_text_asc))
	if("All" in categories)
		categories -= "All"
		categories.Insert(1, "All")
	return categories

/proc/generate_recipe_detail_html(path, mob/user)
	if(!ispath(path))
		return "<div class='recipe-content'><p>Invalid recipe selected.</p></div>"

	var/html = "<div class='recipe-content'>"
	var/recipe_name = "Unknown Recipe"
	var/recipe_html = ""

	var/datum/temp_recipe
	if(ispath(path, /datum/crafting_recipe))
		temp_recipe = new path()
		var/datum/crafting_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/anvil_recipe))
		temp_recipe = new path()
		var/datum/anvil_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/book_entry))
		temp_recipe = new path()
		var/datum/book_entry/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/alch_grind_recipe))
		temp_recipe = new path()
		var/datum/alch_grind_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/alch_cauldron_recipe))
		temp_recipe = new path()
		var/datum/alch_cauldron_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/brewing_recipe))
		temp_recipe = new path()
		var/datum/brewing_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/runeritual))
		temp_recipe = new path()
		var/datum/runeritual/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/temp_spell = new path()
		recipe_name = temp_spell.name
		recipe_html = temp_spell.generate_wiki_html(user)
		qdel(temp_spell)
		var/miracle_html = generate_miracle_granted_html(path)
		if(miracle_html)
			recipe_html += miracle_html

	if(temp_recipe)
		qdel(temp_recipe)

	if(recipe_html && recipe_html != "")
		html += recipe_html
	else
		html += "<h2 class='recipe-title'>[recipe_name]</h2>"
		html += "<p>No detailed information available.</p>"

	html += "</div>"
	return html

