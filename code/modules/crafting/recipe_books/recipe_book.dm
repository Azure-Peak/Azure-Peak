

/obj/item/recipe_book
	icon = 'icons/roguetown/items/books.dmi'

	grid_width = 32
	grid_height = 32
	firefuel = 5 MINUTES
	var/list/types = list()
	var/mob/current_reader
	var/open
	var/base_icon_state
	var/can_spawn = TRUE
	resistance_flags = FLAMMABLE
	var/list/categories = list("All") // Default categories
	var/current_category = "All"      // Default selected category
	var/current_recipe = null         // Currently viewed recipe
	var/search_query = ""             // Current search query

/obj/item/recipe_book/New()
	. = ..()
	// Populate categories from types with custom categories
	generate_categories()

/obj/item/recipe_book/proc/generate_categories()
	categories = list("All") // Reset and add default

	// Gather categories from recipes themselves
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			// Handle abstract types
			for(var/atom/sub_path as anything in subtypesof(path))
				if(is_abstract(sub_path))
					continue

				var/category = get_recipe_category(sub_path)
				if(category && !(category in categories))
					categories += category
		else
			// Handle non-abstract types directly
			var/category = get_recipe_category(path)
			if(category && !(category in categories))
				categories += category

/obj/item/recipe_book/proc/get_recipe_category(path)
	// Extract category from the recipe
	var/category = null

	// Try to create a temporary instance to get category
	if(ispath(path))
		var/datum/temp_recipe

		// Handle different recipe types
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
		// else if(ispath(path, /datum/orderless_slapcraft))
		// 	temp_recipe = new path()
		// 	var/datum/orderless_slapcraft/r = temp_recipe
		// 	category = r.category
		// else if(ispath(path, /datum/slapcraft_recipe))
		// 	temp_recipe = new path()
		// 	var/datum/slapcraft_recipe/r = temp_recipe
		// 	category = r.category
		// else if(ispath(path, /datum/crafting_recipe))
		// 	temp_recipe = new path()
		// 	var/datum/crafting_recipe/r = temp_recipe
		// 	category = r.category
		// else if(ispath(path, /datum/container_craft))
		// 	temp_recipe = new path()
		// 	var/datum/container_craft/r = temp_recipe
		// 	category = r.category
		// else if(ispath(path, /datum/molten_recipe))
		// 	temp_recipe = new path()
		// 	var/datum/molten_recipe/r = temp_recipe
		// 	category = r.category
		// else if(ispath(path, /datum/pottery_recipe))
		// 	temp_recipe = new path()
		// 	var/datum/pottery_recipe/r = temp_recipe
		// 	category = r.category
		else if(ispath(path, /datum/brewing_recipe))
			temp_recipe = new path()
			var/datum/brewing_recipe/r = temp_recipe
			category = r.category
		else if(ispath(path, /datum/runeritual))
			temp_recipe = new path()
			var/datum/runeritual/r = temp_recipe
			category = r.category

		// Clean up our temporary instance
		if(temp_recipe)
			qdel(temp_recipe)

	return category

/obj/item/recipe_book/dropped(mob/user, silent)
	. = ..()
	if(current_reader)
		current_reader << browse(null,"window=recipe")
		current_reader = null

/obj/item/recipe_book/attack_self(mob/user)
	. = ..()
	current_reader = user
	current_reader << browse(generate_html(user),"window=recipe;size=1000x810")

