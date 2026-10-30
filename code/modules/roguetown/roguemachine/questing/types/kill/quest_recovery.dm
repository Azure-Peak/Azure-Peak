GLOBAL_LIST_INIT(quest_recovery_shipments, list(
	// Smith / Dwarfin Guild: raw materials for crafting
	/area/rogue/indoors/town/dwarfin = list(
		list("name" = "iron ingots", "item" = /obj/item/ingot/iron, "min" = 4, "max" = 7),
		list("name" = "bronze ingots", "item" = /obj/item/ingot/bronze, "min" = 3, "max" = 5),
		list("name" = "a haul of coal", "item" = /obj/item/rogueore/coal, "min" = 5, "max" = 9),
		list("name" = "a shipment of cinnabar ore", "item" = /obj/item/rogueore/cinnabar, "min" = 2, "max" = 3),
	),
	// University / Magician: alchemical reagents, oddities, and parchment for the scribes
	/area/rogue/indoors/town/magician = list(
		list("name" = "alchemical ozium", "item" = /obj/item/reagent_containers/powder/ozium, "min" = 3, "max" = 5),
		list("name" = "a cache of moondust", "item" = /obj/item/reagent_containers/powder/moondust, "min" = 2, "max" = 3),
		list("name" = "cinnabar ore for the Archivist", "item" = /obj/item/rogueore/cinnabar, "min" = 2, "max" = 3),
		list("name" = "blue elven wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/elfblue, "min" = 1, "max" = 2),
		list("name" = "a bundle of parchment", "item" = /obj/item/paper, "min" = 8, "max" = 14),
		list("name" = "the grand magos' special request", "item" = /obj/item/reagent_containers/powder/spice, "min" = 2, "max" = 4),
		list("name" = "Mount Decapitation study materials", "item" = /obj/item/roguecoin/aalloy/pile, "min" = 1, "max" = 1),
		list("name" = "the grand magos' other request", "item" = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry, "min" = 2, "max" = 4),
		list("name" = "abandoned hats from the south", "item" = /obj/item/clothing/head/roguetown/wizhat/random, "min" = 4, "max" = 6),
	),



	// Manor: luxury goods and contraband
	/area/rogue/indoors/town/manor = list(
		list("name" = "aged cheese wheels", "item" = /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged, "min" = 4, "max" = 6),
		list("name" = "imported white wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/whitewine, "min" = 3, "max" = 5),
		list("name" = "aged red wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/redwine, "min" = 3, "max" = 5),
		list("name" = "an Elven vintage", "item" = /obj/item/reagent_containers/glass/bottle/rogue/elfred, "min" = 1, "max" = 1),
		list("name" = "a cache of moondust", "item" = /obj/item/reagent_containers/powder/moondust, "min" = 2, "max" = 3),
		list("name" = "dressed poultry", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry, "min" = 3, "max" = 5),
		list("name" = "fresh steaks", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak, "min" = 3, "max" = 5),
		list("name" = "well-aged tea", "item" = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry, "min" = 1, "max" = 2),
		list("name" = "recovered sugars", "item" = /obj/item/reagent_containers/food/snacks/sugar, "min" = 2, "max" = 3),
	),
	// Tavern: food and drink for the Innkeeper
	/area/rogue/indoors/town/tavern = list(
		list("name" = "wine bottles", "item" = /obj/item/reagent_containers/glass/bottle/rogue/whitewine, "min" = 4, "max" = 7),
		list("name" = "aged spiced wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/spicedwineaged, "min" = 2, "max" = 4),
		list("name" = "bottles of aurorian ale", "item" = /obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian, "min" = 5, "max" = 8),
		list("name" = "aged cheese wheels", "item" = /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged, "min" = 3, "max" = 5),
		list("name" = "dressed poultry", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry, "min" = 1, "max" = 2),
		list("name" = "fresh steaks", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak, "min" = 2, "max" = 4),
		list("name" = "a chocolate ingot", "item" = /obj/item/reagent_containers/food/snacks/chocolate, "min" = 1, "max" = 2),
		list("name" = "fresh hams", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/ham, "min" = 2, "max" = 4),
		list("name" = "a consortium of pork belly", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/pork_belly, "min" = 2, "max" = 4),
		list("name" = "a poor vendor's cabbages", "item" = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue, "min" = 6, "max" = 10),
		list("name" = "recovered sugars", "item" = /obj/item/reagent_containers/food/snacks/sugar, "min" = 2, "max" = 4),
		list("name" = "somewhat burnt coffee", "item" = /obj/item/reagent_containers/food/snacks/grown/coffeebeans, "min" = 2, "max" = 4),
		list("name" = "well-aged tea", "item" = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry, "min" = 2, "max" = 4),
	),
	// Church: lost tithes — always a full bundle or two of the essentials
	/area/rogue/indoors/town/church = list(
		list("name" = "bundles of tithe cloth", "item" = /obj/item/natural/bundle/cloth, "min" = 1, "max" = 2),
		list("name" = "ozium for the incense braziers", "item" = /obj/item/reagent_containers/powder/ozium, "min" = 1, "max" = 2),
		list("name" = "sacramental wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/whitewine, "min" = 1, "max" = 2),
		list("name" = "fishy healing aids", "item" = /obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum, "min" = 1, "max" = 2),
		list("name" = "old surgeon's tools", "item" = /obj/item/storage/belt/rogue/surgery_bag, "min" = 1, "max" = 1),
		list("name" = "spare verses", "item" = /obj/item/book/rogue/bibble, "min" = 3, "max" = 6),
		list("name" = "countryside tithes", "item" = /obj/item/roguecoin/copper/pile, "min" = 1, "max" = 2),
		list("name" = "holy vessels blessed in Grenzelhoft", "item" = /obj/item/reagent_containers/glass/bottle/clayvaseclassic/holy_water, "min" = 1, "max" = 3),
	),
	// Physician / Apothecary: herbs and alchemical reagents for healing
	/area/rogue/indoors/town/physician = list(
		list("name" = "calendula flowers", "item" = /obj/item/alch/calendula, "min" = 4, "max" = 7),
		list("name" = "jars of viscera", "item" = /obj/item/alch/viscera, "min" = 3, "max" = 5),
		list("name" = "bundles of bandages", "item" = /obj/item/natural/bundle/cloth/bandage/full, "min" = 2, "max" = 3),
		list("name" = "healing draughts", "item" = /obj/item/reagent_containers/glass/bottle/rogue/healthpot, "min" = 2, "max" = 4),
		list("name" = "an abundance of fishy healing aids", "item" = /obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum, "min" = 3, "max" = 5),
		list("name" = "old surgeon's tools", "item" = /obj/item/storage/belt/rogue/surgery_bag, "min" = 1, "max" = 2),
		list("name" = "tumor removing draughts", "item" = /obj/item/reagent_containers/glass/bottle/rogue/berrypoison, "min" = 1, "max" = 3),
		list("name" = "impure lux", "item" = /obj/item/reagent_containers/lux_impure, "min" = 1, "max" = 1),
	),
))

/datum/quest/kill/recovery
	quest_type = QUEST_RECOVERY
	chronicle_order = QUEST_CHRONICLE_ORDER_RECOVERY
	quest_difficulty = QUEST_DIFFICULTY_MEDIUM
	pool_kind = QUEST_POOL_KILL
	pool_weight = QUEST_POOL_WEIGHT_RECOVERY
	rumor_cost = RUMOR_COST_STANDARD
	// No defense_cost so that Steward cannot issue them. I want Innkeeper to have a unique type of quest that is not available to the Steward.
	eligible_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_UNDERDARK,
	)
	tp_budget = QUEST_TP_BUDGET_RECOVERY
	threat_bands_cleared = QUEST_BANDS_RECOVERY
	fellowship_threat_rate = QUEST_FELLOWSHIP_THREAT_PER_EXTRA_MEDIUM
	fellowship_reward_rate = QUEST_FELLOWSHIP_REWARD_PER_EXTRA
	kills_count_progress = FALSE
	takes_destination = TRUE
	var/shipment_name
	var/shipment_count = 0
	var/parcel_released = FALSE

/datum/quest/kill/recovery/get_base_reward()
	return QUEST_REWARD_BASE_RECOVERY

/datum/quest/kill/recovery/roll_circumstance()
	if(faction?.category in list(FACTION_CAT_UNDEAD, FACTION_CAT_BEAST, FACTION_CAT_ELEMENTAL))
		return pick_writ_circumstance(/datum/writ_circumstance/recovery)
	return pick_writ_circumstance(/datum/writ_circumstance/recovery_bandits)

/datum/quest/kill/recovery/get_recovery_shipment_name()
	return shipment_name

/datum/quest/kill/recovery/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!pick_shipment())
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	progress_required = 1
	return TRUE

/datum/quest/kill/recovery/proc/pick_shipment()
	// Destination picks the item pool. If Rumor-dispatcher pre-set an override, use it; else random.
	var/area/destination = override_destination
	if(!destination)
		var/list/keys = GLOB.quest_recovery_shipments
		destination = pick(keys)
	target_delivery_location = destination
	var/list/pool = GLOB.quest_recovery_shipments[destination]
	if(!length(pool))
		return FALSE
	var/list/chosen = pick(pool)
	target_delivery_item = chosen["item"]
	shipment_name = chosen["name"]
	shipment_count = rand(chosen["min"], chosen["max"])
	return TRUE

/datum/quest/kill/recovery/get_title()
	if(title)
		return title
	if(!faction || !shipment_name)
		return "Recover lost goods"
	return "Recover [shipment_name] from a [faction.group_word] of [faction.name_plural]"

/datum/quest/kill/recovery/get_objective_text()
	var/area/dest = target_delivery_location
	var/dest_name = ispath(dest) ? initial(dest.name) : "its rightful owner"
	return "Recover [shipment_name] and deliver the sealed parcel to [dest_name]."

/datum/quest/kill/recovery/get_additional_reward(turf/origin_turf, turf/target_turf)
	return ROUND_UP(..() + calculate_delivery_reward(origin_turf, target_turf))

/datum/quest/kill/recovery/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!faction)
		return FALSE
	. = ..()
	if(. && !any_guardians_alive())
		release_parcel(landmark)

/datum/quest/kill/recovery/mark_complete()
	..()
	despawn_live_hunt_mobs()

/datum/quest/kill/recovery/on_guardian_killed()
	if(any_guardians_alive())
		return
	release_parcel()
	if(!hunt_timer_id)
		return
	hunt_timer_label = "Parcel must be delivered in"
	hunt_warn_text = "to deliver the parcel"
	hunt_timeout_text = "<b>The parcel was not delivered in time.</b> The scroll crumbles to ash in your hand."
	start_hunt_timer(QUEST_RECOVERY_DELIVERY_TIMER)
	announce_to_bearer("<b>The guardians are slain.</b> You have [DisplayTimeText(QUEST_RECOVERY_DELIVERY_TIMER)] to deliver the parcel.")

/datum/quest/kill/recovery/proc/release_parcel(obj/effect/landmark/quest_spawner/landmark)
	if(parcel_released)
		return
	if(!landmark)
		landmark = pending_landmark_ref?.resolve()
	if(!landmark)
		return
	parcel_released = TRUE
	spawn_recovery_parcel(landmark)

/datum/quest/kill/recovery/proc/build_bundle()
	. = list()
	.[target_delivery_item] = shipment_count

/datum/quest/kill/recovery/proc/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	var/parcel_desc = "A sealed parcel of [shipment_name] wrested back from its captors. Marked for delivery to [initial(target_delivery_location.name)]. The seal can only be broken by the recipient."
	spawn_parcel(landmark, /obj/item/parcel, build_bundle(), "lost shipment of [shipment_name]", parcel_desc, target_delivery_location)
