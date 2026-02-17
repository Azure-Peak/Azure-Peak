/// TGUI Loadout Menu - Opened from character preferences to select loadout items within a point budget.
/// Uses a name-keyed associative list (gear_list) with per-item metadata for color, custom name, and custom description.
/// Based on Bay / Eris / Sojourn loadout menu with a different UI but the same save format.
#define LOADOUT_MAX_POINTS 10
#define LOADOUT_MAX_DESC_LEN 1024

/datum/loadout_menu
	var/client/owner
	var/list/gear_list = list()

/datum/loadout_menu/New(client/C)
	owner = C
	if(C?.prefs)
		// Deep copy so we don't modify prefs until it is confirmed
		gear_list = deepCopyList(C.prefs.gear_list)

/datum/loadout_menu/Destroy()
	owner = null
	return ..()

/datum/loadout_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoadoutMenu", "Loadout")
		ui.open()

/datum/loadout_menu/ui_static_data(mob/user)
	var/list/data = list()

	// Build category list and items catalog - this won't change during the session
	var/list/categories = list()
	var/list/items = list()

	for(var/item_name as anything in GLOB.loadout_items_by_name)
		var/datum/loadout_item/LI = GLOB.loadout_items_by_name[item_name]
		if(LI.donoritem && !LI.donator_ckey_check(user.ckey))
			continue

		var/cat = LI.sort_category
		categories |= cat

		// Detect color channels dynamically from the item's compiled defaults
		var/obj/item/target = LI.path
		var/list/color_channels = list("primary")
		if(ispath(LI.path, /obj/item))
			if(initial(target.detail_tag))
				color_channels += "detail"
			if(initial(target.altdetail_tag))
				color_channels += "altdetail"

		items += list(list(
			"name" = LI.name,
			"desc" = LI.desc,
			"category" = cat,
			"cost" = LI.cost,
			"triumph_cost" = LI.triumph_cost,
			"color_channels" = color_channels
		))

	data["categories"] = categories
	data["items"] = items
	data["max_points"] = LOADOUT_MAX_POINTS
	return data

/datum/loadout_menu/ui_data(mob/user)
	var/list/data = list()

	// Current selections with metadata
	var/list/selected = list()
	var/total_cost = 0
	var/total_triumph_cost = 0
	for(var/item_name in gear_list)
		var/datum/loadout_item/LI = GLOB.loadout_items_by_name[item_name]
		if(!LI)
			continue
		total_cost += LI.cost
		if(LI.triumph_cost)
			total_triumph_cost += LI.triumph_cost
		var/list/meta = gear_list[item_name]
		if(!islist(meta))
			meta = list()
		selected += list(list(
			"name" = item_name,
			"color" = meta["color"],
			"detail_color" = meta["detail_color"],
			"altdetail_color" = meta["altdetail_color"],
			"custom_name" = meta["custom_name"],
			"custom_desc" = meta["custom_desc"]
		))

	data["selected"] = selected
	data["total_cost"] = total_cost
	data["total_triumph_cost"] = total_triumph_cost
	data["player_triumphs"] = user.get_triumphs() || 0
	return data

/datum/loadout_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("toggle_item")
			var/item_name = params["name"]
			if(!item_name)
				return TRUE
			if(item_name in gear_list)
				gear_list -= item_name
			else
				var/datum/loadout_item/LI = GLOB.loadout_items_by_name[item_name]
				if(!LI)
					return TRUE
				var/total_cost = 0
				for(var/existing_name in gear_list)
					var/datum/loadout_item/existing = GLOB.loadout_items_by_name[existing_name]
					if(existing)
						total_cost += existing.cost
				if((total_cost + LI.cost) <= LOADOUT_MAX_POINTS)
					gear_list[item_name] = list()
			return TRUE

		if("set_color", "set_detail_color", "set_altdetail_color")
			var/item_name = params["name"]
			if(!item_name || !(item_name in gear_list))
				return TRUE
			var/list/meta = gear_list[item_name]
			if(!islist(meta))
				meta = list()
				gear_list[item_name] = meta
			// Determine which meta key to set
			var/meta_key
			switch(action)
				if("set_color")
					meta_key = "color"
				if("set_detail_color")
					meta_key = "detail_color"
				if("set_altdetail_color")
					meta_key = "altdetail_color"
			if(params["clear"])
				meta -= meta_key
			else
				// Open color picker modal with dye presets
				var/current = meta[meta_key] || "#FFFFFF"
				var/picked = tgui_color_picker(ui.user, "Choose color for [item_name]", "Color Picker", current, named_presets = COLOR_MAP)
				if(picked)
					// sanitize_hexcolor returns without #, so prepend it
					if(picked[1] != "#")
						picked = "#[picked]"
					meta[meta_key] = picked
			return TRUE

		if("set_custom_name")
			var/item_name = params["name"]
			var/custom_name = params["custom_name"]
			if(!item_name || !(item_name in gear_list))
				return TRUE
			var/list/meta = gear_list[item_name]
			if(!islist(meta))
				meta = list()
				gear_list[item_name] = meta
			if(custom_name)
				meta["custom_name"] = copytext(custom_name, 1, MAX_NAME_LEN)
			else
				meta -= "custom_name"
			return TRUE

		if("set_custom_desc")
			var/item_name = params["name"]
			var/custom_desc = params["custom_desc"]
			if(!item_name || !(item_name in gear_list))
				return TRUE
			var/list/meta = gear_list[item_name]
			if(!islist(meta))
				meta = list()
				gear_list[item_name] = meta
			if(custom_desc)
				meta["custom_desc"] = copytext(custom_desc, 1, LOADOUT_MAX_DESC_LEN)
			else
				meta -= "custom_desc"
			return TRUE

		if("confirm")
			if(owner?.prefs)
				owner.prefs.gear_list = gear_list
				owner.prefs.save_character()
			ui.close()
			return TRUE

#undef LOADOUT_MAX_POINTS
#undef LOADOUT_MAX_DESC_LEN
