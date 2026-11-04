// Treasury solvency state machine: NORMAL -> IN_ARREARS -> BANKRUPTCY (and back).
// All transitions go through these helpers. distribute_daily_payments and the debt-skim
// path read treasury_state but never mutate it.

/datum/controller/subsystem/treasury/proc/is_in_receivership()
	return treasury_state == TREASURY_BANKRUPTCY

/datum/controller/subsystem/treasury/proc/is_in_arrears_or_worse()
	return treasury_state != TREASURY_NORMAL

/datum/controller/subsystem/treasury/proc/enter_arrears(projected_total)
	if(treasury_state != TREASURY_NORMAL)
		return FALSE
	var/shortfall = max(0, projected_total - discretionary_fund.balance)
	var/loan_amount = max(TREASURY_ARREARS_LOAN, shortfall)
	treasury_state = TREASURY_IN_ARREARS
	treasury_debt += loan_amount
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = treasury_debt
	record_round_statistic(STATS_ARREARS_DECLARED, 1)
	// Direct credit so the loan itself isn't immediately skimmed against the debt we just registered.
	discretionary_fund.balance += loan_amount
	post_ledger_entry("financing", "Arrears advance from the Burghers of Azuria", list(
		list(LEDGER_CROWN_CASH, loan_amount, 0),
		list(LEDGER_CROWN_ARREARS_ADVANCE, 0, loan_amount),
	), null, discretionary_fund)
	priority_announce(
		"The Treasury ran dry at payroll. The Burghers of Azuria have advanced [loan_amount]m at no interest to cover the day's wages.",
		"THE BURGHERS LEND",
		'sound/misc/royal_decree2.ogg',
		"Captain",
	)
	return TRUE

/datum/controller/subsystem/treasury/proc/enter_bankruptcy()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return FALSE
	bankruptcy_count += 1
	record_round_statistic(STATS_BANKRUPTCY_DECLARED, 1)

	// Reset purse to the operating floor. Adjust by difference and log so the ledger reflects
	// the residual being burned (or topped up) rather than a silent assignment.
	var/topup = 0
	if(discretionary_fund.balance > BANKRUPTCY_OPERATING_FLOOR)
		var/excess = discretionary_fund.balance - BANKRUPTCY_OPERATING_FLOOR
		discretionary_fund.balance = BANKRUPTCY_OPERATING_FLOOR
		post_ledger_entry("financing", "Sequestration: residual Treasury forfeit", list(
			list(LEDGER_CROWN_EXP_SEQUESTRATION, excess, 0),
			list(LEDGER_CROWN_CASH, 0, excess),
		), discretionary_fund)
	else if(discretionary_fund.balance < BANKRUPTCY_OPERATING_FLOOR)
		topup = BANKRUPTCY_OPERATING_FLOOR - discretionary_fund.balance
		discretionary_fund.balance = BANKRUPTCY_OPERATING_FLOOR
		post_ledger_entry("financing", "Sequestration: operating reserve from the ATC", list(
			list(LEDGER_CROWN_CASH, topup, 0),
			list(LEDGER_CROWN_SEQUESTRATION_DEBT, 0, topup),
		), null, discretionary_fund)

	// Existing arrears debt is rolled into the new sequestration debt rather than dropped,
	// so the Crown doesn't escape the smaller obligation by failing harder.
	var/new_debt = BANKRUPTCY_DEBT_FLAT
	// The reserve advance above is already on the books as debt; the remainder of the flat
	// charge (or the over-provision, if the advance exceeded it) is booked as a sequestration charge.
	var/charge = new_debt - topup
	if(charge > 0)
		post_ledger_entry("accrual", "Sequestration charge", list(
			list(LEDGER_CROWN_EXP_SEQUESTRATION, charge, 0),
			list(LEDGER_CROWN_SEQUESTRATION_DEBT, 0, charge),
		))
	else if(charge < 0)
		post_ledger_entry("accrual", "Sequestration charge (adjustment)", list(
			list(LEDGER_CROWN_SEQUESTRATION_DEBT, -charge, 0),
			list(LEDGER_CROWN_EXP_SEQUESTRATION, 0, -charge),
		))
	treasury_debt += new_debt
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = treasury_debt
	treasury_state = TREASURY_BANKRUPTCY

	suspend_charters_for_bankruptcy()
	override_trade_for_bankruptcy()
	suspend_wages_for_bankruptcy()

	priority_announce(
		"The ATC, most blessed and most devout servant of Malum the Worker and Abyssor the Dreamer, has seized [atc_seizure_blurb()] against the Crown's debts. It has advanced [BANKRUPTCY_OPERATING_FLOOR]m to keep the Treasury running, and the Crown now owes it [new_debt]m. Until that is repaid, the ATC collects the realm's revenues and runs its trade and stockpile. Wages are suspended, and every Charter but the Golden Bull is suspended.",
		"SEQUESTRATION DECLARED",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)
	return TRUE