/obj/item/recipe_book/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client

	user << browse_rsc('html/book.png')

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1em;
				text-align: center;
				margin: 20px;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('book.png');
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
			.book-content {
				display: flex;
				height: 85%;
			}
			.sidebar {
				width: 30%;
				padding: 10px;
				border-right: 2px solid #3e2723;
				overflow-y: auto;
				max-height: 600px;
			}
			.main-content {
				width: 70%;
				padding: 10px;
				overflow-y: auto;
				max-height: 600px;
				text-align: left;
			}
			.categories {
				margin-bottom: 15px;
			}
			.category-btn {
				margin: 2px;
				padding: 5px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
			}
			.category-btn.active {
				background-color: #8b4513;
				color: white;
			}
			.search-box {
				width: 90%;
				padding: 5px;
				margin-bottom: 15px;
				border: 1px solid #3e2723;
				border-radius: 5px;
				font-family: "Charm", cursive;
			}
			.recipe-list {
				text-align: left;
			}
			.recipe-link {
				display: block;
				padding: 5px;
				color: #3e2723;
				text-decoration: none;
				border-bottom: 1px dotted #d2b48c;
			}
			.recipe-link:hover {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.recipe-content {
				padding: 10px;
			}
			.recipe-title {
				font-size: 1.5em;
				margin-bottom: 15px;
				border-bottom: 1px solid #3e2723;
				padding-bottom: 5px;
			}
			.back-btn {
				margin-top: 10px;
				padding: 5px 10px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
			}
			.icon {
				width: 96px;
				height: 96px;
				vertical-align: middle;
				margin-right: 10px;
			}
			.result-icon {
				text-align: center;
				margin: 15px 0;
			}
			.craft-button {
				display: inline-block;
				margin: 10px 0;
				padding: 8px 15px;
				background-color: #8b4513;
				color: white;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				text-decoration: none;
			}
			.no-matches {
				font-style: italic;
				color: #8b4513;
				padding: 10px;
				text-align: center;
				display: none;
			}
			/* Styles to match the original recipe display */
			table {
				margin: 10px auto;
				border-collapse: collapse;
			}
			table, th, td {
				border: 1px solid #3e2723;
			}
			th, td {
				padding: 8px;
				text-align: left;
			}
			th {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.hidden {
				display: none;
			}
		</style>

		<body>
			<h1>Recipe Book</h1>

			<div class="book-content">
				<div class="sidebar">
					<!-- Search box (now with live filtering) -->
					<input type="text" class="search-box" id="searchInput"
						placeholder="Search recipes..." value="[search_query]">

					<!-- Categories -->
					<div class="categories">
	"}

	// Add category buttons with direct links
	for(var/category in categories)
		var/active_class = category == current_category ? "active" : ""
		html += "<button class='category-btn [active_class]' onclick=\"location.href='byond://?src=\ref[src];action=set_category&category=[url_encode(category)]'\">[category]</button>"

	html += {"
					</div>

					<!-- Recipe List -->
					<div class="recipe-list" id="recipeList">
	"}

	// Add recipes based on current category
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			var/list/sorted_types = sortNames(subtypesof(path)) // Edit vs Vander lin - Sort
			for(var/atom/sub_path as anything in sorted_types)
				if(is_abstract(sub_path))
					continue
				if(!sub_path.name) // Also skip if there's no names
					continue

				if(ispath(sub_path, /datum/crafting_recipe))
					var/datum/crafting_recipe/recipe = sub_path
					if(initial(recipe.hides_from_books))
						continue
				if(ispath(sub_path, /datum/anvil_recipe))
					var/datum/anvil_recipe/recipe = sub_path
					if(initial(recipe.hides_from_books))
						continue
				if(ispath(sub_path, /datum/runeritual))
					var/datum/runeritual/ritual = sub_path
					if(initial(ritual.blacklisted))
						continue

				var/recipe_name = initial(sub_path.name)

				// Check if this recipe belongs to the current category
				var/should_show = TRUE
				if(current_category != "All")
					var/category = get_recipe_category(sub_path)
					if(category != current_category)
						should_show = FALSE

				// Default display style - will be changed by JS if searching
				var/display_style = should_show ? "" : "display: none;"

				html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[sub_path]' style='[display_style]'>[recipe_name]</a>"
		else
			var/recipe_name = initial(path.name)

			// Check if this recipe belongs to the current category
			var/should_show = TRUE
			if(current_category != "All")
				var/category = get_recipe_category(path)
				if(category != current_category)
					should_show = FALSE

			// Default display style - will be changed by JS if searching
			var/display_style = should_show ? "" : "display: none;"

			html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[path]' style='[display_style]'>[recipe_name]</a>"

	html += {"
						<div id="noMatchesMsg" class="no-matches">No matching recipes found.</div>
					</div>
				</div>

				<div class="main-content" id="mainContent">
	"}

	// If a recipe is selected, show its details
	if(current_recipe)
		html += generate_recipe_html(current_recipe, user)
	else
		html += "<div class='recipe-content'><p>Select a recipe from the list to view details.</p></div>"

	html += {"
				</div>
			</div>

			<script>
				// Live search functionality with debouncing
				let searchTimeout;
				document.getElementById('searchInput').addEventListener('keyup', function(e) {
					clearTimeout(searchTimeout);

					// Debounce the search to improve performance (only search after typing stops for 300ms)
					searchTimeout = setTimeout(function() {
						const query = document.getElementById('searchInput').value.toLowerCase();
						filterRecipes(query);
					}, 300);
				});

				function filterRecipes(query) {
					const recipeLinks = document.querySelectorAll('.recipe-link');
					const currentCategory = "[current_category]";
					let anyVisible = false;

					recipeLinks.forEach(function(link) {
						const recipeName = link.textContent.toLowerCase();

						// Check if it matches the search query
						const matchesQuery = query === '' || recipeName.includes(query);

						// If we have both a query and active category, respect both filters
						if (matchesQuery) {
							link.style.display = 'block';
							anyVisible = true;
						} else {
							link.style.display = 'none';
						}
					});

					// Show a message if no recipes match
					const noMatchesMsg = document.getElementById('noMatchesMsg');
					noMatchesMsg.style.display = anyVisible ? 'none' : 'block';

					// Remember the query
					window.location.replace(`byond://?src=\\ref[src];action=remember_query&query=${encodeURIComponent(query)}`);
				}

				// Initialize search based on any current query
				if ("[search_query]" !== "") {
					filterRecipes("[search_query]".toLowerCase());
				}
			</script>
		</body>
		</html>
	"}

	return html

/obj/item/recipe_book/proc/generate_recipe_html(path, mob/user)
	if(!ispath(path))
		return "<div class='recipe-content'><p>Invalid recipe selected.</p></div>"

	var/html = "<div class='recipe-content'>"

	// Get recipe details
	var/recipe_name = "Unknown Recipe"
	var/recipe_description = "No description available."
	var/recipe_html = ""

	// Create a temporary instance to get the actual recipe content that would normally be shown in show_menu
	var/datum/temp_recipe
	if(ispath(path, /datum/crafting_recipe))
		temp_recipe = new path()
		var/datum/crafting_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_description = recipe_description
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/anvil_recipe))
		temp_recipe = new path()
		var/datum/anvil_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/book_entry))
		temp_recipe = new path()
		var/datum/book_entry/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/alch_grind_recipe))
		temp_recipe = new path()
		var/datum/alch_grind_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/alch_cauldron_recipe))
		temp_recipe = new path()
		var/datum/alch_cauldron_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	// else if(ispath(path, /datum/alch_cauldron_recipe))
	// 	temp_recipe = new path()
	// 	var/datum/alch_cauldron_recipe/r = temp_recipe
	// 	recipe_name = initial(r.name)
	// 	recipe_html = get_recipe_specific_html(r, user)
	// else if(ispath(path, /datum/orderless_slapcraft))
	// 	temp_recipe = new path()
	// 	var/datum/orderless_slapcraft/r = temp_recipe
	// 	recipe_name = initial(r.name)
	// 	recipe_html = get_recipe_specific_html(r, user)
	// else if(ispath(path, /datum/slapcraft_recipe))
	// 	temp_recipe = new path()
	// 	var/datum/slapcraft_recipe/r = temp_recipe
	// 	recipe_name = initial(r.name)
	// 	recipe_description = r.desc || recipe_description
	// 	recipe_html = get_recipe_specific_html(r, user)
	// else if(ispath(path, /datum/crafting_recipe))
	// 	temp_recipe = new path()
	// 	var/datum/crafting_recipe/r = temp_recipe
	// 	recipe_name = initial(r.name)
	// 	recipe_html = get_recipe_specific_html(r, user)
	// else if(ispath(path, /datum/container_craft))
	// 	temp_recipe = new path()
	// 	var/datum/container_craft/r = temp_recipe
	// 	recipe_name = initial(r.name)
	// 	recipe_html = get_recipe_specific_html(r, user)
	// else if(ispath(path, /datum/molten_recipe))
	// 	temp_recipe = new path()
	// 	var/datum/molten_recipe/r = temp_recipe
	// 	recipe_name = initial(r.name)
	// 	recipe_html = get_recipe_specific_html(r, user)
	// else if(ispath(path, /datum/pottery_recipe))
	// 	temp_recipe = new path()
	// 	var/datum/pottery_recipe/r = temp_recipe
	// 	recipe_name = initial(r.name)
	// 	recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/brewing_recipe))
		temp_recipe = new path()
		var/datum/brewing_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)
	else if(ispath(path, /datum/runeritual))
		temp_recipe = new path()
		var/datum/runeritual/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = get_recipe_specific_html(r, user)

	if(temp_recipe)
		qdel(temp_recipe)

	// If we have recipe-specific HTML, use that
	if(recipe_html && recipe_html != "")
		html += recipe_html
	else
		// Otherwise use our fallback information display
		html += "<h2 class='recipe-title'>[recipe_name]</h2>"
		html += "<p>[recipe_description]</p>"

	html += "</div>"

	return html

