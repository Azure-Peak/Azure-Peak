/datum/fellowship_ui
	var/mob/living/holder

/datum/fellowship_ui/New(mob/living/user)
	if(!istype(user))
		CRASH("Fellowship UI created without a user")
	holder = user

/datum/fellowship_ui/Destroy(force)
	if(holder && GLOB.fellowship_uis_by_mob[holder] == src)
		GLOB.fellowship_uis_by_mob -= holder
	holder = null
	return ..()

/datum/fellowship_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/fellowship_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FellowshipPanel")
		GLOB.fellowship_uis_by_mob[user] = src
		ui.open()

/datum/fellowship_ui/ui_close()
	QDEL_NULL(src)

/datum/fellowship_ui/proc/refresh()
	var/datum/tgui/ui = SStgui.get_open_ui(holder, src)
	if(ui)
		ui.send_full_update()

/datum/fellowship_ui/ui_data(mob/user)
	// Everything the panel cares about is static and pushed on change. ui_data only carries
	// the server clock so the client can render countdowns for invite expiry without the
	// server refreshing every tick.
	return list("server_time" = world.time)

/datum/fellowship_ui/ui_static_data(mob/user)
	var/list/data = list()
	data["user_name"] = holder.real_name
	data["max_members"] = FELLOWSHIP_MAX_MEMBERS
	data["invite_expiry_ds"] = FELLOWSHIP_INVITE_EXPIRY
	var/datum/fellowship/F = holder.current_fellowship
	if(!F)
		data["in_fellowship"] = FALSE
		data["pending_invites"] = get_pending_invites_for(holder)
		return data
	F.prune_invites()
	var/list/living = F.get_members()
	var/mob/living/lead = F.get_leader()
	data["in_fellowship"] = TRUE
	data["fellowship_name"] = F.name
	data["is_leader"] = (lead == holder)
	data["leader_name"] = lead ? lead.real_name : null
	data["leader_present"] = !!lead
	var/list/member_data = list()
	for(var/mob/living/M in living)
		member_data += list(list(
			"name" = M.real_name,
			"is_leader" = (M == lead),
			"is_self" = (M == holder),
		))
	data["members"] = member_data
	var/list/invite_data = list()
	for(var/invitee_name in F.pending_invites)
		var/list/entry = F.pending_invites[invitee_name]
		invite_data += list(list(
			"name" = invitee_name,
			"expires_at" = entry[1],
		))
	data["outgoing_invites"] = invite_data
	return data

/datum/fellowship_ui/proc/get_pending_invites_for(mob/living/user)
	var/list/invites = list()
	for(var/datum/weakref/W as anything in user.incoming_fellowship_invites)
		var/datum/fellowship/F = W.resolve()
		if(QDELETED(F) || !(user.real_name in F.pending_invites))
			user.incoming_fellowship_invites -= W
			continue
		var/list/entry = F.pending_invites[user.real_name]
		if(entry[1] < world.time)
			F.remove_pending_invite(user.real_name)
			continue
		var/mob/living/lead = F.get_leader()
		invites += list(list(
			"fellowship_name" = F.name,
			"leader_name" = lead ? lead.real_name : "Unknown",
			"member_count" = length(F.get_members()),
			"max_members" = FELLOWSHIP_MAX_MEMBERS,
			"expires_at" = entry[1],
			"ref" = REF(F),
		))
	return invites

/datum/fellowship_ui/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("create")
			return handle_create(params)
		if("leave")
			return handle_leave()
		if("disband")
			return handle_disband()
		if("invite")
			return handle_invite()
		if("kick")
			return handle_kick(params)
		if("rescind")
			return handle_rescind(params)
		if("accept_invite")
			return handle_accept(params)

/datum/fellowship_ui/proc/handle_create(list/params)
	if(holder.current_fellowship)
		return TRUE
	var/raw = params["name"]
	if(!raw)
		raw = tgui_input_text(holder, "Name your fellowship:", "Fellowship", max_length = FELLOWSHIP_NAME_MAX_LEN)
	if(!raw)
		return TRUE
	var/candidate = trim(raw)
	if(length(candidate) < FELLOWSHIP_NAME_MIN_LEN)
		to_chat(holder, span_warning("That name is too short."))
		return TRUE
	if(length(candidate) > FELLOWSHIP_NAME_MAX_LEN)
		to_chat(holder, span_warning("That name is too long."))
		return TRUE
	if(!fellowship_name_available(candidate))
		to_chat(holder, span_warning("That fellowship name is already taken or invalid."))
		return TRUE
	new /datum/fellowship(holder, candidate)
	to_chat(holder, span_notice("You have founded the fellowship '[candidate]'."))
	return TRUE

/datum/fellowship_ui/proc/handle_leave()
	var/datum/fellowship/F = holder.current_fellowship
	if(!F)
		return TRUE
	if(F.is_leader(holder))
		F.disband()
		return TRUE
	F.remove_member(holder, reason = FELLOWSHIP_REASON_LEFT)
	return TRUE

/datum/fellowship_ui/proc/handle_disband()
	var/datum/fellowship/F = holder.current_fellowship
	if(!F)
		return TRUE
	if(!F.is_leader(holder))
		return TRUE
	F.disband()
	return TRUE

/datum/fellowship_ui/proc/handle_invite()
	var/datum/fellowship/F = holder.current_fellowship
	if(!F || !F.is_leader(holder))
		return TRUE
	var/list/living = F.get_members()
	if(length(living) >= FELLOWSHIP_MAX_MEMBERS)
		to_chat(holder, span_warning("The fellowship is full."))
		return TRUE
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in view(7, holder))
		if(H == holder)
			continue
		if(H.current_fellowship)
			continue
		if(F.has_member(H))
			continue
		candidates[H.real_name] = H
	if(!length(candidates))
		to_chat(holder, span_warning("There is no one nearby you can invite."))
		return TRUE
	var/choice = tgui_input_list(holder, "Invite whom to the fellowship?", "Fellowship", candidates)
	if(!choice)
		return TRUE
	var/mob/living/target = candidates[choice]
	if(!target)
		return TRUE
	F.invite(holder, target)
	return TRUE

/datum/fellowship_ui/proc/handle_kick(list/params)
	var/datum/fellowship/F = holder.current_fellowship
	if(!F || !F.is_leader(holder))
		return TRUE
	var/target_name = params["name"]
	if(!target_name)
		return TRUE
	for(var/mob/living/M in F.get_members())
		if(M.real_name == target_name)
			F.kick(holder, M)
			return TRUE
	return TRUE

/datum/fellowship_ui/proc/handle_rescind(list/params)
	var/datum/fellowship/F = holder.current_fellowship
	if(!F || !F.is_leader(holder))
		return TRUE
	F.rescind_invite(holder, params["name"])
	return TRUE

/datum/fellowship_ui/proc/handle_accept(list/params)
	if(holder.current_fellowship)
		return TRUE
	var/ref = params["ref"]
	if(!ref)
		return TRUE
	var/datum/fellowship/F = locate(ref) in GLOB.fellowships
	if(!F)
		return TRUE
	F.accept_invite(holder)
	return TRUE
