/proc/send_ooc_note(msg, name, job)
	var/list/names_to = list()
	if(name)
		names_to += name
	if(job)
		var/list/L = list()
		if(islist(job))
			L = job
		else
			L += job
		for(var/J in L)
			for(var/mob/living/carbon/human/X in GLOB.human_list)
				if(X.job == J)
					names_to |= X.real_name
	if(names_to.len)
		for(var/mob/living/carbon/human/X in GLOB.human_list)
			if(X.real_name in names_to)
				if(!X.stat)
					to_chat(X, span_biginfo("[msg]"))

SUBSYSTEM_DEF(treasury)
	name = "treasury"
	wait = 1
	priority = FIRE_PRIORITY_WATER_LEVEL
	var/list/tax_rates = list(
		TAX_CATEGORY_CONTRACT_LEVY = 0.20,
		TAX_CATEGORY_HEADEATER_LEVY = 0.15,
		TAX_CATEGORY_IMPORT_TARIFF = 0.15,
		TAX_CATEGORY_EXPORT_DUTY = 0.15,
		TAX_CATEGORY_RECOVERED_SPOILS = 0.50,
		TAX_CATEGORY_FINE = 1.0,
	)
	var/trade_spread = 0.10
	var/autoexport_percentage = AUTOEXPORT_DEFAULT_PERCENTAGE
	var/list/bank_accounts = list()
	var/datum/fund/discretionary_fund
	var/datum/fund/burgher_pledge_fund
	var/datum/fund/church/church_fund
	var/datum/fund/merchant/merchant_fund
	var/datum/fund/bathhouse/bathhouse_fund
	var/datum/fund/innkeeper/innkeeper_fund
	var/list/jawbanks_by_fund_id = list()
	var/concordat_tithe_debt = 0
	var/bathhouse_tithe_debt = 0
	var/bathhouse_ordinance_active = TRUE
	var/bathhouse_ordinance_next_toggle_time = 0
	var/round_bathhouse_tithe_total = 0
	var/list/merchant_agents = list()
	var/list/bathhouse_agents = list()
	var/list/church_agents = list()

	/// Per-day mammon cap on Agents of the Bathhouse (writ holders) drawing from the bathhouse fund. Set by the Bathmaster.
	var/bathhouse_agent_daily_withdraw_limit = BATHHOUSE_AGENT_DAILY_WITHDRAW_DEFAULT
	/// Per-day mammon cap on bathhouse workers (attendants) drawing from the bathhouse fund. Set by the Bathmaster.
	var/bathhouse_worker_daily_withdraw_limit = BATHHOUSE_WORKER_DAILY_WITHDRAW_DEFAULT
	/// When TRUE, the Bathmaster has suspended all agent withdrawals from the bathhouse fund.
	var/bathhouse_agent_withdrawals_suspended = FALSE
	/// When TRUE, the Bathmaster has suspended all worker withdrawals from the bathhouse fund.
	var/bathhouse_worker_withdrawals_suspended = FALSE
	/// Amount each worker or agent has already drawn today, keyed by real_name. One shared
	/// tally so someone who is somehow both worker and agent cannot double-dip.
	var/list/bathhouse_withdrawals = list()
	/// The in-game day bathhouse_withdrawals last reset on.
	var/bathhouse_withdrawals_day = -1

	var/banditry_debt = 0
	var/treasury_state = TREASURY_NORMAL
	var/treasury_debt = 0
	var/bankruptcy_count = 0
	var/bankruptcy_concession_picks = 0
	var/list/bankruptcy_suspended_decree_ids = list()
	/// TRUE once the Crown has drawn an ATC emergency loan; consumes the arrears grace so the
	/// next failed payroll skips IN_ARREARS straight to sequestration.
	var/atc_loan_arrears_consumed = FALSE
	var/atc_loans_drawn_this_round = 0
	var/list/ledger = list()
	/// Double-entry chart of accounts: account id -> /datum/ledger_account. Built lazily.
	var/list/chart_of_accounts = list()
	var/ledger_entry_seq = 0
	/// Cash that has entered / left the Crown purse through ordinary receipts and payments, taken from the books
	/// (financing and opening entries are left out). Feeds the Economic Chronicle.
	var/purse_inflow_total = 0
	var/purse_outflow_total = 0
	/// Funds that live outside bank_accounts (e.g. escrow holds) but must reconcile to the books.
	var/list/auxiliary_funds = list()
	/// Account totals at the close of each day: day -> list(account id -> list(debits, credits)).
	var/list/day_snapshots = list()
	var/ledger_closed_day = -1
	/// Crown revenue/expense balances and purse at the last Steward's morning report, so the next one can show what changed.
	var/list/last_report_ledger = null
	var/last_report_balance = null
	var/list/noble_incomes = list()
	var/list/decrees = list()
	var/list/stockpile_datums = list()
	var/list/stockpile_by_trade_good = list()
	var/decree_revoke_used_day = -1
	var/decree_restore_used_day = -1
	var/next_treasury_check = 0
	var/economic_output = 0
	var/total_deposit_tax = 0
	var/total_rural_tax = 0
	var/total_noble_income = 0
	var/total_import = 0
	var/total_export = 0
	var/obj/structure/roguemachine/steward/steward_machine
	var/initial_payment_done = FALSE
	var/list/loans = list()
	var/loan_max_issuance_day = 5
	var/list/poll_levy_owed = list()
	var/list/poll_levies = list()
	var/list/poll_levy_grace_until = list()
	var/levy_rates_changed_day = -1
	/// Steward-settable floor. Stockpile refuses purchases when Crown's Purse would drop below this.
	var/stockpile_purchase_floor = STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT
	/// A feature for the Steward to unlock once the Crown's trade volume reaches 10k
	/// Basically help automate the import, fitting in line with my idea of active trade
	/// Converting to passive convenience later. Later on I might gate it through a
	/// Total trade volumes converting into multiple chooseable upgrades but for now
	/// It just automatically unlock an upgrade with no real choice
	var/royal_custom_unlocked = FALSE
	var/royal_custom_active = FALSE
	var/royal_custom_margin = ROYAL_CUSTOM_DEFAULT_MARGIN
	var/royal_custom_threshold = ROYAL_CUSTOM_VOLUME_BASE
	var/list/cached_market_rows = null
	var/list/cached_region_rows = null
	var/cached_total_arbitrage_potential = 0
	var/market_view_dirty = TRUE
	var/list/cached_auto_import_data = null
	var/auto_import_view_dirty = TRUE
	var/rumor_points = RUMOR_POINTS_START
	var/list/rumor_log = list()
	var/list/rumor_issued_today = list()
	var/list/defense_log = list()
	var/list/fined_today_names = list()
	var/fined_today_day = -1

