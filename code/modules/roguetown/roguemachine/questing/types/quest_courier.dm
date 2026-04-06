/datum/quest/courier
	quest_type = QUEST_COURIER
	contract_group = QUEST_GROUP_ERRANDS
	minimum_tier = QUEST_TIER_ROUTINE
	maximum_tier = QUEST_TIER_DEADLY
	base_reward_value = QUEST_BASE_REWARD_COURIER
	var/list/target_delivery_locations = list(
		/area/rogue/indoors/town/tavern,
		/area/rogue/indoors/town/church,
		/area/rogue/indoors/town/dwarfin,
		/area/rogue/indoors/town/shop,
		/area/rogue/indoors/town/manor,
		/area/rogue/indoors/town/magician,
	)

/datum/quest/courier/get_title()
	if(title)
		return title
	return "Deliver [pick("an important", "a sealed", "a confidential", "a valuable")] [pick("package", "parcel", "letter", "delivery")]"

/datum/quest/courier/get_objective_text()
	return "Deliver [initial(target_delivery_item.name)] to [initial(target_delivery_location.name)]."

/datum/quest/courier/get_location_text()
	var/text = ""
	if(target_spawn_area)
		text += "Pickup location: Reported sighting in [target_spawn_area] region.<br>"
	text += "Destination: [initial(target_delivery_location.name)]."
	return text

/datum/quest/courier/get_additional_reward(target_turf)
	var/turf/scroll_turf = get_turf(quest_scroll)
	var/distance = CLAMP(get_dist(scroll_turf, target_turf), 0, 200) // Avoid infinity rewards if it bugs out
	var/distance_reward = (distance / QUEST_DELIVERY_DISTANCE_DIVISOR) * QUEST_DELIVERY_DISTANCE_BONUS
	return ROUND_UP(distance_reward + QUEST_COURIER_BONUS_FLAT)

/datum/quest/courier/proc/spawn_courier_item(area/delivery_area, obj/effect/landmark/quest_spawner/landmark)
	if(!delivery_area)
		return null

	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return

	var/obj/item/parcel/delivery_parcel = new(spawn_turf)
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
		/area/rogue/indoors/town = list(
			/obj/item/ration,
		)
	)

	var/list/possible_items = area_delivery_items[delivery_area] || list(
		/obj/item/natural/cloth,
		/obj/item/ration,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked,
	)

	var/contained_item_type = pick(possible_items)
	var/obj/item/contained_item = new contained_item_type(delivery_parcel)
	delivery_parcel.contained_item = contained_item
	delivery_parcel.delivery_area_type = delivery_area
	delivery_parcel.allowed_jobs = delivery_parcel.get_area_jobs(delivery_area)
	delivery_parcel.name = "Delivery for [initial(delivery_area.name)]"
	delivery_parcel.desc = "A securely wrapped parcel addressed to [initial(delivery_area.name)]. [pick("Handle with care.", "Do not bend.", "Confidential contents.", "Urgent delivery.")]"
	delivery_parcel.icon_state = contained_item.w_class >= WEIGHT_CLASS_NORMAL ? "ration_large" : "ration_small"
	delivery_parcel.dropshrink = 1
	delivery_parcel.update_icon()

	target_delivery_item = contained_item_type
	delivery_parcel.AddComponent(/datum/component/quest_object/courier, src)
	contained_item.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(delivery_parcel)

	return delivery_parcel

/datum/quest/courier/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE

	// Select delivery location
	target_delivery_location = pick(target_delivery_locations)
	progress_required = 1
	target_spawn_area = get_area_name(get_turf(landmark))

	// Spawn parcel
	var/obj/item/parcel/delivery_parcel = spawn_courier_item(target_delivery_location, landmark)
	if(!delivery_parcel)
		return FALSE

	return TRUE
