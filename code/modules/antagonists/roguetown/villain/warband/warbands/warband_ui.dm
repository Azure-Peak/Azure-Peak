// gets the warband associated with the user
// creates an instance of the BEGIN hud (the thing we're using for warband & character creation)
/atom/movable/screen/warband/manager/proc/create_HUD_instance(mob/user)
	for(var/atom/movable/screen/warband/manager/listed_manager in SSwarbands.warband_managers)
		if(listed_manager.warband_ID == user.mind.warband_ID)
			user.client.screen += listed_manager
			animate(listed_manager, alpha = 255, time = 800)
			break

////////////////////////
//////////////////////////////////////////////// UI DATA
////////////////////////
/atom/movable/screen/warband/manager/Click()
	src.ui_interact(usr)

/atom/movable/screen/warband/manager/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WarbandCreation")
		ui.open()

/atom/movable/screen/warband/manager/ui_data(mob/user)
	var/list/data = ..()

	var/finalized_status = src.finalized
	var/user_role = user.mind.special_role
	var/list/noble_list = list()
	var/list/allies_list = list()

	data["creation_stage"] = src.creation_stage
	data["warlord_spawned"] = src.warlord_spawned
	data["is_warlord"] = (user_role == "Warlord")
	data["user_role"] = user_role
	data["finalized_status"] = finalized_status

	var/remaining_time = get_remaining_time()
	if(remaining_time >= 0)
		data["time_remaining"] = remaining_time
		data["timer_active"] = TRUE
	else
		data["time_remaining"] = 0
		data["timer_active"] = FALSE

	// a list of important figures in town | used in the 'know thy enemy' list in the creation menu | helps in plotting an initial gimmick
	for(var/mob/living/carbon/human/quote_importantperson_unquote in src.importantfigures)
		UNTYPED_LIST_ADD(noble_list, list(
			"name" = quote_importantperson_unquote.real_name,
			"job" = quote_importantperson_unquote.job
		))
	data["nobles"] = noble_list

	// a list of teammates (living)
	for(var/mob/living/carbon/human/buddy in src.members)	
		var/member_role = buddy.mind?.special_role || "Unknown"
		UNTYPED_LIST_ADD(allies_list, list(
			"name" = buddy.real_name,
			"job" = buddy.job,
			"special_role" = member_role,
			"in_lobby" = FALSE
		))

	// a list of teammates (in the lobby)
	for(var/mob/living/lobby_member in src.lobby_members)
		if(!lobby_member.client || !lobby_member.client.prefs)
			continue
		var/char_name = lobby_member.client.prefs.real_name
		var/member_role = lobby_member.mind?.special_role || "Unknown"
		UNTYPED_LIST_ADD(allies_list, list(
			"name" = char_name,
			"job" = member_role,
			"in_lobby" = TRUE
		))
	data["allies"] = allies_list	
	return data

