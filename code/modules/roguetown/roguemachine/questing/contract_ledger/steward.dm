/proc/get_commission_bonus_pay_mult(level)
	switch(level)
		if(COMMISSION_BONUS_PAY_LIGHT)
			return COMMISSION_BONUS_PAY_LIGHT_MULT
		if(COMMISSION_BONUS_PAY_FULL)
			return COMMISSION_BONUS_PAY_MULT
	return 1.0

/proc/get_commission_bonus_pay_label(level)
	switch(level)
		if(COMMISSION_BONUS_PAY_LIGHT)
			return "light bonus pay"
		if(COMMISSION_BONUS_PAY_FULL)
			return "bonus pay"
	return ""

/obj/structure/roguemachine/contractledger/proc/build_active_writ_regions()
	var/list/out = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/quest/kill/blockade_defense/Q = B.active_quest_ref?.resolve()
		if(!istype(Q) || QDELETED(Q))
			continue
		var/datum/economic_region/ER = B.get_region()
		out += ER ? ER.name : B.region_id
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/datum/quest/kill/blockade_defense/Q = TR.active_hoard_recovery_ref?.resolve()
		if(!istype(Q) || QDELETED(Q) || Q.failed || Q.complete)
			continue
		out += TR.region_name
	return out

/obj/structure/roguemachine/contractledger/proc/draw_commission_funds(list/draws, reason)
	var/list/drawn = list()
	for(var/list/draw as anything in draws)
		if(!SStreasury.burn(draw["fund"], draw["amount"], reason))
			refund_commission_draws(drawn, "[reason] - refund (draft refused)")
			return FALSE
		drawn += list(draw)
		if(draw["fund"] == SStreasury.burgher_pledge_fund)
			record_round_statistic(STATS_PLEDGE_CONSUMED, draw["amount"])
	return TRUE

/obj/structure/roguemachine/contractledger/proc/refund_commission_draws(list/draws, reason)
	for(var/list/draw as anything in draws)
		SStreasury.mint(draw["fund"], draw["amount"], reason)
		if(draw["fund"] == SStreasury.burgher_pledge_fund)
			record_round_statistic(STATS_PLEDGE_CONSUMED, -draw["amount"])

/obj/structure/roguemachine/contractledger/proc/attach_commission_draws(datum/quest/Q, list/draws)
	for(var/list/draw as anything in draws)
		Q.add_funding(draw["fund"], draw["amount"])

/obj/structure/roguemachine/contractledger/proc/commission_source_label(is_directive, list/draws)
	if(is_directive)
		return "as a Request"
	var/list/names = list()
	for(var/list/draw as anything in draws)
		var/datum/fund/fund = draw["fund"]
		names += (fund == SStreasury.burgher_pledge_fund) ? "the Pledge" : fund.name
	return "from [english_list(names)]"

/obj/structure/roguemachine/contractledger/proc/build_region_tp_multipliers()
	var/list/out = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		out[TR.region_name] = TR.tp_budget_multiplier
	return out

/obj/structure/roguemachine/contractledger/proc/build_region_delivery_multipliers()
	var/list/out = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		out[TR.region_name] = TR.delivery_reward_multiplier
	return out

