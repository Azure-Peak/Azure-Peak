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
	var/trade_spread = 0.10
	var/mint_multiplier = 0.8
	var/minted = 0
	var/autoexport_percentage = 0.6
	var/list/bank_accounts = list()
	var/datum/fund/discretionary_fund
	var/datum/fund/burgher_pledge_fund
	var/list/ledger = list()
	var/list/noble_incomes = list()
	var/list/decrees = list()
	var/list/stockpile_datums = list()
	var/decree_revoke_used_day = -1
	var/decree_restore_used_day = -1
	var/next_treasury_check = 0
	var/economic_output = 0
	var/total_deposit_tax = 0
	var/total_rural_tax = 0
	var/total_noble_income = 0
	var/total_import = 0
	var/total_export = 0
	var/obj/structure/roguemachine/steward/steward_machine
	var/initial_payment_done = FALSE
	var/list/loans = list()
	var/loan_interest_rate = 0.25
	var/loan_max_issuance_day = 5
	var/list/poll_tax_rates = list(
		POLL_TAX_CAT_NOBLE = 0,
		POLL_TAX_CAT_CLERGY = 0,
		POLL_TAX_CAT_INQUISITION = 0,
		POLL_TAX_CAT_COURTIER = 0,
		POLL_TAX_CAT_GARRISON = 0,
		POLL_TAX_CAT_GUILDS = 0,
		POLL_TAX_CAT_MERCHANT = 0,
		POLL_TAX_CAT_BURGHER = 0,
		POLL_TAX_CAT_ADVENTURER = 0,
		POLL_TAX_CAT_MERCENARY = 0,
		POLL_TAX_CAT_PEASANT = 0,
	)
	var/list/poll_tax_advance_days = list()
	var/list/poll_tax_owed = list()
	var/list/poll_tax_debt_days = list()
	var/levy_rates_changed_day = -1
	var/poll_rates_changed_day = -1
	/// Steward-settable floor. Stockpile refuses purchases when Crown's Purse would drop below this.
	var/stockpile_purchase_floor = STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT
	var/rumor_points = RUMOR_POINTS_START
	var/list/rumor_log = list()
	var/list/rumor_issued_today = list()
	var/list/defense_log = list()

/datum/controller/subsystem/treasury/Initialize()
	// Roundstart Crown's Purse = purchase floor + random buffer + pop-scaled seed. Pop scaling
	// covers the payroll burden (highpop full-roster = ~600m/day) so a low-rolled purse
	// at full garrison doesn't trigger immediate insolvency.
	var/roundstart_pop = get_active_player_count()
	var/seed = STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT + rand(500, 1500) + (roundstart_pop * CROWN_PURSE_SEED_PER_PLAYER)
	discretionary_fund = new("Crown's Purse", null, seed, CURRENCY_MAMMON)
	burgher_pledge_fund = new("Burgher Pledge", null, BURGHER_PLEDGE_BASE_REFILL * BURGHER_PLEDGE_ROUNDSTART_MULTIPLIER, CURRENCY_BURGHER_PLEDGE)
	force_set_round_statistic(STATS_STARTING_TREASURY, discretionary_fund.balance)
	init_decrees()

	for(var/path in subtypesof(/datum/roguestock/bounty))
		var/datum/D = new path
		stockpile_datums += D
	for(var/path in subtypesof(/datum/roguestock/stockpile))
		var/datum/D = new path
		stockpile_datums += D
	return ..()

/datum/controller/subsystem/treasury/fire(resumed = 0)
	if(world.time > next_treasury_check)
		next_treasury_check = world.time + TREASURY_TICK_AMOUNT
		if(SSticker.current_state == GAME_STATE_PLAYING)
			if(!initial_payment_done)
				initial_payment_done = TRUE
				distribute_daily_payments()
		var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/vault]
		for(var/obj/structure/roguemachine/vaultbank/VB in A)
			if(istype(VB))
				VB.update_icon()
		mint(discretionary_fund, RURAL_TAX, "Rural Tax Collection")
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

/// Returns the maximum mammon that can still be fined from payer today across all active decrees.
/datum/controller/subsystem/treasury/proc/get_daily_fine_remaining(mob/living/payer)
	if(!payer || HAS_TRAIT(payer, TRAIT_OUTLAW))
		return 999999
	var/datum/fund/account = get_account(payer)
	var/remaining = account ? account.balance : 0
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		remaining = D.apply_daily_fine_cap(payer, remaining)
	return remaining

