GLOBAL_LIST_INIT(towner_posting_tiers, list(
	TOWNER_POSTING_TIER_MEDIUM = list("cost" = TOWNER_POSTING_COST_MEDIUM, "difficulty" = QUEST_DIFFICULTY_MEDIUM, "reward_cap" = TOWNER_REWARD_CAP_MEDIUM, "flat_bonus" = TOWNER_FLAT_BONUS_MEDIUM),
	TOWNER_POSTING_TIER_HARD = list("cost" = TOWNER_POSTING_COST_HARD, "difficulty" = QUEST_DIFFICULTY_HARD, "reward_cap" = TOWNER_REWARD_CAP_HARD, "flat_bonus" = TOWNER_FLAT_BONUS_HARD),
	TOWNER_POSTING_TIER_PERILOUS = list("cost" = TOWNER_POSTING_COST_PERILOUS, "difficulty" = QUEST_DIFFICULTY_INCURSION, "reward_cap" = TOWNER_REWARD_CAP_PERILOUS, "flat_bonus" = TOWNER_FLAT_BONUS_PERILOUS, "fellowship" = QUEST_INCURSION_FELLOWSHIP_REQUIREMENT),
))

/proc/get_towner_tier_term(tier, term)
	var/list/terms = GLOB.towner_posting_tiers[tier]
	return terms?[term]

/proc/get_towner_prototype(quest_type)
	var/datum/quest/kill/recovery/towner/proto = GLOB.quest_prototypes[quest_type]
	return istype(proto) ? proto : null

/proc/get_towner_prototypes()
	. = list()
	for(var/qtype in GLOB.quest_prototypes)
		if(get_towner_prototype(qtype))
			.[qtype] = GLOB.quest_prototypes[qtype]

/datum/quest/kill/recovery/towner
	abstract_type = /datum/quest/kill/recovery/towner
	chronicle_order = QUEST_CHRONICLE_ORDER_TOWNER
	pool_kind = null
	pool_weight = 0
	rumor_cost = 0 // We don't want the Innkeeper to be able to issue these quests, so these overrides prevent it from appearing in their list.
	writ_type = WRIT_TYPE_TOWNER
	levy_exempt = TRUE
	guild_cut_rate = 0
	charges_deposit = FALSE
	lapses = FALSE
	takes_destination = FALSE
	fellowship_threat_rate = 0
	fellowship_reward_rate = 0
	var/posting_tier = TOWNER_POSTING_TIER_MEDIUM
	var/loadout_variety
	var/parcel_label = "sealed strongbox"
	var/sealed_noun = "strongbox"
	var/posting_label
	var/posting_blurb
	var/list/posting_rules = list(
		"The crate is magickally sealed. Only you can open it.",
		"You don't need to travel along. The holder will bring the package to you or send it by HERMES to be opened at your leisure.",
	)
	eligible_regions = list()
	var/list/postable_advclasses = list()
	var/list/tier_tp_budgets = list(
		TOWNER_POSTING_TIER_MEDIUM = list(TOWNER_CARAVAN_TP_BUDGET_MEDIUM),
		TOWNER_POSTING_TIER_HARD = list(TOWNER_CARAVAN_TP_BUDGET_HARD),
		TOWNER_POSTING_TIER_PERILOUS = list(TOWNER_PERILOUS_TP_BUDGET_FIRST, TOWNER_PERILOUS_TP_BUDGET_SECOND),
	)
	var/list/varieties = list()
	var/list/bundle_pools = list()
	var/list/wave_budgets
	var/current_wave = 1
	var/intermission_timer_id
	var/intermission_warn_id

/datum/quest/kill/recovery/towner/Destroy()
	clear_intermission_timers()
	return ..()

/datum/quest/kill/recovery/towner/proc/clear_intermission_timers()
	if(intermission_timer_id)
		deltimer(intermission_timer_id)
		intermission_timer_id = null
	if(intermission_warn_id)
		deltimer(intermission_warn_id)
		intermission_warn_id = null

/datum/quest/kill/recovery/towner/calculate_reward(turf/origin_turf, turf/target_turf)
	. = ..()
	var/cap = get_towner_tier_term(posting_tier, "reward_cap")
	if(cap)
		. = min(., cap)

/datum/quest/kill/recovery/towner/get_scroll_type()
	return /obj/item/quest_writ/towner

/datum/quest/kill/recovery/towner/proc/get_writ_intro()
	return "One of the townsfolk calls for hands to recover what was lost to the wilds and bring it home."

/datum/quest/kill/recovery/towner/proc/get_writ_seal_note()
	return "The [sealed_noun] is magickally sealed to [quest_giver_name || "the poster"]. You can deposit the package in the nearest HERMES to complete the contract, or have them open it by hand."

/datum/quest/kill/recovery/towner/populate_scroll_ui_static_data(list/data)
	..()
	data["towner_intro"] = get_writ_intro()
	data["towner_seal_note"] = get_writ_seal_note()

/datum/quest/kill/recovery/towner/proc/get_tier_wave_budgets()
	return tier_tp_budgets[posting_tier] || tier_tp_budgets[TOWNER_POSTING_TIER_MEDIUM]

