#define TAB_MAIN 1
#define TAB_BANK 2
#define TAB_STOCK 3
#define TAB_IMPORT 4
#define TAB_BOUNTIES 5
#define TAB_LOG 6
#define TAB_FISCAL 7
#define TAB_PAYDAY 8

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
	var/list/categories = list("Raw Materials", "Fruit", "Vegetable", "Animal","Seafood")
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

/obj/structure/roguemachine/steward/proc/issue_loan_dialog(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(GLOB.dayspassed > SStreasury.loan_max_issuance_day)
		say("No new loans may be drawn after day [SStreasury.loan_max_issuance_day].")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	// Build candidate list from accounted humans, excluding those already in debt or marked defaulter.
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in SStreasury.bank_accounts)
		if(H.stat == DEAD)
			continue
		if(HAS_TRAIT(H, TRAIT_DEBTOR))
			continue
		if(SStreasury.get_loan_for(H))
			continue
		candidates["[H.real_name] ([H.job ? H.job : "-"])"] = H
	if(!length(candidates))
		say("No eligible debtors found.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/picked = input(user, "Select a debtor for the loan.", src) as null|anything in candidates
	if(!picked)
		return
	if(!user.canUseTopic(src, BE_CLOSE) || locked)
		return
	var/mob/living/carbon/human/debtor = candidates[picked]
	if(!debtor || HAS_TRAIT(debtor, TRAIT_DEBTOR) || SStreasury.get_loan_for(debtor))
		say("That debtor is no longer eligible.")
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
	contract.debtor_name_ic = debtor.real_name
	contract.principal = amount
	contract.term_days = term
	contract.interest_rate = SStreasury.loan_interest_rate
	contract.principal_due_on_day = GLOB.dayspassed + term
	contract.total_due = FLOOR(amount * (1 + (contract.interest_rate * term)), 1)
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	say("Loan Contract for [debtor.real_name] issued: [amount]m over [term] day\s, signed by [user.real_name].")


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
		var/datum/roguestock/D = locate(href_list["import"]) in SStreasury.stockpile_datums
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
	if(href_list["setprice"])
		var/datum/roguestock/D = locate(href_list["setprice"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newtax = input(usr, "Set a new price to withdraw [D.name]", src, D.withdraw_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 0, 999)
				if(newtax < D.withdraw_price)
					scom_announce("The withdraw price for [D.name] was decreased.")
				D.withdraw_price = newtax
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
		if(forgiven)
			SStreasury.loans -= forgiven
			qdel(forgiven)
		SStreasury.clear_poll_tax_debt(target)
		say("[target.real_name]'s debtor mark has been cleared; all Crown debts forgiven.")
		to_chat(target, span_notice("The Stewardry has cleared the defaulter mark from my name. My debts to the Crown are forgiven."))
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
				record_round_statistic(STATS_WAGES_PAID)
				SStreasury.give_money_account(amount_to_pay, H, "NERVE MASTER")
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
		var/amount_to_pay = input(usr, "Set daily payment for [job_to_pay] (0 to remove)", src, daily_payments[job_to_pay] ? daily_payments[job_to_pay] : 0) as null|num
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		if(isnull(amount_to_pay))
			return
		amount_to_pay = CLAMP(amount_to_pay, 0, 999)
		if(amount_to_pay == 0)
			daily_payments -= job_to_pay
			say("Daily payment for [job_to_pay] removed.")
		else
			daily_payments[job_to_pay] = amount_to_pay
			say("Daily payment for [job_to_pay] set to [amount_to_pay]m.")
	if(href_list["removedailypay"])
		var/job_to_remove = href_list["removedailypay"]
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
	
	return attack_hand(usr)

/obj/structure/roguemachine/steward/proc/do_import(datum/roguestock/D,number)
	if(!D)
		return
	D = new D
	if(number > D.importexport_amt)
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
			contents += "<a href='?src=\ref[src];switchtab=[TAB_IMPORT]'>\[Import\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_BOUNTIES]'>\[Bounties\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_PAYDAY]'>\[Daily Payments\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_LOG]'>\[Log\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_FISCAL]'>\[Fiscal Ledger\]</a><BR>"
			contents += "<a href='?src=\ref[src];printresidency=1'>\[Print Letter of Citizenry\]</a><BR>"
			var/loan_gate_ok = (GLOB.dayspassed <= SStreasury.loan_max_issuance_day)
			if(loan_gate_ok)
				contents += "<a href='?src=\ref[src];issueloan=1'>\[Issue Loan\]</a><BR>"
			else
				contents += "<font color='gray'>\[Issue Loan - closed after day [SStreasury.loan_max_issuance_day]\]</font><BR>"
			contents += "<a href='?src=\ref[src];setloanrate=1'>\[Loan Rate: [round(SStreasury.loan_interest_rate * 100)]%/day\]</a><BR>"
			contents += "<a href='?src=\ref[src];clearloandebtor=1'>\[Clear Defaulter Mark\]</a><BR>"
			contents += "<font color='gray'><i>(A defaulter's mark lifts automatically when they settle the outstanding debt at a MEISTER. Use this to forgive the debt entirely.)</i></font><BR>"
			contents += "</center>"
		if(TAB_BANK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Bank<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
			if(length(SStreasury.loans))
				contents += "<center>Active Loans ([length(SStreasury.loans)]):</center><BR>"
				for(var/datum/loan/L in SStreasury.loans)
					contents += "<span class='info'>[L.format()]</span><BR>"
				contents += "<BR>"
			contents += "<a href='?src=\ref[src];payroll=1'>\[Pay by Class\]</a><BR><BR>"
			for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
				var/balance = SStreasury.get_balance(A)
				var/max_fine = SStreasury.get_max_fine_for(A)
				var/wage_status_short = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "UNSUSPEND" : "SUSPEND"
				var/wage_status_long = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "Unsuspend Wages" : "Suspend Wages"
				var/fine_label = max_fine > 0 ? "FINE (Max [max_fine]m)" : "FINE (exempt)"
				var/fine_long_label = max_fine > 0 ? "Fine Account (Max [max_fine]m)" : "Fine Account (exempt)"
				if(compact)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [balance]m"
					else
						contents += "[A.real_name] - [balance]m"
					contents += " / <a href='?src=\ref[src];givemoney=\ref[A]'>\[PAY\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[[fine_label]\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status_short]\]</a><BR><BR>"
				else
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [balance]m<BR>"
					else
						contents += "[A.real_name] - [balance]m<BR>"
					contents += "<a href='?src=\ref[src];givemoney=\ref[A]'>\[Give Money\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[[fine_long_label]\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status_long]\]</a><BR><BR>"
		if(TAB_STOCK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Stockpile<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
				contents += "<center>Auto Export Stockpile Above: "
				contents += "<a href='?src=\ref[src];changeautoexport=1'>[SStreasury.autoexport_percentage * 100]%</a></center><BR>"
				var/selection = "<center>Categories: "
				for(var/category in categories)
					if(category == current_category)
						selection += "<b>[current_category]</b> "
					else
						selection += "<a href='?src=[REF(src)];changecat=[category]'>[category]</a> "
				contents += selection + "<BR>"
				contents += "--------------</center><BR>"
				for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
					if(A.category != current_category)
						continue
					contents += "<b>[A.name]:</b>"
					contents += " [A.held_items[1] + A.held_items[2]]"
					contents += " | SELL: <a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]m</a>"
					contents += " / BUY: <a href='?src=\ref[src];setprice=\ref[A]'>[A.withdraw_price]m</a>"
					contents += " / LIMIT: <a href='?src=\ref[src];setlimit=\ref[A]'>[A.stockpile_limit]</a>"
					if(!A.export_only)
						if(A.importexport_amt)
							contents += " <a href='?src=\ref[src];import=\ref[A]'>\[IMP [A.importexport_amt] ([A.get_import_price()])\]</a> <a href='?src=\ref[src];export=\ref[A]'>\[EXP [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
					else
						if(A.importexport_amt)
							contents += " <a href='?src=\ref[src];export=\ref[A]'>\[EXP [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
			
			else
				contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
				var/selection = "<center>Categories: "
				for(var/category in categories)
					if(category == current_category)
						selection += "<b>[current_category]</b> "
					else
						selection += "<a href='?src=[REF(src)];changecat=[category]'>[category]</a> "
				contents += selection + "<BR>"
				contents += "--------------</center><BR>"
				for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
					if(A.category != current_category)
						continue
					contents += "[A.name]<BR>"
					contents += "[A.desc]<BR>"
					contents += "Stockpiled Amount: [A.held_items[1] + A.held_items[2]]<BR>"
					contents += "Bounty Price: <a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]</a><BR>"
					contents += "Withdraw Price: <a href='?src=\ref[src];setprice=\ref[A]'>[A.withdraw_price]</a><BR>"
					contents += "Demand: [A.demand2word()]<BR>"
					if(!A.export_only)
						if(A.importexport_amt)
							contents += "<a href='?src=\ref[src];import=\ref[A]'>\[Import [A.importexport_amt] ([A.get_import_price()])\]</a> <a href='?src=\ref[src];export=\ref[A]'>\[Export [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
					else
						if(A.importexport_amt)
							contents += " <a href='?src=\ref[src];export=\ref[A]'>\[Export [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
					contents += "<a href='?src=\ref[src];togglewithdraw=\ref[A]'>\[[A.withdraw_disabled ? "Enable" : "Disable"] Withdrawing\]</a><BR><BR>"
		if(TAB_IMPORT)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Imports<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
				for(var/datum/roguestock/import/A in SStreasury.stockpile_datums)
					contents += "<b>[A.name]:</b>"
					contents += " <a href='?src=\ref[src];import=\ref[A]'>\[Import [A.importexport_amt] ([A.get_import_price()])\]</a><BR><BR>"
			else
				contents += "Treasury: [SStreasury.discretionary_fund.balance]m</center><BR>"
				for(var/datum/roguestock/import/A in SStreasury.stockpile_datums)
					contents += "[A.name]<BR>"
					contents += "[A.desc]<BR>"
					if(!A.stable_price)
						contents += "Demand: [A.demand2word()]<BR>"
					contents += "<a href='?src=\ref[src];import=\ref[A]'>\[Import [A.importexport_amt] ([A.get_import_price()])\]</a><BR><BR>"
		if(TAB_BOUNTIES)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += "<center>Bounties<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.discretionary_fund.balance]m<BR>"
			contents += "Contract Levy: [round(SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)*100)]%</center><BR>"
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
			contents += "<tr><td>Mammons Minted</td><td align='right'>[SStreasury.minted]m</td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table><br>"

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
			var/list/poll_entries = list()
			for(var/pcat in SStreasury.poll_tax_rates)
				var/rate = SStreasury.poll_tax_rates[pcat]
				var/pretty = SStreasury.get_poll_tax_category_pretty_name(pcat)
				var/rate_display = "[rate]m"
				if(pcat == POLL_TAX_CAT_BURGHER && golden_active && rate > GOLDEN_BULL_POLL_CAP)
					rate_display = "<font color='#e07b39'>[GOLDEN_BULL_POLL_CAP]m</font> (raw [rate]m, capped)"
				poll_entries += "<td>[pretty]</td><td align='right'>[rate_display]</td>"
			for(var/i = 1, i <= length(poll_entries), i += 2)
				contents += "<tr>"
				contents += poll_entries[i]
				if(i + 1 <= length(poll_entries))
					contents += poll_entries[i + 1]
				else
					contents += "<td></td><td></td>"
				contents += "</tr>"
			contents += "</table><br>"

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
			contents += "<td>Accounts in Grace</td><td align='right'>[snap["in_grace"]]</td></tr>"
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
					contents += "<b>[job_name]:</b> [amt]m/day"
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
