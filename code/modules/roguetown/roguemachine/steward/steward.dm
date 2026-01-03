#define TAB_MAIN 1
#define TAB_BANK 2
#define TAB_STOCK 3
#define TAB_IMPORT 4
#define TAB_BOUNTIES 5
#define TAB_LOG 6
#define TAB_STATISTICS 7
#define TAB_PAYDAY 8

/obj/structure/roguemachine/steward
	name = "nerve master"
	desc = "A magitech device connected to the royal treasury. Stewards can manage payroll by interacting with it."
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
	daily_payments["Warden"] = 30
	daily_payments["Veteran"] = 20
	daily_payments["Squire"] = 10
	daily_payments["Seneschal"] = 40 //Manor-House
	daily_payments["Servant"] = 20	
	daily_payments["Head Physician"] = 20 //Doctors
	daily_payments["Apothecary"] = 10
	daily_payments["Court Magician"] = 40 //University
	daily_payments["Archivist"] = 20
	daily_payments["Magicians Associate"] = 10

/obj/structure/roguemachine/steward/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol || istype(K, /obj/item/roguekey/lord)) //Master key
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
		SStreasury.give_money_treasury(P.get_real_price(), "NERVE MASTER deposit")
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
		if(SStreasury.treasury_value < D.get_import_price())
			say("Insufficient mammon.")
			return
		var/amt = D.get_import_price()
		SStreasury.treasury_value -= amt
		SStreasury.total_import += amt
		SStreasury.log_to_steward("-[amt] imported [D.name]")
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
				if(SStreasury.check_fine_exemption(A))
					say("By our Liege's mercy, they can not be fined!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/newtax = input(usr, "How much to fine [X]", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(-newtax, A, "NERVE MASTER")
				break
	if(href_list["payroll"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
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
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
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
			contents += "<a href='?src=\ref[src];switchtab=[TAB_STATISTICS]'>\[Statistics\]</a><BR>"
			contents += "</center>"
		if(TAB_BANK)
			var/total_deposit = 0
			for(var/bank_account in SStreasury.bank_accounts)
				total_deposit += SStreasury.bank_accounts[bank_account]
			if(total_deposit == 0)
				total_deposit++ //Division by zero catch
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Bank<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.treasury_value]m<BR>"
			contents += "Reserve Ratio: [round(SStreasury.treasury_value / total_deposit * 100)]%</center><BR>"
			contents += "<a href='?src=\ref[src];payroll=1'>\[Pay by Class\]</a><BR><BR>"
			if(compact)
				for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [SStreasury.bank_accounts[A]]m"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m"
					var/wage_status = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "UNSUSPEND" : "SUSPEND"
					contents += " / <a href='?src=\ref[src];givemoney=\ref[A]'>\[PAY\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[FINE\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status]\]</a><BR><BR>"
			else
				for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [SStreasury.bank_accounts[A]]m<BR>"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m<BR>"
					var/wage_status = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "Unsuspend Wages" : "Suspend Wages"
					contents += "<a href='?src=\ref[src];givemoney=\ref[A]'>\[Give Money\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[Fine Account\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status]\]</a><BR><BR>"
		if(TAB_STOCK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[Compact: [compact? "ENABLED" : "DISABLED"]\]</a><BR>"
			contents += "<center>Stockpile<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "Treasury: [SStreasury.treasury_value]m"
				contents += " / Lord's Tax: [SStreasury.tax_value*100]%"
				contents += " / Guild's Tax: [SStreasury.queens_tax*100]%</center><BR>"
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
				contents += "Treasury: [SStreasury.treasury_value]m<BR>"
				contents += "Lord's Tax: [SStreasury.tax_value*100]%<BR>"
				contents += "Guild's Tax: [SStreasury.queens_tax*100]%</center><BR>"
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
				contents += "Treasury: [SStreasury.treasury_value]m"
				contents += " / Lord's Tax: [SStreasury.tax_value*100]%"
				contents += " / Guild's Tax: [SStreasury.queens_tax*100]%</center><BR>"
				for(var/datum/roguestock/import/A in SStreasury.stockpile_datums)
					contents += "<b>[A.name]:</b>"
					contents += " <a href='?src=\ref[src];import=\ref[A]'>\[Import [A.importexport_amt] ([A.get_import_price()])\]</a><BR><BR>"
			else
				contents += "Treasury: [SStreasury.treasury_value]m<BR>"
				contents += "Lord's Tax: [SStreasury.tax_value*100]%<BR>"
				contents += "Guild's Tax: [SStreasury.queens_tax*100]%</center><BR>"
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
			contents += "Treasury: [SStreasury.treasury_value]m<BR>"
			contents += "Lord's Tax: [SStreasury.tax_value*100]%</center><BR>"
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
			for(var/i = SStreasury.log_entries.len to 1 step -1)
				contents += "<span class='info'>[SStreasury.log_entries[i]]</span><BR>"
		if(TAB_STATISTICS)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Statistics:<BR>"
			contents += "Known Economic Output: [SStreasury.economic_output]m<BR>"
			contents += "Total Rural Tax: [SStreasury.total_rural_tax]m<BR>"
			contents += "Total Deposit Tax: [SStreasury.total_deposit_tax]m<BR>"
			contents += "Total Noble Estate Income: [SStreasury.total_noble_income]m<BR>"
			contents += "Total Import: [SStreasury.total_import]m<BR>"
			contents += "Total Export: [SStreasury.total_export]m<BR>"
			contents += "Total Mammons Minted: [SStreasury.minted]m<BR>"
			contents += "Trade Balance: [SStreasury.total_export - SStreasury.total_import]m<BR>"
			contents  += "</center><BR>"
		if(TAB_PAYDAY)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			contents += "<center>Daily Payments<BR>"
			contents += "--------------<BR>"
			contents += "Treasury: [SStreasury.treasury_value]m</center><BR>"
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
#undef TAB_STATISTICS
#undef TAB_PAYDAY