/datum/quest/kill/recovery/towner/proc/wave_budget(wave)
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	return round(wave_budgets[wave] * (TR ? TR.tp_budget_multiplier : 1))

/datum/quest/kill/recovery/towner/proc/unsent_wave_tp()
	. = 0
	for(var/wave in (current_wave + 1) to length(wave_budgets))
		. += wave_budget(wave)

/datum/quest/kill/recovery/towner/proc/get_tier_flat_bonus()
	return get_towner_tier_term(posting_tier, "flat_bonus") || 0

/datum/quest/kill/recovery/towner/build_bundle()
	var/variety = effective_variety()
	if(!variety)
		return list()
	var/list/meta = varieties[variety]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])

/datum/quest/kill/recovery/towner/proc/effective_variety()
	if(!length(varieties))
		return null
	if(loadout_variety && (loadout_variety in varieties))
		return loadout_variety
	return varieties[1]

/datum/quest/kill/recovery/towner/proc/resolve_bundle_spec(list/spec)
	var/list/bundle = list()
	if(!length(spec))
		return bundle
	for(var/list/entry in spec)
		if(entry["prob"] != null && !prob(entry["prob"]))
			continue
		var/count = rand(entry["min"], entry["max"])
		if(count <= 0)
			continue
		var/pool = entry["pool"]
		if(pool)
			var/list/resolved = istext(pool) ? bundle_pools[pool] : pool
			if(!length(resolved))
				continue
			for(var/i in 1 to count)
				var/ppath = pick(resolved)
				bundle[ppath] = (bundle[ppath] || 0) + 1
		else
			var/path = entry["path"]
			bundle[path] = (bundle[path] || 0) + count
	return bundle

/datum/quest/kill/recovery/towner/proc/get_parcel_name()
	return "[quest_giver_name]'s [parcel_label]"

/datum/quest/kill/recovery/towner/proc/get_parcel_desc()
	return "A [sealed_noun] magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!(landmark.region in eligible_regions))
		return FALSE
	wave_budgets = get_tier_wave_budgets()
	tp_budget = wave_budgets[1]
	return ..()

/datum/quest/kill/recovery/towner/pick_shipment()
	shipment_name = parcel_label
	return TRUE

/datum/quest/kill/recovery/towner/get_additional_reward(turf/origin_turf, turf/target_turf)
	return ..() + get_tier_flat_bonus() + unsent_wave_tp() * QUEST_KILL_THREAT_MULT

/datum/quest/kill/recovery/towner/on_guardian_killed()
	if(current_wave >= length(wave_budgets))
		return ..()
	if(intermission_timer_id || any_guardians_alive())
		return
	clear_hunt_timers()
	intermission_timer_id = addtimer(CALLBACK(src, PROC_REF(spawn_next_wave)), QUEST_INCURSION_INTERMISSION, TIMER_STOPPABLE)
	intermission_warn_id = addtimer(CALLBACK(src, PROC_REF(warn_next_wave)), QUEST_INCURSION_INTERMISSION - QUEST_INCURSION_INTERMISSION_WARN, TIMER_STOPPABLE)
	quest_scroll?.update_quest_text()
	announce_to_bearer("Reinforcements will arrive in [DisplayTimeText(QUEST_INCURSION_INTERMISSION)].")

/datum/quest/kill/recovery/towner/proc/warn_next_wave()
	intermission_warn_id = null
	if(complete || failed)
		return
	announce_to_bearer("[DisplayTimeText(QUEST_INCURSION_INTERMISSION_WARN)] remains.")

/datum/quest/kill/recovery/towner/proc/spawn_next_wave()
	intermission_timer_id = null
	if(complete || failed)
		return
	var/obj/effect/landmark/quest_spawner/landmark = pending_landmark_ref?.resolve()
	if(QDELETED(landmark))
		return
	current_wave++
	var/saved_budget = tp_budget
	tp_budget = roll_tp_budget(wave_budget(current_wave))
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
	start_hunt_timer(hunt_duration)
	quest_scroll?.update_quest_text()
	if(!spawned)
		on_guardian_killed()
		return
	announce_to_bearer("Reinforcements of [spawned] [faction?.name_plural || "foes"] have arrived, you have [DisplayTimeText(hunt_duration)] to dispatch of them.")

/datum/quest/kill/recovery/towner/populate_scroll_ui_data(list/data)
	if(intermission_timer_id)
		var/left = timeleft(intermission_timer_id)
		if(left > 0)
			data["hunt_timer_label"] = "Next wave arrives in"
			data["hunt_timer_seconds"] = round(left / 10)
		return
	return ..()

/datum/quest/kill/recovery/towner/on_claim(mob/user)
	. = ..()
	to_chat(user, span_warning("The [sealed_noun] is magickally sealed. Only [quest_giver_name] can open it."))

/datum/quest/kill/recovery/towner/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	var/obj/item/parcel/towner_caravan/recovered = spawn_parcel(landmark, /obj/item/parcel/towner_caravan, build_bundle(), get_parcel_name(), get_parcel_desc())
	if(!recovered)
		return
	recovered.unlocked_by_owner_ref = quest_giver_reference
	recovered.owner_name = quest_giver_name
	recovered.sealed_noun = sealed_noun
