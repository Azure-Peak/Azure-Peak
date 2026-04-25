/// Maps a bonus-pay level (0=NONE, 1=LIGHT, 2=FULL) to its multiplier. Levels outside
/// the range collapse to 1.0x so a stray input can't accidentally inflate payouts.
/proc/get_commission_bonus_pay_mult(level)
	switch(level)
		if(COMMISSION_BONUS_PAY_LIGHT)
			return COMMISSION_BONUS_PAY_LIGHT_MULT
		if(COMMISSION_BONUS_PAY_FULL)
			return COMMISSION_BONUS_PAY_MULT
	return 1.0

/// Human-readable label for log lines and on-scroll annotations.
/proc/get_commission_bonus_pay_label(level)
	switch(level)
		if(COMMISSION_BONUS_PAY_LIGHT)
			return "light bonus pay"
		if(COMMISSION_BONUS_PAY_FULL)
			return "bonus pay"
	return ""

/// Snapshot of each blockade that currently has a writ in circulation, with recall eligibility.
/// Used by ContractLedgerSteward.tsx to show a "Recall Writ" button when the Steward picks
/// a blockaded region that still has an armed, pre-wave writ within the recall window.
/obj/structure/roguemachine/contractledger/proc/build_blockade_recall_list()
	var/list/out = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/obj/item/quest_writ/S = B.active_scroll_ref?.resolve()
		if(!S || QDELETED(S))
			continue
		var/datum/quest/kill/blockade_defense/Q = S.assigned_quest
		if(!istype(Q))
			continue
		var/datum/economic_region/ER = B.get_region()
		var/reason = Q.recall_blocker()
		var/recall_eligible = isnull(reason) ? TRUE : FALSE
		// Seconds until the recall window opens (issue + BLOCKADE_RECALL_WINDOW_DS).
		// Zero once the window is open or the writ has failed/engaged.
		var/seconds_until_recallable = 0
		if(Q.current_wave == 0 && !Q.failed && !Q.complete && Q.issued_at)
			var/elapsed = world.time - Q.issued_at
			var/until_open = BLOCKADE_RECALL_WINDOW_DS - elapsed
			if(until_open > 0)
				seconds_until_recallable = round(until_open / 10)
		out += list(list(
			"region" = ER ? ER.name : B.region_id,
			"recall_eligible" = recall_eligible,
			"recall_blocker" = reason,
			"seconds_until_recallable" = seconds_until_recallable,
			"refund" = Q.funding_cost,
			"refund_fund" = Q.funding_fund ? Q.funding_fund.name : null,
		))
	return out

/// Per-region TP budget multiplier, exposed so the Steward's UI can surface "this region
/// yields bigger payouts for the same draft cost" - kill/bounty rewards scale with
/// spawned TP, so a 1.5x region returns roughly 50% more reward than a 1.0x one on an
/// identical commission cost.
/obj/structure/roguemachine/contractledger/proc/build_region_tp_multipliers()
	var/list/out = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		out[TR.region_name] = TR.tp_budget_multiplier
	return out

/obj/structure/roguemachine/contractledger/proc/build_defense_regions_by_type()
	var/list/out = list()
	for(var/qtype in GLOB.defense_quest_tier_costs)
		var/list/regions = list()
		if(qtype == QUEST_BLOCKADE_DEFENSE)
			// All active blockades are listed regardless of scroll state. Regions with a
			// writ already out are still shown so the Steward can pick them to recall.
			// The UI decides whether the primary button says "Print Writ" or "Recall Writ"
			// based on the blockade_recall_list entry for that region.
			for(var/datum/blockade/B as anything in GLOB.active_blockades)
				var/datum/economic_region/ER = B.get_region()
				if(ER)
					regions += ER.name
		else
			for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
				if(!TR.allows_quest_type(qtype))
					continue
				regions += TR.region_name
		out[qtype] = regions
	return out

