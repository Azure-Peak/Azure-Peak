/datum/quest/kill/blockade_defense
	quest_type = QUEST_BLOCKADE_DEFENSE
	quest_difficulty = QUEST_DIFFICULTY_HARD
	tp_budget = BLOCKADE_WAVE_1_TP
	threat_bands_cleared = QUEST_BANDS_RAID * 2
	required_fellowship_size = 0

	var/current_wave = 0
	var/wave_timer_id
	/// Chat-ping timers. Fire at 2 min and 30 s left so the bearer is warned before forfeit.
	var/wave_warn_2m_id
	var/wave_warn_30s_id
	var/datum/weakref/wave_landmark_ref
	var/datum/weakref/blockade_ref
	var/failed = FALSE
	/// TRUE after materialize() arms the quest and before the bearer has triggered wave 1
	/// by entering the landmark's proximity. Prevents double-fire via check_arrival.
	var/armed = FALSE
	var/list/wave_budgets = list(BLOCKADE_WAVE_1_TP, BLOCKADE_WAVE_2_TP, BLOCKADE_WAVE_3_TP)
	/// Auto-fail timer that fires if the bearer never reaches the landmark. Without this, a writ
	/// stashed in a drawer or handed to someone who never travels keeps the blockade slot locked
	/// until round-end.
	var/arm_timer_id
	/// world.time at which the writ was issued. Used by the Steward's ledger to gate recall
	/// within BLOCKADE_RECALL_WINDOW_DS.
	var/issued_at = 0
	/// Fund the commission draft was burned from, so a recall can mint the cost back to the
	/// correct pot. Null for directives (which burned nothing).
	var/datum/fund/funding_fund
	var/funding_cost = 0

/// Faction is forced by the blockade, not rolled from threat weights.
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

/// Compass target: live wave mobs when present, otherwise the landmark itself. The base impl
/// iterates tracked_atoms (spawned mobs), which is empty while armed (before wave 1) and between
/// waves — the scroll would whisper "location unknown" right when the bearer most needs it.
/datum/quest/kill/blockade_defense/get_target_location()
	var/turf/from_mobs = ..()
	if(from_mobs)
		return from_mobs
	var/obj/effect/landmark/quest_spawner/landmark = wave_landmark_ref?.resolve()
	return landmark ? get_turf(landmark) : null

/// Reward is set at issue time (BLOCKADE_SCROLL_REWARD × region tp_budget_multiplier).
/datum/quest/kill/blockade_defense/calculate_reward(turf/origin_turf, turf/target_turf)
	return reward_amount

/// Materialize arms the quest but does NOT spawn wave 1. The scroll's process() tick polls
/// check_arrival() and fires wave 1 once the bearer is in proximity to the landmark.
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

/// Called from the scroll's process tick. Tests bearer proximity; fires wave 1 on arrival.
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
	tp_budget = wave_budgets[wave_num]
	total_spawned_tp = 0
	progress_current = 0
	progress_required = 1
	spawn_kill_mobs(landmark)
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
	announce_to_bearer("<b>Wave [wave_num]/[BLOCKADE_TOTAL_WAVES]</b> descends on you. You have [BLOCKADE_WAVE_TIMER_DS / 600] minutes.")
	quest_scroll?.update_quest_text()

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
	despawn_live_wave_mobs()
	quest_scroll?.update_quest_text()
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)

/// Reason the writ cannot be recalled right now, or null if it can. Single source of truth
/// for both the DM recall handler and the Steward's TGUI flavor copy. Recall policy:
/// the bearer gets an uninterrupted BLOCKADE_RECALL_WINDOW_DS to reach the blockade; only
/// after that window, and only if they still haven't engaged (armed == TRUE), may the
/// Steward yank the writ and refund the draft. Once a wave has started the fellowship
/// owns the outcome regardless of elapsed time.
/datum/quest/kill/blockade_defense/proc/recall_blocker()
	if(failed)
		return "the writ has already lapsed"
	if(complete)
		return "the blockade is already broken"
	// current_wave > 0 means a wave has actually spawned - the fellowship is committed.
	// armed == FALSE before the scroll is opened (pre-claim), so we can't use !armed
	// here or an untouched writ would incorrectly read as "already engaged".
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

/// Steward-initiated cancellation. Refunds the original funding draft (if any), then
/// tears down the quest by deleting the scroll - Destroy handles qdeling the quest datum
/// and the blockade's weakref self-heals.
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
	if(funding_fund && funding_cost > 0)
		SStreasury.mint(funding_fund, funding_cost, "Blockade writ recall refund ([recaller ? recaller.real_name : "unknown"])")
		if(funding_fund == SStreasury.burgher_pledge_fund)
			record_round_statistic(STATS_PLEDGE_CONSUMED, -funding_cost)
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)
	return TRUE

/datum/quest/kill/blockade_defense/proc/despawn_live_wave_mobs()
	for(var/datum/weakref/W in tracked_atoms)
		var/mob/living/M = W.resolve()
		if(QDELETED(M))
			continue
		if(M.stat == DEAD)
			continue
		qdel(M)

/// Reward pays immediately on last-wave clear (not at noticeboard turn-in) so the
/// fellowship doesn't have to risk the scroll on the trip home. Scroll burns afterward
/// to prevent double-minting at the contract ledger.
/datum/quest/kill/blockade_defense/mark_complete()
	..()
	clear_wave_timers()
	if(arm_timer_id)
		deltimer(arm_timer_id)
		arm_timer_id = null
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		SSeconomy.clear_blockade(B, "cleared")
	var/mob/lead = quest_receiver_reference?.resolve()
	var/payout = reward_amount
	if(payout > 0)
		if(lead && SStreasury.has_account(lead))
			SStreasury.mint(SStreasury.get_account(lead), payout, "Blockade defense reward ([quest_giver_name || "Crown"] -> [lead.real_name])")
			record_round_statistic(STATS_BLOCKADE_REWARDS_PAID, payout)
			announce_to_bearer("The final wave breaks. The rewards have been transferred to your account.")
		else
			SStreasury.mint(SStreasury.discretionary_fund, payout, "Blockade defense reward (unbanked bearer)")
			announce_to_bearer("The final wave breaks. The Crown holds your share - return to the Nerve Master to collect.")
	else
		announce_to_bearer("The final wave breaks. This was a Request - no reward is due.")
	var/obj/item/quest_writ/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)
