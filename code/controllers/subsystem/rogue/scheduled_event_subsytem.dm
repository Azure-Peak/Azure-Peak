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
	load_fog_schedule()
	if(check_schedule_new())
		schedule_fog()

	/// UNCOMMENT BELOW FOR DEBUGGING PURPOSES, ENABLES FOG REGARDLESS OF SCHEDULER ///

	// fog_timer_id = addtimer(CALLBACK(src, .proc/trigger_fog_event), 1 MINUTES, TIMER_STOPPABLE)
	// addtimer(CALLBACK(src, .proc/delayed_tech_unlock), 1 MINUTES)
	// fog_scheduled = TRUE

/datum/controller/subsystem/event_scheduler/proc/schedule_fog(var/delayinminutes = 40)
	if(fog_scheduled || fog_active)
		return

	var/fogtime = delayinminutes MINUTES
	fog_scheduled = TRUE
	priority_announce("The fog looms over the hills in the distance. The Peaks are hungry tonight.\n\n\
	- The fog is lethal, do not venture forth without a fog-repelling lamptern. These relics protect those in their light.\n\
	- Necran clergy may ward off the fog or perform rituals to safeguard entire areas.\n\
	- Lampterns are not eternal, they must be refilled with blessed, golden-colored oils.", 
	"Azure Peak Weather")
	addtimer(CALLBACK(src, .proc/delayed_tech_unlock), 1 MINUTES)
	fog_timer_id = addtimer(CALLBACK(src, .proc/trigger_fog_event), fogtime, TIMER_STOPPABLE)

/datum/controller/subsystem/event_scheduler/proc/trigger_fog_event()
	fog_active = TRUE
	SSParticleWeather.run_weather(/datum/particle_weather/fog/necra, TRUE)
	priority_announce("The fog bellows in from over the hills, coating the peaks in ominous hue.\n\n\
	- The fog is lethal; do not venture forth without a fog-repelling lamptern. These relics protect those in their light.\n\
	- Necran clergy may ward off the fog or perform rituals to safeguard entire areas.\n\
	- Lampterns are not eternal; they must be refilled with blessed, golden-colored oils.", 
	"Azure Peak Weather")

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
	stop_active_fog()

/datum/controller/subsystem/event_scheduler/proc/stop_active_fog()
	fog_active = FALSE
	SSParticleWeather.stopWeather()
	SEND_SIGNAL(src, COMSIG_FOG_END)
	priority_announce("The fog dissipates as quickly as it arrived. The sun returns.", "Azure Peak Weather")

/datum/controller/subsystem/event_scheduler/ui_interact(mob/user)
	var/dat = "<html><head><style>"
	dat += "body { font-family: Verdana; background-color: #1a1a1a; color: #fff; padding: 10px; }"
	dat += "table { width: 100%; border-collapse: collapse; margin-top: 10px; }"
	dat += "td, th { padding: 8px; border: 1px solid #444; text-align: left; }"
	dat += "th { background-color: #333; }"
	dat += ".edit-btn { color: #44ff44; text-decoration: none; font-weight: bold; }"
	dat += ".stop-btn { color: #ff4444; text-decoration: none; font-weight: bold; border: 1px solid #ff4444; padding: 5px; display: inline-block; margin-right: 5px; }"
	dat += ".force-btn { color: #ffcc00; text-decoration: none; font-weight: bold; border: 1px solid #ffcc00; padding: 5px; display: inline-block; }"
	dat += ".status-box { background: #222; padding: 10px; border: 1px solid #555; margin-bottom: 10px; }"
	dat += ".info-text { font-size: 0.85em; color: #aaa; margin-top: 5px; }"
	dat += "</style></head><body>"

	var/server_time = time2text(world.timeofday, "hh:mm")
	var/server_day = uppertext(time2text(world.timeofday, "Day"))

	dat += "<h2>Fog Status</h2>"
	dat += "<div class='status-box'>"
	dat += "<b>Server Time:</b> [server_day], [server_time]<br>"
	dat += "<b>Status:</b> [fog_active ? "<b style='color:red'>ACTIVE</b>" : (fog_scheduled ? "<b style='color:orange'>SCHEDULED</b>" : "<b style='color:gray'>INACTIVE</b>")]<br><br>"

	if(fog_active)
		dat += "<a class='stop-btn' href='?src=[REF(src)];stop_active=1'>STOP ACTIVE FOG</a>"
	else if(fog_scheduled)
		dat += "<a class='stop-btn' href='?src=[REF(src)];cancel_scheduled=1'>CANCEL PLANNED FOG</a>"
	else
		dat += "<a class='force-btn' href='?src=[REF(src)];force_start=1'>FORCE START FOG</a>"
		dat += "<div class='info-text' style='color:#ff4444'>Warning: Starting an unscheduled fog round may break mid-round mechanics.</div>"
	dat += "</div>"

	dat += "<h2>Schedule Manager</h2>"
	dat += "<div class='info-text'>Fog triggers automatically if a round starts within the window: <b>30m before</b> to <b>3.5h after</b> the scheduled time.</div>"
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
	dat += "<p class='info-text'><i>Format: HH:MM (24h). Leave blank to disable.</i></p>"
	dat += "</body></html>"

	user << browse(dat, "window=fog_admin_panel;size=420x550")

