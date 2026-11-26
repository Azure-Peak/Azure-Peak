/datum/steward_treasury_panel
	var/obj/structure/roguemachine/steward/host
	var/list/job_factions

/datum/steward_treasury_panel/New(obj/structure/roguemachine/steward/new_host)
	host = new_host

/datum/steward_treasury_panel/Destroy()
	host = null
	return ..()

/datum/steward_treasury_panel/ui_host(mob/user)
	return host

/datum/steward_treasury_panel/ui_state(mob/user)
	return GLOB.human_adjacent_state

/datum/steward_treasury_panel/ui_status(mob/user, datum/ui_state/state)
	if(QDELETED(host) || host.locked)
		return UI_CLOSE
	return ..()

/datum/steward_treasury_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StewardTreasury")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/steward_treasury_panel/ui_static_data(mob/user)
	var/list/data = list()
	data["can_fiscal"] = has_fiscal_authority(user) ? TRUE : FALSE
	var/list/factions = job_factions()
	var/list/payroll = list()
	for(var/job_name in factions)
		if(host.daily_payments[job_name])
			payroll += list(payroll_row(job_name, factions[job_name]))
	for(var/job_name in host.daily_payments)
		if(!factions[job_name])
			payroll += list(payroll_row(job_name, null))
	data["payroll"] = payroll
	return data

/datum/steward_treasury_panel/proc/payroll_row(job_name, faction)
	return list(
		"job" = job_name,
		"wage" = host.daily_payments[job_name],
		"floor" = SStreasury.get_wage_floor(job_name),
		"faction" = faction,
	)

/datum/steward_treasury_panel/proc/job_factions()
	if(job_factions)
		return job_factions
	job_factions = list()
	var/list/groups = host.payable_job_groups()
	for(var/group in groups)
		for(var/job_name in groups[group])
			if(!job_factions[job_name])
				job_factions[job_name] = group
	return job_factions

/datum/steward_treasury_panel/ui_data(mob/user)
	var/list/data = list()
	data["treasury"] = SStreasury.discretionary_fund?.balance || 0
	var/list/headcount = list()
	var/list/accounts = list()
	var/list/debts = list()
	for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
		var/datum/fund/account = SStreasury.bank_accounts[A]
		var/poll_owed = SStreasury.poll_levy_owed[A] || 0
		var/debtor = HAS_TRAIT(A, TRAIT_DEBTOR) ? TRUE : FALSE
		var/arrears = (poll_owed > 0 || HAS_TRAIT(A, TRAIT_ARREARS)) ? TRUE : FALSE
		var/suspended = account?.wages_suspended ? TRUE : FALSE
		if(!suspended && host.daily_payments[A.job])
			headcount[A.job] = (headcount[A.job] || 0) + 1
		var/list/row = list(
			"ref" = REF(A),
			"name" = A.real_name,
			"job" = host.job_filter(A.advjob, A.job, TRUE),
			"balance" = SStreasury.get_balance(A),
			"max_fine" = SStreasury.get_max_fine_for(A),
			"suspended" = suspended,
			"debtor" = debtor,
			"arrears" = arrears,
			"poll_owed" = poll_owed,
		)
		accounts += list(row)
		if(debtor || arrears)
			debts += list(row)
	data["accounts"] = accounts
	data["debts"] = debts
	data["employed"] = headcount
	var/list/loans = list()
	for(var/datum/loan/L in SStreasury.loans)
		if(L.source_fund != SStreasury.discretionary_fund)
			continue
		loans += list(list(
			"text" = L.format(),
			"defaulted" = L.defaulted ? TRUE : FALSE,
		))
	data["loans"] = loans
	return data

/datum/steward_treasury_panel/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!still_usable(user))
		return
	switch(action)
		if("open_window")
			host.open_steward_window(user, params["window"])
		if("give_money")
			give_money(user, locate(params["ref"]) in SStreasury.bank_accounts)
		if("fine")
			fine(user, locate(params["ref"]) in SStreasury.bank_accounts)
		if("toggle_wages")
			toggle_wages(user, locate(params["ref"]) in SStreasury.bank_accounts)
		if("pay_by_class")
			pay_by_class(user)
		if("add_daily_pay")
			add_daily_pay(user)
		if("add_group_daily_pay")
			add_group_daily_pay(user)
		if("set_daily_pay")
			var/job = params["job"]
			var/amount = text2num("[params["amount"]]")
			if(!(job in host.daily_payments) || isnull(amount))
				return
			apply_daily_pay(job, amount)
		if("remove_daily_pay")
			remove_daily_pay(params["job"])
		if("clear_defaulter")
			clear_defaulter(user, locate(params["ref"]) in SStreasury.bank_accounts)
		if("clear_poll_levy")
			clear_poll_levy(user, locate(params["ref"]) in SStreasury.bank_accounts)
	return TRUE

/datum/steward_treasury_panel/proc/still_usable(mob/user)
	return !QDELETED(host) && !host.locked && user.canUseTopic(host, BE_CLOSE)