/obj/structure/roguemachine/contractledger/proc/commission_defense_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/steward = user
	if(!can_commission(steward))
		return
	if(!steward.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(steward, span_warning("The ledger is not yet open."))
		return

	var/chosen_type = params["type"]
	if(!(chosen_type in GLOB.defense_quest_tier_costs))
		to_chat(steward, span_warning("That quest type is not one the Crown commissions."))
		return

	// Alderman status is computed up front so funding and levy-exempt gates can reference it.
	// Stewards who happen to also be the Alderman act as Steward for the purposes of these gates -
	// the Steward's own authority is strictly broader.
	var/is_alderman_acting = SScity_assembly?.is_alderman(steward)
	if(is_alderman_acting && steward.job == "Steward")
		is_alderman_acting = FALSE

	// funding source: "pledge" (default), "crown" (discretionary fund), "directive" (free, capped).
	// Aldermen are restricted to "pledge" - they cannot draw Crown's Purse (the Assembly's warrant
	// is denominated in Pledge authority, and letting them also drain the Crown's coin double-dips
	// the realm's budget against the Commons' allowance) and cannot issue Requests (directive is
	// the Steward's administrative prerogative, a Crown officer commanding the staff it pays).
	var/funding = params["funding"] || "pledge"
	if(is_alderman_acting && funding != "pledge")
		to_chat(steward, span_warning("The Alderman's commission is paid from the Assembly's Pledge warrant alone. The Crown's Purse and the Steward's Request are not yours to command."))
		return

	var/cost = GLOB.defense_quest_tier_costs[chosen_type]
	// Bonus Pay: tri-state sweetener (NONE/LIGHT/FULL). Multiplies cost and reward by the
	// level's multiplier. Not permitted on Requests (no reward to sweeten, no coin to burn).
	var/bonus_pay_level = CLAMP(text2num("[params["bonus_pay_level"]]") || COMMISSION_BONUS_PAY_NONE, COMMISSION_BONUS_PAY_NONE, COMMISSION_BONUS_PAY_FULL)
	if(funding == "directive")
		bonus_pay_level = COMMISSION_BONUS_PAY_NONE
	var/bonus_mult = get_commission_bonus_pay_mult(bonus_pay_level)
	if(bonus_mult != 1.0)
		cost = round(cost * bonus_mult)
	var/datum/fund/source_fund
	var/is_directive = FALSE
	switch(funding)
		if("pledge")
			if(!SStreasury.burgher_pledge_fund)
				to_chat(steward, span_warning("The Burgher Pledge is not established. Use Crown's Purse or a Request."))
				return
			source_fund = SStreasury.burgher_pledge_fund
		if("crown")
			if(!SStreasury.discretionary_fund)
				to_chat(steward, span_warning("The Crown's Purse is not established."))
				return
			source_fund = SStreasury.discretionary_fund
		if("directive")
			refresh_directive_quota()
			if(directives_issued_today >= COMMISSION_REQUESTS_PER_DAY)
				to_chat(steward, span_warning("You have exhausted today's request quota ([COMMISSION_REQUESTS_PER_DAY]/day)."))
				return
			is_directive = TRUE
			cost = 0
		else
			to_chat(steward, span_warning("Unknown funding source."))
			return

	if(source_fund && source_fund.balance < cost)
		to_chat(steward, span_warning("Insufficient [source_fund.name]. Need [cost]m, have [source_fund.balance]m."))
		return

	if(is_alderman_acting)
		if(!SScity_assembly.can_consume_defense(cost))
			to_chat(steward, span_warning("Your defense warrant cannot cover this commission. Remaining: [SScity_assembly.current_warrant.defense_remaining]p."))
			return

	if(chosen_type == QUEST_BLOCKADE_DEFENSE)
		commission_blockade_defense(steward, params, cost, source_fund, is_directive, bonus_pay_level)
		if(is_alderman_acting)
			SScity_assembly.consume_defense(cost, steward, "blockade defense commission")
		return

	var/region_name = params["region"]
	var/datum/threat_region/chosen_region
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(TR.region_name == region_name && TR.allows_quest_type(chosen_type))
			chosen_region = TR
			break
	if(!chosen_region)
		to_chat(steward, span_warning("That region does not host quests of this sort."))
		return

	// Recovery is not commissionable by the Steward - it only enters the pool via
	// SSquestpool.regen_kill_targets or via the Innkeeper's rumor flow, so we no longer
	// need a destination picker here.
	var/area/chosen_destination

	if(source_fund && cost > 0 && !SStreasury.burn(source_fund, cost, "Defense commission ([chosen_type] in [chosen_region.region_name])"))
		to_chat(steward, span_warning("The [source_fund.name] refused the draft."))
		return
	if(source_fund == SStreasury.burgher_pledge_fund && cost > 0)
		record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	if(is_alderman_acting && cost > 0)
		SScity_assembly.consume_defense(cost, steward, "[chosen_type] defense commission in [chosen_region.region_name]")
	var/in_hands = params["in_hands"] ? TRUE : FALSE
	// Directives are always drafted to the Steward's hand - they don't get posted publicly
	// because they carry no reward and nobody signs free work off a board.
	if(is_directive)
		in_hands = TRUE
	// Levy exemption is the Steward's sole prerogative - a Crown officer can waive the Crown's
	// tax revenue. The Alderman speaks for the Commons, not the Crown, and has no such authority.
	var/levy_exempt = (!is_alderman_acting && params["levy_exempt"]) ? TRUE : FALSE
	var/datum/quest/dispatched = SSquestpool.issue_defense_quest(chosen_type, chosen_region, chosen_destination, in_hands, steward)
	if(!dispatched)
		if(source_fund && cost > 0)
			SStreasury.mint(source_fund, cost, "Defense commission refund (landmark failure)")
			if(source_fund == SStreasury.burgher_pledge_fund)
				record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		SSquestpool.log_event("defense_refund", "landmark failure [chosen_type] in [chosen_region.region_name] refunded [cost]m")
		to_chat(steward, span_warning("No landmark could bear that commission. Funds refunded."))
		return
	if(levy_exempt)
		dispatched.levy_exempt = TRUE
	if(bonus_mult != 1.0)
		dispatched.reward_amount = round(dispatched.reward_amount * bonus_mult)
	if(is_directive)
		// Zero out the reward. The quest datum was built assuming a funded commission;
		// we strip the payout so the scroll promises nothing but duty.
		dispatched.reward_amount = 0
		dispatched.is_directive = TRUE
		directives_issued_today++
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	SStreasury.defense_log += list(list(
		"title" = dispatched.title || dispatched.quest_type,
		"type" = dispatched.quest_type,
		"region" = chosen_region.region_name,
		"cost" = cost,
		"in_hands" = in_hands,
		"levy_exempt" = levy_exempt,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	))
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned [dispatched.quest_difficulty] [chosen_type] in [chosen_region.region_name] for [cost]m ([funding])[levy_exempt ? " (levy-exempt)" : ""][bonus_label_text ? " ([bonus_label_text])" : ""][in_hands ? " (in hand)" : ""]")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = is_directive ? "as a Request" : (funding == "crown" ? "from Crown's Purse" : "from the Pledge")
	var/bonus_label = bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""
	if(in_hands)
		to_chat(steward, span_notice("Commission drafted [source_label] to your hand: <b>[dispatched.title || dispatched.quest_type]</b> in [chosen_region.region_name][levy_exempt ? " - <i>levy-exempt</i>" : ""][bonus_label]."))
	else
		to_chat(steward, span_notice("Commission posted [source_label]: <b>[dispatched.title || dispatched.quest_type]</b> in [chosen_region.region_name][levy_exempt ? " - <i>levy-exempt</i>" : ""][bonus_label]."))

/// Blockade commissions bypass the threat-region picker entirely — region param is the
/// economic region name, resolved to a live /datum/blockade. Multiple writs may be in
/// circulation concurrently, one per blockaded region.
/obj/structure/roguemachine/contractledger/proc/commission_blockade_defense(mob/living/carbon/human/steward, list/params, cost, datum/fund/source_fund, is_directive, bonus_pay_level = COMMISSION_BONUS_PAY_NONE)
	var/region_name = params["region"]
	var/datum/blockade/chosen
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/economic_region/ER = B.get_region()
		if(ER?.name == region_name)
			chosen = B
			break
	if(!chosen)
		to_chat(steward, span_warning("That region is not currently blockaded."))
		return
	if(chosen.has_active_scroll())
		to_chat(steward, span_warning("A writ is already in circulation for that blockade."))
		return
	if(source_fund && cost > 0 && !SStreasury.burn(source_fund, cost, "Blockade defense writ ([region_name])"))
		to_chat(steward, span_warning("The [source_fund.name] refused the draft."))
		return
	if(source_fund == SStreasury.burgher_pledge_fund && cost > 0)
		record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_blockade_defense_quest(chosen, steward, is_directive ? null : source_fund, is_directive ? 0 : cost)
	if(!Q)
		if(source_fund && cost > 0)
			SStreasury.mint(source_fund, cost, "Blockade defense writ refund (issue failure)")
			if(source_fund == SStreasury.burgher_pledge_fund)
				record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		SSquestpool.log_event("defense_refund", "landmark failure blockade [region_name] refunded [cost]m")
		to_chat(steward, span_warning("No landmark could bear that writ. Funds refunded."))
		return
	var/bonus_mult = get_commission_bonus_pay_mult(bonus_pay_level)
	if(bonus_mult != 1.0)
		Q.reward_amount = round(Q.reward_amount * bonus_mult)
	if(is_directive)
		Q.reward_amount = 0
		Q.is_directive = TRUE
		directives_issued_today++
	var/funding = is_directive ? "directive" : (source_fund == SStreasury.discretionary_fund ? "crown" : "pledge")
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	SStreasury.defense_log += list(list(
		"title" = Q.get_title(),
		"type" = QUEST_BLOCKADE_DEFENSE,
		"region" = region_name,
		"cost" = cost,
		"in_hands" = TRUE,
		"levy_exempt" = FALSE,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	))
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned blockade defense on [region_name] (faction [Q.faction_id]) for [cost]m ([funding])[bonus_label_text ? " ([bonus_label_text])" : ""]")
	scom_announce("A blockade defense writ has been issued for [region_name][bonus_label_text ? " - [bonus_label_text] attached" : ""].")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = is_directive ? "as a Request" : (funding == "crown" ? "from Crown's Purse" : "from the Pledge")
	to_chat(steward, span_notice("Blockade writ drafted [source_label] to your hand: <b>[Q.get_title()]</b>[bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""]."))

/// Steward recall: cancels a still-armed writ within the recall window and refunds the draft.
/// Region param is the economic region name — same selector used for issuance.
/obj/structure/roguemachine/contractledger/proc/recall_blockade_writ_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/steward = user
	if(!can_commission(steward))
		return
	if(!steward.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(steward, span_warning("The ledger is not yet open."))
		return
	var/region_name = params["region"]
	if(!region_name)
		return
	var/datum/blockade/chosen
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/economic_region/ER = B.get_region()
		if(ER?.name == region_name)
			chosen = B
			break
	if(!chosen)
		to_chat(steward, span_warning("That region is not currently blockaded."))
		return
	var/obj/item/quest_writ/S = chosen.active_scroll_ref?.resolve()
	if(!S || QDELETED(S))
		to_chat(steward, span_warning("No writ is in circulation for that blockade."))
		return
	var/datum/quest/kill/blockade_defense/Q = S.assigned_quest
	if(!istype(Q))
		to_chat(steward, span_warning("That writ cannot be recalled."))
		return
	var/blocker = Q.recall_blocker()
	if(blocker)
		to_chat(steward, span_warning("The writ cannot be recalled: [blocker]."))
		return
	var/refund = Q.funding_cost
	var/datum/fund/refund_fund = Q.funding_fund
	if(!Q.recall(steward))
		to_chat(steward, span_warning("The writ could not be recalled."))
		return
	SSquestpool.log_event("defense_recall", "[steward.real_name] recalled blockade writ on [region_name][refund > 0 && refund_fund ? " (refunded [refund]m to [refund_fund.name])" : ""]")
	scom_announce("The blockade defense writ for [region_name] has been recalled.")
	playsound(src, 'sound/items/inqslip_sealed.ogg', 50, FALSE, -1)
	if(refund > 0 && refund_fund)
		to_chat(steward, span_notice("Writ recalled. [refund]m returned to [refund_fund.name]."))
	else
		to_chat(steward, span_notice("Writ recalled."))
