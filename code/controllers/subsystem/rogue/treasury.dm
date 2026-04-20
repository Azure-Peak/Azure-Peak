// SEE treasury.dm in __DEFINES for definitions

/proc/send_ooc_note(msg, name, job)
	var/list/names_to = list()
	if(name)
		names_to += name
	if(job)
		var/list/L = list()
		if(islist(job))
			L = job
		else
			L += job
		for(var/J in L)
			for(var/mob/living/carbon/human/X in GLOB.human_list)
				if(X.job == J)
					names_to |= X.real_name
	if(names_to.len)
		for(var/mob/living/carbon/human/X in GLOB.human_list)
			if(X.real_name in names_to)
				if(!X.stat)
					to_chat(X, span_biginfo("[msg]"))

SUBSYSTEM_DEF(treasury)
	name = "treasury"
	wait = 1
	priority = FIRE_PRIORITY_WATER_LEVEL
	/// Assoc list of assoc lists for taxation settings. [category] = list("tax_percent" = num, "fine_exemption" = TRUE/FALSE)
	var/list/taxation_cat_settings = list(
		TAX_CAT_NOBLE = list("taxAmount" = 0, "fineExemption" = TRUE),
		TAX_CAT_CHURCH = list("taxAmount" = 6, "fineExemption" = TRUE),
		TAX_CAT_BURGHERS = list("taxAmount" = 12, "fineExemption" = FALSE),
		TAX_CAT_PEASANTS = list("taxAmount" = 12, "fineExemption" = FALSE)
	)
	var/tax_value = 0.11
	var/queens_tax = 0.10
	var/mint_multiplier = 0.8 // 1x is meant to leave a margin after standard 80% collectable. Less than Bathmatron.
	var/minted = 0
	var/autoexport_percentage = 0.6 // Percentage above which stockpiles will automatically export  
	var/list/bank_accounts = list()
	var/datum/fund/discretionary_fund
	var/list/ledger = list()
	var/list/noble_incomes = list()
	var/list/stockpile_datums = list()
	var/next_treasury_check = 0
	var/economic_output = 0
	var/total_deposit_tax = 0
	var/total_rural_tax = 0
	var/total_noble_income = 0
	var/total_import = 0
	var/total_export = 0
	var/obj/structure/roguemachine/steward/steward_machine // Reference to the nerve master
	var/initial_payment_done = FALSE // Flag to track if initial round-start payment has been distributed

/datum/controller/subsystem/treasury/Initialize()
	discretionary_fund = new("Crown Discretionary", null, rand(1000, 2000), CURRENCY_MAMMON)
	force_set_round_statistic(STATS_STARTING_TREASURY, discretionary_fund.balance)

	for(var/path in subtypesof(/datum/roguestock/bounty))
		var/datum/D = new path
		stockpile_datums += D
	for(var/path in subtypesof(/datum/roguestock/stockpile))
		var/datum/D = new path
		stockpile_datums += D
	for(var/path in subtypesof(/datum/roguestock/import))
		var/datum/D = new path
		stockpile_datums += D
	return ..()

/datum/controller/subsystem/treasury/fire(resumed = 0)
	if(world.time > next_treasury_check)
		next_treasury_check = world.time + TREASURY_TICK_AMOUNT
		if(SSticker.current_state == GAME_STATE_PLAYING)
			if(!initial_payment_done) // Distribute initial payments once at round start
				initial_payment_done = TRUE
				distribute_daily_payments()
			for(var/datum/roguestock/X in stockpile_datums)
				if(!X.stable_price && !X.mint_item)
					if(X.demand < initial(X.demand))
						X.demand += rand(5,15)
					if(X.demand > initial(X.demand))
						X.demand -= rand(5,15)
			for(var/datum/roguestock/stockpile/A in stockpile_datums) //Generate some remote resources
				A.held_items[2] += A.passive_generation
				A.held_items[2] = min(A.held_items[2],10) //To a maximum of 10
		var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/vault]
		for(var/obj/structure/roguemachine/vaultbank/VB in A)
			if(istype(VB))
				VB.update_icon()
		mint(discretionary_fund, RURAL_TAX, "Rural Tax Collection") //Give the King's purse to the treasury
		record_round_statistic(STATS_RURAL_TAXES_COLLECTED, RURAL_TAX)
		total_rural_tax += RURAL_TAX
	
		auto_export()

/datum/controller/subsystem/treasury/proc/get_account(target)
	if(!target)
		return null
	return bank_accounts[target]

/datum/controller/subsystem/treasury/proc/get_balance(target)
	var/datum/fund/account = get_account(target)
	return account ? account.balance : 0

