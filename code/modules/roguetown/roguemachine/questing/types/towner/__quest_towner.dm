GLOBAL_LIST_INIT(towner_tier_difficulties, list(
	TOWNER_POSTING_TIER_EASY = QUEST_DIFFICULTY_EASY,
	TOWNER_POSTING_TIER_MEDIUM = QUEST_DIFFICULTY_MEDIUM,
	TOWNER_POSTING_TIER_HARD = QUEST_DIFFICULTY_HARD,
))

GLOBAL_LIST_INIT(towner_reward_caps, list(
	TOWNER_POSTING_TIER_EASY = TOWNER_REWARD_CAP_EASY,
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_REWARD_CAP_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_REWARD_CAP_HARD,
))

GLOBAL_LIST_INIT(towner_tier_flat_bonus, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_FLAT_BONUS_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_FLAT_BONUS_HARD,
))

/datum/quest/kill/recovery/towner
	writ_type = WRIT_TYPE_TOWNER
	levy_exempt = TRUE
	guild_cut_exempt = TRUE
	override_destination = /area/rogue/indoors/town/dwarfin
	var/posting_tier = TOWNER_POSTING_TIER_EASY
	var/parcel_label = "sealed strongbox"
	/// Noun the writ and messages use for the sealed goods (e.g. "strongbox", "ore-crate").
	var/sealed_noun = "strongbox"

/datum/quest/kill/recovery/towner/calculate_deposit()
	return 0

/datum/quest/kill/recovery/towner/calculate_reward(turf/origin_turf, turf/target_turf)
	. = ..()
	var/cap = GLOB.towner_reward_caps[posting_tier]
	if(cap)
		. = min(., cap)

/datum/quest/kill/recovery/towner/get_scroll_type()
	return /obj/item/quest_writ/towner

/datum/quest/kill/recovery/towner/proc/get_writ_intro()
	return "A townsman calls for hands to recover what was lost to the wilds and bear it home."

/datum/quest/kill/recovery/towner/proc/get_writ_seal_note()
	return "The [sealed_noun] is magickally sealed to [quest_giver_name || "the poster"] - carry it back, only they can open it."

/datum/quest/kill/recovery/towner/populate_scroll_ui_static_data(list/data)
	..()
	data["towner_intro"] = get_writ_intro()
	data["towner_seal_note"] = get_writ_seal_note()

/datum/quest/kill/recovery/towner/proc/get_eligible_regions()
	return list()

/datum/quest/kill/recovery/towner/proc/get_tier_tp_budget()
	return 0

/datum/quest/kill/recovery/towner/proc/get_tier_flat_bonus()
	return GLOB.towner_tier_flat_bonus[posting_tier] || 0

/datum/quest/kill/recovery/towner/proc/build_bundle()
	return list()

/datum/quest/kill/recovery/towner/proc/get_parcel_name()
	return "[quest_giver_name]'s [parcel_label]"

/datum/quest/kill/recovery/towner/proc/get_parcel_desc()
	return "A [sealed_noun] magickally sealed for [quest_giver_name] - only they can open it."

/datum/quest/kill/recovery/towner/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!(landmark.region in get_eligible_regions()))
		return FALSE
	tp_budget = get_tier_tp_budget()
	. = ..()
	if(!.)
		return FALSE
	shipment_name = parcel_label
	return TRUE

/datum/quest/kill/recovery/towner/get_additional_reward(turf/origin_turf, turf/target_turf)
	return ..() + get_tier_flat_bonus()

/datum/quest/kill/recovery/towner/on_claim(mob/user)
	. = ..()
	to_chat(user, span_warning("The [sealed_noun] is magickally sealed - only [quest_giver_name] can open it."))

/datum/quest/kill/recovery/towner/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return
	var/obj/item/parcel/towner_caravan/recovered = new(spawn_turf)
	var/list/bundle = build_bundle()
	for(var/path in bundle)
		var/count = bundle[path]
		for(var/i in 1 to count)
			var/obj/item/I = new path(recovered)
			recovered.contained_items += I
	recovered.delivery_area_type = target_delivery_location
	recovered.allowed_jobs = recovered.get_area_jobs(target_delivery_location)
	recovered.unlocked_by_owner_ref = quest_giver_reference
	recovered.owner_name = quest_giver_name
	recovered.sealed_noun = sealed_noun
	recovered.name = get_parcel_name()
	recovered.desc = get_parcel_desc()
	recovered.icon_state = "ration_large"
	recovered.dropshrink = 1
	recovered.update_icon()
	recovered.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(recovered)

/datum/quest/kill/recovery/towner/proc/on_turn_in_pay_giver(mob/bearer, turf/ledger_turf)
	return
