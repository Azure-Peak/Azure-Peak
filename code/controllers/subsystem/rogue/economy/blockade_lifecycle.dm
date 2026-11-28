/datum/controller/subsystem/economy/proc/find_blockade_for_subroute(subroute)
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		if(B.subroute == subroute)
			return B
	return null

/datum/controller/subsystem/economy/proc/pick_blockade_faction_for(datum/threat_region/TR)
	if(!TR || !length(TR.faction_weights))
		return null
	var/list/eligible = list()
	for(var/fid in TR.faction_weights)
		var/datum/quest_faction/F = get_quest_faction(fid)
		if(!F || !F.can_blockade)
			continue
		eligible[fid] = TR.faction_weights[fid]
	if(!length(eligible))
		return null
	return pickweight(eligible)

/datum/controller/subsystem/economy/proc/pick_blockade_subroute()
	var/list/candidates = list()
	for(var/subroute in subtypesof(/datum/trade_subroute))
		if(gathering_blockades[subroute] || find_blockade_for_subroute(subroute))
			continue
		var/list/regions = get_subroute_regions(subroute)
		if(!length(regions))
			continue
		var/recently_cleared = FALSE
		for(var/datum/economic_region/ER as anything in regions)
			if(ER.day_last_cleared >= 0 && (ECONOMY_DAY - ER.day_last_cleared) < BLOCKADE_RECLEAR_COOLDOWN)
				recently_cleared = TRUE
				break
		if(recently_cleared)
			continue
		var/threat_region_id = get_subroute_threat_region(subroute)
		if(!pick_blockade_faction_for(SSregionthreat.get_region(threat_region_id)))
			continue
		if(!SSquestpool.has_landmark_for_region(threat_region_id))
			continue
		candidates += subroute
	if(!length(candidates))
		return null
	return pick(candidates)

/datum/controller/subsystem/economy/proc/roll_blockade()
	var/subroute = pick_blockade_subroute()
	if(!subroute)
		return null
	var/fid = pick_blockade_faction_for(SSregionthreat.get_region(get_subroute_threat_region(subroute)))
	if(!fid)
		return null
	return place_blockade(subroute, fid)

/datum/controller/subsystem/economy/proc/gather_blockade()
	var/subroute = pick_blockade_subroute()
	if(!subroute)
		return FALSE
	var/fid = pick_blockade_faction_for(SSregionthreat.get_region(get_subroute_threat_region(subroute)))
	if(!fid)
		return FALSE
	gathering_blockades[subroute] = fid
	var/datum/quest_faction/F = get_quest_faction(fid)
	if(F)
		scom_announce("<font color='#c44'>The scouts report a [F.group_word] of [F.name_plural] massing on the road to [get_subroute_region_names(subroute)]. It will be blocked at the next dawn.</font>")
	return TRUE

/datum/controller/subsystem/economy/proc/land_gathering_blockades()
	for(var/subroute in gathering_blockades)
		place_blockade(subroute, gathering_blockades[subroute])
	gathering_blockades.Cut()

/datum/controller/subsystem/economy/proc/place_blockade(subroute, faction_id)
	if(find_blockade_for_subroute(subroute))
		return null
	var/list/regions = get_subroute_regions(subroute)
	if(!length(regions))
		return null
	var/threat_region_id = get_subroute_threat_region(subroute)
	if(!SSquestpool.has_landmark_for_region(threat_region_id))
		return null

	var/datum/blockade/B = new()
	B.subroute = subroute
	B.threat_region_name = threat_region_id
	B.faction_id = faction_id
	B.day_started = ECONOMY_DAY
	GLOB.active_blockades += B
	for(var/datum/economic_region/ER as anything in regions)
		ER.is_region_blockaded = TRUE
	SStreasury.dirty_market_view()
	record_round_statistic(STATS_BLOCKADES_FIRED, 1)
	announce_blockade_start(B)
	return B

/datum/controller/subsystem/economy/proc/clear_blockade(datum/blockade/B, reason = "cleared")
	if(!B)
		return
	for(var/datum/economic_region/ER as anything in B.get_regions())
		ER.is_region_blockaded = FALSE
		ER.day_last_cleared = ECONOMY_DAY
	SStreasury.dirty_market_view()
	GLOB.active_blockades -= B
	release_estate_backlogs()
	if(reason == "cleared")
		record_round_statistic(STATS_BLOCKADES_CLEARED, 1)
		announce_blockade_cleared(B)
	qdel(B)

/datum/controller/subsystem/economy/proc/roundstart_blockades()
	var/count = rand(BLOCKADE_ROUNDSTART_COUNT_MIN, BLOCKADE_ROUNDSTART_COUNT_MAX)
	for(var/i in 1 to count)
		if(!roll_blockade())
			break

/datum/controller/subsystem/economy/proc/tick_blockade_replenish()
	land_gathering_blockades()
	var/strike_day = ECONOMY_DAY + 1
	if(strike_day < BLOCKADE_REPLENISH_FIRST_DAY || strike_day > BLOCKADE_REPLENISH_LAST_DAY)
		return
	if(length(GLOB.active_blockades) >= BLOCKADE_REPLENISH_FLOOR)
		return
	var/budget = clamp(BLOCKADE_REPLENISH_BUDGET_BASE + round(get_effective_player_count() * BLOCKADE_REPLENISH_BUDGET_PER_PLAYER), BLOCKADE_REPLENISH_BUDGET_BASE, BLOCKADE_REPLENISH_BUDGET_MAX)
	if(blockade_replenish_spent >= budget)
		return
	if(!prob(BLOCKADE_REPLENISH_DAILY_CHANCE))
		return
	if(gather_blockade())
		blockade_replenish_spent++

/datum/controller/subsystem/economy/proc/announce_blockade_start(datum/blockade/B)
	var/datum/quest_faction/F = B.get_faction()
	if(!F)
		return
	scom_announce("<font color='#c44'>BLOCKADE: A [F.group_word] of [F.name_plural] has cut the trade road to [B.get_region_names()].</font>")

/datum/controller/subsystem/economy/proc/announce_blockade_cleared(datum/blockade/B)
	scom_announce("<font color='#5cb85c'>The blockade on the road to [B.get_region_names()] has been broken.</font>")