/// Notifies all active decrees that a fine was successfully applied, so they can update tracking.
/datum/controller/subsystem/treasury/proc/notify_fine_applied(mob/living/payer, amount)
	if(!payer || amount <= 0)
		return
	for(var/id in decrees)
		var/datum/decree/D = decrees[id]
		D.on_fine_applied(payer, amount)

/datum/controller/subsystem/treasury/proc/award_savings_goals()
	var/met = 0
	var/missed = 0
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(!account || account.currency != CURRENCY_MAMMON)
			continue
		var/mob/living/owner = account.get_owner()
		if(!owner || !owner.mind)
			continue
		var/threshold = SAVINGS_GOAL_THRESHOLD
		var/list/modifiers = list()
		if(HAS_TRAIT(owner, TRAIT_NOBLE))
			threshold += SAVINGS_GOAL_NOBLE_BUMP
			modifiers += "noble"
		if(owner.get_flaw(/datum/charflaw/greedy))
			threshold += SAVINGS_GOAL_GREEDY_BUMP
			modifiers += "greedy"
		var/modifier_text = length(modifiers) ? " as [jointext(modifiers, ", ")]" : ""
		var/on_person = get_mammons_in_atom(owner) || 0
		var/in_bank = account.balance
		var/total = on_person + in_bank
		if(total >= threshold)
			owner.mind.adjust_triumphs(3)
			met++
			to_chat(owner, "<font color='purple'>You met your Savings Goal ([total]m total, needed [threshold]m[modifier_text])! +3 TRIUMPHS awarded.</font>")
		else
			missed++
			to_chat(owner, "<font color='gray'>You fell short of your Savings Goal (had [total]m, needed [threshold]m[modifier_text]).</font>")
	record_round_statistic(STATS_SAVINGS_GOAL_MET, met)
	record_round_statistic(STATS_SAVINGS_GOAL_MISSED, missed)
	return list("met" = met, "missed" = missed)

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
		log_game("CROWN GRANT: [usr ? key_name(usr) : "system"] granted [amt]m to [istype(target, /mob/living) ? key_name(target) : target_name] via [source || "unknown"]")
	else
		if(SSgamemode?.roundvoteend)
			send_ooc_note("<b>MEISTER:</b> Error: The round is ending. No further fines may be levied.", name = target_name)
			return FALSE
		var/mob/living/fine_owner = istype(target, /mob/living) ? target : null
		if(fine_owner && is_tax_exempt(fine_owner, TAX_CATEGORY_FINE))
			record_tax_exemption(TAX_CATEGORY_FINE, abs(amt))
			send_ooc_note("<b>MEISTER:</b> Error: By decree, they cannot be fined.", name = target_name)
			log_game("FINE REFUSED: [usr ? key_name(usr) : "system"] attempted to fine [key_name(fine_owner)] [abs(amt)]m but they were Charter-exempt")
			return FALSE
		var/fine_amt = abs(amt)
		if(fine_owner)
			var/cap_rate = get_rate_cap(fine_owner, TAX_CATEGORY_FINE)
			var/max_fine = FLOOR(account.balance * cap_rate, 1)
			max_fine = min(max_fine, get_daily_fine_remaining(fine_owner))
			if(fine_amt > max_fine)
				record_tax_exemption(TAX_CATEGORY_FINE, fine_amt - max_fine)
				fine_amt = max_fine
		if(fine_amt <= 0)
			send_ooc_note("<b>MEISTER:</b> Error: No fineable amount remains.", name = target_name)
			return FALSE
		if(!transfer(account, discretionary_fund, fine_amt, "[TAX_CATEGORY_FINE] ([source])"))
			send_ooc_note("<b>MEISTER:</b> Error: Insufficient funds in the account to complete the fine.", name = target_name)
			return FALSE
		record_round_statistic(STATS_FINES_INCOME, -fine_amt)
		send_ooc_note(source ? "<b>MEISTER:</b> You were fined [fine_amt]m. ([source])" : "<b>MEISTER:</b> You were fined [fine_amt]m.", name = target_name)
		log_game("FINE: [usr ? key_name(usr) : "system"] fined [istype(target, /mob/living) ? key_name(target) : target_name] [fine_amt]m via [source || "unknown"]")
		if(fine_owner)
			notify_fine_applied(fine_owner, fine_amt)

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

	if(SSeconomy)
		SSeconomy.daily_tick()

