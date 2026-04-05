GLOBAL_DATUM(recipe_wiki, /datum/recipe_wiki)

/datum/recipe_wiki
	/// Cached book metadata: list of assoc lists with "name", "types", "path" keys
	var/list/book_entries = list()
	/// Cached recipe detail HTML, keyed by recipe type path string
	var/list/cached_details = list()
	/// Per-user viewing state, keyed by ckey
	var/list/user_states = list()
	/// Cached per-book recipe lists for TGUI static data, keyed by book path string
	var/list/cached_book_recipes = list()

/datum/recipe_wiki/New()
	. = ..()
	for(var/book_type in subtypesof(/obj/item/recipe_book))
		var/obj/item/recipe_book/book = new book_type()
		if(!length(book.types) && !book.wiki_only)
			qdel(book)
			continue
		var/book_key = "[book_type]"
		if(book.can_spawn || book.wiki_only)
			book_entries += list(list(
				"name" = book.name,
				"wiki_name" = book.wiki_name || book.name,
				"types" = book.types.Copy(),
				"path" = book_type,
				"wiki_section" = book.wiki_section
			))
		// Cache recipe data for all books, even those hidden from the library
		if(!cached_book_recipes[book_key])
			if(book_type == /obj/item/recipe_book/miracle_compendium)
				cached_book_recipes[book_key] = build_miracle_list(book.types)
			else
				cached_book_recipes[book_key] = build_recipe_list(book.types)
		qdel(book)
	book_entries = sortTim(book_entries, GLOBAL_PROC_REF(cmp_book_entries))

/proc/cmp_book_entries(list/a, list/b)
	return sorttext(b["wiki_name"], a["wiki_name"])

/proc/get_recipe_wiki()
	if(!GLOB.recipe_wiki)
		GLOB.recipe_wiki = new /datum/recipe_wiki()
	return GLOB.recipe_wiki

/// Open the recipe viewer for a specific book's types. Used by physical recipe book items.
/datum/recipe_wiki/proc/show_to_user(mob/user, list/type_filter, title = "Recipe Book", book_type_path)
	if(!user?.client)
		return
	var/ckey = user.client.ckey
	if(!user_states[ckey])
		user_states[ckey] = list()
	var/list/state = user_states[ckey]
	state["recipe"] = null
	state["category"] = "All"
	state["filter"] = type_filter
	state["title"] = title
	state["page"] = "book"
	state["book_path"] = book_type_path ? "[book_type_path]" : null
	ui_interact(user)

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
	state["book_path"] = null
	state["category"] = "All"
	ui_interact(user)

/datum/recipe_wiki/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RecipeBook", "Encyclopedia")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/recipe_wiki/ui_state(mob/user)
	return GLOB.always_state

/datum/recipe_wiki/ui_static_data(mob/user)
	var/list/data = list()

	var/list/books = list()
	for(var/list/entry in book_entries)
		var/entry_path = "[entry["path"]]"
		books += list(list(
			"wiki_name" = entry["wiki_name"],
			"path" = entry_path,
			"section" = entry["wiki_section"]
		))
	data["books"] = books

	data["book_recipes"] = cached_book_recipes

	return data

/datum/recipe_wiki/ui_data(mob/user)
	var/list/data = list()
	var/ckey = user.client?.ckey
	if(!ckey || !user_states[ckey])
		data["page"] = "library"
		data["current_book"] = null
		data["current_book_title"] = ""
		data["current_recipe"] = null
		data["recipe_detail_html"] = ""
		return data

	var/list/state = user_states[ckey]
	data["page"] = state["page"] || "library"
	data["current_book"] = state["book_path"]
	data["current_book_title"] = state["title"] || "Guidebook"
	var/cur_recipe = state["recipe"]
	data["current_recipe"] = cur_recipe ? "[cur_recipe]" : null

	if(state["recipe"])
		data["recipe_detail_html"] = get_cached_detail(state["recipe"], user)
	else
		data["recipe_detail_html"] = ""

	return data

