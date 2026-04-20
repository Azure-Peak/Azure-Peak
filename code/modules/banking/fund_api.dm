/datum/controller/subsystem/treasury/proc/log_fund_entry(datum/treasury_entry/entry)
	ledger += entry

/datum/controller/subsystem/treasury/proc/mint(datum/fund/to_fund, amount, reason)
	if(!to_fund || amount <= 0)
		return FALSE
	to_fund.balance += amount
	log_fund_entry(new /datum/treasury_entry("mint", null, to_fund, amount, reason))
	return TRUE

/datum/controller/subsystem/treasury/proc/burn(datum/fund/from_fund, amount, reason)
	if(!from_fund || amount <= 0)
		return FALSE
	if(from_fund.balance < amount)
		return FALSE
	from_fund.balance -= amount
	log_fund_entry(new /datum/treasury_entry("burn", from_fund, null, amount, reason))
	return TRUE

/datum/controller/subsystem/treasury/proc/transfer(datum/fund/from_fund, datum/fund/to_fund, amount, reason)
	if(!from_fund || !to_fund || amount <= 0)
		return FALSE
	if(from_fund.currency != to_fund.currency)
		stack_trace("Treasury transfer with mismatched currencies: [from_fund.currency] -> [to_fund.currency] ([reason])")
		return FALSE
	if(from_fund.balance < amount)
		return FALSE
	from_fund.balance -= amount
	to_fund.balance += amount
	log_fund_entry(new /datum/treasury_entry("transfer", from_fund, to_fund, amount, reason))
	return TRUE

/datum/controller/subsystem/treasury/proc/get_tax_rate(tax_category)
	return tax_rates[tax_category] || 0

/datum/controller/subsystem/treasury/proc/set_tax_rate(tax_category, rate)
	if(tax_category == TAX_CATEGORY_FINE)
		return
	tax_rates[tax_category] = CLAMP(rate, 0, 0.50)

/datum/controller/subsystem/treasury/proc/is_tax_exempt(mob/living/payer, tax_category)
	if(!payer)
		return FALSE
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		if(D.apply_exemption(payer, tax_category))
			return TRUE
	return FALSE

/// Returns the tightest rate cap (as a fraction 0-1) applicable to the payer for this category.
/// Starts at GENERIC_RATE_CAP and lets decrees narrow further via apply_rate_cap.
/datum/controller/subsystem/treasury/proc/get_rate_cap(mob/living/payer, tax_category)
	var/cap = GENERIC_RATE_CAP
	if(!payer)
		return cap
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		cap = D.apply_rate_cap(payer, tax_category, cap)
	return cap

/datum/controller/subsystem/treasury/proc/apply_tax(datum/fund/payer, base_amount, tax_category, reason)
	if(!payer || base_amount <= 0)
		return 0
	var/mob/living/owner = payer.get_owner()
	if(owner && is_tax_exempt(owner, tax_category))
		return 0
	var/rate = get_tax_rate(tax_category)
	if(owner)
		rate = min(rate, get_rate_cap(owner, tax_category))
	if(rate <= 0)
		return 0
	payer.tax_debt += base_amount * rate
	var/due = FLOOR(payer.tax_debt, 1)
	if(due <= 0)
		return 0
	if(!transfer(payer, discretionary_fund, due, "[tax_category] ([reason])"))
		return 0
	payer.tax_debt -= due
	return due

/datum/controller/subsystem/treasury/proc/verify_mammon_conservation()
	var/ledger_delta = 0
	for(var/datum/treasury_entry/entry as anything in ledger)
		if(entry.currency != CURRENCY_MAMMON)
			continue
		switch(entry.kind)
			if("mint")
				ledger_delta += entry.amount
			if("burn")
				ledger_delta -= entry.amount
	var/observed_total = discretionary_fund ? discretionary_fund.balance : 0
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(account?.currency == CURRENCY_MAMMON)
			observed_total += account.balance
	return list("ledger_delta" = ledger_delta, "observed_total" = observed_total)
