/obj/structure/roguemachine/contractledger/proc/add_rumor_types(list/data)
	var/list/costs = list()
	var/list/regions_by_type = list()
	for(var/qtype in GLOB.quest_prototypes)
		var/datum/quest/proto = GLOB.quest_prototypes[qtype]
		if(!proto.rumor_cost)
			continue
		costs[qtype] = proto.rumor_cost
		var/list/regions = list()
		for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
			if(TR.allows_quest_type(qtype) && rumor_region_passes_threat_gate(TR, qtype))
				regions += TR.region_name
		regions_by_type[qtype] = regions
	data["rumor_costs"] = costs
	data["rumor_regions_by_type"] = regions_by_type

/obj/structure/roguemachine/contractledger/proc/rumor_region_passes_threat_gate(datum/threat_region/TR, quest_type)
	var/datum/quest/proto = GLOB.quest_prototypes[quest_type]
	if(!proto?.rumor_threat_gated)
		return TRUE
	return TR.get_threat_weight() >= RUMOR_THREAT_GATE_MIN

/obj/structure/roguemachine/contractledger/proc/build_rumor_destinations()
	var/list/out = list()
	for(var/area/A as anything in GLOB.quest_recovery_shipments)
		out += initial(A.name)
	return out

/obj/structure/roguemachine/contractledger/proc/compose_rumor_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/innkeeper = user
	if(!(innkeeper.job in GLOB.tavern_positions))
		return
	if(!innkeeper.Adjacent(src))
		return

	var/chosen_type = params["type"]
	var/datum/quest/chosen_proto = GLOB.quest_prototypes[chosen_type]
	if(!chosen_proto?.rumor_cost)
		to_chat(innkeeper, span_warning("That rumor type is not one the Guild accepts."))
		return
	var/lucrative = params["lucrative"] ? TRUE : FALSE
	var/base_cost = chosen_proto.rumor_cost
	var/cost = lucrative ? round(base_cost * RUMOR_LUCRATIVE_MULT) : base_cost
	if(SStreasury.rumor_points < cost)
		to_chat(innkeeper, span_warning("Not enough Rumor Points. You need [cost] and have [round(SStreasury.rumor_points, 0.1)]."))
		return

	var/region_name = params["region"]
	var/datum/threat_region/chosen_region
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(TR.region_name == region_name && TR.allows_quest_type(chosen_type))
			chosen_region = TR
			break
	if(!chosen_region)
		to_chat(innkeeper, span_warning("That region does not host rumors of this sort."))
		return
	if(!rumor_region_passes_threat_gate(chosen_region, chosen_type))
		to_chat(innkeeper, span_warning("You don't recall that region being dangerous enough for such rumors to circulate."))
		return

	var/area/chosen_destination
	var/dest_name
	if(chosen_proto.takes_destination)
		dest_name = params["destination"]
		for(var/area/A as anything in GLOB.quest_recovery_shipments)
			if(initial(A.name) == dest_name)
				chosen_destination = A
				break
		if(!chosen_destination)
			to_chat(innkeeper, span_warning("No such shipment destination is known."))
			return

	var/dup_key = "[chosen_type]|[chosen_region.region_name]|[dest_name || ""]"
	if(SStreasury.rumor_issued_today[dup_key] == GLOB.dayspassed)
		to_chat(innkeeper, span_warning("You've already passed on a rumor like this today."))
		return

	SStreasury.rumor_points -= cost
	record_round_statistic(STATS_RUMOR_POINTS_CONSUMED, cost)
	var/in_hands = params["in_hands"] ? TRUE : FALSE
	var/datum/quest/dispatched = SSquestpool.issue_player_quest(chosen_type, QUEST_SOURCE_RUMOR, chosen_region, chosen_destination, in_hands, innkeeper)
	if(!dispatched)
		SStreasury.rumor_points += cost
		record_round_statistic(STATS_RUMOR_POINTS_CONSUMED, -cost)
		to_chat(innkeeper, span_warning("No landmark could take that rumor. Try another region or type."))
		return
	if(lucrative)
		dispatched.reward_bonus_mult *= RUMOR_LUCRATIVE_MULT
		dispatched.reward_amount = round(dispatched.reward_amount * RUMOR_LUCRATIVE_MULT)
	dispatched.funding_rumor_points = cost
	SStreasury.rumor_issued_today[dup_key] = GLOB.dayspassed
	var/list/log_entry = list(
		"title" = dispatched.title || dispatched.quest_type,
		"type" = dispatched.quest_type,
		"region" = chosen_region.region_name,
		"in_hands" = in_hands,
		"lucrative" = lucrative,
		"day" = GLOB.dayspassed,
	)
	SStreasury.rumor_log += list(log_entry)
	dispatched.issue_log_entry = log_entry
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/lucrative_tail = lucrative ? " - <i>lucrative</i>" : ""
	if(in_hands)
		to_chat(innkeeper, span_notice("The rumor's scroll is placed in your hands: <b>[dispatched.title || dispatched.quest_type]</b>[lucrative_tail]. Give it to whoever you choose."))
	else
		say("A new rumor is on the Ledger.")
		to_chat(innkeeper, span_notice("Rumor posted to the Ledger: <b>[dispatched.title || dispatched.quest_type]</b>[lucrative_tail]."))

/obj/structure/roguemachine/contractledger/proc/pay_innkeeper_referral_fees(datum/fund/user_account, datum/quest/completed_quest, reward)
	if(reward <= 0)
		return 0
	var/datum/fund/tavern_fund = SStreasury.innkeeper_fund
	var/guild_paid = 0
	if(completed_quest.guild_cut_rate > 0)
		var/guild_fee = round(reward * completed_quest.guild_cut_rate)
		if(guild_fee > 0 && user_account && tavern_fund)
			if(SStreasury.transfer(user_account, tavern_fund, guild_fee, "Guild Cut - [completed_quest.quest_type]", LEDGER_CITIZEN_CONTRACT_PAID, LEDGER_TAVERN_REFERRAL_IN))
				guild_paid = guild_fee
				record_round_statistic(STATS_CONTRACT_MAMMONS_GUILD_CUT, guild_fee)
	if(completed_quest.source == QUEST_SOURCE_RUMOR && tavern_fund)
		var/rumor_fee = round(reward * RUMOR_CONTACT_FEE_PCT)
		if(rumor_fee > 0)
			SStreasury.mint(tavern_fund, rumor_fee, "Contact Referral Fee - [completed_quest.quest_type]", null, LEDGER_TAVERN_REFERRAL_IN)
	return guild_paid
