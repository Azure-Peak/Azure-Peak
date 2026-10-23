GLOBAL_LIST_INIT(towner_posting_tiers, list(
	TOWNER_POSTING_TIER_MEDIUM = list("cost" = TOWNER_POSTING_COST_MEDIUM, "difficulty" = QUEST_DIFFICULTY_MEDIUM, "reward_cap" = TOWNER_REWARD_CAP_MEDIUM, "flat_bonus" = TOWNER_FLAT_BONUS_MEDIUM),
	TOWNER_POSTING_TIER_HARD = list("cost" = TOWNER_POSTING_COST_HARD, "difficulty" = QUEST_DIFFICULTY_HARD, "reward_cap" = TOWNER_REWARD_CAP_HARD, "flat_bonus" = TOWNER_FLAT_BONUS_HARD),
))

/proc/get_towner_tier_term(tier, term)
	var/list/terms = GLOB.towner_posting_tiers[tier]
	return terms?[term]

/proc/get_towner_prototype(quest_type)
	var/datum/quest/kill/recovery/towner/proto = GLOB.quest_prototypes[quest_type]
	return istype(proto) ? proto : null

/proc/get_towner_prototypes()
	. = list()
	for(var/qtype in GLOB.quest_prototypes)
		if(get_towner_prototype(qtype))
			.[qtype] = GLOB.quest_prototypes[qtype]

/datum/quest/kill/recovery/towner
	abstract_type = /datum/quest/kill/recovery/towner
	chronicle_order = QUEST_CHRONICLE_ORDER_TOWNER
	pool_kind = null
	pool_weight = 0
	rumor_cost = 0 // We don't want the Innkeeper to be able to issue these quests, so these overrides prevent it from appearing in their list.
	writ_type = WRIT_TYPE_TOWNER
	levy_exempt = TRUE
	guild_cut_rate = 0
	charges_deposit = FALSE
	lapses = FALSE
	takes_destination = FALSE
	var/posting_tier = TOWNER_POSTING_TIER_MEDIUM
	var/loadout_variety
	var/parcel_label = "sealed strongbox"
	var/sealed_noun = "strongbox"
	var/posting_label
	var/posting_blurb
	var/list/posting_rules = list(
		"The crate is magickally sealed. Only you can open it.",
		"You don't need to travel along. The holder will bring the package to you or send it by HERMES to be opened at your leisure.",
	)
	eligible_regions = list()
	var/list/postable_advclasses = list()
	var/list/eligible_factions = list()
	var/list/tier_tp_budgets = list(
		TOWNER_POSTING_TIER_MEDIUM = TOWNER_CARAVAN_TP_BUDGET_MEDIUM,
		TOWNER_POSTING_TIER_HARD = TOWNER_CARAVAN_TP_BUDGET_HARD,
	)
	var/list/varieties = list()
	var/list/bundle_pools = list()

/datum/quest/kill/recovery/towner/calculate_reward(turf/origin_turf, turf/target_turf)
	. = ..()
	var/cap = get_towner_tier_term(posting_tier, "reward_cap")
	if(cap)
		. = min(., cap)

/datum/quest/kill/recovery/towner/get_scroll_type()
	return /obj/item/quest_writ/towner

/datum/quest/kill/recovery/towner/proc/get_writ_intro()
	return "One of the townsfolk calls for hands to recover what was lost to the wilds and bring it home."

/datum/quest/kill/recovery/towner/proc/get_writ_seal_note()
	return "The [sealed_noun] is magickally sealed to [quest_giver_name || "the poster"]. You can deposit the package in the nearest HERMES to complete the contract, or have them open it by hand."

/datum/quest/kill/recovery/towner/populate_scroll_ui_static_data(list/data)
	..()
	data["towner_intro"] = get_writ_intro()
	data["towner_seal_note"] = get_writ_seal_note()

/datum/quest/kill/recovery/towner/proc/get_tier_tp_budget()
	return tier_tp_budgets[posting_tier] || tier_tp_budgets[TOWNER_POSTING_TIER_MEDIUM]

/datum/quest/kill/recovery/towner/proc/get_tier_flat_bonus()
	return get_towner_tier_term(posting_tier, "flat_bonus") || 0

/datum/quest/kill/recovery/towner/faction_fits(datum/quest_faction/F)
	return (F.id in eligible_factions)

/datum/quest/kill/recovery/towner/build_bundle()
	var/variety = effective_variety()
	if(!variety)
		return list()
	var/list/meta = varieties[variety]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])

/datum/quest/kill/recovery/towner/proc/effective_variety()
	if(!length(varieties))
		return null
	if(loadout_variety && (loadout_variety in varieties))
		return loadout_variety
	return varieties[1]

/datum/quest/kill/recovery/towner/proc/resolve_bundle_spec(list/spec)
	var/list/bundle = list()
	if(!length(spec))
		return bundle
	for(var/list/entry in spec)
		if(entry["prob"] != null && !prob(entry["prob"]))
			continue
		var/count = rand(entry["min"], entry["max"])
		if(count <= 0)
			continue
		var/pool = entry["pool"]
		if(pool)
			var/list/resolved = istext(pool) ? bundle_pools[pool] : pool
			if(!length(resolved))
				continue
			for(var/i in 1 to count)
				var/ppath = pick(resolved)
				bundle[ppath] = (bundle[ppath] || 0) + 1
		else
			var/path = entry["path"]
			bundle[path] = (bundle[path] || 0) + count
	return bundle

/datum/quest/kill/recovery/towner/proc/get_parcel_name()
	return "[quest_giver_name]'s [parcel_label]"

/datum/quest/kill/recovery/towner/proc/get_parcel_desc()
	return "A [sealed_noun] magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!(landmark.region in eligible_regions))
		return FALSE
	tp_budget = get_tier_tp_budget()
	return ..()

/datum/quest/kill/recovery/towner/pick_shipment()
	shipment_name = parcel_label
	return TRUE

/datum/quest/kill/recovery/towner/get_additional_reward(turf/origin_turf, turf/target_turf)
	return ..() + get_tier_flat_bonus()

/datum/quest/kill/recovery/towner/on_claim(mob/user)
	. = ..()
	to_chat(user, span_warning("The [sealed_noun] is magickally sealed. Only [quest_giver_name] can open it."))

/datum/quest/kill/recovery/towner/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	var/obj/item/parcel/towner_caravan/recovered = spawn_parcel(landmark, /obj/item/parcel/towner_caravan, build_bundle(), get_parcel_name(), get_parcel_desc())
	if(!recovered)
		return
	recovered.unlocked_by_owner_ref = quest_giver_reference
	recovered.owner_name = quest_giver_name
	recovered.sealed_noun = sealed_noun
