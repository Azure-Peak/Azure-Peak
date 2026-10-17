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
	var/threat_bonus = 0
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(TR)
		threat_bonus = max(0, (TR.delivery_reward_multiplier - 1.0) * QUEST_DELIVERY_THREAT_BONUS)
	return ROUND_UP(distance_reward + QUEST_COURIER_BONUS_FLAT + threat_bonus)

/datum/quest/courier/proc/get_area_delivery_items()
	var/static/list/area_delivery_items = list(
		/area/rogue/indoors/town/tavern = list(
			/obj/item/cooking/pan,
			/obj/item/rogueweapon/huntingknife/chefknife,
			/obj/item/reagent_containers/glass/bucket,
			// ration papers! always good to have extra.
			/obj/item/ration,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar,
			// LOTS of different alcohol variations.
			/obj/item/reagent_containers/glass/bottle/rogue/spicedwineaged,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/butterhairs,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/stonebeardreserve,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena,
			/obj/item/reagent_containers/glass/bottle/rogue/redwine,
			/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
			/obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,
			/obj/item/reagent_containers/glass/bottle/rogue/elfred,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/avarrice,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunlager,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/baijiu,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/nocshine // hehehe

		),
		/area/rogue/indoors/town/bath = list(
			/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian,
			/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab,
			/obj/item/perfume/random,
			/obj/item/storage/belt/rogue/pouch/zigarrete/nicotine,
			/obj/item/storage/belt/rogue/pouch/zigarrete/cannabis,
			/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/whipwine,

		),
		/area/rogue/indoors/town/church = list(
			/obj/item/natural/cloth,
			/obj/item/reagent_containers/powder/ozium,
			/obj/item/reagent_containers/food/snacks/rogue/crackerscooked,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum, // shitty health potion. NOT the good one.
			/obj/item/reagent_containers/glass/bottle/clayvaseclassic/holy_water,
			/obj/item/book/rogue/bibble,

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
			/obj/item/perfume/random, // idk this was o nthe other noble lists and i think its Ok.
			/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena, // helps you get thru playing merchant
			/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
			/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
			/obj/item/bomb, // oh my god JC
		),
		/area/rogue/indoors/town/manor = list(
			/obj/item/clothing/cloak/raincloak/furcloak,
			/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged,
			/obj/item/perfume/random,
			/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab, // in honor of ser psyras or hubert i cant remember who wanted this
		),
		/area/rogue/indoors/town/magician = list(
			/obj/item/rogueweapon/spellbook,
			/obj/item/roguegem/yellow,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot,
			/obj/item/clothing/head/roguetown/wizhat/random,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
		),
		/area/rogue/indoors/town/physician = list(
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum,
			/obj/item/reagent_containers/glass/bottle/rogue/antidote,
			/obj/item/reagent_containers/glass/bottle/rogue/berrypoison,
			/obj/item/alch/viscera,
			/obj/item/natural/bundle/cloth/bandage/full,
			/obj/item/reagent_containers/powder/ozium,
			/datum/supply_pack/rogue/drugs/moondust,
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
