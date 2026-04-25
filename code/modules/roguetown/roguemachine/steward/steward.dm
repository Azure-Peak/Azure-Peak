#define TAB_MAIN 1
#define TAB_BANK 2
#define TAB_STOCK 3
#define TAB_IMPORT 4
#define TAB_BOUNTIES 5
#define TAB_LOG 6
#define TAB_FISCAL 7
#define TAB_PAYDAY 8
#define TAB_DEBT 9

/obj/structure/roguemachine/steward
	name = "nerve master"
	desc = "A magitech device connected to the arteries of Azuria's royal treasury. When unlocked with the proper key, it can sway the fate of an entire kingdom's \
	finances. Stewards traditionally use these machines to export stockpiled goods for coinage, to pay-and-tax all accounts registered through the MEISTER, and to \
	import supplies for taskings-a-plenty."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/locked = FALSE
	var/keycontrol = "steward"
	var/current_tab = TAB_MAIN
	var/compact = TRUE
	var/total_deposit = 0
	var/list/excluded_jobs = list("Wretch","Vagabond","Adventurer")
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood", "Precious")
	var/list/daily_payments = list() // Associative list: job name -> payment amount
	var/residency_print_cooldown = 0

/obj/structure/roguemachine/steward/Initialize()
	. = ..()
	if(SStreasury.steward_machine == null) //The "only one" mapped in Nerve Master at map start
		SStreasury.steward_machine = src
	setup_default_payments()

//	For competence of life I will allow you,
//	That lack of means enforce you not to evil:
/obj/structure/roguemachine/steward/proc/setup_default_payments()
	daily_payments["Sergeant"] = 40 //Garrison
	daily_payments["Man at Arms"] = 30
	daily_payments["Warden"] = 20
	daily_payments["Veteran"] = 20
	daily_payments["Squire"] = 10
	daily_payments["Seneschal"] = 40 //Manor-House
	daily_payments["Servant"] = 20	
	daily_payments["Head Physician"] = 20 //Doctors
	daily_payments["Apothecary"] = 10
	daily_payments["Court Magician"] = 40 //University
	daily_payments["Archivist"] = 20
	daily_payments["Magicians Associate"] = 10
	enforce_wage_floors()

/// Walks every job currently on the payroll and every job newly floored by an active charter,
/// then raises any below-floor wages up to the floor. Called at machine init and whenever a
/// flooring charter activates. Safe to call multiple times.
/obj/structure/roguemachine/steward/proc/enforce_wage_floors()
	// Bump jobs already on the payroll if they're now below floor.
	for(var/job in daily_payments)
		var/floor = SStreasury.get_wage_floor(job)
		if(floor > 0 && (daily_payments[job] || 0) < floor)
			daily_payments[job] = floor
	// Jobs the payroll doesn't know about but a charter floors (e.g., Knight, Marshal) need to
	// be seeded at the floor so they actually receive pay.
	for(var/job in SStreasury.enumerate_wage_floored_jobs())
		if(isnull(daily_payments[job]))
			daily_payments[job] = SStreasury.get_wage_floor(job)

/obj/structure/roguemachine/steward/proc/issue_loan_dialog(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(GLOB.dayspassed > SStreasury.loan_max_issuance_day)
		say("No new loans may be drawn after day [SStreasury.loan_max_issuance_day].")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/amount = input(user, "Principal (50-250 mammon).", src, 100) as null|num
	if(isnull(amount))
		return
	if(!user.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(findtext(num2text(amount), "."))
		return
	amount = CLAMP(round(amount), 50, 250)
	var/term_choice = input(user, "Select term.", src) as null|anything in list("2 days", "3 days")
	if(!term_choice)
		return
	if(!user.canUseTopic(src, BE_CLOSE) || locked)
		return
	var/term = (term_choice == "3 days") ? 3 : 2
	if(SStreasury.discretionary_fund.balance < amount)
		say("The treasury cannot cover a loan of [amount]m at this time.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/obj/item/loan_contract/contract = new(get_turf(src))
	contract.issuer_name = user.real_name
	contract.issuer_year = CALENDAR_EPOCH_YEAR
	contract.principal = amount
	contract.term_days = term
	contract.interest_rate = SStreasury.loan_interest_rate
	contract.principal_due_on_day = GLOB.dayspassed + term
	contract.total_due = FLOOR(amount * (1 + (contract.interest_rate * term)), 1)
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	say("Bearer Loan Contract issued: [amount]m over [term] day\s, signed by [user.real_name].")
	log_game("LOAN CONTRACT: [key_name(user)] drafted bearer loan contract - [amount]m over [term] days at [round(contract.interest_rate * 100)]%/day.")


/obj/structure/roguemachine/steward/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol || istype(K, /obj/item/roguekey/lord) || istype(K, /obj/item/roguekey/skeleton)) //Master key
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
			update_icon()
			return
		else
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		if(!K.contents.len)
			return
		var/list/keysy = K.contents.Copy()
		for(var/obj/item/roguekey/KE in keysy)
			if(KE.lockid == keycontrol)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
				update_icon()
				return
		to_chat(user, span_warning("Wrong key."))
		return
	if(istype(P, /obj/item/roguecoin/aalloy))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))	
		return	
	if(istype(P, /obj/item/roguecoin))
		record_round_statistic(STATS_MAMMONS_DEPOSITED, P.get_real_price())
		SStreasury.mint(SStreasury.discretionary_fund, P.get_real_price(), "NERVE MASTER deposit")
		qdel(P)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	return ..()


