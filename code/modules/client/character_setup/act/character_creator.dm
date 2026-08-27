// In this folder, all of our different pages are split up into separate sub-procs

/datum/preferences
	COOLDOWN_DECLARE(ui_refresh_cooldown)

/datum/preferences/proc/ui_act_character_creator(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ui_act_character_creator_all_pages(action, params, ui, state)
	if(.)
		return

	. = ui_act_character_creator_appearance(action, params, ui, state)
	if(.)
		return

	. = ui_act_character_creator_classes(action, params, ui, state)
	if(.)
		return

	. = ui_act_character_creator_descriptors(action, params, ui, state)
	if(.)
		return

	. = ui_act_character_creator_identity(action, params, ui, state)
	if(.)
		return

	. = ui_act_character_creator_villain(action, params, ui, state)
	if(.)
		return

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/ui_act_character_creator(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	// helpers/switch(action) as needed
*/

/datum/preferences/proc/ui_act_character_creator_all_pages(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("export_save")
			user.client.export_savefile()
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("playerquality")
			check_pq_menu(user.ckey)
			return CHARACTER_ACT_DATA_UPDATE
		if("triumphs")
			user.show_triumphs_list()
			return CHARACTER_ACT_DATA_UPDATE
		if("agevet")
			if(!user.check_agevet())
				to_chat(user, span_info("- You are a whitelisted player with full access to the server's features. If you'd also like to show others that you've been <b>AGE-VERIFIED</b> with a censored ID, you can open a ticket in Azure Peak's <b>#vet-here</b> channel. If you are already verified on Discord, but not in-game, ahelp. Note that this is a purely optional process, and - besides awarding a special header for your flavortext - doesn't affect you in any other way."))
			else
				to_chat(user, span_love("- You have been successfully <b>AGE-VERIFIED!</b>"))
			return CHARACTER_ACT_DATA_UPDATE
		if("changelog")
			user.client.changelog()
			return CHARACTER_ACT_DATA_UPDATE
		if("save")
			save_preferences()
			save_character()
			verbose_pref_log_notification(user, "notice", "Character Saved")
			// Always tell them even if they have the other notices turned off
			if(!verbose_character_creator)
				to_chat(user, span_notice("Character Saved."))
			return CHARACTER_ACT_DATA_UPDATE
		if("load")
			load_preferences()
			load_character()
			verbose_pref_log_notification(user, "danger", "Character Reloaded from Savefile")
			// Always tell them even if they have the other notices turned off
			if(!verbose_character_creator)
				to_chat(user, span_danger("Character Reloaded from Savefile."))
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("refresh_character_preview")
			if(!character_preview_view || !COOLDOWN_FINISHED(src, ui_refresh_cooldown))
				return
			COOLDOWN_START(src, ui_refresh_cooldown, 5 SECONDS)
			character_preview_view.update_body()
			// People are mostly going to click this when they encounter the ByondUI resizing bug, so we need to manually force a re-layout
			INVOKE_ASYNC(character_preview_view, TYPE_PROC_REF(/atom/movable/screen/map_view/char_preview, jiggle_map))
			return CHARACTER_ACT_DATA_UPDATE
		if("rotate_character_preview")
			character_preview_view?.setDir(turn(character_preview_view.dir, -90))
			return CHARACTER_ACT_DATA_UPDATE
		if("set_preview_background")
			character_preview_view?.preview_background.set_background(params["bg"])
			return CHARACTER_ACT_DATA_UPDATE
		if("headshot")
			to_chat(user, span_notice("Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
			to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
			to_chat(user, span_notice("Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look."))
			var/new_headshot_link = tgui_input_text(user, "Input the headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox, file garden):", "Headshot", headshot_link, max_length = MAX_MESSAGE_LEN, encode = FALSE)
			if(new_headshot_link == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_headshot_link == "")
				verbose_pref_log_change(user, "notice", "Headshot", html_encode(headshot_link), "")
				headshot_link = null
				return CHARACTER_ACT_DATA_UPDATE
			if(!valid_headshot_link(user, new_headshot_link))
				to_chat(user, span_notice("Invalid image link. Make sure it's a direct link from a valid host (gyazo, discord, lensdump, imgbox, catbox, file garden)."))
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Headshot", html_encode(headshot_link), html_encode(new_headshot_link))
			headshot_link = new_headshot_link
			log_game("[user] has set their Headshot image to '[html_encode(headshot_link)]'.")
			return CHARACTER_ACT_DATA_UPDATE
