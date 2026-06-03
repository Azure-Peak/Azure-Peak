GLOBAL_LIST_INIT(towner_smith_caravan_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_smith_caravan_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_MOUNT_REAVER,
	QUEST_FACTION_BLEAKISLE_REAVER,
))

GLOBAL_LIST_INIT(towner_smith_caravan_bundle_ranges, list(
	TOWNER_POSTING_TIER_MEDIUM = list(
		"iron" = list(4, 6),
		"bronze" = list(2, 4),
		"steel" = list(1, 3),
	),
	TOWNER_POSTING_TIER_HARD = list(
		"iron" = list(8, 12),
		"bronze" = list(4, 6),
		"steel" = list(4, 6),
	),
))

/datum/quest/kill/recovery/towner_smith_caravan
	quest_type = QUEST_TOWNER_SMITH_CARAVAN
	quest_difficulty = QUEST_DIFFICULTY_HARD
	required_fellowship_size = TOWNER_QUEST_FELLOWSHIP_SIZE
	levy_exempt = TRUE
	guild_cut_exempt = TRUE
	var/posting_tier = TOWNER_POSTING_TIER_HARD
	var/datum/weakref/wreck_landmark_ref
	var/parcel_spawned = FALSE
	var/presence_announced = FALSE
	var/expiry_at = 0
	var/expiry_timer_id = null
	var/expired = FALSE
	var/bearer_arrived = FALSE
	var/warned_bearer_return = FALSE
	var/announced_waiting_smith = FALSE

/datum/quest/kill/recovery/towner_smith_caravan/calculate_deposit()
	return 0

