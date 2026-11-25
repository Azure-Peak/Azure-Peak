/datum/component/quest_object/courier

/datum/component/quest_object/courier/Initialize(datum/quest/target_quest)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/datum/component/quest_object/courier/on_item_dropped(obj/item/dropped_item, mob/user)
	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete || !Q.target_delivery_location)
		return

	var/turf/drop_turf = get_turf(dropped_item)
	var/area/drop_area = get_area(drop_turf)

	if(!istype(drop_area, Q.target_delivery_location))
		return

	if(istype(dropped_item, /obj/item/parcel))
		var/obj/item/parcel/parcel = dropped_item
		parcel.remove_filter(outline_filter_id)
		for(var/obj/item/I as anything in parcel.contained_items)
			I.remove_filter(outline_filter_id)
		Q.progress_current++
		Q.on_progress_update()
		return

	else if(istype(dropped_item, Q.target_delivery_item))
		dropped_item.remove_filter(outline_filter_id)
		Q.progress_current++
		Q.on_progress_update()
		return
