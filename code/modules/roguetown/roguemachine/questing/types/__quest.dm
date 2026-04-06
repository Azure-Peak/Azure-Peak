/datum/quest
	var/title = ""
	var/datum/weakref/quest_giver_reference
	var/quest_giver_name = ""
	var/datum/weakref/quest_receiver_reference
	var/quest_receiver_name = ""
	var/quest_type = ""
	var/contract_group = QUEST_GROUP_ERRANDS
	var/requested_tier = QUEST_TIER_ROUTINE
	var/threat_tier = QUEST_TIER_ROUTINE
	var/minimum_tier = QUEST_TIER_ROUTINE
	var/maximum_tier = QUEST_TIER_MYTHIC
	var/base_reward_value = 0
	var/reward_amount = 0
	var/deposit_amount = 0
	var/complete = FALSE
	var/being_destroyed = FALSE

	/// Progress tracking
	var/progress_current = 0
	var/progress_required = 1

	/// Target item type for fetch quests
	var/obj/item/target_item_type
	/// Target item type for courier quests
	var/obj/item/target_delivery_item
	/// Target mob type for kill quests
	var/mob/target_mob_type
	/// Location for courier quests
	var/area/rogue/indoors/town/target_delivery_location
	/// Location name for kill/clear quests
	var/target_spawn_area = ""
	/// Stable anchor coordinates for resolving the quest's map context.
	var/target_anchor_x = 0
	var/target_anchor_y = 0
	var/target_anchor_z = 0

	/// Distance bonus multiplier (0.0 to QUEST_DISTANCE_BONUS_MAX_MULT), calculated once at quest creation
	var/distance_bonus_mult = 0
	/// Map reward modifier from quest_map_config, set once at generation
	var/map_reward_modifier = 1.0
	/// Map difficulty modifier from quest_map_config, set once at generation
	var/map_difficulty_modifier = 1.0

	/// Scroll icon state
	var/quest_icon = "scroll_quest"

	/// Fallback reference to the spawned scroll
	var/obj/item/paper/scroll/quest/quest_scroll
	/// Weak reference to the quest scroll
	var/datum/weakref/quest_scroll_ref
	/// List of weakrefs to actual quest items/mobs for reducing overhead of compass.
	var/list/datum/weakref/tracked_atoms = list()

/datum/quest/Destroy()
	being_destroyed = TRUE

	// Clean up mobs with quest components
	for(var/mob/living/M in GLOB.mob_list)
		var/datum/component/quest_object/Q = M.GetComponent(/datum/component/quest_object)
		if(Q && Q.quest_ref?.resolve() == src)
			M.remove_filter("quest_item_outline")
			qdel(Q)

	for(var/datum/weakref/tracked_weakref in tracked_atoms)
		var/atom/target_atom = tracked_weakref.resolve()
		if(QDELETED(target_atom))
			continue

		if(!complete)
			if(ismob(target_atom))
				qdel(target_atom)
			else if(quest_type == QUEST_RETRIEVAL && istype(target_atom, target_item_type))
				qdel(target_atom)
			else if(quest_type == QUEST_COURIER && (istype(target_atom, /obj/item/parcel) || (target_delivery_item && istype(target_atom, target_delivery_item))))
				qdel(target_atom)

		tracked_atoms -= tracked_weakref
		qdel(tracked_weakref)

	// Clean up references
	quest_scroll = null
	if(quest_scroll_ref)
		var/obj/item/paper/scroll/quest/Q = quest_scroll_ref.resolve()
		if(Q && !QDELETED(Q))
			Q.assigned_quest = null
			qdel(Q)
		quest_scroll_ref = null

	return ..()

/datum/quest/proc/add_tracked_atom(atom/movable/to_track)
	tracked_atoms += WEAKREF(to_track)

/datum/quest/proc/remove_tracked_atom(atom/movable/to_untrack)
	if(!to_untrack)
		return FALSE

	for(var/datum/weakref/tracked_ref in tracked_atoms.Copy())
		if(tracked_ref.resolve() != to_untrack)
			continue

		tracked_atoms -= tracked_ref
		qdel(tracked_ref)
		return TRUE

	return FALSE

