SUBSYSTEM_DEF(event_scheduler)
	name = "Event Scheduler"
	flags = SS_NO_FIRE
	var/fog_active = FALSE
	var/fog_scheduled = FALSE
	var/fog_json_path = "data/fog_schedule.json"
	var/list/fog_schedule = list()
	var/fog_timer_id

/datum/controller/subsystem/event_scheduler/Initialize()
	. = ..()
	show_current_datetime()
	load_fog_schedule()
	if(check_schedule_new())
		schedule_fog()
		addtimer(CALLBACK(src, .proc/delayed_tech_unlock), 1 MINUTES)

	/// UNCOMMENT BELOW FOR DEBUGGING PURPOSES, ENABLES FOG REGARDLESS OF SCHEDULER ///

	// fog_timer_id = addtimer(CALLBACK(src, .proc/trigger_fog_event), 1 MINUTES, TIMER_STOPPABLE)
	// addtimer(CALLBACK(src, .proc/delayed_tech_unlock), 1 MINUTES)
	// fog_scheduled = TRUE

/datum/controller/subsystem/event_scheduler/proc/schedule_fog()
	if(fog_scheduled || fog_active)
		return

	fog_scheduled = TRUE
	priority_announce("The fog looms over the hills in the distance. The Peak is hungry tonight.", "Azure Peak Weather")
	fog_timer_id = addtimer(CALLBACK(src, .proc/trigger_fog_event), 30 MINUTES, TIMER_STOPPABLE)

/datum/controller/subsystem/event_scheduler/proc/trigger_fog_event()
	fog_active = TRUE
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

/datum/controller/subsystem/event_scheduler/proc/cancel_fog_planned()
	fog_scheduled = FALSE
	if(fog_timer_id)
		deltimer(fog_timer_id)
		fog_timer_id = null
	priority_announce("The omen of the fog has passed. The skies remain clear.", "Azure Peak Weather")

/datum/controller/subsystem/event_scheduler/proc/stop_active_fog()
	fog_active = FALSE
	SSParticleWeather.stopWeather()
	priority_announce("The fog dissipates as quickly as it arrived. The sun returns.", "Azure Peak Weather")

/datum/controller/subsystem/event_scheduler/ui_interact(mob/user)
	var/dat = "<html><head><style>"
	dat += "body { font-family: Verdana; background-color: #1a1a1a; color: #fff; padding: 10px; }"
	dat += "table { width: 100%; border-collapse: collapse; margin-top: 10px; }"
	dat += "td, th { padding: 8px; border: 1px solid #444; text-align: left; }"
	dat += "th { background-color: #333; }"
	dat += ".edit-btn { color: #44ff44; text-decoration: none; font-weight: bold; }"
	dat += ".stop-btn { color: #ff4444; text-decoration: none; font-weight: bold; border: 1px solid #ff4444; padding: 5px; display: inline-block; margin-right: 5px; }"
	dat += ".status-box { background: #222; padding: 10px; border: 1px solid #555; margin-bottom: 10px; }"
	dat += "</style></head><body>"

	dat += "<h2>Fog Status</h2>"
	dat += "<div class='status-box'>"
	dat += "Current Status: [fog_active ? "<b style='color:red'>ACTIVE</b>" : (fog_scheduled ? "<b style='color:orange'>SCHEDULED</b>" : "<b style='color:gray'>INACTIVE</b>")]<br><br>"

	if(fog_active)
		dat += "<a class='stop-btn' href='?src=[REF(src)];stop_active=1'>STOP ACTIVE FOG</a>"
	if(fog_scheduled)
		dat += "<a class='stop-btn' href='?src=[REF(src)];cancel_scheduled=1'>CANCEL PLANNED FOG</a>"
	dat += "</div>"

	dat += "<h2>Schedule Manager</h2>"
	dat += "<table><tr><th>Day</th><th>Time</th><th>Action</th></tr>"
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

	if(href_list["stop_active"])
		stop_active_fog()
		log_admin("[key_name(usr)] force-stopped the active fog event.")
		ui_interact(usr)

	if(href_list["cancel_scheduled"])
		cancel_fog_planned()
		log_admin("[key_name(usr)] cancelled the scheduled fog event.")
		ui_interact(usr)

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

