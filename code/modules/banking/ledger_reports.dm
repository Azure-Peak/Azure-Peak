// Reports over the double-entry books: daily close, reconciliation, trial balance, statements,
// general-ledger drill-down and the subsidiary ledgers. These only read; nothing here posts
// to the books.

/// Freezes the account totals at the end of `day` so period statements can diff against them.
/datum/controller/subsystem/treasury/proc/close_books_through(day)
	if(day <= ledger_closed_day)
		return
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/snap = list()
	for(var/id in chart_of_accounts)
		var/datum/ledger_account/A = chart_of_accounts[id]
		snap[id] = list(A.debits, A.credits)
	// Days that passed with nobody looking all close at the same totals.
	var/first = max(ledger_closed_day + 1, day - 40)
	for(var/d in first to day)
		day_snapshots["[d]"] = snap
	ledger_closed_day = day

/datum/controller/subsystem/treasury/proc/ledger_balance_in_snapshot(datum/ledger_account/A, list/snap)
	if(!snap)
		return 0
	var/list/totals = snap[A.id]
	if(!totals)
		return 0
	return A.debit_normal ? (totals[1] - totals[2]) : (totals[2] - totals[1])

/// Checks the books against the live balances and registers. Each row is list("label", "ledger",
/// "actual", "drift"). A non-zero drift means something moved money without going through the
/// posting procs (or a posting was demoted for being unbalanced).
/// `only_book` limits the report to one institution. The Steward's machine passes the Crown so it
/// never sees the private books of the Church, Merchantry, Bathhouse and so on.
/datum/controller/subsystem/treasury/proc/reconcile_ledger(only_book)
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/rows = list()
	var/list/cash_funds = list(
		LEDGER_BOOK_CROWN = discretionary_fund,
		LEDGER_BOOK_PLEDGE = burgher_pledge_fund,
		LEDGER_BOOK_CHURCH = church_fund,
		LEDGER_BOOK_MERCHANT = merchant_fund,
		LEDGER_BOOK_BATHHOUSE = bathhouse_fund,
		LEDGER_BOOK_TAVERN = innkeeper_fund,
	)
	for(var/book in cash_funds)
		if(only_book && book != only_book)
			continue
		var/datum/fund/F = cash_funds[book]
		var/datum/ledger_account/A = chart_of_accounts[ledger_acct(book, LEDGER_KEY_CASH)]
		rows += list(ledger_recon_row("[A.name] vs fund balance", A.get_balance(), F ? F.balance : 0))

	if(!only_book || only_book == LEDGER_BOOK_CITIZENS)
		var/citizen_total = 0
		for(var/key in bank_accounts)
			var/datum/fund/account = bank_accounts[key]
			if(account)
				citizen_total += account.balance
		for(var/datum/fund/aux as anything in auxiliary_funds)
			citizen_total += aux.balance
		var/datum/ledger_account/deposits = chart_of_accounts[LEDGER_CITIZEN_CASH]
		rows += list(ledger_recon_row("Citizen Deposits vs sum of personal accounts and escrow holds", deposits.get_balance(), citizen_total))

	if(!only_book || only_book == LEDGER_BOOK_CROWN)
		var/debt_ledger = 0
		for(var/id in list(LEDGER_CROWN_ARREARS_ADVANCE, LEDGER_CROWN_ATC_LOAN, LEDGER_CROWN_SEQUESTRATION_DEBT))
			var/datum/ledger_account/D = chart_of_accounts[id]
			debt_ledger += D.get_balance()
		rows += list(ledger_recon_row("Crown debt accounts vs treasury debt", debt_ledger, treasury_debt))
		var/datum/ledger_account/banditry = chart_of_accounts[LEDGER_CROWN_BANDITRY_DEBT]
		rows += list(ledger_recon_row("Brigand Debt vs banditry debt", banditry.get_balance(), banditry_debt))

		var/arrears_total = 0
		for(var/owner in poll_tax_owed)
			arrears_total += poll_tax_owed[owner]
		var/datum/ledger_account/poll_rec = chart_of_accounts[LEDGER_CROWN_POLL_RECEIVABLE]
		rows += list(ledger_recon_row("Poll Tax Receivable vs arrears owed", poll_rec.get_balance(), arrears_total))

		var/advance_total = 0
		for(var/owner in poll_tax_advance_value)
			advance_total += poll_tax_advance_value[owner]
		var/datum/ledger_account/poll_def = chart_of_accounts[LEDGER_CROWN_POLL_DEFERRED]
		rows += list(ledger_recon_row("Poll Tax Received in Advance vs prepaid balances", poll_def.get_balance(), advance_total))

		var/interest_total = 0
		for(var/datum/loan/L as anything in loans)
			if(L.source_fund == discretionary_fund)
				interest_total += max(0, L.interest_accrued - L.get_interest_repaid())
		var/datum/ledger_account/interest_rec = chart_of_accounts[LEDGER_CROWN_INTEREST_RECEIVABLE]
		rows += list(ledger_recon_row("Interest Receivable vs interest accrued on open loans", interest_rec.get_balance(), interest_total))

	for(var/book in GLOB.ledger_books)
		if(only_book && book != only_book)
			continue
		var/expected_rec = 0
		var/expected_pay = 0
		for(var/datum/loan/L as anything in loans)
			if(L.source_fund?.ledger_book == book)
				expected_rec += L.get_principal_outstanding()
			var/borrower_book = L.target_fund ? L.target_fund.ledger_book : LEDGER_BOOK_CITIZENS
			if(borrower_book == book)
				expected_pay += L.get_principal_outstanding()
		var/datum/ledger_account/rec = chart_of_accounts[ledger_acct(book, LEDGER_KEY_LOANS_REC)]
		var/datum/ledger_account/pay = chart_of_accounts[ledger_acct(book, LEDGER_KEY_LOANS_PAY)]
		if(rec.get_balance() || expected_rec)
			rows += list(ledger_recon_row("[ledger_book_label(book)] Loans Receivable vs open loans", rec.get_balance(), expected_rec))
		if(pay.get_balance() || expected_pay)
			rows += list(ledger_recon_row("[ledger_book_label(book)] Loans Payable vs open loans", pay.get_balance(), expected_pay))

	for(var/book in GLOB.ledger_books)
		if(only_book && book != only_book)
			continue
		var/total_debits = 0
		var/total_credits = 0
		for(var/id in chart_of_accounts)
			var/datum/ledger_account/A = chart_of_accounts[id]
			if(A.book == book)
				total_debits += A.debits
				total_credits += A.credits
		// "Books" is everything debited and "Actual" everything credited; they must match.
		rows += list(ledger_recon_row("[ledger_book_label(book)] book: total debits vs total credits", total_debits, total_credits))
	return rows

