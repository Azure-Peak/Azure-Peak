/obj/structure/roguemachine/contractledger/proc/sign_contract(mob/user, ref)
	if(!ref)
		return
	if(!SStreasury.has_account(user))
		say("[user.real_name] has no bank account on record.")
		return
	var/datum/quest/Q = locate(ref) in SSquestpool.pool
	if(!Q)
		say("That contract is no longer available.")
		return
	if(Q.quest_giver_name && Q.quest_giver_name == user.real_name)
		say("You cannot sign a contract you yourself put on the board.")
		return

	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	var/active_cap = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	if(count_user_active_contracts(user) >= active_cap)
		say("You are already committed to [active_cap] contracts. Complete one before signing another.")
		return

	if(SSquestpool.is_on_take_cooldown(user))
		var/remaining_seconds = round(SSquestpool.take_cooldown_remaining(user) / 10)
		say("You have taken your fill of contracts. Wait [remaining_seconds]s before signing another.")
		return

	var/deposit = Q.deposit_amount
	if(SStreasury.get_balance(user) < deposit)
		say("Insufficient balance. This contract requires a [deposit] mammon deposit.")
		return

	if(!Q.can_claim(user))
		say(Q.claim_failure_reason(user))
		return

	if(!SSquestpool.claim(Q, user))
		say("That contract could not be dispatched. Try another.")
		return

	SSquestpool.mark_taken(user)

	var/obj/item/paper/scroll/quest/spawned_scroll = new(get_turf(src))
	user.put_in_hands(spawned_scroll)
	log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type]")
	spawned_scroll.base_icon_state = Q.get_scroll_icon()
	spawned_scroll.assigned_quest = Q
	Q.quest_scroll = spawned_scroll
	Q.quest_scroll_ref = WEAKREF(spawned_scroll)
	spawned_scroll.update_quest_text()

	SStreasury.transfer(SStreasury.get_account(user), SStreasury.discretionary_fund, deposit, "quest deposit")

/obj/structure/roguemachine/contractledger/proc/turn_in_contract(mob/user, obj/item/paper/scroll/quest/scroll_in_hand)
	var/list/mob/quest_assignees = scroll_in_hand.get_quest_assignees(user, TRUE)
	if(!(user in quest_assignees))
		to_chat(user, span_warning("You are not the assigned quest receiver for this contract!"))
		return
	turn_in_scroll(user, scroll_in_hand)

/obj/structure/roguemachine/contractledger/proc/turn_in_scroll(mob/user, obj/item/paper/scroll/quest/scroll)
	if(!scroll.assigned_quest?.complete)
		return

	var/base_reward = scroll.assigned_quest.reward_amount
	var/deposit_return = scroll.assigned_quest.calculate_deposit()
	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	var/gross_reward = (mob_job?.is_quest_giver ? base_reward * QUEST_HANDLER_REWARD_MULTIPLIER : base_reward) + deposit_return
	gross_reward = round(gross_reward)
	var/original_reward = base_reward + deposit_return

	var/datum/quest/completed_quest = scroll.assigned_quest
	var/quest_levy_exempt = completed_quest.levy_exempt
	qdel(scroll.assigned_quest)
	qdel(scroll)

	var/datum/fund/user_account = SStreasury.get_account(user)
	if(!user_account)
		say("No account on record - reward cannot be paid.")
		return

	SStreasury.mint(user_account, gross_reward, "quest reward - [src.name]")

	var/tax_amt = 0
	if(!quest_levy_exempt)
		tax_amt = SStreasury.apply_tax(user_account, gross_reward, TAX_CATEGORY_CONTRACT_LEVY, src.name)
		if(tax_amt > 0)
			record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, tax_amt)
			record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)

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
	var/obj/item/paper/scroll/quest/matched_scroll
	var/datum/quest/matched_quest
	for(var/obj/item/paper/scroll/quest/scroll in GLOB.quest_scrolls)
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

/obj/structure/roguemachine/contractledger/proc/print_contracts(mob/user)
	var/list/active_quests = list()
	for(var/obj/item/paper/scroll/quest/quest_scroll in GLOB.quest_scrolls)
		if(quest_scroll.assigned_quest && !quest_scroll.assigned_quest.complete)
			active_quests += quest_scroll

	if(!length(active_quests))
		say("No active contracts found.")
		return

	var/obj/item/paper/scroll/report = new(get_turf(src))
	report.name = "Guild Contract Report"
	report.desc = "A list of currently active contracts issued by the Mercenary's Guild."

	var/report_text = "<center><b>MERCENARY'S GUILD - ACTIVE CONTRACTS</b></center><br><br>"
	report_text += "<i>Generated on [station_time_timestamp()]</i><br><br>"

	for(var/obj/item/paper/scroll/quest/quest_scroll in active_quests)
		var/datum/quest/quest = quest_scroll.assigned_quest
		var/area/quest_area = get_area(quest_scroll)
		report_text += "<b>Title:</b> [quest.title].<br>"
		report_text += "<b>Issuer:</b> [quest.quest_giver_name ? quest.quest_giver_name : "Mercenary's Guild"].<br>"
		report_text += "<b>Recipient:</b> [quest.quest_receiver_name ? quest.quest_receiver_name : "Unclaimed"].<br>"
		report_text += "<b>Type:</b> [quest.quest_type].<br>"
		report_text += "<b>Difficulty:</b> [quest.quest_difficulty].<br>"
		report_text += "<b>Last Known Location:</b> [quest_area ? quest_area.name : "Unknown Location"].<br>"
		report_text += "<b>Reward:</b> [quest.reward_amount] mammons.<br><br>"

	report.info = report_text
	say("Contract report printed.")
