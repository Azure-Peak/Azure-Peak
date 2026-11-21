#define TAB_MAIN 1
#define TAB_FISCAL 6

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
	var/datum/steward_treasury_panel/treasury_panel
	var/total_deposit = 0
	var/list/excluded_jobs = list("Wretch","Vagabond","Adventurer")
	var/list/daily_payments = list()
	var/residency_print_cooldown = 0
	var/list/ledger_view = list()
	var/list/petition_view = list()
	var/list/caravan_view = list()

/obj/structure/roguemachine/steward/Initialize(mapload)
	. = ..()
	if(SStreasury.steward_machine == null) //The "only one" mapped in Nerve Master at map start
		SStreasury.steward_machine = src
	setup_default_payments()

/obj/structure/roguemachine/steward/Destroy()
	QDEL_NULL(treasury_panel)
	return ..()

//	For competence of life I will allow you,
//	That lack of means enforce you not to evil:
/obj/structure/roguemachine/steward/proc/setup_default_payments()
	daily_payments["Marshal"] = 60 //Garrison
	daily_payments["Knight"] = 40
	daily_payments["Sergeant"] = 40
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

/obj/structure/roguemachine/steward/proc/enforce_wage_floors()
	for(var/job in daily_payments)
		var/floor = SStreasury.get_wage_floor(job)
		if(floor > 0 && (daily_payments[job] || 0) < floor)
			daily_payments[job] = floor
	for(var/job in SStreasury.enumerate_wage_floored_jobs())
		if(isnull(daily_payments[job]))
			daily_payments[job] = SStreasury.get_wage_floor(job)