/datum/controller/subsystem/treasury/Initialize(mapload)
	var/roundstart_pop = get_active_player_count()
	var/seed = STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT + rand(500, 1500) + (roundstart_pop * CROWN_PURSE_SEED_PER_PLAYER)
	royal_custom_threshold = ROYAL_CUSTOM_VOLUME_BASE + (roundstart_pop * ROYAL_CUSTOM_VOLUME_PER_POP)
	init_chart_of_accounts()
	discretionary_fund = new("Treasury", null, seed, CURRENCY_MAMMON)
	discretionary_fund.ledger_book = LEDGER_BOOK_CROWN
	burgher_pledge_fund = new("Burgher Pledge", null, BURGHER_PLEDGE_BASE_REFILL * BURGHER_PLEDGE_ROUNDSTART_MULTIPLIER, CURRENCY_BURGHER_PLEDGE)
	burgher_pledge_fund.ledger_book = LEDGER_BOOK_PLEDGE
	church_fund = new("Church Fund", null, CHURCH_FUND_SEED, CURRENCY_MAMMON)
	merchant_fund = new("Merchant Fund", null, MERCHANT_FUND_SEED, CURRENCY_MAMMON)
	bathhouse_fund = new("Bathhouse Fund", null, BATHHOUSE_FUND_SEED, CURRENCY_MAMMON)
	innkeeper_fund = new("Tavern Earnings", null, INNKEEPER_FUND_SEED, CURRENCY_MAMMON)
	for(var/datum/fund/seeded as anything in list(discretionary_fund, burgher_pledge_fund, church_fund, merchant_fund, bathhouse_fund, innkeeper_fund))
		post_opening_balance(seeded)
	force_set_round_statistic(STATS_STARTING_TREASURY, discretionary_fund.balance)
	record_round_statistic(STATS_PLEDGE_GENERATED, burgher_pledge_fund.balance)
	record_round_statistic(STATS_RUMOR_POINTS_GENERATED, rumor_points)
	init_decrees()

	for(var/path in subtypesof(/datum/roguestock/stockpile))
		var/datum/roguestock/D = new path
		stockpile_datums += D
		if(D.trade_good_id)
			stockpile_by_trade_good[D.trade_good_id] = D
	autoset_stockpile_limits()
	revalue_stockpile_inventory(opening = TRUE)
	return ..()

/datum/controller/subsystem/treasury/proc/autoset_stockpile_limits()
	var/effective_pop = (SSeconomy && SSeconomy.simulated_player_scalar > 0) ? SSeconomy.simulated_player_scalar : get_active_player_count()
	var/pop_mult = min(REGION_POP_SCALE_MAX, 1.0 + (effective_pop * REGION_POP_SCALE_PER_PLAYER))
	for(var/datum/roguestock/D as anything in stockpile_datums)
		if(!D.automatic_limit)
			continue
		if(!D.trade_good_id)
			D.stockpile_limit = max(STOCKPILE_LIMIT_MIN, D.stockpile_limit)
			continue
		var/total_demand = 0
		for(var/region_id in GLOB.economic_regions)
			var/datum/economic_region/region = GLOB.economic_regions[region_id]
			total_demand += region.demands[D.trade_good_id] || 0
		if(total_demand <= 0)
			D.stockpile_limit = max(STOCKPILE_LIMIT_MIN, D.stockpile_limit)
			continue
		D.stockpile_limit = clamp(ceil(total_demand * pop_mult * STOCKPILE_AUTO_LIMIT_DAYS), STOCKPILE_LIMIT_MIN, STOCKPILE_LIMIT_MAX)
		D.automatic_limit = TRUE

