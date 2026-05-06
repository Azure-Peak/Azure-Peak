GLOBAL_LIST_INIT(towner_posting_tier_costs, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_POSTING_COST_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_POSTING_COST_HARD,
))

GLOBAL_LIST_INIT(towner_posting_descriptors, list(
	QUEST_TOWNER_SMITH_CARAVAN = list(
		"label" = "A Caravan Gone Missing",
		"blurb" = "A wagon of yours was lost on the road. Hire hands to escort you to the wreck.",
		"rules" = list(
			"You must reach the wreck yourself for the strongbox to surface.",
			"Once the bearer reaches the wreck, you have 20 minutes to follow.",
			"If the trail goes cold, your posting fee is refunded.",
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
		"blurb" = "You have prospected an elemental guarded vein. Hire hands to clear the guardians while you work the rock.",
		"rules" = list(
			"You must reach the vein yourself - the earth only erupts when you arrive.",
			"Once the bearer reaches the vein, you have 30 minutes before the vein closes.",
			"The fellowship may help you mine - the ore is yours by agreement, not by enchantment.",
			"If the vein closes before erupting, your posting fee is refunded.",
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

/proc/user_can_post_towner_type(mob/user, posting_type)
	var/list/desc = GLOB.towner_posting_descriptors[posting_type]
	if(!desc)
		return FALSE
	var/path = get_user_advclass_path(user)
	if(!path)
		return FALSE
	return (path in desc["postable_advclasses"])

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

/proc/towner_tier_summary(posting_type, tier)
	switch(posting_type)
		if(QUEST_TOWNER_SMITH_CARAVAN)
			var/list/ranges = GLOB.towner_smith_caravan_bundle_ranges[tier]
			var/poster_summary = "?"
			if(ranges)
				poster_summary = "[ranges["iron"][1]]-[ranges["iron"][2]] iron, [ranges["bronze"][1]]-[ranges["bronze"][2]] bronze, [ranges["steel"][1]]-[ranges["steel"][2]] steel"
			var/bonus = (tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_CARAVAN_FLAT_BONUS_HARD : TOWNER_CARAVAN_FLAT_BONUS_MEDIUM
			return list(
				"bearer_summary" = "combat & distance pay + [bonus]m bonus",
				"poster_summary" = poster_summary,
			)
		if(QUEST_TOWNER_MINER_OREVEIN)
			var/clusters = (tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_OREVEIN_CLUSTER_COUNT_HARD : TOWNER_OREVEIN_CLUSTER_COUNT_MEDIUM
			var/bonus = (tier == TOWNER_POSTING_TIER_HARD) ? TOWNER_OREVEIN_FLAT_BONUS_HARD : TOWNER_OREVEIN_FLAT_BONUS_MEDIUM
			var/poster_summary
			if(tier == TOWNER_POSTING_TIER_HARD)
				poster_summary = "[clusters] clusters: each yields cinnabar + iron + a windfall of gold, gems, or a richer iron seam"
			else
				poster_summary = "[clusters] clusters: each yields iron + coal, with a chance of gold"
			return list(
				"bearer_summary" = "combat pay + [bonus]m bonus",
				"poster_summary" = poster_summary,
			)
	return list("bearer_summary" = "?", "poster_summary" = "?")

/proc/build_towner_posting_listing(mob/user)
	var/list/out = list()
	for(var/posting_type in GLOB.towner_posting_descriptors)
		var/list/desc = GLOB.towner_posting_descriptors[posting_type]
		var/list/tiers = list()
		for(var/tier in list(TOWNER_POSTING_TIER_MEDIUM, TOWNER_POSTING_TIER_HARD))
			tiers[tier] = towner_tier_summary(posting_type, tier)
		out += list(list(
			"type" = posting_type,
			"label" = desc["label"],
			"blurb" = desc["blurb"],
			"rules" = desc["rules"] || list(),
			"eligible" = user_can_post_towner_type(user, posting_type) ? TRUE : FALSE,
			"eligible_jobs" = towner_advclass_names(desc["postable_advclasses"]),
			"cost_medium" = TOWNER_POSTING_COST_MEDIUM,
			"cost_hard" = TOWNER_POSTING_COST_HARD,
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
	if(tier != TOWNER_POSTING_TIER_MEDIUM && tier != TOWNER_POSTING_TIER_HARD)
		to_chat(poster, span_warning("That posting tier is not recognised."))
		return
	var/cost = GLOB.towner_posting_tier_costs[tier]
	if(!cost)
		return

	if(!SStreasury.has_account(poster))
		to_chat(poster, span_warning("You have no account on record."))
		return
	if(SStreasury.get_balance(poster) < cost)
		to_chat(poster, span_warning("Insufficient balance. This posting requires [cost] mammon."))
		return

	var/datum/fund/poster_account = SStreasury.get_account(poster)
	if(!poster_account)
		return
	if(!SStreasury.transfer(poster_account, SStreasury.discretionary_fund, cost, "towner contract posting ([chosen_type])"))
		to_chat(poster, span_warning("The treasury refused the draft."))
		return

	var/datum/quest/dispatched = SSquestpool.issue_towner_quest(chosen_type, poster, tier)
	if(!dispatched)
		SStreasury.transfer(SStreasury.discretionary_fund, poster_account, cost, "towner contract posting refund (issue failure)")
		to_chat(poster, span_warning("No landmark could bear that contract. Funds refunded."))
		return

	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	to_chat(poster, span_notice("Contract posted: <b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m). The bearer of the contract must bring you along in their fellowship."))
