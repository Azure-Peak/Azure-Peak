/obj/item/paper/scroll/quest/blockade
	name = "blockade defense writ"
	desc = "A stout writ sealed by the Steward, calling for armed answer to a trade blockade. \
	The bearer is enjoined to travel to the blockaded region and break three successive waves \
	of raiders. Hand this writ over to a fellow-adventurer and they may initiate the contract; \
	post it on a notice board and it will demand a full Fellowship of three."
	icon_state = "scroll_quest_info"
	base_icon_state = "scroll_quest"

/// Bearer-bond: first open claims and fires wave 1. The fellowship gate is set by
/// promote_to_board_gated() when the scroll is pinned to a notice board — hand-offs
/// bypass it so a Steward can hand-pick a trusted party off-book.
/obj/item/paper/scroll/quest/blockade/attack_self(mob/user)
	if(!assigned_quest)
		return ..()
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	if(!Q.quest_receiver_reference)
		if(!Q.can_claim(user))
			to_chat(user, span_warning(Q.claim_failure_reason(user)))
			return
		Q.quest_receiver_reference = WEAKREF(user)
		Q.quest_receiver_name = user.real_name
		to_chat(user, span_notice("You take up the blockade writ. Travel to the marked region — the waves will begin when you arrive."))
		var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
		if(landmark)
			Q.materialize(landmark)
		update_quest_text()
	open = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)

/// Piggybacks on the base scroll's whisper tick. Once the bearer is near the landmark,
/// fire wave 1 via the quest's check_arrival helper. Before arrival the quest is armed
/// but dormant - no mobs spawned, no timer ticking.
/obj/item/paper/scroll/quest/blockade/process()
	. = ..()
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	if(!Q || !Q.armed)
		return
	var/mob/bearer = Q.quest_receiver_reference?.resolve()
	if(!bearer)
		return
	// Only count the bearer as "arrived" if they physically hold the scroll.
	var/atom/loc_chain = src.loc
	var/found_bearer = FALSE
	while(loc_chain)
		if(loc_chain == bearer)
			found_bearer = TRUE
			break
		if(isturf(loc_chain))
			break
		loc_chain = loc_chain.loc
	if(!found_bearer)
		return
	Q.check_arrival(bearer)

/obj/item/paper/scroll/quest/blockade/proc/promote_to_board_gated()
	if(!assigned_quest)
		return
	assigned_quest.required_fellowship_size = BLOCKADE_FELLOWSHIP_REQUIREMENT
	update_quest_text()

/obj/item/paper/scroll/quest/blockade/update_quest_text()
	if(!assigned_quest)
		return
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	var/datum/blockade/B = Q.blockade_ref?.resolve()
	var/datum/economic_region/ER = B?.get_region()
	var/datum/quest_faction/F = Q.faction
	var/region_label = ER ? ER.name : "an unspecified region"
	var/faction_label = F ? "a [F.group_word] of [F.name_plural]" : "raiders"

	var/scroll_text = "<center><b>BLOCKADE DEFENSE WRIT</b></center><br>"
	scroll_text += "<center><i>[Q.get_title()]</i></center><br>"
	scroll_text += "<b>Issued by:</b> [Q.quest_giver_name || "The Crown"].<br>"
	scroll_text += "<b>Issued to:</b> [Q.quest_receiver_name || "whoever it may concern"].<br>"
	scroll_text += "<b>Target:</b> [region_label], beset by [faction_label].<br>"
	if(Q.required_fellowship_size > 0)
		scroll_text += "<b>Fellowship required:</b> at least <b>[Q.required_fellowship_size]</b>.<br>"
	scroll_text += "<br>"

	if(Q.failed)
		scroll_text += "<center><font color='#c44'><b>BLOCKADE HELD. THE WRIT HAS LAPSED.</b></font></center>"
	else if(Q.complete)
		scroll_text += "<center><font color='#5cb85c'><b>THE BLOCKADE IS BROKEN.</b></font></center><br>"
		scroll_text += "The Crown has deposited [BLOCKADE_SCROLL_REWARD] mammon to the bearer's account."
	else if(Q.armed)
		scroll_text += "<b>Objective:</b> Travel to [region_label]. The raiders will descend upon your arrival.<br>"
		if(last_compass_direction)
			scroll_text += "<b>Direction:</b> The raiders are[last_compass_direction]. "
			if(last_z_level_hint)
				scroll_text += "([last_z_level_hint])"
			scroll_text += "<br>"
		scroll_text += "<b>Reward:</b> [BLOCKADE_SCROLL_REWARD] mammon to the lead bearer on breaking the third wave.<br>"
		scroll_text += "<br><i>Three waves descend once you reach the blockade. Each wave must fall within five minutes, or the writ is forfeit.</i>"
	else
		scroll_text += "<b>Objective:</b> [Q.get_objective_text()]<br>"
		if(Q.current_wave > 0)
			scroll_text += "<b>Wave progress:</b> [Q.progress_current]/[Q.progress_required] felled this wave.<br>"
		if(last_compass_direction)
			scroll_text += "<b>Direction:</b> The raiders are[last_compass_direction]. "
			if(last_z_level_hint)
				scroll_text += "([last_z_level_hint])"
			scroll_text += "<br>"
		scroll_text += "<b>Reward:</b> [BLOCKADE_SCROLL_REWARD] mammon to the lead bearer on breaking the third wave.<br>"

	info = scroll_text
	update_icon()