/datum/quest/proc/set_target_anchor(atom/source)
	var/turf/anchor_turf = get_turf(source)
	if(!anchor_turf)
		return FALSE

	target_anchor_x = anchor_turf.x
	target_anchor_y = anchor_turf.y
	target_anchor_z = anchor_turf.z
	return TRUE

/datum/quest/proc/get_target_anchor_turf()
	if(!target_anchor_x || !target_anchor_y || !target_anchor_z)
		return null

	return locate(target_anchor_x, target_anchor_y, target_anchor_z)

/datum/quest/proc/get_additional_reward(target_turf)
	return 0

/datum/quest/proc/get_map_file_for_turf(turf/target_turf)
	if(!target_turf)
		return null

	var/map_file = SSmapping.level_trait(target_turf.z, ZTRAIT_MAP_FILE)
	if(!map_file)
		return null

	return lowertext("[map_file]")

/datum/quest/proc/get_nearest_tracked_atom(turf/reference_turf, include_held_items = TRUE, atom/movable/preferred_atom = null)
	var/turf/origin_turf = reference_turf ? get_turf(reference_turf) : (quest_scroll ? get_turf(quest_scroll) : null)
	if(!origin_turf)
		return null

	var/atom/movable/closest
	var/min_dist = INFINITY
	var/list/stale_refs = list()

	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/movable/A = ref.resolve()
		if(!A || QDELETED(A))
			stale_refs += ref
			continue

		if(ismob(A))
			var/mob/living/tracked_mob = A
			if(tracked_mob.stat == DEAD)
				stale_refs += ref
				continue
		else if(isitem(A) && !include_held_items)
			if(recursive_loc_check(A, /mob/living))
				continue

		var/turf/A_turf = get_turf(A)
		if(!A_turf)
			stale_refs += ref
			continue

		if(preferred_atom && A == preferred_atom)
			for(var/datum/weakref/stale_ref in stale_refs)
				tracked_atoms -= stale_ref
				qdel(stale_ref)
			return A

		var/score = get_map_distance_score(origin_turf, A_turf)
		if(score < min_dist)
			min_dist = score
			closest = A

	for(var/datum/weakref/stale_ref in stale_refs)
		tracked_atoms -= stale_ref
		qdel(stale_ref)

	return closest

/datum/quest/proc/get_nearest_tracked_location(turf/reference_turf, include_held_items = TRUE, atom/movable/preferred_atom = null)
	var/atom/movable/closest_atom = get_nearest_tracked_atom(reference_turf, include_held_items, preferred_atom)
	return get_turf(closest_atom)

/datum/quest/proc/resolve_compass_focus_target(turf/reference_turf, atom/movable/preferred_atom = null)
	return get_nearest_tracked_atom(reference_turf, TRUE, preferred_atom)

/datum/quest/proc/has_tracked_item_in_inventory()
	var/list/stale_refs = list()

	for(var/datum/weakref/ref in tracked_atoms)
		var/obj/item/tracked_item = ref.resolve()
		if(!tracked_item || QDELETED(tracked_item))
			stale_refs += ref
			continue

		if(recursive_loc_check(tracked_item, /mob/living))
			for(var/datum/weakref/stale_ref in stale_refs)
				tracked_atoms -= stale_ref
				qdel(stale_ref)
			return TRUE

	for(var/datum/weakref/stale_ref in stale_refs)
		tracked_atoms -= stale_ref
		qdel(stale_ref)

	return FALSE

/datum/quest/proc/resolve_target_area(target_area_or_type)
	if(isarea(target_area_or_type))
		return target_area_or_type
	if(ispath(target_area_or_type, /area))
		return GLOB.areas_by_type[target_area_or_type]
	return null

/datum/quest/proc/get_area_target_turf(target_area_or_type, turf/reference_turf)
	var/area/target_area = resolve_target_area(target_area_or_type)
	if(!target_area)
		return null

	var/turf/origin_turf = reference_turf ? get_turf(reference_turf) : null
	var/origin_map_file = get_map_file_for_turf(origin_turf)
	var/turf/fallback_turf = null

	for(var/turf/area_turf in target_area)
		if(!fallback_turf)
			fallback_turf = area_turf
		if(origin_map_file && get_map_file_for_turf(area_turf) == origin_map_file)
			return area_turf

	return fallback_turf