/datum/controller/subsystem/treasury/proc/ledger_recon_row(label, ledger_value, actual_value)
	return list(
		"label" = label,
		"ledger" = round(ledger_value, 0.01),
		"actual" = round(actual_value, 0.01),
		"drift" = round(ledger_value - actual_value, 0.01),
	)

/// Trial balance for one book. Each balance is shown on the side it sits on.
/datum/controller/subsystem/treasury/proc/get_trial_balance(book)
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/rows = list()
	var/total_dr = 0
	var/total_cr = 0
	for(var/class in GLOB.ledger_class_order)
		for(var/id in chart_of_accounts)
			var/datum/ledger_account/A = chart_of_accounts[id]
			if(A.book != book || A.class != class)
				continue
			if(!A.debits && !A.credits)
				continue
			var/net = A.debits - A.credits
			var/dr = max(net, 0)
			var/cr = max(-net, 0)
			total_dr += dr
			total_cr += cr
			rows += list(list("id" = A.id, "name" = A.name, "class" = A.class, "dr" = dr, "cr" = cr))
	return list(
		"book" = book,
		"book_label" = ledger_book_label(book),
		"rows" = rows,
		"total_dr" = total_dr,
		"total_cr" = total_cr,
		"balanced" = abs(total_dr - total_cr) < 0.01,
	)

