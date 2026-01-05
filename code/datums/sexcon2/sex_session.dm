/datum/sex_session //! TODO SEX SOUNDS
	/// The initiating user
	var/mob/living/carbon/human/user
	/// Target of our actions
	var/mob/living/carbon/human/target
	/// Whether the user desires to stop current action
	var/desire_stop = FALSE
	/// What is the current performed action
	var/datum/sex_action/current_action = null
	/// Enum of desired speed
	var/speed = SEX_SPEED_MID
	/// Enum of desired force
	var/force = SEX_FORCE_MID
	/// Makes genital arousal automatic by default
	var/manual_arousal = SEX_MANUAL_AROUSAL_DEFAULT
	/// Whether we want to screw until finished, or non stop
	var/do_until_finished = TRUE
	///inactivity bumps
	var/inactivity = 0
	/// Reference to the collective this session belongs to
	var/datum/collective_message/collective = null
	///have we just climaxed?
	var/just_climaxed = FALSE
	/// Whether to use knot when fucking (for knotted penis types)
	var/do_knot_action = FALSE

	var/static/sex_id = 0
	var/our_sex_id = 0 //this is so we can have more then 1 sex id open at once


/datum/sex_session/New(mob/living/carbon/human/session_user, mob/living/carbon/human/session_target)
	user = session_user
	target = session_target
	sex_id++
	our_sex_id = sex_id
	assign_to_collective()

	RegisterSignal(user, COMSIG_SEX_CLIMAX, PROC_REF(on_climax))
	RegisterSignal(user, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed), TRUE)

/datum/sex_session/Destroy(force, ...)
	UnregisterSignal(user, list(COMSIG_SEX_CLIMAX, COMSIG_SEX_AROUSAL_CHANGED))
	if(collective)
		collective.sessions -= src
		// If this was the last session in the collective, remove the collective
		if(!length(collective.sessions))
			LAZYREMOVE(GLOB.sex_collectives, collective)
			qdel(collective)

	GLOB.sex_sessions -= src
	. = ..()


/datum/sex_session/proc/assign_to_collective()
	// Check if we can merge with an existing collective
	for(var/datum/collective_message/existing_collective in GLOB.sex_collectives)
		if(existing_collective.can_merge_session(src))
			existing_collective.merge_session(src)
			return

	// No existing collective found, create a new one
	var/datum/collective_message/new_collective = new /datum/collective_message(src)
	LAZYADD(GLOB.sex_collectives, new_collective)
	collective = new_collective

/datum/sex_session/proc/on_arousal_changed()
	SStgui.update_uis(src)

/datum/sex_session/proc/check_climax()
	var/list/arousal_data = list()
	SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, arousal_data)
	if(arousal_data["arousal"] < ACTIVE_EJAC_THRESHOLD)
		return FALSE
	return TRUE

/datum/sex_session/proc/try_start_action(action_type)
	if(action_type == current_action)
		try_stop_current_action()
		return
	if(current_action != null)
		try_stop_current_action()
		return
	if(!action_type)
		return
	if(!can_perform_action(action_type))
		return

	desire_stop = FALSE
	current_action = action_type
	inactivity = 0
	var/datum/sex_action/action = SEX_ACTION(current_action)
	log_combat(user, target, "Started sex action: [action.name] with [target.name].")
	INVOKE_ASYNC(src, PROC_REF(sex_action_loop))

/datum/sex_session/proc/try_stop_current_action()
	if(!current_action)
		return
	desire_stop = TRUE

