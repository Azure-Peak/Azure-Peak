/*
// this is for pinning recipes in the craftingg and anvil menus. You can do it per round or per character.
// This is done locally per ckey, so a new ckey will need to build its pinlist again and can't be edited or saved server side.
 */

/datum/mind/var/datum/recipe_pins/recipe_pins

/mob/proc/get_recipe_pins()
	if(!mind)
		return null
	if(!mind.recipe_pins)
		mind.recipe_pins = new /datum/recipe_pins(ckey(real_name))
	return mind.recipe_pins

/datum/recipe_pins
	var/list/pins
	var/pin_key
	/// Max pins were recommended to stop abuse
	var/max_pins = 200

/datum/recipe_pins/New(pin_key)
	. = ..()
	src.pin_key = pin_key
	pins = list("crafting" = list(), "anvil" = list())

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
		new_scope = "saved"
	else
		new_scope = null

	if(new_scope)
		menu_pins[path_text] = new_scope
	else
		menu_pins -= path_text
	return TRUE

/datum/recipe_pins/proc/import_saved(menu, list/paths)
	if(!islist(paths) || !islist(pins[menu]))
		return FALSE
	var/list/menu_pins = pins[menu]
	var/checked = 0
	for(var/path_text in paths)
		if(++checked > max_pins || length(menu_pins) >= max_pins)
			break
		if(!valid_path(menu, path_text))
			continue
		if(!isnull(menu_pins[path_text]))
			continue
		menu_pins[path_text] = "saved"
	return TRUE