/obj/structure/roguemachine/contractledger/proc/build_defense_regions_by_type()
	var/list/out = list()
	for(var/qtype in GLOB.defense_quest_tier_costs)
		var/list/regions = list()
		if(qtype == QUEST_BLOCKADE_DEFENSE)
			for(var/datum/blockade/B as anything in GLOB.active_blockades)
				var/datum/economic_region/ER = B.get_region()
				if(ER)
					regions += ER.name
		else if(qtype == QUEST_HOARD_RECOVERY)
			for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
				if(TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
					continue
				// A true blockade takes precedence
				if(TR.has_active_blockade())
					continue
				regions += TR.region_name
		else
			for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
				if(!TR.allows_quest_type(qtype))
					continue
				regions += TR.region_name
		out[qtype] = regions
	return out

/obj/structure/roguemachine/contractledger/proc/build_blockade_region_labels()
	var/list/out = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/economic_region/ER = B.get_region()
		if(!ER)
			continue
		var/datum/threat_region/TR = B.get_threat_region()
		out[ER.name] = TR ? "[ER.name] ([TR.region_name])" : ER.name
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

	var/is_alderman_acting = SScity_assembly?.is_alderman(steward)
	if(is_alderman_acting && steward.job == "Steward")
		is_alderman_acting = FALSE

	var/funding = params["funding"] || "pledge"
	if(is_alderman_acting && funding != "pledge")
		to_chat(steward, span_warning("The Alderman's commission is paid from the Assembly's Pledge warrant alone. The Crown's Purse and the Steward's Request are not yours to command."))
		return

	var/cost = GLOB.defense_quest_tier_costs[chosen_type]
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

	var/list/draws = list()
	if(source_fund && cost > 0)
		var/topup_share = 0
		if(source_fund == SStreasury.burgher_pledge_fund && source_fund.balance < cost && params["crown_topup"] && !is_alderman_acting)
			if(!SStreasury.discretionary_fund)
				to_chat(steward, span_warning("The Crown's Purse is not established."))
				return
			topup_share = cost - max(0, source_fund.balance)
			if(SStreasury.discretionary_fund.balance < topup_share)
				to_chat(steward, span_warning("Insufficient Crown's Purse to cover the shortfall. Need [topup_share]m, have [SStreasury.discretionary_fund.balance]m."))
				return
			funding = "pledge_topup"
		else if(source_fund.balance < cost)
			to_chat(steward, span_warning("Insufficient [source_fund.name]. Need [cost]m, have [source_fund.balance]m."))
			return
		if(cost > topup_share)
			draws += list(list("fund" = source_fund, "amount" = cost - topup_share))
		if(topup_share > 0)
			draws += list(list("fund" = SStreasury.discretionary_fund, "amount" = topup_share))

	if(is_alderman_acting)
		if(!SScity_assembly.can_consume_defense(cost))
			to_chat(steward, span_warning("Your defense warrant cannot cover this commission. Remaining: [SScity_assembly.current_warrant.defense_remaining]p."))
			return

	if(chosen_type == QUEST_BLOCKADE_DEFENSE)
		commission_blockade_defense(steward, params, cost, draws, funding, is_directive, bonus_pay_level, is_alderman_acting)
		return

	if(chosen_type == QUEST_HOARD_RECOVERY)
		commission_hoard_recovery(steward, params, cost, draws, funding, is_directive, bonus_pay_level, is_alderman_acting)
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

	var/area/chosen_destination

	if(!draw_commission_funds(draws, "Defense commission ([chosen_type] in [chosen_region.region_name])"))
		to_chat(steward, span_warning("The treasury refused the draft."))
		return
	if(is_alderman_acting && cost > 0)
		SScity_assembly.consume_defense(cost, steward, "[chosen_type] defense commission in [chosen_region.region_name]")
	var/in_hands = params["in_hands"] ? TRUE : FALSE
	if(is_directive)
		in_hands = TRUE
	var/levy_exempt = (!is_alderman_acting && params["levy_exempt"]) ? TRUE : FALSE
	var/datum/quest/dispatched = SSquestpool.issue_defense_quest(chosen_type, chosen_region, chosen_destination, in_hands, steward)
	if(!dispatched)
		refund_commission_draws(draws, "Defense commission refund (landmark failure)")
		// Restore the Alderman's warrant too - it was consumed above but the commission never issued.
		if(is_alderman_acting && cost > 0)
			SScity_assembly.refund_defense(cost, steward, "[chosen_type] defense commission refund (landmark failure)")
		SSquestpool.log_event("defense_refund", "landmark failure [chosen_type] in [chosen_region.region_name] refunded [cost]m")
		to_chat(steward, span_warning("No landmark could bear that commission. Funds refunded."))
		return
	if(levy_exempt)
		dispatched.levy_exempt = TRUE
	if(bonus_mult != 1.0)
		dispatched.reward_amount = round(dispatched.reward_amount * bonus_mult)
	if(is_directive)
		dispatched.reward_amount = 0
		dispatched.is_directive = TRUE
		directives_issued_today++
	attach_commission_draws(dispatched, draws)
	if(is_alderman_acting && cost > 0)
		dispatched.warrant_consumed = cost
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	var/list/log_entry = list(
		"title" = dispatched.title || dispatched.quest_type,
		"type" = dispatched.quest_type,
		"region" = chosen_region.region_name,
		"cost" = cost,
		"in_hands" = in_hands,
		"levy_exempt" = levy_exempt,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	)
	SStreasury.defense_log += list(log_entry)
	dispatched.issue_log_entry = log_entry
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned [dispatched.quest_difficulty] [chosen_type] in [chosen_region.region_name] for [cost]m ([funding])[levy_exempt ? " (levy-exempt)" : ""][bonus_label_text ? " ([bonus_label_text])" : ""][in_hands ? " (in hand)" : ""]")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = commission_source_label(is_directive, draws)
	var/bonus_label =bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""
	if(in_hands)
		to_chat(steward, span_notice("Commission drafted [source_label] to your hand: <b>[dispatched.title || dispatched.quest_type]</b> in [chosen_region.region_name][levy_exempt ? " - <i>levy-exempt</i>" : ""][bonus_label]."))
	else
		to_chat(steward, span_notice("Commission posted [source_label]: <b>[dispatched.title || dispatched.quest_type]</b> in [chosen_region.region_name][levy_exempt ? " - <i>levy-exempt</i>" : ""][bonus_label]."))

/obj/structure/roguemachine/contractledger/proc/commission_blockade_defense(mob/living/carbon/human/steward, list/params, cost, list/draws, funding, is_directive,bonus_pay_level = COMMISSION_BONUS_PAY_NONE, is_alderman_acting = FALSE)
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
	if(!draw_commission_funds(draws, "Blockade defense writ ([region_name])"))
		to_chat(steward, span_warning("The treasury refused the draft."))
		return
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_blockade_defense_quest(chosen, steward)
	if(!Q)
		refund_commission_draws(draws, "Blockade defense writ refund (issue failure)")
		SSquestpool.log_event("defense_refund", "landmark failure blockade [region_name] refunded [cost]m")
		to_chat(steward, span_warning("No landmark could bear that writ. Funds refunded."))
		return
	attach_commission_draws(Q, draws)
	if(is_alderman_acting && cost > 0 && SScity_assembly.consume_defense(cost, steward, "blockade defense commission ([region_name])"))
		Q.warrant_consumed = cost
	var/bonus_mult = get_commission_bonus_pay_mult(bonus_pay_level)
	if(bonus_mult != 1.0)
		Q.reward_amount = round(Q.reward_amount * bonus_mult)
	if(is_directive)
		Q.reward_amount = 0
		Q.is_directive = TRUE
		directives_issued_today++
	var/levy_exempt = (!is_directive && !is_alderman_acting && params["levy_exempt"]) ? TRUE : FALSE
	if(levy_exempt)
		Q.levy_exempt = TRUE
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	var/list/log_entry = list(
		"title" = Q.get_title(),
		"type" = QUEST_BLOCKADE_DEFENSE,
		"region" = region_name,
		"cost" = cost,
		"in_hands" = TRUE,
		"levy_exempt" = levy_exempt,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	)
	SStreasury.defense_log += list(log_entry)
	Q.issue_log_entry = log_entry
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned blockade defense on [region_name] (faction [Q.faction_id]) for [cost]m ([funding])[levy_exempt ? " (levy-exempt)" : ""][bonus_label_text ? " ([bonus_label_text])" : ""]")
	scom_announce("A blockade defense writ has been issued for [region_name][bonus_label_text ? " - [bonus_label_text] attached" : ""].")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = commission_source_label(is_directive, draws)
	to_chat(steward, span_notice("Blockade writ drafted [source_label] to your hand: <b>[Q.get_title()]</b>[levy_exempt ? " - <i>levy-exempt</i>" : ""][bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""]."))

/obj/structure/roguemachine/contractledger/proc/commission_hoard_recovery(mob/living/carbon/human/steward, list/params, cost, list/draws, funding, is_directive,bonus_pay_level = COMMISSION_BONUS_PAY_NONE, is_alderman_acting = FALSE)
	var/region_name = params["region"]
	var/datum/threat_region/TR = SSregionthreat.get_region(region_name)
	if(!TR || TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
		to_chat(steward, span_warning("The hoard in that region is too trivial for a Recovery writ - a number of [HOARD_RECOVERY_HOARD_MINIMUM] mammons or more is needed."))
		return
	if(TR.has_active_blockade())
		to_chat(steward, span_warning("[TR.region_name] is under an active blockade - commission a blockade defense writ instead."))
		return
	var/datum/quest/kill/blockade_defense/existing = TR.active_hoard_recovery_ref?.resolve()
	if(existing && !QDELETED(existing) && !existing.failed && !existing.complete)
		to_chat(steward, span_warning("A recovery writ is already in circulation for that region."))
		return
	if(!draw_commission_funds(draws, "Hoard recovery writ ([region_name])"))
		to_chat(steward, span_warning("The treasury refused the draft."))
		return
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_hoard_recovery_request(TR, steward, TRUE)
	if(!Q)
		refund_commission_draws(draws, "Hoard recovery writ refund (issue failure)")
		SSquestpool.log_event("defense_refund", "landmark failure hoard recovery [region_name] refunded [cost]m")
		to_chat(steward, span_warning("No landmark could bear that writ. Funds refunded."))
		return
	attach_commission_draws(Q, draws)
	if(is_alderman_acting && cost > 0 && SScity_assembly.consume_defense(cost, steward, "hoard recovery commission ([region_name])"))
		Q.warrant_consumed = cost
	var/bonus_mult = get_commission_bonus_pay_mult(bonus_pay_level)
	if(bonus_mult != 1.0)
		Q.reward_amount = round(Q.reward_amount * bonus_mult)
	if(is_directive)
		Q.reward_amount = 0
		Q.is_directive = TRUE
		directives_issued_today++
	var/levy_exempt = (!is_directive && !is_alderman_acting && params["levy_exempt"]) ? TRUE : FALSE
	if(levy_exempt)
		Q.levy_exempt = TRUE
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	var/list/log_entry = list(
		"title" = Q.get_title(),
		"type" = QUEST_HOARD_RECOVERY,
		"region" = region_name,
		"cost" = cost,
		"in_hands" = TRUE,
		"levy_exempt" = levy_exempt,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	)
	SStreasury.defense_log += list(log_entry)
	Q.issue_log_entry = log_entry
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned hoard recovery on [region_name] (faction [Q.faction_id], hoard [TR.banditry_hoard]) for [cost]m ([funding])[levy_exempt ? " (levy-exempt)" : ""][bonus_label_text ? " ([bonus_label_text])" : ""]")
	scom_announce("A hoard recovery writ has been issued for [region_name][bonus_label_text ? " - [bonus_label_text] attached" : ""].")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = commission_source_label(is_directive, draws)
	to_chat(steward, span_notice("Hoard recovery writ drafted [source_label] to your hand: <b>[Q.get_title()]</b>[levy_exempt ? " - <i>levy-exempt</i>" : ""][bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""]."))
