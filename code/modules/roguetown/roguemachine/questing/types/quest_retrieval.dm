/datum/quest/retrieval
	quest_type = QUEST_RETRIEVAL
	writ_type = WRIT_TYPE_RECOVERY
	var/list/fetch_items = list(
		/obj/item/rogueweapon/huntingknife/throwingknife/steel,
		/obj/item/rogueweapon/huntingknife,
		/obj/item/reagent_containers/glass/bottle/rogue/whitewine
	)

/datum/quest/retrieval/get_base_reward()
	return QUEST_REWARD_BASE_FETCH

/datum/quest/retrieval/get_title()
	if(title)
		return title
	return "Retrieve [pick("misplaced", "lost", "abandoned")] goods"

/datum/quest/retrieval/get_objective_text()
	return "Retrieve [progress_required] [initial(target_item_type.name)]."


/datum/quest/retrieval/get_additional_reward(turf/origin_turf, turf/target_turf)
	var/distance = CLAMP(get_dist(origin_turf, target_turf), 0, 200)
	var/distance_reward = (distance / QUEST_DELIVERY_DISTANCE_DIVISOR) * QUEST_DELIVERY_DISTANCE_BONUS
	var/item_bonus = progress_required * QUEST_DELIVERY_PER_ITEM_BONUS
	return ROUND_UP(distance_reward + item_bonus)

/datum/quest/retrieval/preview(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return
	target_item_type = pick(fetch_items)
	progress_required = rand(1, 3)
	finalize_preview_title()

/datum/quest/retrieval/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	for(var/i in 1 to progress_required)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/item/new_item = new target_item_type(spawn_turf)
		new_item.AddComponent(/datum/component/quest_object/retrieval, src)
		add_tracked_atom(new_item)
	return TRUE