/datum/controller/subsystem/event_scheduler/Topic(href, href_list)
	if(..()) return
	if(!check_rights(R_ADMIN)) return

	if(href_list["stop_active"])
		stop_active_fog()
		log_admin("[key_name(usr)] force-stopped the active fog event.")
		ui_interact(usr)

	if(href_list["cancel_scheduled"])
		cancel_fog_planned()
		log_admin("[key_name(usr)] cancelled the scheduled fog event.")
		ui_interact(usr)

	if(href_list["force_start"])
		var/confirm = alert(usr, "CAUTION: Forcing the fog when not scheduled by the table before round start will break some things. Are you sure?", "Force Start Fog", "Yes", "No")
		if(confirm == "Yes")
			var/timer_input = input(usr, "Enter countdown in minutes until fog arrival:", "Fog Timer", 30) as num|null
			if(!isnull(timer_input) && timer_input >= 0)
				schedule_fog(timer_input)
				log_admin("[key_name(usr)] FORCED a fog event with a [timer_input] minute delay.")
		ui_interact(usr)

	if(href_list["edit_day"])
		var/day = href_list["edit_day"]
		var/new_time = input(usr, "Enter new time for [uppertext(day)] (HH:MM format):", "Fog Schedule", fog_schedule[day]) as text|null
		if(!isnull(new_time))
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

	if(!time_str || time_str == "")
		return FALSE

	var/curr_hh = text2num(time2text(world.timeofday, "hh"))
	var/curr_mm = text2num(time2text(world.timeofday, "mm"))
	
	var/list/split = splittext(time_str, ":")
	var/targ_hh = text2num(split[1])
	var/targ_mm = text2num(split[2])

	var/now_mins = (curr_hh * 60) + curr_mm
	var/targ_mins = (targ_hh * 60) + targ_mm

	var/start_win = targ_mins - 30
	var/end_win = targ_mins + 210

	// var/start_h = (start_win < 0) ? floor((start_win + 1440) / 60) : floor(start_win / 60)
	// var/start_m = (start_win < 0) ? (start_win + 1440) % 60 : start_win % 60

	// var/end_h = (end_win >= 1440) ? floor((end_win - 1440) / 60) : floor(end_win / 60)
	// var/end_m = (end_win >= 1440) ? (end_win - 1440) % 60 : end_win % 60

	var/result = FALSE

	// Start window is before midnight
	if(start_win < 0)
		if(now_mins >= (start_win + 1440) || now_mins <= end_win)
			result = TRUE

	// End window is after midnight
	else if(end_win > 1440)
		if(now_mins >= start_win || now_mins <= (end_win - 1440))
			result = TRUE
			
	// Standard daytime window
	else
		if(now_mins >= start_win && now_mins <= end_win)
			result = TRUE

	//to_chat(world, span_userdanger("FOG DEBUG: Time [curr_hh]:[curr_mm] | Target [targ_hh]:[targ_mm] | Window: [start_h]:[start_m] to [end_h]:[end_m] | Result: [result]"))
	return result

/client/proc/manage_fog_schedule()
	set name = "Manage Fog Schedule"
	set category = "-GameMaster-"
	if(!holder)
		return

	SSevent_scheduler.ui_interact(src)

/datum/controller/subsystem/event_scheduler/proc/delayed_tech_unlock()
	var/tech_id = "SANCTIFIED_LAMPTERNS"
	SSchimeric_tech.admin_force_unlock(tech_id, TRUE)