/datum/recipe_wiki/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	if(!user?.client)
		return
	var/ckey = user.client.ckey
	if(!user_states[ckey])
		user_states[ckey] = list()
	var/list/ustate = user_states[ckey]

	switch(action)
		if("open_book")
			var/book_path = text2path(params["path"])
			if(!book_path)
				return
			var/obj/item/recipe_book/temp_book = new book_path()
			if(temp_book.open_wiki_entry(user))
				qdel(temp_book)
				return FALSE
			qdel(temp_book)
			for(var/list/entry in book_entries)
				if(entry["path"] == book_path)
					ustate["recipe"] = null
					ustate["category"] = "All"
					ustate["filter"] = entry["types"]
					ustate["title"] = entry["wiki_name"]
					ustate["page"] = "book"
					ustate["book_path"] = params["path"]
					return TRUE

		if("back_to_library")
			ustate["recipe"] = null
			ustate["filter"] = null
			ustate["title"] = null
			ustate["page"] = "library"
			ustate["book_path"] = null
			ustate["category"] = "All"
			return TRUE

		if("view_recipe")
			var/recipe_path = text2path(params["path"])
			if(recipe_path)
				ustate["recipe"] = recipe_path
				return TRUE

		if("clear_recipe")
			ustate["recipe"] = null
			return TRUE

/// Build sorted recipe list data for a given set of types.
/datum/recipe_wiki/proc/build_recipe_list(list/types)
	var/list/valid_paths = list()
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			for(var/atom/sub_path as anything in subtypesof(path))
				if(is_abstract(sub_path))
					continue
				if(!sub_path.name)
					continue
				if(should_hide_recipe(sub_path))
					continue
				valid_paths += sub_path
		else
			if(!initial(path.name))
				continue
			if(should_hide_recipe(path))
				continue
			valid_paths += path
	valid_paths = sortNames(valid_paths)

	var/list/recipes = list()
	for(var/atom/entry_path as anything in valid_paths)
		var/recipe_category = get_recipe_category(entry_path) || "All"
		recipes += list(list(
			"name" = initial(entry_path.name),
			"path" = "[entry_path]",
			"category" = recipe_category
		))
	return recipes

/// Build miracle list with entries duplicated per patron, sorted by tier then name.
/datum/recipe_wiki/proc/build_miracle_list(list/types)
	var/list/entries = list()
	for(var/spell_path in types)
		var/path_key = "[spell_path]"
		var/list/patrons = GLOB.miracle_registry[path_key]
		if(!length(patrons))
			continue
		var/s_name = initial(spell_path:name)
		if(!s_name)
			continue
		for(var/list/pentry in patrons)
			var/tier = pentry["tier"]
			var/tier_label = cleric_tier_to_short(tier)
			entries += list(list(
				"name" = "[s_name] ([tier_label])",
				"path" = path_key,
				"category" = pentry["patron"],
				"tier" = tier
			))
	entries = sortTim(entries, GLOBAL_PROC_REF(cmp_miracle_entries))
	return entries

/proc/cmp_miracle_entries(list/a, list/b)
	if(a["tier"] != b["tier"])
		return a["tier"] - b["tier"]
	return sorttext(b["name"], a["name"])

/// Get or build cached recipe detail HTML.
/datum/recipe_wiki/proc/get_cached_detail(path, mob/user)
	var/path_key = "[path]"
	if(cached_details[path_key])
		return cached_details[path_key]
	var/html = generate_recipe_detail_html(path, user)
	cached_details[path_key] = html
	return html

/client/verb/ooc_wiki()
	set name = "Encyclopedia"
	set category = "OOC"
	set desc = "Browse the Encyclopaedia Azurea - all recipe books and guidebook entries."

	var/datum/recipe_wiki/wiki = get_recipe_wiki()
	wiki.show_library(mob)
