/datum/quest/retrieval
	quest_type = QUEST_RETRIEVAL
	chronicle_order = QUEST_CHRONICLE_ORDER_RETRIEVAL
	pool_kind = QUEST_POOL_EVERGREEN
	pool_weight = QUEST_POOL_WEIGHT_RETRIEVAL
	rumor_cost = RUMOR_COST_TRIVIAL
	eligible_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
	)
	writ_type = WRIT_TYPE_RECOVERY
	var/list/fetch_items = list(
		/obj/item/rogueweapon/huntingknife/throwingknife/steel = "steel tossblades",
		/obj/item/rogueweapon/huntingknife = "hunting knives",
		/obj/item/reagent_containers/glass/bottle/rogue/whitewine = "bottles of Otavan White",
	)

/datum/quest/retrieval/get_base_reward()
	return QUEST_REWARD_BASE_FETCH

/datum/quest/retrieval/is_contract_item(obj/item/I)
	return target_item_type && istype(I, target_item_type)

/datum/quest/retrieval/get_title()
	if(title)
		return title
	return "Retrieve [pick("misplaced", "lost", "abandoned")] goods"

/datum/quest/retrieval/get_objective_text()
	return "Retrieve [progress_required] [progress_required > 1 ? target_item_plural : initial(target_item_type.name)]."


/datum/quest/retrieval/get_target_location()
	var/turf/user_turf = quest_scroll ? get_turf(quest_scroll) : null
	if(!user_turf)
		return null

	var/mob/bearer = get(quest_scroll, /mob)
	var/turf/closest
	var/min_dist = INFINITY
	var/turf/closest_held
	var/held_dist = INFINITY

	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/A = ref.resolve()
		if(QDELETED(A))
			continue
		var/turf/A_turf = get_turf(A)
		if(!A_turf)
			continue
		var/dist = get_dist(user_turf, A_turf)
		if(bearer && get(A, /mob) == bearer)
			if(dist < held_dist)
				held_dist = dist
				closest_held = A_turf
		else if(dist < min_dist)
			min_dist = dist
			closest = A_turf

	return closest || closest_held

/datum/quest/retrieval/get_additional_reward(turf/origin_turf, turf/target_turf)
	return ROUND_UP(calculate_delivery_reward(origin_turf, target_turf) + progress_required * QUEST_DELIVERY_PER_ITEM_BONUS)

/datum/quest/retrieval/preview(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return
	target_item_type = pick(fetch_items)
	target_item_plural = fetch_items[target_item_type]
	progress_required = 1
	finalize_preview_title()

/datum/quest/retrieval/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	for(var/i in 1 to progress_required)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/item/spawner = new(spawn_turf)
		var/obj/item/new_item = new target_item_type(spawner)
		new_item.AddComponent(/datum/component/quest_object/retrieval, src)
		add_tracked_atom(new_item)
		spawner.contained_atom = new_item
		spawner.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawner)
	return TRUE
