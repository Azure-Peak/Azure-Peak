/datum/loan
	/// Display/RP name - debtor's real_name at issuance. Kept for ledger/logs.
	var/debtor_name
	/// Authoritative identity - weakref to the debtor mob at issuance.
	/// If the mob qdels (gibbed, rerolled, etc.) this resolves null and the loan is orphaned.
	var/datum/weakref/debtor_ref
	/// Original principal, fixed at acceptance.
	var/principal = 0
	/// Simple-interest rate per day (0.25 == 25%). Copied from SStreasury at acceptance.
	var/interest_rate = 0.25
	/// Term length in days (2 or 3).
	var/days_total = 2
	/// GLOB.dayspassed at acceptance.
	var/issued_on_day = 0
	/// Day on which the loan matures and is auto-collected.
	var/due_on_day = 0
	/// Total mammons owed at maturity (principal + simple interest over the full term).
	/// Upper-bound; true current settlement is computed dynamically in get_remaining_due().
	var/total_due = 0
	/// Running tally of mammons the debtor has repaid early.
	var/repaid_so_far = 0
	/// Set to TRUE when the loan matures insolvent and the debtor is marked TRAIT_DEBTOR.
	var/defaulted = FALSE
	/// Name of the Steward/officer who signed the issuing contract (for ledger / ledger-in-UI).
	var/issuer_name

/datum/loan/New(mob/living/carbon/human/debtor, amount, term, rate, issuer)
	. = ..()
	if(debtor)
		debtor_name = debtor.real_name
		debtor_ref = WEAKREF(debtor)
	principal = amount
	days_total = term
	interest_rate = rate
	issuer_name = issuer
	issued_on_day = GLOB.dayspassed
	due_on_day = GLOB.dayspassed + days_total
	total_due = compute_total_due()

/// Simple interest at full maturity: principal * (1 + rate * days). Upper bound.
/datum/loan/proc/compute_total_due()
	return FLOOR(principal * (1 + (interest_rate * max(1, days_total))), 1)

/// Current settlement amount if the loan were repaid right now. Interest accrues
/// per elapsed day with a MINIMUM of one day's interest, even on same-day repayment.
/// Capped by the scheduled maturity total (principal + full-term interest).
/datum/loan/proc/get_remaining_due()
	var/elapsed_days = max(1, GLOB.dayspassed - issued_on_day)
	var/accrued_interest = FLOOR(principal * interest_rate * elapsed_days, 1)
	var/current_owed = principal + accrued_interest
	if(current_owed > total_due)
		current_owed = total_due
	return max(current_owed - repaid_so_far, 0)

/datum/loan/proc/days_until_due()
	return max(due_on_day - GLOB.dayspassed, 0)

/datum/loan/proc/format()
	var/pct = round(interest_rate * 100)
	if(defaulted)
		return "[debtor_name]: [principal]m principal @ [pct]%/day over [days_total] day\s - [get_remaining_due()]m outstanding (DEFAULTED day [due_on_day])"
	return "[debtor_name]: [principal]m principal @ [pct]%/day over [days_total] day\s - [get_remaining_due()]m due (day [due_on_day], [days_until_due()] day\s left)"

/// Resolve the weakref to the live debtor mob, or null if the mob is gone.
/datum/loan/proc/get_debtor_mob()
	if(!debtor_ref)
		return null
	var/mob/living/carbon/human/H = debtor_ref.resolve()
	if(QDELETED(H))
		return null
	return H

// -----------------------------------------------------------------------------
// SStreasury helpers
// -----------------------------------------------------------------------------

/// Lookup helper - returns the active /datum/loan for the given mob, or null.
/// Identity is by weakref equality against the live mob; ckey is no longer used.
/datum/controller/subsystem/treasury/proc/get_loan_for(mob/living/carbon/human/H)
	if(!H)
		return null
	for(var/datum/loan/L in loans)
		if(!L.debtor_ref)
			continue
		var/mob/living/carbon/human/resolved = L.debtor_ref.resolve()
		if(resolved == H)
			return L
	return null

/// Attempt to issue a loan to the given mob for `amount` mammons over `term` days,
/// at the current default interest rate. Returns the created loan datum on success,
/// null on failure. This does NOT move money or append to the active list; that
/// happens at contract acceptance.
/datum/controller/subsystem/treasury/proc/issue_loan(mob/living/carbon/human/debtor, amount, term, issuer_name)
	if(!debtor)
		return null
	if(GLOB.dayspassed > loan_max_issuance_day)
		return null
	if(HAS_TRAIT(debtor, TRAIT_DEBTOR))
		return null
	if(get_loan_for(debtor))
		return null
	amount = CLAMP(amount, 50, 250)
	if(term != 2 && term != 3)
		term = 2
	var/datum/loan/L = new(debtor, amount, term, loan_interest_rate, issuer_name)
	return L

