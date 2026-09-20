/datum/preferences/proc/ui_act_popup_customizer_select(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action != "change_customizer_popup")
		return FALSE

	var/customizer_type = text2path(params["customizer"])
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	if(!customizer)
		return CHARACTER_ACT_DATA_UPDATE

	var/datum/customizer_entry/current_entry = get_customizer_entry_for_customizer_type(customizer_type)
	if(!current_entry)
		return CHARACTER_ACT_DATA_UPDATE

	var/datum/customizer_choice/current_choice = CUSTOMIZER_CHOICE(current_entry.customizer_choice_type)
	if(!current_choice)
		return CHARACTER_ACT_DATA_UPDATE

	var/mob/user = ui.user
	switch(params["task"])
		if("change_choice")
			var/datum/customizer_choice/new_choice = CUSTOMIZER_CHOICE(text2path(params["choice"]))
			if(!new_choice)
				return CHARACTER_ACT_DATA_UPDATE
			if(!(new_choice.type in customizer.customizer_choices))
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Feature [customizer.name] choice", current_choice.name, new_choice.name)
			customizer_entries -= current_entry
			customizer_entries += customizer.create_customizer_entry(src, new_choice.type)
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("change_accessory")
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(text2path(params["acc"]))
			if(!accessory)
				return CHARACTER_ACT_DATA_UPDATE
			if(!(accessory.type in current_choice.sprite_accessories))
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/sprite_accessory/old = SPRITE_ACCESSORY(current_entry.accessory_type)
			verbose_pref_log_change(user, "notice", "Feature [customizer.name] accessory", old.name, accessory.name)
			current_choice.set_accessory_type(src, accessory.type, current_entry)
			return CHARACTER_ACT_PREVIEW_UPDATE
