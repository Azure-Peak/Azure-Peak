/proc/load_calendar_events()
	GLOB.calendar_events.Cut()
	if(!fexists(CALENDAR_EVENTS_JSON_PATH))
		log_world("Calendar: no events file at [CALENDAR_EVENTS_JSON_PATH]")
		return
	var/raw = file2text(CALENDAR_EVENTS_JSON_PATH)
	var/list/parsed = safe_json_decode(raw)
	if(!islist(parsed))
		log_world("Calendar: failed to parse [CALENDAR_EVENTS_JSON_PATH]")
		return
	var/list/seen_ids = list()
	for(var/list/entry in parsed)
		var/datum/calendar_event/event = new
		if(!event.load_from_list(entry))
			log_world("Calendar: skipped invalid entry [json_encode(entry)]")
			qdel(event)
			continue
		if(event.id in seen_ids)
			log_world("Calendar: duplicate event id '[event.id]', skipping")
			qdel(event)
			continue
		seen_ids += event.id
		GLOB.calendar_events += event
