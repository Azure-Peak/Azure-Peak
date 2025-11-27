#define RURAL_TAX 50 // Free money. A small safety pool for lowpop mostly
#define TREASURY_TICK_AMOUNT 6 MINUTES
#define EXPORT_ANNOUNCE_THRESHOLD 100

#define TAX_CAT_NOBLE "Nobility"
#define TAX_CAT_CHURCH "Church"
#define TAX_CAT_YEOMEN "Yeomanry"
#define TAX_CAT_PEASANTS "Peasantry"

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
		TAX_CAT_YEOMEN = list("taxAmount" = 12, "fineExemption" = FALSE),
		TAX_CAT_PEASANTS = list("taxAmount" = 12, "fineExemption" = FALSE)
	)
	var/tax_value = 0.11
	var/queens_tax = 0.10
	var/treasury_value = 0
	var/mint_multiplier = 0.8 // 1x is meant to leave a margin after standard 80% collectable. Less than Bathmatron.
	var/minted = 0
	var/autoexport_percentage = 0.6 // Percentage above which stockpiles will automatically export  
	var/list/bank_accounts = list()
	var/list/noble_incomes = list()
	var/list/stockpile_datums = list()
	var/next_treasury_check = 0
	var/list/log_entries = list()
	var/economic_output = 0
	var/total_deposit_tax = 0
	var/total_rural_tax = 0
	var/total_noble_income = 0
	var/total_import = 0
	var/total_export = 0
	var/obj/structure/roguemachine/steward/steward_machine // Reference to the nerve master
	var/initial_payment_done = FALSE // Flag to track if initial round-start payment has been distributed

/datum/controller/subsystem/treasury/Initialize()
	treasury_value = rand(1000, 2000)
	force_set_round_statistic(STATS_STARTING_TREASURY, treasury_value)

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
		give_money_treasury(RURAL_TAX, "Rural Tax Collection") //Give the King's purse to the treasury
		record_round_statistic(STATS_RURAL_TAXES_COLLECTED, RURAL_TAX)
		total_rural_tax += RURAL_TAX
		auto_export()

/datum/controller/subsystem/treasury/proc/create_bank_account(name, initial_deposit)
	if(!name)
		return
	if(name in bank_accounts)
		return
	bank_accounts += name
	if(initial_deposit)
		bank_accounts[name] = initial_deposit
	else
		bank_accounts[name] = 0
	return TRUE

//increments the treasury directly (tax collection)
/datum/controller/subsystem/treasury/proc/give_money_treasury(amt, source, silent = FALSE)
	if(!amt)
		return
	treasury_value += amt
	if(silent)
		return
	if(source)
		log_to_steward("+[amt] to treasury ([source])")
	else
		log_to_steward("+[amt] to treasury")

//pays to account from treasury (payroll)
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
	var/found_account
	for(var/X in bank_accounts)
		if(X == target)
			if(amt > 0)
				bank_accounts[X] += amt  // Add funds into the player's account
			else
				// Check if the amount to be fined exceeds the player's account balance
				if(abs(amt) > bank_accounts[X])
					send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the account to complete the fine.", name = target_name)
					return FALSE  // Return early if the player has insufficient funds
				bank_accounts[X] -= abs(amt)  // Deduct the fine amount from the player's account
			found_account = TRUE
			break
	if(!found_account)
		return FALSE

	if (amt > 0)
		// Player received money
		record_round_statistic(STATS_DIRECT_TREASURY_TRANSFERS, amt)
		if(source)
			send_ooc_note("<b>MEISTER:</b> You received [amt]m. ([source])", name = target_name)
			log_to_steward("+[amt] from treasury to [target_name] ([source])")
		else
			send_ooc_note("<b>MEISTER:</b> You received [amt]m.", name = target_name)
			log_to_steward("+[amt] from treasury to [target_name]")
	else
		// Player was fined
		record_round_statistic(STATS_FINES_INCOME, amt)
		if(source)
			send_ooc_note("<b>MEISTER:</b> You were fined [amt]m. ([source])", name = target_name)
			log_to_steward("[target_name] was fined [amt] ([source])")
		else
			send_ooc_note("<b>MEISTER:</b> You were fined [amt]m.", name = target_name)
			log_to_steward("[target_name] was fined [amt]")

	return TRUE

///Deposits money into a character's bank account. Taxes are deducted from the deposit and added to the treasury.
///@param amt: The amount of money to deposit.
///@param character: The character making the deposit.
///@return TRUE if the money was successfully deposited, FALSE otherwise.
/datum/controller/subsystem/treasury/proc/generate_money_account(amt, mob/living/carbon/human/character)
	if(!amt)
		return FALSE
	if(!character)
		return FALSE
	var/taxed_amount = 0
	var/original_amt = amt
	treasury_value += amt
	if(!(character in bank_accounts))
		return FALSE

	taxed_amount = round(amt * get_tax_value_for(character))
	amt -= taxed_amount
	bank_accounts[character] += amt

	log_to_steward("+[original_amt] deposited by [character.real_name] of which taxed [taxed_amount]")

	return list(original_amt, taxed_amount)

