GLOBAL_LIST_INIT(quest_difficulty_terms, list(
	QUEST_DIFFICULTY_EASY = list("bonus" = QUEST_DIFFICULTY_BONUS_EASY, "deposit" = QUEST_DEPOSIT_EASY, "icon" = "scroll_quest_low"),
	QUEST_DIFFICULTY_MEDIUM = list("bonus" = QUEST_DIFFICULTY_BONUS_MEDIUM, "deposit" = QUEST_DEPOSIT_MEDIUM, "icon" = "scroll_quest_mid"),
	QUEST_DIFFICULTY_HARD = list("bonus" = QUEST_DIFFICULTY_BONUS_HARD, "deposit" = QUEST_DEPOSIT_HARD, "icon" = "scroll_quest_high"),
	QUEST_DIFFICULTY_NOTORIOUS = list("bonus" = QUEST_DIFFICULTY_BONUS_NOTORIOUS, "deposit" = QUEST_DEPOSIT_NOTORIOUS, "icon" = "scroll_quest_notorious"),
))

GLOBAL_LIST_INIT(quest_prototypes, build_quest_prototypes())

/proc/build_quest_prototypes()
	. = list()
	for(var/datum/quest/path as anything in subtypesof(/datum/quest))
		if(IS_ABSTRACT(path))
			continue
		var/qtype = initial(path.quest_type)
		if(!qtype)
			continue
		if(.[qtype])
			stack_trace("Duplicate quest_type [qtype] on [path] and [.[qtype]]")
			continue
		.[qtype] = new path()
	sortTim(., GLOBAL_PROC_REF(cmp_quest_chronicle_order), associative = TRUE)

/datum/quest
	abstract_type = /datum/quest
	var/title = ""
	var/datum/weakref/quest_giver_reference
	var/quest_giver_name = ""
	var/datum/weakref/quest_receiver_reference
	var/quest_receiver_name = ""
	var/quest_type = ""
	var/list/eligible_regions = list()
	var/chronicle_order = QUEST_CHRONICLE_ORDER_DEFAULT
	var/pool_kind
	var/pool_weight = 0
	var/rumor_cost = 0
	var/rumor_threat_gated = TRUE
	var/defense_cost = 0
	var/quest_difficulty = QUEST_DIFFICULTY_EASY
	var/reward_amount = 0
	var/charges_deposit = TRUE
	var/lapses = TRUE
	var/deposit_amount = 0
	var/complete = FALSE

	var/source
	var/created_at = 0
	var/issued_day = 0

	var/progress_current = 0
	var/progress_required = 1

	var/obj/item/target_item_type
	var/target_item_plural
	var/obj/item/target_delivery_item
	var/mob/living/target_mob_type
	var/area/rogue/indoors/town/target_delivery_location
	var/takes_destination = FALSE
	var/area/override_destination
	var/target_spawn_area = ""

	var/obj/item/quest_writ/quest_scroll
	var/datum/weakref/quest_scroll_ref
	var/list/datum/weakref/tracked_atoms = list()
	var/datum/weakref/pending_landmark_ref
	var/materialized = FALSE
	var/hand_claim_message = "You claim this contract for yourself!"
	var/region = ""
	var/faction_id
	var/datum/quest_faction/faction
	var/required_fellowship_size = 0
	var/issuer_may_claim = FALSE
	var/levy_exempt = FALSE
	var/guild_cut_rate = GUILD_REFERRAL_FEE_PCT
	var/shows_commission_seal = FALSE
	var/is_directive = FALSE
	var/list/datum/weakref/spawners = list()
	var/list/rolled_crimes
	var/sacral_hook = FALSE
	var/oath_breach = FALSE
	var/condemnation_variant = ""
	var/band_leader_name = ""
	var/writ_type = WRIT_TYPE_OUTLAWRY
	var/circumstance_text = ""
	var/list/funding_sources
	var/funding_rumor_points = 0
	var/warrant_consumed = 0
	var/list/issue_log_entry
	var/last_claimed_at = 0
	var/engaged = FALSE
	var/datum/fund/deposit_payer
	var/deposit_paid = 0
	var/posted_at = 0
	var/signer_group

/datum/quest/New()
	. = ..()
	posted_at = world.time

/datum/quest/proc/is_contract_item(obj/item/I)
	return FALSE

/datum/quest/proc/take_deposit(datum/fund/account)
	if(deposit_amount <= 0 || !account)
		return
	if(!SStreasury.burn(account, deposit_amount, "contract deposit", LEDGER_CITIZEN_CONTRACT_PAID))
		return
	deposit_payer = account
	deposit_paid = deposit_amount

