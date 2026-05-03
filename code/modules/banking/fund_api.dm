/datum/controller/subsystem/treasury/proc/log_fund_entry(datum/treasury_entry/entry)
	ledger += entry

/// If the destination is the discretionary fund and banditry debt is outstanding, skim the
/// owed amount off the inflow and shrink the debt. Returns the post-skim amount that should
/// actually credit the fund. Logged as a separate ledger entry for transparency.
/datum/controller/subsystem/treasury/proc/skim_for_banditry_debt(datum/fund/to_fund, amount)
	if(amount <= 0 || banditry_debt <= 0 || to_fund != discretionary_fund)
		return amount
	var/skim = min(amount, banditry_debt)
	banditry_debt -= skim
	GLOB.azure_round_stats[STATS_BANDITRY_DEBT_OUTSTANDING] = banditry_debt
	log_fund_entry(new /datum/treasury_entry("burn", to_fund, null, skim, "Banditry debt repayment"))
	return amount - skim

/// Treasury-debt skim. Runs whenever treasury_debt is outstanding, regardless of state -
/// so an ATC emergency loan (NORMAL state with non-zero debt) repays itself silently from
/// inflow just like arrears or sequestration debt. The operating floor differs by state:
/// 0 in NORMAL or IN_ARREARS (full inflow goes to debt), BANKRUPTCY_OPERATING_FLOOR in
/// BANKRUPTCY (purse refills up to the floor to keep the trade engine running).
/// Calls clear_treasury_debt_state when debt reaches zero.
/datum/controller/subsystem/treasury/proc/skim_for_treasury_debt(datum/fund/to_fund, amount)
	if(amount <= 0 || treasury_debt <= 0 || to_fund != discretionary_fund)
		return amount
	var/floor_value = (treasury_state == TREASURY_BANKRUPTCY) ? BANKRUPTCY_OPERATING_FLOOR : 0
	var/headroom_below_floor = max(0, floor_value - to_fund.balance)
	var/amount_above_floor = max(0, amount - headroom_below_floor)
	if(amount_above_floor <= 0)
		return amount
	var/skim = min(amount_above_floor, treasury_debt)
	treasury_debt -= skim
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = treasury_debt
	record_round_statistic(STATS_TREASURY_DEBT_REPAID, skim)
	var/reason
	if(treasury_state == TREASURY_BANKRUPTCY)
		reason = "Sequestration debt - Azurian Trading Company"
	else if(treasury_state == TREASURY_IN_ARREARS)
		reason = "Arrears repayment - Burghers of Azuria"
	else
		reason = "ATC loan repayment"
	log_fund_entry(new /datum/treasury_entry("burn", to_fund, null, skim, reason))
	if(treasury_debt <= 0)
		treasury_debt = 0
		clear_treasury_debt_state()
	return amount - skim

/datum/controller/subsystem/treasury/proc/mint(datum/fund/to_fund, amount, reason)
	if(!to_fund || amount <= 0)
		return FALSE
	var/credited = skim_for_banditry_debt(to_fund, amount)
	credited = skim_for_treasury_debt(to_fund, credited)
	if(credited > 0)
		to_fund.balance += credited
		log_fund_entry(new /datum/treasury_entry("mint", null, to_fund, credited, reason))
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
	var/credited = skim_for_banditry_debt(to_fund, amount)
	credited = skim_for_treasury_debt(to_fund, credited)
	to_fund.balance += credited
	log_fund_entry(new /datum/treasury_entry("transfer", from_fund, to_fund, amount, reason))
	return TRUE

/datum/controller/subsystem/treasury/proc/get_tax_rate(tax_category)
	return tax_rates[tax_category] || 0

/datum/controller/subsystem/treasury/proc/set_tax_rate(tax_category, rate)
	if(tax_category == TAX_CATEGORY_FINE)
		return
	tax_rates[tax_category] = CLAMP(rate, 0, 1.0)

/datum/controller/subsystem/treasury/proc/is_tax_exempt(mob/living/payer, tax_category)
	if(!payer)
		return FALSE
	// Outlawry is civic death - the Crown's ledger no longer recognises any protection.
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		if(D.apply_exemption(payer, tax_category))
			return TRUE
	return FALSE

/// Returns the tightest rate cap (as a fraction 0-1) applicable to the payer for this category.
/// Starts at GENERIC_RATE_CAP and lets decrees narrow further via apply_rate_cap.
/// Outlaws have no cap — their wealth is fully forfeit to the Crown.
/datum/controller/subsystem/treasury/proc/get_rate_cap(mob/living/payer, tax_category)
	var/cap = GENERIC_RATE_CAP
	if(!payer)
		return cap
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return 1.0
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		cap = D.apply_rate_cap(payer, tax_category, cap)
	return cap

/datum/controller/subsystem/treasury/proc/apply_tax(datum/fund/payer, base_amount, tax_category, reason)
	if(!payer || base_amount <= 0)
		return 0
	var/mob/living/owner = payer.get_owner()
	var/base_rate = get_tax_rate(tax_category)
	if(owner && is_tax_exempt(owner, tax_category))
		record_tax_exemption(tax_category, FLOOR(base_amount * base_rate, 1))
		return 0
	var/rate = base_rate
	if(owner)
		rate = min(rate, get_rate_cap(owner, tax_category))
	if(rate <= 0)
		return 0
	// If a rate-cap reduced what the Crown could take, log the gap as exemption.
	if(rate < base_rate)
		record_tax_exemption(tax_category, FLOOR(base_amount * (base_rate - rate), 1))
	payer.tax_debt += base_amount * rate
	var/due = FLOOR(payer.tax_debt, 1)
	if(due <= 0)
		return 0
	if(!transfer(payer, discretionary_fund, due, "[tax_category] ([reason])"))
		return 0
	payer.tax_debt -= due
	switch(tax_category)
		if(TAX_CATEGORY_CONTRACT_LEVY)
			record_round_statistic(STATS_REVENUE_CONTRACT_LEVY, due)
		if(TAX_CATEGORY_HEADEATER_LEVY)
			record_round_statistic(STATS_REVENUE_HEADEATER_LEVY, due)
		if(TAX_CATEGORY_IMPORT_TARIFF)
			record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, due)
		if(TAX_CATEGORY_EXPORT_DUTY)
			record_round_statistic(STATS_REVENUE_EXPORT_DUTY, due)
	return due

/datum/controller/subsystem/treasury/proc/record_tax_exemption(tax_category, amount)
	if(amount <= 0)
		return
	switch(tax_category)
		if(TAX_CATEGORY_CONTRACT_LEVY)
			record_round_statistic(STATS_EXEMPTED_CONTRACT_LEVY, amount)
		if(TAX_CATEGORY_HEADEATER_LEVY)
			record_round_statistic(STATS_EXEMPTED_HEADEATER_LEVY, amount)
		if(TAX_CATEGORY_IMPORT_TARIFF)
			record_round_statistic(STATS_EXEMPTED_IMPORT_TARIFF, amount)
		if(TAX_CATEGORY_EXPORT_DUTY)
			record_round_statistic(STATS_EXEMPTED_EXPORT_DUTY, amount)
		if(TAX_CATEGORY_FINE)
			record_round_statistic(STATS_EXEMPTED_FINE, amount)

