/obj/structure/roguemachine/contractledger
	name = "Contract Ledger"
	desc = "A massive ledger book with gilded edges sits atop a pedestal with the Mercenary's Guild banner. Its myriad enchanted pages are filled with contracts issued by the Mercenary's Guild. Arcane scripts appear and fade on them as contracts are issued and completed."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "contractledger"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	layer = GAME_PLANE_UPPER
	var/input_point
	var/directives_issued_today = 0
	var/directives_day_stamp = -1

/obj/structure/roguemachine/contractledger/Initialize(mapload)
	. = ..()
	input_point = locate(x, y - 1, z)
	var/obj/effect/decal/marker_export/marker = new(get_turf(input_point))
	marker.desc = "Drop items for retrieval contracts here to turn them in."
	marker.layer = ABOVE_OBJ_LAYER
	SSquestpool.registered_ledgers += src

/obj/structure/roguemachine/contractledger/Destroy()
	SSquestpool.registered_ledgers -= src
	return ..()

/obj/structure/roguemachine/contractledger/proc/refresh_directive_quota()
	if(directives_day_stamp != GLOB.dayspassed)
		directives_day_stamp = GLOB.dayspassed
		directives_issued_today = 0

/obj/structure/roguemachine/contractledger/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("<b>Left-click</b> to open the Contract Ledger, where you can sign new contracts and abandon ones you hold.")
	. += span_info("To <b>turn in</b> a completed contract, click the Ledger while holding its scroll.")
	. += span_info("Items for retrieval contracts should be <b>dropped onto the marked tile</b> in front of the Ledger.")
	. += span_info("Abandoning a contract forfeits its deposit. If you sign as many contracts as you can hold within [QUEST_TAKE_COOLDOWN / (1 MINUTES)] minutes, you must wait before signing another.")
	. += span_info("Heads from <b>contract targets</b> fetch nothing at a HEADEATER, because the contract's reward already covers them. Heads from beasts and brigands you kill outside a contract still sell there.")
	. += span_info("The <b>Innkeeper and their tavern staff</b> (Cook, Tapster) may compose rumor contracts here. They spend Rumor Points to seed contracts across the realm.")
	. += span_info("The <b>[english_list(GLOB.crown_authority_roles)]</b> can issue defense scrolls here. Scrolls are paid from the Burgher Pledge or the Treasury. A scroll can also go out as an unpaid Request. If the Pledge runs short, the Treasury can make up the difference. A Regent ruling in the Grand Duke's absence can issue scrolls while they rule.")
	. += span_info("You can <b>withdraw</b> any contract or scroll you issued from the Issued tab at any time while no one has taken it. Once someone takes it, you must wait [QUEST_ISSUER_CANCEL_WINDOW / (1 MINUTES)] minutes. You can't withdraw it once the work has begun. The full cost is refunded. Postings that lapse are refunded automatically.")
	. += span_info("Some <b>townsfolk</b> can post contracts of their own and pay for them with their own coin. They can pin them to the Ledger or hand them over in person. The <b>[english_list(GLOB.crown_authority_roles)]</b> can post any of them. The Treasury pays [TOWNER_POSTING_CROWN_COST_MULT] times the price. Only the poster can open what is recovered.")
	. += span_info("Your <b>fellowship</b> can turn in contracts you hold if you fall in battle. The reward goes to whoever turns it in. Their levy exemption applies if they have one.")
	// TODO: flavor - plain placeholder, rewrite
	. += span_info("A <b>fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT] or more</b> can put up a stake of <b>[HOARD_RECOVERY_PLEDGE] mammon</b> to call for a <b>Hoard Recovery</b> in a region whose brigand hoard has reached <b>[HOARD_RECOVERY_HOARD_MINIMUM] mammon</b>. It pays the usual blockade reward. The Crown taxes the recovered hoard as <b>Recovered Spoils</b>. Crown officials can also issue a hoard recovery scroll like any other defense scroll.")
	. += span_info("A ghost may take up a <b>Notorious Bounty</b> and play the outlaw fighting against you. Its reward then rises by <b>[NOTORIOUS_BOUNTY_PLAYER_BONUS] mammon</b>. If no one answers, it rises by <b>[NOTORIOUS_BOUNTY_NPC_BONUS]</b>.")
	. += span_info("The <b>[english_list(GLOB.contract_proxy_officials)]</b> may turn in any completed contract on the holder's behalf. The reward goes to the holder's own account. They take no cut.")