/datum/quest/proc/return_deposit(memo)
	if(deposit_paid <= 0 || !deposit_payer)
		return 0
	. = deposit_paid
	SStreasury.mint(deposit_payer, deposit_paid, memo, null, LEDGER_CITIZEN_CONTRACT_PAID)
	deposit_paid = 0
	deposit_payer = null

/datum/quest/proc/pay_reward(datum/fund/account, mob/payee, amount, memo, tax_note)
	SStreasury.mint(account, amount, memo, null, LEDGER_CITIZEN_CONTRACTS)
	if(levy_exempt)
		var/levy_rate = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
		SStreasury.record_tax_exemption(TAX_CATEGORY_CONTRACT_LEVY, FLOOR(amount * levy_rate, 1))
		return 0
	var/tax_amt = SStreasury.apply_tax(account, amount, TAX_CATEGORY_CONTRACT_LEVY, tax_note)
	if(tax_amt > 0)
		record_featured_stat(FEATURED_STATS_TAX_PAYERS, payee, tax_amt)
		record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
	return tax_amt

/datum/quest/proc/forfeit_deposit()
	. = deposit_paid
	deposit_paid = 0
	deposit_payer = null

/datum/quest/proc/bind_new_scroll(mob/living/holder, turf/spawn_turf)
	var/scroll_type = get_scroll_type()
	var/obj/item/quest_writ/scroll = new scroll_type(spawn_turf || get_turf(holder))
	scroll.base_icon_state = get_scroll_icon()
	scroll.assigned_quest = src
	quest_scroll = scroll
	quest_scroll_ref = WEAKREF(scroll)
	scroll.update_quest_text()
	holder?.put_in_hands(scroll)
	return scroll

/datum/quest/proc/get_lapse_time()
	var/window = (source == QUEST_SOURCE_POOL) ? QUEST_POOL_STALE_THRESHOLD : QUEST_PLAYER_STALE_THRESHOLD
	return created_at + window

/datum/quest/Destroy()
	var/obj/effect/landmark/quest_spawner/held_landmark = pending_landmark_ref?.resolve()
	if(held_landmark)
		if(held_landmark.claimed_by?.resolve() == src)
			held_landmark.claimed_by = null
		if(materialized)
			held_landmark.cooldown_until = world.time + QUEST_LANDMARK_COOLDOWN

	for(var/datum/weakref/spawner_ref in spawners)
		var/obj/effect/quest_spawn/spawner = spawner_ref.resolve()
		if(!QDELETED(spawner))
			qdel(spawner)
	spawners.Cut()

	for(var/datum/weakref/tracked_weakref in tracked_atoms)
		var/atom/target_atom = tracked_weakref.resolve()
		if(!QDELETED(target_atom))
			if(ismob(target_atom))
				var/mob/M = target_atom
				var/datum/component/quest_object/Q = M.GetComponent(/datum/component/quest_object)
				if(Q && Q.quest_ref?.resolve() == src)
					M.remove_filter("quest_item_outline")
					qdel(Q)
			else if(!complete && is_contract_item(target_atom))
				qdel(target_atom)
	tracked_atoms.Cut()

	// Clean up references
	quest_scroll = null
	if(quest_scroll_ref)
		var/obj/item/quest_writ/Q = quest_scroll_ref.resolve()
		if(Q && !QDELETED(Q))
			Q.assigned_quest = null
			qdel(Q)
		quest_scroll_ref = null

	return ..()

/datum/quest/proc/add_tracked_atom(atom/movable/to_track)
	tracked_atoms += WEAKREF(to_track)

/datum/quest/proc/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	bind_landmark(landmark)
	return TRUE

/datum/quest/proc/bind_landmark(obj/effect/landmark/quest_spawner/landmark)
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region

/datum/quest/proc/finalize_preview_title()
	if(!title)
		title = get_title()
	if(!rolled_crimes && faction)
		faction.compose_preamble(src)
	if(!circumstance_text)
		circumstance_text = roll_circumstance()

/datum/quest/proc/roll_circumstance()
	switch(writ_type)
		if(WRIT_TYPE_RECOVERY)
			return pick_writ_circumstance(/datum/writ_circumstance/recovery)
		if(WRIT_TYPE_CARRIAGE)
			return pick_writ_circumstance(/datum/writ_circumstance/carriage)
	return ""

/datum/quest/proc/get_named_target()
	return null

/datum/quest/proc/get_recovery_shipment_name()
	return null

/datum/quest/proc/register_spawner(obj/effect/quest_spawn/spawner)
	spawners += WEAKREF(spawner)

/datum/quest/proc/pop_all_spawners()
	if(length(spawners))
		engaged = TRUE
		on_first_pop()
	for(var/datum/weakref/ref in spawners)
		var/obj/effect/quest_spawn/spawner = ref.resolve()
		if(QDELETED(spawner) || !spawner.contained_atom)
			continue
		spawner.reveal_contained()
	spawners.Cut()