/// Revenue & expense report for a book: round total, since the last close, and the last closed day.
/datum/controller/subsystem/treasury/proc/get_income_statement(book)
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/latest = day_snapshots["[ledger_closed_day]"]
	var/list/previous = day_snapshots["[ledger_closed_day - 1]"]
	var/list/revenue = list()
	var/list/expenses = list()
	var/list/totals = list("revenue" = list(0, 0, 0), "expenses" = list(0, 0, 0))
	for(var/id in chart_of_accounts)
		var/datum/ledger_account/A = chart_of_accounts[id]
		if(A.book != book)
			continue
		if(A.class != LEDGER_CLASS_REVENUE && A.class != LEDGER_CLASS_EXPENSE)
			continue
		if(!A.debits && !A.credits)
			continue
		var/total = A.get_balance()
		var/at_close = ledger_balance_in_snapshot(A, latest)
		var/at_prior = ledger_balance_in_snapshot(A, previous)
		var/open_day = total - at_close
		var/last_day = at_close - at_prior
		var/list/row = list("id" = A.id, "name" = A.name, "total" = total, "today" = open_day, "yesterday" = last_day)
		var/list/bucket = (A.class == LEDGER_CLASS_REVENUE) ? totals["revenue"] : totals["expenses"]
		bucket[1] += total
		bucket[2] += open_day
		bucket[3] += last_day
		if(A.class == LEDGER_CLASS_REVENUE)
			revenue += list(row)
		else
			expenses += list(row)
	var/list/rev = totals["revenue"]
	var/list/expense_totals = totals["expenses"]
	return list(
		"book" = book,
		"book_label" = ledger_book_label(book),
		"revenue" = revenue,
		"expenses" = expenses,
		"revenue_total" = rev[1],
		"expense_total" = expense_totals[1],
		"net_total" = rev[1] - expense_totals[1],
		"revenue_today" = rev[2],
		"expense_today" = expense_totals[2],
		"net_today" = rev[2] - expense_totals[2],
		"revenue_yesterday" = rev[3],
		"expense_yesterday" = expense_totals[3],
		"net_yesterday" = rev[3] - expense_totals[3],
		"closed_day" = ledger_closed_day,
	)

/datum/controller/subsystem/treasury/proc/get_balance_sheet(book)
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/assets = list()
	var/list/liabilities = list()
	var/list/equity = list()
	var/total_assets = 0
	var/total_liabilities = 0
	var/total_equity = 0
	var/surplus = 0
	var/unclassified = 0
	for(var/id in chart_of_accounts)
		var/datum/ledger_account/A = chart_of_accounts[id]
		if(A.book != book || (!A.debits && !A.credits))
			continue
		var/bal = A.get_balance()
		var/list/row = list("id" = A.id, "name" = A.name, "balance" = bal)
		switch(A.class)
			if(LEDGER_CLASS_ASSET)
				assets += list(row)
				total_assets += bal
			if(LEDGER_CLASS_LIABILITY)
				liabilities += list(row)
				total_liabilities += bal
			if(LEDGER_CLASS_EQUITY)
				equity += list(row)
				total_equity += bal
			if(LEDGER_CLASS_REVENUE)
				surplus += bal
			if(LEDGER_CLASS_EXPENSE)
				surplus -= bal
			if(LEDGER_CLASS_SUSPENSE)
				// Credit-normal suspense (receipts) adds to the equity side, debit-normal subtracts.
				unclassified += A.debit_normal ? -bal : bal
	var/equity_side = total_liabilities + total_equity + surplus + unclassified
	return list(
		"book" = book,
		"book_label" = ledger_book_label(book),
		"assets" = assets,
		"liabilities" = liabilities,
		"equity" = equity,
		"surplus" = surplus,
		"unclassified" = unclassified,
		"total_assets" = total_assets,
		"total_liabilities" = total_liabilities,
		"total_equity" = total_equity,
		"total_equity_side" = equity_side,
		"balanced" = abs(total_assets - equity_side) < 0.01,
	)

/// Chart listing for a book with live balances, used to pick an account to drill into.
/datum/controller/subsystem/treasury/proc/get_chart_listing(book)
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/out = list()
	for(var/class in GLOB.ledger_class_order)
		for(var/id in chart_of_accounts)
			var/datum/ledger_account/A = chart_of_accounts[id]
			if(A.book != book || A.class != class)
				continue
			out += list(list("id" = A.id, "name" = A.name, "class" = A.class, "balance" = A.get_balance(), "active" = (A.debits || A.credits) ? TRUE : FALSE))
	return out

