// Double-entry engine: chart of accounts and balanced postings.
//
// mint/burn/transfer in fund_api.dm build their legs through the helpers here, so any code that
// moves money through those procs is automatically journalled. Anything that cannot name a
// counter-account lands in the book's "Unclassified" suspense accounts, which is both a safety
// valve (the books still balance) and a visible to-do list for the Steward.
//
// Leg format: list(account_id, debit, credit).

/datum/ledger_account
	var/id
	var/name
	var/book
	var/class
	var/debit_normal = TRUE
	var/currency = CURRENCY_MAMMON
	var/debits = 0
	var/credits = 0

/// Balance on the account's normal side. Negative means it has swung to the opposite side.
/datum/ledger_account/proc/get_balance()
	return debit_normal ? (debits - credits) : (credits - debits)

/proc/ledger_acct(book, key)
	return "[book]_[key]"

/proc/ledger_book_label(book)
	switch(book)
		if(LEDGER_BOOK_CROWN)
			return "Crown"
		if(LEDGER_BOOK_PLEDGE)
			return "Burgher Pledge"
		if(LEDGER_BOOK_CHURCH)
			return "Church"
		if(LEDGER_BOOK_MERCHANT)
			return "Merchant Fund"
		if(LEDGER_BOOK_BATHHOUSE)
			return "Bathhouse"
		if(LEDGER_BOOK_TAVERN)
			return "Tavern"
		if(LEDGER_BOOK_CITIZENS)
			return "Citizens"
	return capitalize(book)

GLOBAL_LIST_INIT(ledger_books, list(
	LEDGER_BOOK_CROWN,
	LEDGER_BOOK_PLEDGE,
	LEDGER_BOOK_CHURCH,
	LEDGER_BOOK_MERCHANT,
	LEDGER_BOOK_BATHHOUSE,
	LEDGER_BOOK_TAVERN,
	LEDGER_BOOK_CITIZENS,
))

GLOBAL_LIST_INIT(ledger_class_order, list(
	LEDGER_CLASS_ASSET,
	LEDGER_CLASS_LIABILITY,
	LEDGER_CLASS_EQUITY,
	LEDGER_CLASS_REVENUE,
	LEDGER_CLASS_EXPENSE,
	LEDGER_CLASS_SUSPENSE,
))

/datum/controller/subsystem/treasury/proc/add_ledger_account(id, name, book, class, debit_normal, currency = CURRENCY_MAMMON)
	if(isnull(debit_normal))
		debit_normal = (class == LEDGER_CLASS_ASSET || class == LEDGER_CLASS_EXPENSE)
	var/datum/ledger_account/A = new
	A.id = id
	A.name = name
	A.book = book
	A.class = class
	A.debit_normal = debit_normal
	A.currency = currency
	chart_of_accounts[id] = A
	return A