/atom/movable/screen/warband/manager/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/storyteller_list = list()
	var/list/warbands_list = list()
	var/list/subtypes_list = list()
	var/list/aspects_list = list()
	var/list/class_list = list()

	var/list/backend_warband_list = list()
	var/list/backend_subtype_list = list()
	var/list/backend_aspects_list = list()

	if(src.selected_warband)
		UNTYPED_LIST_ADD(backend_warband_list, list(
			"title" = selected_warband.title,
			"summary" = selected_warband.summary,
			"storyinfluence" = selected_warband.storytellerlimit,
			"subtyperequired" = selected_warband.subtyperequired,
			"rarity" = selected_warband.rarity,
			"subtypes" = selected_warband.subtypes,
			"aspects" = selected_warband.aspects,
			"points" = selected_warband.points,
			"type" = selected_warband.type,
			"warlordclasses" = selected_warband.warlordclasses,
			"lieuclasses" = selected_warband.lieutenantclasses,
			"gruntclasses" = selected_warband.gruntclasses
		))
	data["backend_warband"] = backend_warband_list

	if(src.selected_subtype)
		UNTYPED_LIST_ADD(backend_subtype_list, list(
			"title" = selected_subtype.title,
			"summary" = selected_subtype.summary,
			"storyinfluence" = selected_subtype.storytellerlimit,
			"rarity" = selected_subtype.rarity,
			"aspects" = selected_subtype.aspects,
			"points" = selected_subtype.points,
			"type" = selected_subtype.type,
			"warlordclasses" = selected_subtype.warlordclasses,
			"lieuclasses" = selected_subtype.lieutenantclasses,
			"gruntclasses" = selected_subtype.gruntclasses
		))
	data["backend_subtype"] = backend_subtype_list

	for(var/datum/warbands/aspects/selected_aspect in src.selected_aspects)
		UNTYPED_LIST_ADD(backend_aspects_list, list(
			"title" = selected_aspect.title,
			"summary" = selected_aspect.summary,
			"storyinfluence" = selected_aspect.storytellerlimit,
			"rarity" = selected_aspect.rarity,
			"class" = selected_aspect.asclass,
			"points" = selected_aspect.points,
			"type" = selected_aspect.type,
			"warlordclasses" = selected_aspect.warlordclasses,
			"lieuclasses" = selected_aspect.lieutenantclasses,
			"gruntclasses" = selected_aspect.gruntclasses
		))
	data["backend_aspects"] = backend_aspects_list

	if(!static_data_set) // we want to be absolutely sure we're only checking storytellers Once
		for(var/datum/storyteller/storyteller in src.storyinfluence)
			UNTYPED_LIST_ADD(storyteller_list, list(
				"title" = storyteller.name,
				"summary" = storyteller.desc,
				"type" = storyteller.type
			))
	data["backendstorytellers"] = storyteller_list

	for(var/datum/warbands/warband in src.warbands)
		UNTYPED_LIST_ADD(warbands_list, list(
			"title" = warband.title,
			"summary" = warband.summary,
			"storyinfluence" = warband.storytellerlimit,
			"subtyperequired" = warband.subtyperequired,
			"rarity" = warband.rarity,			
			"subtypes" = warband.subtypes,
			"aspects" = warband.aspects,
			"points" = warband.points,
			"type" = warband.type,
			"warlordclasses" = warband.warlordclasses,
			"lieuclasses" = warband.lieutenantclasses,
			"gruntclasses" = warband.gruntclasses
		))
	data["warbands"] = warbands_list

	for(var/datum/warbands/subtypes/subtype in src.subtypes)
		UNTYPED_LIST_ADD(subtypes_list, list(
			"title" = subtype.title,
			"summary" = subtype.summary,
			"storyinfluence" = subtype.storytellerlimit,
			"rarity" = subtype.rarity,
			"aspects" = subtype.aspects,
			"points" = subtype.points,
			"type" = subtype.type,
			"quote" = subtype.quote,
			"quote_followup" = subtype.quote_followup,
			"warlordclasses" = subtype.warlordclasses,
			"lieuclasses" = subtype.lieutenantclasses,
			"gruntclasses" = subtype.gruntclasses
		))
	data["subtypes"] = subtypes_list

	for(var/datum/warbands/aspects/aspect in src.aspects)
		UNTYPED_LIST_ADD(aspects_list, list(
			"title" = aspect.title,
			"summary" = aspect.summary,
			"storyinfluence" = aspect.storytellerlimit,
			"rarity" = aspect.rarity,
			"class" = aspect.asclass,
			"points" = aspect.points,
			"type" = aspect.type,
			"warlordclasses" = aspect.warlordclasses,
			"lieuclasses" = aspect.lieutenantclasses,
			"gruntclasses" = aspect.gruntclasses
		))
	data["aspects"] = aspects_list

	for(var/datum/advclass/class in src.classes)
		UNTYPED_LIST_ADD(class_list, list(
			"name" = class.title,
			"desc" = class.tutorial,
			"alt_name" = class.name,
			"storyinfluence" = class.storytellerlimit,
			"rarity" = class.rarity,
			"slots" = class.maximum_possible_slots,
			"type" = class.type
		))
	data["classes"] = class_list
	src.static_data_set = TRUE
	return data


