#define AB_MAX_COLUMNS 12

/atom/movable/screen/movable/action_button
	var/datum/action/linked_action
	var/actiontooltipstyle = ""
	screen_loc = null
	var/mutable_appearance/blank_icon

	var/button_icon_state
	var/appearance_cache
	locked = TRUE
	var/id
	var/ordered = TRUE //If the button gets placed into the default bar
	nomouseover = FALSE

	var/atom/movable/screen/maptext_holder/maptext_holder

/atom/movable/screen/movable/action_button/Destroy()
	QDEL_NULL(maptext_holder)
	return ..()

/atom/movable/screen/movable/action_button/proc/can_use(mob/user)
	if (linked_action)
		return linked_action.owner == user
	else if (isobserver(user))
		var/mob/dead/observer/O = user
		return !O.observetarget
	else
		return TRUE

/atom/movable/screen/movable/action_button/MouseDrop(over_object)
	if(!can_use(usr))
		return
	if((istype(over_object, /atom/movable/screen/movable/action_button) && !istype(over_object, /atom/movable/screen/movable/action_button/hide_toggle)))
		if(locked)
			to_chat(usr, span_warning("Action button \"[name]\" is locked, unlock it first."))
			return
		var/atom/movable/screen/movable/action_button/B = over_object
		var/list/actions = usr.actions
		actions.Swap(actions.Find(src.linked_action), actions.Find(B.linked_action))
		moved = FALSE
		ordered = TRUE
		B.moved = FALSE
		B.ordered = TRUE
		usr.update_action_buttons()
	else
		return ..()

/atom/movable/screen/movable/action_button/Click(location,control,params)
	if (!can_use(usr))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["alt"])
		if(locked)
			to_chat(usr, span_warning("Action button \"[name]\" is locked, unlock it first."))
			return TRUE
		moved = 0
		usr.update_action_buttons() //redraw buttons that are no longer considered "moved"
		return TRUE
	if(modifiers["ctrl"])
		locked = !locked
		to_chat(usr, span_notice("Action button \"[name]\" [locked ? "" : "un"]locked."))
		if(id && usr.client) //try to (un)remember position
			usr.client.prefs.action_buttons_screen_locs["[name]_[id]"] = locked ? moved : null
		return TRUE
	if(modifiers["shift"])
		examine_ui(usr)
		return TRUE
	if(usr.next_click > world.time)
		return
	usr.next_click = world.time + 1
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)
	linked_action.Trigger()
	return TRUE

//Hide/Show Action Buttons ... Button
/atom/movable/screen/movable/action_button/hide_toggle
	name = "Hide Buttons"
	desc = ""
	icon = 'icons/mob/actions.dmi'
	icon_state = "bg_default"
	locked = TRUE
	var/hidden = 0
	var/hide_icon = 'icons/mob/actions.dmi'
	var/hide_state = "hide"
	var/show_state = "show"
	var/mutable_appearance/hide_appearance
	var/mutable_appearance/show_appearance

/atom/movable/screen/movable/action_button/hide_toggle/Initialize()
	. = ..()
	var/static/list/icon_cache = list()

	var/cache_key = "[hide_icon][hide_state]"
	hide_appearance = icon_cache[cache_key]
	if(!hide_appearance)
		hide_appearance = icon_cache[cache_key] = mutable_appearance(hide_icon, hide_state)

	cache_key = "[hide_icon][show_state]"
	show_appearance = icon_cache[cache_key]
	if(!show_appearance)
		show_appearance = icon_cache[cache_key] = mutable_appearance(hide_icon, show_state)


/atom/movable/screen/movable/action_button/hide_toggle/Click(location,control,params)
	if (!can_use(usr))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		if(locked)
			to_chat(usr, span_warning("Action button \"[name]\" is locked, unlock it first."))
			return TRUE
		moved = FALSE
		usr.update_action_buttons(TRUE)
		return TRUE
	if(modifiers["ctrl"])
		locked = !locked
		to_chat(usr, span_notice("Action button \"[name]\" [locked ? "" : "un"]locked."))
		if(id && usr.client) //try to (un)remember position
			usr.client.prefs.action_buttons_screen_locs["[name]_[id]"] = locked ? moved : null
		return TRUE
	if(modifiers["alt"])
		for(var/V in usr.actions)
			var/datum/action/A = V
			var/atom/movable/screen/movable/action_button/B = A.button
			B.moved = FALSE
			if(B.id && usr.client)
				usr.client.prefs.action_buttons_screen_locs["[B.name]_[B.id]"] = null
			B.locked = usr.client.prefs.buttons_locked
		locked = usr.client.prefs.buttons_locked
		moved = FALSE
		if(id && usr.client)
			usr.client.prefs.action_buttons_screen_locs["[name]_[id]"] = null
		usr.update_action_buttons(TRUE)
		to_chat(usr, span_notice("Action button positions have been reset."))
		return TRUE
	usr.hud_used.action_buttons_hidden = !usr.hud_used.action_buttons_hidden

	hidden = usr.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	update_icon()
	usr.update_action_buttons()

