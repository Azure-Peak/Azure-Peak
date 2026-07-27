#define AB_MAX_COLUMNS 12
#define AB_REARRANGE_TINT "#96ff96"
#define AB_DROP_TINT "#40ff40"

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
	/// A weakref of the last thing we hovered over
	var/datum/weakref/last_hovored_ref

	/// AP: maptext holder for cooldown display on old proc_holder spells
	var/atom/movable/screen/maptext_holder/maptext_holder

	var/atom/movable/screen/hotkey_label_holder/hotkey_label_holder

/atom/movable/screen/movable/action_button/Destroy()
	if(our_hud)
		var/mob/viewer = our_hud.mymob
		viewer?.client?.screen -= src
		linked_action?.viewers -= our_hud
		viewer?.update_action_buttons()
		our_hud = null
	linked_action = null
	QDEL_NULL(maptext_holder)
	QDEL_NULL(hotkey_label_holder)
	return ..()

/atom/movable/screen/movable/action_button/proc/can_use(mob/user)
	if (linked_action)
		return linked_action.owner == user
	else if (isobserver(user))
		var/mob/dead/observer/O = user
		return !O.observetarget
	else
		return TRUE

/atom/movable/screen/movable/action_button/proc/set_drag_highlight(on)
	if(!our_hud?.rearrange_mode)
		linked_action?.build_all_button_icons(UPDATE_BUTTON_STATUS)
		return
	color = on ? AB_DROP_TINT : AB_REARRANGE_TINT

/atom/movable/screen/movable/action_button/MouseDrag(atom/over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!can_use(usr) || !our_hud?.rearrange_mode)
		return
	var/atom/movable/screen/movable/action_button/old_button = last_hovored_ref?.resolve()
	if(old_button == over_object)
		return
	if(istype(old_button))
		old_button.set_drag_highlight(FALSE)
	last_hovored_ref = null
	if(over_object != src && istype(over_object, /atom/movable/screen/movable/action_button))
		var/atom/movable/screen/movable/action_button/target = over_object
		target.set_drag_highlight(TRUE)
		last_hovored_ref = WEAKREF(target)

/atom/movable/screen/movable/action_button/MouseDrop(atom/over_object)
	var/atom/movable/screen/movable/action_button/hovered = last_hovored_ref?.resolve()
	if(istype(hovered))
		hovered.set_drag_highlight(FALSE)
	last_hovored_ref = null
	if(!can_use(usr))
		return
	if(!our_hud?.rearrange_mode)
		return
	if(!istype(over_object, /atom/movable/screen/movable/action_button))
		return
	var/atom/movable/screen/movable/action_button/B = over_object
	if(B == src)
		return
	moved = FALSE
	B.moved = FALSE
	if(!usr.mind?.swap_spell_order(src.linked_action, B.linked_action))
		var/list/actions = usr.actions
		var/first_idx = actions.Find(src.linked_action)
		var/second_idx = actions.Find(B.linked_action)
		if(!first_idx || !second_idx)
			return
		actions.Swap(first_idx, second_idx)
		usr.mind?.sync_spell_list_to_actions()
		usr.update_action_buttons()

/atom/movable/screen/movable/action_button/Click(location,control,params)
	if (!can_use(usr))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["alt"])
		moved = 0
		usr.update_action_buttons() //redraw buttons that are no longer considered "moved"
		return TRUE
	if(modifiers["ctrl"])
		our_hud?.toggle_rearrange_mode()
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
	if(our_hud?.rearrange_mode)
		our_hud.rearrange_hint(usr)
		return TRUE
	if(usr.next_click > world.time)
		return
	usr.next_click = world.time + 1
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)
	linked_action.Trigger()
	return TRUE

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
			B.set_hotkey_label(null)
			if(reload_screen)
				client.screen += B
	else
		for(var/datum/action/A as anything in actions)
			A.build_all_button_icons()
			var/atom/movable/screen/movable/action_button/B = A.viewers[hud_used]
			if(!B)
				continue
			B.locked = !hud_used.rearrange_mode
			if(hud_used.rearrange_mode)
				B.color = AB_REARRANGE_TINT
			B.moved = FALSE
			button_number++
			B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			B.set_hotkey_label(button_number <= 9 ? button_number : null)
			if(reload_screen)
				client.screen += B

