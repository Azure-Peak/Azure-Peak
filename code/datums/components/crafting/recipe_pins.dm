/datum/mind/var/datum/recipe_pins/recipe_pins

/mob/proc/get_recipe_pins()
	if(!mind)
		return null
	if(!mind.recipe_pins)
		mind.recipe_pins = new /datum/recipe_pins(ckey(real_name))
	return mind.recipe_pins

/datum/recipe_pins
	var/list/pins
	var/list/imported
	var/pin_key

/datum/recipe_pins/New(pin_key)
	. = ..()
	src.pin_key = pin_key
	pins = list(RECIPE_PIN_MENU_CRAFTING = list(), RECIPE_PIN_MENU_ANVIL = list())
	imported = list()

/datum/recipe_pins/proc/valid_path(menu, path_text)
	if(!istext(path_text))
		return FALSE
	var/recipe_path = text2path(path_text)
	if(!recipe_path)
		return FALSE
	switch(menu)
		if(RECIPE_PIN_MENU_CRAFTING)
			return ispath(recipe_path, /datum/crafting_recipe)
		if(RECIPE_PIN_MENU_ANVIL)
			return ispath(recipe_path, /datum/anvil_recipe)
	return FALSE

/datum/recipe_pins/proc/cycle(mob/user, menu, path_text)
	if(!valid_path(menu, path_text))
		return FALSE
	var/list/menu_pins = pins[menu]
	var/old_scope = menu_pins[path_text]
	var/new_scope
	if(isnull(old_scope))
		if(length(menu_pins) >= MAX_RECIPE_PINS)
			to_chat(user, span_warning("You cannot pin more than [MAX_RECIPE_PINS] recipes."))
			return FALSE
		new_scope = RECIPE_PIN_ROUND
	else if(old_scope == RECIPE_PIN_ROUND)
		new_scope = RECIPE_PIN_SAVED
	else
		new_scope = null

	if(new_scope)
		menu_pins[path_text] = new_scope
	else
		menu_pins -= path_text
	return TRUE

/datum/recipe_pins/proc/import_saved(menu, list/paths)
	if(!islist(pins[menu]) || imported[menu])
		return FALSE
	imported[menu] = TRUE
	if(!islist(paths))
		return TRUE
	var/list/menu_pins = pins[menu]
	var/checked = 0
	for(var/path_text in paths)
		if(++checked > MAX_RECIPE_PINS || length(menu_pins) >= MAX_RECIPE_PINS)
			break
		if(!valid_path(menu, path_text))
			continue
		if(!isnull(menu_pins[path_text]))
			continue
		menu_pins[path_text] = RECIPE_PIN_SAVED
	return TRUE
