/datum/quest/kill/blockade_defense
	quest_type = QUEST_BLOCKADE_DEFENSE
	quest_difficulty = QUEST_DIFFICULTY_HARD
	tp_budget = BLOCKADE_WAVE_BASE_TP
	threat_bands_cleared = QUEST_BANDS_BLOCKADE
	required_fellowship_size = 0

	var/current_wave = 0
	var/wave_timer_id
	var/wave_warn_2m_id
	var/wave_warn_30s_id
	var/datum/weakref/wave_landmark_ref
	var/datum/weakref/blockade_ref
	var/armed = FALSE
	var/max_defenders_seen = 0
	var/current_archetype = BLOCKADE_ARCHETYPE_WARBAND
	var/wave_boss_name
	var/arm_timer_id
	var/issued_at = 0
	var/datum/fund/funding_fund
	var/funding_cost = 0
	var/warrant_consumed = 0

/datum/quest/kill/blockade_defense/get_scroll_type()
	return /obj/item/quest_writ/blockade

/datum/quest/kill/blockade_defense/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region
	var/datum/blockade/B = blockade_ref?.resolve()
	if(!B)
		return FALSE
	faction = B.get_faction()
	if(!faction || !length(faction.mob_types))
		return FALSE
	faction_id = faction.id
	target_mob_type = faction.pick_mob_type()
	if(!target_mob_type)
		return FALSE
	progress_required = estimate_mob_count()
	finalize_preview_title()
	return TRUE

/datum/quest/kill/blockade_defense/get_title()
	if(title)
		return title
	var/datum/blockade/B = blockade_ref?.resolve()
	var/datum/economic_region/ER = B?.get_region()
	if(ER)
		return "Break the blockade of [ER.name]"
	return "Break a trade blockade"

/datum/quest/kill/blockade_defense/get_objective_text()
	var/wave_label = current_wave > 0 ? "Wave [current_wave]/[BLOCKADE_TOTAL_WAVES]" : "Three waves await"
	if(!faction)
		return "[wave_label]. Hold the line."
	return "[wave_label]. Rout the [faction.name_plural]."

/datum/quest/kill/blockade_defense/on_first_pop()
	return

/datum/quest/kill/blockade_defense/populate_scroll_ui_static_data(list/data)
	data["blockade_total_waves"] = BLOCKADE_TOTAL_WAVES
	data["blockade_current_wave"] = current_wave
	data["blockade_armed"] = armed ? TRUE : FALSE
	data["blockade_failed"] = failed ? TRUE : FALSE

/datum/quest/kill/blockade_defense/populate_scroll_ui_data(list/data)
	var/active_timer_id
	var/label
	if(armed && arm_timer_id)
		active_timer_id = arm_timer_id
		label = "Arrive within"
	else if(current_wave > 0 && wave_timer_id)
		active_timer_id = wave_timer_id
		label = "Wave [current_wave] ends in"
	if(active_timer_id)
		var/left = timeleft(active_timer_id)
		if(left > 0)
			data["blockade_timer_label"] = label
			data["blockade_timer_seconds"] = round(left / 10)

/datum/quest/kill/blockade_defense/get_target_location()
	var/turf/from_mobs = ..()
	if(from_mobs)
		return from_mobs
	var/obj/effect/landmark/quest_spawner/landmark = wave_landmark_ref?.resolve()
	return landmark ? get_turf(landmark) : null

/datum/quest/kill/blockade_defense/calculate_reward(turf/origin_turf, turf/target_turf)
	return reward_amount

/datum/quest/kill/blockade_defense/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	wave_landmark_ref = WEAKREF(landmark)
	armed = TRUE
	arm_timer_id = addtimer(CALLBACK(src, PROC_REF(on_arm_timeout)), BLOCKADE_ARM_TIMEOUT_DS, TIMER_STOPPABLE)
	return TRUE

/datum/quest/kill/blockade_defense/proc/on_arm_timeout()
	if(failed || complete || !armed)
		return
	fail_quest("arm_timeout")

