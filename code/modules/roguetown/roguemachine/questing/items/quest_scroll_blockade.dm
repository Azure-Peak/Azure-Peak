/proc/format_blockade_time(deciseconds)
	if(deciseconds <= 0)
		return "0:00"
	var/total_seconds = round(deciseconds / 10)
	var/minutes = round(total_seconds / 60)
	var/seconds = total_seconds % 60
	return "[minutes]:[seconds < 10 ? "0[seconds]" : "[seconds]"]"

/obj/item/quest_writ/blockade
	name = "blockade defense scroll"
	desc = "A scroll to break a blockade. Travel to the blockaded region and defeat three waves of raiders. \
	Each wave must fall within fifteen minutes. The Steward may recall the scroll if you take too long to get there. \
	Hand it to someone to start the contract. Pinned to the Contract Ledger, it needs a fellowship of three. \
	The blockade grows harder and richer with each defender past the third, up to six. \
	If brigands hold stolen Crown coin, breaking the blockade seizes the hoard. The Crown taxes it as Recovered Spoils."
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
		if(!SStreasury.has_account(user))
			to_chat(user, span_warning("You have no bank account. Register with a Meister before taking a contract."))
			return
		Q.on_claim(user)
		to_chat(user, span_notice("You take up the blockade scroll. Travel to the marked region. The first wave begins when you arrive."))
		var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
		if(landmark)
			Q.materialize(landmark)
			Q.materialized = TRUE
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
