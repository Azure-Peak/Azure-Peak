/datum/controller/subsystem/treasury/proc/get_poll_levy_authority(mob/living/user)
	if(!user)
		return null
	if(user == SSticker.rulermob || user == SSticker.regentmob)
		return "duke"
	if(user.job == "Steward")
		return "steward"
	return null

/datum/controller/subsystem/treasury/proc/get_poll_levy_block_reason(mob/living/user)
	var/authority = get_poll_levy_authority(user)
	if(!authority)
		return "Only the [SSticker.rulertype] or the Steward can levy."
	var/datum/decree/magna_carta = get_decree(DECREE_MAGNA_CARTA)
	if(magna_carta?.active)
		return "No levies while the Magna Carta is in force."
	if(GLOB.dayspassed < POLL_LEVY_FIRST_DAY)
		return "No levies before day [POLL_LEVY_FIRST_DAY]."
	if(length(poll_levies) >= POLL_LEVY_MAX_PER_ROUND)
		return "No levies left this week."
	if(authority == "steward")
		for(var/list/levy as anything in poll_levies)
			if(levy["authority"] == "steward")
				return "The Steward has already levied this week."
	if(length(poll_levies))
		var/list/last = poll_levies[length(poll_levies)]
		if(GLOB.dayspassed - last["day"] < POLL_LEVY_MIN_GAP_DAYS)
			return "A poll levy was raised today. Try again tomorrow."
	return null

/datum/controller/subsystem/treasury/proc/get_poll_levy_due(mob/living/payer, base)
	var/due = min(base, CHARGE_CAP_FLAT)
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		due = D.apply_charge_cap(payer, TAX_CATEGORY_POLL_LEVY, due)
	return max(due, 0)

/datum/controller/subsystem/treasury/proc/charge_poll_levy(mob/living/owner, datum/fund/account, list/levy, quiet = FALSE)
	if(!owner || !account)
		return null
	if(owner.real_name in levy["charged"])
		return null
	var/category = get_poll_levy_category(owner)
	if(!category)
		return null
	var/list/amounts = levy["amounts"]
	var/base = amounts[category]
	if(!base)
		return null
	levy["charged"] |= owner.real_name
	if(is_tax_exempt(owner, TAX_CATEGORY_POLL_LEVY))
		record_tax_exemption(TAX_CATEGORY_POLL_LEVY, base)
		return null
	var/due = get_poll_levy_due(owner, base)
	if(due < base)
		record_tax_exemption(TAX_CATEGORY_POLL_LEVY, base - due)
	if(due <= 0)
		return null
	var/paid = min(due, max(account.balance - POLL_LEVY_PROTECTED_BALANCE, 0))
	if(paid > 0 && !transfer(account, discretionary_fund, paid, "Poll levy ([get_poll_levy_category_pretty_name(category)])", LEDGER_CITIZEN_TAXES, LEDGER_CROWN_REV_POLL_LEVY))
		paid = 0
	if(paid > 0)
		record_poll_levy_by_category(category, paid)
	var/owed = due - paid
	if(owed > 0)
		poll_levy_owed[owner] = (poll_levy_owed[owner] || 0) + owed
		accrue_poll_levy_receivable(owed, category)
		record_round_statistic(STATS_POLL_LEVY_ARREARS, owed)
		ADD_TRAIT(owner, TRAIT_ARREARS, TRAIT_GENERIC)
		if(!quiet)
			to_chat(owner, span_danger("<b>POLL LEVY:</b> [paid]m taken from your account. You owe the Crown [owed]m in arrears."))
	else if(!quiet)
		to_chat(owner, span_notice("<b>POLL LEVY:</b> [paid]m taken from your account."))
	return list(paid, owed)

