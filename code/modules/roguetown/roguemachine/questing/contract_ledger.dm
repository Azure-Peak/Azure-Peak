/obj/structure/roguemachine/contractledger
	name = "Grand Contract Ledger"
	desc = "A massive ledger book with gilded edges, sitting atop a pedestal with the Mercenary's Guild banner. Its myriad enchanted pages are filled with various contracts and bounties issued by Mercenary's Guild, with arcane scripts that appears and fades as contracts are issued and completed."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "contractledger"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	layer = GAME_PLANE_UPPER
	/// Turf south of the ledger, marked with a drop-here decal. Retrieval-quest items carry a
	/// component that consumes them on any tile bearing this decal.
	var/input_point

/obj/structure/roguemachine/contractledger/Initialize()
	. = ..()
	input_point = locate(x, y - 1, z)
	var/obj/effect/decal/marker_export/marker = new(get_turf(input_point))
	marker.desc = "Drop retrieval-quest items here to turn them in."
	marker.layer = ABOVE_OBJ_LAYER
	SSquestpool.registered_ledgers += src

/obj/structure/roguemachine/contractledger/Destroy()
	SSquestpool.registered_ledgers -= src
	return ..()

/obj/structure/roguemachine/contractledger/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("<b>Left click</b> to open the Grand Contract Ledger, where you can sign new contracts and abandon ones you hold.")
	. += span_info("To <b>turn in</b> a completed contract, click the ledger while holding the quest scroll.")
	. += span_info("Retrieval-quest items should be <b>dropped onto the marked tile</b> in front of the ledger.")
	. += span_info("Abandoning a contract forfeits its deposit to the treasury and places you under a brief guild cooldown before you may abandon another.")

/obj/structure/roguemachine/contractledger/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = ..()
	if(istype(P, /obj/item/paper/scroll/quest))
		turn_in_contract(user, P)
		return
	return

/obj/structure/roguemachine/contractledger/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	ui_interact(user)

/obj/structure/roguemachine/contractledger/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/roguemachine/contractledger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ContractLedger")
		ui.open()

/obj/structure/roguemachine/contractledger/ui_data(mob/user)
	var/list/data = list()
	var/datum/job/mob_job = user?.job ? SSjob.GetJob(user.job) : null
	data["is_handler"] = !!mob_job?.is_quest_giver
	data["balance"] = SStreasury.bank_accounts[user] || 0
	data["active_max"] = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	data["active_count"] = count_user_active_contracts(user)
	data["pool"] = build_pool_listing()
	data["active"] = build_active_listing(user)
	return data

/obj/structure/roguemachine/contractledger/proc/build_pool_listing()
	var/list/listing = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool)
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "Unnamed Contract",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"reward" = Q.reward_amount,
			"deposit" = Q.deposit_amount,
			"area" = Q.target_spawn_area,
			"objective" = "",
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/build_active_listing(mob/user)
	var/list/listing = list()
	var/datum/weakref/user_ref = WEAKREF(user)
	for(var/obj/item/paper/scroll/quest/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q)
			continue
		if(Q.quest_receiver_reference != user_ref)
			continue
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "Unnamed Contract",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"area" = Q.target_spawn_area,
			"progress_current" = Q.progress_current,
			"progress_required" = Q.progress_required,
			"complete" = Q.complete,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/count_user_active_contracts(mob/user)
	var/datum/weakref/user_ref = WEAKREF(user)
	var/count = 0
	for(var/obj/item/paper/scroll/quest/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.complete)
			continue
		if(Q.quest_receiver_reference == user_ref)
			count++
	return count

/obj/structure/roguemachine/contractledger/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("sign")
			sign_contract(user, params["ref"])
			return TRUE
		if("abandon")
			abandon_by_ref(user, params["ref"])
			return TRUE
		if("print_active")
			var/datum/job/mob_job = user?.job ? SSjob.GetJob(user.job) : null
			if(mob_job?.is_quest_giver)
				print_contracts(user)
			return TRUE

