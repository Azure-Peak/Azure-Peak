/obj/structure/roguemachine/contractledger/proc/play_reject_sound()
	playsound(src, 'sound/misc/machineno.ogg', 80, FALSE, -1)

/obj/structure/roguemachine/contractledger/proc/sign_contract(mob/user, ref)
	if(!ref)
		return
	if(!SStreasury.has_account(user))
		say("You have no bank account. Register with a Meister first.")
		play_reject_sound()
		return
	var/datum/quest/Q = locate(ref) in SSquestpool.pool
	if(!Q)
		say("That contract is no longer available.")
		play_reject_sound()
		return
	if(Q.quest_giver_name && Q.quest_giver_name == user.real_name && !Q.issuer_may_claim && !SSquestpool.debug_mode)
		say("You can't sign your own contract.")
		play_reject_sound()
		return

	if(is_quest_claim_barred(user))
		say("Your office forbids you from signing contracts.")
		play_reject_sound()
		return

	if(!is_townie_contract_gate_exempt(user))
		var/elapsed = world.time - SSticker.round_start_time
		if(elapsed < CONTRACT_TOWNIE_GATE_TIME)
			var/remaining_min = round((CONTRACT_TOWNIE_GATE_TIME - elapsed) / (1 MINUTES))
			say("For now, only sellswords and the like can sign contracts. You can sign in [remaining_min]m.")
			play_reject_sound()
			return

	var/active_cap = get_active_quest_cap(user)
	if(count_user_active_contracts(user) >= active_cap)
		say("You already hold [active_cap] contracts. Finish one before signing another.")
		play_reject_sound()
		return

	if(SSquestpool.is_on_take_cooldown(user))
		var/remaining_seconds = round(SSquestpool.take_cooldown_remaining(user) / 10)
		say("You've signed too many contracts recently. Wait [remaining_seconds]s before signing another.")
		play_reject_sound()
		return

	var/deposit = Q.deposit_amount
	if(SStreasury.get_balance(user) < deposit)
		say("You need [deposit] mammon in your account for the deposit.")
		play_reject_sound()
		return

	if(!Q.can_claim(user))
		say(Q.claim_failure_reason(user))
		play_reject_sound()
		return

	if(!SSquestpool.claim(Q, user))
		say("That contract can't be signed right now. Try another.")
		play_reject_sound()
		return

	SSquestpool.mark_taken(user)

	Q.bind_new_scroll(user, get_turf(src))
	log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type]")
	Q.take_deposit(SStreasury.get_account(user))

/obj/structure/roguemachine/contractledger/proc/resolve_turnin_mode(mob/user, obj/item/quest_writ/scroll, mob/living/holder)
	if(user in scroll.get_quest_assignees(user))
		return QUEST_TURNIN_SELF
	var/is_issuer = user.real_name == scroll.assigned_quest?.quest_giver_name
	if(istype(holder) && !is_issuer)
		var/datum/fellowship/F = holder.current_fellowship
		if(F && F.has_member(user))
			return QUEST_TURNIN_FELLOWSHIP
	if(user.job in GLOB.contract_proxy_officials)
		return QUEST_TURNIN_OFFICIAL
	return null

/obj/structure/roguemachine/contractledger/proc/turn_in_contract(mob/user, obj/item/quest_writ/scroll_in_hand)
	var/datum/quest/Q = scroll_in_hand.assigned_quest
	if(!Q)
		return
	var/mob/living/holder = Q.quest_receiver_reference?.resolve()
	var/mode = resolve_turnin_mode(user, scroll_in_hand, holder)
	if(!mode)
		to_chat(user, span_warning("This contract isn't yours to turn in."))
		return
	turn_in_scroll(user, scroll_in_hand, mode, holder)

