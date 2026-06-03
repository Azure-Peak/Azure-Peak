GLOBAL_LIST_INIT(towner_orevein_regions, list(
	THREAT_REGION_AZUREAN_COAST,
	THREAT_REGION_UNDERDARK,
))

GLOBAL_LIST_INIT(towner_orevein_gem_types, list(
	/obj/item/roguegem/green,
	/obj/item/roguegem/blue,
	/obj/item/roguegem/yellow,
	/obj/item/roguegem/violet,
	/obj/item/roguegem/ruby,
	/obj/item/roguegem/diamond,
	/obj/item/roguegem/jade,
))

/datum/quest/kill/towner_miner_orevein
	quest_type = QUEST_TOWNER_MINER_OREVEIN
	quest_difficulty = QUEST_DIFFICULTY_HARD
	required_fellowship_size = TOWNER_QUEST_FELLOWSHIP_SIZE
	levy_exempt = TRUE
	guild_cut_exempt = TRUE
	threat_bands_cleared = QUEST_BANDS_RECOVERY
	kills_count_progress = FALSE
	writ_type = WRIT_TYPE_TOWNER_VEIN
	var/posting_tier = TOWNER_POSTING_TIER_HARD
	var/datum/weakref/wreck_landmark_ref
	var/clusters_spawned = FALSE
	var/clusters_total = 0
	var/clusters_remaining = 0
	var/expiry_at = 0
	var/expiry_timer_id = null
	var/expired = FALSE
	var/bearer_arrived = FALSE

	var/warned_bearer_return = FALSE
	var/announced_waiting_miner = FALSE
	var/list/datum/weakref/spawned_cluster_refs = list()

/datum/quest/kill/towner_miner_orevein/calculate_deposit()
	return 0

/datum/quest/kill/towner_miner_orevein/get_target_location()
	if(!clusters_spawned)
		var/obj/effect/landmark/quest_spawner/landmark = wreck_landmark_ref?.resolve()
		if(landmark)
			return get_turf(landmark)
	return ..()

