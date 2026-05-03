/datum/loan
	var/debtor_name
	var/datum/weakref/debtor_ref
	var/principal = 0
	var/interest_rate = 0.25
	var/days_total = 2
	var/issued_on_day = 0
	var/due_on_day = 0
	var/total_due = 0
	var/repaid_so_far = 0
	var/defaulted = FALSE
	var/issuer_name
	var/datum/fund/source_fund

/datum/loan/New(mob/living/carbon/human/debtor, amount, term, rate, issuer, datum/fund/from_fund)
	. = ..()
	if(debtor)
		debtor_name = debtor.real_name
		debtor_ref = WEAKREF(debtor)
	principal = amount
	days_total = term
	interest_rate = rate
	issuer_name = issuer
	source_fund = from_fund || SStreasury.discretionary_fund
	issued_on_day = GLOB.dayspassed
	due_on_day = GLOB.dayspassed + days_total
	total_due = compute_total_due()

/datum/loan/proc/get_faction_debtor_trait()
	if(istype(source_fund, /datum/fund/church))
		return TRAIT_DEBTOR_CHURCH
	if(istype(source_fund, /datum/fund/merchant))
		return TRAIT_DEBTOR_MERCHANT
	if(istype(source_fund, /datum/fund/bathhouse))
		return TRAIT_DEBTOR_BATHHOUSE
	return TRAIT_DEBTOR_CROWN

/datum/loan/proc/compute_total_due()
	return FLOOR(principal * (1 + (interest_rate * max(1, days_total))), 1)

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

/datum/loan/proc/get_debtor_mob()
	if(!debtor_ref)
		return null
	var/mob/living/carbon/human/H = debtor_ref.resolve()
	if(QDELETED(H))
		return null
	return H

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

/datum/controller/subsystem/treasury/proc/issue_loan(mob/living/carbon/human/debtor, amount, term, issuer_name, datum/fund/from_fund, rate)
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
	var/effective_rate = !isnull(rate) ? rate : loan_interest_rate
	var/datum/loan/L = new(debtor, amount, term, effective_rate, issuer_name, from_fund)
	return L

/datum/controller/subsystem/treasury/proc/repay_loan(mob/living/carbon/human/debtor, amount)
	if(!debtor || amount <= 0)
		return 0
	var/datum/loan/L = get_loan_for(debtor)
	if(!L)
		return 0
	var/datum/fund/account = get_account(debtor)
	if(!account)
		return 0
	var/datum/fund/destination = L.source_fund || discretionary_fund
	var/outstanding = L.get_remaining_due()
	amount = min(amount, outstanding, account.balance)
	if(amount <= 0)
		return 0
	if(!transfer(account, destination, amount, L.defaulted ? "Default debt settlement" : "Loan repayment"))
		return 0
	L.repaid_so_far += amount
	if(L.get_remaining_due() <= 0)
		if(L.defaulted)
			REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
			REMOVE_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
			to_chat(debtor, span_notice("The stigma of default is lifted. Your debt to [destination.name] is paid in full."))
		loans -= L
		qdel(L)
	return amount

/datum/controller/subsystem/treasury/proc/tick_loans()
	for(var/datum/loan/L in loans.Copy())
		var/mob/living/carbon/human/debtor = L.get_debtor_mob()
		if(!debtor)
			log_game("LOAN PRUNED: [L.debtor_name] - debtor mob no longer exists, loan orphaned.")
			loans -= L
			qdel(L)
			continue
		if(GLOB.dayspassed < L.due_on_day)
			continue
		var/datum/fund/account = get_account(debtor)
		var/datum/fund/destination = L.source_fund || discretionary_fund
		var/outstanding = L.get_remaining_due()
		if(outstanding <= 0)
			if(L.defaulted)
				REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
				REMOVE_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
			loans -= L
			qdel(L)
			continue
		if(account && account.balance >= outstanding)
			if(transfer(account, destination, outstanding, L.defaulted ? "Default debt settlement (auto)" : "Loan repayment (maturity)"))
				L.repaid_so_far += outstanding
				if(L.defaulted)
					REMOVE_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
					REMOVE_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
					send_ooc_note("<b>MEISTER:</b> The stigma of default is lifted. [outstanding]m was drawn from your account to settle the outstanding debt in full.", name = debtor.real_name)
				else
					send_ooc_note("<b>MEISTER:</b> Your loan of [L.principal]m has been repaid in full ([outstanding]m drawn from your account).", name = debtor.real_name)
				loans -= L
				qdel(L)
				continue
		if(!L.defaulted)
			L.defaulted = TRUE
			var/seized = 0
			if(account && account.balance > 0)
				seized = account.balance
				if(transfer(account, destination, seized, "Loan default seizure"))
					L.repaid_so_far += seized
			ADD_TRAIT(debtor, TRAIT_DEBTOR, TRAIT_GENERIC)
			ADD_TRAIT(debtor, L.get_faction_debtor_trait(), TRAIT_GENERIC)
			var/still_owed = L.get_remaining_due()
			send_ooc_note("<b>MEISTER:</b> Your loan of [L.principal]m has come due and you cannot pay. [seized]m was seized; [still_owed]m remains owed to [destination.name]. You are marked a defaulter until the debt is settled.", name = debtor.real_name)
			record_round_statistic(STATS_LOANS_DEFAULTED, 1)
			log_game("LOAN DEFAULT: [L.debtor_name] defaulted on [outstanding]m loan from [destination.name]. [seized]m seized, [still_owed]m remaining.")