/datum/controller/subsystem/treasury/proc/suspend_wages_for_bankruptcy()
	if(!steward_machine || !steward_machine.daily_payments)
		return
	var/list/payments = steward_machine.daily_payments
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner || !(payments[owner.job] > 0))
			continue
		var/datum/fund/account = bank_accounts[owner]
		if(!account || account.wages_suspended)
			continue
		account.wages_suspended = TRUE
		to_chat(owner, span_danger("My wages are stopped until the Crown pays off the ATC."))

/datum/controller/subsystem/treasury/proc/resume_wages_after_bankruptcy()
	var/list/payments = steward_machine?.daily_payments
	for(var/mob/living/owner as anything in bank_accounts)
		if(!owner)
			continue
		var/datum/fund/account = bank_accounts[owner]
		if(!account || !account.wages_suspended)
			continue
		account.wages_suspended = FALSE
		if(payments && payments[owner.job] > 0)
			to_chat(owner, span_notice("My wages have been reinstated as the Crown's sequestration lifts."))

/datum/controller/subsystem/treasury/proc/clear_treasury_debt_state()
	switch(treasury_state)
		if(TREASURY_NORMAL)
			if(atc_loan_arrears_consumed)
				atc_loan_arrears_consumed = FALSE
				priority_announce(
					"The Crown has repaid its loan from the ATC.",
					"ATC LOAN SETTLED",
					'sound/misc/royal_decree2.ogg',
					"Captain",
				)
		if(TREASURY_IN_ARREARS)
			exit_arrears()
		if(TREASURY_BANKRUPTCY)
			exit_bankruptcy()

/datum/controller/subsystem/treasury/proc/exit_arrears()
	if(treasury_state != TREASURY_IN_ARREARS)
		return
	treasury_state = TREASURY_NORMAL
	atc_loan_arrears_consumed = FALSE
	priority_announce(
		"The Crown has repaid the Burghers' advance.",
		"THE BURGHERS PAID",
		'sound/misc/royal_decree2.ogg',
		"Captain",
	)

/datum/controller/subsystem/treasury/proc/exit_bankruptcy()
	if(treasury_state != TREASURY_BANKRUPTCY)
		return
	treasury_state = TREASURY_NORMAL

	// The skim leaves the purse at exactly the operating floor; top up to the recovery target
	// so the Crown has working capital to resume.
	if(discretionary_fund.balance < BANKRUPTCY_RECOVERY_RESET)
		var/topup = BANKRUPTCY_RECOVERY_RESET - discretionary_fund.balance
		discretionary_fund.balance = BANKRUPTCY_RECOVERY_RESET
		post_ledger_entry("financing", "Sequestration lifted: working capital", list(
			list(LEDGER_CROWN_CASH, topup, 0),
			list(LEDGER_CROWN_GRANTS, 0, topup),
		), null, discretionary_fund)

	resume_wages_after_bankruptcy()
	// Trade configuration intentionally NOT restored - re-tuning it is part of the cost of failure.
	bankruptcy_concession_picks = BANKRUPTCY_CONCESSION_PICKS
	atc_loan_arrears_consumed = FALSE
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = 0

	priority_announce(
		"The ATC releases the Crown's trade. Wages resume at the next payroll.",
		"SEQUESTRATION LIFTED",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)

