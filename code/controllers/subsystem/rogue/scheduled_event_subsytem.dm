SUBSYSTEM_DEF(event_scheduler)
	name = "Event Scheduler"
	flags = SS_NO_FIRE
	var/fog_active = FALSE
	var/fog_scheduled = FALSE
	var/fog_json_path = "data/fog_schedule.json"
	var/list/fog_schedule = list()

/datum/controller/subsystem/event_scheduler/Initialize()
	. = ..()
	show_current_datetime()
	// for testing purposes
	load_fog_schedule()
	check_schedule_new()
	addtimer(CALLBACK(src, .proc/trigger_fog_event), 1 MINUTES)
	fog_scheduled = TRUE

/datum/controller/subsystem/event_scheduler/proc/schedule_fog()
	to_chat(world, span_userdanger("Necra has brought the fog..."))
	// Still using the 30-minute delay before the actual weather hits
	addtimer(CALLBACK(src, .proc/trigger_fog_event), 30 MINUTES)

/datum/controller/subsystem/event_scheduler/proc/trigger_fog_event()
	fog_active = TRUE
	priority_announce("The fog rolls in. The Peak is hungry tonight.", "Azure Peak Weather")
	SSParticleWeather.run_weather(/datum/particle_weather/fog/necra, TRUE)

/proc/show_current_datetime()
	var/dd = text2num(time2text(world.timeofday, "DD"))
	var/mm = text2num(time2text(world.timeofday, "MM"))
	var/yy = text2num(time2text(world.timeofday, "YY"))
	var/hh = text2num(time2text(world.timeofday, "hh"))
	var/min = text2num(time2text(world.timeofday, "mm"))
	var/weekday = time2text(world.timeofday, "Day") // Full day name

	to_chat(world, span_userdanger("Today is [weekday], [mm]/[dd]/20[yy] at [hh]:[min]"))

/datum/controller/subsystem/event_scheduler/proc/update_mob_fog_status(atom/movable/AM, area_is_safe)
	if(!ishuman(AM))
		return

	var/mob/living/carbon/human/H = AM

	if(!H.mind)
		return

	to_chat(H, span_userdanger("HELLO I AM THE COMPONENT YOU ARE IN [area_is_safe] AREA"))
	var/datum/component/fogged/comp = H.GetComponent(/datum/component/fogged)

	if(area_is_safe)
		// If the area is safe, strip the component if they have it
		if(comp)
			qdel(comp)
	else if(!comp)
		H.AddComponent(/datum/component/fogged)

/datum/controller/subsystem/event_scheduler/proc/load_fog_schedule()
	if(!fexists(fog_json_path))
		// Initialize defaults if file is missing
		for(var/day in list("monday","tuesday","wednesday","thursday","friday","saturday","sunday"))
			fog_schedule[day] = ""
		save_fog_schedule()
	else
		fog_schedule = json_decode(file2text(fog_json_path))

/datum/controller/subsystem/event_scheduler/proc/save_fog_schedule()
	if(fexists(fog_json_path))
		fdel(fog_json_path)
	WRITE_FILE(file(fog_json_path), json_encode(fog_schedule))

/datum/controller/subsystem/event_scheduler/ui_interact(mob/user)
	var/dat = "<html><head><style>"
	dat += "body { font-family: Verdana; background-color: #1a1a1a; color: #fff; }"
	dat += "table { width: 100%; border-collapse: collapse; }"
	dat += "td, th { padding: 8px; border: 1px solid #444; text-align: left; }"
	dat += "th { background-color: #333; }"
	dat += ".edit-btn { color: #44ff44; text-decoration: none; font-weight: bold; }"
	dat += "</style></head><body>"

	dat += "<h2>Fog Schedule Manager</h2>"
	dat += "<table><tr><th>Day</th><th>Scheduled Time (24h)</th><th>Action</th></tr>"

	var/list/days = list("monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday")
	for(var/day in days)
		var/time = fog_schedule[day]
		dat += "<tr>"
		dat += "<td><b>[uppertext(day)]</b></td>"
		dat += "<td>[time ? time : "<i>Not Scheduled</i>"]</td>"
		dat += "<td><a class='edit-btn' href='?src=[REF(src)];edit_day=[day]'>\[Edit\]</a></td>"
		dat += "</tr>"

	dat += "</table><br>"
	dat += "<p><i>Format: HH:MM (e.g., 20:00). Leave blank to disable.</i></p>"
	dat += "</body></html>"

	user << browse(dat, "window=fog_admin_panel;size=400x450")

/datum/controller/subsystem/event_scheduler/Topic(href, href_list)
	if(..()) return
	if(!check_rights(R_ADMIN)) return // Ensure only admins can use this

	if(href_list["edit_day"])
		var/day = href_list["edit_day"]
		var/new_time = input(usr, "Enter new time for [uppertext(day)] (HH:MM format):", "Fog Schedule", fog_schedule[day]) as text|null

		if(!isnull(new_time))
			// Basic validation
			if(new_time != "" && !findtext(new_time, ":"))
				to_chat(usr, span_warning("Invalid format! Use HH:MM."))
			else
				fog_schedule[day] = new_time
				save_fog_schedule()
				log_admin("[key_name(usr)] changed the [day] fog schedule to [new_time].")

		ui_interact(usr)

/datum/controller/subsystem/event_scheduler/proc/check_schedule_new()
	var/weekday = lowertext(time2text(world.timeofday, "Day")) 
	var/time_str = fog_schedule[weekday]

	if(!time_str)
		return FALSE

	var/current_ds = MODULUS(REALTIMEOFDAY, 24 HOURS)
	var/list/split = splittext(time_str, ":")
	
	if(length(split) < 2) 
		return FALSE

	var/target_ds = (text2num(split[1]) * 1 HOURS) + (text2num(split[2]) * 1 MINUTES)
	
	// Logic for window (30 mins before, 3.5 hours after)
	var/start_window = target_ds - 30 MINUTES
	var/end_window = target_ds + 210 MINUTES

	// Midnight Rollover Logic
	if(start_window < 0)
		if(current_ds >= (start_window + 24 HOURS) || current_ds <= end_window)
			return TRUE
	else if(end_window > 24 HOURS)
		if(current_ds >= start_window || current_ds <= (end_window - 24 HOURS))
			return TRUE
	else
		if(current_ds >= start_window && current_ds <= end_window)
			return TRUE

	return FALSE

/client/proc/manage_fog_schedule()
	set name = "Manage Fog Schedule"
	set category = "-GameMaster-"
	if(!holder)
		return

	SSevent_scheduler.ui_interact(src)
