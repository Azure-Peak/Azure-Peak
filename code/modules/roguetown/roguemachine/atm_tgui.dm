/obj/structure/roguemachine/atm/proc/build_log_entries(account_name)
	var/list/out = list()
	for(var/datum/treasury_entry/E as anything in SStreasury.get_account_log(account_name))
		var/direction = "neutral"
		var/counterparty = ""
		if(E.kind == "transfer")
			if(E.from_name == account_name)
				direction = "out"
				counterparty = E.to_name
			else
				direction = "in"
				counterparty = E.from_name
		else if(E.kind == "mint" && E.to_name == account_name)
			direction = "in"
		else if(E.kind == "burn" && E.from_name == account_name)
			direction = "out"
		out += list(list(
			"kind" = E.kind,
			"direction" = direction,
			"counterparty" = counterparty,
			"amount" = E.amount,
			"reason" = E.reason || "",
		))
	return out

/obj/structure/roguemachine/atm/proc/open_meister_tgui(mob/user)
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "MeisterPanel")
		ui.open()

/obj/structure/roguemachine/atm/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/atm/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)

/obj/structure/roguemachine/atm/ui_static_data(mob/user)
	var/mob/living/carbon/human/H = user
	var/list/data = list()
	data["max_issuance_day"] = SStreasury.loan_max_issuance_day
	data["poll_tax_static"] = list(
		"max_advance_days" = POLL_TAX_MAX_ADVANCE_DAYS,
		"fallback_rate" = POLL_TAX_ADVANCE_FALLBACK_RATE,
	)
	var/poll_category = istype(H) ? SStreasury.get_poll_tax_category(H) : null
	data["poll_tax_user"] = list(
		"category" = poll_category || "",
		"category_label" = poll_category ? SStreasury.get_poll_tax_category_pretty_name(poll_category) : "",
	)
	var/list/funds = list()
	var/list/patron_rosters_static = list()
	for(var/fid in ALL_FUND_IDS)
		var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
		var/datum/fund/F = SStreasury.resolve_fund_by_id(fid)
		if(!F)
			continue
		funds += list(list(
			"id" = fid,
			"label" = SStreasury.indenture_faction_label(F),
			"name" = F.name,
			"can_issue" = (V && V.can_issue_loan(user)) ? TRUE : FALSE,
			"can_withdraw" = (V && V.can_withdraw(user)) ? TRUE : FALSE,
			"can_view" = (V && V.can_view(user)) ? TRUE : FALSE,
			"supports_loans" = V ? (V.supports_loans ? TRUE : FALSE) : TRUE,
			"allow_zero_rate" = (V && (0 in V.allowed_rates())) ? TRUE : FALSE,
			"authority_label" = V ? V.get_authority_label() : "",
			"withdraw_rule" = V ? V.get_withdraw_rule_text() : "",
			"has_patronage" = (V && !isnull(V.get_patronage_writ_path())) ? TRUE : FALSE,
			"patron_label" = V ? V.get_patron_label() : "",
			"patron_cap" = V ? V.get_patron_cap() : 0,
		))
		if(V && !isnull(V.get_patronage_writ_path()))
			patron_rosters_static[fid] = list(
				"label" = V.get_patron_label(),
				"cap" = V.get_patron_cap(),
				"can_manage" = V.can_issue_loan(user) ? TRUE : FALSE,
				"explanation" = V.get_patron_explanation(),
			)
	data["funds"] = funds
	data["patron_rosters_static"] = patron_rosters_static
	return data

