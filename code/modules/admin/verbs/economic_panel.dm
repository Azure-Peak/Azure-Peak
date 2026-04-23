GLOBAL_DATUM_INIT(economic_panel, /datum/economic_panel, new)

/client/proc/cmd_admin_economic_panel()
	set category = "Debug"
	set name = "Economic Panel"
	set desc = "Inspect and manipulate the fiscal system for testing."

	if(!check_rights(R_ADMIN|R_DEBUG))
		return
	GLOB.economic_panel.ui_interact(usr)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Economic Panel")

/datum/economic_panel
	var/filter_category = "all"
	var/filter_status = "all"
	var/filter_search = ""
	var/selected_ref

/datum/economic_panel/ui_state(mob/user)
	if(user.client && check_rights_for(user.client, R_ADMIN|R_DEBUG))
		return GLOB.always_state
	return GLOB.never_state

/datum/economic_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EconomicPanel", "Economic Panel")
		ui.open()

/datum/economic_panel/ui_static_data(mob/user)
	return list(
		"filter_options" = list(
			"categories" = list(
				"all",
				POLL_TAX_CAT_NOBLE,
				POLL_TAX_CAT_CLERGY,
				POLL_TAX_CAT_INQUISITION,
				POLL_TAX_CAT_COURTIER,
				POLL_TAX_CAT_GARRISON,
				POLL_TAX_CAT_GUILDS,
				POLL_TAX_CAT_MERCHANT,
				POLL_TAX_CAT_BURGHER,
				POLL_TAX_CAT_ADVENTURER,
				POLL_TAX_CAT_MERCENARY,
				POLL_TAX_CAT_PEASANT,
			),
			"statuses" = list("all", "arrears", "advance", "debtor", "low_balance", "exempt"),
		),
	)

/datum/economic_panel/ui_data(mob/user)
	var/list/data = list()
	data["dashboard"] = SStreasury.compute_fiscal_snapshot()
	data["filter"] = list(
		"category" = filter_category,
		"status" = filter_status,
		"search" = filter_search,
	)
	data["players"] = SStreasury.compute_filtered_players(filter_category, filter_status, filter_search, FALSE)
	data["selected"] = null
	if(selected_ref)
		// Locate the selected row in the list, then patch in on_person for just that one row.
		// Keeps the list cheap (no inventory walk per row) while the detail pane still shows it.
		for(var/entry in data["players"])
			if(entry["ref"] == selected_ref)
				var/mob/living/selected_mob = locate(selected_ref)
				if(selected_mob)
					entry["on_person"] = get_mammons_in_atom(selected_mob) || 0
				data["selected"] = entry
				break
	data["day"] = GLOB.dayspassed
	data["charters"] = SStreasury.compute_charter_states()
	data["simulated_player_scalar"] = SSeconomy?.simulated_player_scalar || 0
	data["effective_player_count"] = SSeconomy?.get_effective_player_count() || 0
	data["live_player_count"] = get_active_player_count()

	var/list/blockades = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/economic_region/ER = B.get_region()
		var/datum/quest_faction/F = B.get_faction()
		blockades += list(list(
			"region_id" = B.region_id,
			"region_name" = ER ? ER.name : B.region_id,
			"threat_region" = B.threat_region_name,
			"faction_name" = F ? F.name_plural : B.faction_id,
			"day_started" = B.day_started,
			"has_active_scroll" = B.has_active_scroll() ? TRUE : FALSE,
			"ref" = "\ref[B]",
		))
	data["blockades"] = blockades
	return data

