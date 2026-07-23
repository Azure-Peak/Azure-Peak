/obj/item/quest_writ/towner
	name = "towner's contract scroll"
	desc = "A contract issued by a member of the town.\
	Hand it to an adventurer and they may take it up regardless of fellowship requirements. Pin it to the Grand Contract Ledger \
	and it waits for whomeever will sign"
	base_icon_state = "scroll_quest"

/obj/item/quest_writ/towner/attack_self(mob/user)
	if(!assigned_quest)
		return ..()
	var/datum/quest/Q = assigned_quest
	if(!Q.quest_receiver_reference)
		if(Q.quest_giver_name && Q.quest_giver_name == user.real_name)
			to_chat(user, span_warning("You cannot take a contract you yourself issued. Put it in another's hands."))
			return
		if(!SStreasury.has_account(user))
			to_chat(user, span_warning("No account on record - register with a Meister before taking a contract."))
			return
		if(!Q.can_claim(user))
			to_chat(user, span_warning(Q.claim_failure_reason(user)))
			return
		var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
		if(!landmark || !Q.materialize(landmark))
			to_chat(user, span_warning("Odd. It appears no landmark is available for this contract!"))
			return
		Q.materialized = TRUE
		Q.on_claim(user)
		log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type] (hand-delivered)")
		update_quest_text()
	opened = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)