/datum/quest/kill/blockade_defense/proc/check_arrival(mob/bearer)
	if(!armed || failed || complete)
		return
	if(!bearer)
		return
	var/obj/effect/landmark/quest_spawner/landmark = wave_landmark_ref?.resolve()
	if(!landmark)
		return
	var/turf/bearer_turf = get_turf(bearer)
	var/turf/landmark_turf = get_turf(landmark)
	if(!bearer_turf || !landmark_turf)
		return
	if(bearer_turf.z != landmark_turf.z)
		return
	if(get_dist(bearer_turf, landmark_turf) > 7)
		return
	armed = FALSE
	if(arm_timer_id)
		deltimer(arm_timer_id)
		arm_timer_id = null
	announce_to_bearer("<b>You have reached the blockade.</b> Ready yourselves.")
	spawn_wave(1)

/datum/quest/kill/blockade_defense/proc/count_defenders(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return BLOCKADE_DEFENDER_SCALE_MIN
	var/turf/center = get_turf(landmark)
	if(!center)
		return BLOCKADE_DEFENDER_SCALE_MIN
	var/count = 0
	for(var/mob/living/L in range(BLOCKADE_DEFENDER_SCAN_RANGE, center))
		if(!L.client)
			continue
		if(L.stat == DEAD)
			continue
		count++
	return count

/datum/quest/kill/blockade_defense/proc/wave_tp_budget(defenders, wave_num)
	var/n = clamp(defenders, BLOCKADE_DEFENDER_SCALE_MIN, BLOCKADE_DEFENDER_SCALE_MAX)
	var/mult = 1 + (n - BLOCKADE_DEFENDER_SCALE_MIN) * BLOCKADE_TP_PER_EXTRA_DEFENDER
	if(wave_num < BLOCKADE_TOTAL_WAVES)
		mult *= BLOCKADE_EARLY_WAVE_TP_MULT
	return round(BLOCKADE_WAVE_BASE_TP * mult)

/datum/quest/kill/blockade_defense/proc/reward_turnout_mult()
	var/n = clamp(max_defenders_seen, BLOCKADE_DEFENDER_SCALE_MIN, BLOCKADE_DEFENDER_SCALE_MAX)
	return 1 + (n - BLOCKADE_DEFENDER_SCALE_MIN) * BLOCKADE_REWARD_PER_EXTRA_DEFENDER

/datum/quest/kill/blockade_defense/compose_candidates()
	var/list/base = faction.mob_types.Copy()
	if(current_archetype == BLOCKADE_ARCHETYPE_WARBAND)
		return base
	var/favor_expensive = (current_archetype == BLOCKADE_ARCHETYPE_ELITE)
	var/list/out = list()
	for(var/path in base)
		var/tp = max(initial_threat_point(path), 1)
		var/ratio = favor_expensive ? (tp / BLOCKADE_ARCHETYPE_PIVOT_TP) : (BLOCKADE_ARCHETYPE_PIVOT_TP / tp)
		out[path] = max(1, round(base[path] * (ratio ** BLOCKADE_ARCHETYPE_BIAS_STRENGTH)))
	return out

/datum/quest/kill/blockade_defense/proc/priciest_mob_type()
	var/best_path
	var/best_tp = 0
	for(var/path in faction.mob_types)
		var/tp = initial_threat_point(path)
		if(tp > best_tp)
			best_tp = tp
			best_path = path
	return best_path

/datum/quest/kill/blockade_defense/proc/spawn_wave_boss(obj/effect/landmark/quest_spawner/landmark)
	if(!faction)
		return
	var/boss_type = faction.pick_boss_mob_type() || priciest_mob_type()
	if(!boss_type)
		return
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return
	var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
	var/mob/living/boss = new boss_type(spawn_effect)
	boss.faction |= "quest"
	if(faction.faction_tag)
		boss.faction |= faction.faction_tag
	boss.mark_contract_spawned()
	boss.AddComponent(/datum/component/quest_object/kill, src)
	ADD_TRAIT(boss, TRAIT_FRESHSPAWN, "[type]")
	addtimer(TRAIT_CALLBACK_REMOVE(boss, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
	spawn_effect.contained_atom = boss
	spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
	register_spawner(spawn_effect)
	add_tracked_atom(boss)
	total_spawned_tp += initial(boss.threat_point) || 0
	progress_required += 1
	if(faction.boss_name_file)
		wave_boss_name = faction.generate_boss_name()
		addtimer(CALLBACK(src, PROC_REF(apply_wave_boss_name), WEAKREF(boss), wave_boss_name), 2 SECONDS)

/datum/quest/kill/blockade_defense/proc/apply_wave_boss_name(datum/weakref/boss_ref, boss_name)
	var/mob/living/boss = boss_ref?.resolve()
	if(QDELETED(boss) || !boss_name)
		return
	boss.real_name = boss_name
	boss.name = boss_name

/datum/quest/kill/blockade_defense/proc/spawn_wave(wave_num)
	if(failed || complete)
		return
	if(wave_num < 1 || wave_num > BLOCKADE_TOTAL_WAVES)
		return
	var/obj/effect/landmark/quest_spawner/landmark = wave_landmark_ref?.resolve()
	if(!landmark)
		fail_quest("landmark_lost")
		return
	current_wave = wave_num
	var/defenders = count_defenders(landmark)
	max_defenders_seen = max(max_defenders_seen, defenders)
	tp_budget = wave_tp_budget(defenders, wave_num)
	current_archetype = pickweight(BLOCKADE_ARCHETYPE_WEIGHTS)
	total_spawned_tp = 0
	progress_current = 0
	progress_required = 1
	spawn_kill_mobs(landmark)
	if(wave_num >= BLOCKADE_TOTAL_WAVES)
		spawn_wave_boss(landmark)
	if(progress_required <= 0)
		fail_quest("composition_empty")
		return
	clear_wave_timers()
	wave_timer_id = addtimer(CALLBACK(src, PROC_REF(on_wave_timeout), wave_num), BLOCKADE_WAVE_TIMER_DS, TIMER_STOPPABLE)
	// Chat pings at 2 min and 30 s left. Skipped if the wave timer is shorter than the threshold.
	if(BLOCKADE_WAVE_TIMER_DS > (2 MINUTES))
		wave_warn_2m_id = addtimer(CALLBACK(src, PROC_REF(warn_time_left), wave_num, "two minutes"), BLOCKADE_WAVE_TIMER_DS - (2 MINUTES), TIMER_STOPPABLE)
	if(BLOCKADE_WAVE_TIMER_DS > (30 SECONDS))
		wave_warn_30s_id = addtimer(CALLBACK(src, PROC_REF(warn_time_left), wave_num, "thirty seconds"), BLOCKADE_WAVE_TIMER_DS - (30 SECONDS), TIMER_STOPPABLE)
	announce_to_bearer("<b>Wave [wave_num]/[BLOCKADE_TOTAL_WAVES]</b> [wave_flavor()] You have [BLOCKADE_WAVE_TIMER_DS / 600] minutes.")
	quest_scroll?.update_quest_text()

/datum/quest/kill/blockade_defense/proc/wave_flavor()
	var/who = faction ? faction.name_plural : "raiders"
	if(current_wave >= BLOCKADE_TOTAL_WAVES && wave_boss_name)
		return "descends on you - [wave_boss_name] leads the [who]."
	switch(current_archetype)
		if(BLOCKADE_ARCHETYPE_SWARM)
			return "breaks over you - a tide of [who]."
		if(BLOCKADE_ARCHETYPE_ELITE)
			return "advances - a hardened [faction ? faction.group_word : "band"] of [who]."
	return "descends on you - a [faction ? faction.group_word : "band"] of [who]."

/datum/quest/kill/blockade_defense/proc/warn_time_left(wave_num, label)
	if(failed || complete)
		return
	if(wave_num != current_wave)
		return
	announce_to_bearer("<b>Wave [wave_num]:</b> [label] remaining.")

/datum/quest/kill/blockade_defense/proc/clear_wave_timers()
	if(wave_timer_id)
		deltimer(wave_timer_id)
		wave_timer_id = null
	if(wave_warn_2m_id)
		deltimer(wave_warn_2m_id)
		wave_warn_2m_id = null
	if(wave_warn_30s_id)
		deltimer(wave_warn_30s_id)
		wave_warn_30s_id = null

/datum/quest/kill/blockade_defense/on_progress_update()
	if(failed || complete)
		return
	if(progress_current < progress_required)
		return
	clear_wave_timers()
	if(current_wave >= BLOCKADE_TOTAL_WAVES)
		mark_complete()
		return
	announce_to_bearer("<b>Wave [current_wave] broken.</b> Another wave gathers...")
	addtimer(CALLBACK(src, PROC_REF(spawn_wave), current_wave + 1), 5 SECONDS)

/datum/quest/kill/blockade_defense/proc/on_wave_timeout(wave_num)
	if(failed || complete)
		return
	if(wave_num != current_wave)
		return
	fail_quest("timeout")

/datum/quest/kill/blockade_defense/proc/fail_quest(reason)
	if(failed || complete)
		return
	failed = TRUE
	clear_wave_timers()
	if(arm_timer_id)
		deltimer(arm_timer_id)
		arm_timer_id = null
	announce_to_bearer("<b>The blockade holds.</b> The scroll smolders and crumbles in your grip.")
	record_round_statistic(STATS_BLOCKADE_CONTRACTS_FAILED, 1)
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		B.active_quest_ref = null
	despawn_live_wave_mobs()
	quest_scroll?.update_quest_text()
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)

/datum/quest/kill/blockade_defense/proc/recall_blocker()
	if(failed)
		return "the writ has already lapsed"
	if(complete)
		return "the blockade is already broken"
	if(current_wave > 0)
		return "the fellowship has already engaged the blockade"
	if(!issued_at)
		return "the writ's issue time is unknown"
	var/elapsed = world.time - issued_at
	if(elapsed < BLOCKADE_RECALL_WINDOW_DS)
		var/remaining = BLOCKADE_RECALL_WINDOW_DS - elapsed
		var/minutes_left = max(1, round(remaining / 600))
		return "the bearer has [minutes_left] minute(s) left to reach the blockade before it can be recalled"
	return null

/datum/quest/kill/blockade_defense/proc/can_recall()
	return isnull(recall_blocker())

/datum/quest/kill/blockade_defense/proc/recall(mob/recaller, reason = "recalled")
	if(!can_recall())
		return FALSE
	if(arm_timer_id)
		deltimer(arm_timer_id)
		arm_timer_id = null
	armed = FALSE
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		B.active_quest_ref = null
	if(funding_fund && funding_cost > 0)
		SStreasury.mint(funding_fund, funding_cost, "Blockade writ recall refund ([recaller ? recaller.real_name : "unknown"])")
		if(funding_fund == SStreasury.burgher_pledge_fund)
			record_round_statistic(STATS_PLEDGE_CONSUMED, -funding_cost)
	if(warrant_consumed > 0)
		SScity_assembly?.refund_defense(warrant_consumed, recaller, "blockade writ recall")
		warrant_consumed = 0
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)
	else
		SSquestpool.pool -= src
		qdel(src)
	return TRUE

/datum/quest/kill/blockade_defense/proc/despawn_live_wave_mobs()
	for(var/datum/weakref/W in tracked_atoms)
		var/mob/living/M = W.resolve()
		if(QDELETED(M))
			continue
		if(M.stat == DEAD)
			continue
		qdel(M)

/datum/quest/kill/blockade_defense/mark_complete()
	..()
	clear_wave_timers()
	if(arm_timer_id)
		deltimer(arm_timer_id)
		arm_timer_id = null
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		B.active_quest_ref = null
		SSeconomy.clear_blockade(B, "cleared")
	var/mob/lead = quest_receiver_reference?.resolve()
	var/payout = round(reward_amount * reward_turnout_mult())
	if(payout > 0)
		if(lead && SStreasury.has_account(lead))
			var/datum/fund/lead_account = SStreasury.get_account(lead)
			SStreasury.mint(lead_account, payout, "Blockade defense reward ([quest_giver_name || "Crown"] -> [lead.real_name])")
			var/tax_amt = 0
			if(!levy_exempt)
				tax_amt = SStreasury.apply_tax(lead_account, payout, TAX_CATEGORY_CONTRACT_LEVY, "Blockade defense")
				if(tax_amt > 0)
					record_featured_stat(FEATURED_STATS_TAX_PAYERS, lead, tax_amt)
					record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
			record_round_statistic(STATS_BLOCKADE_REWARDS_PAID, payout)
			announce_to_bearer("The final wave breaks. The rewards have been transferred to your account. Gross: [payout] mammons. Tax: [tax_amt] mammons. Net: [payout - tax_amt] mammons.")
		else
			SStreasury.mint(SStreasury.discretionary_fund, payout, "Blockade defense reward (unbanked bearer)")
			announce_to_bearer("The final wave breaks. The Crown holds your share - return to the Nerve Master to collect.")
	else
		announce_to_bearer("The final wave breaks. This was a Request - no reward is due.")
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)
