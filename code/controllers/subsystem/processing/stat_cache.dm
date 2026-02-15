SUBSYSTEM_DEF(statpanel)
	name = "Stat Panel Cache"
	flags = SS_BACKGROUND
	wait = 10
	priority = FIRE_PRIORITY_HUDS
	init_order = INIT_ORDER_TICKER
	runlevels = RUNLEVEL_INIT | RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/base_roundinfo_text
	var/list/admin_roundinfo_text
	var/list/debug_roundinfo_text
	var/list/mc_info_text
	var/list/mc_cache

	var/timeofday_text
	var/ic_date_text
	var/td_info_text

/datum/controller/subsystem/statpanel/Initialize()
	. = ..()
	update_cache()

/datum/controller/subsystem/statpanel/fire()
	update_cache()

/datum/controller/subsystem/statpanel/proc/update_cache()
	var/time_left = SSgamemode.round_ends_at - world.time

	base_roundinfo_text = list(
		"MAP: [SSmapping.config?.map_name || "Loading..."]"
	)

	var/datum/map_config/next_map = SSmapping.next_map_config
	if(next_map)
		base_roundinfo_text += "Next Map: [next_map.map_name]"

	base_roundinfo_text += list(
		"ROUND ID: [GLOB.rogue_round_id || "NULL"]",
		"ROUND TIME: [time2text(STATION_TIME_PASSED(), "hh:mm:ss", 0)]"
	)
	debug_roundinfo_text = list(
		"ROUND TrueTime: [worldtime2text()] [world.time]",
	)
	if(SSgamemode.roundvoteend)
		base_roundinfo_text += "ROUND END: [DisplayTimeText(time_left)]"

	timeofday_text = "TIME: [get_current_ic_time_as_string()]"
	ic_date_text = "IC DATE: [get_current_ic_date_as_string()]"

	admin_roundinfo_text = list(
		SSmigrants.get_status_line(),
	)
	td_info_text = "TIME DILATION: [round(SStime_track.time_dilation_current,1)]% \
	AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, \
	[round(SStime_track.time_dilation_avg,1)]%, \
	[round(SStime_track.time_dilation_avg_slow,1)]%)"
	mc_info_text = list()

	mc_info_text += "CPU: [world.cpu]"
	mc_info_text += "Instances: [num2text(world.contents.len, 10)]"
	mc_info_text += "World Time: [world.time]"

	mc_cache = list()

	for(var/datum/controller/subsystem/SSsub in Master.subsystems)
		SSsub.collecting_stat = TRUE
		SSsub.collected_stat = null
		SSsub.stat_entry("")
		SSsub.collecting_stat = FALSE
		if(SSsub.collected_stat)
			mc_cache += list(SSsub.collected_stat)