/datum/controller/subsystem/treasury/proc/withdraw_money_account(amt, target)
	if(!amt)
		return
	var/target_name = target
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		target_name = H.real_name
	var/found_account
	for(var/X in bank_accounts)
		if(X == target)
			if(bank_accounts[X] < amt)  // Check if the withdrawal amount exceeds the player's account balance
				send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the account to complete the withdrawal.", name = target_name)
				return  // Return without processing the transaction
			if(treasury_value < amt)  // Check if the amount exceeds the treasury balance
				send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the treasury to complete the transaction.", name = target_name)
				return  // Return early if the treasury balance is insufficient
			bank_accounts[X] -= amt //The account accounts accountingly. Shame on you if you copy this, apple.
			treasury_value -= amt
			found_account = TRUE
			break
	if(!found_account)
		return
	log_to_steward("-[amt] withdrawn by [target_name]")
	return TRUE


/datum/controller/subsystem/treasury/proc/log_to_steward(log)
	log_entries += log
	return

/datum/controller/subsystem/treasury/proc/distribute_estate_incomes()
	for(var/mob/living/welfare_dependant in noble_incomes)
		var/how_much = noble_incomes[welfare_dependant]
		record_round_statistic(STATS_NOBLE_INCOME_TOTAL, how_much)
		give_money_treasury(how_much, silent = TRUE)
		total_noble_income += how_much
		if(welfare_dependant.job == "Merchant")
			give_money_account(how_much, welfare_dependant, "The Guild")
		else
			give_money_account(how_much, welfare_dependant, "Noble Estate")

/datum/controller/subsystem/treasury/proc/distribute_daily_payments()
	if(!steward_machine || !steward_machine.daily_payments || !steward_machine.daily_payments.len)
		return

	var/total_paid = 0
	for(var/job_name in steward_machine.daily_payments)
		var/payment_amount = steward_machine.daily_payments[job_name]
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_name)
				// Skip payment if wages are suspended
				if(HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
					continue
				if(give_money_account(payment_amount, H, "Daily Wage"))
					total_paid += payment_amount
					record_round_statistic(STATS_WAGES_PAID)

	if(total_paid > 0)
		log_to_steward("Daily wages distributed: [total_paid]m total")

/datum/controller/subsystem/treasury/proc/do_export(var/datum/roguestock/D, silent = FALSE)
	if((D.held_items[1] < D.importexport_amt))
		return FALSE
	var/amt = D.get_export_price()

	// You should only export from town stockpiles, not from remote. Remote is meant
	// To fulfill local economic shortfall and not to make $$ for the steward.
	if(D.held_items[1] >= D.importexport_amt)
		D.held_items[1] -= D.importexport_amt

	SStreasury.treasury_value += amt
	SStreasury.total_export += amt
	SStreasury.log_to_steward("+[amt] exported [D.name]")
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
	else if(HAS_TRAIT(person, TRAIT_RESIDENT) || (person.job in GLOB.yeoman_positions))
		return taxation_cat_settings[TAX_CAT_YEOMEN]["taxAmount"] / 100
	else if(person.job in GLOB.church_positions)
		return taxation_cat_settings[TAX_CAT_CHURCH]["taxAmount"] / 100
	else
		return taxation_cat_settings[TAX_CAT_PEASANTS]["taxAmount"] / 100

/// Checks if a given mob can be fined, based on its traits & job. TRUE if can be fined, FALSE if protected by decrees
/datum/controller/subsystem/treasury/proc/check_fine_exemption(mob/living/person)
	if(HAS_TRAIT(person, TRAIT_NOBLE))
		return taxation_cat_settings[TAX_CAT_NOBLE]["fineExemption"]
	else if(HAS_TRAIT(person, TRAIT_RESIDENT) || (person.job in GLOB.yeoman_positions))
		return taxation_cat_settings[TAX_CAT_YEOMEN]["fineExemption"]
	else if(person.job in GLOB.church_positions)
		return taxation_cat_settings[TAX_CAT_CHURCH]["fineExemption"]
	else
		return taxation_cat_settings[TAX_CAT_PEASANTS]["fineExemption"]

/// Checks if there is a valid amount in the treasury, if so, withdraw that amount and log it
/// Currently only used by Chimeric heartbeasts
/datum/controller/subsystem/treasury/proc/withdraw_money_treasury(amt, target)
	if(!amt || treasury_value < amt)
		return FALSE // Not enough funds

	treasury_value -= amt
	log_to_steward("-[amt] withdrawn from treasury by [target]")
	return TRUE

#undef RURAL_TAX
#undef TREASURY_TICK_AMOUNT
#undef EXPORT_ANNOUNCE_THRESHOLD
#undef TAX_CAT_NOBLE
#undef TAX_CAT_CHURCH
#undef TAX_CAT_YEOMEN
#undef TAX_CAT_PEASANTS