/// Force-suspend bankruptcy-listed Charters, bypassing cooldown and the daily revoke gate -
/// these aren't policy decisions, they're mechanical consequences of default.
/datum/controller/subsystem/treasury/proc/suspend_charters_for_bankruptcy()
	bankruptcy_suspended_decree_ids.Cut()
	for(var/decree_id in BANKRUPTCY_SUSPENDED_DECREES)
		var/datum/decree/D = decrees[decree_id]
		if(!D)
			continue
		if(D.active)
			D.active = FALSE
			D.cooldown_expires = 0
			D.on_revoke()
		D.bankruptcy_suspended = TRUE
		bankruptcy_suspended_decree_ids += decree_id
	steward_machine?.enforce_wage_floors()

/// Force every importable good onto standing import and pin auto-export at the sequestration
/// ratio. Not snapshotted - the Steward must re-tune by hand on recovery.
/datum/controller/subsystem/treasury/proc/override_trade_for_bankruptcy()
	autoexport_percentage = BANKRUPTCY_AUTOEXPORT_PERCENTAGE
	auto_import_disabled.Cut()
	for(var/good_id in GLOB.trade_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg && tg.importable)
			auto_import_standing[good_id] = TRUE
	dirty_auto_import_view()
	dirty_market_view()

/// Cooldown-free restore of a bankruptcy-suspended charter. Returns TRUE on success.
/datum/controller/subsystem/treasury/proc/restore_charter_via_concession(decree_id)
	if(bankruptcy_concession_picks <= 0)
		return FALSE
	var/datum/decree/D = decrees[decree_id]
	if(!D || !D.bankruptcy_suspended || D.active)
		return FALSE
	D.bankruptcy_suspended = FALSE
	D.active = TRUE
	D.year = CALENDAR_EPOCH_YEAR
	D.cooldown_expires = 0
	D.has_ever_been_active = TRUE
	D.on_restore()
	D.broadcast_state_change()
	bankruptcy_concession_picks -= 1
	bankruptcy_suspended_decree_ids -= decree_id
	steward_machine?.enforce_wage_floors()
	return TRUE

/// Called from set_decree_active before any state change. Golden Bull cannot be revoked
/// during sequestration; bankruptcy-suspended charters are immutable until concession-restored.
/datum/controller/subsystem/treasury/proc/can_mutate_decree(decree_id, new_active)
	if(treasury_state == TREASURY_BANKRUPTCY && decree_id == DECREE_GOLDEN_BULL && !new_active)
		return FALSE
	if(treasury_state != TREASURY_BANKRUPTCY)
		return TRUE
	var/datum/decree/D = decrees[decree_id]
	if(!D)
		return FALSE
	if(D.bankruptcy_suspended)
		return FALSE
	return TRUE

/proc/bankruptcy_state_label(state_value)
	switch(state_value)
		if(TREASURY_NORMAL)
			return "Solvent"
		if(TREASURY_IN_ARREARS)
			return "In Arrears"
		if(TREASURY_BANKRUPTCY)
			return "Sequestered"
	return "Unknown"

/// Properties the Azurian Trading Company "seizes" against the Crown's debts on bankruptcy entry.
/// Two or three are picked at random for the sequestration announcement.
GLOBAL_LIST_INIT(atc_seizure_inventory, list(
	"the Grand Duke's gilded bathtub",
	"a brace of falcons from the royal mews",
	"an illuminated psyalter bound in shagreen",
	"the great Otavan tapestry depicting the Hunt of the Boar",
	"two gilded saltcellars in the Etruscan fashion",
	"three sealed coffers of the Crown's pearls",
	"the household reliquary (less the relic)",
	"a Naledian astrolabe with three missing pins",
	"the Steward's reserve of saffron and cinnamon",
	"an ivory chess set, six pieces short",
	"a brocaded canopy bed, taken down with great difficulty",
	"the chapel's spare gilt candelabrum",
	"the last Marshal's silver hunting horn",
	"a portrait of a forgotten ancestor, slashed by a disgruntled debtor",
	"the Court Cupbearer's pewter inventory and the keys to it",
	"a jeweled Lirvanic bathtub of indecent proportion",
	"twelve casks of Bleakcoast firewine, marked for the Midwinter feast",
	"a Kazengun lacquered wardrobe of indeterminate vintage",
	"an Etruscan illuminated bestiary, warped by damp",
	"a clutch of Heartfelt clockwork toys, ticking faintly",
	"the menagerie's pet civet, of doubtful temperament",
	"the great clock of the Crown, dismantled in three carts",
	"twelve hundred yards of Naledian silk, the Crown's spare livery",
	"the Crown's reserve of Saltwick anchovies, packed in oil",
	"the Crown's emergency Kingsfield cheese reserve",
	"two white stag heads, taxidermied from the last royal hunt",
	"a crate of unknown white liquid of uncertain provenance, labeled 'CROWN ONLY - Not for Consumption'",
	"a sealed crate marked PROPERTY OF THE LATE STEWARD",
))

