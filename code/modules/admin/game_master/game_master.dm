GLOBAL_LIST_EMPTY(game_masters)

#define SPAWN_CLICK_INTERCEPT_ACTION "spawn_click_intercept_action"

/proc/open_game_master_panel(client/using_client)
	if(using_client.game_master_menu)
		using_client.game_master_menu.ui_interact(using_client.mob)
		return

	using_client.game_master_menu = new /datum/game_master(using_client)

/client/proc/toggle_game_master()
	set name = "Game Master Panel"
	set category = "Game Master"
	set desc = "Spawn and direct NPCs by clicking the map."

	if(!check_rights(R_ADMIN))
		return

	open_game_master_panel(src)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Game Master Panel")

/datum/game_master
	var/client/game_master_client

	var/current_click_intercept_action

	var/selected_view = GM_VIEW_INDIVIDUAL
	var/list/pinned_factions = list()
	var/selected_filter = GM_FILTER_ALL
	var/selected_mob_name
	var/selected_faction = ""
	var/spawn_count = GM_DEFAULT_SPAWN_COUNT
	var/spawn_ai = TRUE
	var/spawn_taints_loot = TRUE
	var/spawn_dust = FALSE
	var/spawn_dust_leave_head = FALSE
	var/spawn_dust_delete_gear = FALSE
	var/spawn_click_intercept = FALSE

/datum/game_master/New(client/using_client)
	. = ..()

	game_master_client = using_client

	get_gm_spawn_roster()
	selected_mob_name = get_first_mob_name()

	GLOB.game_masters |= game_master_client

	ui_interact(game_master_client.mob)

/datum/game_master/Destroy(force, ...)
	if(game_master_client)
		if(game_master_client.click_intercept == src)
			game_master_client.click_intercept = null
		if(game_master_client.game_master_menu == src)
			game_master_client.game_master_menu = null
		GLOB.game_masters -= game_master_client
		game_master_client = null

	return ..()

/datum/game_master/proc/get_filtered_mob_names()
	var/list/names = list()
	for(var/display_name in get_gm_spawn_roster())
		if(selected_filter != GM_FILTER_ALL && GLOB.gm_spawn_roster_factions[display_name] != selected_filter)
			continue
		names += display_name
	return names

/datum/game_master/proc/get_first_mob_name()
	for(var/display_name in get_filtered_mob_names())
		return display_name

/datum/game_master/proc/get_selected_mob_type()
	return get_gm_spawn_roster()[selected_mob_name]

/datum/game_master/proc/get_selected_detail()
	var/mob/living/selected_type = get_selected_mob_type()
	if(!selected_type)
		return null

	return list(
		"name" = selected_mob_name,
		"category" = GLOB.gm_spawn_roster_factions[selected_mob_name],
		"threat" = initial(selected_type.threat_point),
		"path" = "[selected_type]",
	)

/datum/game_master/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/game_master/ui_data(mob/user)
	var/list/data = list()

	data["selected_filter"] = selected_filter
	data["selected_mob_name"] = selected_mob_name
	data["selected_faction"] = selected_faction
	data["spawn_count"] = spawn_count
	data["spawn_ai"] = spawn_ai
	data["spawn_taints_loot"] = spawn_taints_loot
	data["spawn_dust"] = spawn_dust
	data["spawn_dust_leave_head"] = spawn_dust_leave_head
	data["spawn_dust_delete_gear"] = spawn_dust_delete_gear
	data["spawn_click_intercept"] = spawn_click_intercept

	data["selected_view"] = selected_view
	data["pinned_factions"] = pinned_factions
	data["selectable_mobs"] = selected_view == GM_VIEW_WARBAND ? list() : get_filtered_mob_names()
	data["selected_detail"] = selected_view == GM_VIEW_WARBAND ? null : get_selected_detail()
	data["spawn_filters"] = GLOB.gm_spawn_filters
	data["filter_counts"] = GLOB.gm_spawn_filter_counts
	data["max_pinned"] = GM_MAX_PINNED_FACTIONS

	return data

/datum/game_master/ui_static_data(mob/user)
	var/list/data = list()

	data["spawn_factions"] = GLOB.gm_spawn_factions
	data["mob_threats"] = GLOB.gm_spawn_roster_threats

	return data