/obj/structure/roguemachine/contractledger/proc/turn_in_scroll(mob/user, obj/item/quest_writ/scroll, mode = QUEST_TURNIN_SELF, mob/holder)
	if(!scroll.assigned_quest?.complete)
		return

	var/datum/quest/completed_quest = scroll.assigned_quest
	var/holder_name = completed_quest.quest_receiver_name
	var/mob/beneficiary = (mode == QUEST_TURNIN_OFFICIAL) ? holder : user
	var/datum/fund/benef_account = SStreasury.get_account(beneficiary)
	if(!benef_account)
		if(mode == QUEST_TURNIN_OFFICIAL)
			say("[holder_name] has no bank account. The reward can't be paid.")
		else
			say("You have no bank account. Register with a Meister before turning in the contract.")
		return

	var/base_reward = completed_quest.reward_amount
	var/deposit_return = completed_quest.return_deposit("contract deposit returned - [src.name]")

	completed_quest.record_completion_stats(base_reward)

	var/tax_amt = 0
	var/guild_fee_paid = 0
	var/list/shares = completed_quest.fellowship_shares(base_reward, beneficiary)
	var/split_ways = completed_quest.fellowship_split_payout ? length(completed_quest.fellowship_roster) : 0
	var/share_memo = split_ways ? "Contract Reward (Split) - [src.name]" : "contract reward - [src.name]"
	var/paid_out = 0
	var/list/nets = list()
	for(var/mob/living/payee as anything in shares)
		var/datum/fund/payee_account = SStreasury.get_account(payee)
		var/payee_tax = completed_quest.pay_reward(payee_account, payee, shares[payee], share_memo, src.name)
		var/payee_fee = pay_innkeeper_referral_fees(payee_account, completed_quest, shares[payee])
		tax_amt += payee_tax
		guild_fee_paid += payee_fee
		nets[payee] = shares[payee] - payee_tax - payee_fee
		paid_out += shares[payee]
	var/leftover = base_reward - paid_out
	var/mob/living/sink = completed_quest.fellowship_leftover_sink(shares, beneficiary)
	if(leftover > 0 && sink)
		var/datum/fund/sink_account = SStreasury.get_account(sink)
		tax_amt += completed_quest.pay_reward(sink_account, sink, leftover, "Contract Reward (No account leftover) - [src.name]", src.name)
		guild_fee_paid += pay_innkeeper_referral_fees(sink_account, completed_quest, leftover)
	var/unbanked = split_ways ? split_ways - length(shares) : 0
	var/take_home = base_reward - tax_amt - guild_fee_paid
	SSquestpool.record_completion(user, completed_quest, take_home, tax_amt)
	qdel(completed_quest)
	qdel(scroll)

	var/list/deductions = list()
	if(tax_amt > 0)
		deductions += "[tax_amt] mammon of contract levy"
	if(guild_fee_paid > 0)
		deductions += "[guild_fee_paid] mammon for the Guild's cut"
	var/deductions_clause = length(deductions) ? ", less [english_list(deductions)]" : ""
	var/deposit_clause = deposit_return > 0 ? " The deposit of [deposit_return] mammon is also returned." : ""
	if(split_ways)
		var/leftover_clause = unbanked > 0 ? " Because [unbanked] member[unbanked == 1 ? " does" : "s do"] not have an account, the remaining sum of [leftover] mammon is deposited into [sink.real_name]'s account." : ""
		var/list/net_values = list()
		for(var/mob/living/payee as anything in nets)
			net_values |= nets[payee]
		var/net_clause
		if(length(net_values) == 1)
			net_clause = "Each member receives [net_values[1]] mammon."
		else
			var/list/net_lines = list()
			for(var/mob/living/payee as anything in nets)
				net_lines += "[payee.real_name] [nets[payee]]"
			net_clause = "Shares: [jointext(net_lines, ", ")]."
		say("The reward of [base_reward] mammon[deductions_clause] for a purse of [take_home], has been split [split_ways] ways between [holder_name]'s fellowship. [net_clause][leftover_clause][deposit_clause]")
		return
	switch(mode)
		if(QUEST_TURNIN_OFFICIAL)
			say("On behalf of [holder_name], a reward of [base_reward] mammon has been credited to their account[deductions_clause].[deposit_clause]")
		if(QUEST_TURNIN_FELLOWSHIP)
			say("You turned in [holder_name]'s contract. [base_reward] mammon has been credited to you[deductions_clause].[deposit_clause]")
		else
			say("Your reward of [base_reward] mammon has been credited[deductions_clause].[deposit_clause]")

/obj/structure/roguemachine/contractledger/proc/can_admin_complete(mob/user)
	var/client/C = user?.client
	if(!C || !check_rights_for(C, R_DEBUG))
		return FALSE
	return isnull(C.address) || (C.address in list("127.0.0.1", "::1"))

/obj/structure/roguemachine/contractledger/proc/admin_complete_by_ref(mob/user, ref)
	if(!ref || !can_admin_complete(user))
		return
	var/datum/quest/matched_quest = locate(ref) in get_held_quests(user)
	if(!matched_quest)
		return
	var/obj/item/quest_writ/matched_scroll = matched_quest.quest_scroll_ref?.resolve()
	log_admin("[key_name(user)] force-completed a [matched_quest.quest_type] contract at the Contract Ledger.")
	if(!matched_quest.complete)
		matched_quest.force_complete()
	if(!QDELETED(matched_scroll) && matched_scroll.assigned_quest?.complete)
		turn_in_scroll(user, matched_scroll, QUEST_TURNIN_SELF)

/obj/structure/roguemachine/contractledger/proc/abandon_by_ref(mob/user, ref)
	if(!ref)
		return
	var/datum/quest/matched_quest = locate(ref) in get_held_quests(user)
	if(!matched_quest)
		to_chat(user, span_warning("That contract is not yours to abandon."))
		return
	var/obj/item/quest_writ/matched_scroll = matched_quest.quest_scroll_ref?.resolve()
	if(matched_quest.complete)
		to_chat(user, span_warning("That contract is already complete. Turn it in instead."))
		return
	var/forfeited = matched_quest.forfeit_deposit()
	log_quest(user.ckey, user.mind, user, "Abandon [matched_quest.quest_type]")
	SSquestpool.mark_abandoned(user, matched_quest, forfeited)
	var/refund_fraction = matched_quest.has_started() ? REFUND_ON_FAILURE : REFUND_ON_NOT_TAKEN
	SSquestpool.refund_closed_posting(matched_quest, QUEST_ISSUE_STATUS_ABANDONED, refund_fraction, "Abandoned posting refund", "was abandoned by [user.real_name]")
	if(forfeited > 0)
		to_chat(user, span_warning("You abandon the contract and lose your [forfeited] mammon deposit."))
	else
		to_chat(user, span_warning("You abandon the contract."))
	if(matched_scroll)
		matched_scroll.assigned_quest = null
	qdel(matched_quest)
	qdel(matched_scroll)