/obj/item/recipe_book/proc/get_recipe_specific_html(datum/recipe, mob/user)
	if(!istype(recipe))
		return ""
	var/html = ""

	html = recipe:generate_html(user)
	return html

/obj/item/recipe_book/Topic(href, href_list)
	. = ..()
	var/action = href_list["action"]
	if(!action)
		return

	switch(action)
		if("set_category")
			var/category = href_list["category"]
			if(category)
				current_category = category
				current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
			return

		if("search")
			var/query = href_list["query"]
			if(query)
				search_query = query
				current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
			return

		if("remember_query")
			var/query = href_list["query"]
			if(query)
				search_query = query
			return

		if("view_recipe")
			var/recipe_path = href_list["recipe"]
			if(recipe_path)
				var/datum/path = text2path(recipe_path)
				current_recipe = path
				current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
			return

		if("clear_recipe")
			current_recipe = null
			current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
			return

	if(href_list["set_category"])
		current_category = href_list["set_category"]
		current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
		return

	if(href_list["search"])
		search_query = href_list["search"]
		current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
		return

	if(href_list["view_recipe"])
		var/datum/path = text2path(href_list["view_recipe"])
		current_recipe = path
		current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
		return

	if(href_list["clear_recipe"])
		current_recipe = null
		current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")
		return

	if(href_list["pick_recipe"])
		var/datum/path = text2path(href_list["pick_recipe"])
		current_recipe = path
		current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")