/datum/controller/subsystem/treasury/proc/tick_rumor_points()
	var/active = get_active_player_count()
	var/refill = RUMOR_POINTS_BASE_REFILL + (RUMOR_POINTS_PER_PLAYER * active)
	rumor_points += refill
	var/ceiling = RUMOR_POINTS_CLAWBACK_MULTIPLIER * refill
	if(rumor_points > ceiling)
		rumor_points = ceiling

/datum/controller/subsystem/treasury/proc/tick_burgher_pledge()
	if(!burgher_pledge_fund)
		return
	var/datum/decree/golden = get_decree(DECREE_GOLDEN_BULL)
	if(!golden?.active)
		return
	var/refill = BURGHER_PLEDGE_BASE_REFILL + (get_active_player_count() * BURGHER_PLEDGE_PER_PLAYER)
	var/ceiling = refill * BURGHER_PLEDGE_CLAWBACK_MULTIPLIER
	if(burgher_pledge_fund.balance > ceiling)
		var/surplus = burgher_pledge_fund.balance - ceiling
		burn(burgher_pledge_fund, surplus, "Burgher Pledge clawback")
	mint(burgher_pledge_fund, refill, "Burgher Pledge replenishment")

/datum/controller/subsystem/treasury/proc/do_export(var/datum/roguestock/D, silent = FALSE)
	if(D.stockpile_amount < D.importexport_amt)
		return FALSE
	var/amt = D.get_export_price()
	D.stockpile_amount -= D.importexport_amt

	mint(discretionary_fund, amt, "exported [D.name]")
	SStreasury.total_export += amt
	record_round_statistic(STATS_STOCKPILE_EXPORTS_VALUE, amt)
	if(!silent && amt >= EXPORT_ANNOUNCE_THRESHOLD)
		scom_announce("Azure Peak exports [D.name] for [amt] mammon.")
	return amt

/datum/controller/subsystem/treasury/proc/auto_export()
	var/total_value_exported = 0
	for(var/datum/roguestock/D in stockpile_datums)
		if(!D.importexport_amt)
			continue
		if((autoexport_percentage * D.stockpile_limit) >= D.stockpile_amount)
			continue
		// Unpegged trade-good entries are Steward's manual territory.
		if(D.trade_good_id && !D.pegged)
			continue
		// Legacy entries (no trade_good_id) keep the old profitability guard.
		if(!D.trade_good_id)
			if(D.get_export_price() <= (D.payout_price * D.importexport_amt))
				continue
			if(D.stockpile_amount >= D.importexport_amt)
				total_value_exported += do_export(D, TRUE)
			continue
		// Trade-good entries: clear surplus only up to the best region's remaining daily
		// demand. No escalation, no profit required - this is a market pressure valve.
		var/surplus = D.stockpile_amount - round(autoexport_percentage * D.stockpile_limit)
		if(surplus <= 0)
			continue
		var/list/best = SSeconomy.get_best_export_region(D.trade_good_id)
		if(!best || !best["region_id"])
			continue
		var/datum/economic_region/region = GLOB.economic_regions[best["region_id"]]
		if(!region)
			continue
		var/remaining_demand = region.demands_today[D.trade_good_id] || 0
		if(remaining_demand <= 0)
			continue
		var/export_qty = min(surplus, remaining_demand)
		var/revenue = SSeconomy.manual_export(null, region.region_id, D.trade_good_id, export_qty)
		if(revenue)
			total_value_exported += revenue
	if(total_value_exported >= EXPORT_ANNOUNCE_THRESHOLD)
		scom_announce("Azure Peak exports [total_value_exported] mammons of surplus goods.")

/datum/controller/subsystem/treasury/proc/remove_person(mob/living/person)
	noble_incomes -= person
	bank_accounts -= person
	poll_tax_advance_days -= person
	poll_tax_owed -= person
	poll_tax_debt_days -= person
	return TRUE