/datum/controller/subsystem/treasury/fire(resumed = 0)
	if(world.time > next_treasury_check)
		next_treasury_check = world.time + TREASURY_TICK_AMOUNT
		if(SSticker.current_state == GAME_STATE_PLAYING)
			if(!initial_payment_done)
				initial_payment_done = TRUE
				distribute_daily_payments()
		var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/vault]
		for(var/obj/structure/roguemachine/vaultbank/VB in A)
			if(istype(VB))
				VB.update_icon()

		auto_export()

	if(ledger_closed_day < GLOB.dayspassed - 1)
		// Value the stockpile before the totals are frozen so the day closes with it included.
		revalue_stockpile_inventory()
		close_books_through(GLOB.dayspassed - 1)

/datum/controller/subsystem/treasury/proc/tick_rural_tax()
	if(!discretionary_fund)
		return
	var/rural_tax_amount = get_rural_tax_amount()
	if(rural_tax_amount <= 0)
		return
	mint(discretionary_fund, rural_tax_amount, "Rural Subsidy", null, LEDGER_CROWN_REV_RURAL)
	record_round_statistic(STATS_RURAL_TAXES_COLLECTED, rural_tax_amount)
	total_rural_tax += rural_tax_amount

/datum/controller/subsystem/treasury/proc/get_active_producer_count()
	var/count = 0
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner || !owner.client)
			continue
		if(is_producer_job(owner.job))
			count++
	return count

/datum/controller/subsystem/treasury/proc/get_rural_tax_amount()
	var/producers = get_active_producer_count()
	var/taper = clamp(1.0 - (producers / RURAL_SUBSIDY_REFERENCE_PRODUCERS), 0.0, 1.0)
	return RURAL_SUBSIDY_FLOOR + round((RURAL_SUBSIDY_BASE - RURAL_SUBSIDY_FLOOR) * taper)

// Mark the cached stewardry market / region / arbitrage
// View as needing rebuild on next read.
/datum/controller/subsystem/treasury/proc/dirty_market_view()
	market_view_dirty = TRUE
	auto_import_view_dirty = TRUE

/datum/controller/subsystem/treasury/proc/dirty_auto_import_view()
	auto_import_view_dirty = TRUE

/datum/controller/subsystem/treasury/proc/get_expected_wage_outlay()
	if(!steward_machine || !steward_machine.daily_payments)
		return 0
	var/list/payments = steward_machine.daily_payments
	var/total = 0
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner)
			continue
		var/payment_amount = payments[owner.job]
		if(!payment_amount)
			continue
		var/datum/fund/account = bank_accounts[owner]
		if(!account || account.wages_suspended)
			continue
		total += payment_amount
	return total

/datum/controller/subsystem/treasury/proc/get_account(target)
	if(!target)
		return null
	return bank_accounts[target]

/datum/controller/subsystem/treasury/proc/get_balance(target)
	var/datum/fund/account = get_account(target)
	return account ? account.balance : 0

/datum/controller/subsystem/treasury/proc/has_account(target)
	return !isnull(bank_accounts[target])

/datum/controller/subsystem/treasury/proc/rename_account(mob/living/owner, new_name)
	var/datum/fund/account = get_account(owner)
	if(!account)
		return
	account.name = new_name

/datum/controller/subsystem/treasury/proc/is_name_taken(candidate_name)
	if(!candidate_name)
		return FALSE
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(account?.name == candidate_name)
			return TRUE
	return FALSE

/datum/controller/subsystem/treasury/proc/create_bank_account(mob/living/owner, initial_deposit, defer_levies = TRUE)
	if(!owner)
		return
	if(has_account(owner))
		return
	if(is_name_taken(owner.real_name))
		return
	var/datum/fund/account = new(owner.real_name, owner, 0, CURRENCY_MAMMON)
	bank_accounts[owner] = account
	if(initial_deposit > 0)
		mint(account, initial_deposit, "Initial endowment", null, LEDGER_CITIZEN_COIN_IN)
	if(defer_levies && length(poll_levies))
		addtimer(CALLBACK(src, PROC_REF(apply_past_poll_levies), owner), 5 SECONDS)
	return TRUE

/datum/controller/subsystem/treasury/proc/get_max_fine_for(mob/living/target)
	if(!target)
		return 0
	if(is_tax_exempt(target, TAX_CATEGORY_FINE))
		return 0
	var/balance = get_balance(target)
	if(balance <= 0)
		return 0
	var/cap_rate = get_rate_cap(target, TAX_CATEGORY_FINE)
	return FLOOR(balance * cap_rate, 1)

/// Returns the maximum mammon that can still be fined from payer today across all active decrees.
/// Outlaws are uncapped. Otherwise, once a subject has already been fined today, returns 0 -
/// the one-fine-per-subject-per-day rule is absolute, regardless of amount taken.
/datum/controller/subsystem/treasury/proc/get_daily_fine_remaining(mob/living/payer)
	if(!payer || HAS_TRAIT(payer, TRAIT_OUTLAW))
		return 999999
	if(has_been_fined_today(payer))
		return 0
	var/datum/fund/account = get_account(payer)
	var/remaining = min(account ? account.balance : 0, CHARGE_CAP_FLAT)
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		remaining = D.apply_charge_cap(payer, TAX_CATEGORY_FINE, remaining)
	return remaining