/obj/structure/roguemachine/steward/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(href_list["switchtab"])
		current_tab = text2num(href_list["switchtab"])
	if(href_list["import"])
		var/datum/crown_import/D = locate(href_list["import"]) in GLOB.crown_imports
		if(!D)
			return
		var/amt = D.get_import_price()
		if(!SStreasury.burn(SStreasury.discretionary_fund, amt, "imported [D.name]"))
			say("Insufficient mammon.")
			return
		SStreasury.total_import += amt
		record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, amt)
		if(amt >= 100) //Only announce big spending.
			scom_announce("Azure Peak imports [D.name] for [amt] mammon.", )
		D.raise_demand()
		addtimer(CALLBACK(src, PROC_REF(do_import), D.type), 10 SECONDS)
	if(href_list["export"])
		var/datum/roguestock/D = locate(href_list["export"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!SStreasury.do_export(D))
			say("Insufficient stock.")
			return
	if(href_list["togglewithdraw"])
		var/datum/roguestock/D = locate(href_list["togglewithdraw"]) in SStreasury.stockpile_datums
		if(!D)
			return
		D.withdraw_disabled = !D.withdraw_disabled
	if(href_list["toggleaccept"])
		var/datum/roguestock/D = locate(href_list["toggleaccept"]) in SStreasury.stockpile_datums
		if(!D)
			return
		D.accept_toggle_enabled = !D.accept_toggle_enabled
	if(href_list["setbounty"])
		var/datum/roguestock/D = locate(href_list["setbounty"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newtax = input(usr, "Set a new price for [D.name]", src, D.payout_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 0, 999)
				if(newtax > D.payout_price)
					scom_announce("The bounty for [D.name] was increased.")
				D.payout_price = newtax
				D.pegged = FALSE
		else
			var/newtax = input(usr, "Set a new percent for [D.name]", src, D.payout_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 1, 99)
				if(newtax > D.payout_price)
					scom_announce("The bounty for [D.name] was increased.")
				D.payout_price = newtax
				D.pegged = FALSE
	if(href_list["togglepeg"])
		var/datum/roguestock/D = locate(href_list["togglepeg"]) in SStreasury.stockpile_datums
		if(!D)
			return
		D.pegged = !D.pegged
		if(D.pegged)
			D.refresh_pegged_price()
	if(href_list["pegall"])
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			A.pegged = TRUE
			A.refresh_pegged_price()
		scom_announce("All stockpile prices re-pegged to market.")
	if(href_list["priceallmult"])
		var/mult = input(usr, "Multiply ALL stockpile prices by (e.g. 1.2 for +20%). Unpegs each entry.", src, 1.0) as null|num
		if(mult && mult > 0)
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				A.refresh_pegged_price()
				A.payout_price = max(1, round(A.payout_price * mult))
				A.pegged = FALSE
			scom_announce("Steward adjusted all stockpile prices by x[mult].")
	if(href_list["pricecatmult"])
		var/catname = href_list["pricecatmult"]
		var/mult = input(usr, "Multiply [catname] category prices by (e.g. 1.2 for +20%). Unpegs each entry.", src, 1.0) as null|num
		if(mult && mult > 0)
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				if(A.category != catname)
					continue
				A.refresh_pegged_price()
				A.payout_price = max(1, round(A.payout_price * mult))
				A.pegged = FALSE
			scom_announce("Steward adjusted [catname] stockpile prices by x[mult].")
	if(href_list["catacceptall"])
		var/catname = href_list["catacceptall"]
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			if(A.category != catname)
				continue
			A.accept_toggle_enabled = TRUE
		scom_announce("Steward opened deposits for all [catname] goods.")
	if(href_list["catacceptnone"])
		var/catname = href_list["catacceptnone"]
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			if(A.category != catname)
				continue
			A.accept_toggle_enabled = FALSE
		scom_announce("Steward closed deposits for all [catname] goods.")
	if(href_list["setlimit"])
		var/datum/roguestock/D = locate(href_list["setlimit"]) in SStreasury.stockpile_datums
		if(!D)
			return
		var/newlimit = input(usr, "Set a new limit for [D.name]", src, D.stockpile_limit) as null|num
		if(newlimit)
			if(!usr.canUseTopic(src, BE_CLOSE) || locked)
				return
			if(findtext(num2text(newlimit), "."))
				return
			newlimit = CLAMP(newlimit, 0, 999)
			scom_announce("The stockpile limit for [D.name] was changed to [newlimit].")
			D.stockpile_limit = newlimit
	if(href_list["givemoney"])
		var/X = locate(href_list["givemoney"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/newtax = input(usr, "How much to give [X]", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(newtax, A, "NERVE MASTER")
				break
	if(href_list["fineaccount"])
		var/X = locate(href_list["fineaccount"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/max_fine = SStreasury.get_max_fine_for(A)
				if(max_fine <= 0)
					say("[A] cannot be fined by the Crown at this time.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/newtax = input(usr, "How much to fine [A]? (Maximum [max_fine]m)", src, max_fine) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				if(newtax > max_fine)
					newtax = max_fine
					say("The ledger will accept no more than [max_fine]m from [A]. Amount adjusted.")
				SStreasury.give_money_account(-newtax, A, "NERVE MASTER")
				break
	if(href_list["printresidency"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(world.time < residency_print_cooldown)
			say("The machine is still warming its quill.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		var/mob/living/carbon/human/H = usr
		var/obj/item/citizenry_letter/letter = new(get_turf(src))
		letter.issuer_name = H.real_name
		letter.issuer_year = CALENDAR_EPOCH_YEAR
		residency_print_cooldown = world.time + 1 MINUTES
		playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
		say("Letter of Citizenry issued, signed by [H.real_name].")
	if(href_list["issueloan"])
		issue_loan_dialog(usr)
	if(href_list["setloanrate"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/current_pct = round(SStreasury.loan_interest_rate * 100)
		var/new_pct = input(usr, "Set daily loan interest rate (percent 0-200)", src, current_pct) as null|num
		if(isnull(new_pct))
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(new_pct), "."))
			return
		new_pct = CLAMP(new_pct, 0, 200)
		SStreasury.loan_interest_rate = new_pct / 100
		say("Default loan rate set to [new_pct]% per day.")
	if(href_list["setpurchasefloor"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/current_floor = SStreasury.stockpile_purchase_floor
		var/new_floor = input(usr, "Set the Crown's Purchase Floor. Below this balance the stockpile refuses purchases - goods stay with the seller. (0-10000m)", src, current_floor) as null|num
		if(isnull(new_floor))
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		new_floor = CLAMP(round(new_floor), 0, 10000)
		SStreasury.stockpile_purchase_floor = new_floor
		say("Crown's Purchase Floor set to [new_floor]m.")
		log_game("PURCHASE FLOOR: [key_name(usr)] set stockpile purchase floor to [new_floor]m")
	if(href_list["clearloandebtor"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/debtors = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(HAS_TRAIT(H, TRAIT_DEBTOR))
				debtors["[H.real_name]"] = H
		if(!length(debtors))
			say("No debtors currently marked.")
			return
		var/pick = input(usr, "Clear defaulter mark from which debtor?", src) as null|anything in debtors
		if(!pick)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/mob/living/carbon/human/target = debtors[pick]
		if(!target || !HAS_TRAIT(target, TRAIT_DEBTOR))
			return
		REMOVE_TRAIT(target, TRAIT_DEBTOR, TRAIT_GENERIC)
		var/datum/loan/forgiven = SStreasury.get_loan_for(target)
		var/loan_amt = forgiven ? forgiven.get_remaining_due() : 0
		if(forgiven)
			SStreasury.loans -= forgiven
			qdel(forgiven)
		SStreasury.clear_poll_tax_debt(target)
		say("[target.real_name]'s debtor mark has been cleared; all Crown debts forgiven.")
		log_game("DEBT FORGIVEN: [key_name(usr)] cleared debtor mark on [key_name(target)][loan_amt ? " (wrote off [loan_amt]m loan)" : ""]")
		to_chat(target, span_notice("The Stewardry has cleared the defaulter mark from my name. My debts to the Crown are forgiven."))
	if(href_list["clearpolltax"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/in_arrears = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(SStreasury.poll_tax_owed[H] || SStreasury.poll_tax_debt_days[H] || HAS_TRAIT(H, TRAIT_ARREARS))
				in_arrears["[H.real_name]"] = H
		if(!length(in_arrears))
			say("No poll tax arrears on the ledger.")
			return
		var/pick = input(usr, "Clear poll tax arrears for which subject?", src) as null|anything in in_arrears
		if(!pick)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/mob/living/carbon/human/target = in_arrears[pick]
		if(!target)
			return
		var/was_owed = SStreasury.poll_tax_owed[target] || 0
		var/was_overdue = SStreasury.poll_tax_debt_days[target] || 0
		SStreasury.clear_poll_tax_debt(target)
		say("[target.real_name]'s poll tax arrears have been cleared.")
		log_game("POLL TAX CLEARED: [key_name(usr)] cleared [was_owed]m poll tax arrears on [key_name(target)] ([was_overdue] day\s overdue)")
		to_chat(target, span_notice("The Stewardry has cleared my poll tax arrears. The Crown's ledger on my head is wiped clean."))
	if(href_list["imposepolltax"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/candidates = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(!H.real_name)
				continue
			if(!SStreasury.has_account(H))
				continue
			candidates["[H.real_name]"] = H
		if(!length(candidates))
			say("No valid subjects on the ledger.")
			return
		var/pick = input(usr, "Impose poll tax arrears on which subject?", src) as null|anything in candidates
		if(!pick)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/mob/living/carbon/human/target = candidates[pick]
		if(!target)
			return
		var/category = SStreasury.get_poll_tax_category(target)
		if(!category)
			say("[target.real_name] is outside the Crown's poll tax ledger.")
			return
		var/rate = SStreasury.get_poll_tax_rate_for(target, category)
		if(rate <= 0)
			say("[target.real_name]'s category bears no poll tax at present.")
			return
		var/days = input(usr, "Impose how many days of poll tax arrears? (Rate: [rate]m/day.)", src) as null|num
		if(!days || days <= 0)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		days = round(days)
		var/imposed = rate * days
		SStreasury.poll_tax_owed[target] = (SStreasury.poll_tax_owed[target] || 0) + imposed
		SStreasury.poll_tax_debt_days[target] = (SStreasury.poll_tax_debt_days[target] || 0) + days
		if(SStreasury.poll_tax_debt_days[target] >= POLL_TAX_DEBT_DAYS_TO_DEBTOR && !HAS_TRAIT(target, TRAIT_ARREARS))
			ADD_TRAIT(target, TRAIT_ARREARS, TRAIT_GENERIC)
		say("[target.real_name] has been assessed [imposed]m in poll tax arrears ([days] day\s).")
		log_game("POLL TAX IMPOSED: [key_name(usr)] imposed [imposed]m ([days] day\s) poll tax arrears on [key_name(target)]")
		to_chat(target, span_danger("<b>POLL TAX:</b> The Stewardry has imposed [days] day\s of back-poll-tax upon me ([imposed]m)."))
	if(href_list["payroll"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.retinue_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.burgher_positions) + list(GLOB.peasant_positions) + list(GLOB.sidefolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "Select a job", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/amount_to_pay = input(usr, "How much to pay every [job_to_pay]", src) as null|num
		if(!amount_to_pay)
			return
		if(amount_to_pay<1)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_to_pay)
				if(SStreasury.give_money_account(amount_to_pay, H, "NERVE MASTER"))
					record_round_statistic(STATS_WAGES_PAID, amount_to_pay)
	if(href_list["setdailypay"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.retinue_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.burgher_positions) + list(GLOB.peasant_positions) + list(GLOB.sidefolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "Select a job", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/wage_floor = SStreasury.get_wage_floor(job_to_pay)
		var/prompt = wage_floor > 0 ? "Set daily payment for [job_to_pay] (floor: [wage_floor]m by Charter; 0 not permitted)" : "Set daily payment for [job_to_pay] (0 to remove)"
		var/amount_to_pay = input(usr, prompt, src, daily_payments[job_to_pay] ? daily_payments[job_to_pay] : wage_floor) as null|num
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		if(isnull(amount_to_pay))
			return
		amount_to_pay = CLAMP(amount_to_pay, 0, 999)
		if(wage_floor > 0 && amount_to_pay < wage_floor)
			amount_to_pay = wage_floor
			say("By Charter, [job_to_pay]'s wage may not fall below [wage_floor]m. Payment set to the floor.")
		if(amount_to_pay == 0)
			daily_payments -= job_to_pay
			say("Daily payment for [job_to_pay] removed.")
		else
			daily_payments[job_to_pay] = amount_to_pay
			say("Daily payment for [job_to_pay] set to [amount_to_pay]m.")
	if(href_list["removedailypay"])
		var/job_to_remove = href_list["removedailypay"]
		var/removal_floor = SStreasury.get_wage_floor(job_to_remove)
		if(removal_floor > 0)
			daily_payments[job_to_remove] = removal_floor
			say("By Charter, [job_to_remove]'s wage cannot be removed. Payment held at the floor of [removal_floor]m.")
		else
			daily_payments -= job_to_remove
			say("Daily payment for [job_to_remove] removed.")
	if(href_list["togglewages"])
		var/X = locate(href_list["togglewages"])
		if(!X)
			return
		for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
			if(A == X)
				// Check if user has permission (Steward, Clerk, Grand Duke, or Regent)
				var/is_authorized = FALSE
				if(usr.job == "Steward" || usr.job == "Clerk" || usr.job == "Grand Duke")
					is_authorized = TRUE
				if(SSticker.regentmob && usr == SSticker.regentmob)
					is_authorized = TRUE

				if(!is_authorized)
					say("Only the Steward, Clerk, or Ruler may suspend wages.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return

				if(HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED))
					REMOVE_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name]'s wages have been reinstated.")
					to_chat(A, span_notice("My wages have been reinstated by the Stewardry."))
				else
					ADD_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name]'s wages have been suspended.")
					to_chat(A, span_danger("My wages have been suspended by the Stewardry!"))
				break
	if(href_list["compact"])
		compact = !compact
	if(href_list["changecat"])
		current_category = href_list["changecat"]
	if(href_list["changeautoexport"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/new_autoexport = input(usr, "Set a new autoexport percentage between 0 and 100", src, SStreasury.autoexport_percentage * 100) as null|num
		if(!new_autoexport && new_autoexport != 0)
			return
		if(findtext(num2text(new_autoexport), "."))
			return
		if(new_autoexport < 0 || new_autoexport > 100)
			to_chat(usr, span_warning("Invalid autoexport percentage. Must be between 0 and 100."))
			return
		new_autoexport = round(new_autoexport)
		SStreasury.autoexport_percentage = new_autoexport * 0.01
	if(href_list["trade_tgui"])
		open_trade_tgui(usr)
		return

	return attack_hand(usr)

/obj/structure/roguemachine/steward/proc/handle_trade_import(mob/user, region_id, good_id)
	if(!user_can_act(user))
		return
	// Alderman-acting is determined by trait+warrant, not by the machine's locked state. An
	// Alderman trading through an unlocked machine still draws from their warrant.
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		return
	var/quantity = input(user, "How many [tg.name] to import from [region.name]?", src, 1) as null|num
	if(!quantity || quantity < 1)
		return
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	if(findtext(num2text(quantity), "."))
		return
	quantity = round(quantity)
	var/daily_pace = region.produces[good_id] || 0
	if(daily_pace <= 0)
		to_chat(user, span_warning("[region.name] does not produce [tg.name]."))
		return
	var/produces_today = region.produces_today[good_id] || 0
	var/starting_index = max(0, daily_pace - produces_today)
	var/total = 0
	for(var/i in 1 to quantity)
		total += SSeconomy.compute_import_unit_price(good_id, region, starting_index + i)
	var/balance = SStreasury.discretionary_fund.balance
	var/blockade_note = region.is_region_blockaded ? "\n(BLOCKADED - [BLOCKADE_IMPORT_MULT]x cost)" : ""
	var/warrant_note = ""
	if(is_alderman_acting && SScity_assembly?.current_warrant)
		warrant_note = "\n(Warrant: [SScity_assembly.current_warrant.trade_remaining]m of [SScity_assembly.current_warrant.trade_daily_cap]m remaining)"
	var/confirm = alert(user, "Import [quantity] [tg.name] from [region.name]?\nTotal cost: [total]m\nCrown's Purse after: [balance - total]m[blockade_note][warrant_note]", "Confirm Import", "Yes", "No")
	if(confirm != "Yes")
		return
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	if(is_alderman_acting && !SScity_assembly.can_consume_trade(total))
		to_chat(user, span_warning("Your warrant cannot cover this trade. Remaining: [SScity_assembly.current_warrant.trade_remaining]m."))
		return
	var/spent = SSeconomy.manual_import(user, region_id, good_id, quantity)
	if(spent > 0)
		if(is_alderman_acting)
			SScity_assembly.consume_trade(spent, user, "import [quantity] [tg.name] from [region.name]")
		var/msg = "Azure Peak imports [quantity] [tg.name] from [region.name] for [spent] mammon."
		scom_announce(msg)
		say(msg)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	SStgui.update_uis(src)

/obj/structure/roguemachine/steward/proc/handle_trade_export(mob/user, region_id, good_id)
	if(!user_can_act(user))
		return
	// Alderman-acting is determined by trait+warrant, not by the machine's locked state.
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		return
	var/quantity = input(user, "How many [tg.name] to export to [region.name]?", src, 1) as null|num
	if(!quantity || quantity < 1)
		return
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	if(findtext(num2text(quantity), "."))
		return
	quantity = round(quantity)
	var/daily_pace = region.demands[good_id] || 0
	if(daily_pace <= 0)
		to_chat(user, span_warning("[region.name] does not demand [tg.name]."))
		return
	var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
	if(!entry || entry.stockpile_amount < quantity)
		to_chat(user, span_warning("Insufficient [tg.name] in stockpile: have [entry?.stockpile_amount || 0], need [quantity]."))
		return
	var/demands_today = region.demands_today[good_id] || 0
	var/starting_index = max(0, daily_pace - demands_today)
	var/total = 0
	for(var/i in 1 to quantity)
		total += SSeconomy.compute_export_unit_price(good_id, region, starting_index + i)
	var/balance = SStreasury.discretionary_fund.balance
	var/blockade_note = region.is_region_blockaded ? "\n(BLOCKADED - [BLOCKADE_EXPORT_MULT]x revenue)" : ""
	var/warrant_note = ""
	if(is_alderman_acting && SScity_assembly?.current_warrant)
		warrant_note = "\n(Warrant: [SScity_assembly.current_warrant.trade_remaining]m of [SScity_assembly.current_warrant.trade_daily_cap]m remaining)"
	var/confirm = alert(user, "Export [quantity] [tg.name] to [region.name]?\nTotal revenue: [total]m\nCrown's Purse after: [balance + total]m[blockade_note][warrant_note]", "Confirm Export", "Yes", "No")
	if(confirm != "Yes")
		return
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	if(is_alderman_acting && !SScity_assembly.can_consume_trade(total))
		to_chat(user, span_warning("Your warrant cannot cover this trade. Remaining: [SScity_assembly.current_warrant.trade_remaining]m."))
		return
	var/gained = SSeconomy.manual_export(user, region_id, good_id, quantity)
	if(gained > 0)
		if(is_alderman_acting)
			SScity_assembly.consume_trade(gained, user, "export [quantity] [tg.name] to [region.name]")
		var/msg = "Azure Peak exports [quantity] [tg.name] to [region.name] for [gained] mammon."
		scom_announce(msg)
		say(msg)
		playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	SStgui.update_uis(src)

/obj/structure/roguemachine/steward/proc/handle_trade_region_import(mob/user, region_id)
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return
	var/list/options = list()
	for(var/good_id in region.produces)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg || !tg.importable)
			continue
		options["[tg.name]"] = good_id
	if(!length(options))
		to_chat(user, span_warning("[region.name] has no importable goods."))
		return
	var/pick_name = input(user, "Import what from [region.name]?", src) as null|anything in options
	if(!pick_name)
		return
	handle_trade_import(user, region_id, options[pick_name])

/obj/structure/roguemachine/steward/proc/handle_trade_region_export(mob/user, region_id)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(locked && !alderman_has_access(user))
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return
	var/list/options = list()
	for(var/good_id in region.demands)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		options["[tg.name]"] = good_id
	if(!length(options))
		to_chat(user, span_warning("[region.name] has no demanded goods."))
		return
	var/pick_name = input(user, "Export what to [region.name]?", src) as null|anything in options
	if(!pick_name)
		return
	handle_trade_export(user, region_id, options[pick_name])

/obj/structure/roguemachine/steward/proc/do_import(datum/crown_import/D, number)
	if(!D)
		return
	D = new D
	if(number > D.import_amt)
		return

	if(!number)
		number = 1
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(!A)
		return
	var/obj/item/I = new D.item_type()
	var/list/turfs = list()
	for(var/turf/T in A)
		turfs += T
	var/turf/T = pick(turfs)
	I.forceMove(T)
	playsound(T, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	number += 1

	addtimer(CALLBACK(src, PROC_REF(do_import), D.type, number), 3 SECONDS)

/obj/structure/roguemachine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked && alderman_has_access(user))
		open_trade_tgui(user)
		return
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	switch(current_tab)
		if(TAB_MAIN)
			contents += "<center>NERVE MASTER<BR>"
			contents += "--------------<BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_BANK]'>\[Bank\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_STOCK]'>\[Stockpile\]</a><BR>"
			contents += "<a href='?src=\ref[src];trade_tgui=1'>\[Trade\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_IMPORT]'>\[Import\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_BOUNTIES]'>\[Bounties\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_PAYDAY]'>\[Daily Payments\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_LOG]'>\[Log\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_FISCAL]'>\[Fiscal Ledger\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_DEBT]'>\[Debts &amp; Arrears\]</a><BR>"
			contents += "<a href='?src=\ref[src];printresidency=1'>\[Print Letter of Citizenry\]</a><BR>"
			var/loan_gate_ok = (GLOB.dayspassed <= SStreasury.loan_max_issuance_day)
			if(loan_gate_ok)
				contents += "<a href='?src=\ref[src];issueloan=1'>\[Issue Loan\]</a><BR>"
			else
				contents += "<font color='gray'>\[Issue Loan - closed after day [SStreasury.loan_max_issuance_day]\]</font><BR>"
			contents += "<a href='?src=\ref[src];setloanrate=1'>\[Loan Rate: [round(SStreasury.loan_interest_rate * 100)]%/day\]</a><BR>"
			contents += "<a href='?src=\ref[src];setpurchasefloor=1'>\[Purchase Floor: [SStreasury.stockpile_purchase_floor]m\]</a><BR>"
			contents += "</center>"
		if(TAB_BANK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Bank<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
			contents += "<a href='?src=\ref[src];payroll=1'>\[Pay by Class\]</a><BR><BR>"
			// Collect all accounts, sort debtors/arrears first, then rest.
			var/list/priority_accounts = list() // debtors or in arrears
			var/list/normal_accounts = list()
			for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
				var/owed = SStreasury.poll_tax_owed[A] || 0
				var/is_debtor = HAS_TRAIT(A, TRAIT_DEBTOR)
				if(is_debtor || owed > 0)
					priority_accounts += A
				else
					normal_accounts += A
			for(var/mob/living/carbon/human/A in priority_accounts + normal_accounts)
				var/balance = SStreasury.get_balance(A)
				var/max_fine = SStreasury.get_max_fine_for(A)
				var/wage_status_short = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "UNSUSPEND" : "SUSPEND"
				var/wage_status_long = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "Unsuspend Wages" : "Suspend Wages"
				var/fine_label = max_fine > 0 ? "FINE (Max [max_fine]m)" : "FINE (exempt)"
				var/fine_long_label = max_fine > 0 ? "Fine Account (Max [max_fine]m)" : "Fine Account (exempt)"
				var/poll_owed = SStreasury.poll_tax_owed[A] || 0
				var/overdue_days = SStreasury.poll_tax_debt_days[A] || 0
				var/a_is_debtor = HAS_TRAIT(A, TRAIT_DEBTOR)
				var/debt_tag = ""
				if(a_is_debtor)
					var/owed_str = poll_owed > 0 ? ", owes [poll_owed]m" : ""
					debt_tag = " <font color='#d9534f'>\[DEBTOR[owed_str]\]</font>"
				else if(poll_owed > 0)
					debt_tag = " <font color='#e07b39'>\[ARREARS: [poll_owed]m, [overdue_days] day[overdue_days == 1 ? "" : "s"]\]</font>"
				if(compact)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [balance]m[debt_tag]"
					else
						contents += "[A.real_name] - [balance]m[debt_tag]"
					contents += " / <a href='?src=\ref[src];givemoney=\ref[A]'>\[PAY\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[[fine_label]\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status_short]\]</a><BR><BR>"
				else
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [balance]m[debt_tag]<BR>"
					else
						contents += "[A.real_name] - [balance]m[debt_tag]<BR>"
					contents += "<a href='?src=\ref[src];givemoney=\ref[A]'>\[Give Money\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[[fine_long_label]\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status_long]\]</a><BR><BR>"
		if(TAB_DEBT)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Debts &amp; Arrears<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
			// ── Active Loans ──────────────────────────────────────────────────
			if(length(SStreasury.loans))
				contents += "<b>Active Loans ([length(SStreasury.loans)]):</b><BR>"
				for(var/datum/loan/L in SStreasury.loans)
					var/loan_color = L.defaulted ? "#d9534f" : "#e07b39"
					contents += "<font color='[loan_color]'>[L.format()]</font><BR>"
				contents += "<BR>"
			else
				contents += "<i>No active loans.</i><BR><BR>"
			// ── Poll Tax Arrears & Debtors ────────────────────────────────────
			var/list/debt_rows = list()
			for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
				var/poll_owed = SStreasury.poll_tax_owed[A] || 0
				var/is_debtor = HAS_TRAIT(A, TRAIT_DEBTOR)
				if(poll_owed > 0 || is_debtor)
					debt_rows += A
			if(length(debt_rows))
				contents += "<b>Poll Tax Debtors / Arrears ([length(debt_rows)]):</b><BR>"
				for(var/mob/living/carbon/human/A in debt_rows)
					var/poll_owed = SStreasury.poll_tax_owed[A] || 0
					var/overdue_days = SStreasury.poll_tax_debt_days[A] || 0
					var/is_debtor = HAS_TRAIT(A, TRAIT_DEBTOR)
					var/balance = SStreasury.get_balance(A)
					if(is_debtor)
						var/owed_str = poll_owed > 0 ? ", owes [poll_owed]m" : ""
						contents += "<font color='#d9534f'><b>[A.real_name]</b> \[DEBTOR[owed_str]\]</font> - balance: [balance]m"
					else
						contents += "<font color='#e07b39'><b>[A.real_name]</b> \[ARREARS: [poll_owed]m, [overdue_days] day[overdue_days == 1 ? "" : "s"]\]</font> - balance: [balance]m"
					contents += "<BR>"
				contents += "<BR>"
			else
				contents += "<i>No poll tax arrears.</i><BR><BR>"
			contents += "<a href='?src=\ref[src];clearloandebtor=1'>\[Clear Defaulter Mark\]</a><BR>"
			contents += "<font color='gray'><i>(Forgives outstanding loans entirely and lifts the defaulter mark.)</i></font><BR>"
			contents += "<a href='?src=\ref[src];clearpolltax=1'>\[Clear Poll Tax Obligation\]</a> "
			contents += "<a href='?src=\ref[src];imposepolltax=1'>\[Impose Poll Tax Arrears\]</a><BR>"
			contents += "<font color='gray'><i>(Clear wipes a subject's poll tax arrears. Impose adds days of overdue poll tax to their record.)</i></font><BR>"
		if(TAB_STOCK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Stockpile<BR>"
			contents += "--------------<BR>"
			for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
				A.refresh_pegged_price()
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
			contents += "<center>Auto Export Stockpile Above: "
			contents += "<a href='?src=\ref[src];changeautoexport=1'>[SStreasury.autoexport_percentage * 100]%</a></center><BR>"
			contents += "<center><a href='?src=\ref[src];pegall=1'>\[Peg All\]</a> <a href='?src=\ref[src];priceallmult=1'>\[Global Margin x\]</a> <a href='?src=\ref[src];pricecatmult=[current_category]'>\[[current_category] Margin x\]</a></center><BR>"
			contents += "<center><a href='?src=\ref[src];catacceptall=[current_category]'>\[Accept All [current_category]\]</a> <a href='?src=\ref[src];catacceptnone=[current_category]'>\[Reject All [current_category]\]</a></center><BR>"
			var/selection = "<center>Categories: "
			for(var/category in categories)
				if(category == current_category)
					selection += "<b>[current_category]</b> "
				else
					selection += "<a href='?src=[REF(src)];changecat=[category]'>[category]</a> "
			contents += selection + "<BR>"
			contents += "--------------</center><BR>"
			if(compact)
				for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
					if(A.category != current_category)
						continue
					if(!A.accept_toggle_enabled)
						contents += "<font color='#888'><b>[A.name]:</b> NOT ACCEPTED</font> <a href='?src=\ref[src];toggleaccept=\ref[A]'>\[Enable\]</a><BR>"
						continue
					var/peg_tag = A.pegged ? "<font color='#8a8'>(P)</font>" : "<font color='#c84'>(U)</font>"
					contents += "<b>[A.name]:</b>"
					contents += " [A.stockpile_amount]"
					contents += " | PRICE: <a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]m[A.get_market_delta_tag()]</a> [peg_tag] <a href='?src=\ref[src];togglepeg=\ref[A]'>\[[A.pegged ? "Unpeg" : "Peg"]\]</a>"
					contents += " / LIMIT: <a href='?src=\ref[src];setlimit=\ref[A]'>[A.stockpile_limit]</a>"
					contents += " <a href='?src=\ref[src];toggleaccept=\ref[A]'>\[ACCEPT: ON\]</a><BR>"
			else
				for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
					if(A.category != current_category)
						continue
					if(!A.accept_toggle_enabled)
						contents += "<font color='#888'>[A.name] - NOT ACCEPTED</font><BR>"
						contents += "<font color='#888'>[A.desc]</font><BR>"
						contents += "<a href='?src=\ref[src];toggleaccept=\ref[A]'>\[Enable Accepting\]</a><BR><BR>"
						continue
					var/peg_tag = A.pegged ? "<font color='#8a8'>PEGGED</font>" : "<font color='#c84'>UNPEGGED</font>"
					contents += "[A.name]<BR>"
					contents += "[A.desc]<BR>"
					contents += "Stockpiled Amount: [A.stockpile_amount] / <a href='?src=\ref[src];setlimit=\ref[A]'>[A.stockpile_limit]</a><BR>"
					contents += "Price: <a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]m[A.get_market_delta_tag()]</a> [peg_tag] <a href='?src=\ref[src];togglepeg=\ref[A]'>\[[A.pegged ? "Unpeg" : "Peg"]\]</a><BR>"
					contents += "<a href='?src=\ref[src];togglewithdraw=\ref[A]'>\[[A.withdraw_disabled ? "Enable" : "Disable"] Withdrawing\]</a> <a href='?src=\ref[src];toggleaccept=\ref[A]'>\[Accept Deposits: ON\]</a><BR><BR>"
		if(TAB_IMPORT)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Imports<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
				for(var/datum/crown_import/A in GLOB.crown_imports)
					var/blockade_tag = A.is_blockaded() ? " <font color='#c44'>(BLOCKADED)</font>" : ""
					contents += "<b>[A.name][blockade_tag]:</b>"
					contents += " <a href='?src=\ref[src];import=\ref[A]'>\[Import [A.import_amt] ([A.get_import_price()])\]</a><BR><BR>"
			else
				contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
				for(var/datum/crown_import/A in GLOB.crown_imports)
					var/blockade_tag_full = A.is_blockaded() ? " <font color='#c44'>(BLOCKADED - 2x COST)</font>" : ""
					contents += "[A.name][blockade_tag_full]<BR>"
					contents += "[A.desc]<BR>"
					contents += "<a href='?src=\ref[src];import=\ref[A]'>\[Import [A.import_amt] ([A.get_import_price()])\]</a><BR><BR>"
		if(TAB_BOUNTIES)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += "<center>Bounties<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
			for(var/datum/roguestock/bounty/A in SStreasury.stockpile_datums)
				contents += "[A.name]<BR>"
				contents += "[A.desc]<BR>"
				contents += "Total Collected: [SStreasury.minted]<BR>"
				if(A.percent_bounty)
					contents += "Bounty Price: <a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]%</a><BR><BR>"
				else
					contents += "Bounty Price: <a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]</a><BR><BR>"
		if(TAB_LOG)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Log<BR>"
			contents += "--------------</center><BR><BR>"
			for(var/i = SStreasury.ledger.len to 1 step -1)
				var/datum/treasury_entry/entry = SStreasury.ledger[i]
				contents += "<span class='info'>[entry.format()]</span><BR>"
		if(TAB_FISCAL)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			var/list/snap = SStreasury.compute_fiscal_snapshot()
			var/list/charters = SStreasury.compute_charter_states()
			contents += "<center><b>Fiscal Ledger &mdash; Day [GLOB.dayspassed]</b></center>"
			contents += "<hr>"

			// Balances (two-column)
			contents += "<b><font color='#e6b327'>BALANCES</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Crown's Purse</td><td align='right'><font color='#e6b327'>[snap["discretionary"]]m</font></td>"
			contents += "<td>Burgher Pledge</td><td align='right'><font color='#e6b327'>[snap["burgher_pledge"]]m</font></td></tr>"
			contents += "<tr><td>Total Bank Coin</td><td align='right'>[snap["total_bank"]]m</td>"
			contents += "<td>Held Accounts</td><td align='right'>[snap["held_accounts"]]</td></tr>"
			contents += "<tr><td>Average Balance</td><td align='right'>[snap["avg_balance"]]m</td>"
			contents += "<td>Under 50m</td><td align='right'><font color='#e07b39'>[snap["under_50m"]]</font></td></tr>"
			contents += "</table><br>"

			// Revenue (two-column, green) - only mammon that lands in Crown's Purse
			contents += "<b><font color='#5cb85c'>CROWN REVENUE THIS WEEK</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Rural Tax</td><td align='right'><font color='#5cb85c'>[SStreasury.total_rural_tax]m</font></td>"
			contents += "<td>Fines</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_FINES_INCOME]]m</font></td></tr>"
			contents += "<tr><td>Poll Tax</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_POLL_TAX_COLLECTED]]m</font></td>"
			contents += "<td>Deposit Tax</td><td align='right'><font color='#5cb85c'>[SStreasury.total_deposit_tax]m</font></td></tr>"
			contents += "<tr><td>Contract Levy</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_CONTRACT_LEVY]]m</font></td>"
			contents += "<td>Headeater Levy</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_HEADEATER_LEVY]]m</font></td></tr>"
			contents += "<tr><td>Import Tariff</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_IMPORT_TARIFF]]m</font></td>"
			contents += "<td>Export Duty</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_EXPORT_DUTY]]m</font></td></tr>"
			contents += "<tr><td>Treasure Minted (Gross)</td><td align='right'>[GLOB.azure_round_stats[STATS_MINTED_TREASURE_GROSS]]m</td>"
			contents += "<td>Treasure Minted (Crown Cut)</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_MINTED_TREASURE_NET]]m</font></td></tr>"
			contents += "</table><br>"

			// Forgone Revenue (two-column, muted - what the Crown *could* have collected)
			var/exempt_contract = GLOB.azure_round_stats[STATS_EXEMPTED_CONTRACT_LEVY]
			var/exempt_headeater = GLOB.azure_round_stats[STATS_EXEMPTED_HEADEATER_LEVY]
			var/exempt_import = GLOB.azure_round_stats[STATS_EXEMPTED_IMPORT_TARIFF]
			var/exempt_export = GLOB.azure_round_stats[STATS_EXEMPTED_EXPORT_DUTY]
			var/exempt_fine = GLOB.azure_round_stats[STATS_EXEMPTED_FINE]
			var/exempt_poll = GLOB.azure_round_stats[STATS_EXEMPTED_POLL_TAX]
			var/exempt_total = exempt_contract + exempt_headeater + exempt_import + exempt_export + exempt_fine + exempt_poll
			contents += "<b><font color='#8f7a5a'>FORGONE REVENUE (tax exempted)</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Contract Levy</td><td align='right'><font color='#8f7a5a'>[exempt_contract]m</font></td>"
			contents += "<td>Headeater Levy</td><td align='right'><font color='#8f7a5a'>[exempt_headeater]m</font></td></tr>"
			contents += "<tr><td>Import Tariff</td><td align='right'><font color='#8f7a5a'>[exempt_import]m</font></td>"
			contents += "<td>Export Duty</td><td align='right'><font color='#8f7a5a'>[exempt_export]m</font></td></tr>"
			contents += "<tr><td>Fines Waived</td><td align='right'><font color='#8f7a5a'>[exempt_fine]m</font></td>"
			contents += "<td>Poll Tax</td><td align='right'><font color='#8f7a5a'>[exempt_poll]m</font></td></tr>"
			contents += "<tr><td><b>Total Forgone</b></td><td align='right'><b><font color='#8f7a5a'>[exempt_total]m</font></b></td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table>"
			contents += "<font size='1'><i>Charter exemptions, levy-exempt stamps, and rate-cap gaps. Mammon the Crown would have collected had no exemption applied.</i></font><br><br>"

			// Trade (two-column, mixed)
			contents += "<b><font color='#c0b283'>TRADE</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Stockpile Exports</td><td align='right'><font color='#5cb85c'>[SStreasury.total_export]m</font></td>"
			contents += "<td>Stockpile Imports</td><td align='right'><font color='#d9534f'>-[SStreasury.total_import]m</font></td></tr>"
			var/trade_bal = SStreasury.total_export - SStreasury.total_import
			var/trade_col = trade_bal >= 0 ? "#5cb85c" : "#d9534f"
			contents += "<tr><td>Trade Balance</td><td align='right'><font color='[trade_col]'>[trade_bal]m</font></td>"
			contents += "<td>Economic Output</td><td align='right'>[SStreasury.economic_output]m</td></tr>"
			contents += "</table><br>"

			// Expenses (two-column, red)
			contents += "<b><font color='#d9534f'>EXPENSES THIS WEEK</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Wages Paid</td><td align='right'><font color='#d9534f'>-[GLOB.azure_round_stats[STATS_WAGES_PAID]]m</font></td>"
			contents += "<td>Treasury Transfers</td><td align='right'><font color='#d9534f'>-[GLOB.azure_round_stats[STATS_DIRECT_TREASURY_TRANSFERS]]m</font></td></tr>"
			contents += "<tr><td>Stockpile Imports <font size='1'><i>(see Trade)</i></font></td><td align='right'><font color='#d9534f'>-[SStreasury.total_import]m</font></td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table><br>"

			// Tax Rates (two columns: rate name | percentage)
			contents += "<b>TAX RATES</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			var/list/rate_entries = list()
			for(var/cat in SStreasury.tax_rates)
				if(cat == TAX_CATEGORY_FINE)
					continue
				rate_entries += "<td>[SStreasury.get_tax_category_pretty_name(cat)]</td><td align='right'>[round(SStreasury.tax_rates[cat] * 100)]%</td>"
			for(var/i = 1, i <= length(rate_entries), i += 2)
				contents += "<tr>"
				contents += rate_entries[i]
				if(i + 1 <= length(rate_entries))
					contents += rate_entries[i + 1]
				else
					contents += "<td></td><td></td>"
				contents += "</tr>"
			contents += "</table><br>"

			// Poll Tax Rates (two columns: category | m/day)
			contents += "<b>POLL TAX RATES (daily)</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			var/datum/decree/golden = SStreasury.get_decree(DECREE_GOLDEN_BULL)
			var/golden_active = golden?.active
			var/datum/decree/covenant = SStreasury.get_decree(DECREE_NOC_PESTRA_COVENANT)
			var/covenant_active = covenant?.active
			var/datum/decree/merc_charter = SStreasury.get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
			var/merc_charter_active = merc_charter?.active
			var/list/poll_entries = list()
			for(var/pcat in SStreasury.poll_tax_rates)
				var/rate = SStreasury.poll_tax_rates[pcat]
				var/pretty = SStreasury.get_poll_tax_category_pretty_name(pcat)
				var/rate_display = "[rate]m"
				if(pcat == POLL_TAX_CAT_BURGHER && golden_active && rate > GOLDEN_BULL_POLL_CAP)
					rate_display = "<font color='#e07b39'>[GOLDEN_BULL_POLL_CAP]m</font> (raw [rate]m, capped)"
				else if(pcat == POLL_TAX_CAT_MERCENARY && merc_charter_active && rate > GUILD_CHARTER_OF_ARMS_POLL_CAP)
					rate_display = "<font color='#e07b39'>[GUILD_CHARTER_OF_ARMS_POLL_CAP]m</font> (raw [rate]m, capped)"
				poll_entries += "<td>[pretty]</td><td align='right'>[rate_display]</td>"
			for(var/i = 1, i <= length(poll_entries), i += 2)
				contents += "<tr>"
				contents += poll_entries[i]
				if(i + 1 <= length(poll_entries))
					contents += poll_entries[i + 1]
				else
					contents += "<td></td><td></td>"
				contents += "</tr>"
			contents += "</table>"
			if(covenant_active)
				contents += "<i><font color='#e07b39'>Covenant of Noc & Pestra in force: University and Apothecary pay no more than [NOC_PESTRA_POLL_CAP]m/day regardless of category rate.</font></i><br>"
			contents += "<br>"

			// Charters (two-column)
			contents += "<b>CHARTERS</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			var/list/charter_rows = list()
			for(var/entry in charters)
				var/cooldown_left = entry["cooldown_remaining"]
				var/cd_text = cooldown_left > 0 ? " <i>(cd: [round(cooldown_left / 600, 0.1)]m)</i>" : ""
				var/status_color = entry["active"] ? "#5cb85c" : "#d9534f"
				var/status_text = entry["active"] ? "ACTIVE" : "SUSPENDED"
				charter_rows += "<td>[entry["name"]]</td><td align='right'><font color='[status_color]'>[status_text]</font>[cd_text]</td>"
			for(var/i = 1, i <= length(charter_rows), i += 2)
				contents += "<tr>"
				contents += charter_rows[i]
				if(i + 1 <= length(charter_rows))
					contents += charter_rows[i + 1]
				else
					contents += "<td></td><td></td>"
				contents += "</tr>"
			contents += "</table><br>"

			// Debt & Loans (two-column, orange for warnings)
			contents += "<b><font color='#e07b39'>DEBT &amp; LOANS</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Accounts in Arrears</td><td align='right'><font color='#e07b39'>[snap["in_arrears"]]</font></td>"
			contents += "<td>Accounts in Advance</td><td align='right'>[snap["in_advance"]]</td></tr>"
			contents += "<tr><td>Default Debtors</td><td align='right'><font color='#d9534f'>[snap["debtor_count"]]</font></td>"
			contents += "<td>Loans Outstanding</td><td align='right'>[snap["loans_outstanding"]] ([snap["loan_exposure"]]m)</td></tr>"
			contents += "</table><br>"

			// Contracts (three-column: Issued / Taken / Completed, by issuing authority)
			contents += "<b>CONTRACTS THIS WEEK</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td></td><td align='right'><b>Issued</b></td><td align='right'><b>Taken</b></td><td align='right'><b>Completed</b></td></tr>"
			contents += "<tr><td>Guild</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_POOL]]</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_POOL]]</td>"
			contents += "<td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_POOL]]</font></td></tr>"
			contents += "<tr><td>Tavern</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_RUMOR]]</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_RUMOR]]</td>"
			contents += "<td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_RUMOR]]</font></td></tr>"
			contents += "<tr><td>Crown</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_DEFENSE]]</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_DEFENSE]]</td>"
			contents += "<td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_DEFENSE]]</font></td></tr>"
			contents += "<tr><td><b>Total</b></td>"
			contents += "<td align='right'><b>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED]]</b></td>"
			contents += "<td align='right'><b>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN]]</b></td>"
			contents += "<td align='right'><b><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED]]</font></b></td></tr>"
			contents += "</table>"
		if(TAB_PAYDAY)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Daily Payments<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m<BR>"
			var/total_payroll = 0
			for(var/job_name in daily_payments)
				var/amt = daily_payments[job_name]
				var/count = 0
				for(var/mob/living/carbon/human/H in GLOB.human_list)
					if(H.job == job_name && !HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
						count++
				total_payroll += amt * count
			contents += "Projected Daily Payroll: [total_payroll]m</center><BR>"
			contents += "<a href='?src=\ref[src];setdailypay=1'>\[Add/Modify Job Payment\]</a><BR><BR>"
			if(daily_payments.len)
				contents += "<center>Configured Payments:</center><BR>"
				for(var/job_name in daily_payments)
					var/amt = daily_payments[job_name]
					var/count = 0
					for(var/mob/living/carbon/human/H in GLOB.human_list)
						if(H.job == job_name && !HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
							count++
					var/job_floor = SStreasury.get_wage_floor(job_name)
					contents += "<b>[job_name]:</b> [amt]m/day"
					if(job_floor > 0)
						contents += " <font color='#e07b39'>\[FLOORED [job_floor]m by Charter\]</font>"
					if(count > 0)
						contents += " ([count] employed, [amt * count]m total/day)"
					contents += " <a href='?src=\ref[src];removedailypay=[job_name]'>\[Remove\]</a><BR>"
			else
				contents += "<center>No daily payments configured.</center><BR>"

	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 700, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/steward/proc/job_filter(advj, j, compact = FALSE)
	if(advj in excluded_jobs)
		return "Adventurer"
	if(j in excluded_jobs)
		return "Adventurer"
	if(compact && j)
		return j
	else if(!compact && advj && j)
		return "[j] ([advj])"
	else if(j)
		return j
	else if(advj)
		return advj

#undef TAB_MAIN
#undef TAB_BANK
#undef TAB_STOCK
#undef TAB_IMPORT
#undef TAB_BOUNTIES
#undef TAB_LOG
#undef TAB_FISCAL
#undef TAB_PAYDAY
#undef TAB_DEBT