/// General-ledger T-account for one account, newest first, each row carrying the running balance.
/datum/controller/subsystem/treasury/proc/get_account_ledger(account_id, max_rows = 100)
	var/datum/ledger_account/A = get_ledger_account(account_id)
	if(!A)
		return null
	var/list/rows = list()
	var/running = 0
	for(var/datum/treasury_entry/E as anything in ledger)
		if(!E.legs)
			continue
		for(var/list/leg as anything in E.legs)
			if(leg[1] != account_id)
				continue
			running += A.debit_normal ? (leg[2] - leg[3]) : (leg[3] - leg[2])
			rows += list(list(
				"no" = E.entry_no,
				"day" = E.day,
				"reason" = E.reason || "",
				"dr" = leg[2],
				"cr" = leg[3],
				"balance" = running,
				"count" = E.count,
			))
	var/list/newest_first = list()
	for(var/i = length(rows) to max(1, length(rows) - max_rows + 1) step -1)
		newest_first += list(rows[i])
	return list(
		"id" = A.id,
		"name" = A.name,
		"class" = A.class,
		"book_label" = ledger_book_label(A.book),
		"debit_normal" = A.debit_normal,
		"debits" = A.debits,
		"credits" = A.credits,
		"balance" = A.get_balance(),
		"rows" = newest_first,
		"total_rows" = length(rows),
	)

/// Name for the fundless side of a posting: the account(s) the money came from or went to,
/// rather than a generic placeholder. `receipt` is TRUE for the source of a mint.
/datum/controller/subsystem/treasury/proc/counterparty_label(datum/treasury_entry/E, receipt)
	var/list/names = list()
	for(var/list/leg as anything in E.legs)
		if(copytext(leg[1], -5) == "_cash")
			continue
		if(receipt ? !leg[3] : !leg[2])
			continue
		var/datum/ledger_account/A = chart_of_accounts[leg[1]]
		if(A && !(A.name in names))
			names += A.name
	if(!length(names))
		return LEDGER_REALM_LABEL
	if(length(names) == 1)
		return names[1]
	return "[names[1]] and [length(names) - 1] other[length(names) > 2 ? "s" : ""]"

/// Journal rows for display. Only the legs inside `book` are shown when a book is given.
/datum/controller/subsystem/treasury/proc/journal_entry_view(datum/treasury_entry/E, book)
	var/from_label = E.from_name
	var/to_label = E.to_name
	if(length(E.legs))
		if(from_label == LEDGER_REALM_LABEL)
			from_label = counterparty_label(E, TRUE)
		if(to_label == LEDGER_REALM_LABEL)
			to_label = counterparty_label(E, FALSE)
	var/list/leg_view = list()
	for(var/list/leg as anything in E.legs)
		if(book && findtext(leg[1], "[book]_") != 1)
			continue
		var/datum/ledger_account/A = chart_of_accounts[leg[1]]
		leg_view += list(list("account" = A ? A.name : leg[1], "dr" = leg[2], "cr" = leg[3]))
	return list(
		"no" = E.entry_no,
		"day" = E.day,
		"kind" = E.kind,
		"from" = from_label,
		"to" = to_label,
		"amount" = E.amount,
		"reason" = E.reason || "",
		"count" = E.count || 1,
		"actor" = E.actor,
		"legs" = leg_view,
	)

/proc/cmp_stockpile_value_desc(list/a, list/b)
	return b["value"] - a["value"]

