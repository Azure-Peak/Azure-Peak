/datum/fellowship
	var/name
	var/faction_tag
	var/datum/weakref/leader
	var/list/members = list()
	// pending_invites[real_name] = list(expires_at_world_time, /datum/weakref of target mob)
	var/list/pending_invites = list()
	var/list/active_contracts = list()
	var/created_time

/datum/fellowship/New(mob/living/founder, chosen_name)
	if(!istype(founder) || !chosen_name)
		CRASH("Fellowship created without founder or name")
	name = chosen_name
	faction_tag = "[FELLOWSHIP_FACTION_PREFIX][ckey(chosen_name)]"
	leader = WEAKREF(founder)
	created_time = world.time
	GLOB.fellowships += src
	add_member(founder)

/datum/fellowship/Destroy()
	for(var/datum/weakref/W in members)
		var/mob/living/M = W.resolve()
		if(M)
			strip_fellowship_from(M)
	members.Cut()
	for(var/invitee_name in pending_invites)
		clear_invitee_list(pending_invites[invitee_name])
	pending_invites.Cut()
	leader = null
	active_contracts.Cut()
	GLOB.fellowships -= src
	return ..()

/datum/fellowship/proc/get_leader()
	var/mob/living/M = leader?.resolve()
	if(QDELETED(M))
		return null
	return M

/datum/fellowship/proc/get_members()
	var/list/resolved = list()
	for(var/datum/weakref/W as anything in members)
		var/mob/living/M = W.resolve()
		if(QDELETED(M))
			members -= W
			continue
		resolved += M
	return resolved

/datum/fellowship/proc/is_leader(mob/living/user)
	return user && get_leader() == user

/datum/fellowship/proc/find_member_ref(mob/living/user)
	if(!user)
		return null
	for(var/datum/weakref/W as anything in members)
		if(W.resolve() == user)
			return W
	return null

/datum/fellowship/proc/has_member(mob/living/user)
	return !!find_member_ref(user)

/datum/fellowship/proc/add_member(mob/living/user)
	if(!istype(user) || QDELETED(user))
		return FALSE
	if(has_member(user))
		return FALSE
	var/list/living = get_members()
	if(length(living) >= FELLOWSHIP_MAX_MEMBERS)
		return FALSE
	if(user.current_fellowship && user.current_fellowship != src)
		return FALSE
	members += WEAKREF(user)
	user.current_fellowship = src
	user.faction |= faction_tag
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(on_member_qdel), override = TRUE)
	remove_pending_invite(user.real_name)
	to_chat(user, span_notice("You have joined the fellowship '[name]'."))
	notify_members("[user.real_name] has joined the fellowship.", exclude = user)
	push_updates()
	return TRUE

/datum/fellowship/proc/remove_member(mob/living/user, reason = FELLOWSHIP_REASON_LEFT)
	if(!user)
		return FALSE
	var/datum/weakref/W = find_member_ref(user)
	if(!W)
		return FALSE
	members -= W
	strip_fellowship_from(user)
	switch(reason)
		if(FELLOWSHIP_REASON_KICKED)
			to_chat(user, span_warning("You have been removed from the fellowship '[name]'."))
			notify_members("[user.real_name] has been removed from the fellowship.")
		if(FELLOWSHIP_REASON_DESTROYED)
			notify_members("[user.real_name] is no longer among the fellowship.")
		else
			to_chat(user, span_notice("You have left the fellowship '[name]'."))
			notify_members("[user.real_name] has left the fellowship.")
	if(!check_auto_disband())
		push_updates()
	return TRUE

/datum/fellowship/proc/strip_fellowship_from(mob/living/user)
	if(!user)
		return
	UnregisterSignal(user, COMSIG_PARENT_QDELETING)
	user.faction -= faction_tag
	if(user.current_fellowship == src)
		user.current_fellowship = null

/datum/fellowship/proc/on_member_qdel(mob/living/source)
	SIGNAL_HANDLER
	var/datum/weakref/W = find_member_ref(source)
	if(W)
		members -= W
	if(source.current_fellowship == src)
		source.current_fellowship = null
	source.faction -= faction_tag
	if(!check_auto_disband())
		push_updates()

/datum/fellowship/proc/check_auto_disband()
	var/list/living = get_members()
	if(!length(living) || !get_leader())
		disband(reason = "auto")
		return TRUE
	return FALSE

