GLOBAL_LIST_INIT(towner_posting_tier_costs, list(
	TOWNER_POSTING_TIER_EASY = TOWNER_POSTING_COST_EASY,
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_POSTING_COST_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_POSTING_COST_HARD,
))

GLOBAL_LIST_INIT(towner_posting_descriptors, list(
	QUEST_TOWNER_SMITH_CARAVAN = list(
		"label" = "A Caravan Gone Missing",
		"blurb" = "A wagon of yours was lost on the road. Hire hands to secure the wreck and bring the strongbox home.",
		"rules" = list(
			"The strongbox is magickally sealed to you - only you can open it.",
			"You need not travel; the bearer brings the strongbox to you.",
		),
		"postable_advclasses" = list(
			/datum/advclass/blacksmith,
			/datum/advclass/guildsman/blacksmith,
			/datum/advclass/guildsman/artificer,
			/datum/advclass/guildmaster,
		),
	),
	QUEST_TOWNER_MINER_OREVEIN = list(
		"label" = "A Miner's Lead",
		"blurb" = "You have prospected an elemental guarded vein and mined a good haul, before the guardians drove you away. Hire hands to slay the elementals and haul out the crate.",
		"rules" = list(
			"The crate is magickally sealed to you - only you can open it.",
			"You need not travel; the bearer brings the crate to you.",
		),
		"postable_advclasses" = list(
			/datum/advclass/miner,
			/datum/advclass/guildsman/architect,
			/datum/advclass/guildmaster,
		),
	),
))

/proc/get_user_advclass_path(mob/user)
	if(!ishuman(user))
		return null
	var/datum/advclass/AC = user?.mind?.picked_advclass
	if(!AC)
		return null
	return AC.type

/proc/towner_trade_can_post(mob/user, posting_type)
	var/list/desc = GLOB.towner_posting_descriptors[posting_type]
	if(!desc)
		return FALSE
	var/path = get_user_advclass_path(user)
	if(!path)
		return FALSE
	return (path in desc["postable_advclasses"])

/proc/user_can_post_crown_towner(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.crown_authority_roles)
		return TRUE
	if(SSticker?.regentmob == user)
		return TRUE
	return FALSE

/proc/towner_posting_is_crown_funded(mob/user, posting_type)
	if(towner_trade_can_post(user, posting_type))
		return FALSE
	return user_can_post_crown_towner(user)

/proc/user_can_post_towner_type(mob/user, posting_type)
	if(!GLOB.towner_posting_descriptors[posting_type])
		return FALSE
	if(towner_trade_can_post(user, posting_type))
		return TRUE
	return user_can_post_crown_towner(user)

/proc/user_can_post_any_towner(mob/user)
	for(var/posting_type in GLOB.towner_posting_descriptors)
		if(user_can_post_towner_type(user, posting_type))
			return TRUE
	return FALSE

/proc/towner_advclass_names(list/paths)
	var/list/out = list()
	for(var/path in paths)
		var/datum/advclass/AC = path
		var/n = initial(AC.name)
		if(n)
			out += n
	return out

/proc/towner_bearer_summary(tier)
	var/bonus = GLOB.towner_tier_flat_bonus[tier] || 0
	if(bonus > 0)
		return "combat & distance pay + [bonus]m bonus"
	return "combat & distance pay"

/proc/towner_tier_summary(posting_type, tier)
	switch(posting_type)
		if(QUEST_TOWNER_SMITH_CARAVAN)
			var/list/ranges = GLOB.towner_smith_caravan_bundle_ranges[tier]
			var/poster_summary = "?"
			if(ranges)
				poster_summary = "[ranges["iron"][1]]-[ranges["iron"][2]] iron, [ranges["bronze"][1]]-[ranges["bronze"][2]] bronze, [ranges["steel"][1]]-[ranges["steel"][2]] steel"
			return list(
				"bearer_summary" = towner_bearer_summary(tier),
				"poster_summary" = poster_summary,
			)
		if(QUEST_TOWNER_MINER_OREVEIN)
			var/poster_summary
			switch(tier)
				if(TOWNER_POSTING_TIER_HARD)
					poster_summary = "26-34 iron, 14-18 coal, 5-8 cinnabar, 3-5 gold, and two or three gems"
				if(TOWNER_POSTING_TIER_MEDIUM)
					poster_summary = "18-24 iron, 10-14 coal, 3-4 cinnabar, a bar or two of gold, and a good chance of a gem"
				else
					poster_summary = "13-18 iron, 8-11 coal, with a fair chance of gold"
			return list(
				"bearer_summary" = towner_bearer_summary(tier),
				"poster_summary" = poster_summary,
			)
	return list("bearer_summary" = "?", "poster_summary" = "?")

