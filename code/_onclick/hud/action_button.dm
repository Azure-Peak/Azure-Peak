#define AB_MAX_COLUMNS 12

/atom/movable/screen/movable/action_button
	var/datum/action/linked_action
	var/datum/hud/our_hud
	var/actiontooltipstyle = ""
	screen_loc = null
	nomouseover = FALSE

	/// The icon state of our active overlay, used to prevent re-applying identical overlays
	var/active_overlay_icon_state
	/// The icon state of our active underlay, used to prevent re-applying identical underlays
	var/active_underlay_icon_state

	var/mutable_appearance/button_overlay

	/// Where we are currently placed on the hud. SCRN_OBJ_DEFAULT asks the linked action what it thinks
	var/location = SCRN_OBJ_DEFAULT
	locked = TRUE
	/// A unique bitflag, combined with the name of our linked action this lets us persistently remember any user changes to our position
	var/id
	var/ordered = TRUE //If the button gets placed into the default bar
	/// A weakref of the last thing we hovered over
	var/datum/weakref/last_hovored_ref

	/// AP: maptext holder for cooldown display on old proc_holder spells
	var/atom/movable/screen/maptext_holder/maptext_holder

/atom/movable/screen/movable/action_button/Destroy()
	if(our_hud)
		var/mob/viewer = our_hud.mymob
		viewer?.client?.screen -= src
		linked_action?.viewers -= our_hud
		viewer?.update_action_buttons()
		our_hud = null
	linked_action = null
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
		var/datum/action/spell_action/SA = linked_action
		if(istype(SA))
			SA.examine(usr)
		else
			var/datum/action/cooldown/spell/v2_spell = linked_action
			if(istype(v2_spell))
				v2_spell.examine(usr)
			else
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
		var/datum/hud/usr_hud = usr.hud_used
		for(var/datum/action/A as anything in usr.actions)
			var/atom/movable/screen/movable/action_button/B = A.viewers[usr_hud]
			if(!B)
				continue
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
	var/datum/hud/user_hud = user.hud_used
	for(var/datum/action/A as anything in user.actions)
		var/atom/movable/screen/movable/action_button/B = A.viewers[user_hud]
		if(!B)
			continue
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

/// Updates all action button icons for this mob.
/mob/proc/update_mob_action_buttons(update_flags = ALL, force = FALSE)
	for(var/datum/action/current_action as anything in actions)
		current_action.build_all_button_icons(update_flags, force)

//This is the proc used to update all the action buttons.
/mob/proc/update_action_buttons(reload_screen)
	if(!hud_used || !client)
		return

	if(hud_used.hud_shown != HUD_STYLE_STANDARD)
		return

	var/button_number = 0

	if(hud_used.action_buttons_hidden)
		for(var/datum/action/A as anything in actions)
			A.build_all_button_icons()
			var/atom/movable/screen/movable/action_button/B = A.viewers[hud_used]
			if(!B)
				continue
			B.screen_loc = null
			if(reload_screen)
				client.screen += B
	else
		for(var/datum/action/A as anything in actions)
			A.build_all_button_icons()
			var/atom/movable/screen/movable/action_button/B = A.viewers[hud_used]
			if(!B)
				continue
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
	if(cd_time_deciseconds <= 0)
		maptext = null
		color = color_neutral
		return
	var/seconds_left = round(cd_time_deciseconds / (1 SECONDS), 0.1)
	if(seconds_left >= 60)
		var/mins = round(seconds_left / 60)
		var/secs = round(seconds_left) % 60
		maptext = MAPTEXT("[mins]:[secs < 10 ? "0[secs]" : "[secs]"]")
	else
		maptext = MAPTEXT("[seconds_left]s")
	color = color_cd

#undef AB_MAX_COLUMNS