/// Returns a semicolon-separated string of 2-3 randomly chosen seizures for the announcement.
/// Semicolons (rather than commas) keep the items distinguishable when each contains internal
/// commas of its own ("...water-damaged", "...packed in oil"). The final item is preceded by
/// "and" in the period-formal manner.
/proc/atc_seizure_blurb()
	var/list/picks = list()
	var/count = rand(2, 3)
	var/list/pool = GLOB.atc_seizure_inventory.Copy()
	for(var/i in 1 to count)
		if(!length(pool))
			break
		var/choice = pick(pool)
		picks += choice
		pool -= choice
	if(length(picks) == 1)
		return picks[1]
	if(length(picks) == 2)
		return "[picks[1]]; and [picks[2]]"
	var/last = picks[length(picks)]
	picks.Cut(length(picks), length(picks) + 1)
	return "[jointext(picks, "; ")]; and [last]"

// ============================================================================
// ATC Emergency Loan - early-round "just one more day" tool. Adds debt that future inflow
// repays, plus consumes the arrears safety net (next failed payroll skips to sequestration).
// Disabled from ATC_LOAN_CLOSED_DAY onward so it can't be used to free-ride a round-end wipe.
// ============================================================================
/datum/controller/subsystem/treasury/proc/atc_loan_available()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return FALSE
	if(GLOB.dayspassed >= ATC_LOAN_CLOSED_DAY)
		return FALSE
	return TRUE

/datum/controller/subsystem/treasury/proc/atc_loan_blocker_reason()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return "The ATC won't lend during sequestration."
	if(GLOB.dayspassed >= ATC_LOAN_CLOSED_DAY)
		return "The ATC stops lending this late in the week."
	if(atc_loan_arrears_consumed)
		return "The ATC won't lend again until the last loan is repaid."
	return null

/datum/controller/subsystem/treasury/proc/take_atc_loan(amount, mob/applicant)
	var/blocker = atc_loan_blocker_reason()
	if(blocker)
		if(applicant)
			to_chat(applicant, span_warning("Loan refused. [blocker]"))
		return FALSE
	amount = clamp(round(amount), ATC_LOAN_MIN_AMOUNT, ATC_LOAN_MAX_AMOUNT)
	var/debt_owed = round(amount * (1 + ATC_LOAN_INTEREST_RATE))
	treasury_debt += debt_owed
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = treasury_debt
	atc_loans_drawn_this_round += 1
	atc_loan_arrears_consumed = TRUE
	// Direct credit so the principal isn't immediately skimmed against the debt we just registered.
	discretionary_fund.balance += amount
	// Principal arrives as cash; the interest premium is expensed up front because the debt is
	// registered at its full repayable value.
	var/list/loan_legs = list(
		list(LEDGER_CROWN_CASH, amount, 0),
		list(LEDGER_CROWN_ATC_LOAN, 0, debt_owed),
	)
	if(debt_owed > amount)
		loan_legs += list(list(LEDGER_CROWN_INTEREST_EXP, debt_owed - amount, 0))
	else if(debt_owed < amount)
		loan_legs += list(list(LEDGER_CROWN_INTEREST_INC, 0, amount - debt_owed))
	post_ledger_entry("financing", "ATC emergency loan (principal)", loan_legs, null, discretionary_fund)
	priority_announce(
		"The Crown has taken a loan of [amount]m from the ATC at [round(ATC_LOAN_INTEREST_RATE * 100)]% interest, and now owes [debt_owed]m.",
		"THE CROWN BORROWS",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)
	log_game("ATC LOAN: [applicant ? key_name(applicant) : "system"] drew [amount]m principal from the Azurian Trading Company; debt of [debt_owed]m registered")
	return TRUE