/datum/controller/subsystem/treasury/proc/init_chart_of_accounts()
	chart_of_accounts = list()
	for(var/book in GLOB.ledger_books)
		var/label = ledger_book_label(book)
		var/currency = (book == LEDGER_BOOK_PLEDGE) ? CURRENCY_BURGHER_PLEDGE : CURRENCY_MAMMON
		var/is_citizens = (book == LEDGER_BOOK_CITIZENS)
		var/cash_name = is_citizens ? "Citizen Deposits (control)" : (book == LEDGER_BOOK_CROWN ? "Crown Purse" : "[label] Cash")
		add_ledger_account(ledger_acct(book, LEDGER_KEY_CASH), cash_name, book, LEDGER_CLASS_ASSET, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_LOANS_REC), "Loans Receivable", book, LEDGER_CLASS_ASSET, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_LOANS_PAY), "Loans Payable", book, LEDGER_CLASS_LIABILITY, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_CAPITAL), "Opening Capital", book, LEDGER_CLASS_EQUITY, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_GRANTS), "Grants & Adjustments", book, LEDGER_CLASS_EQUITY, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_INCOME), is_citizens ? "Citizen Receipts" : "Other Receipts", book, LEDGER_CLASS_REVENUE, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_INTEREST_INC), "Interest Income", book, LEDGER_CLASS_REVENUE, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_EXPENSE), is_citizens ? "Citizen Payments" : "Other Disbursements", book, LEDGER_CLASS_EXPENSE, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_INTEREST_EXP), "Interest Expense", book, LEDGER_CLASS_EXPENSE, currency = currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_SUSP_IN), "Unclassified Receipts", book, LEDGER_CLASS_SUSPENSE, FALSE, currency)
		add_ledger_account(ledger_acct(book, LEDGER_KEY_SUSP_OUT), "Unclassified Disbursements", book, LEDGER_CLASS_SUSPENSE, TRUE, currency)

	// Crown liabilities
	add_ledger_account(LEDGER_CROWN_ARREARS_ADVANCE, "Burghers' Arrears Advance", LEDGER_BOOK_CROWN, LEDGER_CLASS_LIABILITY)
	add_ledger_account(LEDGER_CROWN_ATC_LOAN, "ATC Emergency Loan", LEDGER_BOOK_CROWN, LEDGER_CLASS_LIABILITY)
	add_ledger_account(LEDGER_CROWN_SEQUESTRATION_DEBT, "Sequestration Debt (ATC)", LEDGER_BOOK_CROWN, LEDGER_CLASS_LIABILITY)
	add_ledger_account(LEDGER_CROWN_BANDITRY_DEBT, "Brigand Debt", LEDGER_BOOK_CROWN, LEDGER_CLASS_LIABILITY)
	// Crown revenue
	add_ledger_account(LEDGER_CROWN_REV_CONTRACT_LEVY, "Contract Levy", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_HEADEATER_LEVY, "Headeater Levy", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_IMPORT_TARIFF, "Import Tariff", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_EXPORT_DUTY, "Export Duty", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_SPOILS, "Recovered Spoils", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_FINES, "Fines", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_POLL_TAX, "Poll Tax", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_EXPORT_SALES, "Export Sales", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_STANDING_ORDERS, "Standing Order Sales", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_STOCKPILE_SALES, "Stockpile Sales", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_QUALITY, "Quality Premiums", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_RURAL, "Rural Subsidy", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_BLOCKADE, "Blockade Defense Rewards", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_MAIL, "Mail Income", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CROWN_REV_REFUNDS, "Refunds Received", LEDGER_BOOK_CROWN, LEDGER_CLASS_REVENUE)
	// Crown expenses
	add_ledger_account(LEDGER_CROWN_EXP_WAGES, "Wages", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_IMPORTS, "Imports & Purchases", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_POLL_SUBSIDY, "Poll Subsidy", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_BANDITRY, "Brigand Losses", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_CONTRACTS, "Contract Outlay", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_TITHE, "Church Tithe", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_WITHDRAWALS, "Treasury Withdrawals", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_GRANTS, "Crown Grants & Payouts", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_QUALITY, "Quality Penalties", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_SEQUESTRATION, "Sequestration Charges", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CROWN_EXP_LOAN_LOSS, "Loan Losses", LEDGER_BOOK_CROWN, LEDGER_CLASS_EXPENSE)
	// Citizens
	add_ledger_account(LEDGER_CITIZEN_COIN_IN, "Coin Deposited at the Meister", LEDGER_BOOK_CITIZENS, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CITIZEN_COIN_OUT, "Coin Withdrawn from the Meister", LEDGER_BOOK_CITIZENS, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CITIZEN_WAGES, "Wages Received", LEDGER_BOOK_CITIZENS, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_CITIZEN_TAXES, "Taxes & Levies Paid", LEDGER_BOOK_CITIZENS, LEDGER_CLASS_EXPENSE)
	add_ledger_account(LEDGER_CITIZEN_CONTRACTS, "Contract Rewards", LEDGER_BOOK_CITIZENS, LEDGER_CLASS_REVENUE)
	// Other institutions
	add_ledger_account(LEDGER_CHURCH_TITHE_IN, "Tithes Received", LEDGER_BOOK_CHURCH, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_MERCHANT_LEVY_IN, "Merchant's Levy", LEDGER_BOOK_MERCHANT, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_MERCHANT_MARGIN_IN, "Trading Margin", LEDGER_BOOK_MERCHANT, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_BATHHOUSE_MARGIN_IN, "Purity Margin", LEDGER_BOOK_BATHHOUSE, LEDGER_CLASS_REVENUE)
	add_ledger_account(LEDGER_TAVERN_REFERRAL_IN, "Referral Fees", LEDGER_BOOK_TAVERN, LEDGER_CLASS_REVENUE)

/datum/controller/subsystem/treasury/proc/get_ledger_account(id)
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	return chart_of_accounts[id]

/// Account id of the counter-account to use when a caller did not classify a leg.
/datum/controller/subsystem/treasury/proc/default_counter_account(datum/fund/F, receipt)
	if(F.ledger_book == LEDGER_BOOK_CITIZENS)
		return ledger_acct(LEDGER_BOOK_CITIZENS, receipt ? LEDGER_KEY_INCOME : LEDGER_KEY_EXPENSE)
	return ledger_acct(F.ledger_book, receipt ? LEDGER_KEY_SUSP_IN : LEDGER_KEY_SUSP_OUT)

