/obj/structure/roguemachine/contractledger
	name = "Grand Contract Ledger"
	desc = "A massive ledger book with gilded edges, sitting atop a pedestal with the Mercenary's Guild banner. Its myriad enchanted pages are filled with various contracts and bounties issued by Mercenary's Guild, with arcane scripts that appears and fades as contracts are issued and completed."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "contractledger"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	layer = GAME_PLANE_UPPER
	/// Turf south of the ledger, marked with a drop-here decal. Retrieval-quest items carry a
	/// component that consumes them on any tile bearing this decal.
	var/input_point
	/// Directive quota tracking. Reset when GLOB.dayspassed advances past directives_day_stamp.
	var/directives_issued_today = 0
	var/directives_day_stamp = -1

/obj/structure/roguemachine/contractledger/Initialize()
	. = ..()
	input_point = locate(x, y - 1, z)
	var/obj/effect/decal/marker_export/marker = new(get_turf(input_point))
	marker.desc = "Drop retrieval-quest items here to turn them in."
	marker.layer = ABOVE_OBJ_LAYER
	SSquestpool.registered_ledgers += src

/obj/structure/roguemachine/contractledger/Destroy()
	SSquestpool.registered_ledgers -= src
	return ..()

/// Lazy-reset of the daily directive quota. Called wherever directive state is read or
/// mutated — cheap comparison, auto-rolls over when GLOB.dayspassed advances.
/obj/structure/roguemachine/contractledger/proc/refresh_directive_quota()
	if(directives_day_stamp != GLOB.dayspassed)
		directives_day_stamp = GLOB.dayspassed
		directives_issued_today = 0

/obj/structure/roguemachine/contractledger/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("<b>Left click</b> to open the Grand Contract Ledger, where you can sign new contracts and abandon ones you hold.")
	. += span_info("To <b>turn in</b> a completed contract, click the ledger while holding the quest scroll.")
	. += span_info("Retrieval-quest items should be <b>dropped onto the marked tile</b> in front of the ledger.")
	. += span_info("Abandoning a contract forfeits its deposit to the treasury and places you under a brief guild cooldown before you may abandon another.")
	. += span_info("The <b>Innkeeper</b> may compose rumor contracts here, spending Rumor Points to seed retrieval, courier, and light kill jobs across the realm.")
	. += span_info("The <b>[english_list(GLOB.contract_ledger_commission_roles)]</b> may commission defense writs here - paid from the Burgher Pledge, the Crown's Purse, or issued as an unfunded Request. The Steward is the primary commissioner; the others substitute if the Steward is absent. A Regent sitting in the Lord's absence inherits commission authority for the duration of their regency.")

/obj/structure/roguemachine/contractledger/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = ..()
	if(istype(P, /obj/item/quest_writ))
		turn_in_contract(user, P)
		return
	return

/obj/structure/roguemachine/contractledger/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	ui_interact(user)

/obj/structure/roguemachine/contractledger/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/contractledger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ContractLedger")
		ui.open()

