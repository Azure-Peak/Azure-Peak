/datum/quest
	var/title = ""
	var/datum/weakref/quest_giver_reference
	var/quest_giver_name = ""
	var/datum/weakref/quest_receiver_reference
	var/quest_receiver_name = ""
	var/quest_type = ""
	var/quest_difficulty = ""
	var/reward_amount = 0
	var/deposit_amount = 0
	var/complete = FALSE

	var/source = QUEST_SOURCE_HANDLER
	var/created_at = 0
	var/issued_day = 0

	var/progress_current = 0
	var/progress_required = 1

	var/obj/item/target_item_type
	var/obj/item/target_delivery_item
	var/mob/living/target_mob_type
	var/area/rogue/indoors/town/target_delivery_location
	var/target_spawn_area = ""

	var/quest_icon = "scroll_quest"

	var/obj/item/quest_writ/quest_scroll
	var/datum/weakref/quest_scroll_ref
	var/list/datum/weakref/tracked_atoms = list()
	var/datum/weakref/pending_landmark_ref
	var/materialized = FALSE
	var/region = ""
	var/faction_id
	var/datum/quest_faction/faction
	var/required_fellowship_size = 0
	var/levy_exempt = FALSE
	var/guild_cut_exempt = FALSE
	var/is_directive = FALSE
	var/list/datum/weakref/spawners = list()
	var/list/rolled_crimes
	var/sacral_hook = FALSE
	var/oath_breach = FALSE
	var/condemnation_variant = ""
	var/band_leader_name = ""
	var/writ_type = WRIT_TYPE_OUTLAWRY
	var/circumstance_text = ""

/datum/quest/proc/get_lapse_time()
	var/window = (source == QUEST_SOURCE_POOL) ? QUEST_POOL_STALE_THRESHOLD : QUEST_PLAYER_STALE_THRESHOLD
	return created_at + window

/datum/quest/Destroy()
	var/obj/effect/landmark/quest_spawner/held_landmark = pending_landmark_ref?.resolve()
	if(held_landmark)
		if(held_landmark.claimed_by?.resolve() == src)
			held_landmark.claimed_by = null
		if(materialized)
			held_landmark.cooldown_until = world.time + QUEST_LANDMARK_COOLDOWN

	for(var/datum/weakref/tracked_weakref in tracked_atoms)
		var/atom/target_atom = tracked_weakref.resolve()
		if(!QDELETED(target_atom))
			if(ismob(target_atom))
				var/mob/M = target_atom
				var/datum/component/quest_object/Q = M.GetComponent(/datum/component/quest_object)
				if(Q && Q.quest_ref?.resolve() == src)
					M.remove_filter("quest_item_outline")
					qdel(Q)
			else if(!complete && target_item_type && quest_type == QUEST_RETRIEVAL && istype(target_atom, target_item_type))
				qdel(target_atom)
			else if(!complete && target_delivery_item && quest_type == QUEST_COURIER && istype(target_atom, target_delivery_item))
				qdel(target_atom)
	tracked_atoms.Cut()

	// Clean up references
	quest_scroll = null
	if(quest_scroll_ref)
		var/obj/item/quest_writ/Q = quest_scroll_ref.resolve()
		if(Q && !QDELETED(Q))
			Q.assigned_quest = null
			qdel(Q)
		quest_scroll_ref = null
		
	return ..()

/datum/quest/proc/add_tracked_atom(atom/movable/to_track)
	tracked_atoms += WEAKREF(to_track)

/datum/quest/proc/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region
	return TRUE

/datum/quest/proc/finalize_preview_title()
	if(!title)
		title = get_title()
	if(!rolled_crimes && faction)
		faction.compose_preamble(src)
	if(!circumstance_text)
		circumstance_text = roll_circumstance()

/datum/quest/proc/roll_circumstance()
	switch(writ_type)
		if(WRIT_TYPE_RECOVERY)
			return pick_recovery_circumstance()
		if(WRIT_TYPE_CARRIAGE)
			return pick_carriage_circumstance()
	return ""

/datum/quest/proc/get_named_target()
	return null

/datum/quest/proc/get_recovery_shipment_name()
	return null

/datum/quest/proc/register_spawner(obj/effect/quest_spawn/spawner)
	spawners += WEAKREF(spawner)

