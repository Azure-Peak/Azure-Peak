/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	// This is where we decide to update the UI and call ShowChoices to update it if we took any action
	. = ui_act_all_pages(action, params, ui, state)
	if(.)
		if(. == CHARACTER_ACT_PREVIEW_UPDATE)
			character_preview_view?.update_body()
		ShowChoices(ui.user)
		return

	. = ui_act_popup(action, params, ui, state)
	if(.)
		if(. == CHARACTER_ACT_PREVIEW_UPDATE)
			character_preview_view?.update_body()
		ShowChoices(ui.user)
		return

	. = ui_act_for_tab(action, params, ui, state)
	if(.)
		if(. == CHARACTER_ACT_PREVIEW_UPDATE)
			character_preview_view?.update_body()
		ShowChoices(ui.user)
		return

/datum/preferences/proc/ui_act_all_pages(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user
	switch(action)
		if("change_tab")
			character_preview_view.hide_from(ui.user)
			current_tab = clamp(text2num(params["tab"]), PREFERENCE_TAB_CHARACTER_CREATOR, PREFERENCE_TAB_KEYBINDINGS)
			if(current_tab == PREFERENCE_TAB_CHARACTER_CREATOR)
				character_preview_view.display_to(ui.user)
			// no need to do CHARACTER_ACT_PREVIEW_UPDATE because we won't have changed the body, just display status
			return CHARACTER_ACT_DATA_UPDATE
		if("bancheck")
			var/role_to_check = params["bancheck"]
			var/list/ban_details = is_banned_from_with_details(parent.ckey, parent.address, parent.computer_id, role_to_check)
			var/admin = FALSE
			if(GLOB.admin_datums[parent.ckey] || GLOB.deadmins[parent.ckey])
				admin = TRUE
			for(var/i in ban_details)
				if(admin && !text2num(i["applies_to_admins"]))
					continue
				ban_details = i
				break //we only want to get the most recent ban's details
			if(LAZYLEN(ban_details))
				var/expires = "This is a permanent ban."
				if(ban_details["expiration_time"])
					expires = " The ban is for [DisplayTimeText(text2num(ban_details["duration"]) MINUTES)] and expires on [ban_details["expiration_time"]] (server time)."
				to_chat(user, span_danger("You, or another user of this computer or connection ([ban_details["key"]]) is banned from playing [role_to_check].<br>The ban reason is: [ban_details["reason"]]<br>This ban (BanID #[ban_details["id"]]) was applied by [ban_details["admin_key"]] on [ban_details["bantime"]] during round ID [ban_details["round_id"]].<br>[expires]"))
			return CHARACTER_ACT_DATA_UPDATE

/datum/preferences/proc/ui_act_for_tab(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(current_tab)
		if(PREFERENCE_TAB_CHARACTER_CREATOR)
			. = ui_act_character_creator(action, params, ui, state)
		if(PREFERENCE_TAB_GAME_SETTINGS)
			. = ui_act_game_settings(action, params, ui, state)
		if(PREFERENCE_TAB_KEYBINDINGS)
			. = ui_act_keybinds(action, params, ui, state)
