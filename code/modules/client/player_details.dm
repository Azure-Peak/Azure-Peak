/datum/player_details
	var/list/player_actions = list()
	var/list/logging = list()
	var/list/post_login_callbacks = list()
	var/list/post_logout_callbacks = list()
	var/list/played_names = list() //List of names this key played under this round
	var/byond_version = "Unknown"
	var/datum/achievement_data/achievements

/datum/player_details/New(key)
	achievements = new(key)

/datum/player_details/vv_get_var(var_name)
	if(var_name == NAMEOF(src, logging))
		var/list/shown_logs = logging.Copy()
		shown_logs -= "[LOG_SUBTLE]"
		return debug_variable(var_name, shown_logs, 0, src, FALSE)
	return ..()

/datum/player_details/can_vv_get(var_name)
	if(var_name == NAMEOF(src, logging))
		return FALSE
	return ..()

/proc/log_played_names(ckey, ...)
	if(!ckey)
		return
	if(args.len < 2)
		return
	var/list/names = args.Copy(2)
	var/datum/player_details/P = GLOB.player_details[ckey]
	if(P)
		for(var/name in names)
			if(name)
				P.played_names |= name
