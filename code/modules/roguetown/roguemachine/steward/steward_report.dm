/obj/item/paper/steward_report
	name = "steward's morning report"
	desc = "A stamped sheet summarising yesterday's dispatches, for the Steward."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll"
	info = ""
	resistance_flags = FIRE_PROOF

/// Called at the end of SSeconomy.daily_tick. Prints a report onto the Nerve Master's tile.
/// `diff` is a /list produced by SSeconomy across the tick; see build_steward_report_body.
/proc/print_steward_report(list/diff)
	if(!diff)
		return
	var/obj/structure/roguemachine/steward/nm = SStreasury?.steward_machine
	if(!nm)
		return
	var/turf/drop = get_turf(nm)
	if(!drop)
		return
	var/obj/item/paper/steward_report/R = new(drop)
	R.name = "steward's morning report (day [diff["day"] || GLOB.dayspassed])"
	diff["finance"] = SStreasury.build_report_finance()
	R.info = build_steward_report_body(diff)
	R.update_icon()
	playsound(drop, 'sound/misc/coindispense.ogg', 40, FALSE, -1)

/proc/build_steward_report_body(list/diff)
	var/list/events_fired = diff["events_fired"]
	var/list/events_expired = diff["events_expired"]
	var/list/blockades_fired = diff["blockades_fired"]
	var/list/blockades_cleared = diff["blockades_cleared"]
	var/list/banditry_lines = diff["banditry_drain_lines"]
	var/banditry_total = diff["banditry_drain_total"] || 0
	var/banditry_burned = diff["banditry_drain_burned"] || 0
	var/banditry_debt_accrued = diff["banditry_drain_accrued_debt"] || 0
	var/banditry_hoard = diff["banditry_hoard_total"] || 0
	var/orders_rolled = diff["orders_rolled"] || 0
	var/urgent_rolled = diff["urgent_rolled"] || 0
	var/day = diff["day"] || GLOB.dayspassed
	var/list/finance = diff["finance"]

	var/body = "<center><b>STEWARD'S MORNING REPORT</b></center><br>"
	body += "<center><i>Day [day]</i></center><br><hr>"

	if(finance)
		body += build_steward_report_finance_section(finance)

	if(length(blockades_fired))
		body += "<b>New blockades:</b><br>"
		for(var/line in blockades_fired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(blockades_cleared))
		body += "<b>Blockades lifted:</b><br>"
		for(var/line in blockades_cleared)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(events_fired))
		body += "<b>New economic events:</b><br>"
		for(var/line in events_fired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(events_expired))
		body += "<b>Events returned to normal:</b><br>"
		for(var/line in events_expired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(banditry_total > 0)
		body += "<b>Losses to brigands:</b> <font color='#c44'>-[banditry_total]m</font><br>"
		for(var/line in banditry_lines)
			body += "&nbsp;&nbsp;- [line]<br>"
		if(banditry_debt_accrued > 0)
			body += "<i>The Treasury could only pay [banditry_burned]m of the loss. The other <font color='#c44'>[banditry_debt_accrued]m</font> is added to brigand debt, which comes out of future income until it is paid off.</i><br>"
		body += "<br>"
	if(banditry_hoard > 0)
		body += "<b>Brigand Hoard:</b> <font color='#c44'>[banditry_hoard]m</font> across their hoards. Recovering a hoard or breaking a blockade reclaims it, and the Crown taxes a share as Recovered Spoils.<br><br>"
	if(orders_rolled)
		body += "<b>Standing orders posted this morning:</b> [orders_rolled]"
		if(urgent_rolled)
			body += " ([urgent_rolled] urgent)"
		body += "<br><br>"
	if(!length(blockades_fired) && !length(blockades_cleared) && !length(events_fired) && !length(events_expired) && !orders_rolled && banditry_total <= 0 && banditry_hoard <= 0)
		body += "<i>The roads are quiet. No shipment was disturbed overnight.</i><br>"

	body += "<hr><center><i>Use the Contract Ledger to post contracts in response.</i></center>"
	return body

/// Crown revenue and expense balances by account id, for diffing between reports.
/datum/controller/subsystem/treasury/proc/report_ledger_snapshot()
	var/list/snap = list()
	for(var/id in chart_of_accounts)
		var/datum/ledger_account/A = chart_of_accounts[id]
		if(A.book != LEDGER_BOOK_CROWN)
			continue
		if(A.class == LEDGER_CLASS_REVENUE || A.class == LEDGER_CLASS_EXPENSE)
			snap[id] = A.get_balance()
	return snap

/// Gathers the Steward report's money section: what came in and went out since the last report,
/// the purse, solvency, and what is owed to or by the Crown. Also advances the "since last report" baseline.
/datum/controller/subsystem/treasury/proc/build_report_finance()
	if(!discretionary_fund)
		return null
	if(!length(chart_of_accounts))
		init_chart_of_accounts()
	var/list/snap = report_ledger_snapshot()
	var/list/income = list()
	var/list/spending = list()
	var/income_total = 0
	var/spending_total = 0
	for(var/id in snap)
		var/delta = snap[id] - (last_report_ledger ? (last_report_ledger[id] || 0) : 0)
		if(!delta)
			continue
		var/datum/ledger_account/A = chart_of_accounts[id]
		if(A.class == LEDGER_CLASS_REVENUE)
			income += list(list("name" = A.name, "amount" = delta))
			income_total += delta
		else
			spending += list(list("name" = A.name, "amount" = delta))
			spending_total += delta
	sortTim(income, GLOBAL_PROC_REF(cmp_treasury_role_desc))
	sortTim(spending, GLOBAL_PROC_REF(cmp_treasury_role_desc))

	var/discrepancies = 0
	for(var/list/row as anything in reconcile_ledger())
		if(abs(row["drift"]) >= 0.5)
			discrepancies++

	var/list/fiscal = compute_fiscal_snapshot()
	var/list/out = list(
		"first" = isnull(last_report_balance),
		"balance" = discretionary_fund.balance,
		"balance_change" = isnull(last_report_balance) ? 0 : discretionary_fund.balance - last_report_balance,
		"income" = income,
		"income_total" = income_total,
		"spending" = spending,
		"spending_total" = spending_total,
		"state_label" = bankruptcy_state_label(treasury_state),
		"treasury_debt" = treasury_debt,
		"banditry_debt" = banditry_debt,
		"wage_outlay" = fiscal["expected_wage_outlay"],
		"rural_revenue" = fiscal["expected_rural_revenue"],
		"loans_outstanding" = fiscal["loans_outstanding"],
		"loan_exposure" = fiscal["loan_exposure"],
		"debtors" = fiscal["debtor_count"],
		"poll_arrears" = fiscal["in_arrears"],
		"discrepancies" = discrepancies,
	)
	last_report_ledger = snap
	last_report_balance = discretionary_fund.balance
	return out

#define STEWARD_REPORT_TOP_LINES 3

/proc/build_steward_report_finance_section(list/finance)
	var/body = ""
	var/change = finance["balance_change"]
	body += "<b>Treasury:</b> [finance["balance"]]m"
	if(!finance["first"])
		body += " (<font color='[change >= 0 ? "#2a7" : "#c44"]'>[change >= 0 ? "+" : ""][change]m</font> since the last report)"
	body += "<br>"
	body += "<b>Standing:</b> [finance["state_label"]]"
	if(finance["treasury_debt"] > 0)
		body += ", owing [finance["treasury_debt"]]m to its creditors"
	if(finance["banditry_debt"] > 0)
		body += ", with [finance["banditry_debt"]]m of brigand debt being skimmed from income"
	body += ".<br><br>"

	var/period = finance["first"] ? "so far" : "since the last report"
	var/list/income = finance["income"]
	if(length(income))
		body += "<b>Coming in, [period]:</b> <font color='#2a7'>+[finance["income_total"]]m</font><br>"
		var/shown = 0
		for(var/list/row as anything in income)
			if(++shown > STEWARD_REPORT_TOP_LINES)
				break
			body += "&nbsp;&nbsp;- [row["name"]]: [row["amount"]]m<br>"
		if(length(income) > STEWARD_REPORT_TOP_LINES)
			body += "&nbsp;&nbsp;- <i>and [length(income) - STEWARD_REPORT_TOP_LINES] other source\s</i><br>"
		body += "<br>"
	var/list/spending = finance["spending"]
	if(length(spending))
		body += "<b>Going out, [period]:</b> <font color='#c44'>-[finance["spending_total"]]m</font><br>"
		var/shown = 0
		for(var/list/row as anything in spending)
			if(++shown > STEWARD_REPORT_TOP_LINES)
				break
			body += "&nbsp;&nbsp;- [row["name"]]: [row["amount"]]m<br>"
		if(length(spending) > STEWARD_REPORT_TOP_LINES)
			body += "&nbsp;&nbsp;- <i>and [length(spending) - STEWARD_REPORT_TOP_LINES] other outlay\s</i><br>"
		body += "<br>"

	body += "<b>Payroll ahead:</b> about [finance["wage_outlay"]]m a day in wages, against [finance["rural_revenue"]]m a day of rural subsidy.<br>"
	if(finance["loans_outstanding"] || finance["debtors"] || finance["poll_arrears"])
		var/list/credit = list()
		if(finance["loans_outstanding"])
			credit += "[finance["loans_outstanding"]] loan\s out ([finance["loan_exposure"]]m still due)"
		if(finance["debtors"])
			credit += "[finance["debtors"]] defaulter\s"
		if(finance["poll_arrears"])
			credit += "[finance["poll_arrears"]] in poll tax arrears"
		body += "<b>Credit:</b> [jointext(credit, ", ")].<br>"
	if(finance["discrepancies"])
		body += "<br><i><font color='#c44'>The clerks' tally is out of balance on [finance["discrepancies"]] line\s. See the Ledger's Trial Balance.</font></i><br>"
	body += "<br><hr>"
	return body

#undef STEWARD_REPORT_TOP_LINES