/datum/steward_treasury_panel/proc/refuse(message)
	host.say(message)
	playsound(host, 'sound/misc/machineno.ogg', 100, FALSE, -1)

/datum/steward_treasury_panel/proc/give_money(mob/user, mob/living/carbon/human/A)
	if(!istype(A))
		return
	var/amount = tgui_input_number(user, "How much to give [A.real_name]?", "Give Money", 0, INFINITY, 0, round_value = FALSE)
	if(isnull(amount) || !still_usable(user))
		return
	amount = mammon_round(amount)
	if(amount < 1)
		return
	SStreasury.give_money_account(amount, A, "NERVE MASTER")

/datum/steward_treasury_panel/proc/fine(mob/user, mob/living/carbon/human/A)
	if(!istype(A))
		return
	if(!has_fiscal_authority(user))
		refuse("Only Crown officials can fine people.")
		return
	if(A == user)
		refuse("You can't fine yourself.")
		return
	var/max_fine = SStreasury.get_max_fine_for(A)
	if(max_fine <= 0)
		refuse("You can't fine [A.real_name]. They are exempt or their account is empty.")
		return
	var/amount = tgui_input_number(user, "How much to fine [A.real_name]? (Maximum [format_mammon(max_fine)]m)", "Fine", max_fine, max_fine, 0, round_value = FALSE)
	if(isnull(amount) || !still_usable(user))
		return
	amount = min(mammon_round(amount), SStreasury.get_max_fine_for(A))
	if(amount < 1)
		return
	SStreasury.give_money_account(-amount, A, "NERVE MASTER")

/datum/steward_treasury_panel/proc/toggle_wages(mob/user, mob/living/carbon/human/A)
	if(!istype(A))
		return
	if(!has_fiscal_authority(user))
		refuse("Only Crown officials can suspend wages.")
		return
	var/datum/fund/account = SStreasury.bank_accounts[A]
	if(!account)
		return
	var/has_wage = host.daily_payments[A.job] > 0
	account.wages_suspended = !account.wages_suspended
	if(account.wages_suspended)
		host.say("[A.real_name]'s wages have been suspended.")
		if(has_wage)
			to_chat(A, span_danger("My wages have been suspended by the Stewardry!"))
	else
		host.say("[A.real_name]'s wages have been reinstated.")
		if(has_wage)
			to_chat(A, span_notice("My wages have been reinstated by the Stewardry."))

/datum/steward_treasury_panel/proc/pay_by_class(mob/user)
	var/job_to_pay = tgui_input_list(user, "Select a job", "Pay by Class", host.payable_jobs())
	if(!job_to_pay || !still_usable(user))
		return
	var/amount = tgui_input_number(user, "How much to pay each [job_to_pay]?", "Pay by Class", 0, INFINITY, 0, round_value = FALSE)
	if(isnull(amount) || !still_usable(user))
		return
	amount = mammon_round(amount)
	if(amount < 1)
		return
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.job == job_to_pay && SStreasury.give_money_account(amount, H, "NERVE MASTER", is_salary = TRUE))
			record_round_statistic(STATS_WAGES_PAID, amount)

/datum/steward_treasury_panel/proc/add_daily_pay(mob/user)
	var/job_to_pay = tgui_input_list(user, "Select a job", "Daily Payment", host.payable_jobs())
	if(!job_to_pay || !still_usable(user))
		return
	var/wage_floor = SStreasury.get_wage_floor(job_to_pay)
	var/prompt = wage_floor > 0 ? "Set the daily payment for [job_to_pay]. A Charter requires at least [wage_floor]m." : "Set the daily payment for [job_to_pay] (0 to remove)."
	var/amount = tgui_input_number(user, prompt, "Daily Payment", host.daily_payments[job_to_pay] || wage_floor, 999, 0, round_value = FALSE)
	if(isnull(amount) || !still_usable(user))
		return
	apply_daily_pay(job_to_pay, amount)

/datum/steward_treasury_panel/proc/add_group_daily_pay(mob/user)
	var/list/groups = host.payable_job_groups()
	var/group = tgui_input_list(user, "Select a faction", "Daily Payment", groups)
	if(!group || !still_usable(user))
		return
	var/amount = tgui_input_number(user, "Set the daily payment for every [group] job (0 to remove).", "Daily Payment", 0, 999, 0, round_value = FALSE)
	if(isnull(amount) || !still_usable(user))
		return
	var/requested = CLAMP(mammon_round(amount), 0, 999)
	var/list/raised = list()
	for(var/job in groups[group])
		if(store_daily_pay(job, requested) > requested)
			raised += job
	if(requested == 0)
		host.say("Daily payments for [group] removed.")
	else
		host.say("Daily payment for every [group] job set to [requested]m.")
	if(length(raised))
		host.say("A Charter requires more for [english_list(raised)]. Their payment has been set to the Charter minimum.")
	update_static_data_for_all_viewers()