/datum/controller/subsystem/treasury/proc/has_account(target)
	return !isnull(bank_accounts[target])

/datum/controller/subsystem/treasury/proc/rename_account(mob/living/owner, new_name)
	var/datum/fund/account = get_account(owner)
	if(!account)
		return
	account.name = new_name

/datum/controller/subsystem/treasury/proc/is_name_taken(candidate_name)
	if(!candidate_name)
		return FALSE
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(account?.name == candidate_name)
			return TRUE
	return FALSE

/datum/controller/subsystem/treasury/proc/create_bank_account(mob/living/owner, initial_deposit)
	if(!owner)
		return
	if(has_account(owner))
		return
	if(is_name_taken(owner.real_name))
		return
	var/datum/fund/account = new(owner.real_name, owner, initial_deposit || 0, CURRENCY_MAMMON)
	bank_accounts[owner] = account
	return TRUE

/datum/controller/subsystem/treasury/proc/give_money_account(amt, target, source)
	if(!amt)
		return
	if(!target)
		return
	amt = min(amt, 10000) //No exponentials, please!
	var/target_name = target
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		target_name = H.real_name
	var/datum/fund/account = get_account(target)
	if(!account)
		return FALSE

	if(amt > 0)
		if(!transfer(discretionary_fund, account, amt, source))
			send_ooc_note("<b>MEISTER:</b> The Crown is insolvent. No payment this day.", name = target_name)
			return FALSE
		record_round_statistic(STATS_DIRECT_TREASURY_TRANSFERS, amt)
		send_ooc_note(source ? "<b>MEISTER:</b> You received [amt]m. ([source])" : "<b>MEISTER:</b> You received [amt]m.", name = target_name)
	else
		var/fine_amt = abs(amt)
		if(!transfer(account, discretionary_fund, fine_amt, "[TAX_CATEGORY_FINE] ([source])"))
			send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the account to complete the fine.", name = target_name)
			return FALSE
		record_round_statistic(STATS_FINES_INCOME, amt)
		send_ooc_note(source ? "<b>MEISTER:</b> You were fined [fine_amt]m. ([source])" : "<b>MEISTER:</b> You were fined [fine_amt]m.", name = target_name)

	return TRUE

/datum/controller/subsystem/treasury/proc/generate_money_account(amt, mob/living/carbon/human/character)
	if(!amt)
		return FALSE
	if(!character)
		return FALSE
	var/datum/fund/account = get_account(character)
	if(!account)
		return FALSE
	var/original_amt = amt
	mint(account, amt, "[TAX_CATEGORY_DEPOSIT] by [character.real_name]")
	var/taxed_amount = apply_tax(account, amt, TAX_CATEGORY_DEPOSIT, character.real_name)
	return list(original_amt, taxed_amount)

/datum/controller/subsystem/treasury/proc/withdraw_money_account(amt, target)
	if(!amt)
		return
	var/target_name = target
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		target_name = H.real_name
	var/datum/fund/account = get_account(target)
	if(!account)
		return
	if(account.balance < amt)
		send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the account to complete the withdrawal.", name = target_name)
		return
	if(!burn(account, amt, "Meister withdraw by [target_name]"))
		return
	return TRUE

/datum/controller/subsystem/treasury/proc/distribute_estate_incomes()
	for(var/mob/living/welfare_dependant in noble_incomes)
		var/how_much = noble_incomes[welfare_dependant]
		var/datum/fund/account = get_account(welfare_dependant)
		if(!account)
			continue
		record_round_statistic(STATS_NOBLE_INCOME_TOTAL, how_much)
		total_noble_income += how_much
		var/source = welfare_dependant.job == "Merchant" ? "The Guild" : "Noble Estate"
		mint(account, how_much, source)
		send_ooc_note("<b>MEISTER:</b> You received [how_much]m. ([source])", name = welfare_dependant.real_name)