/// Consume a partial or full repayment against an active loan. Transfers `amount`
/// from the debtor's account into the Crown discretionary. Returns the amount
/// actually repaid, or 0 on failure. Closes the loan and (for a defaulted loan)
/// clears TRAIT_DEBTOR if fully settled.
/datum/controller/subsystem/treasury/proc/repay_loan(mob/living/carbon/human/debtor, amount)
	if(!debtor || amount <= 0)
		return 0
	var/datum/loan/L = get_loan_for(debtor)
	if(!L)
		return 0
	var/datum/fund/account = get_account(debtor)
	if(!account)
		return 0
	var/outstanding = L.get_remaining_due()
	amount = min(amount, outstanding, account.balance)
	if(amount <= 0)
		return 0
	if(!transfer(account, discretionary_fund, amount, L.defaulted ? "Default debt settlement" : "Loan repayment"))
		return 0
	L.repaid_so_far += amount
	if(L.get_remaining_due() <= 0)
		if(L.defaulted)
			REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
			to_chat(debtor, span_notice("The stigma of default is lifted. Your debt to the Crown is paid in full."))
		loans -= L
		qdel(L)
	return amount

/// Dawn-hook. For each outstanding loan:
///   - If the debtor mob is gone (weakref resolves null), silently prune. They no
///     longer exist in any meaningful sense; there is nothing to seize or mark.
///   - Otherwise on/after maturity, collect in full if possible. If the account
///     can't cover the debt on first maturity, seize what's there, flag default,
///     mark TRAIT_DEBTOR, and keep the loan alive on `loans` for later settlement.
///   - A defaulted loan with a recovered balance auto-settles on a later tick:
///     debt is charged in full, TRAIT_DEBTOR cleared, loan qdel'd.
/datum/controller/subsystem/treasury/proc/tick_loans()
	for(var/datum/loan/L in loans.Copy())
		var/mob/living/carbon/human/debtor = L.get_debtor_mob()
		if(!debtor)
			// Orphaned: debtor mob was qdel'd (gib, reroll, disconnect-cleanup).
			// Silently prune - no debt can physically follow a body that no longer exists.
			log_game("LOAN PRUNED: [L.debtor_name] - debtor mob no longer exists, loan orphaned.")
			loans -= L
			qdel(L)
			continue
		if(GLOB.dayspassed < L.due_on_day)
			continue
		var/datum/fund/account = get_account(debtor)
		var/outstanding = L.get_remaining_due()
		if(outstanding <= 0)
			if(L.defaulted)
				REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
			loans -= L
			qdel(L)
			continue
		if(account && account.balance >= outstanding)
			if(transfer(account, discretionary_fund, outstanding, L.defaulted ? "Default debt settlement (auto)" : "Loan repayment (maturity)"))
				L.repaid_so_far += outstanding
				if(L.defaulted)
					REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
					send_ooc_note("<b>MEISTER:</b> The stigma of default is lifted. [outstanding]m was drawn from your account to settle the outstanding debt in full.", name = debtor.real_name)
				else
					send_ooc_note("<b>MEISTER:</b> Your loan of [L.principal]m has been repaid in full ([outstanding]m drawn from your account).", name = debtor.real_name)
				loans -= L
				qdel(L)
				continue
		// Insufficient funds. First-time default: seize what we can, mark, persist.
		if(!L.defaulted)
			L.defaulted = TRUE
			var/seized = 0
			if(account && account.balance > 0)
				seized = account.balance
				if(transfer(account, discretionary_fund, seized, "Loan default seizure"))
					L.repaid_so_far += seized
			ADD_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
			var/still_owed = L.get_remaining_due()
			send_ooc_note("<b>MEISTER:</b> Your loan of [L.principal]m has come due and you cannot pay. [seized]m was seized; [still_owed]m remains owed to the Crown. You are marked a defaulter until the debt is settled.", name = debtor.real_name)
			record_round_statistic(STATS_LOANS_DEFAULTED, 1)
			log_game("LOAN DEFAULT: [L.debtor_name] defaulted on [outstanding]m loan. [seized]m seized, [still_owed]m remaining.")
		// Already-defaulted loans persist on `loans` for future manual/auto settlement.