/datum/steward_treasury_panel/proc/apply_daily_pay(job_to_pay, amount)
	var/requested = CLAMP(mammon_round(amount), 0, 999)
	var/stored = store_daily_pay(job_to_pay, requested)
	if(stored > requested)
		host.say("A Charter requires at least [stored]m for [job_to_pay]. Payment set to [stored]m.")
	if(stored == 0)
		host.say("Daily payment for [job_to_pay] removed.")
	else
		host.say("Daily payment for [job_to_pay] set to [stored]m.")
	update_static_data_for_all_viewers()

/datum/steward_treasury_panel/proc/store_daily_pay(job_to_pay, amount)
	var/wage_floor = SStreasury.get_wage_floor(job_to_pay)
	if(wage_floor > 0 && amount < wage_floor)
		amount = wage_floor
	if(amount == 0)
		host.daily_payments -= job_to_pay
	else
		host.daily_payments[job_to_pay] = amount
	return amount

/datum/steward_treasury_panel/proc/remove_daily_pay(job_to_remove)
	if(!(job_to_remove in host.daily_payments))
		return
	var/removal_floor = SStreasury.get_wage_floor(job_to_remove)
	if(removal_floor > 0)
		host.daily_payments[job_to_remove] = removal_floor
		host.say("A Charter requires at least [removal_floor]m for [job_to_remove], so you can't remove it. Payment set to [removal_floor]m.")
	else
		host.daily_payments -= job_to_remove
		host.say("Daily payment for [job_to_remove] removed.")
	update_static_data_for_all_viewers()

/datum/steward_treasury_panel/proc/clear_defaulter(mob/user, mob/living/carbon/human/target)
	if(!istype(target) || !HAS_TRAIT(target, TRAIT_DEBTOR))
		return
	if(!has_fiscal_authority(user))
		refuse("Only Crown officials can forgive debts.")
		return
	if(tgui_alert(user, "Forgive [target.real_name]'s Crown loan and poll levy arrears, and clear their defaulter mark?", "Clear Defaulter Mark", list("Forgive", "Cancel")) != "Forgive")
		return
	if(!still_usable(user) || !HAS_TRAIT(target, TRAIT_DEBTOR))
		return
	REMOVE_TRAIT(target, TRAIT_DEBTOR, TRAIT_GENERIC)
	var/datum/loan/forgiven = SStreasury.get_loan_for(target)
	var/loan_amt = forgiven ? forgiven.get_remaining_due() : 0
	if(forgiven)
		SStreasury.write_off_loan(forgiven, "Debt forgiven by the Steward")
		SStreasury.loans -= forgiven
		qdel(forgiven)
	SStreasury.clear_poll_levy_debt(target)
	host.say("[target.real_name]'s debtor mark has been cleared and all Crown loans have been forgiven.")
	log_game("DEBT FORGIVEN: [key_name(user)] cleared debtor mark on [key_name(target)][loan_amt ? " (wrote off [loan_amt]m loan)" : ""]")
	to_chat(target, span_notice("The Stewardry has cleared the defaulter mark from my name. My Crown debts are forgiven."))

/datum/steward_treasury_panel/proc/clear_poll_levy(mob/user, mob/living/carbon/human/target)
	if(!istype(target))
		return
	if(!SStreasury.poll_levy_owed[target] && !HAS_TRAIT(target, TRAIT_ARREARS))
		return
	if(!has_fiscal_authority(user))
		refuse("Only Crown officials can clear poll levy arrears.")
		return
	if(tgui_alert(user, "Clear [target.real_name]'s poll levy arrears?", "Clear Poll Levy", list("Clear", "Cancel")) != "Clear")
		return
	if(!still_usable(user))
		return
	var/was_owed = SStreasury.poll_levy_owed[target] || 0
	SStreasury.clear_poll_levy_debt(target)
	host.say("[target.real_name]'s poll levy arrears have been cleared.")
	log_game("POLL LEVY CLEARED: [key_name(user)] cleared [was_owed]m poll levy arrears on [key_name(target)]")
	to_chat(target, span_notice("The Stewardry has cleared my poll levy arrears."))

/obj/structure/roguemachine/steward/proc/open_treasury_tgui(mob/user)
	if(locked)
		to_chat(user, span_warning("It's locked."))
		return
	if(!treasury_panel)
		treasury_panel = new(src)
	treasury_panel.ui_interact(user)

/obj/structure/roguemachine/steward/proc/payable_job_groups()
	return list(
		"Nobility" = GLOB.noble_positions,
		"Retinue" = GLOB.retinue_positions,
		"Garrison" = GLOB.garrison_positions,
		"Court" = GLOB.courtier_positions,
		"Church" = GLOB.church_positions,
		"Burghers" = GLOB.burgher_positions,
		"Trading Company" = GLOB.atc_positions,
		"Peasants" = GLOB.peasant_positions,
		"Sidefolk" = GLOB.sidefolk_positions,
		"Inquisition" = GLOB.inquisition_positions,
	)

/obj/structure/roguemachine/steward/proc/payable_jobs()
	var/list/jobs = list()
	var/list/groups = payable_job_groups()
	for(var/group in groups)
		jobs += groups[group]
	return jobs