/proc/has_fiscal_authority(mob/user)
	if(!user)
		return FALSE
	if(user.job == "Steward" || user.job == "Clerk" || user.job == "Grand Duke")
		return TRUE
	if(SSticker.regentmob && user == SSticker.regentmob)
		return TRUE
	return FALSE



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
		SStreasury.mint(SStreasury.discretionary_fund, P.get_real_price(), "NERVE MASTER deposit", null, LEDGER_CROWN_REV_OTHER)
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
	if(href_list["printresidency"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(world.time < residency_print_cooldown)
			say("You just printed a letter. Wait [DisplayTimeText(residency_print_cooldown - world.time)] and try again.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		var/mob/living/carbon/human/H = usr
		var/obj/item/citizenry_letter/letter = new(get_turf(src))
		letter.issuer_name = H.real_name
		letter.issuer_year = CALENDAR_EPOCH_YEAR
		residency_print_cooldown = world.time + RESIDENCY_PRINT_COOLDOWN
		playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
		say("Letter of Citizenry issued, signed by [H.real_name].")
	if(href_list["setpurchasefloor"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/current_floor = SStreasury.stockpile_purchase_floor
		var/new_floor = input(usr, "Set the purchase floor (0-10000m). If the Treasury drops below this, the stockpile stops paying people for goods.", src, current_floor) as null|num
		if(isnull(new_floor))
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		new_floor = CLAMP(round(new_floor), 0, 10000)
		SStreasury.stockpile_purchase_floor = new_floor
		say("Treasury purchase floor set to [new_floor]m.")
		log_game("PURCHASE FLOOR: [key_name(usr)] set stockpile purchase floor to [new_floor]m")
	if(href_list["treasury_tgui"])
		open_treasury_tgui(usr)
		return
	if(href_list["trade_tgui"])
		open_trade_tgui(usr)
		return

	return attack_hand(usr)

/obj/structure/roguemachine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked)
		to_chat(user, span_warning("It's locked."))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	switch(current_tab)
		if(TAB_MAIN)
			contents += "<center>NERVE MASTER<BR>"
			contents += "--------------<BR>"
			contents += "<a href='?src=\ref[src];treasury_tgui=1'>\[Treasury\]</a><BR>"
			contents += "<a href='?src=\ref[src];trade_tgui=1'>\[Trade & Stockpile\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_FISCAL]'>\[Fiscal Ledger\]</a><BR>"
			contents += "<a href='?src=\ref[src];printresidency=1'>\[Print Letter of Citizenry\]</a><BR>"
			contents += "<a href='?src=\ref[src];setpurchasefloor=1'>\[Purchase Floor: [SStreasury.stockpile_purchase_floor]m\]</a><BR>"
			contents += "</center>"
		if(TAB_FISCAL)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			var/list/snap = SStreasury.compute_fiscal_snapshot()
			var/list/charters = SStreasury.compute_charter_states()
			contents += "<center><b>Fiscal Ledger, Day [GLOB.dayspassed]</b></center>"
			contents += "<hr>"

			// Balances (two-column)
			contents += "<b><font color='#e6b327'>BALANCES</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Treasury</td><td align='right'><font color='#e6b327'>[snap["discretionary"]]m</font></td>"
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
			contents += "<tr><td>Poll Levy</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_POLL_LEVY_COLLECTED]]m</font></td>"
			contents += "<td>Deposit Tax</td><td align='right'><font color='#5cb85c'>[SStreasury.total_deposit_tax]m</font></td></tr>"
			contents += "<tr><td>Contract Levy</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_CONTRACT_LEVY]]m</font></td>"
			contents += "<td>Headeater Levy</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_HEADEATER_LEVY]]m</font></td></tr>"
			contents += "<tr><td>Import Tariff</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_IMPORT_TARIFF]]m</font></td>"
			contents += "<td>Export Duty</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_EXPORT_DUTY]]m</font></td></tr>"
			contents += "<tr><td>Recovered Spoils</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_RECOVERED_SPOILS] || 0]m</font></td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table><br>"

			// Forgone Revenue (two-column, muted - what the Crown *could* have collected)
			var/exempt_contract = GLOB.azure_round_stats[STATS_EXEMPTED_CONTRACT_LEVY]
			var/exempt_headeater = GLOB.azure_round_stats[STATS_EXEMPTED_HEADEATER_LEVY]
			var/exempt_import = GLOB.azure_round_stats[STATS_EXEMPTED_IMPORT_TARIFF]
			var/exempt_export = GLOB.azure_round_stats[STATS_EXEMPTED_EXPORT_DUTY]
			var/exempt_fine = GLOB.azure_round_stats[STATS_EXEMPTED_FINE]
			var/exempt_poll = GLOB.azure_round_stats[STATS_EXEMPTED_POLL_LEVY]
			var/exempt_total = exempt_contract + exempt_headeater + exempt_import + exempt_export + exempt_fine + exempt_poll
			contents += "<b><font color='#8f7a5a'>FORGONE REVENUE (tax exempted)</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Contract Levy</td><td align='right'><font color='#8f7a5a'>[exempt_contract]m</font></td>"
			contents += "<td>Headeater Levy</td><td align='right'><font color='#8f7a5a'>[exempt_headeater]m</font></td></tr>"
			contents += "<tr><td>Import Tariff</td><td align='right'><font color='#8f7a5a'>[exempt_import]m</font></td>"
			contents += "<td>Export Duty</td><td align='right'><font color='#8f7a5a'>[exempt_export]m</font></td></tr>"
			contents += "<tr><td>Fines Waived</td><td align='right'><font color='#8f7a5a'>[exempt_fine]m</font></td>"
			contents += "<td>Poll Levy</td><td align='right'><font color='#8f7a5a'>[exempt_poll]m</font></td></tr>"
			contents += "<tr><td><b>Total Forgone</b></td><td align='right'><b><font color='#8f7a5a'>[exempt_total]m</font></b></td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table>"
			contents += "<font size='1'><i>Mammon the Crown would have collected without Charter exemptions, tax exempt stamps and rate limits.</i></font><br><br>"

			// Trade (two-column, mixed)
			contents += "<b><font color='#c0b283'>TRADE</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Stockpile Imports</td><td align='right'><font color='#d9534f'>-[SStreasury.total_import]m</font></td>"
			contents += "<td>Economic Output</td><td align='right'>[SStreasury.economic_output]m</td></tr>"
			contents += "</table><br>"

			// Expenses (two-column, red)
			contents += "<b><font color='#d9534f'>EXPENSES THIS WEEK</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>Wages Paid</td><td align='right'><font color='#d9534f'>-[GLOB.azure_round_stats[STATS_WAGES_PAID]]m</font></td>"
			contents += "<td>Treasury Transfers</td><td align='right'><font color='#d9534f'>-[GLOB.azure_round_stats[STATS_DIRECT_TREASURY_TRANSFERS]]m</font></td></tr>"
			contents += "<tr><td>Crown Imports</td><td align='right'><font color='#d9534f'>-[crown_import_spending()]m</font></td>"
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
			contents += "<td>Default Debtors</td><td align='right'><font color='#d9534f'>[snap["debtor_count"]]</font></td></tr>"
			contents += "<tr><td>Loans Outstanding</td><td align='right'>[snap["loans_outstanding"]] ([snap["loan_exposure"]]m)</td>"
			contents += "<td></td><td></td></tr>"
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
#undef TAB_FISCAL