/// Subsidiary ledgers behind the control accounts: receivables, payables, payroll, taxes.
/datum/controller/subsystem/treasury/proc/get_subsidiary_ledgers()
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/loan_rows = list()
	for(var/datum/loan/L as anything in loans)
		// Only loans the Crown is a party to; other lenders' and borrowers' accounts are private.
		if(L.source_fund != discretionary_fund && L.target_fund != discretionary_fund)
			continue
		loan_rows += list(list(
			"debtor" = L.debtor_name,
			"lender" = L.source_fund?.name,
			"principal" = L.principal,
			"rate_pct" = round(L.interest_rate * 100),
			"due_day" = L.due_on_day,
			"repaid" = L.repaid_so_far,
			"principal_outstanding" = L.get_principal_outstanding(),
			"remaining_due" = L.get_remaining_due(),
			"defaulted" = L.defaulted ? TRUE : FALSE,
		))

	var/list/arrears_rows = list()
	for(var/mob/living/owner as anything in poll_tax_owed)
		if(!owner)
			continue
		arrears_rows += list(list(
			"name" = owner.real_name,
			"job" = owner.job,
			"owed" = poll_tax_owed[owner],
			"days" = poll_tax_debt_days[owner] || 0,
		))

	var/list/payables = list()
	for(var/id in list(LEDGER_CROWN_ARREARS_ADVANCE, LEDGER_CROWN_ATC_LOAN, LEDGER_CROWN_SEQUESTRATION_DEBT, LEDGER_CROWN_BANDITRY_DEBT, LEDGER_CROWN_POLL_DEFERRED))
		var/datum/ledger_account/A = chart_of_accounts[id]
		payables += list(list("name" = A.name, "balance" = A.get_balance()))
	// Fractions owed to the Church are not posted until they accrue to a whole coin.
	payables += list(list("name" = "Church tithe accruing (not yet posted)", "balance" = round(concordat_tithe_debt, 0.01)))

	var/list/receivables = list()
	for(var/id in list(LEDGER_CROWN_LOANS_REC, LEDGER_CROWN_INTEREST_RECEIVABLE, LEDGER_CROWN_POLL_RECEIVABLE))
		var/datum/ledger_account/A = chart_of_accounts[id]
		receivables += list(list("name" = A.name, "balance" = A.get_balance()))

	var/list/inventory = list()
	var/inventory_live = 0
	for(var/datum/roguestock/D as anything in stockpile_datums)
		if(D.stockpile_amount <= 0)
			continue
		var/line_value = D.stockpile_amount * D.payout_price
		inventory_live += line_value
		inventory += list(list("name" = D.name, "units" = D.stockpile_amount, "unit_price" = D.payout_price, "value" = line_value))
	sortTim(inventory, GLOBAL_PROC_REF(cmp_stockpile_value_desc))
	var/datum/ledger_account/inventory_acct = chart_of_accounts[LEDGER_CROWN_INVENTORY]

	var/list/payroll = list()
	var/payroll_total = 0
	if(steward_machine?.daily_payments)
		var/list/headcount = list()
		var/list/suspended = list()
		for(var/mob/living/owner as anything in bank_accounts)
			if(!owner)
				continue
			headcount[owner.job] = (headcount[owner.job] || 0) + 1
			var/datum/fund/account = bank_accounts[owner]
			if(account?.wages_suspended)
				suspended[owner.job] = (suspended[owner.job] || 0) + 1
		var/list/payments = steward_machine.daily_payments
		for(var/job in payments)
			var/wage = payments[job]
			if(!wage)
				continue
			var/paid_heads = (headcount[job] || 0) - (suspended[job] || 0)
			payroll += list(list("job" = job, "wage" = wage, "heads" = headcount[job] || 0, "suspended" = suspended[job] || 0, "daily_cost" = wage * paid_heads))
			payroll_total += wage * paid_heads

	var/list/tax_rows = list()
	var/list/tax_map = list(
		list(TAX_CATEGORY_CONTRACT_LEVY, LEDGER_CROWN_REV_CONTRACT_LEVY, STATS_EXEMPTED_CONTRACT_LEVY),
		list(TAX_CATEGORY_HEADEATER_LEVY, LEDGER_CROWN_REV_HEADEATER_LEVY, STATS_EXEMPTED_HEADEATER_LEVY),
		list(TAX_CATEGORY_IMPORT_TARIFF, LEDGER_CROWN_REV_IMPORT_TARIFF, STATS_EXEMPTED_IMPORT_TARIFF),
		list(TAX_CATEGORY_EXPORT_DUTY, LEDGER_CROWN_REV_EXPORT_DUTY, STATS_EXEMPTED_EXPORT_DUTY),
		list(TAX_CATEGORY_RECOVERED_SPOILS, LEDGER_CROWN_REV_SPOILS, null),
		list(TAX_CATEGORY_FINE, LEDGER_CROWN_REV_FINES, STATS_EXEMPTED_FINE),
	)
	for(var/list/spec as anything in tax_map)
		var/datum/ledger_account/A = chart_of_accounts[spec[2]]
		tax_rows += list(list(
			"name" = get_tax_category_pretty_name(spec[1]),
			"rate_pct" = round((tax_rates[spec[1]] || 0) * 100),
			"collected" = A.get_balance(),
			"exempted" = spec[3] ? (GLOB.azure_round_stats[spec[3]] || 0) : 0,
		))
	var/datum/ledger_account/poll = chart_of_accounts[LEDGER_CROWN_REV_POLL_TAX]
	tax_rows += list(list("name" = "Poll Tax", "rate_pct" = null, "collected" = poll.get_balance(), "exempted" = GLOB.azure_round_stats[STATS_EXEMPTED_POLL_TAX] || 0))

	return list(
		"loans" = loan_rows,
		"poll_arrears" = arrears_rows,
		"payables" = payables,
		"receivables" = receivables,
		"inventory" = inventory,
		"inventory_live" = inventory_live,
		"inventory_booked" = inventory_acct.get_balance(),
		"payroll" = payroll,
		"payroll_total" = payroll_total,
		"taxes" = tax_rows,
	)