/datum/fellowship/proc/disband(reason = "leader")
	notify_members("The fellowship '[name]' has been disbanded.")
	var/list/affected = get_members()
	for(var/invitee_name in pending_invites)
		var/list/entry = pending_invites[invitee_name]
		var/datum/weakref/TW = entry?[2]
		var/mob/target = TW?.resolve()
		if(target)
			affected |= target
	qdel(src)
	for(var/mob/M in affected)
		refresh_fellowship_ui_for(M)

/datum/fellowship/proc/notify_members(message, mob/living/exclude)
	for(var/mob/living/M in get_members())
		if(M == exclude)
			continue
		to_chat(M, span_notice("[message]"))

/datum/fellowship/proc/invite(mob/living/inviter, mob/living/target)
	if(!is_leader(inviter))
		to_chat(inviter, span_warning("Only the fellowship leader can invite others."))
		return FALSE
	if(!istype(target) || QDELETED(target))
		to_chat(inviter, span_warning("That target cannot be invited."))
		return FALSE
	if(target == inviter)
		return FALSE
	if(has_member(target))
		to_chat(inviter, span_warning("[target.real_name] is already in the fellowship."))
		return FALSE
	if(target.current_fellowship)
		to_chat(inviter, span_warning("[target.real_name] is already in a fellowship."))
		return FALSE
	if(length(get_members()) >= FELLOWSHIP_MAX_MEMBERS)
		to_chat(inviter, span_warning("The fellowship is full."))
		return FALSE
	pending_invites[target.real_name] = list(world.time + FELLOWSHIP_INVITE_EXPIRY, WEAKREF(target))
	target.incoming_fellowship_invites |= WEAKREF(src)
	var/href = "<a href='?src=[REF(src)];accept_invite=1;invitee=[target.real_name]'>\[Accept\]</a>"
	to_chat(target, span_notice("[inviter.real_name] has invited you to join the fellowship '[name]'. [href]"))
	to_chat(inviter, span_notice("You have invited [target.real_name] to the fellowship."))
	push_updates()
	refresh_fellowship_ui_for(target)
	return TRUE

/datum/fellowship/proc/rescind_invite(mob/living/user, invitee_name)
	if(!is_leader(user))
		return FALSE
	if(!(invitee_name in pending_invites))
		return FALSE
	remove_pending_invite(invitee_name)
	to_chat(user, span_notice("You have rescinded the invitation for [invitee_name]."))
	push_updates()
	return TRUE

/datum/fellowship/proc/remove_pending_invite(invitee_name)
	var/list/entry = pending_invites[invitee_name]
	if(!entry)
		return
	clear_invitee_list(entry)
	pending_invites -= invitee_name

/datum/fellowship/proc/clear_invitee_list(list/entry)
	var/datum/weakref/TW = entry?[2]
	var/mob/living/target = TW?.resolve()
	if(target)
		target.incoming_fellowship_invites -= WEAKREF(src)
		refresh_fellowship_ui_for(target)

/datum/fellowship/proc/prune_invites()
	var/changed = FALSE
	for(var/invitee_name in pending_invites)
		var/list/entry = pending_invites[invitee_name]
		if(entry[1] < world.time)
			remove_pending_invite(invitee_name)
			changed = TRUE
	if(changed)
		push_updates()
	return changed

/datum/fellowship/proc/accept_invite(mob/living/user)
	if(!istype(user))
		return FALSE
	prune_invites()
	if(!(user.real_name in pending_invites))
		to_chat(user, span_warning("That invitation has expired or was rescinded."))
		return FALSE
	return add_member(user)

/datum/fellowship/proc/kick(mob/living/kicker, mob/living/target)
	if(!is_leader(kicker))
		return FALSE
	if(target == kicker)
		return FALSE
	if(!has_member(target))
		return FALSE
	return remove_member(target, reason = FELLOWSHIP_REASON_KICKED)

/datum/fellowship/proc/push_updates()
	for(var/datum/weakref/W as anything in members)
		var/mob/M = W.resolve()
		if(M)
			refresh_fellowship_ui_for(M)
	for(var/invitee_name in pending_invites)
		var/list/entry = pending_invites[invitee_name]
		var/datum/weakref/TW = entry?[2]
		var/mob/target = TW?.resolve()
		if(target)
			refresh_fellowship_ui_for(target)

/datum/fellowship/Topic(href, href_list)
	if(href_list["accept_invite"])
		var/mob/living/user = usr
		if(!istype(user))
			return
		if(user.real_name != href_list["invitee"])
			return
		accept_invite(user)
		return
	return ..()