/datum/quest/kill/recovery/towner_smith_caravan/can_claim(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	return towner_can_claim_check(src, user)

/datum/quest/kill/recovery/towner_smith_caravan/claim_failure_reason(mob/living/user)
	var/towner_reason = towner_claim_failure_reason(src, user)
	if(towner_reason)
		return towner_reason
	return ..()

/datum/quest/kill/recovery/towner_smith_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Gone Missing"

/datum/quest/kill/recovery/towner_smith_caravan/get_objective_text()
	return "Escort the smith to the wreck and deliver the recovered parcel to the Guildhall."

/datum/quest/kill/recovery/towner_smith_caravan/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		if(!(id in GLOB.towner_smith_caravan_factions))
			continue
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/datum/quest/kill/recovery/towner_smith_caravan/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!(landmark.region in GLOB.towner_smith_caravan_regions))
		return FALSE
	override_destination = /area/rogue/indoors/town/dwarfin
	tp_budget = (posting_tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_CARAVAN_TP_BUDGET_HARD : TOWNER_CARAVAN_TP_BUDGET_MEDIUM
	. = ..()
	if(!.)
		return FALSE
	shipment_name = "recovered ingots"
	return TRUE

/datum/quest/kill/recovery/towner_smith_caravan/get_additional_reward(turf/origin_turf, turf/target_turf)
	var/base = ..()
	base += (posting_tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_CARAVAN_FLAT_BONUS_HARD : TOWNER_CARAVAN_FLAT_BONUS_MEDIUM
	return base

/datum/quest/kill/recovery/towner_smith_caravan/on_claim(mob/user)
	. = ..()
	to_chat(user, span_warning("The strongbox stays buried until [quest_giver_name] reaches the wreck themselves. The [TOWNER_CARAVAN_EXPIRY_DS / 600]-minute clock starts when you first reach the wreck."))

/datum/quest/kill/recovery/towner_smith_caravan/proc/on_expiry()
	expiry_timer_id = null
	if(parcel_spawned || complete || expired)
		return
	expired = TRUE
	var/mob/bearer = quest_receiver_reference?.resolve()
	if(bearer)
		to_chat(bearer, span_danger("<b>The trail has gone cold. The smith never came; the wreck's secrets are lost.</b>"))
	var/mob/smith = quest_giver_reference?.resolve()
	if(smith)
		to_chat(smith, span_danger("<b>You were too slow. The wreck has been picked clean.</b>"))
		var/datum/fund/smith_account = SStreasury.get_account(smith)
		if(smith_account)
			var/refund = (posting_tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_POSTING_COST_HARD : TOWNER_POSTING_COST_MEDIUM
			SStreasury.transfer(SStreasury.discretionary_fund, smith_account, refund, "towner caravan expiry refund")
			to_chat(smith, span_notice("Your [refund] mammon posting fee has been returned."))
	if(quest_scroll)
		quest_scroll.update_quest_text()

/datum/quest/kill/recovery/towner_smith_caravan/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	wreck_landmark_ref = WEAKREF(landmark)
	addtimer(CALLBACK(src, PROC_REF(check_smith_presence)), TOWNER_PRESENCE_POLL_INTERVAL)

/datum/quest/kill/recovery/towner_smith_caravan/get_target_location()
	if(!parcel_spawned)
		var/obj/effect/landmark/quest_spawner/landmark = wreck_landmark_ref?.resolve()
		if(landmark)
			return get_turf(landmark)
	return ..()

/datum/quest/kill/recovery/towner_smith_caravan/proc/check_smith_presence()
	if(parcel_spawned || complete || expired)
		return
	var/obj/effect/landmark/quest_spawner/landmark = wreck_landmark_ref?.resolve()
	if(QDELETED(landmark))
		return
	var/turf/landmark_turf = get_turf(landmark)
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	if(!bearer_arrived)
		if(bearer && bearer.stat != DEAD && mob_in_wreck_range(bearer, landmark_turf))
			arm_expiry_timer()
		else if(bearer && !warned_bearer_return)
			warned_bearer_return = TRUE
			to_chat(bearer, span_warning("<b>You must reach the wreck itself before the trail can be picked up. Return to it.</b>"))
	var/mob/living/smith = quest_giver_reference?.resolve()
	if(smith && smith.stat != DEAD && mob_in_wreck_range(smith, landmark_turf))
		do_spawn_parcel(landmark)
		return
	if(bearer_arrived && !announced_waiting_smith && bearer)
		announced_waiting_smith = TRUE
		to_chat(bearer, span_notice("<b>The wreck is secure. The strongbox stays buried until [quest_giver_name] reaches it.</b>"))
	addtimer(CALLBACK(src, PROC_REF(check_smith_presence)), TOWNER_PRESENCE_POLL_INTERVAL)

/datum/quest/kill/recovery/towner_smith_caravan/proc/mob_in_wreck_range(mob/M, turf/landmark_turf)
	var/turf/T = get_turf(M)
	if(!T || !landmark_turf)
		return FALSE
	if(T.z != landmark_turf.z)
		return FALSE
	return get_dist(T, landmark_turf) <= TOWNER_PRESENCE_RADIUS

/datum/quest/kill/recovery/towner_smith_caravan/proc/arm_expiry_timer()
	if(bearer_arrived)
		return
	bearer_arrived = TRUE
	expiry_at = world.time + TOWNER_CARAVAN_EXPIRY_DS
	expiry_timer_id = addtimer(CALLBACK(src, PROC_REF(on_expiry)), TOWNER_CARAVAN_EXPIRY_DS, TIMER_STOPPABLE)
	var/mob/bearer = quest_receiver_reference?.resolve()
	if(bearer)
		to_chat(bearer, span_warning("<b>You have reached the wreck. [TOWNER_CARAVAN_EXPIRY_DS / 600] minutes before the trail goes cold.</b>"))
	var/mob/smith = quest_giver_reference?.resolve()
	if(smith)
		to_chat(smith, span_warning("<b>The fellowship has reached your wreck. You have [TOWNER_CARAVAN_EXPIRY_DS / 600] minutes to get there yourself.</b>"))
	if(quest_scroll)
		quest_scroll.update_quest_text()

/datum/quest/kill/recovery/towner_smith_caravan/proc/do_spawn_parcel(obj/effect/landmark/quest_spawner/landmark)
	if(parcel_spawned)
		return
	parcel_spawned = TRUE
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return
	var/obj/item/parcel/towner_caravan/recovered = new(spawn_turf)
	var/list/bundle = build_ingot_bundle()
	for(var/path in bundle)
		var/count = bundle[path]
		for(var/i in 1 to count)
			var/obj/item/I = new path(recovered)
			recovered.contained_items += I
	recovered.delivery_area_type = target_delivery_location
	recovered.allowed_jobs = recovered.get_area_jobs(target_delivery_location)
	recovered.unlocked_by_owner_ref = quest_giver_reference
	recovered.owner_name = quest_giver_name
	recovered.name = "[quest_giver_name]'s recovered caravan"
	recovered.desc = "A sealed strongbox of ingots wrested back from the bandits. Marked for [quest_giver_name] - only they can crack the seal, and only while they yet live."
	recovered.icon_state = "ration_large"
	recovered.dropshrink = 1
	recovered.update_icon()
	recovered.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(recovered)
	announce_strongbox_uncovered()

/datum/quest/kill/recovery/towner_smith_caravan/proc/announce_strongbox_uncovered()
	if(presence_announced)
		return
	presence_announced = TRUE
	var/mob/bearer = quest_receiver_reference?.resolve()
	if(bearer)
		to_chat(bearer, span_notice("<b>The smith's arrival uncovers the strongbox - it is here, at the wreck.</b>"))
	var/mob/smith = quest_giver_reference?.resolve()
	if(smith)
		to_chat(smith, span_notice("<b>You find your strongbox in the wreckage. Get it home.</b>"))

/datum/quest/kill/recovery/towner_smith_caravan/populate_scroll_ui_data(list/data)
	..()
	data["caravan_parcel_spawned"] = parcel_spawned
	data["caravan_expired"] = expired
	data["caravan_bearer_arrived"] = bearer_arrived
	if(expiry_at && !parcel_spawned && !expired)
		data["caravan_expiry_seconds"] = max(0, round((expiry_at - world.time) / 10))
	else
		data["caravan_expiry_seconds"] = 0

/datum/quest/kill/recovery/towner_smith_caravan/Destroy()
	if(expiry_timer_id)
		deltimer(expiry_timer_id)
		expiry_timer_id = null
	return ..()

/datum/quest/kill/recovery/towner_smith_caravan/proc/build_ingot_bundle()
	var/list/ranges = GLOB.towner_smith_caravan_bundle_ranges[posting_tier] || GLOB.towner_smith_caravan_bundle_ranges[TOWNER_POSTING_TIER_MEDIUM]
	var/list/bundle = list()
	bundle[/obj/item/ingot/iron] = rand(ranges["iron"][1], ranges["iron"][2])
	bundle[/obj/item/ingot/bronze] = rand(ranges["bronze"][1], ranges["bronze"][2])
	bundle[/obj/item/ingot/steel] = rand(ranges["steel"][1], ranges["steel"][2])
	return bundle

/datum/quest/kill/recovery/towner_smith_caravan/proc/on_turn_in_pay_giver(mob/bearer, turf/ledger_turf)
	return
