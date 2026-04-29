/datum/quest/courier
	quest_type = QUEST_COURIER
	writ_type = WRIT_TYPE_CARRIAGE
	var/list/target_delivery_locations = list(
		/area/rogue/indoors/town/tavern,
		/area/rogue/indoors/town/church,
		/area/rogue/indoors/town/dwarfin,
		/area/rogue/indoors/town/shop,
		/area/rogue/indoors/town/manor,
		/area/rogue/indoors/town/magician,
		/area/rogue/indoors/town/physician,
	)

/datum/quest/courier/get_base_reward()
	return QUEST_REWARD_BASE_FETCH

/datum/quest/courier/get_title()
	if(title)
		return title
	return "Deliver a parcel"

/datum/quest/courier/get_objective_text()
	return "Deliver [initial(target_delivery_item.name)] to [initial(target_delivery_location.name)]."

/datum/quest/courier/get_additional_reward(turf/origin_turf, turf/target_turf)
	var/distance = CLAMP(get_dist(origin_turf, target_turf), 0, 200)
	var/distance_reward = (distance / QUEST_DELIVERY_DISTANCE_DIVISOR) * QUEST_DELIVERY_DISTANCE_BONUS
	return ROUND_UP(distance_reward + QUEST_COURIER_BONUS_FLAT)

/datum/quest/courier/proc/get_area_delivery_items()
	var/static/list/area_delivery_items = list(
		/area/rogue/indoors/town/tavern = list(
			/obj/item/cooking/pan,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar,
		),
		/area/rogue/indoors/town/bath = list(
			/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian,
			/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab,
			/obj/item/perfume/random,
		),
		/area/rogue/indoors/town/church = list(
			/obj/item/natural/cloth,
			/obj/item/reagent_containers/powder/ozium,
			/obj/item/reagent_containers/food/snacks/rogue/crackerscooked,
		),
		/area/rogue/indoors/town/dwarfin = list(
			/obj/item/ingot/iron,
			/obj/item/ingot/bronze,
			/obj/item/rogueore/coal,
		),
		/area/rogue/indoors/town/shop = list(
			/obj/item/roguecoin/gold,
			/obj/item/clothing/ring/silver,
			/obj/item/scomstone/bad,
		),
		/area/rogue/indoors/town/manor = list(
			/obj/item/clothing/cloak/raincloak/furcloak,
			/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged,
			/obj/item/perfume/random,
		),
		/area/rogue/indoors/town/magician = list(
			/obj/item/book/spellbook,
			/obj/item/roguegem/yellow,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot,
		),
		/area/rogue/indoors/town/physician = list(
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/alch/viscera,
			/obj/item/natural/bundle/cloth/bandage/full,
		),
		/area/rogue/indoors/town = list(
			/obj/item/ration,
		)
	)
	return area_delivery_items

/datum/quest/courier/proc/spawn_courier_item(area/delivery_area, obj/effect/landmark/quest_spawner/landmark)
	if(!delivery_area)
		return null

	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return

	var/obj/item/parcel/delivery_parcel = new(spawn_turf)
	var/obj/item/contained = new target_delivery_item(delivery_parcel)
	delivery_parcel.contained_items += contained
	delivery_parcel.delivery_area_type = delivery_area
	delivery_parcel.allowed_jobs = delivery_parcel.get_area_jobs(delivery_area)
	delivery_parcel.name = "Delivery for [initial(delivery_area.name)]"
	delivery_parcel.desc = "A securely wrapped parcel addressed to [initial(delivery_area.name)]. [pick("Handle with care.", "Do not bend.", "Confidential contents.", "Urgent delivery.")]"
	delivery_parcel.icon_state = contained.w_class >= WEIGHT_CLASS_NORMAL ? "ration_large" : "ration_small"
	delivery_parcel.dropshrink = 1
	delivery_parcel.update_icon()

	delivery_parcel.AddComponent(/datum/component/quest_object/courier, src)
	contained.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(delivery_parcel)

	return delivery_parcel

/datum/quest/courier/preview(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return
	target_delivery_location = pick(target_delivery_locations)
	progress_required = 1
	var/list/possible_items = get_area_delivery_items()[target_delivery_location] || list(
		/obj/item/natural/cloth,
		/obj/item/ration,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked,
	)
	target_delivery_item = pick(possible_items)
	finalize_preview_title()

/datum/quest/courier/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	var/obj/item/parcel/delivery_parcel = spawn_courier_item(target_delivery_location, landmark)
	if(!delivery_parcel)
		return FALSE
	return TRUE
