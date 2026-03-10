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

	if(temp_recipe)
		qdel(temp_recipe)

	if(recipe_html && recipe_html != "")
		html += recipe_html
	else
		html += "<h2 class='recipe-title'>[recipe_name]</h2>"
		html += "<p>No detailed information available.</p>"

	html += "</div>"
	return html

/proc/recipe_book_css()
	return {"
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1em;
				text-align: center;
				margin: 20px;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background: url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1 {
				text-align: center;
				font-size: 1.5em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 20px;
			}
			.book-content { display: flex; height: 85%; }
			.sidebar {
				width: 30%; padding: 10px;
				border-right: 2px solid #3e2723;
				overflow-y: auto; max-height: 600px;
			}
			.main-content {
				width: 70%; padding: 10px;
				overflow-y: auto; max-height: 600px; text-align: left;
			}
			.categories { margin-bottom: 15px; }
			.category-btn {
				margin: 2px; padding: 5px;
				background-color: #d2b48c;
				border: 1px solid #3e2723; border-radius: 5px;
				cursor: pointer; font-family: "Charm", cursive;
			}
			.category-btn.active { background-color: #8b4513; color: white; }
			.search-box {
				width: 90%; padding: 5px; margin-bottom: 15px;
				border: 1px solid #3e2723; border-radius: 5px;
				font-family: "Charm", cursive;
			}
			.recipe-list { text-align: left; }
			.recipe-link {
				display: block; padding: 5px;
				color: #3e2723; text-decoration: none;
				border-bottom: 1px dotted #d2b48c;
			}
			.recipe-link:hover { background-color: rgba(210, 180, 140, 0.3); }
			.back-link {
				display: block; padding: 8px 12px; margin-bottom: 10px;
				color: #3e2723; text-decoration: none;
				border: 1px solid #3e2723; border-radius: 5px;
				text-align: center;
			}
			.back-link:hover { background-color: rgba(210, 180, 140, 0.3); }
			.recipe-content { padding: 10px; }
			.recipe-title {
				font-size: 1.5em; margin-bottom: 15px;
				border-bottom: 1px solid #3e2723; padding-bottom: 5px;
			}
			.icon { width: 96px; height: 96px; vertical-align: middle; margin-right: 10px; }
			.result-icon { text-align: center; margin: 15px 0; }
			.no-matches {
				font-style: italic; color: #8b4513;
				padding: 10px; text-align: center; display: none;
			}
			table { margin: 10px auto; border-collapse: collapse; }
			table, th, td { border: 1px solid #3e2723; }
			th, td { padding: 8px; text-align: left; }
			th { background-color: rgba(210, 180, 140, 0.3); }
			.hidden { display: none; }
		</style>
	"}