/datum/controller/subsystem/treasury/proc/apply_rate_adjustments(list/adjustments, good_announcement_text, bad_announcement_text)
	if(GLOB.dayspassed <= levy_rates_changed_day)
		to_chat(usr, span_warning("Crown levies have already been adjusted today - come back tomorrow."))
		return
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

	levy_rates_changed_day = GLOB.dayspassed
	var/final_text = jointext(lines, "<br>")
	var/final_announcement_text = bad_guy ? bad_announcement_text : good_announcement_text
	priority_announce(final_text, final_announcement_text, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
	log_game("TAX RATES: [usr ? key_name(usr) : "system"] changed levy rates - [jointext(lines, " | ")]")

/datum/controller/subsystem/treasury/proc/apply_poll_rate_adjustments(list/adjustments, good_announcement_text, bad_announcement_text)
	if(GLOB.dayspassed <= poll_rates_changed_day)
		to_chat(usr, span_warning("Poll tax rates have already been adjusted today - come back tomorrow."))
		return
	if(!islist(adjustments))
		return
	var/list/lines = list()
	var/bad_guy = FALSE
	for(var/entry in adjustments)
		if(!islist(entry))
			continue
		var/category = entry["category"]
		if(!(category in poll_tax_rates))
			continue
		var/new_rate = CLAMP(entry["rate"], 0, POLL_TAX_MAX_RATE)
		var/old_rate = poll_tax_rates[category] || 0
		if(new_rate == old_rate)
			continue
		poll_tax_rates[category] = new_rate
		if(new_rate > old_rate)
			bad_guy = TRUE
		var/pretty = get_poll_tax_category_pretty_name(category)
		var/verb = new_rate > old_rate ? "raised" : "reduced"
		lines += "[pretty] poll tax [verb] from [old_rate]m/day to [new_rate]m/day."

	if(!length(lines))
		return
	poll_rates_changed_day = GLOB.dayspassed
	var/final_text = jointext(lines, "<br>")
	var/final_announcement_text = bad_guy ? bad_announcement_text : good_announcement_text
	priority_announce(final_text, final_announcement_text, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
	log_game("POLL TAX RATES: [usr ? key_name(usr) : "system"] changed poll tax rates - [jointext(lines, " | ")]")

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

/datum/controller/subsystem/treasury/proc/withdraw_money_treasury(amt, target)
	if(!amt)
		return FALSE
	return burn(discretionary_fund, amt, "withdrawn by [target]")

/datum/controller/subsystem/treasury/proc/get_poll_tax_category(mob/living/H)
	if(!H)
		return null
	if(HAS_TRAIT(H, TRAIT_OUTLAW))
		return null
	if(HAS_TRAIT(H, TRAIT_NOBLE) || (H.job in GLOB.noble_positions))
		return POLL_TAX_CAT_NOBLE
	if(H.job in GLOB.inquisition_positions)
		return POLL_TAX_CAT_INQUISITION
	if((H.job in GLOB.church_positions) || HAS_TRAIT(H, TRAIT_DECLARED_BENEFACTOR))
		return POLL_TAX_CAT_CLERGY
	if(H.job in GLOB.courtier_positions)
		return POLL_TAX_CAT_COURTIER
	if((H.job in GLOB.garrison_positions) || H.job == "Squire")
		return POLL_TAX_CAT_GARRISON
	if(H.job in list("Guildmaster", "Guildsman", "Tailor"))
		return POLL_TAX_CAT_GUILDS
	if(H.job == "Merchant")
		return POLL_TAX_CAT_MERCHANT
	if((H.job in list("Innkeeper", "Head Physician", "Apothecary", "Bathmaster", "Town Crier", "Magicians Associate")) || HAS_TRAIT(H, TRAIT_RESIDENT))
		return POLL_TAX_CAT_BURGHER
	if(H.job in GLOB.wanderer_positions)
		return POLL_TAX_CAT_ADVENTURER
	if(H.job == "Mercenary")
		return POLL_TAX_CAT_MERCENARY
	if((H.job in GLOB.peasant_positions) || (H.job in GLOB.sidefolk_positions))
		return POLL_TAX_CAT_PEASANT
	return null

/datum/controller/subsystem/treasury/proc/is_poll_tax_charter_exempt(mob/living/H, category)
	switch(category)
		if(POLL_TAX_CAT_NOBLE)
			var/datum/decree/GW = get_decree(DECREE_GREAT_WRIT)
			return GW?.active
		if(POLL_TAX_CAT_CLERGY)
			var/datum/decree/ZC = get_decree(DECREE_ZENITSTADT_CONCORDAT)
			return ZC?.active
		if(POLL_TAX_CAT_INQUISITION)
			var/datum/decree/OA = get_decree(DECREE_OTAVAN_ACCORDS)
			return OA?.active
	return FALSE

/datum/controller/subsystem/treasury/proc/get_poll_tax_category_pretty_name(category)
	switch(category)
		if(POLL_TAX_CAT_NOBLE)
			return "Noble"
		if(POLL_TAX_CAT_CLERGY)
			return "Clergy"
		if(POLL_TAX_CAT_INQUISITION)
			return "Inquisition"
		if(POLL_TAX_CAT_COURTIER)
			return "Courtier"
		if(POLL_TAX_CAT_GARRISON)
			return "Garrison"
		if(POLL_TAX_CAT_GUILDS)
			return "Guilds"
		if(POLL_TAX_CAT_MERCHANT)
			return "Merchant"
		if(POLL_TAX_CAT_BURGHER)
			return "Burgher"
		if(POLL_TAX_CAT_ADVENTURER)
			return "Adventurer"
		if(POLL_TAX_CAT_MERCENARY)
			return "Mercenary"
		if(POLL_TAX_CAT_PEASANT)
			return "Peasant"
	return capitalize(category)

/datum/controller/subsystem/treasury/proc/record_poll_tax_by_category(category, amount)
	if(!category || amount <= 0)
		return
	record_round_statistic(STATS_POLL_TAX_COLLECTED, amount)
	switch(category)
		if(POLL_TAX_CAT_NOBLE)
			record_round_statistic(STATS_POLL_TAX_NOBLE, amount)
		if(POLL_TAX_CAT_CLERGY)
			record_round_statistic(STATS_POLL_TAX_CLERGY, amount)
		if(POLL_TAX_CAT_INQUISITION)
			record_round_statistic(STATS_POLL_TAX_INQUISITION, amount)
		if(POLL_TAX_CAT_COURTIER)
			record_round_statistic(STATS_POLL_TAX_COURTIER, amount)
		if(POLL_TAX_CAT_GARRISON)
			record_round_statistic(STATS_POLL_TAX_GARRISON, amount)
		if(POLL_TAX_CAT_GUILDS)
			record_round_statistic(STATS_POLL_TAX_GUILDS, amount)
		if(POLL_TAX_CAT_MERCHANT)
			record_round_statistic(STATS_POLL_TAX_MERCHANT, amount)
		if(POLL_TAX_CAT_BURGHER)
			record_round_statistic(STATS_POLL_TAX_BURGHER, amount)
		if(POLL_TAX_CAT_ADVENTURER)
			record_round_statistic(STATS_POLL_TAX_ADVENTURER, amount)
		if(POLL_TAX_CAT_MERCENARY)
			record_round_statistic(STATS_POLL_TAX_MERCENARY, amount)
		if(POLL_TAX_CAT_PEASANT)
			record_round_statistic(STATS_POLL_TAX_PEASANT, amount)

/datum/controller/subsystem/treasury/proc/get_poll_tax_rate_for(mob/living/H, category)
	if(!category)
		return 0
	if(H && is_poll_tax_charter_exempt(H, category))
		return 0
	var/rate = poll_tax_rates[category] || 0
	if(category == POLL_TAX_CAT_BURGHER)
		var/datum/decree/golden = get_decree(DECREE_GOLDEN_BULL)
		if(golden?.active)
			rate = min(rate, GOLDEN_BULL_POLL_CAP)
	return rate

/datum/controller/subsystem/treasury/proc/poll_tax_pay_advance(mob/living/H, days)
	if(!H || days <= 0)
		return FALSE
	if(SSticker?.round_start_time && (world.time - SSticker.round_start_time) < POLL_TAX_ADVANCE_LOCKOUT)
		to_chat(H, span_warning("The Crown's ledgers have not yet opened for the day. Try again later."))
		return FALSE
	var/datum/fund/account = get_account(H)
	if(!account)
		return FALSE
	var/category = get_poll_tax_category(H)
	if(!category)
		to_chat(H, span_warning("The Crown does not tax your class."))
		return FALSE
	if(is_poll_tax_charter_exempt(H, category))
		to_chat(H, span_warning("Your class is exempt from poll tax by decree."))
		return FALSE
	var/rate = get_poll_tax_rate_for(H, category)
	if(rate <= 0)
		rate = POLL_TAX_ADVANCE_FALLBACK_RATE
	var/existing_advance = poll_tax_advance_days[H] || 0
	var/room = POLL_TAX_MAX_ADVANCE_DAYS - existing_advance
	if(room <= 0)
		to_chat(H, span_warning("You already hold the maximum of [POLL_TAX_MAX_ADVANCE_DAYS] days of Poll Tax advance."))
		return FALSE
	if(days > room)
		days = room
	var/total_cost = rate * days
	if(account.balance < total_cost)
		to_chat(H, span_warning("Insufficient balance. Need [total_cost]m for [days] days."))
		return FALSE
	if(!transfer(account, discretionary_fund, total_cost, "Poll Tax advance ([days] days)"))
		return FALSE
	record_poll_tax_by_category(category, total_cost)
	poll_tax_advance_days[H] = existing_advance + days
	to_chat(H, span_notice("You have advanced [days] day[days == 1 ? "" : "s"] of Poll Tax ([total_cost]m total). Advance held: [poll_tax_advance_days[H]] day[poll_tax_advance_days[H] == 1 ? "" : "s"]."))
	log_game("POLL TAX ADVANCE: [key_name(H)] prepaid [days] days ([total_cost]m) of poll tax as [category]")
	return TRUE

/// Clears arrears but preserves advance days - already-advanced mammon stays credited on rehab. Use remove_person for full purge.
/datum/controller/subsystem/treasury/proc/clear_poll_tax_debt(mob/living/H)
	if(!H)
		return
	poll_tax_owed -= H
	poll_tax_debt_days -= H

/datum/controller/subsystem/treasury/proc/tick_poll_tax()
	for(var/key in bank_accounts)
		var/datum/fund/account = bank_accounts[key]
		if(!account)
			continue
		var/mob/living/owner = account.get_owner()
		if(!owner)
			continue
		var/category = get_poll_tax_category(owner)
		if(!category)
			continue
		if(is_poll_tax_charter_exempt(owner, category))
			var/exempted_rate = poll_tax_rates[category] || 0
			if(exempted_rate > 0)
				record_round_statistic(STATS_EXEMPTED_POLL_TAX, exempted_rate)
			continue
		var/rate = get_poll_tax_rate_for(owner, category)
		var/raw_rate = poll_tax_rates[category] || 0
		if(raw_rate > rate)
			record_round_statistic(STATS_EXEMPTED_POLL_TAX, raw_rate - rate)
		if(rate <= 0)
			continue

		var/advance = poll_tax_advance_days[owner] || 0
		if(advance > 0)
			advance--
			if(advance <= 0)
				poll_tax_advance_days -= owner
			else
				poll_tax_advance_days[owner] = advance
			to_chat(owner, span_notice("<b>POLL TAX:</b> Covered by advance. [advance] day[advance == 1 ? "" : "s"] remaining."))
			continue

		var/owed_this_tick = rate + (poll_tax_owed[owner] || 0)

		var/paid = 0
		if(account.balance >= owed_this_tick)
			if(transfer(account, discretionary_fund, owed_this_tick, "Poll Tax ([category])"))
				paid = owed_this_tick
				owed_this_tick = 0
		else
			var/partial = account.balance
			if(partial > 0 && transfer(account, discretionary_fund, partial, "Poll Tax ([category])"))
				paid = partial
				owed_this_tick -= partial

		if(paid > 0)
			record_poll_tax_by_category(category, paid)
			to_chat(owner, span_notice("<b>POLL TAX:</b> [paid]m collected."))

		if(owed_this_tick > 0)
			poll_tax_owed[owner] = owed_this_tick
			poll_tax_debt_days[owner] = (poll_tax_debt_days[owner] || 0) + 1
			to_chat(owner, span_danger("<b>POLL TAX:</b> You owe the Crown [owed_this_tick]m. [poll_tax_debt_days[owner]] day\s overdue."))
			if(poll_tax_debt_days[owner] >= POLL_TAX_DEBT_DAYS_TO_DEBTOR)
				if(!HAS_TRAIT(owner, TRAIT_DEBTOR))
					ADD_TRAIT(owner, TRAIT_DEBTOR, TRAIT_GENERIC)
					to_chat(owner, span_danger("<b>You have been marked a DEBTOR of the Crown for unpaid Poll Tax.</b>"))
		else
			clear_poll_tax_debt(owner)
