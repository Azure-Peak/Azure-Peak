/// Recovery quest "lost shipment" table, keyed by destination area.
/// Each entry has a display name, item path, and per-entry min/max count so cheaper goods
/// show up in bulk and rarer/costlier ones come as single caches.
/// When a Recovery quest materializes for a given destination, it:
///   1. Picks one of this list's entries (RNG — Innkeeper sets destination, not specific good)
///   2. Spawns rand(entry.min, entry.max) of that item
///   3. Packs them into a sealed parcel that only destination staff can open
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
		list("name" = "mana-blue elven wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/elfblue, "min" = 1, "max" = 2),
		list("name" = "a bundle of parchment", "item" = /obj/item/paper, "min" = 8, "max" = 14),
	),
	// Manor: luxury goods and contraband
	/area/rogue/indoors/town/manor = list(
		list("name" = "aged cheese wheels", "item" = /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged, "min" = 4, "max" = 6),
		list("name" = "imported white wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/whitewine, "min" = 3, "max" = 5),
		list("name" = "aged red wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/redwine, "min" = 3, "max" = 5),
		list("name" = "an Elven vintage", "item" = /obj/item/reagent_containers/glass/bottle/rogue/elfred, "min" = 1, "max" = 1),
		list("name" = "a cache of moondust", "item" = /obj/item/reagent_containers/powder/moondust, "min" = 2, "max" = 3),
		list("name" = "dressed poultry", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry, "min" = 3, "max" = 5),
		list("name" = "cured meat", "item" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak, "min" = 3, "max" = 5),
	),
	// Tavern: food and drink for the Innkeeper
	/area/rogue/indoors/town/tavern = list(
		list("name" = "wine bottles", "item" = /obj/item/reagent_containers/glass/bottle/rogue/whitewine, "min" = 4, "max" = 7),
		list("name" = "aged spiced wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/spicedwineaged, "min" = 2, "max" = 4),
		list("name" = "barrels of aurorian ale", "item" = /obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian, "min" = 5, "max" = 8),
		list("name" = "aged cheese wheels", "item" = /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged, "min" = 3, "max" = 5),
	),
	// Church: lost tithes — always a full bundle or two of the essentials
	/area/rogue/indoors/town/church = list(
		list("name" = "bundles of tithe cloth", "item" = /obj/item/natural/bundle/cloth, "min" = 1, "max" = 2),
		list("name" = "ozium for the incense braziers", "item" = /obj/item/reagent_containers/powder/ozium, "min" = 1, "max" = 2),
		list("name" = "sacramental wine", "item" = /obj/item/reagent_containers/glass/bottle/rogue/whitewine, "min" = 1, "max" = 2),
	),
	// Physician / Apothecary: herbs and alchemical reagents for healing
	/area/rogue/indoors/town/physician = list(
		list("name" = "calendula flowers", "item" = /obj/item/alch/calendula, "min" = 4, "max" = 7),
		list("name" = "jars of viscera", "item" = /obj/item/alch/viscera, "min" = 3, "max" = 5),
		list("name" = "bundles of bandages", "item" = /obj/item/natural/bundle/cloth/bandage/full, "min" = 2, "max" = 3),
		list("name" = "healing draughts", "item" = /obj/item/reagent_containers/glass/bottle/rogue/healthpot, "min" = 2, "max" = 4),
	),
))

/datum/quest/kill/recovery
	quest_type = QUEST_RECOVERY
	tp_budget = QUEST_TP_BUDGET_RECOVERY
	threat_bands_cleared = QUEST_BANDS_RECOVERY
	kills_count_progress = FALSE
	/// Override destination — Rumor dispatcher can pre-set this. If null, chosen at preview.
	var/area/override_destination
	/// Display name of the shipment, set at preview from the picked entry.
	var/shipment_name
	/// Count of items actually packed (4-6).
	var/shipment_count = 0

/datum/quest/kill/recovery/roll_circumstance()
	return pick_recovery_bandits_circumstance()

/datum/quest/kill/recovery/get_recovery_shipment_name()
	return shipment_name

/datum/quest/kill/recovery/preview(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
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
	progress_required = 1
	finalize_preview_title()
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
	return "Recover the [shipment_name] and deliver the sealed parcel to [dest_name]."

/datum/quest/kill/recovery/get_additional_reward(turf/origin_turf, turf/target_turf)
	// Combat reward from fighting through (TP of guardians).
	var/combat_reward = 0
	if(total_spawned_tp > 0)
		combat_reward = total_spawned_tp * QUEST_KILL_THREAT_MULT
	else
		combat_reward = tp_budget * QUEST_KILL_THREAT_MULT
	// Distance reward from the delivery leg.
	var/distance = CLAMP(get_dist(origin_turf, target_turf), 0, 200)
	var/distance_reward = (distance / QUEST_DELIVERY_DISTANCE_DIVISOR) * QUEST_DELIVERY_DISTANCE_BONUS
	return ROUND_UP(combat_reward + distance_reward)

/datum/quest/kill/recovery/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	if(!faction)
		return FALSE
	spawn_kill_mobs(landmark)
	spawn_recovery_parcel(landmark)
	return TRUE

/datum/quest/kill/recovery/proc/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return
	var/obj/item/parcel/recovered = new(spawn_turf)
	// Pack shipment_count copies of target_delivery_item into the parcel's list.
	for(var/i in 1 to shipment_count)
		var/obj/item/I = new target_delivery_item(recovered)
		recovered.contained_items += I
	recovered.delivery_area_type = target_delivery_location
	recovered.allowed_jobs = recovered.get_area_jobs(target_delivery_location)
	recovered.name = "lost shipment of [shipment_name]"
	recovered.desc = "A sealed parcel of [shipment_name] wrested back from its captors. Marked for delivery to [initial(target_delivery_location.name)]. The seal can only be broken by the recipient."
	recovered.icon_state = "ration_large"
	recovered.dropshrink = 1
	recovered.update_icon()
	recovered.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(recovered)