/obj/structure/roguemachine/contractledger/proc/sign_contract(mob/user, ref)
	if(!ref)
		return
	if(!(user in SStreasury.bank_accounts))
		say("[user.real_name] has no bank account on record.")
		return
	var/datum/quest/Q = locate(ref) in SSquestpool.pool
	if(!Q)
		say("That contract is no longer available.")
		return

	var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
	var/active_cap = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	if(count_user_active_contracts(user) >= active_cap)
		say("You are already committed to [active_cap] contracts. Complete one before signing another.")
		return

	var/deposit = Q.deposit_amount
	if(SStreasury.bank_accounts[user] < deposit)
		say("Insufficient balance. This contract requires a [deposit] mammon deposit.")
		return

	if(!SSquestpool.claim(Q, user))
		say("That contract could not be dispatched. Try another.")
		return

	// Create scroll
	var/obj/item/paper/scroll/quest/spawned_scroll = new(get_turf(src))
	user.put_in_hands(spawned_scroll)
	log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type]")
	spawned_scroll.base_icon_state = Q.get_scroll_icon()
	spawned_scroll.assigned_quest = Q
	Q.quest_scroll = spawned_scroll
	Q.quest_scroll_ref = WEAKREF(spawned_scroll)
	spawned_scroll.update_quest_text()

	// Charge deposit. Deposit is forfeited on abandon and only returned on successful completion.
	SStreasury.bank_accounts[user] -= deposit
	SStreasury.treasury_value += deposit
	SStreasury.log_entries += "+[deposit] to treasury (quest deposit)"

/obj/structure/roguemachine/contractledger/proc/turn_in_contract(mob/user, obj/item/paper/scroll/quest/scroll_in_hand)
	var/list/mob/quest_assignees = scroll_in_hand.get_quest_assignees(user, TRUE)
	if(!(user in quest_assignees))
		to_chat(user, span_warning("You are not the assigned quest receiver for this contract!"))
		return
	turn_in_scroll(user, scroll_in_hand)

/obj/structure/roguemachine/contractledger/proc/turn_in_scroll(mob/user, obj/item/paper/scroll/quest/scroll)
	var/reward = 0
	var/original_reward = 0
	var/tax_rate = SStreasury.tax_value
	var/tax_amt = 0

	if(scroll.assigned_quest?.complete)
		// Calculate base reward
		var/base_reward = scroll.assigned_quest.reward_amount
		original_reward += base_reward

		// Deposit is returned only on successful completion.
		var/deposit_return = scroll.assigned_quest.calculate_deposit()

		// Apply bonus to the base reward, if appliciable (Steward, Merchant, Clerk, Councillor, Shophand, Duke)
		var/datum/job/mob_job = user.job ? SSjob.GetJob(user.job) : null
		if(mob_job?.is_quest_giver)
			reward += base_reward * QUEST_HANDLER_REWARD_MULTIPLIER
		else
			reward += base_reward

		reward += deposit_return
		original_reward += deposit_return

		var/datum/quest/completed_quest = scroll.assigned_quest
		qdel(scroll.assigned_quest)
		qdel(scroll)

		// Tax payment
		tax_amt = round(tax_rate * reward)
		if(tax_amt > 0)
			reward -= tax_amt
			SStreasury.give_money_treasury(tax_amt, "quest completion tax - [src.name]")
			record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, tax_amt)
			record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)

		SSquestpool.record_completion(user, completed_quest, round(reward), tax_amt)

	cash_in(round(reward), original_reward, tax_amt)

/obj/structure/roguemachine/contractledger/proc/cash_in(reward, original_reward, tax_amt)
	var/list/coin_types = list(
		/obj/item/roguecoin/gold = FLOOR(reward / 10, 1),
		/obj/item/roguecoin/silver = FLOOR(reward % 10 / 5, 1),
		/obj/item/roguecoin/copper = reward % 5
	)

	for(var/coin_type in coin_types)
		var/amount = coin_types[coin_type]
		if(amount > 0)
			var/obj/item/roguecoin/coin_stack = new coin_type(get_turf(src))
			coin_stack.quantity = amount
			coin_stack.update_icon()
			coin_stack.update_transform()

	if(reward > 0)
		say(reward > original_reward ? \
			"Your handler assistance-increased reward of [reward] mammons has been dispensed! The difference is [reward - original_reward] mammons. ([tax_amt] mammons taxed.)" : \
			"Your reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)")

/// Abandon handler: a scroll left in the input area is destroyed with its contract. The deposit
/// is NOT refunded - it's the cost of backing out.
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
	if(SSquestpool.is_on_abandon_cooldown(user))
		var/remaining_seconds = round(SSquestpool.abandon_cooldown_remaining(user) / 10)
		to_chat(user, span_warning("The guild is watching you. Wait [remaining_seconds]s before abandoning another contract."))
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