/// Plain HTML dump of every book: reconciliation, trial balances and Crown statements. Admin use.
/datum/controller/subsystem/treasury/proc/ledger_admin_report_html()
	var/list/html = list("<html><head><title>Ledger Report</title></head><body style='font-family:monospace'>")
	html += "<h2>Reconciliation</h2><table border=1 cellpadding=3><tr><th>Check</th><th>Ledger</th><th>Actual</th><th>Drift</th></tr>"
	for(var/list/row as anything in reconcile_ledger())
		var/drift = row["drift"]
		html += "<tr><td>[row["label"]]</td><td>[row["ledger"]]</td><td>[row["actual"]]</td><td>[abs(drift) >= 0.5 ? "<b><font color='red'>[drift]</font></b>" : drift]</td></tr>"
	html += "</table>"
	for(var/book in GLOB.ledger_books)
		var/list/tb = get_trial_balance(book)
		html += "<h2>Trial Balance - [tb["book_label"]] [tb["balanced"] ? "" : "<font color='red'>(UNBALANCED)</font>"]</h2>"
		html += "<table border=1 cellpadding=3><tr><th>Account</th><th>Class</th><th>Dr</th><th>Cr</th></tr>"
		for(var/list/row as anything in tb["rows"])
			html += "<tr><td>[row["name"]]</td><td>[row["class"]]</td><td>[row["dr"] || ""]</td><td>[row["cr"] || ""]</td></tr>"
		html += "<tr><td colspan=2><b>Total</b></td><td><b>[tb["total_dr"]]</b></td><td><b>[tb["total_cr"]]</b></td></tr></table>"
	var/list/inc = get_income_statement(LEDGER_BOOK_CROWN)
	html += "<h2>Crown Income Statement (round to date)</h2><table border=1 cellpadding=3>"
	for(var/list/row as anything in inc["revenue"])
		html += "<tr><td>[row["name"]]</td><td>[row["total"]]</td></tr>"
	html += "<tr><td><b>Total revenue</b></td><td><b>[inc["revenue_total"]]</b></td></tr>"
	for(var/list/row as anything in inc["expenses"])
		html += "<tr><td>[row["name"]]</td><td>([row["total"]])</td></tr>"
	html += "<tr><td><b>Total expenses</b></td><td><b>([inc["expense_total"]])</b></td></tr>"
	html += "<tr><td><b>Net surplus</b></td><td><b>[inc["net_total"]]</b></td></tr></table>"
	html += "</body></html>"
	return jointext(html, "")

/client/proc/cmd_admin_ledger_report()
	set category = "Debug"
	set name = "Ledger Reconciliation"
	if(!check_rights(R_ADMIN))
		return
	usr << browse(SStreasury.ledger_admin_report_html(), "window=ledger_report;size=800x700")
