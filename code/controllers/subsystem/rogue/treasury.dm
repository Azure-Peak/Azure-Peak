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
	var/list/tax_rates = list(
		TAX_CATEGORY_CONTRACT_LEVY = 0.20,
		TAX_CATEGORY_HEADEATER_LEVY = 0.20,
		TAX_CATEGORY_IMPORT_TARIFF = 0.20,
		TAX_CATEGORY_EXPORT_DUTY = 0.20,
		TAX_CATEGORY_FINE = 1.0,
	)
	var/trade_spread = 0.10 // Merchant-guild spread between stockpile import and export prices. Not a ledger tax.
	var/mint_multiplier = 0.8 // 1x is meant to leave a margin after standard 80% collectable. Less than Bathmatron.
	var/minted = 0
	var/autoexport_percentage = 0.6 // Percentage above which stockpiles will automatically export  
	var/list/bank_accounts = list()
	var/datum/fund/discretionary_fund
	var/datum/fund/burgher_bond_fund
	var/list/ledger = list()
	var/list/noble_incomes = list()
	var/list/decrees = list()
	var/list/stockpile_datums = list()
	/// Day number on which the realm's 1-per-day decree revocation slot was last consumed.
	var/decree_revoke_used_day = -1
	/// Day number on which the realm's 1-per-day decree restoration slot was last consumed.
	var/decree_restore_used_day = -1
	var/next_treasury_check = 0
	var/economic_output = 0
	var/total_deposit_tax = 0
	var/total_rural_tax = 0
	var/total_noble_income = 0
	var/total_import = 0
	var/total_export = 0
	var/obj/structure/roguemachine/steward/steward_machine // Reference to the nerve master
	var/initial_payment_done = FALSE // Flag to track if initial round-start payment has been distributed
	/// List of /datum/loan currently outstanding against debtors.
	var/list/loans = list()
	/// Steward-settable default simple-interest rate per day (0.25 == 25%).
	var/loan_interest_rate = 0.25
	/// GLOB.dayspassed value above which no new loans may be issued.
	var/loan_max_issuance_day = 5

/datum/controller/subsystem/treasury/Initialize()
	discretionary_fund = new("Crown Discretionary", null, rand(1000, 2000), CURRENCY_MAMMON)
	burgher_bond_fund = new("Burgher Bond", null, BURGHER_BOND_BASE_REFILL, CURRENCY_BURGHER_AUTHORITY)
	force_set_round_statistic(STATS_STARTING_TREASURY, discretionary_fund.balance)
	init_decrees()

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
	var/datum/fund/account = new(owner.real_name, owner, 0, CURRENCY_MAMMON)
	bank_accounts[owner] = account
	if(initial_deposit > 0)
		mint(account, initial_deposit, "Initial endowment")
	return TRUE

/// Maximum mammon that can be fined from the target in a single action, accounting for
/// decree exemptions and rate caps. Returns 0 if the target cannot be fined at all.
/datum/controller/subsystem/treasury/proc/get_max_fine_for(mob/living/target)
	if(!target)
		return 0
	if(is_tax_exempt(target, TAX_CATEGORY_FINE))
		return 0
	var/balance = get_balance(target)
	if(balance <= 0)
		return 0
	var/cap_rate = get_rate_cap(target, TAX_CATEGORY_FINE)
	return FLOOR(balance * cap_rate, 1)

/// Awards +1 triumph to every player with >= SAVINGS_GOAL_THRESHOLD in their account.
/// Records roundstat tally. Called once at roundend.
/datum/controller/subsystem/treasury/proc/award_savings_goals()
	var/threshold = SAVINGS_GOAL_THRESHOLD
	var/met = 0
	var/missed = 0
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(!account || account.currency != CURRENCY_MAMMON)
			continue
		var/mob/living/owner = account.get_owner()
		if(!owner || !owner.mind)
			continue
		if(account.balance >= threshold)
			owner.mind.adjust_triumphs(1)
			met++
		else
			missed++
	record_round_statistic(STATS_SAVINGS_GOAL_MET, met)
	record_round_statistic(STATS_SAVINGS_GOAL_MISSED, missed)
	return list("met" = met, "missed" = missed)