/obj/structure/roguemachine/contractledger/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = ..()
	if(istype(P, /obj/item/quest_writ/blockade))
		post_blockade_writ(user, P)
		return
	if(istype(P, /obj/item/quest_writ))
		turn_in_contract(user, P)
		return
	return

/obj/structure/roguemachine/contractledger/proc/post_blockade_writ(mob/living/carbon/human/user, obj/item/quest_writ/blockade/writ)
	var/datum/quest/kill/blockade_defense/Q = writ.assigned_quest
	if(!istype(Q))
		return
	if(Q.is_directive)
		to_chat(user, span_warning("You can't pin a Request to the Ledger. Hand it to whoever will take it on."))
		return
	if(Q.quest_receiver_reference)
		to_chat(user, span_warning("Someone has already taken this scroll. You can't pin it."))
		return
	if(Q in SSquestpool.pool)
		to_chat(user, span_warning("This scroll is already pinned to the Ledger."))
		return
	if(Q.blockade_ref && !Q.blockade_ref.resolve())
		to_chat(user, span_warning("The blockade this scroll answers has already been lifted."))
		return
	Q.required_fellowship_size = BLOCKADE_FELLOWSHIP_REQUIREMENT
	Q.created_at = world.time
	Q.quest_scroll = null
	Q.quest_scroll_ref = null
	writ.assigned_quest = null
	SSquestpool.pool += Q
	var/datum/blockade/B = Q.blockade_ref.resolve()
	if(B)
		B.active_scroll_ref = null
	playsound(src, 'sound/items/inqslip_sealed.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("You pin the [writ.name] to the Ledger. It now needs a fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT] to sign."))
	qdel(writ)

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
	var/active_base = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	var/active_bonus = get_active_quest_fellowship_bonus(user)
	data["active_max"] = active_base + active_bonus
	data["active_max_base"] = active_base
	data["active_fellowship_bonus"] = active_bonus
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
	data["hoard_recovery_regions"] = build_hoard_recovery_region_listing()
	data["hoard_recovery_pledge"] = HOARD_RECOVERY_PLEDGE
	data["hoard_recovery_fellowship_min"] = BLOCKADE_FELLOWSHIP_REQUIREMENT
	data["hoard_recovery_hoard_min"] = HOARD_RECOVERY_HOARD_MINIMUM
	data["townie_gate_minutes"] = CONTRACT_TOWNIE_GATE_TIME / (1 MINUTES)
	data["blockade_defender_min"] = BLOCKADE_DEFENDER_SCALE_MIN
	data["blockade_defender_max"] = BLOCKADE_DEFENDER_SCALE_MAX
	data["blockade_extra_defender_pct"] = round(BLOCKADE_REWARD_PER_EXTRA_DEFENDER * 100)
	data["towner_crown_cost_mult"] = TOWNER_POSTING_CROWN_COST_MULT
	data["fellowship_bonus_pair"] = QUEST_ACTIVE_FELLOWSHIP_BONUS_PAIR
	data["fellowship_bonus_band"] = QUEST_ACTIVE_FELLOWSHIP_BONUS_BAND
	data["scout_regions"] = SSregionthreat.build_scout_region_rows()
	data["spoils_tax_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_RECOVERED_SPOILS)
	data["tax_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
	data["guild_cut_rate"] = GUILD_REFERRAL_FEE_PCT
	data["can_proxy_turnin"] = (user.job in GLOB.contract_proxy_officials)
	data["can_admin_complete"] = check_rights_for(user?.client, R_DEBUG) ? TRUE : FALSE
	data["issuer_cancel_window_minutes"] = QUEST_ISSUER_CANCEL_WINDOW / (1 MINUTES)
	var/list/dynamic_roles = resolve_dynamic_roles(user)
	data["dynamic_roles"] = dynamic_roles
	data["dynamic_role"] = length(dynamic_roles) ? dynamic_roles[1] : null
	if("innkeeper" in dynamic_roles)
		data["rumor_points"] = round(SStreasury.rumor_points, 0.1)
		data["rumor_refill_base"] = RUMOR_POINTS_BASE_REFILL
		data["rumor_refill_per_player"] = RUMOR_POINTS_PER_PLAYER
		data["rumor_active_players"] = get_active_player_count()
		data["rumor_costs"] = GLOB.rumor_point_costs.Copy()
		data["rumor_regions_by_type"] = build_rumor_regions_by_type()
		data["rumor_destinations"] = build_rumor_destinations()
		data["rumor_log"] = SStreasury.rumor_log
		data["rumor_issued"] = build_issued_listing(list(QUEST_SOURCE_RUMOR))
		data["rumor_lucrative_mult"] = RUMOR_LUCRATIVE_MULT
	if("steward" in dynamic_roles)
		data["is_alderman_acting"] = (SScity_assembly?.is_alderman(user) && user.job != "Steward") ? TRUE : FALSE
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
		data["blockade_region_labels"] = build_blockade_region_labels()
		data["defense_destinations"] = build_rumor_destinations()
		data["defense_log"] = SStreasury.defense_log
		data["defense_issued"] = build_issued_listing(list(QUEST_SOURCE_DEFENSE, QUEST_SOURCE_BLOCKADE))
		data["active_writ_regions"] = build_active_writ_regions()
		data["bonus_pay_light_mult"] = COMMISSION_BONUS_PAY_LIGHT_MULT
		data["bonus_pay_full_mult"] = COMMISSION_BONUS_PAY_MULT
		refresh_directive_quota()
		data["directives_per_day"] = COMMISSION_REQUESTS_PER_DAY
		data["directives_issued_today"] = directives_issued_today
	if("towner" in dynamic_roles)
		data["towner_postings"] = build_towner_posting_listing(user)
		data["towner_purse_balance"] = SStreasury?.discretionary_fund?.balance || 0
	return data

GLOBAL_LIST_INIT(crown_authority_roles, list(
	"Steward",
	"Grand Duke",
	"Hand",
	"Clerk",
	"Marshal",
	"Councillor",
	"Prince",
))

GLOBAL_LIST_INIT(contract_proxy_officials, list(
	"Steward",
	"Clerk",
))

/obj/structure/roguemachine/contractledger/proc/can_commission(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.crown_authority_roles)
		return TRUE
	if(SSticker?.regentmob == user)
		return TRUE
	if(SScity_assembly?.is_alderman(user) && SScity_assembly.current_warrant?.defense_remaining > 0)
		return TRUE
	return FALSE

/obj/structure/roguemachine/contractledger/proc/resolve_dynamic_roles(mob/user)
	var/list/roles = list()
	if(user?.job in GLOB.tavern_positions)
		roles += "innkeeper"
	if(can_commission(user))
		roles += "steward"
	roles += "towner"
	return roles

/obj/structure/roguemachine/contractledger/proc/build_region_listing()
	var/list/known = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		known += TR.region_name
	return known

/obj/structure/roguemachine/contractledger/proc/build_hoard_recovery_region_listing()
	var/list/listing = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
			continue
		// A true blockade takes precedence
		if(TR.has_active_blockade())
			continue
		var/datum/quest/existing = TR.active_hoard_recovery_ref?.resolve()
		listing += list(list(
			"region" = TR.region_name,
			"hoard" = TR.banditry_hoard,
			"danger" = TR.get_danger_level(),
			"active" = (existing && !QDELETED(existing)) ? TRUE : FALSE,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/request_hoard_recovery(mob/living/carbon/human/user, region_name)
	if(!ishuman(user))
		return
	var/datum/threat_region/TR = SSregionthreat.get_region(region_name)
	if(!TR)
		return
	if(TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
		to_chat(user, span_warning("The hoard in [TR.region_name] is under [HOARD_RECOVERY_HOARD_MINIMUM] mammon. You can't call a recovery for it yet."))
		return
	if(TR.has_active_blockade())
		to_chat(user, span_warning("[TR.region_name] is under blockade. Clear it with a Blockade Defense scroll instead."))
		return
	var/datum/quest/existing = TR.active_hoard_recovery_ref?.resolve()
	if(existing && !QDELETED(existing))
		to_chat(user, span_warning("A recovery scroll for [TR.region_name] is already in circulation."))
		return
	var/datum/fellowship/F = user.current_fellowship
	if(!F || length(F.get_members()) < BLOCKADE_FELLOWSHIP_REQUIREMENT)
		to_chat(user, span_warning("You need a fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT] or more to call for a Hoard Recovery."))
		return
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("You have no bank account. Register with a Meister first."))
		return
	var/datum/fund/pledge_account = SStreasury.get_account(user)
	if(SStreasury.get_balance(user) < HOARD_RECOVERY_PLEDGE)
		to_chat(user, span_warning("You need [HOARD_RECOVERY_PLEDGE] mammon in your account for the stake."))
		return
	if(!SStreasury.burn(pledge_account, HOARD_RECOVERY_PLEDGE, "Hoard Recovery stake ([TR.region_name])"))
		to_chat(user, span_warning("The deposit could not be taken from your account."))
		return
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_hoard_recovery_request(TR, user)
	if(!Q)
		SStreasury.mint(pledge_account, HOARD_RECOVERY_PLEDGE, "Hoard Recovery deposit refund (issue failure)")
		to_chat(user, span_warning("No recovery scroll can be raised for [TR.region_name] right now. Your deposit is returned."))
		return
	Q.add_funding(pledge_account, HOARD_RECOVERY_PLEDGE)
	playsound(src, 'sound/items/inqslip_sealed.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("Recovery scroll issued for [TR.region_name]."))
	SSquestpool.log_event("hoard_recovery_request", "[user.real_name] called a hoard recovery on [TR.region_name] (hoard [TR.banditry_hoard], pledge [HOARD_RECOVERY_PLEDGE])")

/obj/structure/roguemachine/contractledger/proc/build_pool_listing()
	var/list/listing = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool)
		var/expected_count = Q.progress_required
		var/threat_bands = 0
		if(istype(Q, /datum/quest/kill))
			var/datum/quest/kill/KQ = Q
			threat_bands = KQ.threat_bands_cleared
		var/lapse_minutes = max(0, round((Q.get_lapse_time() - world.time) / 600, 1))
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
			"guild_cut_exempt" = Q.guild_cut_exempt,
			"is_rumor" = Q.source == QUEST_SOURCE_RUMOR,
			"is_defense" = Q.source == QUEST_SOURCE_DEFENSE || Q.source == QUEST_SOURCE_BLOCKADE,
			"is_towner" = Q.source == QUEST_SOURCE_TOWNER,
			"is_standing" = Q.source == QUEST_SOURCE_RUMOR || Q.source == QUEST_SOURCE_DEFENSE || Q.source == QUEST_SOURCE_TOWNER || Q.source == QUEST_SOURCE_BLOCKADE,
			"required_fellowship_size" = Q.required_fellowship_size,
			"lapse_minutes" = lapse_minutes,
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

/proc/get_active_quest_fellowship_bonus(mob/user)
	var/mob/living/L = user
	if(!istype(L))
		return 0
	var/datum/fellowship/F = L.current_fellowship
	if(!F || !F.is_leader(L))
		return 0
	var/size = length(F.get_members())
	if(size >= 3)
		return QUEST_ACTIVE_FELLOWSHIP_BONUS_BAND
	if(size >= 2)
		return QUEST_ACTIVE_FELLOWSHIP_BONUS_PAIR
	return 0

/proc/get_active_quest_cap(mob/user)
	var/datum/job/J = user?.job ? SSjob.GetJob(user.job) : null
	var/base = J?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	return base + get_active_quest_fellowship_bonus(user)

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
		if("admin_complete")
			admin_complete_by_ref(user, params["ref"])
			return TRUE
		if("compose_rumor")
			compose_rumor_from_tgui(user, params)
			return TRUE
		if("commission_defense")
			commission_defense_from_tgui(user, params)
			return TRUE
		if("compose_towner")
			compose_towner_from_tgui(user, params)
			return TRUE
		if("request_hoard_recovery")
			request_hoard_recovery(user, params["region"])
			return TRUE
		if("cancel_issued")
			cancel_issued_from_tgui(user, params["ref"])
			return TRUE

/obj/structure/roguemachine/contractledger/proc/can_cancel_issued(mob/user, datum/quest/Q)
	if(!Q.office_may_withdraw())
		return FALSE
	switch(Q.source)
		if(QUEST_SOURCE_RUMOR)
			return (user.job in GLOB.tavern_positions)
		if(QUEST_SOURCE_DEFENSE, QUEST_SOURCE_BLOCKADE)
			return can_commission(user)
	return FALSE

/obj/structure/roguemachine/contractledger/proc/build_issued_listing(list/sources)
	var/list/out = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool)
		if((Q.source in sources) && Q.office_may_withdraw())
			out += list(build_issued_entry(Q, "On the Ledger"))
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || !(Q.source in sources) || !Q.office_may_withdraw())
			continue
		var/status
		if(!Q.quest_receiver_reference)
			status = "Unclaimed scroll"
		else if(Q.complete)
			status = "Fulfilled by [Q.quest_receiver_name] and waiting to be handed in"
		else
			status = "Taken by [Q.quest_receiver_name]"
		out += list(build_issued_entry(Q, status))
	return out

/obj/structure/roguemachine/contractledger/proc/build_issued_entry(datum/quest/Q, status)
	return list(
		"ref" = REF(Q),
		"title" = Q.get_title() || Q.quest_type,
		"type" = Q.quest_type,
		"region" = Q.region,
		"issued_by" = Q.quest_giver_name,
		"minutes_elapsed" = max(0, round((world.time - Q.created_at) / (1 MINUTES))),
		"reward" = Q.reward_amount,
		"is_directive" = Q.is_directive,
		"status" = status,
		"cancel_blocker" = Q.issuer_cancel_blocker(),
		"refund" = Q.describe_issuer_refund(),
	)

/obj/structure/roguemachine/contractledger/proc/find_issued_quest(ref)
	var/datum/quest/Q = locate(ref) in SSquestpool.pool
	if(Q)
		return Q
	for(var/obj/item/quest_writ/scroll in GLOB.quest_scrolls)
		if(scroll.assigned_quest && REF(scroll.assigned_quest) == ref)
			return scroll.assigned_quest
	return null

/obj/structure/roguemachine/contractledger/proc/cancel_issued_from_tgui(mob/user, ref)
	if(!ishuman(user) || !ref)
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(user, span_warning("The Ledger is not yet open."))
		return
	var/datum/quest/Q = find_issued_quest(ref)
	if(!Q)
		to_chat(user, span_warning("That contract is no longer in circulation."))
		return
	if(!can_cancel_issued(user, Q))
		to_chat(user, span_warning("That contract is not yours to withdraw."))
		return
	var/blocker = Q.issuer_cancel_blocker()
	if(blocker)
		to_chat(user, span_warning("You can't withdraw this contract: [blocker]."))
		return
	var/label = Q.get_title() || Q.quest_type
	var/refund_text = Q.refund_issuer_funding("Contract withdrawn by [user.real_name]", user)
	Q.mark_issue_log(QUEST_ISSUE_STATUS_WITHDRAWN, refund_text)
	var/deposit_returned = 0
	if(Q.deposit_payer && Q.deposit_paid > 0)
		SStreasury.mint(Q.deposit_payer, Q.deposit_paid, "Deposit returned - [label] withdrawn")
		deposit_returned = Q.deposit_paid
	var/mob/bearer = Q.quest_receiver_reference?.resolve()
	if(bearer)
		to_chat(bearer, span_warning("The contract <b>[label]</b> has been withdrawn by its issuer. The scroll crumbles to dust.[deposit_returned ? " Your deposit of [deposit_returned] mammon is returned." : ""]"))
	var/obj/item/quest_writ/writ = Q.quest_scroll_ref?.resolve()
	var/mob/holder = writ ? get(writ, /mob) : null
	if(holder && holder != bearer && holder != user)
		to_chat(holder, span_warning("\The [writ] you carry crumbles to dust. Its issuer has withdrawn the contract."))
	var/log_text = "[Q.source] [Q.quest_type] \"[label]\" (refunded [refund_text || "nothing"][deposit_returned ? ", deposit [deposit_returned] to [Q.quest_receiver_name]" : ""])"
	Q.on_issuer_withdrawn(user)
	SSquestpool.remove_from_pool(Q)
	record_round_statistic(STATS_CONTRACTS_WITHDRAWN)
	if(Q.quest_receiver_reference)
		record_contract_stat(Q, CONTRACT_STAT_WITHDRAWN)
	SSquestpool.log_event("withdraw", "[SSquestpool.describe_user(user)] withdrew [log_text]")
	log_quest(user.ckey, user.mind, user, "Withdraw [log_text]")
	qdel(Q)
	playsound(src, 'sound/items/inqslip_sealed.ogg', 50, FALSE, -1)
	to_chat(user, span_notice("Contract withdrawn: <b>[label]</b>.[refund_text ? " Refunded [refund_text]." : ""]"))