/datum/quest/proc/get_turn_in_target_turf(turf/reference_turf)
	var/turf/origin_turf = reference_turf ? get_turf(reference_turf) : (quest_scroll ? get_turf(quest_scroll) : null)
	var/turf/best_turf
	var/best_score = INFINITY

	for(var/obj/effect/decal/marker_export/marker in world)
		var/turf/marker_turf = get_turf(marker)
		if(!marker_turf)
			continue

		if(!origin_turf)
			return marker_turf

		var/score = get_map_distance_score(origin_turf, marker_turf)
		if(score < best_score)
			best_score = score
			best_turf = marker_turf

	return best_turf

/datum/quest/proc/get_map_distance_score(turf/origin_turf, turf/target_turf)
	if(!origin_turf || !target_turf)
		return INFINITY

	var/origin_map_file = get_map_file_for_turf(origin_turf)
	var/target_map_file = get_map_file_for_turf(target_turf)
	var/distance = get_dist(origin_turf, target_turf)
	if(origin_map_file && target_map_file && origin_map_file != target_map_file)
		return 1000 + distance

	return distance

/datum/quest/proc/should_use_live_target_location(turf/live_target_turf)
	if(!live_target_turf)
		return FALSE

	var/turf/anchor_turf = get_target_anchor_turf()
	if(!anchor_turf)
		return TRUE

	var/anchor_map_file = get_map_file_for_turf(anchor_turf)
	if(!anchor_map_file)
		return TRUE

	var/live_map_file = get_map_file_for_turf(live_target_turf)
	if(!live_map_file)
		return FALSE

	return live_map_file == anchor_map_file

/datum/quest/proc/get_anchor_safe_target_location(turf/reference_turf, turf/live_target_turf)
	if(should_use_live_target_location(live_target_turf))
		return live_target_turf

	return get_target_anchor_turf() || live_target_turf

/datum/quest/proc/get_target_map_anchor(turf/reference_turf)
	return get_target_anchor_turf() || get_target_location(reference_turf)

/datum/quest/proc/get_supported_map_name(map_file)
	if(!map_file)
		return null

	var/static/list/supported_map_names = list(
		"bogforest.dmm" = "Bog Forest",
		"desert.dmm" = "Desert",
		"frozen_mountains.dmm" = "Frozen Mountains",
		"hsector.dmm" = "Rivermist City",
		"hsector_snow.dmm" = "Rivermist City (Winter)",
		"underdark.dmm" = "Underdark",
	)

	return supported_map_names[lowertext("[map_file]")]

/datum/quest/proc/is_supported_map_file(map_file)
	return get_supported_map_name(map_file) ? TRUE : FALSE

/datum/quest/proc/is_supported_map_turf(turf/target_turf)
	return is_supported_map_file(get_map_file_for_turf(target_turf))

/datum/quest/proc/is_supported_area_target(target_area_or_type, turf/reference_turf = null)
	return is_supported_map_turf(get_area_target_turf(target_area_or_type, reference_turf))

/datum/quest/proc/has_supported_spawn_landmark(contract_type = quest_type)
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.quest_landmarks_list)
		if(!landmark.supports_contract_type(contract_type))
			continue
		if(is_supported_map_turf(get_turf(landmark)))
			return TRUE
	return FALSE

/datum/quest/proc/get_target_map_text(turf/reference_turf)
	var/turf/map_anchor = get_target_map_anchor(reference_turf)
	if(!map_anchor)
		return "Error: target location could not be determined."

	var/map_file = get_map_file_for_turf(map_anchor)
	if(!map_file)
		return "Error: target is not on a supported quest map."

	var/map_name = get_supported_map_name(map_file)
	if(!map_name)
		return "Error: target is on an unsupported map ([map_file])."

	return map_name