/// Normalises a caller-supplied counter-account into list(list(account_id, amount), ...).
/// counter may be null (use default), an account id, or an assoc list of account id -> amount.
/// Any part of `amount` not covered by an assoc list falls to the default account.
/datum/controller/subsystem/treasury/proc/ledger_counter_parts(counter, amount, default_id)
	var/list/parts = list()
	if(isnull(counter))
		parts += list(list(default_id, amount))
		return parts
	if(istext(counter))
		if(!get_ledger_account(counter))
			stack_trace("Unknown ledger account '[counter]'")
			parts += list(list(default_id, amount))
			return parts
		parts += list(list(counter, amount))
		return parts
	if(islist(counter))
		var/sum = 0
		for(var/id in counter)
			var/value = counter[id]
			if(!isnum(value) || value <= 0)
				continue
			if(!get_ledger_account(id))
				stack_trace("Unknown ledger account '[id]'")
				continue
			parts += list(list(id, value))
			sum += value
		if(sum > amount + 0.001)
			stack_trace("Ledger counter split [sum] exceeds amount [amount]")
			parts = list(list(default_id, amount))
		else if(sum < amount - 0.001)
			parts += list(list(default_id, amount - sum))
		return parts
	parts += list(list(default_id, amount))
	return parts

/// Legs for cash arriving in F. `credited` is what F actually receives; `gross` is what the
/// counter-accounts are credited with. The difference is the debt skim, passed as debit legs.
/datum/controller/subsystem/treasury/proc/ledger_in_legs(datum/fund/F, credited, gross, counter, list/debt_legs)
	var/list/legs = list()
	if(credited > 0)
		legs += list(list(F.get_cash_account(), credited, 0))
	for(var/list/debt_leg as anything in debt_legs)
		legs += list(list(debt_leg[1], debt_leg[2], 0))
	for(var/list/part as anything in ledger_counter_parts(counter, gross, default_counter_account(F, TRUE)))
		legs += list(list(part[1], 0, part[2]))
	return legs

/// Legs for cash leaving F.
/datum/controller/subsystem/treasury/proc/ledger_out_legs(datum/fund/F, amount, counter)
	var/list/legs = list(list(F.get_cash_account(), 0, amount))
	for(var/list/part as anything in ledger_counter_parts(counter, amount, default_counter_account(F, FALSE)))
		legs += list(list(part[1], part[2], 0))
	return legs

/// Validates and applies a posting to the account totals. Returns FALSE (and demotes the
/// entry to a memo line) if the posting is unbalanced or names an unknown account.
/datum/controller/subsystem/treasury/proc/post_legs(datum/treasury_entry/entry)
	if(!entry || !length(entry.legs))
		return FALSE
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/total_dr = 0
	var/total_cr = 0
	for(var/list/leg as anything in entry.legs)
		if(!chart_of_accounts[leg[1]])
			stack_trace("Ledger posting names unknown account '[leg[1]]' ([entry.reason])")
			entry.legs = null
			return FALSE
		total_dr += leg[2]
		total_cr += leg[3]
	if(abs(total_dr - total_cr) > 0.001)
		stack_trace("Unbalanced ledger posting Dr [total_dr] / Cr [total_cr] ([entry.reason])")
		entry.legs = null
		return FALSE
	for(var/list/leg as anything in entry.legs)
		var/datum/ledger_account/A = chart_of_accounts[leg[1]]
		A.debits += leg[2]
		A.credits += leg[3]
	return TRUE

/// Records a balanced entry that is not a plain mint/burn/transfer (opening balances, debt
/// accruals, sequestration resets, write-offs). `kind` only affects how the legacy journal views
/// label it; the legs are what count.
/datum/controller/subsystem/treasury/proc/post_ledger_entry(kind, reason, list/legs, datum/fund/from_fund, datum/fund/to_fund, from_label)
	var/amount = 0
	for(var/list/leg as anything in legs)
		amount += leg[2]
	var/datum/treasury_entry/entry = new(kind, from_fund, to_fund, amount, reason, from_label)
	entry.legs = legs
	log_fund_entry(entry)
	return entry

/// Seeds a fund's opening balance into the books (the fund was created with a balance already).
/datum/controller/subsystem/treasury/proc/post_opening_balance(datum/fund/F)
	if(!F || F.balance <= 0)
		return
	post_ledger_entry("opening", "Opening balance", list(
		list(F.get_cash_account(), F.balance, 0),
		list(ledger_acct(F.ledger_book, LEDGER_KEY_CAPITAL), 0, F.balance),
	), null, F)

