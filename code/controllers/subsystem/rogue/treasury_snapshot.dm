/datum/controller/subsystem/treasury/proc/compute_fiscal_snapshot()
	var/total_bank = 0
	var/under_50m = 0
	var/in_advance = 0
	var/in_arrears = 0
	var/debtor_count = 0
	var/held_accounts = 0
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(!account || account.currency != CURRENCY_MAMMON)
			continue
		held_accounts++
		total_bank += account.balance
		if(account.balance < 50)
			under_50m++
		var/mob/living/owner = account.get_owner()
		if(!owner)
			continue
		if(poll_tax_advance_days[owner])
			in_advance++
		if(poll_tax_owed[owner])
			in_arrears++
		if(HAS_TRAIT(owner, TRAIT_DEBTOR))
			debtor_count++

	var/avg_balance = 0
	if(held_accounts > 0)
		avg_balance = round(total_bank / held_accounts, 1)

	var/loan_exposure = 0
	for(var/datum/loan/L in loans)
		loan_exposure += L.get_remaining_due()

	return list(
		"discretionary" = discretionary_fund?.balance || 0,
		"burgher_pledge" = burgher_pledge_fund?.balance || 0,
		"total_bank" = total_bank,
		"avg_balance" = avg_balance,
		"held_accounts" = held_accounts,
		"under_50m" = under_50m,
		"in_advance" = in_advance,
		"in_arrears" = in_arrears,
		"debtor_count" = debtor_count,
		"loans_outstanding" = length(loans),
		"loan_exposure" = loan_exposure,
		"rural_tax_total" = total_rural_tax,
		"noble_income_total" = total_noble_income,
		"tax_rates" = tax_rates.Copy(),
		"poll_tax_rates" = poll_tax_rates.Copy(),
	)

/datum/controller/subsystem/treasury/proc/compute_charter_states()
	var/list/out = list()
	for(var/id in list(DECREE_GREAT_WRIT, DECREE_ZENITSTADT_CONCORDAT, DECREE_OTAVAN_ACCORDS, DECREE_GOLDEN_BULL, DECREE_NOC_PESTRA_COVENANT, DECREE_GUILD_CHARTER_OF_ARMS, DECREE_INDENTURE_OF_WAR, DECREE_MAGNA_CARTA))
		var/datum/decree/D = get_decree(id)
		if(!D)
			continue
		// Dormant charters never activated this round are hidden from non-Lord audiences. The
		// Lord still sees them in the Titan's decree_setter panel - that panel doesn't use this
		// snapshot.
		if(!D.has_ever_been_active)
			continue
		out += list(list(
			"id" = D.id,
			"name" = D.name,
			"active" = D.active,
			"cooldown_remaining" = max(0, D.cooldown_expires - world.time),
		))
	return out

/// status values: "arrears" owed>0, "advance" advance_days>0, "debtor" TRAIT_DEBTOR, "low_balance" <50m, "exempt" charter-exempt.
/// `include_details` toggles the per-row expensive bits (on_person inventory walk, has_loan lookup).
/// The list view doesn't need them - the detail panel calls back in with TRUE for the selected row.
/datum/controller/subsystem/treasury/proc/compute_filtered_players(category_filter, status_filter, search_str, include_details = FALSE)
	var/list/out = list()
	var/search_lower = lowertext(search_str || "")
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(!account || account.currency != CURRENCY_MAMMON)
			continue
		var/mob/living/owner = account.get_owner()
		if(!owner)
			continue

		var/category = get_poll_tax_category(owner)
		if(category_filter && category_filter != "all")
			if(category != category_filter)
				continue

		var/owed = poll_tax_owed[owner] || 0
		var/overdue = poll_tax_debt_days[owner] || 0
		var/advance = poll_tax_advance_days[owner] || 0
		var/exempt = category ? is_poll_tax_charter_exempt(owner, category) : FALSE
		var/is_debtor = HAS_TRAIT(owner, TRAIT_DEBTOR)

		if(status_filter && status_filter != "all")
			switch(status_filter)
				if("arrears")
					if(owed <= 0)
						continue
				if("advance")
					if(advance <= 0)
						continue
				if("debtor")
					if(!is_debtor)
						continue
				if("low_balance")
					if(account.balance >= 50)
						continue
				if("exempt")
					if(!exempt)
						continue

		if(search_lower)
			var/name_lower = lowertext(owner.real_name)
			if(!findtext(name_lower, search_lower))
				continue

		var/rate = category ? get_poll_tax_rate_for(owner, category) : 0
		// Inventory walk is per-row expensive (recurses through every bag/pocket). Skip it unless
		// the caller asked for details - the list view doesn't show on_person anymore, only the
		// detail pane for the selected player does. get_loan_for is cheap (iterates SS.loans, ~5
		// entries), so the L-marker in the list view stays accurate.
		var/on_person = include_details ? (get_mammons_in_atom(owner) || 0) : 0
		var/has_loan = !isnull(get_loan_for(owner))

		out += list(list(
			"ref" = "\ref[owner]",
			"name" = owner.real_name,
			"job" = owner.job,
			"category" = category,
			"category_name" = category ? get_poll_tax_category_pretty_name(category) : "None",
			"rate" = rate,
			"raw_rate" = category ? (poll_tax_rates[category] || 0) : 0,
			"exempt" = exempt,
			"advance" = advance,
			"owed" = owed,
			"overdue" = overdue,
			"balance" = account.balance,
			"on_person" = on_person,
			"has_loan" = has_loan,
			"is_debtor" = is_debtor,
		))
	return out