/datum/quest/proc/on_first_pop()
	return

/datum/quest/proc/materialize(obj/effect/landmark/quest_spawner/landmark)
	return TRUE

/datum/quest/proc/get_title()
	return title

/datum/quest/proc/get_objective_text()
	return "Complete the objective."

/datum/quest/proc/populate_scroll_ui_data(list/data)
	return

/datum/quest/proc/populate_scroll_ui_static_data(list/data)
	return

/datum/quest/proc/check_completion()
	return progress_current >= progress_required

/datum/quest/proc/on_progress_update()
	if(check_completion())
		mark_complete()

/datum/quest/proc/mark_complete()
	complete = TRUE
	quest_scroll?.update_quest_text()

/datum/quest/proc/fits_region(datum/threat_region/TR)
	return TRUE

/datum/quest/proc/get_defense_regions()
	. = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(TR.allows_quest_type(quest_type))
			. += TR.region_name

/datum/quest/proc/force_complete()
	if(complete)
		return
	progress_current = progress_required
	mark_complete()

/datum/quest/proc/get_base_reward()
	return QUEST_REWARD_BASE_FLAT

/datum/quest/proc/get_additional_reward(turf/origin_turf, turf/target_turf)
	return 0

/datum/quest/proc/calculate_delivery_reward(turf/origin_turf, turf/target_turf)
	var/distance = CLAMP(get_dist(origin_turf, target_turf), 0, 200)
	. = (distance / QUEST_DELIVERY_DISTANCE_DIVISOR) * QUEST_DELIVERY_DISTANCE_BONUS
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(TR)
		. += max(0, (TR.delivery_reward_multiplier - 1.0) * QUEST_DELIVERY_THREAT_BONUS)

/datum/quest/proc/spawn_parcel(obj/effect/landmark/quest_spawner/landmark, parcel_type, list/bundle, parcel_name, parcel_desc, area/delivery_area)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return null
	var/obj/item/parcel/parcel = new parcel_type(spawn_turf)
	parcel.preserves_contents = TRUE
	for(var/path in bundle)
		for(var/i in 1 to bundle[path])
			parcel.contained_items += new path(parcel)
	if(delivery_area)
		parcel.delivery_area_type = delivery_area
		parcel.allowed_jobs = parcel.get_area_jobs(delivery_area)
	parcel.name = parcel_name
	parcel.desc = parcel_desc
	parcel.icon_state = "ration_large"
	parcel.dropshrink = 1
	parcel.update_icon()
	parcel.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(parcel)
	return parcel

/datum/quest/proc/calculate_reward(turf/origin_turf, turf/target_turf)
	var/base = get_base_reward()
	var/additional = get_additional_reward(origin_turf, target_turf)
	var/payout_mult = QUEST_REWARD_GLOBAL_MULT
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(TR)
		payout_mult *= TR.payout_multiplier
	return round((base + additional + (get_difficulty_term("bonus") || 0)) * payout_mult)

/datum/quest/proc/get_difficulty_term(term)
	var/list/terms = GLOB.quest_difficulty_terms[quest_difficulty]
	return terms?[term]

/datum/quest/proc/calculate_deposit()
	if(!charges_deposit)
		return 0
	return get_difficulty_term("deposit") || 0

/datum/quest/proc/get_scroll_type()
	return /obj/item/quest_writ

/datum/quest/proc/get_scroll_icon()
	return get_difficulty_term("icon") || "scroll_quest"

/datum/quest/proc/get_target_location()
	var/turf/user_turf = quest_scroll ? get_turf(quest_scroll) : null
	if(!user_turf)
		return null

	var/turf/closest
	var/min_dist = INFINITY

	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/A = ref.resolve()
		if(!A || QDELETED(A))
			continue

		if(isliving(A))
			var/mob/living/L = A
			if(L.stat == DEAD)
				continue

		var/turf/A_turf = get_turf(A)
		if(!A_turf)
			continue

		var/dist = get_dist(user_turf, A_turf)
		if(dist < min_dist)
			min_dist = dist
			closest = A_turf

	return closest

/datum/quest/proc/can_claim(mob/living/user)
	if(SSquestpool.debug_mode)
		return TRUE
	if(required_fellowship_size > 0)
		var/datum/fellowship/F = user?.current_fellowship
		if(!F)
			return FALSE
		if(length(F.get_members()) < required_fellowship_size)
			return FALSE
	return TRUE