/datum/game_master/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_spawn_count")
			var/new_count = text2num(params["value"])
			if(!isnum(new_count))
				return
			spawn_count = clamp(round(new_count), 1, GM_MAX_SPAWN_COUNT)
			return TRUE

		if("set_selected_view")
			var/new_view = params["new_view"]
			if(!(new_view in list(GM_VIEW_INDIVIDUAL, GM_VIEW_WARBAND)))
				return
			selected_view = new_view
			return TRUE

		if("toggle_pin_faction")
			var/faction = params["faction"]
			if(faction == GM_FILTER_ALL || !(faction in GLOB.gm_spawn_filters))
				return
			if(faction in pinned_factions)
				pinned_factions -= faction
				return TRUE
			if(length(pinned_factions) >= GM_MAX_PINNED_FACTIONS)
				to_chat(ui.user, span_warning("You can only pin [GM_MAX_PINNED_FACTIONS] factions. Unpin one first."))
				return TRUE
			pinned_factions += faction
			return TRUE

		if("set_selected_filter")
			var/new_filter = params["new_filter"]
			if(!(new_filter in GLOB.gm_spawn_filters))
				return
			selected_filter = new_filter
			if(!(selected_mob_name in get_filtered_mob_names()))
				selected_mob_name = get_first_mob_name()
			return TRUE

		if("set_selected_mob")
			if(!get_gm_spawn_roster()[params["new_mob"]])
				return
			selected_mob_name = params["new_mob"]
			return TRUE

		if("set_selected_faction")
			var/new_faction = params["new_faction"]
			if(new_faction && !(new_faction in GLOB.gm_spawn_factions))
				return
			selected_faction = new_faction
			return TRUE

		if("toggle_spawn_ai")
			spawn_ai = !spawn_ai
			return TRUE

		if("toggle_spawn_taints_loot")
			spawn_taints_loot = !spawn_taints_loot
			return TRUE

		if("toggle_spawn_dust")
			spawn_dust = !spawn_dust
			if(!spawn_dust)
				spawn_dust_leave_head = FALSE
				spawn_dust_delete_gear = FALSE
			return TRUE

		if("toggle_spawn_dust_leave_head")
			spawn_dust_leave_head = !spawn_dust_leave_head
			if(spawn_dust_leave_head)
				spawn_dust = TRUE
			return TRUE

		if("toggle_spawn_dust_delete_gear")
			spawn_dust_delete_gear = !spawn_dust_delete_gear
			if(spawn_dust_delete_gear)
				spawn_dust = TRUE
			return TRUE

		if("toggle_click_spawn")
			if(spawn_click_intercept)
				reset_click_overrides()
				return TRUE

			reset_click_overrides()
			spawn_click_intercept = TRUE
			current_click_intercept_action = SPAWN_CLICK_INTERCEPT_ACTION
			return TRUE

		if("delete_spawned_all")
			if(tgui_alert(ui.user, "Delete every admin-spawned mob in the world?", "Confirmation", list("Yes", "No")) != "Yes")
				return TRUE

			var/deleted = 0
			for(var/mob/living/cycled_mob in GLOB.mob_living_list)
				if(!(cycled_mob.flags_1 & ADMIN_SPAWNED_1))
					continue
				if(cycled_mob.client || cycled_mob.mind || cycled_mob.ckey)
					continue
				qdel(cycled_mob)
				deleted++

			log_admin("[key_name(ui.user)] deleted [deleted] admin-spawned mobs via the game master panel")
			message_admins("[key_name_admin(ui.user)] deleted [deleted] admin-spawned mobs via the game master panel")
			return TRUE

		if("delete_npcs_in_view")
			if(tgui_alert(ui.user, "Delete every unplayed NPC in your view range?", "Confirmation", list("Yes", "No")) != "Yes")
				return TRUE

			var/deleted = 0
			for(var/mob/living/cycled_mob in view(ui.user.client?.view || world.view, ui.user))
				if(cycled_mob == ui.user)
					continue
				if(cycled_mob.client || cycled_mob.mind || cycled_mob.ckey)
					continue
				qdel(cycled_mob)
				deleted++

			log_admin("[key_name(ui.user)] deleted [deleted] NPCs in view via the game master panel")
			message_admins("[key_name_admin(ui.user)] deleted [deleted] NPCs in view via the game master panel")
			return TRUE

/datum/game_master/ui_close(mob/user)
	. = ..()

	var/client/user_client = user.client
	if(user_client?.click_intercept == src)
		user_client.click_intercept = null

	reset_click_overrides()

