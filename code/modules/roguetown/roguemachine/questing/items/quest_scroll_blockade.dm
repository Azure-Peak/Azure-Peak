/proc/format_blockade_time(deciseconds)
	if(deciseconds <= 0)
		return "0:00"
	var/total_seconds = round(deciseconds / 10)
	var/minutes = round(total_seconds / 60)
	var/seconds = total_seconds % 60
	return "[minutes]:[seconds < 10 ? "0[seconds]" : "[seconds]"]"

/obj/item/quest_writ/blockade
	name = "blockade defense writ"
	desc = "A stout writ sealed by the Steward, calling for armed answer to a trade blockade. \
	The bearer is enjoined to travel to the blockaded region and break three successive waves \
	of raiders - each wave must fall within seven minutes, and the writ lapses entirely if the \
	bearer dawdles too long before reaching the blockade. Hand this writ over to a \
	fellow-adventurer and they may initiate the contract; post it on a notice board and it \
	will demand a full Fellowship of three."
	icon_state = "scroll_quest_info"
	base_icon_state = "scroll_quest"
	var/last_arrival_check = 0

/obj/item/quest_writ/blockade/attack_self(mob/user)
	if(!assigned_quest)
		return ..()
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	if(!Q.quest_receiver_reference)
		if(!Q.can_claim(user))
			to_chat(user, span_warning(Q.claim_failure_reason(user)))
			return
		Q.quest_receiver_reference = WEAKREF(user)
		Q.quest_receiver_name = user.real_name
		to_chat(user, span_notice("You take up the blockade writ. Travel to the marked region - the waves will begin when you arrive."))
		var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
		if(landmark)
			Q.materialize(landmark)
		update_quest_text()
	opened = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)

/obj/item/quest_writ/blockade/process()
	. = ..()
	var/datum/quest/kill/blockade_defense/Q = assigned_quest
	if(!Q)
		return
	if(!Q.armed)
		return
	if(world.time < last_arrival_check + (5 SECONDS))
		return
	last_arrival_check = world.time
	var/mob/bearer = Q.quest_receiver_reference?.resolve()
	if(!bearer)
		return
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

/obj/item/quest_writ/blockade/proc/promote_to_board_gated()
	if(!assigned_quest)
		return
	assigned_quest.required_fellowship_size = BLOCKADE_FELLOWSHIP_REQUIREMENT
	update_quest_text()