/atom/movable/screen/warband/manager/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr

	var/user_key = user.ckey
	if(last_action_time[user_key] && world.time < last_action_time[user_key] + 10)
		return TRUE // slight throttling to all of the UI actions
	
	last_action_time[user_key] = world.time

	switch(action)
		if("swap_character_slot")
			select_pref_slot(user)
		if("refresh")
			update_static_data(user, ui)
		if("edit_character")
			user.client.prefs.current_tab = 1
			user.client.prefs.ShowChoices(usr, 4)
		if("create_character")
			if(user.mind.special_role == "Warlord")
				to_chat(user, span_warning("Use the finalize button to complete your warband."))
				return
			if(!src.warlord_spawned)
				to_chat(user, span_warning("Wait for the Warlord to be finalized, first."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			SStgui.close_user_uis(user)
			user.mind.warband_manager = src
			var/class_path = text2path(params["class"])
			var/subclass_path = text2path(params["subclass"])
			if(user in src.lobby_members)
				lobby_members -= user
			load_appearance(user, user)
			lock_check(user)
			var/latespawn = user.mind.warband_latespawn
			spawn_character(class_path, user, subclass_path, is_leader = 0, is_latespawn = latespawn)
			end_intro(user)
			return
		if("advance_stage")
			if(user.mind.special_role != "Warlord")
				to_chat(user, span_warning("Only the Warlord can advance stages."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			if(src.creation_stage != 1)
				return
			
			var/warband_path = text2path(params["warband"])
			if(warband_path && SSwarbands.warband_lookup[warband_path])
				src.selected_warband = SSwarbands.warband_lookup[warband_path]
			var/subtype_path = text2path(params["subtype"])
			if(subtype_path && SSwarbands.subtype_lookup[subtype_path])
				src.selected_subtype = SSwarbands.subtype_lookup[subtype_path]
			var/list/aspect_paths = params["aspects"]
			for(var/aspect_path in aspect_paths)
				var/aspect_type = text2path(aspect_path)
				if(aspect_type && SSwarbands.aspect_lookup[aspect_type])
					src.selected_aspects += SSwarbands.aspect_lookup[aspect_type]

			src.creation_stage = 2
			envy_check() // check for Throne of Envy once a warband is locked in, so we can update any lieutenants
			set_race_and_faith_locks()
			notify_sect()
			send_warnings() // send a warning to a non-warband player
			for(var/mob/living/carbon/human/member in src.lobby_members)
				to_chat(member, span_greenteamradio("The Warlord has advanced to class selection. You may now choose your class."))
				SStgui.update_uis(member)
				update_static_data(member)
			return

		// warband finalization
		// spawns the map
		if("create_warband")
			if(user.mind.special_role != "Warlord")
				to_chat(user, span_warning("Only the Warlord may finalize the warband."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			if(src.creation_stage != 2)
				to_chat(user, span_warning("Select a Warband first."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			if(SSwarbands.warband_managers_busy == TRUE)
				to_chat(src, span_bold("Warband Generation is occupied. Please wait."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			SSwarbands.warband_managers_busy = TRUE
			SStgui.close_user_uis(user)
			var/class_path = text2path(params["class"])
			var/subclass_path = text2path(params["subclass"])
			if(user in src.lobby_members)
				lobby_members -= user
			load_appearance(user, user)
			lock_check(user) 		// checks if the warlord is breaking any faith or species limits, and corrects them if so
			apply_sect_faithlock(user)
			spawn_warband(user) 	// this spawns the map, too
			set_IDs()
			spawn_character(class_path, user, subclass_path, is_leader = 1)			
			set_default_exit()
			
			src.warlord_spawned = TRUE
			SSwarbands.warband_managers_busy = FALSE
			src.finalized = TRUE
			user.mind.warband_manager = src
			end_intro(user)
			for(var/mob/living/carbon/human/member in src.lobby_members) 
				if(member.mind.special_role == "Lieutenant" || member.mind.special_role == "Aspirant Lieutenant" || member.mind.special_role == "Grunt")
					to_chat(member, span_greenteamradio("The Warlord has established the warband. You may now finalize your character."))
					member.playsound_local(member, 'sound/misc/warband/menusound3.ogg', 100, FALSE)
			return

		if("interaction_sound")
			user.playsound_local(user, 'sound/misc/warband/menusound1.ogg', 100, FALSE)
			return

		// view a list of the current laws
		if("view_laws")
			to_chat(user, span_greenteamradio("AZURIA'S LAWS ARE AS FOLLOWS:"))
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
			for(var/law in GLOB.laws_of_the_land)
				to_chat(user, span_memo(law))
			return

		// view a list of the current decrees
		if("view_decrees")
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
			for(var/decree in GLOB.lord_decrees)
				to_chat(user, span_memo(decree))
			return

		// view the flavortext of a given character
		if("view_vip")
			var/returned_vip = params["enemy"]
			var/returned_ally = params["ally"]
			var/mob/living/carbon/human/matched_vip

			for(var/mob/living/carbon/human/vip in src.importantfigures)
				if(vip.real_name == returned_vip)
					matched_vip = vip
					break

			for(var/mob/living/carbon/human/pal in src.members)
				if(pal.real_name == returned_ally)
					matched_vip = pal
					break

			if(matched_vip)
				if(!ismob(usr))
					return
				SStgui.close_user_uis(usr, /datum/examine_panel)
				var/datum/examine_panel/mob_examine_panel = new(matched_vip)
				mob_examine_panel.holder = matched_vip
				mob_examine_panel.viewing = usr
				mob_examine_panel.ui_interact(usr)
				return
			else
				return

/atom/movable/screen/warband/manager/ui_close(mob/user, datum/tgui/ui)
	. = ..()

/atom/movable/screen/warband/manager/ui_status(mob/user)
	if(user)
		return UI_INTERACTIVE
	return ..()