/obj/item/recipe_book/Topic(href, href_list)
	. = ..()
	if(href_list["pick_recipe"])
		var/datum/path = text2path(href_list["pick_recipe"])
		if(ispath(path, /datum/crafting_recipe))
			var/datum/crafting_recipe/real_path = new path
			real_path.show_menu(current_reader)
		else if(ispath(path, /datum/anvil_recipe))
			var/datum/anvil_recipe/real_path = new path
			real_path.show_menu(current_reader)
		// if(ispath(path, /datum/repeatable_crafting_recipe))
		// 	var/datum/repeatable_crafting_recipe/real_path = new path
		// 	real_path.show_menu(current_reader)
		// else if(ispath(path, /datum/orderless_slapcraft))
		// 	var/datum/orderless_slapcraft/real_path = new path
		// 	real_path.show_menu(current_reader)
		// else if(ispath(path, /datum/slapcraft_recipe))
		// 	var/datum/slapcraft_recipe/real_path = new path
		// 	real_path.show_menu(current_reader)
		// else if(ispath(path, /datum/pot_recipe))
		// 	var/datum/pot_recipe/real_path = new path
		// 	real_path.show_menu(current_reader)
		// else if(ispath(path, /datum/molten_recipe))
		// 	var/datum/molten_recipe/real_path = new path
		// 	real_path.show_menu(current_reader)
		// else if(ispath(path, /datum/pottery_recipe))
		// 	var/datum/pottery_recipe/real_path = new path
		// 	real_path.show_menu(current_reader)
		else if(ispath(path, /datum/brewing_recipe))
			var/datum/brewing_recipe/real_path = new path
			real_path.show_menu(current_reader)
		// else if(ispath(path, /datum/runeritual))
		// 	var/datum/runeritual/real_path = new path
		// 	real_path.show_menu(current_reader)
		// else if(ispath(path, /datum/book_entry))
		// 	var/datum/book_entry/real_path = new path
		// 	real_path.show_menu(current_reader)

/obj/item/recipe_book/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