/datum/quest/proc/find_portal_to_area(area/target_area, turf/from_turf)
	if(!target_area || !from_turf)
		return null

	var/obj/structure/fluff/traveltile/best
	var/best_dist = INFINITY
	var/source_map_file = get_map_file_for_turf(from_turf)

	for(var/obj/structure/fluff/traveltile/tile in GLOB.traveltiles)
		var/turf/tile_turf = get_turf(tile)
		if(!tile_turf)
			continue
		if(source_map_file && get_map_file_for_turf(tile_turf) != source_map_file)
			continue
		var/list/dest_turfs = tile.return_connected_turfs()
		var/leads_to_target = FALSE
		for(var/turf/dest_turf in dest_turfs)
			if(get_area(dest_turf) == target_area)
				leads_to_target = TRUE
				break
		if(!leads_to_target)
			continue

		var/distance = get_dist(from_turf, tile_turf)
		if(distance < best_dist)
			best_dist = distance
			best = tile

	return best

/datum/quest/proc/get_compass_signal_label(turf/reference_turf, using_live_target)
	return using_live_target ? "Live target signal" : "Quest spawner echo"

/datum/quest/proc/get_compass_signal_data(turf/reference_turf, atom/movable/preferred_target = null)
	var/list/signal_data = list(
		"compass_target" = null,
		"resolved_target" = null,
		"status_text" = "The signal cannot be resolved.",
	)
	if(!reference_turf)
		return signal_data

	var/atom/movable/live_target_atom = resolve_compass_focus_target(reference_turf, preferred_target)
	var/turf/live_target_turf = get_turf(live_target_atom)
	var/turf/resolved_target = get_target_location(reference_turf, preferred_target)
	var/using_live_target = resolved_target && live_target_turf && resolved_target == live_target_turf
	var/signal_label = get_compass_signal_label(reference_turf, using_live_target)
	var/reference_map_file = get_map_file_for_turf(reference_turf)
	var/resolved_map_file = get_map_file_for_turf(resolved_target)

	if(!resolved_target)
		signal_data["status_text"] = "[signal_label] unavailable."
		return signal_data

	signal_data["resolved_target"] = resolved_target
	signal_data["compass_target"] = resolved_target

	if(reference_map_file && resolved_map_file && resolved_map_file != reference_map_file)
		var/area/target_area = get_area(resolved_target)
		var/obj/structure/fluff/traveltile/portal = find_portal_to_area(target_area, reference_turf)
		if(portal)
			signal_data["compass_target"] = get_turf(portal)
			signal_data["status_text"] = "[signal_label] routed through a local gate."
			return signal_data

		signal_data["compass_target"] = null
		signal_data["status_text"] = "[signal_label] is on another map."
		return signal_data

	if(get_dist(reference_turf, resolved_target) <= 1)
		signal_data["status_text"] = "[signal_label] is very close."
	else
		signal_data["status_text"] = "[signal_label] is active."

	return signal_data

/datum/quest/proc/get_tier_label(tier = threat_tier)
	switch(tier)
		if(QUEST_TIER_ROUTINE)
			return "Tier I - Routine"
		if(QUEST_TIER_RISKY)
			return "Tier II - Risky"
		if(QUEST_TIER_DANGEROUS)
			return "Tier III - Dangerous"
		if(QUEST_TIER_DEADLY)
			return "Tier IV - Deadly"
		if(QUEST_TIER_LETHAL)
			return "Tier V - Lethal"
		if(QUEST_TIER_MYTHIC)
			return "Tier VI - Mythic"
	return "Tier ?"

/datum/quest/proc/get_tier_band_text()
	return "[get_tier_label(minimum_tier)] to [get_tier_label(maximum_tier)]"

/datum/quest/proc/get_tier_choices()
	var/list/choices = list()
	for(var/tier in minimum_tier to maximum_tier)
		choices[get_tier_label(tier)] = tier
	return choices

/datum/quest/proc/get_effective_requested_tier(obj/effect/landmark/quest_spawner/landmark)
	var/tier = requested_tier
	if(!tier && landmark)
		tier = landmark.get_default_contract_tier()
	if(!tier)
		tier = minimum_tier

	tier = clamp(tier, minimum_tier, maximum_tier)
	if(landmark)
		tier = clamp(tier, landmark.min_contract_tier, landmark.max_contract_tier)
	return tier