/datum/controller/subsystem/treasury/proc/has_been_fined_today(mob/living/payer)
	if(!payer?.real_name)
		return FALSE
	if(fined_today_day != GLOB.dayspassed)
		fined_today_names.Cut()
		fined_today_day = GLOB.dayspassed
	return (payer.real_name in fined_today_names)

/// Notifies all active decrees that a fine was successfully applied, so they can update tracking.
/// Also records the subject in today's one-fine-per-day ledger (keyed by real_name).
/datum/controller/subsystem/treasury/proc/notify_fine_applied(mob/living/payer, amount)
	if(!payer || amount <= 0)
		return
	if(payer.real_name && !HAS_TRAIT(payer, TRAIT_OUTLAW))
		if(fined_today_day != GLOB.dayspassed)
			fined_today_names.Cut()
			fined_today_day = GLOB.dayspassed
		fined_today_names |= payer.real_name
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		D.on_fine_applied(payer, amount)

/datum/controller/subsystem/treasury/proc/grant_savings(amt, mob/living/target)
	if(!amt || !target)
		return FALSE
	var/datum/fund/account = get_account(target)
	if(!account)
		return FALSE
	return mint(account, amt, "Savings", null, LEDGER_CITIZEN_ESTATE)

/datum/controller/subsystem/treasury/proc/give_money_account(amt, target, source, mint_new = FALSE, mint_label, is_salary = FALSE, expense_acct, income_acct, flow)
	if(!amt)
		return
	if(!target)
		return
	amt = min(amt, 10000) //No exponentials, please!
	var/target_name = target
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		target_name = H.real_name
	var/datum/fund/account = get_account(target)
	if(!account)
		return FALSE
	if(amt > 0)
		if(mint_new)
			if(!mint(account, amt, source, mint_label, income_acct))
				return FALSE
		else
			// Callers that know what the Crown is paying for classify it; the default is a salary or a grant.
			var/payer_acct = expense_acct || (is_salary ? LEDGER_CROWN_EXP_WAGES : LEDGER_CROWN_EXP_GRANTS)
			var/payee_acct = income_acct || (is_salary ? LEDGER_CITIZEN_WAGES : null)
			if(!transfer(discretionary_fund, account, amt, source, payer_acct, payee_acct))
				return FALSE
		if(!mint_new)
			if(!is_salary && !flow)
				record_round_statistic(STATS_DIRECT_TREASURY_TRANSFERS, amt)
			record_treasury_payout(usr, istype(target, /mob/living) ? target : null, amt, is_salary, flow)
		send_ooc_note(source ? "<b>MEISTER:</b> You received [amt]m. ([source])" : "<b>MEISTER:</b> You received [amt]m.", name = target_name)
		log_game("CROWN GRANT: [usr ? key_name(usr) : "system"] granted [amt]m to [istype(target, /mob/living) ? key_name(target) : target_name] via [source || "unknown"]")
		if(isliving(target))
			collect_poll_levy_arrears(target)
	else
		if(SSgamemode?.roundvoteend)
			send_ooc_note("<b>MEISTER:</b> Error: The round is ending. No further fines may be levied.", name = target_name)
			return FALSE
		var/mob/living/fine_owner = istype(target, /mob/living) ? target : null
		if(fine_owner && usr && fine_owner == usr)
			send_ooc_note("<b>MEISTER:</b> Error: You can't fine yourself.", name = target_name)
			log_game("FINE REFUSED: [key_name(usr)] attempted to fine themselves [abs(amt)]m via [source || "unknown"]")
			return FALSE
		if(fine_owner && is_tax_exempt(fine_owner, TAX_CATEGORY_FINE))
			record_tax_exemption(TAX_CATEGORY_FINE, abs(amt))
			send_ooc_note("<b>MEISTER:</b> Error: A Charter exempts them from fines.", name = target_name)
			log_game("FINE REFUSED: [usr ? key_name(usr) : "system"] attempted to fine [key_name(fine_owner)] [abs(amt)]m but they were Charter-exempt")
			return FALSE
		var/fine_amt = abs(amt)
		if(fine_owner)
			var/cap_rate = get_rate_cap(fine_owner, TAX_CATEGORY_FINE)
			var/max_fine = FLOOR(account.balance * cap_rate, 1)
			max_fine = min(max_fine, get_daily_fine_remaining(fine_owner))
			if(fine_amt > max_fine)
				record_tax_exemption(TAX_CATEGORY_FINE, fine_amt - max_fine)
				fine_amt = max_fine
		if(fine_amt <= 0)
			if(fine_owner && has_been_fined_today(fine_owner))
				send_ooc_note("<b>MEISTER:</b> Error: They have already been fined today.", name = target_name)
			else
				send_ooc_note("<b>MEISTER:</b> Error: There is nothing left to fine them.", name = target_name)
			return FALSE
		if(!transfer(account, discretionary_fund, fine_amt, "[TAX_CATEGORY_FINE] ([source])", LEDGER_CITIZEN_TAXES, LEDGER_CROWN_REV_FINES))
			send_ooc_note("<b>MEISTER:</b> Error: They don't have enough in their account to pay the fine.", name = target_name)
			return FALSE
		record_round_statistic(STATS_FINES_INCOME, fine_amt)
		send_ooc_note(source ? "<b>MEISTER:</b> You were fined [fine_amt]m. ([source])" : "<b>MEISTER:</b> You were fined [fine_amt]m.", name = target_name)
		log_game("FINE: [usr ? key_name(usr) : "system"] fined [istype(target, /mob/living) ? key_name(target) : target_name] [fine_amt]m via [source || "unknown"]")
		if(fine_owner)
			notify_fine_applied(fine_owner, fine_amt)

	return TRUE

