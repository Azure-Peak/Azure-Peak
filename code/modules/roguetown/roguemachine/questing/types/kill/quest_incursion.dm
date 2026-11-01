/datum/quest/kill/incursion
	quest_type = QUEST_INCURSION
	chronicle_order = QUEST_CHRONICLE_ORDER_INCURSION
	quest_difficulty = QUEST_DIFFICULTY_INCURSION
	pool_kind = QUEST_POOL_KILL
	pool_weight = QUEST_POOL_WEIGHT_INCURSION
	rumor_cost = RUMOR_COST_INCURSION
	defense_cost = BURGHER_PLEDGE_COST_INCURSION
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_UNDERDARK,
	)
	tp_budget = QUEST_TP_BUDGET_INCURSION_FIRST
	threat_bands_cleared = QUEST_BANDS_INCURSION
	required_fellowship_size = QUEST_INCURSION_FELLOWSHIP_REQUIREMENT
	fellowship_threat_rate = QUEST_FELLOWSHIP_THREAT_PER_EXTRA_INCURSION
	fellowship_reward_rate = QUEST_FELLOWSHIP_REWARD_PER_EXTRA_INCURSION
	objective_verb = "Rout"
	var/second_wave_sent = FALSE
	var/intermission_timer_id
	var/intermission_warn_id

/datum/quest/kill/incursion/Destroy()
	clear_intermission_timers()
	return ..()

/datum/quest/kill/incursion/proc/clear_intermission_timers()
	if(intermission_timer_id)
		deltimer(intermission_timer_id)
		intermission_timer_id = null
	if(intermission_warn_id)
		deltimer(intermission_warn_id)
		intermission_warn_id = null

/datum/quest/kill/incursion/get_title()
	if(title)
		return title
	if(!faction)
		return "Break an incursion"
	return "Break an incursion of [faction.name_plural]"

/datum/quest/kill/incursion/get_objective_text()
	var/plural = faction ? faction.name_plural : initial(target_mob_type.name)
	if(second_wave_sent)
		return "Second wave: [objective_verb] ~[progress_required] [plural]."
	return "First wave: [objective_verb] ~[progress_required] [plural]. A second wave of [plural] will arrive [DisplayTimeText(QUEST_INCURSION_INTERMISSION)] after."

/datum/quest/kill/incursion/proc/second_wave_budget()
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	return round(QUEST_TP_BUDGET_INCURSION_SECOND * (TR ? TR.tp_budget_multiplier : 1))

/datum/quest/kill/incursion/get_additional_reward(turf/origin_turf, turf/target_turf)
	. = ..()
	if(second_wave_sent)
		return
	. += round(second_wave_budget() * fellowship_threat_mult) * QUEST_KILL_THREAT_MULT

/datum/quest/kill/incursion/check_completion()
	return second_wave_sent && ..()

/datum/quest/kill/incursion/on_progress_update()
	if(!second_wave_sent && !intermission_timer_id && progress_current >= progress_required)
		clear_hunt_timers()
		intermission_timer_id = addtimer(CALLBACK(src, PROC_REF(spawn_second_wave)), QUEST_INCURSION_INTERMISSION, TIMER_STOPPABLE)
		intermission_warn_id = addtimer(CALLBACK(src, PROC_REF(warn_second_wave)), QUEST_INCURSION_INTERMISSION - QUEST_INCURSION_INTERMISSION_WARN, TIMER_STOPPABLE)
		quest_scroll?.update_quest_text()
		announce_to_bearer("Reinforcements will arrive in [DisplayTimeText(QUEST_INCURSION_INTERMISSION)].")
	return ..()

/datum/quest/kill/incursion/proc/warn_second_wave()
	intermission_warn_id = null
	if(second_wave_sent || complete || failed)
		return
	announce_to_bearer("[DisplayTimeText(QUEST_INCURSION_INTERMISSION_WARN)] remains.")

/datum/quest/kill/incursion/proc/spawn_second_wave()
	intermission_timer_id = null
	if(second_wave_sent || complete || failed)
		return
	var/obj/effect/landmark/quest_spawner/landmark = pending_landmark_ref?.resolve()
	if(QDELETED(landmark))
		return
	second_wave_sent = TRUE
	var/saved_budget = tp_budget
	tp_budget = roll_tp_budget(second_wave_budget())
	var/list/to_spawn = compose_warband()
	tp_budget = saved_budget
	var/spawned = 0
	for(var/mob_path in to_spawn)
		var/mob/living/new_mob = spawn_hidden_mob(landmark, mob_path)
		if(!new_mob)
			continue
		total_spawned_tp += initial(new_mob.threat_point) || 0
		spawned++
		sleep(1)
	progress_current = 0
	progress_required = spawned
	start_hunt_timer(hunt_duration)
	quest_scroll?.update_quest_text()
	announce_to_bearer("Reinforcements of [spawned] [faction?.name_plural || "foes"] have arrived, you have [DisplayTimeText(hunt_duration)] to dispatch of them.")
	on_progress_update()

/datum/quest/kill/incursion/populate_scroll_ui_data(list/data)
	if(intermission_timer_id)
		var/left = timeleft(intermission_timer_id)
		if(left > 0)
			data["hunt_timer_label"] = "Second wave arrives in"
			data["hunt_timer_seconds"] = round(left / 10)
		return
	return ..()
