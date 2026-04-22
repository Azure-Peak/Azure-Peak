/datum/quest/kill/blockade_defense
	quest_type = QUEST_BLOCKADE_DEFENSE
	quest_difficulty = QUEST_DIFFICULTY_HARD
	tp_budget = BLOCKADE_WAVE_1_TP
	threat_bands_cleared = QUEST_BANDS_RAID
	required_fellowship_size = 0

	var/current_wave = 0
	var/wave_timer_id
	var/datum/weakref/wave_landmark_ref
	var/datum/weakref/blockade_ref
	var/failed = FALSE
	var/list/wave_budgets = list(BLOCKADE_WAVE_1_TP, BLOCKADE_WAVE_2_TP, BLOCKADE_WAVE_3_TP)

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

/datum/quest/kill/blockade_defense/get_location_text()
	var/datum/blockade/B = blockade_ref?.resolve()
	var/datum/economic_region/ER = B?.get_region()
	if(ER)
		return "Blockade reported at the [ER.name] trade road."
	return ..()

/// Flat reward: the Steward committed a fixed Pledge draw, not TP-scaled.
/datum/quest/kill/blockade_defense/calculate_reward(turf/origin_turf, turf/target_turf)
	return BLOCKADE_SCROLL_REWARD

/datum/quest/kill/blockade_defense/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	wave_landmark_ref = WEAKREF(landmark)
	spawn_wave(1)
	return TRUE

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
	if(wave_timer_id)
		deltimer(wave_timer_id)
	wave_timer_id = addtimer(CALLBACK(src, PROC_REF(on_wave_timeout), wave_num), BLOCKADE_WAVE_TIMER_DS, TIMER_STOPPABLE)
	var/datum/economic_region/ER = blockade_ref?.resolve()?.get_region()
	var/region_label = ER ? ER.name : "the blockade"
	announce_to_bearer("<b>Wave [wave_num]/[BLOCKADE_TOTAL_WAVES]</b> descends on [region_label]. You have five minutes.")
	quest_scroll?.update_quest_text()

/datum/quest/kill/blockade_defense/on_progress_update()
	if(failed || complete)
		return
	if(progress_current < progress_required)
		quest_scroll?.update_quest_text()
		return
	if(wave_timer_id)
		deltimer(wave_timer_id)
		wave_timer_id = null
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
	if(wave_timer_id)
		deltimer(wave_timer_id)
		wave_timer_id = null
	announce_to_bearer("<b>The blockade holds.</b> The scroll smolders and crumbles in your grip.")
	record_round_statistic(STATS_BLOCKADE_CONTRACTS_FAILED, 1)
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
	despawn_live_wave_mobs()
	var/obj/item/paper/scroll/quest/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)

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
	if(wave_timer_id)
		deltimer(wave_timer_id)
		wave_timer_id = null
	var/datum/blockade/B = blockade_ref?.resolve()
	if(B)
		B.active_scroll_ref = null
		SSeconomy.clear_blockade(B, "cleared")
	var/mob/lead = quest_receiver_reference?.resolve()
	if(lead && SStreasury.has_account(lead))
		SStreasury.mint(SStreasury.get_account(lead), BLOCKADE_SCROLL_REWARD, "Blockade defense reward ([quest_giver_name || "Crown"] -> [lead.real_name])")
		record_round_statistic(STATS_BLOCKADE_REWARDS_PAID, BLOCKADE_SCROLL_REWARD)
		announce_to_bearer("The final wave breaks. [BLOCKADE_SCROLL_REWARD] mammon has been deposited to your account.")
	else
		SStreasury.mint(SStreasury.discretionary_fund, BLOCKADE_SCROLL_REWARD, "Blockade defense reward (unbanked bearer)")
		announce_to_bearer("The final wave breaks. The Crown holds your share — return to the Nerve Master to collect.")
	var/obj/item/paper/scroll/quest/S = quest_scroll
	if(S && !QDELETED(S))
		qdel(S)

/datum/quest/kill/blockade_defense/proc/announce_to_bearer(msg)
	var/mob/bearer = quest_receiver_reference?.resolve()
	if(!bearer)
		return
	to_chat(bearer, span_notice(msg))
