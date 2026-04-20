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

/datum/controller/subsystem/treasury/proc/get_tax_rate(datum/fund/payer, tax_category)
	if(!payer)
		return 0
	switch(tax_category)
		if(TAX_CATEGORY_BOUNTY)
			return queens_tax
		if(TAX_CATEGORY_QUEST_REWARD, TAX_CATEGORY_DEPOSIT)
			var/mob/living/owner = payer.get_owner()
			if(!owner)
				return 0
			return get_tax_value_for(owner)
	return 0

/datum/controller/subsystem/treasury/proc/apply_tax(datum/fund/payer, base_amount, tax_category, reason)
	if(!payer || base_amount <= 0)
		return 0
	var/rate = get_tax_rate(payer, tax_category)
	if(rate <= 0)
		return 0
	var/tax_amt = round(base_amount * rate)
	if(tax_amt <= 0)
		return 0
	if(!transfer(payer, discretionary_fund, tax_amt, "[tax_category] ([reason])"))
		return 0
	return tax_amt

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