/datum/quest/proc/claim_failure_reason(mob/living/user)
	if(required_fellowship_size > 0)
		var/datum/fellowship/F = user?.current_fellowship
		if(!F)
			return "This contract needs a fellowship of [required_fellowship_size]."
		if(length(F.get_members()) < required_fellowship_size)
			return "Your fellowship is too small. It needs [required_fellowship_size] members."
	return "You cannot sign that contract."

/datum/quest/proc/on_claim(mob/user)
	quest_receiver_reference = WEAKREF(user)
	quest_receiver_name = user.real_name
	last_claimed_at = world.time
	signer_group = contract_signer_group(user)
	record_contract_stat(src, CONTRACT_STAT_TAKEN)
	record_contract_stat(src, CONTRACT_STAT_WAIT_DS, max(0, world.time - posted_at))
	record_contract_signer(src, user.ckey)

/datum/quest/proc/get_party_size()
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	if(!istype(bearer) || !bearer.current_fellowship)
		return 1
	return max(1, length(bearer.current_fellowship.get_members()))

/datum/quest/proc/record_completion_stats(paid)
	record_contract_stat(src, CONTRACT_STAT_COMPLETED)
	record_contract_stat(src, CONTRACT_STAT_RUN_DS, max(0, world.time - last_claimed_at))
	record_contract_stat(src, CONTRACT_STAT_PARTY, get_party_size())
	if(paid > 0)
		record_contract_stat(src, CONTRACT_STAT_PAID, paid)

/datum/quest/proc/has_started()
	if(complete || engaged || progress_current > 0)
		return TRUE
	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/movable/tracked = ref.resolve()
		if(QDELETED(tracked) || isliving(tracked))
			continue
		if(!isturf(tracked.loc))
			return TRUE
	return FALSE

/datum/quest/proc/issuer_cancel_blocker()
	if(complete)
		return "the contract is already fulfilled"
	if(has_started())
		return "the work has already begun"
	if(!quest_receiver_reference)
		return null
	var/remaining = last_claimed_at + MIN_TIME_BEFORE_CANCEL_TAKEN_QUEST - world.time
	if(remaining > 0)
		return "its holder has [max(1, round(remaining / (1 MINUTES)))] more minute(s) before it can be withdrawn"
	return null

/datum/quest/proc/add_funding(datum/fund/fund, amount)
	if(!fund || amount <= 0)
		return
	if(!funding_sources)
		funding_sources = list()
	funding_sources += list(list("fund" = fund, "amount" = amount))

/datum/quest/proc/get_funding_total()
	. = 0
	for(var/list/source as anything in funding_sources)
		. += source["amount"]

/datum/quest/proc/describe_issuer_refund(fraction = REFUND_ON_NOT_TAKEN)
	var/list/parts = list()
	for(var/list/source as anything in funding_sources)
		var/datum/fund/fund = source["fund"]
		var/amount = round(source["amount"] * fraction)
		if(amount > 0)
			parts += "[amount]m to [fund.name]"
	var/rumor_points = round(funding_rumor_points * fraction, 0.1)
	if(rumor_points > 0)
		parts += "[rumor_points] Rumor Points"
	var/warrant = round(warrant_consumed * fraction)
	if(warrant > 0)
		parts += "[warrant]p to the defense warrant"
	return english_list(parts, nothing_text = "")

/datum/quest/proc/refund_issuer_funding(reason, mob/actor, fraction = REFUND_ON_NOT_TAKEN)
	. = describe_issuer_refund(fraction)
	var/label = get_title() || quest_type
	for(var/list/source as anything in funding_sources)
		var/datum/fund/fund = source["fund"]
		var/amount = round(source["amount"] * fraction)
		if(amount <= 0)
			continue
		SStreasury.mint(fund, amount, "[reason] - [label]", null, SStreasury.commitment_account(fund))
		if(fund == SStreasury.burgher_pledge_fund)
			record_round_statistic(STATS_PLEDGE_CONSUMED, -amount)
		record_round_statistic(STATS_CONTRACT_MAMMONS_REFUNDED, amount)
	funding_sources = null
	var/rumor_points = round(funding_rumor_points * fraction, 0.1)
	if(rumor_points > 0)
		SStreasury.rumor_points += rumor_points
		record_round_statistic(STATS_RUMOR_POINTS_CONSUMED, -rumor_points)
	funding_rumor_points = 0
	var/warrant = round(warrant_consumed * fraction)
	if(warrant > 0)
		SScity_assembly?.refund_defense(warrant, actor, "[reason] - [label]")
	warrant_consumed = 0

/datum/quest/proc/mark_issue_log(status, refund_text)
	if(!issue_log_entry)
		return
	issue_log_entry["status"] = status
	issue_log_entry["refund"] = refund_text

/datum/quest/proc/on_issuer_withdrawn(mob/withdrawer)
	return

/datum/quest/proc/may_be_withdrawn()
	return TRUE
