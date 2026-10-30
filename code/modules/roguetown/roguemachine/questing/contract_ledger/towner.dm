/proc/get_user_advclass_path(mob/user)
	if(!ishuman(user))
		return null
	var/datum/advclass/AC = user?.mind?.picked_advclass
	if(!AC)
		return null
	return AC.type

/proc/towner_trade_can_post(mob/user, posting_type)
	var/datum/quest/kill/recovery/towner/proto = get_towner_prototype(posting_type)
	if(!proto)
		return FALSE
	var/path = get_user_advclass_path(user)
	if(!path)
		return FALSE
	return (path in proto.postable_advclasses)

/proc/user_can_post_crown_towner(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.crown_authority_roles)
		return TRUE
	if(SSticker?.regentmob == user)
		return TRUE
	return FALSE

/proc/user_can_post_company_towner(mob/user)
	if(!user)
		return FALSE
	return (user.job in GLOB.atc_positions)

/proc/towner_posting_funder(mob/user, posting_type)
	if(!get_towner_prototype(posting_type))
		return null
	if(user_can_post_company_towner(user))
		return TOWNER_FUNDER_COMPANY
	if(towner_trade_can_post(user, posting_type))
		return TOWNER_FUNDER_PERSONAL
	if(user_can_post_crown_towner(user))
		return TOWNER_FUNDER_CROWN
	return null

/proc/towner_posting_cost(tier, funder)
	var/base = get_towner_tier_term(tier, "cost")
	switch(funder)
		if(TOWNER_FUNDER_CROWN)
			return round(base * TOWNER_POSTING_CROWN_COST_MULT)
		if(TOWNER_FUNDER_COMPANY)
			return round(base * TOWNER_POSTING_COMPANY_COST_MULT)
	return base

/proc/towner_funder_fund(mob/user, funder)
	switch(funder)
		if(TOWNER_FUNDER_CROWN)
			return SStreasury.discretionary_fund
		if(TOWNER_FUNDER_COMPANY)
			return SStreasury.merchant_fund
		if(TOWNER_FUNDER_PERSONAL)
			return SStreasury.get_account(user)
	return null

/proc/towner_funder_label(funder)
	switch(funder)
		if(TOWNER_FUNDER_CROWN)
			return "the Treasury"
		if(TOWNER_FUNDER_COMPANY)
			return "the ATC"
	return "your account"

/proc/towner_funder_log_label(funder)
	switch(funder)
		if(TOWNER_FUNDER_CROWN)
			return "crown purse"
		if(TOWNER_FUNDER_COMPANY)
			return "ATC coffers"
	return "personal"

/proc/count_active_towner_postings(mob/user)
	. = 0
	var/datum/weakref/user_ref = WEAKREF(user)
	for(var/datum/quest/Q as anything in SSquestpool.pool + get_scroll_quests())
		if(Q.source == QUEST_SOURCE_TOWNER && Q.quest_giver_reference == user_ref && !Q.complete)
			.++

/proc/towner_advclass_names(list/paths)
	var/list/out = list()
	for(var/path in paths)
		var/datum/advclass/AC = path
		var/n = initial(AC.name)
		if(n)
			out += n
	return out

/proc/towner_bearer_summary(tier)
	var/bonus = get_towner_tier_term(tier, "flat_bonus") || 0
	if(bonus > 0)
		return "combat & distance pay + [bonus]m bonus"
	return "combat & distance pay"

/proc/towner_spec_summary(list/spec)
	if(!length(spec))
		return "a modest haul"
	var/list/parts = list()
	for(var/list/entry in spec)
		var/noun = entry["noun"] || "goods"
		var/lo = entry["min"]
		var/hi = entry["max"]
		if(entry["prob"] != null && entry["prob"] < 100)
			parts += "a chance of [noun]"
		else if(lo == hi)
			parts += "[lo] [noun]"
		else
			parts += "[lo]-[hi] [noun]"
	return english_list(parts)

/proc/towner_variety_listing(posting_type)
	var/datum/quest/kill/recovery/towner/proto = get_towner_prototype(posting_type)
	var/list/vtable = proto?.varieties
	if(!length(vtable))
		return list()
	var/list/out = list()
	for(var/key in vtable)
		var/list/meta = vtable[key]
		var/list/poster_summaries = list()
		var/list/meta_tiers = meta["tiers"]
		for(var/tier in GLOB.towner_posting_tiers)
			poster_summaries[tier] = towner_spec_summary(meta_tiers?[tier])
		out += list(list(
			"key" = key,
			"label" = meta["label"],
			"blurb" = meta["blurb"],
			"poster_summaries" = poster_summaries,
		))
	return out