/datum/hud/proc/toggle_rearrange_mode()
	rearrange_mode = !rearrange_mode
	if(rearrange_mode)
		mymob?.mind?.sync_spell_list_to_actions()
		mymob?.balloon_alert(mymob, "<span style='color:#ff6666'>rearrangement mode - spells disabled!</span>")
	else
		mymob?.balloon_alert(mymob, "<span style='color:#96ff96'>rearrangement mode off - spells enabled</span>")
	mymob?.update_action_buttons()

/// Reminds why clicks aren't casting, at most once per few seconds so drag-arranging isn't spammed.
/datum/hud/proc/rearrange_hint(mob/user)
	if(world.time < next_rearrange_hint)
		return
	next_rearrange_hint = world.time + 4 SECONDS
	user?.balloon_alert(user, "<span style='color:#ff6666'>spells disabled - ctrl-click to unlock!</span>")

/datum/hud/proc/ButtonNumberToScreenCoords(number) // TODO : Make this zero-indexed for readabilty
	var/row = round((number - 1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1

	var/coord_col = "+[col-1]"
	var/coord_col_offset = 4 + 2 * col

	var/coord_row = "[row ? "+[row]" : "+0"]"

	return "WEST[coord_col]:[coord_col_offset],SOUTH[coord_row]:3"

/atom/movable/screen/movable/action_button/proc/update_maptext(cd_time_deciseconds, color_cd = "#800000", color_neutral = "#ffffff")
	if(!istype(maptext_holder))
		maptext_holder = new /atom/movable/screen/maptext_holder/cooldown(src)
		vis_contents.Add(maptext_holder)

	maptext_holder.update_maptext(cd_time_deciseconds, color_cd, color_neutral)

/atom/movable/screen/movable/action_button/proc/set_hotkey_label(number)
	if(isnull(number))
		if(hotkey_label_holder)
			hotkey_label_holder.maptext = null
		return
	if(!istype(hotkey_label_holder))
		hotkey_label_holder = new(src)
		vis_contents.Add(hotkey_label_holder)
	hotkey_label_holder.maptext = MAPTEXT("<span style='color: #ffe14d; -dm-text-outline: 1 #000000; font-weight: bold;'>[number]</span>")

/atom/movable/screen/hotkey_label_holder
	layer = ABOVE_HUD_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_x = 1
	maptext_y = 20
	maptext_width = 12
	maptext_height = 11

/atom/movable/screen/maptext_holder
	layer = ABOVE_HUD_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_x = 8
	maptext_y = 4

/atom/movable/screen/maptext_holder/cooldown
	maptext_x = 0
	maptext_y = 0
	maptext_width = 32
	maptext_height = 32

/atom/movable/screen/maptext_holder/proc/update_maptext(cd_time_deciseconds, color_cd = "#800000", color_neutral = "#ffffff")
	if(cd_time_deciseconds <= 0)
		if(maptext)
			maptext = null
			color = color_neutral
		return
	var/seconds_left = round(cd_time_deciseconds / (1 SECONDS), 0.1)
	var/cd_text
	if(seconds_left >= 60)
		var/mins = round(seconds_left / 60)
		var/secs = round(seconds_left) % 60
		cd_text = "[mins]:[secs < 10 ? "0[secs]" : "[secs]"]"
	else
		cd_text = "[seconds_left]s"
	maptext = "<div align='center' valign='middle' class='maptext'>[cd_text]</div>"
	color = color_cd

#undef AB_MAX_COLUMNS
#undef AB_REARRANGE_TINT
#undef AB_DROP_TINT