/datum/controller/subsystem/treasury/proc/generate_money_account(amt, mob/living/carbon/human/character)
	if(!amt)
		return FALSE
	if(!character)
		return FALSE
	var/datum/fund/account = get_account(character)
	if(!account)
		return FALSE
	mint(account, amt, "Meister deposit by [character.real_name]", null, LEDGER_CITIZEN_COIN_IN)
	collect_poll_levy_arrears(character)
	return list(amt, 0)

/datum/controller/subsystem/treasury/proc/withdraw_money_account(amt, target)
	if(!amt)
		return
	var/target_name = target
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		target_name = H.real_name
	var/datum/fund/account = get_account(target)
	if(!account)
		return
	if(account.balance < amt)
		send_ooc_note("<b>MEISTER:</b> Error: You don't have enough in your account for that withdrawal.", name = target_name)
		return
	if(!burn(account, amt, "Meister withdrawal by [target_name]", LEDGER_CITIZEN_COIN_OUT))
		return
	return TRUE

/datum/controller/subsystem/treasury/proc/grant_estate_income(mob/living/recipient, amount, is_starter = FALSE)
	if(!recipient || amount <= 0)
		return FALSE
	if(HAS_TRAIT(recipient, TRAIT_OUTLAW))
		return FALSE
	var/datum/fund/account = get_account(recipient)
	if(!account)
		create_bank_account(recipient)
		account = get_account(recipient)
	if(!account)
		return FALSE
	var/source = recipient.job == "Merchant" ? "Azurian Trading Company" : "Noble Estate"
	var/payout = is_starter ? amount + ESTATE_STARTER_BONUS : amount
	if(!mint(account, payout, source, null, LEDGER_CITIZEN_ESTATE))
		return FALSE
	record_round_statistic(STATS_NOBLE_INCOME_TOTAL, payout)
	total_noble_income += payout
	send_ooc_note("<b>MEISTER:</b> You received [payout]m. ([source])", name = recipient.real_name)
	return TRUE

/datum/controller/subsystem/treasury/proc/distribute_estate_incomes()
	for(var/mob/living/welfare_dependant in noble_incomes)
		grant_estate_income(welfare_dependant, noble_incomes[welfare_dependant])

/datum/controller/subsystem/treasury/proc/distribute_daily_payments()
	if(!discretionary_fund)
		return
	if(!steward_machine || !steward_machine.daily_payments || !steward_machine.daily_payments.len)
		return

	// Receivership: salaries are universally suspended for the duration of bankruptcy.
	// SSeconomy.daily_tick() still runs so the economy keeps churning autonomously.
	if(treasury_state == TREASURY_BANKRUPTCY)
		if(SSeconomy)
			SSeconomy.daily_tick()
		return

	var/projected_total = get_expected_wage_outlay()

	// Solvency check: NORMAL -> IN_ARREARS (interest-free advance covers today's wages);
	// IN_ARREARS -> BANKRUPTCY (sequestration, salaries suspended). If the Crown drew an
	// ATC emergency loan since last solvency, the arrears grace is forfeit and the next
	// failed payroll skips straight to sequestration.
	if(discretionary_fund.balance < projected_total)
		if(treasury_state == TREASURY_NORMAL)
			if(atc_loan_arrears_consumed)
				enter_bankruptcy()
				if(SSeconomy)
					SSeconomy.daily_tick()
				return
			enter_arrears(projected_total)
		else if(treasury_state == TREASURY_IN_ARREARS)
			enter_bankruptcy()
			if(SSeconomy)
				SSeconomy.daily_tick()
			return

	var/list/payments = steward_machine.daily_payments
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner)
			continue
		var/payment_amount = payments[owner.job]
		if(!payment_amount)
			continue
		var/datum/fund/account = bank_accounts[owner]
		if(!account || account.wages_suspended)
			continue
		if(give_money_account(payment_amount, owner, "Daily Wage", is_salary = TRUE))
			record_round_statistic(STATS_WAGES_PAID, payment_amount)

	if(SSeconomy)
		SSeconomy.daily_tick()

/datum/controller/subsystem/treasury/proc/tick_rumor_points()
	var/active = get_active_player_count()
	var/refill = RUMOR_POINTS_BASE_REFILL + (RUMOR_POINTS_PER_PLAYER * active)
	var/before = rumor_points
	rumor_points += refill
	var/ceiling = RUMOR_POINTS_CLAWBACK_MULTIPLIER * refill
	if(rumor_points > ceiling)
		rumor_points = ceiling
	// Record the refill that actually stuck after clawback, so the chronicle reflects real
	// generation rather than the gross theoretical amount.
	record_round_statistic(STATS_RUMOR_POINTS_GENERATED, rumor_points - before)