/datum/quest/proc/pop_all_spawners()
	if(length(spawners))
		on_first_pop()
	for(var/datum/weakref/ref in spawners)
		var/obj/effect/quest_spawn/spawner = ref.resolve()
		if(QDELETED(spawner) || !spawner.contained_atom)
			continue
		spawner.reveal_contained()
	spawners.Cut()

/datum/quest/proc/on_first_pop()
	return

/datum/quest/proc/materialize(obj/effect/landmark/quest_spawner/landmark)
	return TRUE

/datum/quest/proc/get_title()
	return title

/datum/quest/proc/get_objective_text()
	return "Complete the objective."

/datum/quest/proc/populate_scroll_ui_data(list/data)
	return

/datum/quest/proc/populate_scroll_ui_static_data(list/data)
	return

/datum/quest/proc/check_completion()
	return progress_current >= progress_required

/datum/quest/proc/on_progress_update()
	if(check_completion())
		mark_complete()

/datum/quest/proc/mark_complete()
	complete = TRUE
	quest_scroll?.update_quest_text()

/datum/quest/proc/get_base_reward()
	return QUEST_REWARD_BASE_FLAT

/datum/quest/proc/get_additional_reward(turf/origin_turf, turf/target_turf)
	return 0

/datum/quest/proc/calculate_reward(turf/origin_turf, turf/target_turf)
	var/base = get_base_reward()
	var/additional = get_additional_reward(origin_turf, target_turf)
	var/payout_mult = QUEST_REWARD_GLOBAL_MULT
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(TR)
		payout_mult *= TR.payout_multiplier
	return round((base + additional + get_difficulty_bonus()) * payout_mult)

/datum/quest/proc/get_difficulty_bonus()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_MEDIUM)
			return QUEST_DIFFICULTY_BONUS_MEDIUM
		if(QUEST_DIFFICULTY_HARD)
			return QUEST_DIFFICULTY_BONUS_HARD
	return QUEST_DIFFICULTY_BONUS_EASY

/datum/quest/proc/calculate_deposit()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return QUEST_DEPOSIT_EASY
		if(QUEST_DIFFICULTY_MEDIUM)
			return QUEST_DEPOSIT_MEDIUM
		if(QUEST_DIFFICULTY_HARD)
			return QUEST_DEPOSIT_HARD
	return 0

/datum/quest/proc/get_scroll_type()
	return /obj/item/quest_writ

/datum/quest/proc/get_scroll_icon()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return "scroll_quest_low"
		if(QUEST_DIFFICULTY_MEDIUM)
			return "scroll_quest_mid"
		if(QUEST_DIFFICULTY_HARD)
			return "scroll_quest_high"
	return quest_icon

/datum/quest/proc/get_target_location()
	var/turf/user_turf = quest_scroll ? get_turf(quest_scroll) : null
	if(!user_turf)
		return null

	var/turf/closest
	var/min_dist = INFINITY

	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/A = ref.resolve()
		if(!A || QDELETED(A))
			continue

		if(isliving(A))
			var/mob/living/L = A
			if(L.stat == DEAD)
				continue

		var/turf/A_turf = get_turf(A)
		if(!A_turf)
			continue

		var/dist = get_dist(user_turf, A_turf)
		if(dist < min_dist)
			min_dist = dist
			closest = A_turf

	return closest

/datum/quest/proc/can_claim(mob/living/user)
	if(required_fellowship_size > 0)
		var/datum/fellowship/F = user?.current_fellowship
		if(!F)
			return FALSE
		if(length(F.get_members()) < required_fellowship_size)
			return FALSE
	return TRUE

/datum/quest/proc/claim_failure_reason(mob/living/user)
	if(required_fellowship_size > 0)
		var/datum/fellowship/F = user?.current_fellowship
		if(!F)
			return "This contract requires a Fellowship of [required_fellowship_size]."
		if(length(F.get_members()) < required_fellowship_size)
			return "Your Fellowship is too small - requires [required_fellowship_size] members."
	return "You cannot sign that contract."

/datum/quest/proc/on_claim(mob/user)
	quest_receiver_reference = WEAKREF(user)
	quest_receiver_name = user.real_name
