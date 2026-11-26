#define LEDGER_PAGE_SIZE 50

/datum/steward_ledger_panel
	var/obj/structure/roguemachine/steward/host
	var/list/views = list()

/datum/steward_ledger_panel/New(obj/structure/roguemachine/steward/new_host)
	host = new_host

/datum/steward_ledger_panel/Destroy()
	host = null
	return ..()

/datum/steward_ledger_panel/ui_host(mob/user)
	return host

/datum/steward_ledger_panel/ui_state(mob/user)
	return GLOB.human_adjacent_state

/datum/steward_ledger_panel/ui_status(mob/user, datum/ui_state/state)
	if(QDELETED(host) || host.locked)
		return UI_CLOSE
	return ..()

/datum/steward_ledger_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		SStreasury.revalue_stockpile_inventory()
		views[user.ckey] = list("view" = "journal", "page" = 1, "filter" = "")
		ui = new(user, src, "StewardLedger")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/steward_ledger_panel/ui_close(mob/user)
	views -= user.ckey

/datum/steward_ledger_panel/ui_data(mob/user)
	var/list/data = list()
	data["treasury"] = SStreasury.discretionary_fund?.balance || 0
	data["ledger_page"] = build_page(user.ckey)
	return data

/datum/steward_ledger_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(QDELETED(host) || host.locked || !user.canUseTopic(host, BE_CLOSE))
		return
	if(action == "open_window")
		host.open_steward_window(user, params["window"])
		return
	var/list/view = views[user.ckey]
	if(!view)
		return
	switch(action)
		if("ledger_page")
			view["page"] = max(1, text2num("[params["page"]]") || 1)
		if("ledger_filter")
			view["filter"] = trim("[params["filter"]]")
			view["page"] = 1
		if("ledger_view")
			var/new_view = "[params["view"]]"
			if(!(new_view in list("journal", "ledger", "trial", "income", "balance", "subsidiary")))
				return
			SStreasury.revalue_stockpile_inventory()
			view["view"] = new_view
			view["page"] = 1
		if("ledger_account")
			var/datum/ledger_account/picked = SStreasury.get_ledger_account("[params["id"]]")
			if(!picked || picked.book != LEDGER_BOOK_CROWN)
				return
			view["account"] = picked.id
		if("ledger_refresh")
			SStreasury.revalue_stockpile_inventory()
		else
			return
	ui.send_update()

/datum/steward_ledger_panel/proc/build_page(ckey)
	var/list/view = views[ckey]
	var/view_mode = view ? (view["view"] || "journal") : "journal"
	var/list/page_data = list("view" = view_mode)
	switch(view_mode)
		if("ledger")
			var/account_id = view ? (view["account"] || LEDGER_CROWN_CASH) : LEDGER_CROWN_CASH
			page_data["chart"] = SStreasury.get_chart_listing(LEDGER_BOOK_CROWN)
			page_data["account_ledger"] = SStreasury.get_account_ledger(account_id, 100)
			return page_data
		if("trial")
			page_data["trial_balance"] = SStreasury.get_trial_balance(LEDGER_BOOK_CROWN)
			page_data["reconciliation"] = SStreasury.reconcile_ledger(LEDGER_BOOK_CROWN)
			return page_data
		if("income")
			page_data["income_statement"] = SStreasury.get_income_statement(LEDGER_BOOK_CROWN)
			return page_data
		if("balance")
			page_data["balance_sheet"] = SStreasury.get_balance_sheet(LEDGER_BOOK_CROWN)
			return page_data
		if("subsidiary")
			page_data["subsidiary"] = SStreasury.get_subsidiary_ledgers()
			return page_data

	var/page = max(1, view ? (view["page"] || 1) : 1)
	var/filter = view ? (view["filter"] || "") : ""
	var/window_start = (page - 1) * LEDGER_PAGE_SIZE + 1
	var/window_end = page * LEDGER_PAGE_SIZE
	var/list/entries = list()
	var/matched = 0
	var/total = length(SStreasury.ledger)
	var/crown_name = SStreasury.discretionary_fund?.name
	for(var/i = total to 1 step -1)
		var/datum/treasury_entry/E = SStreasury.ledger[i]
		if(E.legs)
			if(!E.touches_book(LEDGER_BOOK_CROWN))
				continue
		else if(crown_name && E.from_name != crown_name && E.to_name != crown_name)
			continue
		if(filter && !findtext(E.reason, filter) && !findtext(E.from_name, filter) && !findtext(E.to_name, filter))
			continue
		matched++
		if(matched < window_start)
			continue
		if(matched > window_end)
			break
		entries += list(SStreasury.journal_entry_view(E, LEDGER_BOOK_CROWN))
	page_data["entries"] = entries
	page_data["page"] = page
	page_data["page_size"] = LEDGER_PAGE_SIZE
	page_data["shown"] = length(entries)
	page_data["has_more"] = (matched > window_end) ? TRUE : FALSE
	page_data["filtered"] = filter ? TRUE : FALSE
	return page_data

/obj/structure/roguemachine/steward/proc/open_ledger_tgui(mob/user)
	if(locked)
		to_chat(user, span_warning("It's locked."))
		return
	if(!ledger_panel)
		ledger_panel = new(src)
	ledger_panel.ui_interact(user)

#undef LEDGER_PAGE_SIZE