/datum/sex_session/proc/considered_limp(mob/limper)
	if(QDELETED(limper))
		return TRUE // If no limper or deleted, consider it limp
	var/list/arousal_data = list()
	SEND_SIGNAL(limper, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/arousal_value = arousal_data["arousal"]
	if(arousal_value >= AROUSAL_HARD_ON_THRESHOLD)
		return FALSE
	return TRUE

/datum/sex_session/proc/sex_action_loop()
	var/performed_action_type = current_action
	var/datum/sex_action/action = SEX_ACTION(current_action)
	action.on_start(user, target)

	while(TRUE)
		#ifndef LOCALTEST
		// DO NOT allow NPC sex except on local, for testing
		if(isnull(target.client))
			break
		#endif

		var/stamina_cost = action.stamina_cost * get_stamina_cost_multiplier()
		if(!user.stamina_add(stamina_cost))
			break

		var/do_time = action.do_time / get_speed_multiplier()
		if(!do_after(user, do_time, target = target))
			break

		if(current_action == null || performed_action_type != current_action)
			break
		if(!can_perform_action(current_action, TRUE))
			break
		if(action.is_finished(user, target))
			break
		if(desire_stop)
			break

		action.on_perform(user, target)

		action.show_sex_effects(user)

		if(action.is_finished(user, target))
			break
		if(!action.continous)
			break

	stop_current_action()

/datum/sex_session/proc/stop_current_action()
	if(!current_action)
		return
	var/datum/sex_action/action = SEX_ACTION(current_action)
	action.on_finish(user, target)
	desire_stop = FALSE
	current_action = null

/datum/sex_session/proc/can_perform_action(action_type, performing = FALSE)
	if(!action_type)
		return FALSE
	var/datum/sex_action/action = SEX_ACTION(action_type)
	if(!inherent_perform_check(action_type))
		return FALSE
	if(!action.can_perform(user, target) && !performing)
		return FALSE
	return TRUE

/datum/sex_session/proc/inherent_perform_check(action_type)
	var/datum/sex_action/action = SEX_ACTION(action_type)
	if(!target)
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(action.check_incapacitated && user.incapacitated())
		return FALSE
	if(action.check_same_tile)
		var/same_tile = (get_turf(user) == get_turf(target))
		var/grab_bypass = (action.aggro_grab_instead_same_tile && user.get_highest_grab_state_on(target) == GRAB_AGGRESSIVE)
		if(!same_tile && !grab_bypass)
			return FALSE
	if(action.require_grab)
		var/grabstate = user.get_highest_grab_state_on(target)
		if(grabstate == null || grabstate < action.required_grab_state)
			return FALSE
	return TRUE

/datum/sex_session/proc/perform_sex_action(mob/living/carbon/human/action_target, arousal_amt, pain_amt, giving)
	SEND_SIGNAL(action_target, COMSIG_SEX_RECEIVE_ACTION, arousal_amt, pain_amt, giving, force, speed)

/datum/sex_session/proc/handle_passive_ejaculation(mob/living/carbon/human/handler)
	if(!handler)
		handler = user
	var/list/arousal_data = list()
	SEND_SIGNAL(handler, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/arousal_multiplier = arousal_data["arousal_multiplier"]
	var/arousal_value = arousal_data["arousal"]

	if(arousal_multiplier > 1.5 && user.check_handholding())
		if(prob(5))
			SEND_SIGNAL(handler, COMSIG_SEX_RECEIVE_ACTION, 3, 0, 1, 0)
		if(arousal_value < 70)
			SEND_SIGNAL(handler, COMSIG_SEX_ADJUST_AROUSAL, 0.2)

		if(handler.handcuffed)
			if(prob(8))
				var/chaffepain = pick(10,10,10,10,20,20,30)
				SEND_SIGNAL(handler, COMSIG_SEX_RECEIVE_ACTION, 3, chaffepain, 1, 0)
				handler.visible_message(("<span class='love_mid'>[handler] squirms uncomfortably in [handler.p_their()] restraints.</span>"), \
					("<span class='love_extreme'>I feel [handler.handcuffed] rub uncomfortably against my skin.</span>"))
			if(arousal_value < ACTIVE_EJAC_THRESHOLD)
				SEND_SIGNAL(handler, COMSIG_SEX_ADJUST_AROUSAL, 0.25)


/datum/sex_session/proc/get_speed_multiplier()
	switch(speed)
		if(SEX_SPEED_LOW)
			return 1.0
		if(SEX_SPEED_MID)
			return 1.5
		if(SEX_SPEED_HIGH)
			return 2.0
		if(SEX_SPEED_EXTREME)
			return 2.5

/datum/sex_session/proc/get_stamina_cost_multiplier()
	switch(force)
		if(SEX_FORCE_LOW)
			return 1.0
		if(SEX_FORCE_MID)
			return 1.5
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_FORCE_EXTREME)
			return 2.5

/datum/sex_session/proc/adjust_speed(amt)
	speed = clamp(speed + amt, SEX_SPEED_MIN, SEX_SPEED_MAX)

/datum/sex_session/proc/adjust_force(amt)
	force = clamp(force + amt, SEX_FORCE_MIN, SEX_FORCE_MAX)

/datum/sex_session/proc/finished_check()
	if(!do_until_finished)
		return FALSE
	if(just_climaxed)
		just_climaxed = FALSE
		return TRUE
	return FALSE

/datum/sex_session/proc/on_climax(mob/source)
	if(!do_until_finished)
		return
	just_climaxed = TRUE


/datum/sex_session/proc/get_force_string()
	switch(force)
		if(SEX_FORCE_LOW)
			return "<font color='#eac8de'>GENTLE</font>"
		if(SEX_FORCE_MID)
			return "<font color='#e9a8d1'>FIRM</font>"
		if(SEX_FORCE_HIGH)
			return "<font color='#f05ee1'>ROUGH</font>"
		if(SEX_FORCE_EXTREME)
			return "<font color='#d146f5'>BRUTAL</font>"

/datum/sex_session/proc/get_speed_string()
	switch(speed)
		if(SEX_SPEED_LOW)
			return "<font color='#eac8de'>SLOW</font>"
		if(SEX_SPEED_MID)
			return "<font color='#e9a8d1'>STEADY</font>"
		if(SEX_SPEED_HIGH)
			return "<font color='#f05ee1'>QUICK</font>"
		if(SEX_SPEED_EXTREME)
			return "<font color='#d146f5'>UNRELENTING</font>"

/datum/sex_session/proc/get_manual_arousal_string()
	switch(manual_arousal)
		if(SEX_MANUAL_AROUSAL_DEFAULT)
			return "<font color='#eac8de'>NATURAL</font>"
		if(SEX_MANUAL_AROUSAL_UNAROUSED)
			return "<font color='#e9a8d1'>UNAROUSED</font>"
		if(SEX_MANUAL_AROUSAL_PARTIAL)
			return "<font color='#f05ee1'>PARTIALLY ERECT</font>"
		if(SEX_MANUAL_AROUSAL_FULL)
			return "<font color='#d146f5'>FULLY ERECT</font>"
/datum/sex_session/proc/get_generic_force_adjective()
	switch(force)
		if(SEX_FORCE_LOW)
			return pick(list("gently", "carefully", "tenderly", "gingerly", "delicately", "lazily"))
		if(SEX_FORCE_MID)
			return pick(list("firmly", "vigorously", "eagerly", "steadily", "intently"))
		if(SEX_FORCE_HIGH)
			return pick(list("roughly", "carelessly", "forcefully", "fervently", "fiercely"))
		if(SEX_FORCE_EXTREME)
			return pick(list("brutally", "violently", "relentlessly", "savagely", "mercilessly"))

/datum/sex_session/proc/spanify_force(string)
	switch(force)
		if(SEX_FORCE_LOW)
			return "<span class='love_low'>[string]</span>"
		if(SEX_FORCE_MID)
			return "<span class='love_mid'>[string]</span>"
		if(SEX_FORCE_HIGH)
			return "<span class='love_high'>[string]</span>"
		if(SEX_FORCE_EXTREME)
			return "<span class='love_extreme'>[string]</span>"

/datum/sex_session/proc/get_force_sound()
	switch(force)
		if(SEX_FORCE_LOW, SEX_FORCE_MID)
			return pick(SEX_SOUNDS_SLOW)
		if(SEX_FORCE_HIGH, SEX_FORCE_EXTREME)
			return pick(SEX_SOUNDS_HARD)

/datum/sex_session/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SexSession", "Sate Desires")
		ui.open()

/datum/sex_session/ui_state(mob/user)
	return GLOB.conscious_state

/datum/sex_session/ui_static_data(mob/user)
	var/list/data = list()

	// Build action list (doesn't change during session)
	var/list/actions = list()
	for(var/action_type in GLOB.sex_actions)
		var/datum/sex_action/action = SEX_ACTION(action_type)
		if(!action.shows_on_menu(user, target))
			continue
		actions += list(list(
			"name" = action.name,
			"type" = action_type,
			"description" = action.description || "",
			"requires_grab" = action.require_grab
		))
	data["actions"] = actions

	// Static UI strings
	data["speed_names"] = list("SLOW", "STEADY", "QUICK", "UNRELENTING")
	data["force_names"] = list("GENTLE", "FIRM", "ROUGH", "BRUTAL")
	data["has_penis"] = user.getorganslot(ORGAN_SLOT_PENIS) ? TRUE : FALSE

	// Check if user has knotted penis
	var/has_knotted_penis = FALSE
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
	if(penis)
		switch(penis.penis_type)
			if(PENIS_TYPE_KNOTTED, PENIS_TYPE_TAPERED_DOUBLE_KNOTTED, PENIS_TYPE_BARBED_KNOTTED)
				has_knotted_penis = TRUE
	data["has_knotted_penis"] = has_knotted_penis

	return data

/datum/sex_session/ui_data(mob/user)
	var/list/data = list()

	var/mob/living/my_user = user
	if(!istype(my_user, /mob/living))
		return

	data["title"] = get_sex_session_header_text()
	data["character_info"] = my_user.return_character_information()
	data["current_action"] = current_action
	data["speed"] = get_current_speed()
	data["force"] = get_current_force()
	data["manual_arousal"] = manual_arousal || SEX_MANUAL_AROUSAL_DEFAULT
	data["do_until_finished"] = do_until_finished
	data["do_knot_action"] = do_knot_action

	var/list/arousal_data = list()
	SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/current_arousal = arousal_data["arousal"] || 0
	data["arousal"] = min(100, (current_arousal / ACTIVE_EJAC_THRESHOLD) * 100)
	data["frozen"] = arousal_data["frozen"] || FALSE

	// Which actions can be performed
	var/list/can_perform = list()
	for(var/action_type in GLOB.sex_actions)
		var/datum/sex_action/action = SEX_ACTION(action_type)
		if(!action.shows_on_menu(user, target))
			continue
		if(can_perform_action(action_type))
			can_perform += action_type
	data["can_perform"] = can_perform

	// Session info
	data["session_name"] = collective?.collective_display_name || "Private Session"
	var/list/participants = list()
	if(collective)
		for(var/datum/sex_session/sess in collective.sessions)
			if(sess == src)
				continue
			participants += list(list(
				"name" = sess.user?.name || "Unknown",
				"ref" = REF(sess.user)
			))
	data["participants"] = participants

	return data

/datum/sex_session/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("start_action")
			try_start_action(text2path(params["action_type"]))
			. = TRUE
		if("stop_action")
			stop_current_action()
			. = TRUE
		if("set_speed")
			set_current_speed(params["value"])
			. = TRUE
		if("set_force")
			set_current_force(params["value"])
			. = TRUE
		if("cycle_arousal")
			manual_arousal = (manual_arousal % SEX_MANUAL_AROUSAL_MAX) + 1
			. = TRUE
		if("toggle_finished")
			do_until_finished = !do_until_finished
			. = TRUE
		if("toggle_knot")
			do_knot_action = !do_knot_action
			. = TRUE
		if("set_arousal_value")
			SEND_SIGNAL(user, COMSIG_SEX_SET_AROUSAL, params["amount"])
			. = TRUE
		if("freeze_arousal")
			SEND_SIGNAL(user, COMSIG_SEX_FREEZE_AROUSAL)
			. = TRUE
		if("update_session_name")
			if(collective)
				collective.collective_display_name = params["name"]
			. = TRUE

	if(.)
		SStgui.update_uis(src)

/datum/sex_session/proc/get_sex_session_header_text()
	return "Interacting with [target?.name || "Unknown"]..."

/datum/sex_session/proc/get_session_tab_content()
	var/list/content = list()

	content += "<div class='session-info'>"

	// Session name editing
	var/session_name = collective?.collective_display_name || "Private Session"
	content += "<div style='margin: 10px 0;'>"
	content += "<label style='color: #d4af8c; font-weight: bold;'>Session Name:</label><br>"
	content += "<input type='text' id='sessionNameInput' class='session-name-input' value='[session_name]' placeholder='Enter session name...'>"
	content += "<button onclick='updateSessionName()' class='control-btn' style='margin-left: 5px;'>Update</button>"
	content += "</div>"

	// Participants list
	content += "<div class='participants-list'>"
	content += "<h4 style='color: #d4af8c;'>Participants:</h4>"

	var/list/participants = list(user, target)
	if(collective)
		participants = collective.involved_mobs

	for(var/mob/living/carbon/human/participant in participants)
		var/display_name = participant.get_face_name() || participant.name
		var/is_you = (participant == user) ? " (You)" : ""
		content += "<div class='participant-item'>[display_name][is_you]</div>"

	content += "</div>"

	return content.Join("")

/datum/sex_session/proc/get_current_speed()
	return speed || SEX_SPEED_LOW

/datum/sex_session/proc/get_current_force()
	return force || SEX_FORCE_LOW

/datum/sex_session/proc/set_current_speed(new_speed)
	speed = clamp(new_speed, SEX_SPEED_MIN, SEX_SPEED_MAX)

/datum/sex_session/proc/set_current_force(new_force)
	force = clamp(new_force, SEX_FORCE_MIN, SEX_FORCE_MAX)
