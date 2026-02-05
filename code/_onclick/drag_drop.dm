/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	receiving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(!usr || !over)
		return
	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over, usr) & COMPONENT_NO_MOUSEDROP)	//Whatever is receiving will verify themselves for adjacency.
		return
	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows
	var/list/L = params2list(params)
	if (L["right"])
		over.RightMouseDrop_T(src, usr)
	else if (L["middle"])
		over.MiddleMouseDrop_T(src, usr)
	else
		if(over == src)
			return usr.client.Click(src, src_location, src_control, params)
		over.MouseDrop_T(src,usr)
	if(isitem(src) && ((isturf(over) && loc == over) || ((istype(over, /obj/structure/table) || istype(over, /obj/structure/rack)) && loc == over.loc)) && (isliving(usr) || prob(10)))
		var/modifier = 1
		var/obj/item/I = src
		if(isdead(usr))
			modifier = 16
		if(!(I.item_flags & ABSTRACT))
			if(!L["icon-x"] || !L["icon-y"])
				return
			I.pixel_x = round(CLAMP(text2num(L["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)/modifier, 1)
			I.pixel_y = round(CLAMP(text2num(L["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)/modifier, 1)
			return
	return

// receive a mousedrop
/atom/proc/MouseDrop_T(atom/dropping, mob/user)
	SEND_SIGNAL(src, COMSIG_MOUSEDROPPED_ONTO, dropping, user, "left")

/atom/proc/RightMouseDrop_T(atom/dropping, mob/user)
	SEND_SIGNAL(src, COMSIG_MOUSEDROPPED_ONTO, dropping, user, "right")

/atom/proc/MiddleMouseDrop_T(atom/dropping, mob/user)
	SEND_SIGNAL(src, COMSIG_MOUSEDROPPED_ONTO, dropping, user, "middle")

/client
	var/list/atom/selected_target[2]
	var/obj/item/active_mousedown_item = null
	var/mouseParams = ""
	var/mouseLocation = null
	var/mouseObject = null
	var/mouseControlObject = null
	var/middragtime = 0
	var/atom/middragatom
	var/tcompare
	var/charging = 0
	var/chargedprog = 0
	var/sections
	var/lastplayed
	var/part
	var/goal
	var/progress
	var/doneset
	var/aghost_toggle
	var/show_lobby_ooc = TRUE // Admin preference: see lobby OOC even when not in lobby
	var/charge_start_time = 0
	var/charge_start_timeofday = 0
	var/last_cooldown_warn = 0
	var/charge_was_blocked_by_cooldown = FALSE

/atom
	var/blockscharging = FALSE

/atom/movable/screen
	blockscharging = TRUE

/client/MouseDown(object, location, control, params)
	charge_was_blocked_by_cooldown = FALSE
	var/list/modifiers = params2list(params)

	if(mob.incapacitated())
		return

	if(mob.stat != CONSCIOUS)
		mob.atkswinging = null
		charging = null
		STOP_PROCESSING(SSmousecharge, src)
		mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'
		return

	tcompare = object

	if(mouse_down_icon)
		mouse_pointer_icon = mouse_down_icon

	var/delay = mob.CanMobAutoclick(object, location, params)

	var/was_charging = charging

	if(was_charging && mob.used_intent)
		mob.used_intent.on_mouse_up()

	mob.atkswinging = null
	charging = 0
	chargedprog = 0

	if(was_charging)
		STOP_PROCESSING(SSmousecharge, src)
		mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'
		return

	if(!mob.fixedeye)
		mob.tempfixeye = TRUE
		mob.nodirchange = TRUE
		// for(var/atom/movable/screen/eye_intent/eyet in mob.hud_used.static_inventory)
		// 	eyet.update_icon(mob)

	if(delay)
		selected_target[1] = object
		selected_target[2] = params
		while(selected_target[1])
			Click(selected_target[1], location, control, selected_target[2])
			sleep(delay)

	active_mousedown_item = mob.canMobMousedown(object, location, params)
	if(active_mousedown_item)
		active_mousedown_item.onMouseDown(object, location, params, mob)

	if(modifiers["right"])
		handle_right_click(object, location, control, params, modifiers)
	else if(modifiers["middle"])
		handle_middle_click(object, params, modifiers)
	else if(modifiers["left"])
		handle_left_click(object, location, control, params, modifiers)

/client/proc/handle_right_click(atom/object, location, control, params, list/modifiers)
	mob.face_atom(object, location, control, params)

	mob.atkswinging = "right"
	if(mob.oactive)
		var/cooldown = (mob.active_hand_index == 2) ? mob.next_lmove : mob.next_rmove
		if(cooldown > world.time)
			charge_was_blocked_by_cooldown = TRUE
			return
		mob.used_intent = mob.o_intent
		if(mob.used_intent.get_chargetime() && !object.blockscharging && !mob.in_throw_mode)
			mob.face_atom(object, location, control, params)
			updateprogbar(object)
		else
			mouse_pointer_icon = 'icons/effects/mousemice/human_attack.dmi'
	else
		mouse_pointer_icon = 'icons/effects/mousemice/human_looking.dmi'

/client/proc/handle_middle_click(atom/object, params, list/modifiers)
	if(mob.next_move > world.time)
		charge_was_blocked_by_cooldown = TRUE
		return

	mob.atkswinging = "middle"
	if(mob.mmb_intent)
		mob.used_intent = mob.mmb_intent
		if(mob.used_intent.type == INTENT_SPELL && mob.ranged_ability)
			var/obj/effect/proc_holder/spell/S = mob.ranged_ability
			if(!S.cast_check(TRUE, mob))
				return

	if(!mob.mmb_intent)
		mouse_pointer_icon = 'icons/effects/mousemice/human_looking.dmi'
	else
		if(mob.mmb_intent.get_chargetime() && !object.blockscharging)
			updateprogbar(object)
		else
			mouse_pointer_icon = mob.mmb_intent.pointer

/client/proc/handle_left_click(atom/object, location, control, params, list/modifiers)
	if(!modifiers["shift"] || mob.BehindAtom(object, mob.dir))
		mob.face_atom(object, location, control, params)
	if(modifiers["right"])
		return

	var/cooldown = (mob.active_hand_index == 1) ? mob.next_lmove : mob.next_rmove
	if(cooldown > world.time)
		charge_was_blocked_by_cooldown = TRUE
		return

	mob.atkswinging = "left"
	mob.used_intent = mob.a_intent
	if(mob.used_intent.get_chargetime() && !object.blockscharging && !mob.in_throw_mode)
		updateprogbar(object)
	else
		mouse_pointer_icon = 'icons/effects/mousemice/human_attack.dmi'

/mob
	var/datum/intent/curplaying

/atom/proc/should_click_on_mouse_up(var/atom/original_object)
	return TRUE

/client/MouseUp(object, location, control, params)
	if(charging && isliving(mob))
		update_to_mob(mob, 0)

	charging = 0

	mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'

	if(mob.curplaying)
		mob.curplaying.on_mouse_up()

	if(!mob.targetting)
		mob.tempfixeye = FALSE

	if(!mob.fixedeye && !mob.tempfixeye)
		mob.nodirchange = FALSE

	// if(mob.hud_used)
	// 	for(var/atom/movable/screen/eye_intent/eyet in mob.hud_used.static_inventory)
	// 		eyet.update_icon(mob) //Update eye icon

	if(!mob.atkswinging)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["left"])
		if(mob.atkswinging != "left")
			mob.atkswinging = null
			return
	if(modifiers["right"])
		if(mob.oactive)
			if(mob.atkswinging != "right")
				mob.atkswinging = null
				return

	if(mob.stat != CONSCIOUS)
		chargedprog = 0
		mob.atkswinging = null
		mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'
		return

	if (mouse_up_icon)
		mouse_pointer_icon = mouse_up_icon
	selected_target[1] = null

	if(tcompare)
		var/atom/target_atom = object
		if(istype(target_atom) && tcompare != mob && (mob.atkswinging == "middle" || (mob.atkswinging && object != tcompare)))
			target_atom.Click(location, control, params)
		tcompare = null

	if(active_mousedown_item)
		active_mousedown_item.onMouseUp(object, location, params, mob)
		active_mousedown_item = null

	if(!isliving(mob))
		return

/client/proc/updateprogbar(atom/clicked_object)
	if(!mob)
		return
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	if(!L.used_intent.can_charge(clicked_object))
		return
	L.used_intent.prewarning()

	if(!charging) //This is for spell charging
		charging = 1
		L.used_intent.on_charge_start()
		L.update_charging_movespeed(L.used_intent)
		progress = 0
		charge_start_time = world.time
		charge_start_timeofday = world.timeofday
		sections = null //commented //From what I can tell, this used to be for the mouse icon changing per % of the cast.
		goal = L.used_intent.get_chargetime() //How much charge to get in order to cast
		part = 1
		lastplayed = 0
		doneset = 0
		chargedprog = 0
		mouse_pointer_icon = 'icons/effects/mousemice/swang/acharging.dmi'
		START_PROCESSING(SSmousecharge, src)

/client/Destroy()
	STOP_PROCESSING(SSmousecharge, src)
	return ..()

/client/process(seconds_per_tick)
	if(!isliving(mob))
		return PROCESS_KILL
	var/mob/living/L = mob
	if(!L?.client || !update_to_mob(L, seconds_per_tick))
		if(L.curplaying)
			L.curplaying.on_mouse_up()
		L.update_charging_movespeed()
		return PROCESS_KILL

/client/proc/update_to_mob(mob/living/L, seconds_per_tick)
	if(charging)
		var/expected_timeofday = charge_start_timeofday + goal
		var/actual_timeofday = world.timeofday
		var/lag_buffer = max(0, (expected_timeofday - progress - actual_timeofday))

		if(progress < goal - lag_buffer) // Add a lag buffer to prevent accidentally losing a full charge due to a lag spike
			progress = world.time - charge_start_time
			progress = min(progress, goal)
			chargedprog = ((progress / goal) * 100)
			var/new_icon = SSmousecharge.access(chargedprog)
			if(mouse_pointer_icon != new_icon)
				mouse_pointer_icon = new_icon
		else //Fully charged spell
			if(!doneset)
				doneset = 1
				if(L.curplaying && !L.used_intent.keep_looping)
					playsound(L, 'sound/magic/charged.ogg', 100, TRUE)
					L.curplaying.on_mouse_up()
				chargedprog = 100
				var/new_icon = 'icons/effects/mousemice/swang/acharged.dmi'
				if(mouse_pointer_icon != new_icon)
					mouse_pointer_icon = new_icon
			else
				if(!L.stamina_add(L.used_intent.chargedrain))
					L.stop_attack()
		return TRUE
	else
		return FALSE

/mob/proc/CanMobAutoclick(object, location, params)
	pass()

/mob/living/carbon/CanMobAutoclick(atom/object, location, params)
	if(!object.IsAutoclickable())
		return
	var/obj/item/h = get_active_held_item()
	if(h)
		. = h.CanItemAutoclick(object, location, params)

/mob/proc/canMobMousedown(atom/object, location, params)

/mob/living/carbon/canMobMousedown(atom/object, location, params)
	var/obj/item/H = get_active_held_item()
	if(H)
		. = H.canItemMouseDown(object, location, params)

/obj/item/proc/CanItemAutoclick(object, location, params)

/obj/item/proc/canItemMouseDown(object, location, params)
	if(canMouseDown)
		return src

/obj/item/proc/onMouseDown(object, location, params, mob)
	return

/obj/item/proc/onMouseUp(object, location, params, mob)
	return

/obj/item/gun/CanItemAutoclick(object, location, params)
	. = automatic

/atom/proc/IsAutoclickable()
	. = 1

/atom/movable/screen/IsAutoclickable()
	. = 0

/atom/movable/screen/click_catcher/IsAutoclickable()
	. = 1

/client/MouseDrag(src_object,atom/over_object,src_location,over_location,src_control,over_control,params)

	if(mob.incapacitated())
		return

	var/list/L = params2list(params)
	if (L["middle"])
		if (src_object && src_location != over_location)
			middragtime = world.time
			middragatom = src_object
		else
			middragtime = 0
			middragatom = null

	if(mob.buckled)
		mob.buckled.face_atom(over_object, over_location, over_control, params)
	else
		mob.face_atom(over_object, over_location, over_control, params)

	mouseParams = params
	mouseLocation = over_location
	mouseObject = over_object
	mouseControlObject = over_control
	if(selected_target[1] && over_object && over_object.IsAutoclickable())
		selected_target[1] = over_object
		selected_target[2] = params
	if(active_mousedown_item)
		active_mousedown_item.onMouseDrag(src_object, over_object, src_location, over_location, params, mob)


/obj/item/proc/onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	return

/client/MouseDrop(src_object, over_object, src_location, over_location, src_control, over_control, params)
	if (middragatom == src_object)
		middragtime = 0
		middragatom = null
	..()