/obj/structure/roguemachine/atm/ui_data(mob/user)
	var/mob/living/carbon/human/H = user
	var/list/data = list()
	data["account_balance"] = SStreasury.get_balance(H)
	data["day"] = GLOB.dayspassed

	var/datum/loan/active = SStreasury.get_loan_for(H)
	if(active)
		data["active_loan"] = list(
			"principal" = active.principal,
			"interest_pct" = round(active.interest_rate * 100),
			"days_total" = active.days_total,
			"due_on_day" = active.due_on_day,
			"days_until_due" = active.days_until_due(),
			"remaining" = active.get_remaining_due(),
			"defaulted" = active.defaulted ? TRUE : FALSE,
			"creditor" = active.source_fund ? SStreasury.indenture_faction_label(active.source_fund) : "the Crown",
		)
	else
		data["active_loan"] = null

	var/poll_category = SStreasury.get_poll_tax_category(H)
	var/poll_rate = poll_category ? SStreasury.get_poll_tax_rate_for(H, poll_category) : 0
	var/poll_exempt = poll_category ? SStreasury.is_poll_tax_charter_exempt(H, poll_category) : FALSE
	var/existing_advance = SStreasury.poll_tax_advance_days[H] || 0
	data["poll_tax"] = list(
		"rate" = poll_rate,
		"exempt" = poll_exempt ? TRUE : FALSE,
		"advance_days_held" = existing_advance,
	)

	var/has_any_institutional_access = FALSE
	var/has_any_patronage_authority = FALSE
	for(var/fid in ALL_FUND_IDS)
		var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
		if(!V)
			continue
		if(V.can_view(user))
			has_any_institutional_access = TRUE
		if(V.can_issue_loan(user) && !isnull(V.get_patronage_writ_path()))
			has_any_patronage_authority = TRUE

	var/list/fund_balances = list()
	var/list/institutional_loans = list()
	var/list/institutional_logs = list()
	if(has_any_institutional_access)
		for(var/fid in ALL_FUND_IDS)
			var/datum/fund/F = SStreasury.resolve_fund_by_id(fid)
			if(!F)
				continue
			var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
			var/has_access = V && V.can_view(user)
			if(!has_access)
				continue
			fund_balances[fid] = list(
				"balance" = F.balance,
				"outstanding_principal" = SStreasury.get_outstanding_principal_from_fund(F),
			)
			institutional_logs[fid] = build_log_entries(F.name)
			if(V.supports_loans)
				for(var/datum/loan/L in SStreasury.loans)
					if(L.source_fund != F)
						continue
					institutional_loans += list(list(
						"creditor_id" = fid,
						"creditor_label" = SStreasury.indenture_faction_label(F),
						"debtor" = L.debtor_name,
						"is_institutional" = L.is_institutional ? TRUE : FALSE,
						"target_label" = L.target_fund ? SStreasury.indenture_faction_label(L.target_fund) : "",
						"principal" = L.principal,
						"interest_pct" = round(L.interest_rate * 100),
						"due_on_day" = L.due_on_day,
						"days_until_due" = L.days_until_due(),
						"remaining" = L.get_remaining_due(),
						"defaulted" = L.defaulted ? TRUE : FALSE,
					))
	data["fund_balances"] = fund_balances
	data["institutional_loans"] = institutional_loans
	data["institutional_logs"] = institutional_logs

	data["personal_log"] = build_log_entries(H.real_name)
	data["bathhouse_ordinance_active"] = SStreasury.bathhouse_ordinance_active ? TRUE : FALSE
	data["bathhouse_tithe_round_total"] = SStreasury.round_bathhouse_tithe_total
	var/bh_cooldown_left_ds = max(0, SStreasury.bathhouse_ordinance_next_toggle_time - world.time)
	data["bathhouse_ordinance_cooldown_seconds"] = round(bh_cooldown_left_ds / 10)

	var/list/patron_rosters = list()
	if(has_any_patronage_authority)
		for(var/fid in PATRONAGE_FUND_IDS)
			var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fid)
			if(!V || isnull(V.get_patronage_writ_path()))
				continue
			if(!V.can_issue_loan(user))
				continue
			var/list/roster_data = list()
			var/list/roster = V.get_patron_roster()
			if(islist(roster))
				for(var/mob/living/carbon/human/HP in roster)
					if(QDELETED(HP))
						continue
					roster_data += list(list("ref" = REF(HP), "name" = HP.real_name, "job" = HP.job || ""))
			patron_rosters[fid] = list(
				"patrons" = roster_data,
			)
	data["patron_rosters"] = patron_rosters

	return data