/proc/build_towner_posting_listing(mob/user)
	var/list/out = list()
	var/list/prototypes = get_towner_prototypes()
	for(var/posting_type in prototypes)
		var/datum/quest/kill/recovery/towner/proto = prototypes[posting_type]
		var/funder = towner_posting_funder(user, posting_type)
		var/list/tiers = list()
		for(var/tier in GLOB.towner_posting_tiers)
			tiers[tier] = list(
				"cost" = towner_posting_cost(tier, funder),
				"bearer_summary" = towner_bearer_summary(tier),
			)
		out += list(list(
			"type" = posting_type,
			"label" = proto.posting_label,
			"blurb" = proto.posting_blurb,
			"rules" = proto.posting_rules || list(),
			"eligible" = funder ? TRUE : FALSE,
			"eligible_jobs" = towner_advclass_names(proto.postable_advclasses),
			"funder" = funder,
			"tiers" = tiers,
			"varieties" = towner_variety_listing(posting_type),
		))
	return out

/obj/structure/roguemachine/contractledger/proc/compose_towner_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/poster = user
	if(!poster.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(poster, span_warning("The Ledger is not yet open."))
		return

	var/chosen_type = params["type"]
	if(!get_towner_prototype(chosen_type))
		to_chat(poster, span_warning("That posting type is not one the Guild accepts."))
		return

	var/funder = towner_posting_funder(poster, chosen_type)
	if(!funder)
		to_chat(poster, span_warning("Your trade does not post that contract."))
		return

	if(count_active_towner_postings(poster) >= TOWNER_MAX_ACTIVE_POSTINGS)
		to_chat(poster, span_warning("You already have [TOWNER_MAX_ACTIVE_POSTINGS] postings out. Withdraw one or wait for one to be fulfilled."))
		return

	var/tier = params["tier"]
	if(!(tier in GLOB.towner_posting_tiers))
		to_chat(poster, span_warning("That posting tier is not recognised."))
		return

	var/variety = params["variety"]
	var/datum/quest/kill/recovery/towner/chosen_proto = get_towner_prototype(chosen_type)
	var/list/vtable = chosen_proto?.varieties
	if(length(vtable))
		if(!variety || !(variety in vtable))
			variety = vtable[1]
	else
		variety = null
	var/cost = towner_posting_cost(tier, funder)
	if(!cost)
		return

	var/datum/fund/paying_fund = towner_funder_fund(poster, funder)
	if(!paying_fund)
		switch(funder)
			if(TOWNER_FUNDER_CROWN)
				to_chat(poster, span_warning("The Treasury isn't ready yet."))
			if(TOWNER_FUNDER_COMPANY)
				to_chat(poster, span_warning("The ATC's treasury is not ready yet."))
			else
				to_chat(poster, span_warning("You have no bank account."))
		return
	if(paying_fund.balance < cost)
		if(funder == TOWNER_FUNDER_PERSONAL)
			to_chat(poster, span_warning("You need [cost] mammon in your account to post this."))
		else
			to_chat(poster, span_warning("[capitalize(towner_funder_label(funder))] can't afford this. Need [cost]m, have [paying_fund.balance]m."))
		return
	var/burn_reason
	switch(funder)
		if(TOWNER_FUNDER_CROWN)
			burn_reason = "Crown townsfolk contract ([chosen_type])"
		if(TOWNER_FUNDER_COMPANY)
			burn_reason = "ATC townsfolk contract ([chosen_type])"
		else
			burn_reason = "townsfolk contract posting ([chosen_type])"
	if(!SStreasury.burn(paying_fund, cost, burn_reason, SStreasury.commitment_account(paying_fund)))
		to_chat(poster, span_warning("The payment didn't go through."))
		return
	if(funder == TOWNER_FUNDER_CROWN)
		record_treasury_expense(TREASURY_FLOW_CONTRACT, treasury_role_of(poster), cost)

	var/to_hand = (params["delivery"] == "hand")
	var/datum/quest/dispatched = SSquestpool.issue_towner_quest(chosen_type, poster, tier, to_hand, variety)
	if(!dispatched)
		SStreasury.mint(paying_fund, cost, "townsfolk contract posting refund (issue failure)", null, SStreasury.commitment_account(paying_fund))
		to_chat(poster, span_warning("No landmark could take that contract. Your funds are refunded."))
		return

	dispatched.add_funding(paying_fund, cost)

	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/purse_note = funder == TOWNER_FUNDER_PERSONAL ? "" : " Paid from [towner_funder_label(funder)]."
	if(to_hand)
		to_chat(poster, span_notice("Contract drawn up: <b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m).[purse_note] Hand it to whoever you want to hire."))
	else
		to_chat(poster, span_notice("Contract posted: <b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m).[purse_note] Only you can open the recovered goods."))
	log_game("[key_name(poster)] posted towner contract \"[dispatched.title || dispatched.quest_type]\" ([tier], [cost]m, [towner_funder_log_label(funder)], [to_hand ? "in hand" : "board"]).")
