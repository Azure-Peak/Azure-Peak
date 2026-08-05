/obj/item/loan_contract
	name = "Loan Contract"
	desc = "A binding writ from the Nerve Master, bearing the Steward's signature. Any eligible bearer may accept its terms."
	icon = 'icons/roguetown/items/paper.dmi'
	icon_state = "paper_altprep"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	var/issuer_name
	var/issuer_year
	var/principal = 0
	var/term_days = 2
	var/interest_rate = 0.25
	var/total_due = 0
	var/principal_due_on_day = 0
	var/source_fund_id = "crown"

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
	if(source_fund_id == "church" && (user.job in GLOB.church_positions))
		to_chat(user, span_warning("The Church prohibits usury to its own. Eora's coin is for the poor and the downtrodden, not the faithful."))
		return
	var/datum/fund/preview_fund = SStreasury.resolve_fund_by_id(source_fund_id)
	var/preview_label = preview_fund ? SStreasury.indenture_faction_label(preview_fund) : "an unknown lender"
	var/pct = round(interest_rate * 100)
	var/choice = alert(user, "Accept a loan of [principal]m from [preview_label], due in [term_days] day\s at [pct]%/day simple interest? Total due: [total_due]m.", "Loan from [preview_label]", "Accept", "Decline")
	if(choice != "Accept")
		to_chat(user, span_notice("I set the contract aside, unsigned."))
		return
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
	var/datum/fund/issuing_fund = SStreasury.resolve_fund_by_id(source_fund_id)
	if(!issuing_fund)
		to_chat(user, span_warning("The writ names no recognised lender. The meister cannot honor it."))
		return
	if(issuing_fund.balance < principal)
		to_chat(user, span_warning("[issuing_fund.name]'s coffers are too thin to honor this writ."))
		return
	if(!SStreasury.transfer(issuing_fund, account, principal, "Loan principal"))
		to_chat(user, span_warning("The meister refuses the transfer."))
		return
	var/datum/loan/L = new(user, principal, term_days, interest_rate, issuer_name, issuing_fund)
	SStreasury.loans += L
	record_round_statistic(STATS_LOANS_ISSUED, 1)
	var/lender_label = SStreasury.indenture_faction_label(issuing_fund)
	user.visible_message(span_notice("[user] signs the loan contract and pockets [lender_label]'s coin."), \
		span_notice("I accept the loan of [principal]m from [lender_label], repayable in [term_days] day\s at [pct]%/day. Total due: [total_due]m."))
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	send_ooc_note("<b>MEISTER:</b> Loan of [principal]m received from [lender_label]. [total_due]m will be collected on day [L.due_on_day].", name = user.real_name)
	qdel(src)

/obj/item/loan_contract/indenture
	name = "Writ of Indenture"
	desc = "A binding indenture between two institutions of Azuria. Only the named target's authorised hand may seal it."
	icon_state = "paper_altprep"
	var/target_fund_id

/obj/item/loan_contract/indenture/examine(mob/user)
	. = ..()
	. += span_warning("This indenture is publicly proclaimed upon acceptance and upon default.")
	if(target_fund_id)
		. += span_info("Drawn for: [SStreasury.indenture_faction_label(SStreasury.resolve_fund_by_id(target_fund_id))].")

/obj/item/loan_contract/indenture/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	var/datum/fund/issuing_fund = SStreasury.resolve_fund_by_id(source_fund_id)
	var/datum/fund/target_fund = SStreasury.resolve_fund_by_id(target_fund_id)
	if(!issuing_fund || !target_fund)
		to_chat(user, span_warning("The indenture names no recognised parties. The meister cannot honor it."))
		return
	var/obj/structure/roguemachine/vaultbank/target_jawbank = SStreasury.find_jawbank_for_fund_id(target_fund_id)
	if(!target_jawbank)
		to_chat(user, span_warning("[SStreasury.indenture_faction_label(target_fund)] has no jawbank to receive this indenture."))
		return
	if(!target_jawbank.can_accept_indenture(user))
		to_chat(user, span_warning("Only [target_jawbank.get_authority_label()] may seal an indenture for [SStreasury.indenture_faction_label(target_fund)]."))
		return
	for(var/datum/loan/L in SStreasury.loans)
		if(L.is_institutional && L.target_fund == target_fund)
			to_chat(user, span_warning("[SStreasury.indenture_faction_label(target_fund)] already holds an outstanding indenture."))
			return
	var/pct = round(interest_rate * 100)
	var/choice = alert(user, "On behalf of [SStreasury.indenture_faction_label(target_fund)], accept an indenture of [principal]m from [issuing_fund.name], due in [term_days] day\s at [pct]%/day? Total due: [total_due]m. THIS WILL BE PUBLICLY PROCLAIMED.", "Writ of Indenture", "Seal", "Decline")
	if(choice != "Seal")
		to_chat(user, span_notice("I set the indenture aside, unsealed."))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(issuing_fund.balance < principal)
		to_chat(user, span_warning("[issuing_fund.name]'s coffers are too thin to honor this indenture."))
		return
	if(!SStreasury.transfer(issuing_fund, target_fund, principal, "Indenture principal"))
		to_chat(user, span_warning("The meister refuses the transfer."))
		return
	var/datum/loan/L = new(null, principal, term_days, interest_rate, issuer_name, issuing_fund, target_fund)
	SStreasury.loans += L
	record_round_statistic(STATS_LOANS_ISSUED, 1)
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	SStreasury.announce_indenture_acceptance(L, user)
	log_admin("INDENTURE SEALED: [key_name(user)] accepted [principal]m from [issuing_fund.name] on behalf of [target_fund.name] over [term_days]d at [pct]%/day.")
	qdel(src)