/proc/build_towner_posting_listing(mob/user)
	var/list/out = list()
	for(var/posting_type in GLOB.towner_posting_descriptors)
		var/list/desc = GLOB.towner_posting_descriptors[posting_type]
		var/crown_funded = towner_posting_is_crown_funded(user, posting_type)
		var/cost_mult = crown_funded ? TOWNER_POSTING_CROWN_COST_MULT : 1
		var/list/tiers = list()
		for(var/tier in GLOB.towner_posting_tier_costs)
			var/list/summary = towner_tier_summary(posting_type, tier)
			summary["cost"] = GLOB.towner_posting_tier_costs[tier] * cost_mult
			tiers[tier] = summary
		out += list(list(
			"type" = posting_type,
			"label" = desc["label"],
			"blurb" = desc["blurb"],
			"rules" = desc["rules"] || list(),
			"eligible" = user_can_post_towner_type(user, posting_type) ? TRUE : FALSE,
			"eligible_jobs" = towner_advclass_names(desc["postable_advclasses"]),
			"crown_funded" = crown_funded ? TRUE : FALSE,
			"tiers" = tiers,
		))
	return out

/obj/structure/roguemachine/contractledger/proc/compose_towner_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/poster = user
	if(!poster.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(poster, span_warning("The ledger is not yet open."))
		return

	var/chosen_type = params["type"]
	if(!(chosen_type in GLOB.towner_posting_descriptors))
		to_chat(poster, span_warning("That posting type is not one the Guild accepts."))
		return

	if(!user_can_post_towner_type(poster, chosen_type))
		to_chat(poster, span_warning("Your trade does not post that contract."))
		return

	var/tier = params["tier"]
	if(!(tier in GLOB.towner_posting_tier_costs))
		to_chat(poster, span_warning("That posting tier is not recognised."))
		return
	var/crown_funded = towner_posting_is_crown_funded(poster, chosen_type)
	var/cost = GLOB.towner_posting_tier_costs[tier] * (crown_funded ? TOWNER_POSTING_CROWN_COST_MULT : 1)
	if(!cost)
		return

	var/datum/fund/poster_account
	if(crown_funded)
		if(!SStreasury.discretionary_fund)
			to_chat(poster, span_warning("The Crown's Purse is not established."))
			return
		if(SStreasury.discretionary_fund.balance < cost)
			to_chat(poster, span_warning("Insufficient Crown's Purse. Need [cost]m, have [SStreasury.discretionary_fund.balance]m."))
			return
		if(!SStreasury.burn(SStreasury.discretionary_fund, cost, "crown towner commission ([chosen_type])"))
			to_chat(poster, span_warning("The Crown's Purse refused the draft."))
			return
	else
		if(!SStreasury.has_account(poster))
			to_chat(poster, span_warning("You have no account on record."))
			return
		if(SStreasury.get_balance(poster) < cost)
			to_chat(poster, span_warning("Insufficient balance. This posting requires [cost] mammon."))
			return
		poster_account = SStreasury.get_account(poster)
		if(!poster_account)
			return
		if(!SStreasury.transfer(poster_account, SStreasury.discretionary_fund, cost, "towner contract posting ([chosen_type])"))
			to_chat(poster, span_warning("The treasury refused the draft."))
			return

	var/to_hand = (params["delivery"] == "hand")
	var/datum/quest/dispatched = SSquestpool.issue_towner_quest(chosen_type, poster, tier, to_hand)
	if(!dispatched)
		if(crown_funded)
			SStreasury.mint(SStreasury.discretionary_fund, cost, "crown towner commission refund (issue failure)")
		else
			SStreasury.transfer(SStreasury.discretionary_fund, poster_account, cost, "towner contract posting refund (issue failure)")
		to_chat(poster, span_warning("No landmark could bear that contract. Funds refunded."))
		return

	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/purse_note = crown_funded ? " Drawn on the Crown's Purse." : ""
	if(to_hand)
		to_chat(poster, span_notice("Contract drawn up: <b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m).[purse_note] Hand it over to whomever you want to hire."))
	else
		to_chat(poster, span_notice("Contract posted: <b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m).[purse_note] The recovered goods must be opened by you."))
	log_game("[key_name(poster)] posted towner contract \"[dispatched.title || dispatched.quest_type]\" ([tier], [cost]m, [crown_funded ? "crown purse" : "personal"], [to_hand ? "in hand" : "board"]).")