/// Writes off whatever a discarded fund still holds so the books follow it out of existence.
/datum/controller/subsystem/treasury/proc/retire_fund(datum/fund/F, reason = "Dormant balance forfeited")
	if(!F)
		return
	if(F.balance > 0)
		var/amount = F.balance
		F.balance = 0
		post_ledger_entry("burn", reason, list(
			list(ledger_acct(F.ledger_book, LEDGER_KEY_GRANTS), amount, 0),
			list(F.get_cash_account(), 0, amount),
		), F)
	auxiliary_funds -= F

/// Registers a fund created outside the subsystem (e.g. escrow machines) so reconciliation sees it.
/datum/controller/subsystem/treasury/proc/register_auxiliary_fund(datum/fund/F)
	if(F)
		auxiliary_funds |= F

/// Repays outstanding debt out of an incoming credit. Returns debit legs (liability reductions).
/// The first account in priority order absorbs any remainder so the posting always balances.
/datum/controller/subsystem/treasury/proc/debt_repayment_legs(skim)
	var/list/legs = list()
	if(skim <= 0)
		return legs
	var/list/priority
	switch(treasury_state)
		if(TREASURY_BANKRUPTCY)
			priority = list(LEDGER_CROWN_SEQUESTRATION_DEBT, LEDGER_CROWN_ARREARS_ADVANCE, LEDGER_CROWN_ATC_LOAN)
		if(TREASURY_IN_ARREARS)
			priority = list(LEDGER_CROWN_ARREARS_ADVANCE, LEDGER_CROWN_ATC_LOAN, LEDGER_CROWN_SEQUESTRATION_DEBT)
		else
			priority = list(LEDGER_CROWN_ATC_LOAN, LEDGER_CROWN_ARREARS_ADVANCE, LEDGER_CROWN_SEQUESTRATION_DEBT)
	var/remaining = skim
	for(var/id in priority)
		var/datum/ledger_account/A = get_ledger_account(id)
		var/take = min(remaining, max(0, A.get_balance()))
		if(take <= 0)
			continue
		legs += list(list(id, take, 0))
		remaining -= take
	if(remaining > 0)
		legs += list(list(priority[1], remaining, 0))
	return legs

/// Splits a loan repayment into principal and interest, principal first, and returns
/// list("payer" = counter for the payer's side, "payee" = counter for the receiver's side).
/// Call BEFORE adding `amount` to L.repaid_so_far.
/datum/controller/subsystem/treasury/proc/loan_repayment_counters(datum/loan/L, amount, datum/fund/payer, datum/fund/payee)
	var/before = L.repaid_so_far
	var/principal_part = max(0, min(before + amount, L.principal) - min(before, L.principal))
	var/interest_part = amount - principal_part
	var/list/payer_counter = list()
	var/list/payee_counter = list()
	if(principal_part > 0)
		payer_counter[ledger_acct(payer.ledger_book, LEDGER_KEY_LOANS_PAY)] = principal_part
		payee_counter[ledger_acct(payee.ledger_book, LEDGER_KEY_LOANS_REC)] = principal_part
	if(interest_part > 0)
		payer_counter[ledger_acct(payer.ledger_book, LEDGER_KEY_INTEREST_EXP)] = interest_part
		payee_counter[ledger_acct(payee.ledger_book, LEDGER_KEY_INTEREST_INC)] = interest_part
	return list("payer" = payer_counter, "payee" = payee_counter)

/// Principal still carried as a receivable for this loan.
/datum/loan/proc/get_principal_outstanding()
	return max(0, principal - repaid_so_far)

/// Removes a loan that will never be repaid from the lender's (and borrower's) books.
/datum/controller/subsystem/treasury/proc/write_off_loan(datum/loan/L, reason = "Loan written off")
	var/outstanding = L.get_principal_outstanding()
	if(outstanding <= 0 || !L.source_fund)
		return
	var/lender_book = L.source_fund.ledger_book
	var/loss_acct = (lender_book == LEDGER_BOOK_CROWN) ? LEDGER_CROWN_EXP_LOAN_LOSS : ledger_acct(lender_book, LEDGER_KEY_EXPENSE)
	post_ledger_entry("writeoff", "[reason]: [L.debtor_name]", list(
		list(loss_acct, outstanding, 0),
		list(ledger_acct(lender_book, LEDGER_KEY_LOANS_REC), 0, outstanding),
	))
	// Borrower side: the obligation is forgiven, which is income to them.
	var/borrower_book = L.target_fund ? L.target_fund.ledger_book : LEDGER_BOOK_CITIZENS
	post_ledger_entry("writeoff", "[reason]: [L.debtor_name] (borrower)", list(
		list(ledger_acct(borrower_book, LEDGER_KEY_LOANS_PAY), outstanding, 0),
		list(ledger_acct(borrower_book, LEDGER_KEY_INCOME), 0, outstanding),
	))
