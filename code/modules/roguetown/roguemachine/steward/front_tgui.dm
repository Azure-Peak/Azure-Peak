/datum/steward_front_panel
	var/obj/structure/roguemachine/steward/host

/datum/steward_front_panel/New(obj/structure/roguemachine/steward/new_host)
	host = new_host

/datum/steward_front_panel/Destroy()
	host = null
	return ..()

/datum/steward_front_panel/ui_host(mob/user)
	return host

/datum/steward_front_panel/ui_state(mob/user)
	return GLOB.human_adjacent_state

/datum/steward_front_panel/ui_status(mob/user, datum/ui_state/state)
	if(QDELETED(host) || host.locked)
		return UI_CLOSE
	return ..()

/datum/steward_front_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NerveMaster")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/steward_front_panel/ui_data(mob/user)
	var/list/data = list()
	data["day"] = ECONOMY_DAY
	data["treasury"] = SStreasury.discretionary_fund?.balance || 0
	data["expected_rural_revenue"] = SStreasury.get_rural_tax_amount() || 0
	data["expected_wage_outlay"] = SStreasury.get_expected_wage_outlay() || 0
	data["sequestration"] = host.sequestration_state()
	data["banditry_projection"] = SSeconomy.preview_banditry_drain()
	data["blockades"] = blockade_rows()

	var/list/events = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		events += list(list(
			"name" = E.name,
			"description" = E.description,
			"days_left" = max(0, E.day_expires - ECONOMY_DAY),
			"shortage_goods" = trade_good_names(E.shortage_goods),
			"glut_goods" = trade_good_names(E.glut_goods),
			"saturation_target" = E.saturation_target,
			"saturation_progress" = E.saturation_progress,
		))
	data["events"] = events

	var/can_draw_loan = (user.job in GLOB.crown_authority_roles)
	data["atc_loan"] = list(
		"available" = (can_draw_loan && SStreasury.atc_loan_available()) ? TRUE : FALSE,
		"can_view" = can_draw_loan ? TRUE : FALSE,
		"min" = ATC_LOAN_MIN_AMOUNT,
		"max" = ATC_LOAN_MAX_AMOUNT,
		"closed_day" = ATC_LOAN_CLOSED_DAY,
		"interest_pct" = round(ATC_LOAN_INTEREST_RATE * 100),
		"blocker" = SStreasury.atc_loan_blocker_reason() || "",
		"arrears_consumed" = SStreasury.atc_loan_arrears_consumed ? TRUE : FALSE,
		"loans_drawn" = SStreasury.atc_loans_drawn_this_round,
		"outstanding" = SStreasury.atc_loan_arrears_consumed ? SStreasury.treasury_debt : 0,
	)
	return data

/datum/steward_front_panel/proc/blockade_rows()
	var/list/by_route = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/trade_subroute/subroute_path = B.subroute
		var/route = initial(subroute_path.route)
		var/list/legs = by_route[route]
		if(!legs)
			legs = list()
			by_route[route] = legs
		var/list/regions = list()
		for(var/datum/economic_region/region as anything in B.get_regions())
			regions += region.name
		var/datum/quest_faction/F = B.get_faction()
		legs += list(list(
			"name" = B.get_name(),
			"threat_region" = B.threat_region_name,
			"raiders" = F ? capitalize(F.name_plural) : "",
			"regions" = regions,
		))
	var/list/rows = list()
	for(var/route in by_route)
		rows += list(list("name" = get_route_name(route), "legs" = by_route[route]))
	return rows

/datum/steward_front_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(QDELETED(host) || host.locked || !user.canUseTopic(host, BE_CLOSE))
		return
	switch(action)
		if("open_window")
			host.open_steward_window(user, params["window"])
		if("print_residency")
			host.print_residency_letter(user)
		if("take_atc_loan")
			if(!(user.job in GLOB.crown_authority_roles))
				to_chat(user, span_warning("Only Crown officials can take loans from the ATC."))
				return
			var/amount = text2num("[params["amount"]]")
			if(!isnum(amount))
				return
			if(SStreasury.take_atc_loan(amount, user))
				playsound(host, 'sound/items/inqslip_sealed.ogg', 70, FALSE, -1)
				host.visible_message(span_notice("[host] stamps a piece of loan paper with an official looking seal."))
			return TRUE

/obj/structure/roguemachine/steward/proc/open_front_tgui(mob/user)
	if(locked)
		to_chat(user, span_warning("It's locked."))
		return
	if(!front_panel)
		front_panel = new(src)
	front_panel.ui_interact(user)