/// Generate quest content - override in subtypes
/datum/quest/proc/generate(obj/effect/landmark/quest_spawner/landmark)
	if(!title)
		title = get_title()
	if(landmark)
		set_target_anchor(landmark)
		requested_tier = get_effective_requested_tier(landmark)
		threat_tier = requested_tier
		apply_map_modifiers(get_turf(landmark))
	return TRUE

/// Apply map-specific difficulty and reward modifiers from quest_map_config
/datum/quest/proc/apply_map_modifiers(turf/landmark_turf)
	var/datum/quest_map_config/config = get_quest_map_config_for_turf(landmark_turf)
	if(!config)
		return
	map_reward_modifier = config.reward_modifier
	map_difficulty_modifier = config.difficulty_modifier

/// Calculate distance bonus multiplier based on distance from ledger to spawn point.
/// Measured once at quest creation. Independent of map modifiers.
/// distance_from_ledger: raw tile distance between contract ledger and quest landmark.
/datum/quest/proc/calculate_distance_bonus(distance_from_ledger)
	if(!distance_from_ledger || distance_from_ledger <= 0)
		distance_bonus_mult = 0
		return
	var/clamped = clamp(distance_from_ledger, 0, QUEST_DISTANCE_BONUS_MAX_RANGE)
	distance_bonus_mult = (clamped / QUEST_DISTANCE_BONUS_MAX_RANGE) * QUEST_DISTANCE_BONUS_MAX_MULT

/// Try to set up a quest ambush on one of the tracked quest mobs.
/// Chance scales with map difficulty: clamp(QUEST_AMBUSH_BASE_CHANCE * difficulty, MIN, MAX)
/// At difficulty 1.0 = 8%, 2.0 = 16%, 2.5 = 20%, 3.0 = 24% (capped at 25%).
/// One random quest mob gets a hidden ambush_config; on death it spawns ambush mobs.
/// Returns TRUE if an ambush was set up.
/datum/quest/proc/try_setup_quest_ambush(obj/effect/landmark/quest_spawner/landmark)
	var/turf/landmark_turf = get_turf(landmark)
	if(!landmark_turf)
		return FALSE

	var/datum/quest_map_config/config = get_quest_map_config_for_turf(landmark_turf)
	if(!config || !length(config.ambush_pools))
		return FALSE

	var/ambush_chance = clamp(ROUND_UP(QUEST_AMBUSH_BASE_CHANCE * config.difficulty_modifier), QUEST_AMBUSH_MIN_CHANCE, QUEST_AMBUSH_MAX_CHANCE)

	if(!prob(ambush_chance))
		return FALSE

	// Pick a random living tracked mob to carry the ambush
	var/list/candidate_mobs = list()
	for(var/datum/weakref/ref in tracked_atoms)
		var/mob/living/tracked_mob = ref.resolve()
		if(!tracked_mob || QDELETED(tracked_mob) || !ismob(tracked_mob))
			continue
		if(tracked_mob.stat == DEAD)
			continue
		candidate_mobs += tracked_mob

	if(!length(candidate_mobs))
		return FALSE

	var/mob/living/ambush_carrier = pick(candidate_mobs)
	var/ambush_config_type = pick(config.ambush_pools)
	ambush_carrier.AddComponent(/datum/component/quest_ambush_payload, ambush_config_type)
	return TRUE

/// Get the quest title - override in subtypes for dynamic titles
/datum/quest/proc/get_title()
	return title

/// Get objective text for scroll display
/datum/quest/proc/get_objective_text()
	return "Complete the objective."

/// Get location text for scroll display
/datum/quest/proc/get_location_text()
	return target_spawn_area ? "Reported sighting in [target_spawn_area] region." : "Location unknown."

/// Check if quest objectives are complete
/datum/quest/proc/check_completion()
	return progress_current >= progress_required

/// Called when progress is updated
/datum/quest/proc/on_progress_update()
	if(check_completion())
		mark_complete()
	else
		quest_scroll?.update_quest_text()

/// Mark quest as complete
/datum/quest/proc/mark_complete()
	complete = TRUE
	quest_scroll?.update_quest_text()