/datum/controller/subsystem/treasury/proc/distribute_daily_payments()
	if(!steward_machine || !steward_machine.daily_payments || !steward_machine.daily_payments.len)
		return

	for(var/job_name in steward_machine.daily_payments)
		var/payment_amount = steward_machine.daily_payments[job_name]
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_name)
				if(HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
					continue
				if(give_money_account(payment_amount, H, "Daily Wage"))
					record_round_statistic(STATS_WAGES_PAID)

/datum/controller/subsystem/treasury/proc/do_export(var/datum/roguestock/D, silent = FALSE)
	if((D.held_items[1] < D.importexport_amt))
		return FALSE
	var/amt = D.get_export_price()

	// You should only export from town stockpiles, not from remote. Remote is meant
	// To fulfill local economic shortfall and not to make $$ for the steward.
	if(D.held_items[1] >= D.importexport_amt)
		D.held_items[1] -= D.importexport_amt

	mint(discretionary_fund, amt, "exported [D.name]")
	SStreasury.total_export += amt
	record_round_statistic(STATS_STOCKPILE_EXPORTS_VALUE, amt)
	if(!silent && amt >= EXPORT_ANNOUNCE_THRESHOLD) //Only announce big spending.
		scom_announce("Azure Peak exports [D.name] for [amt] mammon.")
	D.lower_demand()
	return amt

/datum/controller/subsystem/treasury/proc/auto_export()
	var/total_value_exported = 0 
	for(var/datum/roguestock/D in stockpile_datums)
		if(!D.importexport_amt)
			continue
		if((autoexport_percentage * D.stockpile_limit) >= D.held_items[1])
			continue // We only auto export if above the auto export percentage.
		// We don't want to auto export if it is not profitable at all.
		if(D.get_export_price() <= (D.payout_price * D.importexport_amt))
			continue
		if(D.held_items[1] >= D.importexport_amt)
			var/exported = do_export(D, TRUE)
			total_value_exported += exported
	if(total_value_exported >= EXPORT_ANNOUNCE_THRESHOLD)
		scom_announce("Azure Peak exports [total_value_exported] mammons of surplus goods.")

/datum/controller/subsystem/treasury/proc/remove_person(mob/living/person)
	noble_incomes -= person
	bank_accounts -= person
	return TRUE

/// Boilerplate that sets taxes and announces it to the world. Only changed taxes are announced. 
/datum/controller/subsystem/treasury/proc/set_taxes(list/categories, good_announcement_text, bad_announcement_text)
	var/final_text = null
	var/bad_guy = FALSE // If any fine exemptions are removed or tax is increased, uses an alternative message
	for(var/category in categories)
		if(taxation_cat_settings[category]["taxAmount"] != categories[category]["taxAmount"])
			if(categories[category]["taxAmount"] > taxation_cat_settings[category]["taxAmount"])
				bad_guy = TRUE
			final_text += "<br>[category] tax: [categories[category]["taxAmount"]]%. "
		if(taxation_cat_settings[category]["fineExemption"] != categories[category]["fineExemption"])
			if(taxation_cat_settings[category]["fineExemption"] && !categories[category]["fineExemption"])
				bad_guy = TRUE
			final_text += "[category] is [categories[category]["fineExemption"] ? "now exempt from fines" : "no longer exempt from fines"]."
		taxation_cat_settings[category] = categories[category]

	if(isnull(final_text))
		return
	
	var/final_announcement_text = good_announcement_text
	if(bad_guy)
		final_announcement_text = bad_announcement_text

	priority_announce(final_text, final_announcement_text, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)

/// Returns correct tax (0, 100) for a living mob based on its traits & job
/datum/controller/subsystem/treasury/proc/get_tax_value_for(mob/living/person)
	if(HAS_TRAIT(person, TRAIT_NOBLE))
		return taxation_cat_settings[TAX_CAT_NOBLE]["taxAmount"] / 100
	else if(HAS_TRAIT(person, TRAIT_RESIDENT) || (person.job in GLOB.burgher_positions))
		return taxation_cat_settings[TAX_CAT_BURGHERS]["taxAmount"] / 100
	else if(person.job in GLOB.church_positions)
		return taxation_cat_settings[TAX_CAT_CHURCH]["taxAmount"] / 100
	else
		return taxation_cat_settings[TAX_CAT_PEASANTS]["taxAmount"] / 100

/// Checks if a given mob can be fined, based on its traits & job. TRUE if can be fined, FALSE if protected by decrees
/datum/controller/subsystem/treasury/proc/check_fine_exemption(mob/living/person)
	if(HAS_TRAIT(person, TRAIT_NOBLE))
		return taxation_cat_settings[TAX_CAT_NOBLE]["fineExemption"]
	else if(HAS_TRAIT(person, TRAIT_RESIDENT) || (person.job in GLOB.burgher_positions))
		return taxation_cat_settings[TAX_CAT_BURGHERS]["fineExemption"]
	else if(person.job in GLOB.church_positions)
		return taxation_cat_settings[TAX_CAT_CHURCH]["fineExemption"]
	else
		return taxation_cat_settings[TAX_CAT_PEASANTS]["fineExemption"]

/// Checks if there is a valid amount in the treasury, if so, withdraw that amount and log it
/// Currently only used by Chimeric heartbeasts
/datum/controller/subsystem/treasury/proc/withdraw_money_treasury(amt, target)
	if(!amt)
		return FALSE
	return burn(discretionary_fund, amt, "withdrawn by [target]")
	