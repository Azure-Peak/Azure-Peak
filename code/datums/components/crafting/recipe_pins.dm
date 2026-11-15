/*
// this is for pinning recipes in the craftingg and anvil menus. You can do it per round or per character.
 */

/datum/mind/var/datum/recipe_pins/recipe_pins

/mob/proc/get_recipe_pins()
	if(!mind)
		return null
	if(!mind.recipe_pins)
		var/player = ckey(mind.key)
		var/character = ckey(real_name)
		var/save_file = (player && character) ? "data/recipe_pins/[player]/[character].json" : null
		mind.recipe_pins = new /datum/recipe_pins(save_file)
	return mind.recipe_pins

/datum/recipe_pins
	var/list/pins
	var/save_file
	/// Max pins were recommended to stop abuse
	var/max_pins = 200

/datum/recipe_pins/New(save_file)
	. = ..()
	src.save_file = save_file
	pins = list("crafting" = list(), "anvil" = list())
	load()

//verify the path for the pin is valid for the menu, and that it exists, useful with PRs deleting recipes
/datum/recipe_pins/proc/valid_path(menu, path_text)
	if(!istext(path_text))
		return FALSE
	var/recipe_path = text2path(path_text)
	if(!recipe_path)
		return FALSE
	switch(menu)
		if("crafting")
			return ispath(recipe_path, /datum/crafting_recipe)
		if("anvil")
			return ispath(recipe_path, /datum/anvil_recipe)
	return FALSE

/datum/recipe_pins/proc/cycle(menu, path_text)
	if(!valid_path(menu, path_text))
		return FALSE
	var/list/menu_pins = pins[menu]
	var/old_scope = menu_pins[path_text]
	var/new_scope
	if(isnull(old_scope))
		if(length(menu_pins) >= max_pins)
			return FALSE
		new_scope = "round"
	else if(old_scope == "round")
		new_scope = save_file ? "saved" : null
	else
		new_scope = null

	if(new_scope)
		menu_pins[path_text] = new_scope
	else
		menu_pins -= path_text

	if(old_scope == "saved" || new_scope == "saved")
		save()
	return TRUE

/datum/recipe_pins/proc/save()
	if(!save_file)
		return
	var/list/to_save = list()
	for(var/menu in pins)
		var/list/saved_paths = list()
		for(var/path_text in pins[menu])
			if(pins[menu][path_text] == "saved")
				saved_paths += path_text
		to_save[menu] = saved_paths
	fdel(save_file)
	text2file(json_encode(to_save), save_file)

/datum/recipe_pins/proc/load()
	if(!save_file || !fexists(save_file))
		return
	var/list/stored = json_decode(file2text(save_file))
	if(!islist(stored))
		return
	for(var/menu in pins)
		var/list/saved_paths = stored[menu]
		if(!islist(saved_paths))
			continue
		for(var/path_text in saved_paths)
			if(valid_path(menu, path_text) && length(pins[menu]) < max_pins)
				pins[menu][path_text] = "saved"
