/datum/preferences/proc/ui_act_game_settings(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	. = ui_act_game_settings_admin(action, params, ui, state)
	if(.)
		return

	switch(action)
		if("be_special")
			var/be_special_type = params["be_special_type"]
			if(be_special_type in be_special)
				be_special -= be_special_type
			else
				if(be_special_type in GLOB.special_roles_rogue)
					be_special += be_special_type
			return TRUE
		// these are fine because the other one is in ui_act_character_creator and that's
		// mutually exclusive via current_tab switch
		if("save")
			save_preferences()
			to_chat(user, span_notice("PREFERENCES SAVED."))
			return CHARACTER_ACT_DATA_UPDATE
		if("load")
			load_preferences()
			to_chat(user, span_notice("PREFERENCES RELOADED."))
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("tgui_theme")
			setTguiStyle(user)
			return TRUE
		if("parchment_skin")
			cycle_parchment_skin()
			return TRUE
		if("statbrowser_theme")
			cycle_statbrowser_theme()
			user.client?.apply_statbrowser_theme()
			return TRUE
		if("tgui_lock")
			tgui_lock = !tgui_lock
			return TRUE
		if("ambientocclusion")
			ambientocclusion = !ambientocclusion
			if(parent && parent.screen && parent.screen.len)
				var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in parent.screen
				PM.backdrop(parent.mob)
				PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in parent.screen
				PM.backdrop(parent.mob)
				PM = locate(/atom/movable/screen/plane_master/game_world_above) in parent.screen
				PM.backdrop(parent.mob)
			return TRUE
		if("windowflashing")
			windowflashing = !windowflashing
			return TRUE
		if("clientfps")
			var/desiredfps = tgui_input_number(user, "Choose your desired fps. (0 = synced with server tick rate (currently: [world.fps]))", "Client FPS", clientfps, 1000, 0)
			if(!isnull(desiredfps))
				clientfps = desiredfps
				parent.fps = desiredfps
			return TRUE
		if("auto_fit_viewport")
			auto_fit_viewport = !auto_fit_viewport
			if(auto_fit_viewport && parent)
				parent.fit_viewport()
			return TRUE
		if("schizo_voice")
			toggles ^= SCHIZO_VOICE
			if(toggles & SCHIZO_VOICE)
				to_chat(user, span_warning("You are now a voice.\n\
								As a voice, you will receive meditations from players asking about game mechanics!\n\
								Good voices will be rewarded with PQ for answering meditations, while bad ones are punished at the discretion of The Management."))
			else
				to_chat(user, span_warning("You are no longer a voice."))
			return TRUE
		if("no_storyteller_events")
			no_storyteller_events = !no_storyteller_events
			return TRUE
		if("verbose_character_creator")
			verbose_character_creator = !verbose_character_creator
			to_chat(user, span_notice("Verbose character creator messages turned [verbose_character_creator ? "on" : "off"]."))
			return TRUE

/datum/preferences/proc/cycle_parchment_skin()
	var/list/skins = GLOB.parchment_skins
	var/list/keys = list()
	for(var/k in skins)
		keys += k
	var/idx = keys.Find(parchment_skin)
	if(!idx)
		idx = 1
	parchment_skin = keys[(idx % keys.len) + 1]

/datum/preferences/proc/cycle_statbrowser_theme()
	var/list/themes = GLOB.statbrowser_themes
	var/list/keys = list()
	for(var/k in themes)
		keys += k
	var/idx = keys.Find(statbrowser_theme)
	if(!idx)
		idx = 1
	statbrowser_theme = keys[(idx % keys.len) + 1]

// Open the theme picker with live preview
/datum/preferences/proc/setTguiStyle(mob/user)
	var/datum/theme_picker/picker = new(user)
	picker.ui_interact(user)

/datum/preferences/proc/ui_act_game_settings_admin(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user
	if(!user.client.holder)
		return FALSE

	switch(action)
		if("hear_adminhelps")
			user.client.toggleadminhelpsound()
			return TRUE

		if("hear_prayers")
			user.client.toggle_prayer_sound()
			return TRUE

		if("announce_login")
			user.client.toggleannouncelogin()
			return TRUE

		if("combohud_lighting")
			toggles ^= COMBOHUD_LIGHTING
			return TRUE

		if("toggle_dead_chat")
			user.client.toggle_deadchat()
			return TRUE

		if("toggle_prayers")
			user.client.toggleprayers()
			return TRUE

		if("asaycolor")
			var/new_asaycolor = tgui_color_picker(user, "Choose your ASAY color:", "ASAY Color", asaycolor)
			if(new_asaycolor)
				asaycolor = new_asaycolor
			return TRUE

		if("toggle_deadmin_always")
			toggles ^= DEADMIN_ALWAYS
			return TRUE

		if("toggle_deadmin_antag")
			toggles ^= DEADMIN_ANTAGONIST
			return TRUE

		if("toggle_deadmin_head")
			toggles ^= DEADMIN_POSITION_HEAD
			return TRUE
