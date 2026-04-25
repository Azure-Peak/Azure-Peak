/datum/controller/subsystem/economy/proc/find_blockade_for_region(region_id)
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		if(B.region_id == region_id)
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

/datum/controller/subsystem/economy/proc/roll_blockade()
	var/list/candidates = list()
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/ER = GLOB.economic_regions[region_id]
		if(!ER.threat_region_id)
			continue
		if(ER.is_region_blockaded)
			continue
		if(ER.day_last_cleared >= 0 && (GLOB.dayspassed - ER.day_last_cleared) < BLOCKADE_RECLEAR_COOLDOWN)
			continue
		var/datum/threat_region/TR = SSregionthreat.get_region(ER.threat_region_id)
		if(!TR)
			continue
		if(!pick_blockade_faction_for(TR))
			continue
		candidates += region_id
	if(!length(candidates))
		return null
	var/chosen_id = pick(candidates)
	var/datum/economic_region/ER = GLOB.economic_regions[chosen_id]
	var/datum/threat_region/TR = SSregionthreat.get_region(ER.threat_region_id)
	var/fid = pick_blockade_faction_for(TR)
	if(!fid)
		return null

	var/datum/blockade/B = new()
	B.region_id = chosen_id
	B.threat_region_name = ER.threat_region_id
	B.faction_id = fid
	B.day_started = GLOB.dayspassed
	GLOB.active_blockades += B
	ER.is_region_blockaded = TRUE
	record_round_statistic(STATS_BLOCKADES_FIRED, 1)
	if(daily_report_diff)
		var/list/fired = daily_report_diff["blockades_fired"]
		var/datum/quest_faction/F = B.get_faction()
		fired += "[ER.name] - [F ? "[F.group_word] of [F.name_plural]" : "raiders"]"
	announce_blockade_start(B)
	return B

/datum/controller/subsystem/economy/proc/clear_blockade(datum/blockade/B, reason = "cleared")
	if(!B)
		return
	var/datum/economic_region/ER = B.get_region()
	if(ER)
		ER.is_region_blockaded = FALSE
		ER.day_last_cleared = GLOB.dayspassed
	GLOB.active_blockades -= B
	if(reason == "cleared")
		record_round_statistic(STATS_BLOCKADES_CLEARED, 1)
		if(daily_report_diff && ER)
			var/list/cleared = daily_report_diff["blockades_cleared"]
			cleared += ER.name
		announce_blockade_cleared(B)
	qdel(B)

/datum/controller/subsystem/economy/proc/roundstart_blockades()
	var/count = rand(BLOCKADE_ROUNDSTART_COUNT_MIN, BLOCKADE_ROUNDSTART_COUNT_MAX)
	for(var/i in 1 to count)
		if(!roll_blockade())
			break

/datum/controller/subsystem/economy/proc/announce_blockade_start(datum/blockade/B)
	var/datum/economic_region/ER = B.get_region()
	var/datum/quest_faction/F = B.get_faction()
	if(!ER || !F)
		return
	scom_announce("<font color='#c44'>BLOCKADE: The trade road to [ER.name] is cut — a [F.group_word] of [F.name_plural] has fallen upon it. The Crown awaits a defense commission.</font>")

/datum/controller/subsystem/economy/proc/announce_blockade_cleared(datum/blockade/B)
	var/datum/economic_region/ER = B.get_region()
	if(!ER)
		return
	scom_announce("<font color='#5cb85c'>The road to [ER.name] is open once more — the blockade has been broken.</font>")
