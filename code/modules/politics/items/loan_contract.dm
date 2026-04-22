/obj/item/loan_contract
	name = "Loan Contract"
	desc = "A binding writ from the Nerve Master, bearing the Steward's signature. Any eligible bearer may accept its terms."
	icon = 'icons/roguetown/items/paper.dmi'
	icon_state = "paper_altprep"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	/// Steward's real_name as shown on the signature line.
	var/issuer_name
	/// Year the loan was signed. Set at spawn.
	var/issuer_year
	/// Principal (in mammon) that will be transferred on acceptance.
	var/principal = 0
	/// Term length in days (2 or 3).
	var/term_days = 2
	/// Simple-interest rate per day, as a fraction (0.25 == 25%). Stamped at issuance.
	var/interest_rate = 0.25
	/// Total mammon owed at maturity if not repaid early.
	var/total_due = 0
	/// Day on which the Crown will auto-collect (GLOB.dayspassed + term_days).
	var/principal_due_on_day = 0

/obj/item/loan_contract/Initialize()
	. = ..()
	if(!total_due && principal)
		total_due = FLOOR(principal * (1 + (interest_rate * term_days)), 1)

/obj/item/loan_contract/examine(mob/user)
	. = ..()
	var/signature = issuer_name || "the Nerve Master"
	var/year = issuer_year || CALENDAR_EPOCH_YEAR
	var/pct = round(interest_rate * 100)
	. += span_info("The contract reads: <i>\"Be it known that the bearer doth receive of the Crown the sum of [principal] mammon, to be repaid in full on the [ordinal(term_days)] dae after the acceptance of this loan, at the rate of [pct] per centum per dae of simple interest, totaling [total_due] mammon due.\"</i>")
	. += span_info("<i>Signed in the year [year], [signature].</i>")
	. += span_notice("Left-click in hand to accept or decline its terms.")

/obj/item/loan_contract/proc/ordinal(n)
	if(!isnum(n))
		return "[n]"
	var/suffix = "th"
	var/mod100 = n % 100
	if(mod100 < 11 || mod100 > 13)
		switch(n % 10)
			if(1)
				suffix = "st"
			if(2)
				suffix = "nd"
			if(3)
				suffix = "rd"
	return "[n][suffix]"

/obj/item/loan_contract/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	if(HAS_TRAIT(user, TRAIT_DEBTOR))
		to_chat(user, span_warning("I am already marked a defaulter of the Crown. I cannot take on new debt."))
		return
	if(SStreasury.get_loan_for(user))
		to_chat(user, span_warning("I already owe the Crown. I cannot hold two debts at once."))
		return
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("I have no Meister account to receive these funds. I must open one first."))
		return
	var/pct = round(interest_rate * 100)
	var/choice = alert(user, "Accept a loan of [principal]m, due in [term_days] day\s at [pct]%/day simple interest? Total due: [total_due]m.", "Loan Contract", "Accept", "Decline")
	if(choice != "Accept")
		to_chat(user, span_notice("I set the contract aside, unsigned."))
		return
	// Re-check gates after the blocking dialog.
	if(QDELETED(src) || QDELETED(user))
		return
	if(HAS_TRAIT(user, TRAIT_DEBTOR))
		to_chat(user, span_warning("I am already marked a defaulter of the Crown."))
		return
	if(SStreasury.get_loan_for(user))
		to_chat(user, span_warning("I already owe the Crown."))
		return
	var/datum/fund/account = SStreasury.get_account(user)
	if(!account)
		to_chat(user, span_warning("My Meister account is gone."))
		return
	if(SStreasury.discretionary_fund.balance < principal)
		to_chat(user, span_warning("The Crown's coffers are too thin to honor this writ."))
		return
	if(!SStreasury.transfer(SStreasury.discretionary_fund, account, principal, "Loan principal"))
		to_chat(user, span_warning("The meister refuses the transfer."))
		return
	var/datum/loan/L = new(user, principal, term_days, interest_rate, issuer_name)
	SStreasury.loans += L
	record_round_statistic(STATS_LOANS_ISSUED, 1)
	user.visible_message(span_notice("[user] signs the loan contract and pockets the Crown's coin."), \
		span_notice("I accept the loan of [principal]m, repayable in [term_days] day\s at [pct]%/day. Total due: [total_due]m."))
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	send_ooc_note("<b>MEISTER:</b> Loan of [principal]m received. [total_due]m will be collected on day [L.due_on_day].", name = user.real_name)
	qdel(src)
