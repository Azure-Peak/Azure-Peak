/obj/structure/roguemachine/contractledger/proc/build_rumor_regions_by_type()
	var/list/out = list()
	for(var/qtype in GLOB.rumor_point_costs)
		var/list/regions = list()
		for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
			if(!TR.allows_quest_type(qtype))
				continue
			if(!rumor_region_passes_threat_gate(TR, qtype))
				continue
			regions += TR.region_name
		out[qtype] = regions
	return out

/obj/structure/roguemachine/contractledger/proc/rumor_region_passes_threat_gate(datum/threat_region/TR, quest_type)
	if(!(quest_type in GLOB.rumor_threat_gated_types))
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
	if(innkeeper.job != "Innkeeper")
		return
	if(!innkeeper.Adjacent(src))
		return

	var/chosen_type = params["type"]
	if(!(chosen_type in GLOB.rumor_point_costs))
		to_chat(innkeeper, span_warning("That rumor type is not one the Guild accepts."))
		return
	var/lucrative = params["lucrative"] ? TRUE : FALSE
	var/base_cost = GLOB.rumor_point_costs[chosen_type]
	var/cost = lucrative ? round(base_cost * RUMOR_LUCRATIVE_MULT) : base_cost
	if(SStreasury.rumor_points < cost)
		to_chat(innkeeper, span_warning("Insufficient Rumor Points. Need [cost], have [round(SStreasury.rumor_points, 0.1)]."))
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
	if(chosen_type == QUEST_RECOVERY)
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
		to_chat(innkeeper, span_warning("You don't recall hearing a rumor so similar to one you have heard earlier today."))
		return

	SStreasury.rumor_points -= cost
	record_round_statistic(STATS_RUMOR_POINTS_CONSUMED, cost)
	var/in_hands = params["in_hands"] ? TRUE : FALSE
	var/datum/quest/dispatched = SSquestpool.issue_rumor_quest(chosen_type, chosen_region, chosen_destination, in_hands, innkeeper)
	if(!dispatched)
		SStreasury.rumor_points += cost
		record_round_statistic(STATS_RUMOR_POINTS_CONSUMED, -cost)
		to_chat(innkeeper, span_warning("No landmark could bear that rumor. Try another region or type."))
		return
	if(lucrative)
		dispatched.reward_amount = round(dispatched.reward_amount * RUMOR_LUCRATIVE_MULT)
	SStreasury.rumor_issued_today[dup_key] = GLOB.dayspassed
	SStreasury.rumor_log += list(list(
		"title" = dispatched.title || dispatched.quest_type,
		"type" = dispatched.quest_type,
		"region" = chosen_region.region_name,
		"in_hands" = in_hands,
		"lucrative" = lucrative,
		"day" = GLOB.dayspassed,
	))
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/lucrative_tail = lucrative ? " - <i>lucrative</i>" : ""
	if(in_hands)
		to_chat(innkeeper, span_notice("A scroll of the rumor is placed in your hands: <b>[dispatched.title || dispatched.quest_type]</b>[lucrative_tail]. Pass it to whomever you see fit."))
	else
		say("\"So I have heard...\" A rumor is whispered into the Guild's ledger.")
		to_chat(innkeeper, span_notice("Rumor posted to the board: <b>[dispatched.title || dispatched.quest_type]</b>[lucrative_tail]."))

/obj/structure/roguemachine/contractledger/proc/find_active_innkeeper()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD)
			continue
		if(H.job == "Innkeeper")
			return H
	return null

/obj/structure/roguemachine/contractledger/proc/pay_innkeeper_referral_fees(datum/fund/user_account, datum/quest/completed_quest, gross_reward)
	if(gross_reward <= 0)
		return 0
	var/mob/living/carbon/human/innkeeper = find_active_innkeeper()
	var/datum/fund/inn_account = innkeeper ? SStreasury.get_account(innkeeper) : null
	var/guild_paid = 0
	if(completed_quest.source != QUEST_SOURCE_DEFENSE)
		var/guild_fee = round(gross_reward * GUILD_REFERRAL_FEE_PCT)
		if(guild_fee > 0 && user_account)
			if(inn_account)
				if(SStreasury.transfer(user_account, inn_account, guild_fee, "Guild Cut - [completed_quest.quest_type]"))
					guild_paid = guild_fee
			else if(SStreasury.burn(user_account, guild_fee, "Guild Cut - [completed_quest.quest_type]"))
				guild_paid = guild_fee
	if(completed_quest.source == QUEST_SOURCE_RUMOR && inn_account)
		var/rumor_fee = round(gross_reward * RUMOR_CONTACT_FEE_PCT)
		if(rumor_fee > 0)
			SStreasury.mint(inn_account, rumor_fee, "Contact Referral Fee - [completed_quest.quest_type]")
	return guild_paid