/obj/structure/roguemachine/atm/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return TRUE
	if(!H.canUseTopic(src, BE_CLOSE))
		return TRUE
	switch(action)
		if("withdraw_personal")
			handle_withdraw_personal(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("repay_loan")
			handle_repay_loan(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("advance_poll_tax")
			handle_advance_poll_tax(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("withdraw_institutional")
			handle_withdraw_institutional(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("issue_personal")
			handle_issue_personal_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("issue_indenture")
			handle_issue_indenture_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("issue_patronage")
			handle_issue_patronage_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("revoke_patronage")
			handle_revoke_patronage_for_fund(H, params)
			SStgui.update_uis(src)
			return TRUE
		if("toggle_bathhouse_ordinance")
			handle_toggle_bathhouse_ordinance(H)
			SStgui.update_uis(src)
			return TRUE

/obj/structure/roguemachine/atm/proc/handle_toggle_bathhouse_ordinance(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.job != "Bishop" && H.job != "Bathmaster")
		to_chat(H, span_warning("Only the Bishop or the Bathmaster may set the terms of the Ordinance of the Baths."))
		return
	if(world.time < SStreasury.bathhouse_ordinance_next_toggle_time)
		var/remaining_minutes = CEILING((SStreasury.bathhouse_ordinance_next_toggle_time - world.time) / (1 MINUTES), 1)
		to_chat(H, span_warning("The seal is still warm upon the wax. The Ordinance may be reconsidered in [remaining_minutes] minute\s."))
		return
	SStreasury.bathhouse_ordinance_active = !SStreasury.bathhouse_ordinance_active
	SStreasury.bathhouse_ordinance_next_toggle_time = world.time + BATHHOUSE_ORDINANCE_TOGGLE_COOLDOWN
	var/now_active = SStreasury.bathhouse_ordinance_active
	var/title = now_active ? "Ordinance of the Baths Restored" : "Ordinance of the Baths Broken"
	var/msg
	if(now_active)
		if(H.job == "Bishop")
			msg = "By Eora's grace, the Bishop, [H.real_name], hath set anew the seal upon the Ordinance of the Baths. The See extends its sanction over the stews once more, and the tithe shall render unto the Church."
		else
			msg = "By Eora's grace, the Bathmaster, [H.real_name], hath knelt beneath the Ordinance of the Baths. The stews accept the Church's sanction anew, and the tithe shall render unto the Church."
	else
		if(H.job == "Bishop")
			msg = "The Bishop, [H.real_name], hath broken the seal upon the Ordinance of the Baths. The See renounces its sanction; the stews fall again beneath the Crown's tariff."
		else
			msg = "The Bathmaster, [H.real_name], hath broken the seal upon the Ordinance of the Baths. The stews cast off the Church's sanction; their farm returns unto the Crown."
	priority_announce(msg, title, pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
	log_admin("ORDINANCE OF THE BATHS: [key_name(H)] toggled to [now_active ? "IN FORCE" : "BROKEN"].")
	message_admins("[key_name_admin(H)] toggled the Ordinance of the Baths to [now_active ? "IN FORCE" : "BROKEN"].")

/obj/structure/roguemachine/atm/proc/handle_withdraw_personal(mob/living/carbon/human/H, list/params)
	var/coin_amt = round(text2num("[params["amount"]]"))
	var/denom = "[params["denomination"]]"
	if(!(denom in list("GOLD", "SILVER", "BRONZE")))
		to_chat(H, span_warning("Choose a valid denomination."))
		return
	if(isnull(coin_amt) || coin_amt < 1)
		return
	if(coin_amt > 20)
		to_chat(H, span_warning("Maximum 20 coins per withdrawal."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/mod = 1
	if(denom == "GOLD")
		mod = 10
	else if(denom == "SILVER")
		mod = 5
	var/total = coin_amt * mod
	if(SStreasury.get_balance(H) < total)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		to_chat(H, span_warning("Your balance is insufficient."))
		return
	if(!SStreasury.withdraw_money_account(total, H))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	record_round_statistic(STATS_MAMMONS_WITHDRAWN, total)
	budget2change(total, H, denom)
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)

/obj/structure/roguemachine/atm/proc/handle_repay_loan(mob/living/carbon/human/H, list/params)
	var/datum/loan/L = SStreasury.get_loan_for(H)
	if(!L)
		say("No active loan on record.")
		return
	var/pay_amt = round(text2num("[params["amount"]]"))
	if(isnull(pay_amt) || pay_amt < 1)
		return
	var/outstanding = L.get_remaining_due()
	var/balance = SStreasury.get_balance(H)
	pay_amt = min(pay_amt, outstanding, balance)
	if(pay_amt < 1)
		say("Nothing to repay with.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/paid = SStreasury.repay_loan(H, pay_amt)
	if(!paid)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		say("The ledger refused the transfer.")
		return
	playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	if(!SStreasury.get_loan_for(H))
		say("Loan repaid in full. [paid]m transferred.")
	else
		var/datum/loan/still = SStreasury.get_loan_for(H)
		say("[paid]m transferred. [still.get_remaining_due()]m remains.")

/obj/structure/roguemachine/atm/proc/handle_advance_poll_tax(mob/living/carbon/human/H, list/params)
	var/poll_category = SStreasury.get_poll_tax_category(H)
	if(!poll_category)
		say("The Crown does not tax your class.")
		return
	if(SStreasury.is_poll_tax_charter_exempt(H, poll_category))
		say("Your class is exempt from poll tax by decree.")
		return
	var/days = round(text2num("[params["days"]]"))
	if(isnull(days) || days < 1)
		return
	var/eff_rate = SStreasury.get_poll_tax_rate_for(H, poll_category)
	if(eff_rate <= 0)
		eff_rate = POLL_TAX_ADVANCE_FALLBACK_RATE
	var/balance = SStreasury.get_balance(H)
	if(balance <= 0)
		say("Your balance is nothing.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/existing = SStreasury.poll_tax_advance_days[H] || 0
	var/cap_remaining = POLL_TAX_MAX_ADVANCE_DAYS - existing
	if(cap_remaining <= 0)
		say("You already hold the maximum [POLL_TAX_MAX_ADVANCE_DAYS] days of advance.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/affordable = floor(balance / eff_rate)
	days = min(days, cap_remaining, affordable)
	if(days < 1)
		say("You cannot afford a single day at [eff_rate]m.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!SStreasury.poll_tax_pay_advance(H, days))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		say("The ledger refused the advance.")
		return
	playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	say("[days] day\s of poll tax advanced for [H.real_name].")

/obj/structure/roguemachine/atm/proc/handle_withdraw_institutional(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution has no coffers to draw from."))
		return
	if(!V.can_withdraw(H))
		to_chat(H, span_warning("You are not authorised to withdraw from [V.get_patron_label() || V.get_faction_label()]."))
		return
	V.disburse(H, params)

/obj/structure/roguemachine/atm/proc/handle_issue_personal_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution has no coffers to lend from."))
		return
	if(!V.can_issue_loan(H))
		to_chat(H, span_warning("You are not authorised to draft loans for [V.get_faction_label()]."))
		return
	V.draft_personal_loan(H, params)

/obj/structure/roguemachine/atm/proc/handle_issue_indenture_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution has no coffers to lend from."))
		return
	if(!V.can_issue_loan(H))
		to_chat(H, span_warning("You are not authorised to draft indentures for [V.get_faction_label()]."))
		return
	V.draft_indenture(H, params)

/obj/structure/roguemachine/atm/proc/handle_issue_patronage_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		to_chat(H, span_warning("That institution does not extend patronage."))
		return
	if(!V.can_issue_loan(H))
		to_chat(H, span_warning("You are not authorised to draft patronage for [V.get_patron_label()]."))
		return
	V.draft_patronage_writ(H)

/obj/structure/roguemachine/atm/proc/handle_revoke_patronage_for_fund(mob/living/carbon/human/H, list/params)
	var/fund_id = "[params["fund_id"]]"
	var/obj/structure/roguemachine/vaultbank/V = SStreasury.find_jawbank_for_fund_id(fund_id)
	if(!V)
		return
	if(!V.can_issue_loan(H))
		return
	V.revoke_patron(H, params)