/datum/controller/subsystem/treasury/proc/tick_burgher_pledge()
	if(!burgher_pledge_fund)
		return
	var/datum/decree/golden = get_decree(DECREE_GOLDEN_BULL)
	if(!golden?.active)
		return
	var/refill = BURGHER_PLEDGE_BASE_REFILL + (get_active_player_count() * BURGHER_PLEDGE_PER_PLAYER)
	// The Guild of Arms' reciprocal contribution, when their charter is active. Minted as a
	// separate ledger entry so the tribute is visible in the treasury log distinct from the
	// burghers' own pledge.
	var/datum/decree/arms_charter = get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
	var/guild_bonus = (arms_charter?.active) ? GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS : 0
	var/ceiling = (refill + guild_bonus) * BURGHER_PLEDGE_CLAWBACK_MULTIPLIER
	if(burgher_pledge_fund.balance > ceiling)
		var/surplus = burgher_pledge_fund.balance - ceiling
		burn(burgher_pledge_fund, surplus, "Burgher Pledge clawback", ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_GRANTS))
	mint(burgher_pledge_fund, refill, "Burgher Pledge replenishment", null, ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_GRANTS))
	if(guild_bonus > 0)
		mint(burgher_pledge_fund, guild_bonus, "Guild of Arms tribute (Charter of Arms)", null, ledger_acct(LEDGER_BOOK_PLEDGE, LEDGER_KEY_GRANTS))
	record_round_statistic(STATS_PLEDGE_GENERATED, refill + guild_bonus)

/datum/controller/subsystem/treasury/proc/do_export(datum/roguestock/D, silent = FALSE)
	if(D.stockpile_amount < D.importexport_amt)
		return FALSE
	var/amt = D.get_export_price()
	D.stockpile_amount -= D.importexport_amt
	record_material_flow(MATERIAL_FLOW_OUT, MATERIAL_SOURCE_LOCAL_EXPORT, D.item_type, D.importexport_amt, amt)
	dirty_market_view()

	mint(discretionary_fund, amt, "exported [D.name]", null, LEDGER_CROWN_REV_EXPORT_SALES)
	SStreasury.total_export += amt
	economic_output += amt
	record_round_statistic(STATS_STOCKPILE_EXPORTS_VALUE, amt)
	return amt

/datum/controller/subsystem/treasury/proc/auto_export()
	var/total_value_exported = 0
	// Legacy non-trade-good entries: keep the old profitability guard. Trade-good entries
	// (the bulk of the warehouse) flow through mass_export_surplus() below.
	for(var/datum/roguestock/D in stockpile_datums)
		if(!D.importexport_amt || D.trade_good_id)
			continue
		if(D.autoexport_disabled)
			continue
		if((autoexport_percentage * D.stockpile_limit) >= D.stockpile_amount)
			continue
		if(D.get_export_price() <= (D.payout_price * D.importexport_amt))
			continue
		if(D.stockpile_amount >= D.importexport_amt)
			total_value_exported += do_export(D, TRUE)
	var/list/surplus_result = mass_export_surplus(silent = TRUE)
	total_value_exported += surplus_result["revenue"]

/datum/controller/subsystem/treasury/proc/mass_export_surplus(silent = FALSE)
	var/total_revenue = 0
	var/total_units = 0
	var/list/lines = list()
	for(var/datum/roguestock/D in stockpile_datums)
		if(!D.trade_good_id)
			continue
		if(!D.automatic_price)
			continue
		if(D.autoexport_disabled)
			continue
		if(!D.importexport_amt)
			continue
		var/keep = round(autoexport_percentage * D.stockpile_limit)
		if(is_auto_import_active(D.trade_good_id))
			keep = max(keep, AUTO_IMPORT_FLOOR)
		var/surplus = D.stockpile_amount - keep
		if(surplus <= 0)
			continue
		var/list/best = SSeconomy.get_best_export_region(D.trade_good_id)
		if(!best || !best["region_id"])
			continue
		var/datum/economic_region/region = GLOB.economic_regions[best["region_id"]]
		if(!region)
			continue
		var/remaining_demand = region.demands_today[D.trade_good_id] || 0
		if(remaining_demand <= 0)
			continue
		var/export_qty = min(surplus, remaining_demand)
		var/revenue = SSeconomy.manual_export(null, region.region_id, D.trade_good_id, export_qty)
		if(!revenue)
			continue
		total_revenue += revenue
		total_units += export_qty
		record_material_flow(MATERIAL_FLOW_OUT, MATERIAL_SOURCE_LOCAL_EXPORT, D.item_type, export_qty, revenue)
		if(!silent)
			lines += "[export_qty] [D.name] to [region.name] for [revenue]m"
	return list("revenue" = total_revenue, "units" = total_units, "lines" = lines)

