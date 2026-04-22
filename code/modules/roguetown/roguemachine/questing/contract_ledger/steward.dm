/obj/structure/roguemachine/contractledger/proc/build_defense_regions_by_type()
	var/list/out = list()
	for(var/qtype in GLOB.defense_quest_tier_costs)
		var/list/regions = list()
		if(qtype == QUEST_BLOCKADE_DEFENSE)
			for(var/datum/blockade/B as anything in GLOB.active_blockades)
				if(B.has_active_scroll())
					continue
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
	if(steward.job != "Steward")
		return
	if(!steward.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(steward, span_warning("The Burgher Pledge ledger is not yet open."))
		return
	if(!SStreasury.burgher_pledge_fund)
		to_chat(steward, span_warning("The Burgher Pledge is not established."))
		return

	var/chosen_type = params["type"]
	if(!(chosen_type in GLOB.defense_quest_tier_costs))
		to_chat(steward, span_warning("That quest type is not one the Pledge commissions."))
		return
	var/cost = GLOB.defense_quest_tier_costs[chosen_type]
	if(SStreasury.burgher_pledge_fund.balance < cost)
		to_chat(steward, span_warning("Insufficient Pledge. Need [cost]m, have [SStreasury.burgher_pledge_fund.balance]m."))
		return

	if(chosen_type == QUEST_BLOCKADE_DEFENSE)
		commission_blockade_defense(steward, params, cost)
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
	var/dest_name
	if(chosen_type == QUEST_RECOVERY)
		dest_name = params["destination"]
		for(var/area/A as anything in GLOB.quest_recovery_shipments)
			if(initial(A.name) == dest_name)
				chosen_destination = A
				break
		if(!chosen_destination)
			to_chat(steward, span_warning("No such shipment destination is known."))
			return

	if(!SStreasury.burn(SStreasury.burgher_pledge_fund, cost, "Defense commission ([chosen_type] in [chosen_region.region_name])"))
		to_chat(steward, span_warning("The Pledge refused the draft."))
		return
	var/in_hands = params["in_hands"] ? TRUE : FALSE
	var/levy_exempt = params["levy_exempt"] ? TRUE : FALSE
	var/datum/quest/dispatched = SSquestpool.issue_defense_quest(chosen_type, chosen_region, chosen_destination, in_hands, steward)
	if(!dispatched)
		SStreasury.mint(SStreasury.burgher_pledge_fund, cost, "Defense commission refund (landmark failure)")
		SSquestpool.log_event("defense_refund", "landmark failure [chosen_type] in [chosen_region.region_name] refunded [cost]m")
		to_chat(steward, span_warning("No landmark could bear that commission. Pledge refunded."))
		return
	if(levy_exempt)
		dispatched.levy_exempt = TRUE
	SStreasury.defense_log += list(list(
		"title" = dispatched.title || dispatched.quest_type,
		"type" = dispatched.quest_type,
		"region" = chosen_region.region_name,
		"cost" = cost,
		"in_hands" = in_hands,
		"levy_exempt" = levy_exempt,
		"day" = GLOB.dayspassed,
	))
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned [dispatched.quest_difficulty] [chosen_type] in [chosen_region.region_name] for [cost]m[levy_exempt ? " (levy-exempt)" : ""][in_hands ? " (in hand)" : ""]")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	if(in_hands)
		to_chat(steward, span_notice("Commission drafted to your hand: <b>[dispatched.title || dispatched.quest_type]</b> in [chosen_region.region_name][levy_exempt ? " - <i>levy-exempt</i>" : ""]."))
	else
		to_chat(steward, span_notice("Commission posted: <b>[dispatched.title || dispatched.quest_type]</b> in [chosen_region.region_name][levy_exempt ? " - <i>levy-exempt</i>" : ""]."))

/// Blockade commissions bypass the threat-region picker entirely — region param is the
/// economic region name, resolved to a live /datum/blockade. Only one blockade writ may
/// be in circulation at a time across the whole server.
/obj/structure/roguemachine/contractledger/proc/commission_blockade_defense(mob/living/carbon/human/steward, list/params, cost)
	if(SSeconomy.any_blockade_quest_active())
		to_chat(steward, span_warning("Another blockade writ is already in circulation. Only one at a time."))
		return
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
	if(!SStreasury.burn(SStreasury.burgher_pledge_fund, cost, "Blockade defense writ ([region_name])"))
		to_chat(steward, span_warning("The Pledge refused the draft."))
		return
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_blockade_defense_quest(chosen, steward)
	if(!Q)
		SStreasury.mint(SStreasury.burgher_pledge_fund, cost, "Blockade defense writ refund (issue failure)")
		SSquestpool.log_event("defense_refund", "landmark failure blockade [region_name] refunded [cost]m")
		to_chat(steward, span_warning("No landmark could bear that writ. Pledge refunded."))
		return
	SStreasury.defense_log += list(list(
		"title" = Q.get_title(),
		"type" = QUEST_BLOCKADE_DEFENSE,
		"region" = region_name,
		"cost" = cost,
		"in_hands" = TRUE,
		"levy_exempt" = FALSE,
		"day" = GLOB.dayspassed,
	))
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned blockade defense on [region_name] (faction [Q.faction_id]) for [cost]m")
	scom_announce("A blockade defense writ has been issued for [region_name].")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	to_chat(steward, span_notice("Blockade writ drafted to your hand: <b>[Q.get_title()]</b>."))