/datum/quest/kill/towner_miner_orevein/can_claim(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	return towner_can_claim_check(src, user)

/datum/quest/kill/towner_miner_orevein/claim_failure_reason(mob/living/user)
	var/towner_reason = towner_claim_failure_reason(src, user)
	if(towner_reason)
		return towner_reason
	return ..()

/datum/quest/kill/towner_miner_orevein/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Lead"
	return "A Miner's Lead"

/datum/quest/kill/towner_miner_orevein/finalize_preview_title()
	if(!title)
		title = get_title()

/datum/quest/kill/towner_miner_orevein/get_objective_text()
	if(!clusters_spawned)
		return "Escort the miner to the strike. The vein opens when you arrive."
	return "Slay the elementals while the miner works the rock - [clusters_remaining]/[clusters_total] clusters remain."

/datum/quest/kill/towner_miner_orevein/pick_region_faction_for(datum/threat_region/TR)
	return get_quest_faction(QUEST_FACTION_EARTH_ELEMENTAL)

/datum/quest/kill/towner_miner_orevein/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!(landmark.region in GLOB.towner_orevein_regions))
		return FALSE
	tp_budget = (posting_tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_OREVEIN_TP_BUDGET_HARD : TOWNER_OREVEIN_TP_BUDGET_MEDIUM
	. = ..()
	if(!.)
		return FALSE
	return TRUE

/datum/quest/kill/towner_miner_orevein/get_additional_reward(turf/origin_turf, turf/target_turf)
	var/base = ..()
	base += (posting_tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_OREVEIN_FLAT_BONUS_HARD : TOWNER_OREVEIN_FLAT_BONUS_MEDIUM
	return base

/datum/quest/kill/towner_miner_orevein/on_claim(mob/user)
	. = ..()
	to_chat(user, span_warning("The vein stays buried until [quest_giver_name] reaches the strike. Once you arrive, the elementals erupt - and the [TOWNER_OREVEIN_EXPIRY_DS / 600]-minute clock starts."))

/datum/quest/kill/towner_miner_orevein/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	wreck_landmark_ref = WEAKREF(landmark)
	addtimer(CALLBACK(src, PROC_REF(check_arrival)), TOWNER_PRESENCE_POLL_INTERVAL)
	return TRUE

/datum/quest/kill/towner_miner_orevein/proc/check_arrival()
	if(clusters_spawned || complete || expired)
		return
	var/obj/effect/landmark/quest_spawner/landmark = wreck_landmark_ref?.resolve()
	if(QDELETED(landmark))
		return
	var/turf/landmark_turf = get_turf(landmark)
	var/mob/living/miner = quest_giver_reference?.resolve()
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	if(!bearer_arrived)
		if(bearer && bearer.stat != DEAD && mob_in_strike_range(bearer, landmark_turf))
			bearer_arrived = TRUE
			expiry_at = world.time + TOWNER_OREVEIN_EXPIRY_DS
			expiry_timer_id = addtimer(CALLBACK(src, PROC_REF(on_expiry)), TOWNER_OREVEIN_EXPIRY_DS, TIMER_STOPPABLE)
		else if(bearer && !warned_bearer_return)
			warned_bearer_return = TRUE
			to_chat(bearer, span_warning("<b>You must reach the vein itself before it will open. Return to it.</b>"))
	if(miner && miner.stat != DEAD && mob_in_strike_range(miner, landmark_turf))
		erupt(landmark)
		return
	if(bearer_arrived && !announced_waiting_miner && bearer)
		announced_waiting_miner = TRUE
		to_chat(bearer, span_notice("<b>The vein will not open until [quest_giver_name] reaches it.</b>"))
	addtimer(CALLBACK(src, PROC_REF(check_arrival)), TOWNER_PRESENCE_POLL_INTERVAL)

/datum/quest/kill/towner_miner_orevein/proc/mob_in_strike_range(mob/M, turf/landmark_turf)
	var/turf/T = get_turf(M)
	if(!T || !landmark_turf)
		return FALSE
	if(T.z != landmark_turf.z)
		return FALSE
	return get_dist(T, landmark_turf) <= TOWNER_PRESENCE_RADIUS

/datum/quest/kill/towner_miner_orevein/proc/erupt(obj/effect/landmark/quest_spawner/landmark)
	if(clusters_spawned)
		return
	clusters_spawned = TRUE
	if(!expiry_at)
		expiry_at = world.time + TOWNER_OREVEIN_EXPIRY_DS
		expiry_timer_id = addtimer(CALLBACK(src, PROC_REF(on_expiry)), TOWNER_OREVEIN_EXPIRY_DS, TIMER_STOPPABLE)
	var/mob/bearer = quest_receiver_reference?.resolve()
	var/mob/miner = quest_giver_reference?.resolve()
	if(bearer)
		to_chat(bearer, span_danger("<b>The earth trembles - elementals pour forth, and a vein splits the rock!</b>"))
	if(miner)
		to_chat(miner, span_danger("<b>The earth trembles - Strike while the elementals fall!</b>"))
	spawn_kill_mobs(landmark)
	spawn_clusters(landmark)
	progress_required = clusters_total
	if(quest_scroll)
		quest_scroll.update_quest_text()

/datum/quest/kill/towner_miner_orevein/proc/spawn_clusters(obj/effect/landmark/quest_spawner/landmark)
	clusters_total = (posting_tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_OREVEIN_CLUSTER_COUNT_HARD : TOWNER_OREVEIN_CLUSTER_COUNT_MEDIUM
	clusters_remaining = clusters_total
	for(var/i in 1 to clusters_total)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/turf/closed/mineral/quest_vein/vein = spawn_turf.ChangeTurf(/turf/closed/mineral/quest_vein)
		if(!istype(vein))
			continue
		vein.quest_ref = WEAKREF(src)
		vein.yield_paths = build_cluster_yield()
		spawned_cluster_refs += WEAKREF(vein)

/datum/quest/kill/towner_miner_orevein/proc/build_cluster_yield()
	var/list/yield = list()
	if(posting_tier == TOWNER_POSTING_TIER_HARD)
		yield[/obj/item/rogueore/cinnabar] = 1
		yield[/obj/item/rogueore/iron] = rand(2, 3)
		var/flavor = rand(1, 3)
		if(flavor == 1)
			yield[/obj/item/rogueore/gold] = 1
		else if(flavor == 2)
			var/gem_path = pick(GLOB.towner_orevein_gem_types)
			yield[gem_path] = 1
		else
			yield[/obj/item/rogueore/iron] = (yield[/obj/item/rogueore/iron] || 0) + rand(3, 5)
			if(prob(50))
				yield[/obj/item/rogueore/cinnabar] = (yield[/obj/item/rogueore/cinnabar] || 0) + 1
		return yield
	yield[/obj/item/rogueore/iron] = rand(4, 6)
	yield[/obj/item/rogueore/coal] = rand(2, 3)
	if(prob(40))
		yield[/obj/item/rogueore/gold] = 1
	return yield

/datum/quest/kill/towner_miner_orevein/proc/on_cluster_mined(turf/closed/mineral/quest_vein/vein)
	for(var/datum/weakref/W in spawned_cluster_refs)
		if(W.resolve() == vein)
			spawned_cluster_refs -= W
			break
	clusters_remaining = max(0, clusters_remaining - 1)
	progress_current = clusters_total - clusters_remaining
	on_progress_update()
	if(quest_scroll)
		quest_scroll.update_quest_text()

/datum/quest/kill/towner_miner_orevein/proc/on_expiry()
	expiry_timer_id = null
	if(complete || expired)
		return
	expired = TRUE
	despawn_remaining_clusters()
	var/mob/bearer = quest_receiver_reference?.resolve()
	if(bearer)
		to_chat(bearer, span_danger("<b>The vein closes itself over. The earth has reclaimed what was hers.</b>"))
	var/mob/miner = quest_giver_reference?.resolve()
	if(miner)
		to_chat(miner, span_danger("<b>The vein has closed. The earth has reclaimed what was hers.</b>"))
		var/datum/fund/miner_account = SStreasury.get_account(miner)
		if(miner_account && !clusters_spawned)
			var/refund = (posting_tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_POSTING_COST_HARD : TOWNER_POSTING_COST_MEDIUM
			SStreasury.transfer(SStreasury.discretionary_fund, miner_account, refund, "towner orevein expiry refund")
			to_chat(miner, span_notice("Your [refund] mammon posting fee has been returned."))
	if(quest_scroll)
		quest_scroll.update_quest_text()

/datum/quest/kill/towner_miner_orevein/proc/despawn_remaining_clusters()
	for(var/datum/weakref/W in spawned_cluster_refs)
		var/turf/closed/mineral/quest_vein/V = W.resolve()
		if(V && !QDELETED(V))
			V.ScrapeAway()
	spawned_cluster_refs.Cut()

/datum/quest/kill/towner_miner_orevein/populate_scroll_ui_data(list/data)
	..()
	data["orevein_clusters_total"] = clusters_total
	data["orevein_clusters_remaining"] = clusters_remaining
	data["orevein_clusters_spawned"] = clusters_spawned
	data["orevein_expired"] = expired
	data["orevein_bearer_arrived"] = bearer_arrived
	if(expiry_at && !expired && !complete)
		data["orevein_expiry_seconds"] = max(0, round((expiry_at - world.time) / 10))
	else
		data["orevein_expiry_seconds"] = 0

/datum/quest/kill/towner_miner_orevein/Destroy()
	if(expiry_timer_id)
		deltimer(expiry_timer_id)
		expiry_timer_id = null
	despawn_remaining_clusters()
	return ..()

/datum/quest/kill/towner_miner_orevein/proc/on_turn_in_pay_giver(mob/bearer, turf/ledger_turf)
	return