/// Base reward by contract type, without randomization.
/datum/quest/proc/get_base_reward()
	return base_reward_value

/datum/quest/proc/get_risk_score(turf/target_turf)
	return requested_tier

/datum/quest/proc/get_workload_reward(turf/target_turf)
	return 0

/datum/quest/proc/get_tier_from_risk_score(risk_score)
	if(risk_score <= 3)
		return QUEST_TIER_ROUTINE
	if(risk_score <= 5)
		return QUEST_TIER_RISKY
	if(risk_score <= 7)
		return QUEST_TIER_DANGEROUS
	if(risk_score <= 10)
		return QUEST_TIER_DEADLY
	if(risk_score <= 13)
		return QUEST_TIER_LETHAL
	return QUEST_TIER_MYTHIC

/// Calculate reward from base type value + concrete risk score + workload done.
/// Applies map reward modifier and distance bonus on top of base calculation.
/datum/quest/proc/calculate_reward(turf/target_turf)
	var/risk_score = max(1, ROUND_UP(get_risk_score(target_turf)))
	var/workload_reward = max(0, ROUND_UP(get_workload_reward(target_turf)))
	threat_tier = get_tier_from_risk_score(risk_score)
	var/base_total = get_base_reward() + (risk_score * QUEST_REWARD_PER_RISK_POINT) + workload_reward
	// Apply map reward modifier
	base_total *= map_reward_modifier
	// Apply distance bonus (up to QUEST_DISTANCE_BONUS_MAX_MULT extra)
	base_total *= (1 + distance_bonus_mult)
	return max(0, ROUND_UP(base_total))

/datum/quest/proc/calculate_deposit(reward_override)
	var/effective_tier = get_effective_requested_tier(null)
	// Lowest tier (Routine) quests are free
	if(effective_tier <= QUEST_TIER_ROUTINE)
		return 0
	// Deadly tier has a fixed deposit
	if(effective_tier == QUEST_TIER_DEADLY)
		return 50
	// Highest tiers (Lethal, Mythic) are free — issued by limited roles only
	if(effective_tier >= QUEST_TIER_LETHAL)
		return 0

	var/reward_reference = isnum(reward_override) ? reward_override : reward_amount
	if(reward_reference <= 0)
		reward_reference = get_base_reward() + (effective_tier * QUEST_REWARD_PER_RISK_POINT)
	var/deposit = clamp(ROUND_UP(max(QUEST_MIN_DEPOSIT, reward_reference * QUEST_DEPOSIT_RATE)), QUEST_MIN_DEPOSIT, QUEST_MAX_DEPOSIT)
	// Guarantee that low and mid tier quests always pay more than their deposit
	if(reward_reference > 0 && deposit >= reward_reference)
		deposit = max(QUEST_MIN_DEPOSIT, ROUND_UP(reward_reference * 0.5))
	return deposit

/// Get icon for scroll based on actual threat tier.
/datum/quest/proc/get_scroll_icon()
	switch(threat_tier)
		if(QUEST_TIER_ROUTINE, QUEST_TIER_RISKY)
			return "scroll_quest_low"
		if(QUEST_TIER_DANGEROUS, QUEST_TIER_DEADLY)
			return "scroll_quest_mid"
		if(QUEST_TIER_LETHAL, QUEST_TIER_MYTHIC)
			return "scroll_quest_high"
	return quest_icon

/// Get target location for compass - returns turf of nearest tracked atom
/datum/quest/proc/get_target_location(turf/reference_turf, atom/movable/preferred_target = null)
	var/turf/live_target_turf = get_nearest_tracked_location(reference_turf, TRUE, preferred_target)
	return get_anchor_safe_target_location(reference_turf, live_target_turf)

/datum/quest/proc/can_generate_for_world()
	return TRUE

/// Check if a user can claim this quest - override for restrictions
/datum/quest/proc/can_claim(mob/user)
	return TRUE

/// Called when quest is claimed by a user
/datum/quest/proc/on_claim(mob/user)
	quest_receiver_reference = WEAKREF(user)
	quest_receiver_name = user.real_name