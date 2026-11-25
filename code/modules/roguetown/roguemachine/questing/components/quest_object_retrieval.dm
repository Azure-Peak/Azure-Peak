/datum/component/quest_object/retrieval

/datum/component/quest_object/retrieval/Initialize(datum/quest/target_quest)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/datum/component/quest_object/retrieval/on_item_dropped(obj/item/dropped_item, mob/user)
	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete)
		return

	var/turf/drop_turf = get_turf(dropped_item)

	var/obj/effect/decal/marker_export/marker = locate() in drop_turf

	if(marker)
		if(Q.target_item_type && istype(dropped_item, Q.target_item_type))
			// Notify quest of progress
			Q.progress_current++
			Q.on_progress_update()
			do_sparks(3, TRUE, get_turf(dropped_item))
			qdel(dropped_item)
			return
