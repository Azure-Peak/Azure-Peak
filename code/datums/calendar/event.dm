GLOBAL_LIST_EMPTY(calendar_events)

/datum/calendar_event
	var/id
	var/calendar_system = CALENDAR_SYSTEM_AZURIAN
	var/recur_month
	var/recur_day
	var/duration_days = 1
	var/title
	var/desc
	var/reminder
	var/list/reminders
	var/color_tag = "#7c5b10"

/datum/calendar_event/proc/load_from_list(list/entry)
	if(!islist(entry))
		return FALSE
	id = entry["id"]
	if(entry["calendar_system"])
		calendar_system = entry["calendar_system"]
	recur_month = text2num("[entry["recur_month"]]")
	recur_day = text2num("[entry["recur_day"]]")
	if(entry["duration_days"])
		duration_days = max(1, text2num("[entry["duration_days"]]"))
	title = entry["title"]
	desc = entry["desc"]
	if(entry["reminder"])
		reminder = entry["reminder"]
	if(islist(entry["reminders"]))
		reminders = entry["reminders"]
	if(entry["color_tag"])
		color_tag = entry["color_tag"]
	return is_valid()

/datum/calendar_event/proc/is_valid()
	if(!id || !title)
		return FALSE
	if(recur_month < 1 || recur_month > CALENDAR_MONTHS_PER_YEAR)
		return FALSE
	if(recur_day < 1 || recur_day > CALENDAR_DAYS_IN_MONTH)
		return FALSE
	if(recur_day + duration_days - 1 > CALENDAR_DAYS_IN_MONTH)
		return FALSE
	return TRUE

/datum/calendar_event/proc/covers_day(month, day)
	if(month != recur_month)
		return FALSE
	return day >= recur_day && day < (recur_day + duration_days)

/datum/calendar_event/proc/day_index(month, day)
	if(!covers_day(month, day))
		return 0
	return (day - recur_day) + 1

/datum/calendar_event/proc/get_reminder_for_day(month, day)
	var/idx = day_index(month, day)
	if(!idx)
		return null
	if(islist(reminders) && length(reminders) >= idx)
		var/line = reminders[idx]
		if(line)
			return line
	return reminder

/datum/calendar_event/proc/to_ui_list()
	return list(
		"id" = id,
		"calendar_system" = calendar_system,
		"month" = recur_month,
		"day" = recur_day,
		"duration_days" = duration_days,
		"title" = title,
		"desc" = desc,
		"color_tag" = color_tag,
	)