/datum/controller/subsystem/treasury/proc/enact_poll_levy(mob/living/user, list/raw_amounts, raw_reason)
	var/block = get_poll_levy_block_reason(user)
	if(block)
		to_chat(user, span_warning(block))
		return FALSE
	var/reason = trim(copytext_char(trim(STRIP_HTML_SIMPLE("[raw_reason]", MAX_MESSAGE_LEN)), 1, POLL_LEVY_REASON_MAX + 1))
	if(length_char(reason) < POLL_LEVY_REASON_MIN)
		to_chat(user, span_warning("The reason must be at least [POLL_LEVY_REASON_MIN] characters."))
		return FALSE
	var/list/amounts = list()
	if(islist(raw_amounts))
		for(var/entry in raw_amounts)
			if(!islist(entry))
				continue
			var/category = entry["category"]
			if(!(category in POLL_LEVY_CLASS_ORDER))
				continue
			if(get_poll_levy_exempting_charter(category))
				continue
			var/amount = CLAMP(round(text2num("[entry["amount"]]")), 0, CHARGE_CAP_FLAT)
			if(amount > 0)
				amounts[category] = amount
	if(!length(amounts))
		to_chat(user, span_warning("Set an amount for at least one class."))
		return FALSE

	var/authority = get_poll_levy_authority(user)
	var/list/levy = list(
		"day" = GLOB.dayspassed,
		"authority" = authority,
		"amounts" = amounts,
		"reason" = reason,
		"raised" = 0,
		"arrears" = 0,
		"charged" = list(),
	)
	poll_levies += list(levy)
	record_round_statistic(STATS_POLL_LEVIES_ENACTED, 1)

	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(!account || account.currency != CURRENCY_MAMMON)
			continue
		var/list/result = charge_poll_levy(account.get_owner(), account, levy)
		if(result)
			levy["raised"] += result[1]
			levy["arrears"] += result[2]

	var/list/lines = list()
	var/announcer = authority == "duke" ? "The gracious [SSticker.rulertype]" : "The righteous Steward"
	lines += "[announcer] has enacted a poll levy of:"
	for(var/category in POLL_LEVY_CLASS_ORDER)
		if(!amounts[category])
			continue
		var/list/caps = get_poll_levy_class_caps(category)
		var/shown = min(amounts[category], caps["cap"])
		var/line = "- [get_poll_levy_category_pretty_name(category)]: [shown]m / head"
		if(caps["partial"] && shown > CHARGE_CAP_CHARTER)
			line += " ([CHARGE_CAP_CHARTER]m for [caps["partial"]])"
		lines += line
	lines += ""
	lines += "For reasons of:"
	lines += html_encode(reason)
	lines += ""
	var/tally = "This has raised [levy["raised"]]m in revenue for the realm."
	if(levy["arrears"] > 0)
		tally += " The levy has incurred [levy["arrears"]]m in arrears."
	lines += tally
	priority_announce(jointext(lines, "<br>"), "POLL LEVY", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", user, strip_html = FALSE)

	var/list/log_parts = list()
	for(var/category in amounts)
		log_parts += "[get_poll_levy_category_pretty_name(category)] [amounts[category]]m"
	log_game("POLL LEVY: [key_name(user)] ([authority]) levied [jointext(log_parts, ", ")]; raised [levy["raised"]]m, [levy["arrears"]]m in arrears. Reason: [reason]")
	return TRUE

/datum/controller/subsystem/treasury/proc/waive_past_poll_levies(mob/living/arrival)
	if(!arrival)
		return
	for(var/list/levy as anything in poll_levies)
		levy["charged"] |= arrival.real_name

/datum/controller/subsystem/treasury/proc/apply_past_poll_levies(mob/living/owner, announce = TRUE)
	if(QDELETED(owner))
		return null
	var/datum/fund/account = get_account(owner)
	if(!account)
		return null
	var/paid_total = 0
	var/owed_total = 0
	for(var/list/levy as anything in poll_levies)
		var/list/result = charge_poll_levy(owner, account, levy, quiet = TRUE)
		if(!result)
			continue
		levy["raised"] += result[1]
		levy["arrears"] += result[2]
		paid_total += result[1]
		owed_total += result[2]
	if(paid_total <= 0 && owed_total <= 0)
		return null
	var/list/parts = list()
	if(paid_total > 0)
		parts += "[paid_total]m was drawn for the standing poll levy."
	if(owed_total > 0)
		parts += "You owe the Crown [owed_total]m in poll arrears. Please pay your dues hastily."
	var/summary = jointext(parts, " ")
	if(announce)
		send_ooc_note("<b>MEISTER:</b> New account created. [summary]", name = owner.real_name)
	return summary

/datum/controller/subsystem/treasury/proc/collect_poll_levy_arrears(mob/living/owner)
	if(QDELETED(owner))
		return 0
	var/owed = poll_levy_owed[owner] || 0
	if(owed <= 0)
		return 0
	var/datum/fund/account = get_account(owner)
	if(!account || account.balance <= POLL_LEVY_PROTECTED_BALANCE)
		return 0
	var/paid = min(owed, account.balance - POLL_LEVY_PROTECTED_BALANCE)
	if(!transfer(account, discretionary_fund, paid, "Poll levy arrears", LEDGER_CITIZEN_TAXES, LEDGER_CROWN_POLL_RECEIVABLE))
		return 0
	record_poll_levy_by_category(get_poll_levy_category(owner), paid)
	record_round_statistic(STATS_POLL_LEVY_ARREARS_RECOVERED, paid)
	var/remaining = owed - paid
	if(remaining > 0)
		poll_levy_owed[owner] = remaining
		to_chat(owner, span_danger("<b>POLL LEVY:</b> [paid]m taken from your account toward your arrears. You still owe the Crown [remaining]m."))
	else
		poll_levy_owed -= owner
		if(HAS_TRAIT(owner, TRAIT_ARREARS))
			REMOVE_TRAIT(owner, TRAIT_ARREARS, TRAIT_GENERIC)
		to_chat(owner, span_notice("<b>POLL LEVY:</b> [paid]m taken from your account. Your arrears are settled."))
	log_game("POLL LEVY ARREARS: [key_name(owner)] paid [paid]m, [remaining]m remaining")
	return paid

/datum/controller/subsystem/treasury/proc/tick_poll_levy_arrears()
	for(var/mob/living/owner as anything in poll_levy_owed.Copy())
		collect_poll_levy_arrears(owner)

/datum/controller/subsystem/treasury/proc/get_poll_levy_class_caps(category)
	var/list/covers = list()
	switch(category)
		if(POLL_LEVY_CAT_BURGHER)
			covers[DECREE_GOLDEN_BULL] = null
		if(POLL_LEVY_CAT_SCHOLAR)
			covers[DECREE_NOC_PESTRA_COVENANT] = null
		if(POLL_LEVY_CAT_MERCENARY)
			covers[DECREE_GUILD_CHARTER_OF_ARMS] = null
	var/cap = CHARGE_CAP_FLAT
	var/partial
	var/list/charters = list()
	for(var/id in covers)
		var/datum/decree/D = get_decree(id)
		if(!D?.active)
			continue
		if(covers[id])
			partial = covers[id]
			charters += "[D.name] - [covers[id]] only"
		else
			cap = min(cap, CHARGE_CAP_CHARTER)
			charters += D.name
	if(cap <= CHARGE_CAP_CHARTER)
		partial = null
	return list("cap" = cap, "partial" = partial, "charters" = charters)

/datum/controller/subsystem/treasury/proc/get_poll_levy_ui_data(mob/living/user)
	var/list/heads = list()
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(!account || account.currency != CURRENCY_MAMMON)
			continue
		var/category = get_poll_levy_category(account.get_owner())
		if(category)
			heads[category] = (heads[category] || 0) + 1
	var/list/classes = list()
	for(var/category in POLL_LEVY_CLASS_ORDER)
		var/list/caps = get_poll_levy_class_caps(category)
		classes += list(list(
			"category" = category,
			"label" = get_poll_levy_category_pretty_name(category),
			"exempt_charter" = get_poll_levy_exempting_charter(category),
			"heads" = heads[category] || 0,
			"cap" = caps["cap"],
			"cap_charters" = caps["charters"],
		))
	return list(
		"authority" = get_poll_levy_authority(user),
		"blocked_reason" = get_poll_levy_block_reason(user),
		"levies_used" = length(poll_levies),
		"levies_max" = POLL_LEVY_MAX_PER_ROUND,
		"min_balance" = POLL_LEVY_PROTECTED_BALANCE,
		"classes" = classes,
	)