// /datum/controller/subsystem/event_scheduler/proc/check_schedule_new()
// 	var/weekday = lowertext(time2text(world.timeofday, "Day")) 
// 	var/time_str = fog_schedule[weekday]
// 	to_chat(world, span_userdanger("FOG DEBUG: System checking schedule for: [weekday]"))

// 	if(!time_str)
// 		to_chat(world, span_userdanger("FOG DEBUG: No time string found in JSON for today."))
// 		return FALSE

// 	var/current_ds = (world.timeofday + 1 HOURS) % 24 HOURS
// 	var/list/split = splittext(time_str, ":")
	
// 	if(length(split) < 2) 
// 		to_chat(world, span_userdanger("FOG DEBUG: Time format error for [time_str]. Needs HH:MM."))
// 		return FALSE

// 	var/target_ds = (text2num(split[1]) * 1 HOURS) + (text2num(split[2]) * 1 MINUTES)
	
// 	// Logic for window (30 mins before, 3.5 hours after)
// 	var/start_window = target_ds - 30 MINUTES
// 	var/end_window = target_ds + 210 MINUTES

// 	to_chat(world, span_userdanger("FOG DEBUG: Current Time (DS): [current_ds]"))
// 	to_chat(world, span_userdanger("FOG DEBUG: Target Time (DS): [target_ds] (Window: [start_window] - [end_window])"))

// 	var/result = FALSE
// 	// Midnight Rollover Logic
// 	if(start_window < 0)
// 		to_chat(world, span_userdanger("FOG DEBUG: Handling Midnight Rollover (Start < 0)"))
// 		if(current_ds >= (start_window + 24 HOURS) || current_ds <= end_window)
// 			result = TRUE
// 	else if(end_window > 24 HOURS)
// 		to_chat(world, span_userdanger("FOG DEBUG: Handling Midnight Rollover (End > 24h)"))
// 		if(current_ds >= start_window || current_ds <= (end_window - 24 HOURS))
// 			result = TRUE
// 	else
// 		to_chat(world, span_userdanger("FOG DEBUG: Standard Window Check Logic active."))
// 		if(current_ds >= start_window && current_ds <= end_window)
// 			result = TRUE

// 	to_chat(world, span_userdanger("FOG DEBUG: Final Decision: [result ? "TRUE - TRIGGERING" : "FALSE - SLEEPING"]"))
// 	return result

/datum/controller/subsystem/event_scheduler/proc/check_schedule_new()
	var/weekday = lowertext(time2text(world.timeofday, "Day")) 
	var/time_str = fog_schedule[weekday]

	if(!time_str || time_str == "")
		return FALSE

	// Get current hours and minutes exactly how show_current_datetime does it
	var/curr_hh = text2num(time2text(world.timeofday, "hh"))
	var/curr_mm = text2num(time2text(world.timeofday, "mm"))
	
	// Parse the target
	var/list/split = splittext(time_str, ":")
	var/targ_hh = text2num(split[1])
	var/targ_mm = text2num(split[2])

	// Convert everything to simple minutes past midnight for easy comparison
	var/now_mins = (curr_hh * 60) + curr_mm
	var/targ_mins = (targ_hh * 60) + targ_mm

	// Define the window in minutes (30 mins before, 210 mins after)
	var/start_win = targ_mins - 30
	var/end_win = targ_mins + 210

	to_chat(world, span_userdanger("FOG DEBUG: Clock says [curr_hh]:[curr_mm]. Target is [targ_hh]:[targ_mm]."))
	
	if(now_mins >= start_win && now_mins <= end_win)
		to_chat(world, span_userdanger("FOG DEBUG: MATCH! Decision: TRUE"))
		return TRUE

	to_chat(world, span_userdanger("FOG DEBUG: NO MATCH. Decision: FALSE"))
	return FALSE

/client/proc/manage_fog_schedule()
	set name = "Manage Fog Schedule"
	set category = "-GameMaster-"
	if(!holder)
		return

	SSevent_scheduler.ui_interact(src)

/datum/controller/subsystem/event_scheduler/proc/delayed_tech_unlock()
	var/tech_id = "SANCTIFIED_LAMPTERNS"
	SSchimeric_tech.admin_force_unlock(tech_id, TRUE)
