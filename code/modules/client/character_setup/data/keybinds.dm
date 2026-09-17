/datum/preferences/proc/ui_data_keybinds(mob/user)
	var/list/data = list(
		"keybindings" = list(),
	)

	// Create an inverted list of keybindings -> key
	var/list/user_binds = list()
	for(var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)

	var/list/kb_categories = list()
	// Group keybinds by category
	for(var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		kb_categories[kb.category] += list(kb)

	var/list/keybindings = list()
	for(var/category in kb_categories)
		for(var/i in kb_categories[category])
			var/datum/keybinding/kb = i
			
			UNTYPED_LIST_ADD(keybindings, list(
				"full_name" = kb.full_name,
				"name" = kb.name,
				"default_keys" = kb.hotkey_keys,
				"user_binds" = user_binds[kb.name]
			))

	data["keybindings"] = keybindings

	return data