/obj/structure/roguemachine/contractledger/ui_data(mob/user)
	var/list/data = list()
	var/datum/job/mob_job = user?.job ? SSjob.GetJob(user.job) : null
	data["is_handler"] = !!mob_job?.is_quest_giver
	data["balance"] = SStreasury.get_balance(user)
	data["has_account"] = SStreasury.has_account(user)
	data["active_max"] = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	data["active_count"] = count_user_active_contracts(user)
	var/gate_remaining = 0
	if(!is_townie_contract_gate_exempt(user))
		var/elapsed = world.time - SSticker.round_start_time
		if(elapsed < CONTRACT_TOWNIE_GATE_TIME)
			gate_remaining = round((CONTRACT_TOWNIE_GATE_TIME - elapsed) / 10)
	data["townie_gate_remaining"] = gate_remaining
	data["townie_contract_gate_exempt_jobs"] = SSjob.townie_contract_gate_exempt_display_names()
	data["take_cooldown_remaining"] = round(SSquestpool.take_cooldown_remaining(user) / 10)
	var/mob/living/L = user
	var/datum/fellowship/F = istype(L) ? L.current_fellowship : null
	data["user_fellowship_size"] = F ? length(F.get_members()) : 0
	data["pool"] = build_pool_listing()
	data["active"] = build_active_listing(user)
	data["regions"] = build_region_listing()
	data["tax_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
	data["guild_cut_rate"] = GUILD_REFERRAL_FEE_PCT
	data["dynamic_role"] = resolve_dynamic_role(user)
	if(data["dynamic_role"] == "innkeeper")
		data["rumor_points"] = round(SStreasury.rumor_points, 0.1)
		data["rumor_refill_base"] = RUMOR_POINTS_BASE_REFILL
		data["rumor_refill_per_player"] = RUMOR_POINTS_PER_PLAYER
		data["rumor_active_players"] = get_active_player_count()
		data["rumor_costs"] = GLOB.rumor_point_costs.Copy()
		data["rumor_regions_by_type"] = build_rumor_regions_by_type()
		data["rumor_destinations"] = build_rumor_destinations()
		data["rumor_log"] = SStreasury.rumor_log
		data["rumor_lucrative_mult"] = RUMOR_LUCRATIVE_MULT
	if(data["dynamic_role"] == "steward")
		data["pledge_balance"] = SStreasury.burgher_pledge_fund ? SStreasury.burgher_pledge_fund.balance : 0
		data["pledge_refill_base"] = BURGHER_PLEDGE_BASE_REFILL
		data["pledge_refill_per_player"] = BURGHER_PLEDGE_PER_PLAYER
		data["pledge_active_players"] = get_active_player_count()
		data["pledge_available"] = SStreasury.burgher_pledge_fund ? TRUE : FALSE
		// Guild Charter of Arms tribute contributes a flat bonus to the Pledge refill when active.
		var/datum/decree/arms_charter = SStreasury.get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
		data["pledge_guild_bonus"] = (arms_charter?.active) ? GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS : 0
		var/datum/decree/golden = SStreasury.get_decree(DECREE_GOLDEN_BULL)
		data["pledge_golden_active"] = (golden?.active) ? TRUE : FALSE
		data["crown_purse_balance"] = SStreasury?.discretionary_fund?.balance || 0
		data["defense_costs"] = GLOB.defense_quest_tier_costs.Copy()
		data["defense_regions_by_type"] = build_defense_regions_by_type()
		data["region_tp_multipliers"] = build_region_tp_multipliers()
		data["defense_destinations"] = build_rumor_destinations()
		data["defense_log"] = SStreasury.defense_log
		data["blockade_recall_list"] = build_blockade_recall_list()
		data["blockade_recall_window_seconds"] = BLOCKADE_RECALL_WINDOW_DS / 10
		data["bonus_pay_light_mult"] = COMMISSION_BONUS_PAY_LIGHT_MULT
		data["bonus_pay_full_mult"] = COMMISSION_BONUS_PAY_MULT
		refresh_directive_quota()
		data["directives_per_day"] = COMMISSION_REQUESTS_PER_DAY
		data["directives_issued_today"] = directives_issued_today
	return data

/// Jobs that can access the Steward commission panel. The Steward is the primary commissioner;
/// the rest are substitutes so that blockade defense doesn't get crippled when the Steward is
/// absent, dead, or otherwise occupied. Expand here if more authority roles need standing.
GLOBAL_LIST_INIT(contract_ledger_commission_roles, list(
	"Steward",
	"Grand Duke",
	"Hand",
	"Clerk",
	"Marshal",
	"Councillor",
))

/// TRUE if the user has standing to commission defense writs - either by job, or by sitting as
/// the current Regent (Regent inherits commission authority for the duration of their regency,
/// so a Consort or Prince crowned by the Titan gains access they wouldn't otherwise have).
/obj/structure/roguemachine/contractledger/proc/can_commission(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.contract_ledger_commission_roles)
		return TRUE
	if(SSticker?.regentmob == user)
		return TRUE
	if(SScity_assembly?.is_alderman(user) && SScity_assembly.current_warrant?.defense_remaining > 0)
		return TRUE
	return FALSE

/// Return the dynamic-tab role key for this user, or null. Extend here when a new job earns its
/// own ledger panel (e.g. steward).
/obj/structure/roguemachine/contractledger/proc/resolve_dynamic_role(mob/user)
	if(user?.job == "Innkeeper")
		return "innkeeper"
	if(can_commission(user))
		return "steward"
	return null

/obj/structure/roguemachine/contractledger/proc/build_region_listing()
	var/list/known = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		known += TR.region_name
	return known

/obj/structure/roguemachine/contractledger/proc/build_pool_listing()
	var/list/listing = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool)
		var/expected_count = Q.progress_required
		var/threat_bands = 0
		if(istype(Q, /datum/quest/kill))
			var/datum/quest/kill/KQ = Q
			threat_bands = KQ.threat_bands_cleared
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "Unnamed Contract",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"reward" = Q.reward_amount,
			"deposit" = Q.deposit_amount,
			"area" = Q.target_spawn_area,
			"region" = Q.region,
			"objective" = Q.get_objective_text(),
			"expected_count" = expected_count,
			"threat_bands" = threat_bands,
			"levy_exempt" = Q.levy_exempt,
			"is_rumor" = Q.source == QUEST_SOURCE_RUMOR,
			"is_defense" = Q.source == QUEST_SOURCE_DEFENSE,
			"required_fellowship_size" = Q.required_fellowship_size,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/build_active_listing(mob/user)
	var/list/listing = list()
	var/datum/weakref/user_ref = WEAKREF(user)
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q)
			continue
		if(Q.quest_receiver_reference != user_ref)
			continue
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "Unnamed Contract",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"area" = Q.target_spawn_area,
			"region" = Q.region,
			"progress_current" = Q.progress_current,
			"progress_required" = Q.progress_required,
			"complete" = Q.complete,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/count_user_active_contracts(mob/user)
	var/datum/weakref/user_ref = WEAKREF(user)
	var/count = 0
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.complete)
			continue
		if(Q.quest_receiver_reference == user_ref)
			count++
	return count

/obj/structure/roguemachine/contractledger/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user?.Adjacent(src))
		return TRUE
	switch(action)
		if("sign")
			sign_contract(user, params["ref"])
			return TRUE
		if("abandon")
			abandon_by_ref(user, params["ref"])
			return TRUE
		if("compose_rumor")
			compose_rumor_from_tgui(user, params)
			return TRUE
		if("commission_defense")
			commission_defense_from_tgui(user, params)
			return TRUE
		if("recall_blockade_writ")
			recall_blockade_writ_from_tgui(user, params)
			return TRUE