/datum/game_master/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GameMaster", "Game Master Menu")
		ui.open()

	user.client?.click_intercept = src

/datum/game_master/proc/reset_click_overrides()
	spawn_click_intercept = FALSE
	current_click_intercept_action = null

/datum/game_master/proc/InterceptClickOn(mob/user, params, atom/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, SHIFT_CLICKED) || LAZYACCESS(modifiers, CTRL_CLICKED) || LAZYACCESS(modifiers, ALT_CLICKED))
		return FALSE

	switch(current_click_intercept_action)
		if(SPAWN_CLICK_INTERCEPT_ACTION)
			if(LAZYACCESS(modifiers, MIDDLE_CLICK))
				if(!isliving(object))
					return FALSE
				var/mob/living/clicked_mob = object
				if(clicked_mob == user)
					return TRUE
				if(clicked_mob.client || clicked_mob.mind || clicked_mob.ckey)
					to_chat(user, span_warning("[clicked_mob] is or was player controlled - refusing to delete."))
					return TRUE
				var/turf/clicked_turf = get_turf(clicked_mob)
				var/admin_spawned = (clicked_mob.flags_1 & ADMIN_SPAWNED_1)
				log_admin("[key_name(user)] deleted [clicked_mob] ([clicked_mob.type], [admin_spawned ? "admin-spawned" : "PRE-EXISTING"]) at [AREACOORD(clicked_turf)] via the game master panel")
				message_admins("[key_name_admin(user)] deleted [clicked_mob] ([admin_spawned ? "admin-spawned" : "PRE-EXISTING"]) at [ADMIN_VERBOSEJMP(clicked_turf)] via the game master panel")
				qdel(clicked_mob)
				return TRUE

			if(!LAZYACCESS(modifiers, LEFT_CLICK))
				return FALSE

			if(selected_view == GM_VIEW_WARBAND)
				to_chat(user, span_warning("Warband spawning is not built yet."))
				return TRUE

			var/mob/living/spawning_type = get_selected_mob_type()
			if(!spawning_type)
				to_chat(user, span_warning("No spawnable mob selected."))
				return TRUE

			var/turf/spawn_turf = get_turf(object)
			if(!spawn_turf)
				return TRUE

			for(var/i in 1 to spawn_count)
				spawn_gm_mob(spawning_type, spawn_turf)

			log_admin("[key_name(user)] spawned [spawn_count]ea [spawning_type] at [AREACOORD(spawn_turf)][selected_faction ? " with faction [selected_faction]" : ""]")
			spawn_message_admins("[key_name_admin(user)] spawned [spawn_count]ea [spawning_type] at [AREACOORD(spawn_turf)][selected_faction ? " with faction [selected_faction]" : ""]")
			return TRUE

/datum/game_master/proc/spawn_gm_mob(mob/living/spawning_type, turf/spawn_turf)
	var/mob/living/spawned_mob = new spawning_type(spawn_turf)
	spawned_mob.flags_1 |= ADMIN_SPAWNED_1

	if(selected_faction)
		spawned_mob.faction = list(selected_faction)

	if(spawn_dust)
		ADD_TRAIT(spawned_mob, TRAIT_DUSTABLE, TRAIT_GENERIC)
		if(spawn_dust_leave_head)
			ADD_TRAIT(spawned_mob, TRAIT_DUST_LEAVE_HEAD, TRAIT_GENERIC)
		if(spawn_dust_delete_gear)
			ADD_TRAIT(spawned_mob, TRAIT_DUST_DELETE_GEAR, TRAIT_GENERIC)

	if(ishuman(spawned_mob))
		var/mob/living/carbon/human/spawned_human = spawned_mob
		spawned_human.taints_loot = spawn_taints_loot
		if(!spawn_taints_loot)
			for(var/obj/item/carried_item in spawned_human.get_equipped_items(TRUE) + spawned_human.held_items)
				carried_item.unmark_as_looted()

	if(!spawn_ai)
		if(isanimal(spawned_mob))
			var/mob/living/simple_animal/simple_mob = spawned_mob
			simple_mob.toggle_ai(AI_OFF)
			simple_mob.can_have_ai = FALSE
		if(spawned_mob.ai_controller)
			QDEL_NULL(spawned_mob.ai_controller)

	return spawned_mob

#undef SPAWN_CLICK_INTERCEPT_ACTION