/// Off-map personal wealth granted at roundstart. Mints into the account directly;
/datum/controller/subsystem/treasury/proc/grant_savings(amt, mob/living/target)
	if(!amt || !target)
		return FALSE
	var/datum/fund/account = get_account(target)
	if(!account)
		return FALSE
	return mint(account, amt, "Savings")

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
			return FALSE
		record_round_statistic(STATS_DIRECT_TREASURY_TRANSFERS, amt)
		send_ooc_note(source ? "<b>MEISTER:</b> You received [amt]m. ([source])" : "<b>MEISTER:</b> You received [amt]m.", name = target_name)
	else
		var/mob/living/fine_owner = istype(target, /mob/living) ? target : null
		if(fine_owner && is_tax_exempt(fine_owner, TAX_CATEGORY_FINE))
			send_ooc_note("<b>MEISTER:</b> Error: By decree, they cannot be fined.", name = target_name)
			return FALSE
		var/fine_amt = abs(amt)
		if(fine_owner)
			var/cap_rate = get_rate_cap(fine_owner, TAX_CATEGORY_FINE)
			var/max_fine = FLOOR(account.balance * cap_rate, 1)
			if(fine_amt > max_fine)
				fine_amt = max_fine
		if(fine_amt <= 0)
			send_ooc_note("<b>MEISTER:</b> Error: No fineable amount remains.", name = target_name)
			return FALSE
		if(!transfer(account, discretionary_fund, fine_amt, "[TAX_CATEGORY_FINE] ([source])"))
			send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the account to complete the fine.", name = target_name)
			return FALSE
		record_round_statistic(STATS_FINES_INCOME, -fine_amt)
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
	mint(account, amt, "Meister deposit by [character.real_name]")
	return list(amt, 0)

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

	// Pre-check: sum projected payroll, ensure the Crown can cover it all. If not, pay nothing.
	var/projected_total = 0
	for(var/job_name in steward_machine.daily_payments)
		var/payment_amount = steward_machine.daily_payments[job_name]
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_name && !HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
				projected_total += payment_amount
	if(discretionary_fund.balance < projected_total)
		priority_announce("The Crown is Insolvent! Woe betides this land.", "THE CROWN IS INSOLVENT", 'sound/misc/royal_decree2.ogg', "Captain")
		return

	for(var/job_name in steward_machine.daily_payments)
		var/payment_amount = steward_machine.daily_payments[job_name]
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_name)
				if(HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
					continue
				if(give_money_account(payment_amount, H, "Daily Wage"))
					record_round_statistic(STATS_WAGES_PAID)

/// Daily replenishment of the Burgher Bond. Gated on the Golden Bull of Kingsfield - when charter is active the burghers pledge their authority to the common defense.
/// If the charter is suspended, the refill skips. Surplus above the clawback ceiling is cleared.
/// Refill scales with active player count - the realm's defense needs grow with the populace.
/datum/controller/subsystem/treasury/proc/tick_burgher_bond()
	if(!burgher_bond_fund)
		return
	var/datum/decree/golden = get_decree(DECREE_GOLDEN_BULL)
	if(!golden?.active)
		return
	var/refill = BURGHER_BOND_BASE_REFILL + (get_active_player_count() * BURGHER_BOND_PER_PLAYER)
	var/ceiling = refill * BURGHER_BOND_CLAWBACK_MULTIPLIER
	if(burgher_bond_fund.balance > ceiling)
		var/surplus = burgher_bond_fund.balance - ceiling
		burn(burgher_bond_fund, surplus, "Burgher Bond clawback")
	mint(burgher_bond_fund, refill, "Burgher Bond replenishment")

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

/// Apply Steward/Lord-submitted category rate changes. Announces only changed rates.
/datum/controller/subsystem/treasury/proc/apply_rate_adjustments(list/adjustments, good_announcement_text, bad_announcement_text)
	var/list/lines = list()
	var/bad_guy = FALSE
	for(var/entry in adjustments)
		var/category = entry["category"]
		if(!(category in tax_rates))
			continue
		if(category == TAX_CATEGORY_FINE)
			continue
		var/new_pct = CLAMP(entry["rate"], 0, 100)
		var/new_rate = new_pct / 100
		var/old_rate = tax_rates[category]
		if(new_rate == old_rate)
			continue
		var/old_pct = round(old_rate * 100)
		if(new_rate > old_rate)
			bad_guy = TRUE
		tax_rates[category] = new_rate
		var/pretty = get_tax_category_pretty_name(category)
		var/verb = new_rate > old_rate ? "raised" : "reduced"
		lines += "[pretty] [verb] from [old_pct]% to [new_pct]%."

	if(!length(lines))
		return

	var/final_text = jointext(lines, "<br>")
	var/final_announcement_text = bad_guy ? bad_announcement_text : good_announcement_text
	priority_announce(final_text, final_announcement_text, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)

/datum/controller/subsystem/treasury/proc/get_tax_category_pretty_name(category)
	switch(category)
		if(TAX_CATEGORY_CONTRACT_LEVY)
			return "Contract Levy"
		if(TAX_CATEGORY_HEADEATER_LEVY)
			return "Headeater Levy"
		if(TAX_CATEGORY_IMPORT_TARIFF)
			return "Import Tariff"
		if(TAX_CATEGORY_EXPORT_DUTY)
			return "Export Duty"
		if(TAX_CATEGORY_FINE)
			return "Fine"
	return capitalize(category)

/// Checks if there is a valid amount in the treasury, if so, withdraw that amount and log it
/// Currently only used by Chimeric heartbeasts
/datum/controller/subsystem/treasury/proc/withdraw_money_treasury(amt, target)
	if(!amt)
		return FALSE
	return burn(discretionary_fund, amt, "withdrawn by [target]")
	