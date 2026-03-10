GLOBAL_DATUM(recipe_wiki, /datum/recipe_wiki)

/datum/recipe_wiki
	/// Cached book metadata: list of assoc lists with "name", "types", "path" keys
	var/list/book_entries = list()
	/// Cached library landing page HTML
	var/cached_library_html
	/// Cached sidebar HTML, keyed by filter key string
	var/list/cached_sidebars = list()
	/// Cached recipe detail HTML, keyed by recipe type path string
	var/list/cached_details = list()
	/// Per-user viewing state, keyed by ckey
	var/list/user_states = list()

/datum/recipe_wiki/New()
	. = ..()
	for(var/book_type in subtypesof(/obj/item/recipe_book))
		var/obj/item/recipe_book/book = new book_type()
		if(!length(book.types))
			qdel(book)
			continue
		book_entries += list(list(
			"name" = book.name,
			"wiki_name" = book.wiki_name || book.name,
			"types" = book.types.Copy(),
			"path" = book_type
		))
		qdel(book)
	// Sort entries alphabetically by wiki_name
	book_entries = sortTim(book_entries, GLOBAL_PROC_REF(cmp_book_entries))

/proc/cmp_book_entries(list/a, list/b)
	return sorttext(b["wiki_name"], a["wiki_name"])

/proc/get_recipe_wiki()
	if(!GLOB.recipe_wiki)
		GLOB.recipe_wiki = new /datum/recipe_wiki()
	return GLOB.recipe_wiki

/// Open the recipe viewer for a specific book's types. Used by physical recipe book items.
/datum/recipe_wiki/proc/show_to_user(mob/user, list/type_filter, title = "Recipe Book")
	if(!user?.client)
		return
	var/ckey = user.client.ckey
	if(!user_states[ckey])
		user_states[ckey] = list()
	var/list/state = user_states[ckey]
	state["recipe"] = null
	state["filter"] = type_filter
	state["title"] = title
	state["page"] = "book"
	user << browse_rsc('html/book.png')
	user << browse(build_book_page(user), "window=recipe_wiki;size=1000x810")

/// Open the OOC wiki library landing page.
/datum/recipe_wiki/proc/show_library(mob/user)
	if(!user?.client)
		return
	var/ckey = user.client.ckey
	if(!user_states[ckey])
		user_states[ckey] = list()
	var/list/state = user_states[ckey]
	state["recipe"] = null
	state["filter"] = null
	state["title"] = null
	state["page"] = "library"
	user << browse_rsc('html/book.png')
	user << browse(build_library_page(), "window=recipe_wiki;size=1000x810")

