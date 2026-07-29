/// TGUI Customization menu - replaces the legacy "customization" browser window.
/// Mutations reuse handle_customizer_topic() so behavior matches the legacy menu.
/datum/customizer_menu
	var/datum/preferences/prefs

/datum/customizer_menu/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/customizer_menu/Destroy()
	prefs = null
	return ..()

/datum/customizer_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/customizer_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterCustomizer")
		ui.open()

/datum/customizer_menu/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/customizer_menu/ui_data(mob/user)
	var/list/data = list()
	var/list/customizers_out = list()
	for(var/customizer_type in prefs.pref_species?.customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer.is_allowed(prefs))
			continue
		var/datum/customizer_entry/entry = prefs.get_customizer_entry_for_customizer_type(customizer_type)
		if(!entry)
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/list/card = list(
			"type" = "[customizer_type]",
			"name" = customizer.name,
			"disabled" = entry.disabled,
			"allows_disabling" = customizer.allows_disabling,
			"choice_name" = choice.name,
			"multiple_choices" = length(customizer.customizer_choices) > 1,
			"accessory" = null,
			"colors" = list(),
			"extra" = list(),
		)
		if(!entry.disabled)
			if(choice.sprite_accessories && entry.accessory_type)
				// Imported/stale saves can reference accessories or color counts that no
				// longer exist here — degrade gracefully instead of runtiming the menu blank.
				var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
				if(accessory)
					card["accessory"] = list(
						"name" = accessory.name,
						"multiple" = length(choice.sprite_accessories) > 1,
					)
					if(choice.allows_accessory_color_customization && !accessory.color_disabled)
						var/list/color_list = color_string_to_list(entry.accessory_colors)
						var/list/colors = list()
						for(var/index in 1 to accessory.color_keys)
							var/named_index = (accessory.color_keys == 1) ? accessory.color_key_name : LAZYACCESS(accessory.color_key_names, index)
							colors += list(list(
								"index" = index,
								"name" = named_index || "Color [index]",
								"color" = (index <= length(color_list)) ? color_list[index] : "FFFFFF",
							))
						card["colors"] = colors
			card["extra"] = choice.get_extra_pref_controls(prefs, entry)
		customizers_out += list(card)
	data["customizers"] = customizers_out
	return data

/datum/customizer_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user?.client || !prefs)
		return
	if(action != "customizer_task")
		return
	var/list/href_list = list(
		"task" = "change_customizer",
		"customizer" = "[params["customizer"]]",
		"customizer_task" = "[params["customizer_task"]]",
	)
	if(params["rotate"])
		href_list["rotate"] = "[params["rotate"]]"
	if(params["color_index"])
		href_list["color_index"] = "[params["color_index"]]"
	prefs.handle_customizer_topic(user, href_list)
	prefs.update_preview_icon()
	return TRUE
