/client/proc/open_calendar_ui()
	if(!mob)
		return
	var/datum/calendar_ui/ui = new(src)
	ui.ui_interact(mob)

/datum/calendar_ui
	var/client/owner
	var/view_month
	var/view_year
	var/wrap_count = 0

/datum/calendar_ui/New(client/C)
	owner = C
	var/list/parts = resolve_ic_date_parts(GLOB.dayspassed)
	view_month = parts[2]
	view_year = parts[3]

/datum/calendar_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Calendar", "Calendar")
		ui.open()

/datum/calendar_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/calendar_ui/ui_data(mob/user)
	var/list/parts = resolve_ic_date_parts(GLOB.dayspassed)
	var/today_day = parts[1]
	var/today_month = parts[2]
	var/today_year = parts[3]
	var/today_week = CEILING(today_day / CALENDAR_DAYS_IN_WEEK, 1)

	var/list/months_meta = list()
	for(var/i in 1 to CALENDAR_MONTHS_PER_YEAR)
		months_meta += list(list(
			"number" = i,
			"name" = get_month_number_to_text(i),
			"season" = get_season_from_month(i),
			"phase" = get_season_phase(i),
		))

	var/list/events_in_view = list()
	for(var/datum/calendar_event/event in get_calendar_events_for_month(view_month))
		events_in_view += list(event.to_ui_list())

	return list(
		"today_day" = today_day,
		"today_month" = today_month,
		"today_year" = today_year,
		"today_week" = today_week,
		"view_month" = view_month,
		"view_year" = view_year,
		"weekday_names" = list("Moon's", "Truce's", "Wedding's", "Thunder's", "Feast's", "Psydon's", "Sun's"),
		"days_in_month" = CALENDAR_DAYS_IN_MONTH,
		"days_in_week" = CALENDAR_DAYS_IN_WEEK,
		"months" = months_meta,
		"events" = events_in_view,
		"wrap_count" = wrap_count,
	)

/datum/calendar_ui/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("prev_month")
			if(view_month <= 1)
				view_month = CALENDAR_MONTHS_PER_YEAR
				wrap_count++
			else
				view_month--
			return TRUE
		if("next_month")
			if(view_month >= CALENDAR_MONTHS_PER_YEAR)
				view_month = 1
				wrap_count++
			else
				view_month++
			return TRUE
		if("jump_month")
			var/target = text2num("[params["month"]]")
			if(target >= 1 && target <= CALENDAR_MONTHS_PER_YEAR)
				view_month = target
				return TRUE
		if("today")
			var/list/parts = resolve_ic_date_parts(GLOB.dayspassed)
			view_month = parts[2]
			view_year = parts[3]
			wrap_count = 0
			return TRUE

/datum/calendar_ui/ui_close(mob/user)
	qdel(src)