/datum/controller/subsystem/treasury/proc/remove_person(mob/living/person)
	retire_fund(bank_accounts[person])
	noble_incomes -= person
	bank_accounts -= person
	write_off_poll_levy_receivable(poll_levy_owed[person] || 0, "Poll levy arrears written off (departed)")
	poll_levy_owed -= person
	poll_levy_grace_until -= person
	return TRUE

/datum/controller/subsystem/treasury/proc/apply_rate_adjustments(list/adjustments, good_announcement_text, bad_announcement_text)
	if(GLOB.dayspassed <= levy_rates_changed_day)
		to_chat(usr, span_warning("You already changed the levies today. Try again tomorrow."))
		return
	var/datum/decree/concordat = get_decree(DECREE_ZENITSTADT_CONCORDAT)
	var/concordat_active = concordat?.active ? TRUE : FALSE
	var/list/lines = list()
	var/bad_guy = FALSE
	var/rejected_concordat = FALSE
	for(var/entry in adjustments)
		var/category = entry["category"]
		if(!(category in tax_rates))
			continue
		if(category == TAX_CATEGORY_FINE)
			continue
		var/new_pct = CLAMP(entry["rate"], 0, 100)
		var/new_rate = new_pct / 100
		if(concordat_active && new_rate < CONCORDAT_TITHE_RATE)
			rejected_concordat = TRUE
			continue
		var/old_rate = tax_rates[category]
		if(new_rate == old_rate)
			continue
		var/old_pct = round(old_rate * 100)
		if(new_rate > old_rate)
			bad_guy = TRUE
		tax_rates[category] = new_rate
		var/pretty = get_tax_category_pretty_name(category)
		var/verb = new_rate > old_rate ? "raised" : "reduced"
		lines += "[pretty] [verb] from [old_pct]% to [new_pct]%."

	if(rejected_concordat)
		to_chat(usr, span_warning("While the Concordat of Zenitstadt is in force, no levy can go below [round(CONCORDAT_TITHE_RATE * 100)]%."))

	if(!length(lines))
		return

	levy_rates_changed_day = GLOB.dayspassed
	var/final_text = jointext(lines, "<br>")
	if(concordat_active)
		final_text += "<br><i>Under the Concordat of Zenitstadt, the Church of Azuria takes [round(CONCORDAT_TITHE_RATE * 100)]% of every taxed payment out of the Crown's share.</i>"
	var/final_announcement_text = bad_guy ? bad_announcement_text : good_announcement_text
	priority_announce(final_text, final_announcement_text, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
	log_game("TAX RATES: [usr ? key_name(usr) : "system"] changed levy rates - [jointext(lines, " | ")]")

/datum/controller/subsystem/treasury/proc/get_tax_category_pretty_name(category)
	switch(category)
		if(TAX_CATEGORY_CONTRACT_LEVY)
			return "Contract Levy"
		if(TAX_CATEGORY_HEADEATER_LEVY)
			return "Headeater Levy"
		if(TAX_CATEGORY_IMPORT_TARIFF)
			return "Import Tariff"
		if(TAX_CATEGORY_EXPORT_DUTY)
			return "Export Duty"
		if(TAX_CATEGORY_RECOVERED_SPOILS)
			return "Recovered Spoils"
		if(TAX_CATEGORY_FINE)
			return "Fine"
	return capitalize(category)

/datum/controller/subsystem/treasury/proc/withdraw_money_treasury(amt, target)
	if(!amt)
		return FALSE
	if(!burn(discretionary_fund, amt, "withdrawn by [target]", LEDGER_CROWN_EXP_WITHDRAWALS))
		return FALSE
	record_treasury_expense(TREASURY_FLOW_WITHDRAWAL, ismob(target) ? treasury_role_of(target) : "Unknown", amt)
	return TRUE

/datum/controller/subsystem/treasury/proc/get_poll_levy_category(mob/living/H)
	if(!H)
		return null
	if(HAS_TRAIT(H, TRAIT_OUTLAW) || HAS_TRAIT(H, TRAIT_ROYAL_SUBSIDY))
		return null
	if(HAS_TRAIT(H, TRAIT_NOBLE) || (H.job in GLOB.noble_positions))
		return POLL_LEVY_CAT_NOBLE
	if(H.job in GLOB.inquisition_positions)
		return POLL_LEVY_CAT_INQUISITION
	if((H.job in GLOB.church_positions) || HAS_TRAIT(H, TRAIT_AGENT_CHURCH))
		return POLL_LEVY_CAT_CLERGY
	if(H.job in POLL_LEVY_SCHOLAR_JOBS)
		return POLL_LEVY_CAT_SCHOLAR
	if((H.job in GLOB.courtier_positions) || H.job == "Court Agent")
		return POLL_LEVY_CAT_COURTIER
	if((H.job in GLOB.garrison_positions) || H.job == "Squire")
		return POLL_LEVY_CAT_GARRISON
	if(H.job in list("Guildmaster", "Guildsman", "Tailor"))
		return POLL_LEVY_CAT_GUILDS
	if(H.job == "Merchant")
		return POLL_LEVY_CAT_MERCHANT
	if((H.job in list("Innkeeper", "Bathmaster")) || HAS_TRAIT(H, TRAIT_RESIDENT))
		return POLL_LEVY_CAT_BURGHER
	if(H.job in GLOB.wanderer_positions)
		return POLL_LEVY_CAT_ADVENTURER
	if(H.job == "Mercenary")
		return POLL_LEVY_CAT_MERCENARY
	if((H.job in GLOB.peasant_positions) || (H.job in GLOB.sidefolk_positions) || (H.job == "Shophand"))
		return POLL_LEVY_CAT_PEASANT
	return null

/datum/controller/subsystem/treasury/proc/get_poll_levy_exempting_charter(category)
	var/decree_id
	switch(category)
		if(POLL_LEVY_CAT_NOBLE)
			decree_id = DECREE_GREAT_WRIT
		if(POLL_LEVY_CAT_CLERGY)
			decree_id = DECREE_ZENITSTADT_CONCORDAT
		if(POLL_LEVY_CAT_INQUISITION)
			decree_id = DECREE_OTAVAN_ACCORDS
	if(!decree_id)
		return null
	var/datum/decree/D = get_decree(decree_id)
	return D?.active ? D.name : null

/datum/controller/subsystem/treasury/proc/get_poll_levy_category_pretty_name(category)
	switch(category)
		if(POLL_LEVY_CAT_NOBLE)
			return "Noble"
		if(POLL_LEVY_CAT_CLERGY)
			return "Clergy"
		if(POLL_LEVY_CAT_INQUISITION)
			return "Inquisition"
		if(POLL_LEVY_CAT_COURTIER)
			return "Courtier"
		if(POLL_LEVY_CAT_GARRISON)
			return "Garrison"
		if(POLL_LEVY_CAT_GUILDS)
			return "Guilds"
		if(POLL_LEVY_CAT_MERCHANT)
			return "Merchant"
		if(POLL_LEVY_CAT_BURGHER)
			return "Burgher"
		if(POLL_LEVY_CAT_SCHOLAR)
			return "Scholar"
		if(POLL_LEVY_CAT_ADVENTURER)
			return "Adventurer"
		if(POLL_LEVY_CAT_MERCENARY)
			return "Mercenary"
		if(POLL_LEVY_CAT_PEASANT)
			return "Peasant"
	return capitalize(category)

/datum/controller/subsystem/treasury/proc/record_poll_levy_by_category(category, amount)
	if(!category || amount <= 0)
		return
	record_round_statistic(STATS_POLL_LEVY_COLLECTED, amount)
	switch(category)
		if(POLL_LEVY_CAT_NOBLE)
			record_round_statistic(STATS_POLL_LEVY_NOBLE, amount)
		if(POLL_LEVY_CAT_CLERGY)
			record_round_statistic(STATS_POLL_LEVY_CLERGY, amount)
		if(POLL_LEVY_CAT_INQUISITION)
			record_round_statistic(STATS_POLL_LEVY_INQUISITION, amount)
		if(POLL_LEVY_CAT_COURTIER)
			record_round_statistic(STATS_POLL_LEVY_COURTIER, amount)
		if(POLL_LEVY_CAT_GARRISON)
			record_round_statistic(STATS_POLL_LEVY_GARRISON, amount)
		if(POLL_LEVY_CAT_GUILDS)
			record_round_statistic(STATS_POLL_LEVY_GUILDS, amount)
		if(POLL_LEVY_CAT_MERCHANT)
			record_round_statistic(STATS_POLL_LEVY_MERCHANT, amount)
		if(POLL_LEVY_CAT_BURGHER)
			record_round_statistic(STATS_POLL_LEVY_BURGHER, amount)
		if(POLL_LEVY_CAT_SCHOLAR)
			record_round_statistic(STATS_POLL_LEVY_SCHOLAR, amount)
		if(POLL_LEVY_CAT_ADVENTURER)
			record_round_statistic(STATS_POLL_LEVY_ADVENTURER, amount)
		if(POLL_LEVY_CAT_MERCENARY)
			record_round_statistic(STATS_POLL_LEVY_MERCENARY, amount)
		if(POLL_LEVY_CAT_PEASANT)
			record_round_statistic(STATS_POLL_LEVY_PEASANT, amount)

/datum/controller/subsystem/treasury/proc/get_wage_floor(job_title)
	var/floor = 0
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		if(!D?.active)
			continue
		floor = D.apply_wage_floor(job_title, floor)
	return floor

/datum/controller/subsystem/treasury/proc/enumerate_wage_floored_jobs()
	var/list/out = list()
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		if(!D?.active)
			continue
		for(var/job in D.wage_floored_jobs())
			out |= job
	return out

/datum/controller/subsystem/treasury/proc/clear_poll_levy_debt(mob/living/H)
	if(!H)
		return
	if(poll_levy_owed[H])
		record_round_statistic(STATS_POLL_LEVY_ARREARS_FORGIVEN, poll_levy_owed[H])
		write_off_poll_levy_receivable(poll_levy_owed[H], "Poll levy arrears cleared")
	poll_levy_owed -= H
	if(HAS_TRAIT(H, TRAIT_ARREARS))
		REMOVE_TRAIT(H, TRAIT_ARREARS, TRAIT_GENERIC)