/datum/economic_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("set_filter")
			filter_category = params["category"] || "all"
			filter_status = params["status"] || "all"
			filter_search = params["search"] || ""
			return TRUE
		if("select")
			selected_ref = params["ref"]
			return TRUE
		if("clear_selection")
			selected_ref = null
			return TRUE
		if("advance_day")
			GLOB.dayspassed++
			admin_log_fiscal("advanced the day to [GLOB.dayspassed]", "Advance Day")
			return TRUE
		if("fire_poll_tick")
			SStreasury.tick_poll_tax()
			admin_log_fiscal("fired tick_poll_tax", "Fire Poll Tick")
			return TRUE
		if("fire_loan_tick")
			SStreasury.tick_loans()
			admin_log_fiscal("fired tick_loans", "Fire Loan Tick")
			return TRUE
		if("fire_pledge_tick")
			SStreasury.tick_burgher_pledge()
			admin_log_fiscal("fired tick_burgher_pledge", "Fire Pledge Tick")
			return TRUE
		if("fire_estate_incomes")
			SStreasury.distribute_estate_incomes()
			admin_log_fiscal("distributed estate incomes", "Distribute Estates")
			return TRUE
		if("fire_payroll")
			SStreasury.distribute_daily_payments()
			admin_log_fiscal("distributed daily payments", "Distribute Payroll")
			return TRUE
		if("fire_savings_goal")
			SStreasury.award_savings_goals()
			admin_log_fiscal("awarded savings goals (test)", "Award Savings Goals")
			return TRUE
		if("fire_economy_tick")
			if(SSeconomy)
				SSeconomy.last_processed_day = 0
				SSeconomy.daily_tick()
				admin_log_fiscal("forced economy daily tick (regenerated produces/demands, rolled orders, rolled events)", "Fire Economy Tick")
			return TRUE
		if("set_simulated_population")
			if(!SSeconomy)
				return TRUE
			var/amt = text2num(params["amount"])
			if(!isnum(amt) || amt < 0)
				amt = 0
			SSeconomy.simulated_player_scalar = round(amt)
			admin_log_fiscal("set simulated player scalar to [SSeconomy.simulated_player_scalar] (0 = use live count)", "Set Simulated Population")
			return TRUE
		if("fire_blockade_roll")
			if(!SSeconomy)
				return TRUE
			var/datum/blockade/B = SSeconomy.roll_blockade()
			if(B)
				var/datum/economic_region/ER = B.get_region()
				admin_log_fiscal("rolled a blockade on [ER ? ER.name : B.region_id] ([B.faction_id])", "Fire Blockade Roll")
			else
				to_chat(usr, span_warning("No eligible region available to blockade."))
			return TRUE
		if("clear_blockade")
			if(!SSeconomy)
				return TRUE
			var/datum/blockade/B = locate(params["ref"]) in GLOB.active_blockades
			if(!B)
				return TRUE
			var/datum/economic_region/ER = B.get_region()
			SSeconomy.clear_blockade(B, "admin")
			admin_log_fiscal("force-cleared blockade on [ER ? ER.name : "unknown"]", "Clear Blockade")
			return TRUE
		if("mint_discretionary")
			var/amt = text2num(params["amount"])
			if(!isnum(amt) || amt <= 0)
				return TRUE
			SStreasury.mint(SStreasury.discretionary_fund, amt, "admin mint by [key_name(usr)]")
			admin_log_fiscal("minted [amt]m into Crown's Purse", "Mint Crown's Purse")
			return TRUE
		if("burn_discretionary")
			var/amt = text2num(params["amount"])
			if(!isnum(amt) || amt <= 0)
				return TRUE
			SStreasury.burn(SStreasury.discretionary_fund, amt, "admin burn by [key_name(usr)]")
			admin_log_fiscal("burned [amt]m from Crown's Purse", "Burn Crown's Purse")
			return TRUE
		if("toggle_charter")
			var/datum/decree/D = SStreasury.get_decree(params["decree_id"])
			if(!D)
				return TRUE
			D.set_state(!D.active)
			admin_log_fiscal("toggled [D.id] to active=[D.active]", "Toggle Charter")
			return TRUE
		if("player_clear_debt")
			var/mob/living/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			SStreasury.clear_poll_tax_debt(target)
			admin_log_fiscal("cleared poll-tax debt for [key_name(target)]", "Clear Poll Debt")
			return TRUE
		if("player_add_advance")
			var/mob/living/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			var/days = text2num(params["days"]) || 1
			SStreasury.poll_tax_advance_days[target] = (SStreasury.poll_tax_advance_days[target] || 0) + days
			admin_log_fiscal("added [days] days advance to [key_name(target)]", "Add Advance")
			return TRUE
		if("player_remove_advance")
			var/mob/living/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			var/days = text2num(params["days"]) || 1
			var/existing = SStreasury.poll_tax_advance_days[target] || 0
			var/new_val = max(0, existing - days)
			if(new_val <= 0)
				SStreasury.poll_tax_advance_days -= target
			else
				SStreasury.poll_tax_advance_days[target] = new_val
			admin_log_fiscal("removed [days] days advance from [key_name(target)]", "Remove Advance")
			return TRUE
		if("player_toggle_debtor")
			var/mob/living/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			if(HAS_TRAIT(target, TRAIT_DEBTOR))
				REMOVE_TRAIT(target, TRAIT_DEBTOR, TRAIT_GENERIC)
				admin_log_fiscal("removed TRAIT_DEBTOR from [key_name(target)]", "Toggle Debtor")
			else
				ADD_TRAIT(target, TRAIT_DEBTOR, TRAIT_GENERIC)
				admin_log_fiscal("added TRAIT_DEBTOR to [key_name(target)]", "Toggle Debtor")
			return TRUE
		if("player_mint_account")
			var/mob/living/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			var/amt = text2num(params["amount"])
			if(!isnum(amt) || amt <= 0)
				return TRUE
			var/datum/fund/account = SStreasury.get_account(target)
			if(!account)
				return TRUE
			SStreasury.mint(account, amt, "admin mint by [key_name(usr)]")
			admin_log_fiscal("minted [amt]m to [key_name(target)]", "Mint to Account")
			return TRUE
		if("player_burn_account")
			var/mob/living/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			var/amt = text2num(params["amount"])
			if(!isnum(amt) || amt <= 0)
				return TRUE
			var/datum/fund/account = SStreasury.get_account(target)
			if(!account)
				return TRUE
			SStreasury.burn(account, amt, "admin burn by [key_name(usr)]")
			admin_log_fiscal("burned [amt]m from [key_name(target)]", "Burn from Account")
			return TRUE
		if("bulk_clear_debt")
			var/list/matches = SStreasury.compute_filtered_players(filter_category, filter_status, filter_search)
			var/count = 0
			for(var/entry in matches)
				var/mob/living/target = locate(entry["ref"])
				if(!istype(target))
					continue
				SStreasury.clear_poll_tax_debt(target)
				count++
			admin_log_fiscal("bulk-cleared poll-tax debt for [count] players (filter cat=[filter_category] status=[filter_status])", "Bulk Clear Debt")
			return TRUE
		if("bulk_add_advance")
			var/days = text2num(params["days"]) || 1
			var/list/matches = SStreasury.compute_filtered_players(filter_category, filter_status, filter_search)
			var/count = 0
			for(var/entry in matches)
				var/mob/living/target = locate(entry["ref"])
				if(!istype(target))
					continue
				SStreasury.poll_tax_advance_days[target] = (SStreasury.poll_tax_advance_days[target] || 0) + days
				count++
			admin_log_fiscal("bulk-added [days] advance days to [count] players", "Bulk Add Advance")
			return TRUE

/proc/admin_log_fiscal(detail, tally_label)
	log_admin("[key_name(usr)] [detail]")
	message_admins(span_adminnotice("[key_name_admin(usr)] [detail]."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, tally_label)
