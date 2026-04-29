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

	var/list/assembly = list()
	if(SScity_assembly)
		var/mob/alderman = SScity_assembly.resolve_get_alderman()
		assembly["session_number"] = SScity_assembly.session_counter
		assembly["alderman_name"] = alderman ? alderman.real_name : null
		assembly["alderman_ckey"] = alderman ? alderman.ckey : null
		assembly["history_count"] = length(SScity_assembly.history)
		assembly["censured_count"] = length(SScity_assembly.censured_refs)
		var/datum/assembly_warrant/W = SScity_assembly.current_warrant
		if(W)
			assembly["trade_cap"] = W.trade_daily_cap
			assembly["trade_remaining"] = W.trade_remaining
			assembly["defense_cap"] = W.defense_daily_cap
			assembly["defense_remaining"] = W.defense_remaining
	data["assembly"] = assembly

	var/list/bankruptcy = list()
	bankruptcy["state"] = SStreasury.treasury_state
	bankruptcy["state_label"] = bankruptcy_state_label(SStreasury.treasury_state)
	bankruptcy["debt"] = SStreasury.treasury_debt
	bankruptcy["bankruptcy_count"] = SStreasury.bankruptcy_count
	bankruptcy["concession_picks"] = SStreasury.bankruptcy_concession_picks
	bankruptcy["operating_floor"] = BANKRUPTCY_OPERATING_FLOOR
	bankruptcy["arrears_loan_floor"] = TREASURY_ARREARS_LOAN
	bankruptcy["recovery_reset"] = BANKRUPTCY_RECOVERY_RESET
	bankruptcy["autoexport_override"] = round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)
	var/list/suspended = list()
	for(var/decree_id in SStreasury.bankruptcy_suspended_decree_ids)
		var/datum/decree/D = SStreasury.get_decree(decree_id)
		if(!D)
			continue
		suspended += list(list(
			"id" = decree_id,
			"name" = D.name,
		))
	bankruptcy["suspended_charters"] = suspended
	bankruptcy["atc_loan_min"] = ATC_LOAN_MIN_AMOUNT
	bankruptcy["atc_loan_max"] = ATC_LOAN_MAX_AMOUNT
	bankruptcy["atc_loan_closed_day"] = ATC_LOAN_CLOSED_DAY
	bankruptcy["atc_loan_available"] = SStreasury.atc_loan_available() ? TRUE : FALSE
	bankruptcy["atc_loan_blocker"] = SStreasury.atc_loan_blocker_reason() || ""
	bankruptcy["atc_loan_arrears_consumed"] = SStreasury.atc_loan_arrears_consumed ? TRUE : FALSE
	bankruptcy["atc_loans_drawn"] = SStreasury.atc_loans_drawn_this_round

	var/list/daily_payroll = list()
	var/payroll_total = 0
	if(SStreasury.steward_machine && SStreasury.steward_machine.daily_payments)
		for(var/job_name in SStreasury.steward_machine.daily_payments)
			var/amount = SStreasury.steward_machine.daily_payments[job_name]
			var/headcount = 0
			var/suspended_count = 0
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.job == job_name)
					headcount++
					if(HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
						suspended_count++
			daily_payroll += list(list(
				"job" = job_name,
				"amount" = amount,
				"headcount" = headcount,
				"suspended_count" = suspended_count,
				"row_total" = amount * (headcount - suspended_count),
			))
			payroll_total += amount * (headcount - suspended_count)
	bankruptcy["daily_payroll"] = daily_payroll
	bankruptcy["daily_payroll_total"] = payroll_total
	data["bankruptcy"] = bankruptcy

	// Aggregation tallies the full ledger so cap-exceeding history still shows up in the
	// inflow/outflow totals; only the displayed rows are capped to keep the payload bounded.
	var/list/ledger_serialized = list()
	var/ledger_total = SStreasury.ledger.len
	var/cap = 500
	var/start_idx = max(1, ledger_total - cap + 1)
	for(var/i = ledger_total to start_idx step -1)
		var/datum/treasury_entry/E = SStreasury.ledger[i]
		var/total_seconds = round(E.world_time / 10)
		var/minutes = round(total_seconds / 60)
		var/seconds = total_seconds % 60
		ledger_serialized += list(list(
			"kind" = E.kind,
			"from" = E.from_name,
			"to" = E.to_name,
			"amount" = E.amount,
			"currency" = E.currency,
			"reason" = E.reason,
			"time_label" = "[minutes]m[seconds]s",
		))
	data["ledger"] = ledger_serialized
	data["ledger_total"] = ledger_total
	data["ledger_cap"] = cap

	var/full_minted = 0
	var/full_burned = 0
	for(var/datum/treasury_entry/E as anything in SStreasury.ledger)
		if(E.kind == "mint")
			full_minted += E.amount
		else if(E.kind == "burn")
			full_burned += E.amount
	data["ledger_full_minted"] = full_minted
	data["ledger_full_burned"] = full_burned

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
			// Run the full dawn cadence so testing matches in-game timing: poll tax, loans,
			// pledge, estate incomes, then payroll (which itself triggers SSeconomy.daily_tick).
			// Payroll runs last because it's the call that may transition the solvency state.
			SStreasury.tick_poll_tax()
			SStreasury.tick_loans()
			SStreasury.tick_burgher_pledge()
			SStreasury.distribute_estate_incomes()
			SStreasury.distribute_daily_payments()
			admin_log_fiscal("advanced the day to [GLOB.dayspassed] (full daily tick)", "Advance Day")
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
		if("player_fire_indebted")
			var/mob/living/carbon/human/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			var/datum/charflaw/indebted/I = locate(/datum/charflaw/indebted) in target.charflaws
			if(!I)
				to_chat(usr, span_warning("[target.real_name] does not have the Indebted flaw."))
				return TRUE
			I.next_alimony = 0
			I.calculate_childsupport(target)
			admin_log_fiscal("fired Indebted tick on [key_name(target)]", "Fire Indebted Tick")
			return TRUE
		if("assembly_resolve")
			if(SScity_assembly)
				SScity_assembly.resolve_session("admin panel")
				admin_log_fiscal("forced City Assembly resolution (silent)", "Assembly Resolve")
			return TRUE
		if("assembly_resolve_skip_quorum")
			if(SScity_assembly)
				SScity_assembly.resolve_session("admin panel (quorum bypassed)", null, TRUE)
				admin_log_fiscal("forced City Assembly resolution with quorum bypass", "Assembly Resolve Skip Quorum")
			return TRUE
		if("assembly_divine_complete")
			if(SScity_assembly)
				SScity_assembly.resolve_session(
					"admin divine",
					"COMPLETED BY DIVINE INTERVENTION - the gods have hastened the Assembly's deliberations.",
				)
				admin_log_fiscal("force-completed City Assembly session (divine intervention flavor)", "Assembly Divine Complete")
			return TRUE
		if("assembly_refresh_warrant")
			if(SScity_assembly)
				SScity_assembly.refresh_warrant()
				admin_log_fiscal("refreshed Alderman warrant", "Assembly Warrant Refresh")
			return TRUE
		if("assembly_drain_warrant")
			if(SScity_assembly?.current_warrant)
				SScity_assembly.current_warrant.trade_remaining = 0
				SScity_assembly.current_warrant.defense_remaining = 0
				admin_log_fiscal("drained Alderman warrant", "Drain Warrant")
			return TRUE
		if("assembly_set_trade_cap")
			var/amt = text2num(params["amount"])
			if(!isnum(amt) || amt < 0)
				return TRUE
			SScity_assembly?.current_warrant?.set_trade_cap(round(amt))
			SScity_assembly?.current_warrant?.refresh_for_day()
			admin_log_fiscal("set Alderman trade cap to [amt]m", "Set Trade Cap")
			return TRUE
		if("assembly_set_defense_cap")
			var/amt = text2num(params["amount"])
			if(!isnum(amt) || amt < 0)
				return TRUE
			SScity_assembly?.current_warrant?.set_defense_cap(round(amt))
			SScity_assembly?.current_warrant?.refresh_for_day()
			admin_log_fiscal("set Alderman defense cap to [amt]p", "Set Defense Cap")
			return TRUE
		if("assembly_promote_alderman")
			if(!SScity_assembly)
				return TRUE
			var/mob/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			SScity_assembly.promote_to_alderman(target)
			admin_log_fiscal("force-promoted [key_name(target)] to Alderman", "Force Alderman")
			return TRUE
		if("assembly_demote_alderman")
			if(!SScity_assembly)
				return TRUE
			var/mob/living/carbon/human/outgoing = SScity_assembly.resolve_get_alderman()
			var/departing_name = istype(outgoing) ? outgoing.real_name : null
			var/departing_job = istype(outgoing) ? outgoing.job : null
			SScity_assembly.demote_alderman("admin removal")
			SScity_assembly.notify_alderman_lost_ref(departing_name, departing_job, "admin")
			admin_log_fiscal("force-demoted current Alderman", "Force Demote")
			return TRUE
		if("assembly_censure")
			if(!SScity_assembly)
				return TRUE
			var/mob/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			SScity_assembly.apply_censure(target)
			admin_log_fiscal("censured [key_name(target)]", "Assembly Censure")
			return TRUE
		if("assembly_clear_censure")
			if(!SScity_assembly)
				return TRUE
			var/mob/target = locate(params["ref"])
			if(!istype(target))
				return TRUE
			REMOVE_TRAIT(target, TRAIT_ALDERMAN_CENSURED, "assembly")
			admin_log_fiscal("cleared censure on [key_name(target)]", "Clear Censure")
			return TRUE
		if("force_arrears")
			if(SStreasury.treasury_state != TREASURY_NORMAL)
				to_chat(usr, span_warning("Treasury is not currently solvent."))
				return TRUE
			var/projected = 0
			if(SStreasury.steward_machine)
				for(var/job_name in SStreasury.steward_machine.daily_payments)
					var/payment = SStreasury.steward_machine.daily_payments[job_name]
					for(var/mob/living/carbon/human/H in GLOB.human_list)
						if(H.job == job_name && !HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
							projected += payment
			SStreasury.enter_arrears(projected)
			admin_log_fiscal("force-triggered Crown arrears", "Force Arrears")
			return TRUE
		if("force_bankruptcy")
			if(SStreasury.treasury_state == TREASURY_BANKRUPTCY)
				to_chat(usr, span_warning("Already in receivership."))
				return TRUE
			SStreasury.enter_bankruptcy()
			admin_log_fiscal("force-declared Crown bankruptcy / receivership", "Force Bankruptcy")
			return TRUE
		if("force_recovery")
			if(SStreasury.treasury_state == TREASURY_NORMAL)
				to_chat(usr, span_warning("Treasury is already solvent."))
				return TRUE
			SStreasury.treasury_debt = 0
			GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = 0
			SStreasury.clear_treasury_debt_state()
			admin_log_fiscal("force-cleared treasury debt and recovered solvency", "Force Recovery")
			return TRUE
		if("concession_restore")
			var/decree_id = params["decree_id"]
			if(!decree_id)
				return TRUE
			if(SStreasury.bankruptcy_concession_picks <= 0)
				to_chat(usr, span_warning("No concession picks remaining."))
				return TRUE
			if(SStreasury.restore_charter_via_concession(decree_id))
				admin_log_fiscal("used concession pick to restore [decree_id]", "Concession Restore")
			return TRUE
		if("take_atc_loan")
			var/amount = text2num(params["amount"])
			if(!isnum(amount))
				return TRUE
			if(SStreasury.take_atc_loan(amount, usr))
				admin_log_fiscal("drew an ATC emergency loan of [amount]m", "ATC Loan")
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

