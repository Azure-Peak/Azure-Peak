/obj/structure/roguemachine/contractledger/proc/play_reject_sound()
	playsound(src, 'sound/misc/machineno.ogg', 80, FALSE, -1)

/obj/structure/roguemachine/contractledger/proc/sign_contract(mob/user, ref)
	if(!ref)
		return
	if(!SStreasury.has_account(user))
		say("[user.real_name] has no bank account on record.")
		play_reject_sound()
		return
	var/datum/quest/Q = locate(ref) in SSquestpool.pool
	if(!Q)
		say("That contract is no longer available.")
		play_reject_sound()
		return
	if(Q.quest_giver_name && Q.quest_giver_name == user.real_name)
		say("You cannot sign a contract you yourself put on the board.")
		play_reject_sound()
		return

	if(!is_townie_contract_gate_exempt(user))
		var/elapsed = world.time - SSticker.round_start_time
		if(elapsed < CONTRACT_TOWNIE_GATE_TIME)
			var/remaining_min = round((CONTRACT_TOWNIE_GATE_TIME - elapsed) / (1 MINUTES))
			say("This contract is reserved for sellswords and the like. Members of the town may sign after [remaining_min]m.")
			play_reject_sound()
			return

	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	var/active_cap = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	if(count_user_active_contracts(user) >= active_cap)
		say("You are already committed to [active_cap] contracts. Complete one before signing another.")
		play_reject_sound()
		return

	if(SSquestpool.is_on_take_cooldown(user))
		var/remaining_seconds = round(SSquestpool.take_cooldown_remaining(user) / 10)
		say("You have taken your fill of contracts. Wait [remaining_seconds]s before signing another.")
		play_reject_sound()
		return

	var/deposit = Q.deposit_amount
	if(SStreasury.get_balance(user) < deposit)
		say("Insufficient balance. This contract requires a [deposit] mammon deposit.")
		play_reject_sound()
		return

	if(!Q.can_claim(user))
		say(Q.claim_failure_reason(user))
		play_reject_sound()
		return

	if(!SSquestpool.claim(Q, user))
		say("That contract could not be dispatched. Try another.")
		play_reject_sound()
		return

	SSquestpool.mark_taken(user)

	var/obj/item/quest_writ/spawned_scroll = new(get_turf(src))
	user.put_in_hands(spawned_scroll)
	log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type]")
	spawned_scroll.base_icon_state = Q.get_scroll_icon()
	spawned_scroll.assigned_quest = Q
	Q.quest_scroll = spawned_scroll
	Q.quest_scroll_ref = WEAKREF(spawned_scroll)
	spawned_scroll.update_quest_text()

	SStreasury.transfer(SStreasury.get_account(user), SStreasury.discretionary_fund, deposit, "quest deposit")

/obj/structure/roguemachine/contractledger/proc/turn_in_contract(mob/user, obj/item/quest_writ/scroll_in_hand)
	var/list/mob/quest_assignees = scroll_in_hand.get_quest_assignees(user, TRUE)
	if(!(user in quest_assignees))
		to_chat(user, span_warning("You are not the assigned quest receiver for this contract!"))
		return
	turn_in_scroll(user, scroll_in_hand)

/obj/structure/roguemachine/contractledger/proc/turn_in_scroll(mob/user, obj/item/quest_writ/scroll)
	if(!scroll.assigned_quest?.complete)
		return

	var/datum/fund/user_account = SStreasury.get_account(user)
	if(!user_account)
		say("No account on record - register with a Meister before turning in the contract.")
		return

	var/base_reward = scroll.assigned_quest.reward_amount
	var/deposit_return = scroll.assigned_quest.calculate_deposit()
	var/gross_reward = round(base_reward + deposit_return)
	var/original_reward = base_reward + deposit_return

	var/datum/quest/completed_quest = scroll.assigned_quest
	var/quest_levy_exempt = completed_quest.levy_exempt
	qdel(scroll.assigned_quest)
	qdel(scroll)

	SStreasury.mint(user_account, gross_reward, "quest reward - [src.name]")

	// Levy applies only to the base reward, not the returned deposit. The deposit is the
	// bearer's own money being given back; taxing it would be a hidden levy on principal.
	var/tax_amt = 0
	if(!quest_levy_exempt)
		tax_amt = SStreasury.apply_tax(user_account, base_reward, TAX_CATEGORY_CONTRACT_LEVY, src.name)
		if(tax_amt > 0)
			record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, tax_amt)
			record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
	else
		var/levy_rate = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
		SStreasury.record_tax_exemption(TAX_CATEGORY_CONTRACT_LEVY, FLOOR(base_reward * levy_rate, 1))

	var/guild_fee_paid = pay_innkeeper_referral_fees(user_account, completed_quest, gross_reward)

	var/take_home = gross_reward - tax_amt - guild_fee_paid
	SSquestpool.record_completion(user, completed_quest, take_home, tax_amt)

	if(gross_reward > original_reward)
		say("Your handler-assisted reward of [gross_reward] mammon has been credited. The difference is [gross_reward - original_reward] mammon. ([tax_amt] taxed.)")
	else
		say("Your reward of [gross_reward] mammon has been credited. ([tax_amt] taxed.)")

/obj/structure/roguemachine/contractledger/proc/abandon_by_ref(mob/user, ref)
	if(!ref)
		return
	var/datum/weakref/user_ref = WEAKREF(user)
	var/obj/item/quest_writ/matched_scroll
	var/datum/quest/matched_quest
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.quest_receiver_reference != user_ref)
			continue
		if(REF(Q) != ref)
			continue
		matched_scroll = scroll
		matched_quest = Q
		break
	if(!matched_quest)
		to_chat(user, span_warning("That contract is not yours to abandon."))
		return
	if(matched_quest.complete)
		to_chat(user, span_warning("That contract is already complete - turn it in instead."))
		return
	var/forfeited = matched_quest.calculate_deposit()
	log_quest(user.ckey, user.mind, user, "Abandon [matched_quest.quest_type]")
	SSquestpool.mark_abandoned(user, matched_quest, forfeited)
	to_chat(user, span_warning("The contract is voided. Your deposit of [forfeited] mammon is forfeit to the treasury."))
	matched_scroll.assigned_quest = null
	qdel(matched_quest)
	qdel(matched_scroll)