/// Build the library landing page listing all available recipe books.
/datum/recipe_wiki/proc/build_library_page()
	if(cached_library_html)
		return cached_library_html

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		[recipe_book_css()]
		<style>
			.book-list {
				max-width: 600px; margin: 0 auto;
				display: grid; grid-template-columns: 1fr 1fr;
				gap: 0;
			}
			.book-entry {
				display: block; padding: 8px 12px;
				color: #3e2723; text-decoration: none;
			}
			.book-entry:hover { background-color: rgba(210, 180, 140, 0.3); }
		</style>
		<body>
			<h1>Guidebook</h1>
			<div class="book-list">
	"}

	for(var/list/entry in book_entries)
		html += "<a class='book-entry' href='byond://?src=\ref[src];action=open_book&book=[entry["path"]]'>[entry["wiki_name"]]</a>"

	html += {"
			</div>
		</body>
		</html>
	"}

	cached_library_html = html
	return html

/// Build the recipe viewer page for a specific book filter.
/datum/recipe_wiki/proc/build_book_page(mob/user)
	var/ckey = user.client.ckey
	var/list/state = user_states[ckey]
	var/list/type_filter = state["filter"]
	var/current_recipe = state["recipe"]
	var/title = state["title"] || "Recipe Book"

	var/filter_key = type_filter ? jointext(type_filter, ",") : "all"
	var/sidebar = get_cached_sidebar(type_filter, filter_key)

	var/recipe_content
	if(current_recipe)
		recipe_content = get_cached_detail(current_recipe, user)
	else
		recipe_content = "<div class='recipe-content'><p>Select a recipe from the list to view details.</p></div>"

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		[recipe_book_css()]
		<body>
			<h1>[title]</h1>
			<div class="book-content">
				<div class="sidebar">
					<a class='back-link' href='byond://?src=\ref[src];action=back_to_library'>Back to Library</a>
					<input type="text" class="search-box" id="searchInput" placeholder="Search recipes...">
					[sidebar]
				</div>
				<div class="main-content" id="mainContent">
					[recipe_content]
				</div>
			</div>
			<script>
				var currentCategory = 'All';
				var firstBtn = document.querySelector('.category-btn');
				if (firstBtn) firstBtn.classList.add('active');

				function setCategory(btn) {
					currentCategory = btn.getAttribute('data-category');
					document.querySelectorAll('.category-btn').forEach(function(b) {
						b.classList.remove('active');
					});
					btn.classList.add('active');
					filterRecipes();
				}

				var searchTimeout;
				document.getElementById('searchInput').addEventListener('keyup', function(e) {
					clearTimeout(searchTimeout);
					searchTimeout = setTimeout(filterRecipes, 300);
				});

				function filterRecipes() {
					var query = document.getElementById('searchInput').value.toLowerCase();
					var links = document.querySelectorAll('.recipe-link');
					var anyVisible = false;
					links.forEach(function(link) {
						var name = link.textContent.toLowerCase();
						var cat = link.getAttribute('data-category');
						var matchQuery = query === '' || name.includes(query);
						var matchCat = currentCategory === 'All' || cat === currentCategory;
						if (matchQuery && matchCat) {
							link.style.display = 'block';
							anyVisible = true;
						} else {
							link.style.display = 'none';
						}
					});
					document.getElementById('noMatchesMsg').style.display = anyVisible ? 'none' : 'block';
				}
			</script>
		</body>
		</html>
	"}
	return html

/// Get or build cached sidebar HTML for a given type filter.
/datum/recipe_wiki/proc/get_cached_sidebar(list/types, filter_key)
	if(cached_sidebars[filter_key])
		return cached_sidebars[filter_key]

	var/list/categories = gather_recipe_categories(types)
	var/html = ""

	html += "<div class='categories'>"
	for(var/category in categories)
		html += "<button class='category-btn' data-category='[category]' onclick='setCategory(this)'>[category]</button>"
	html += "</div>"

	html += "<div class='recipe-list' id='recipeList'>"
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			var/list/sorted_types = sortNames(subtypesof(path))
			for(var/atom/sub_path as anything in sorted_types)
				if(is_abstract(sub_path))
					continue
				if(!sub_path.name)
					continue
				if(should_hide_recipe(sub_path))
					continue
				var/recipe_category = get_recipe_category(sub_path) || "All"
				html += "<a class='recipe-link' data-category='[recipe_category]' href='byond://?src=\ref[src];action=view_recipe&recipe=[sub_path]'>[initial(sub_path.name)]</a>"
		else
			if(should_hide_recipe(path))
				continue
			var/recipe_category = get_recipe_category(path) || "All"
			html += "<a class='recipe-link' data-category='[recipe_category]' href='byond://?src=\ref[src];action=view_recipe&recipe=[path]'>[initial(path.name)]</a>"

	html += "<div id='noMatchesMsg' class='no-matches'>No matching recipes found.</div>"
	html += "</div>"

	cached_sidebars[filter_key] = html
	return html

/// Get or build cached recipe detail HTML.
/datum/recipe_wiki/proc/get_cached_detail(path, mob/user)
	var/path_key = "[path]"
	if(cached_details[path_key])
		return cached_details[path_key]
	var/html = generate_recipe_detail_html(path, user)
	cached_details[path_key] = html
	return html

/datum/recipe_wiki/Topic(href, href_list)
	. = ..()
	var/action = href_list["action"]
	if(!action)
		return

	var/mob/user = usr
	if(!user?.client)
		return
	var/ckey = user.client.ckey
	var/list/state = user_states[ckey]
	if(!state)
		return

	switch(action)
		if("open_book")
			var/book_path = text2path(href_list["book"])
			if(!book_path)
				return
			for(var/list/entry in book_entries)
				if(entry["path"] == book_path)
					show_to_user(user, entry["types"], entry["wiki_name"])
					return

		if("back_to_library")
			show_library(user)

		if("view_recipe")
			var/recipe_path = href_list["recipe"]
			if(recipe_path)
				state["recipe"] = text2path(recipe_path)
				user << browse_rsc('html/book.png')
				user << browse(build_book_page(user), "window=recipe_wiki;size=1000x810")

		if("clear_recipe")
			state["recipe"] = null
			user << browse_rsc('html/book.png')
			user << browse(build_book_page(user), "window=recipe_wiki;size=1000x810")

/client/verb/ooc_wiki()
	set name = "Guidebook"
	set category = "OOC"
	set desc = "Browse all recipe books and guidebook entries."

	var/datum/recipe_wiki/wiki = get_recipe_wiki()
	wiki.show_library(mob)