/atom/movable/screen/movable/action_button/hide_toggle/AltClick(mob/user)
	for(var/V in user.actions)
		var/datum/action/A = V
		var/atom/movable/screen/movable/action_button/B = A.button
		B.moved = FALSE
	if(moved)
		moved = FALSE
	user.update_action_buttons(TRUE)
	to_chat(user, span_notice("Action button positions have been reset."))


/atom/movable/screen/movable/action_button/hide_toggle/proc/InitialiseIcon(datum/hud/owner_hud)
	var/settings = owner_hud.get_action_buttons_icons()
	icon = settings["bg_icon"]
	icon_state = settings["bg_state"]
	hide_icon = settings["toggle_icon"]
	hide_state = settings["toggle_hide"]
	show_state = settings["toggle_show"]
	update_icon()

/atom/movable/screen/movable/action_button/hide_toggle/update_overlays()
	. = ..()
	if(hidden)
		. += show_appearance
	else
		. += hide_appearance

/atom/movable/screen/movable/action_button/MouseExited()
	..()

/datum/hud/proc/get_action_buttons_icons()
	. = list()
	.["bg_icon"] = ui_style
	.["bg_state"] = "template"

	//TODO : Make these fit theme
	.["toggle_icon"] = 'icons/mob/actions.dmi'
	.["toggle_hide"] = "hide"
	.["toggle_show"] = "show"

//see human and alien hud for specific implementations.

/mob/proc/update_action_buttons_icon(status_only = FALSE)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon(status_only)

//This is the proc used to update all the action buttons.
/mob/proc/update_action_buttons(reload_screen)
	if(!hud_used || !client)
		return

	if(hud_used.hud_shown != HUD_STYLE_STANDARD)
		return

	var/button_number = 0

	if(hud_used.action_buttons_hidden)
		for(var/datum/action/A in actions)
			A.button.screen_loc = null
			if(reload_screen)
				client.screen += A.button
	else
		for(var/datum/action/A in actions)
			A.UpdateButtonIcon()
			var/atom/movable/screen/movable/action_button/B = A.button
			if(B.ordered)
				button_number++
			if(B.moved)
				B.screen_loc = B.moved
			else
				B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			if(reload_screen)
				client.screen += B

/datum/hud/proc/ButtonNumberToScreenCoords(number) // TODO : Make this zero-indexed for readabilty
	var/row = round((number - 1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1

	var/coord_col = "+[col-1]"
	var/coord_col_offset = 4 + 2 * col

	var/coord_row = "[row ? "+[row]" : "+0"]"

	return "WEST[coord_col]:[coord_col_offset],SOUTH[coord_row]:3"

/datum/hud/proc/SetButtonCoords(atom/movable/screen/button,number)
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/x_offset = 32*(col-1) + 4 + 2*col
	var/y_offset = -32*(row+1) + 26

	var/matrix/M = matrix()
	M.Translate(x_offset,y_offset)
	button.transform = M

/atom/movable/screen/movable/action_button/proc/update_maptext(cd_time_deciseconds, color_cd = "#800000", color_neutral = "#ffffff")
	if(!istype(maptext_holder))
		maptext_holder = new(src)
		vis_contents.Add(maptext_holder)

	maptext_holder.update_maptext(cd_time_deciseconds, color_cd, color_neutral)

/atom/movable/screen/maptext_holder
	layer = ABOVE_HUD_LAYER
	maptext_x = 8
	maptext_y = 4

/atom/movable/screen/maptext_holder/proc/update_maptext(cd_time_deciseconds, color_cd = "#800000", color_neutral = "#ffffff")
	animate(src, flags = ANIMATION_END_NOW)

	// queue an animate for each decisecond remaining in click cooldown + 1
	for(var/i in 1 to cd_time_deciseconds + 1)
		var/decisceonds_left_this_iter = cd_time_deciseconds - i
		var/displaytext = null
		if(decisceonds_left_this_iter > 0)
			displaytext = MAPTEXT("[round(decisceonds_left_this_iter / (1 SECONDS), 0.1)]s")

		if(i == 1)
			animate(src, maptext = displaytext, color = color_cd, 1)
		else if(i == cd_time_deciseconds + 1)
			animate(maptext = displaytext, color = color_neutral, 1)
		else
			animate(maptext = displaytext, 1)

#undef AB_MAX_COLUMNS
