/proc/log_admin_view(target, phrase)
	var/static/list/recent_views = list()
	if(!usr?.client?.holder)
		return
	var/subject = (ismob(target) || istype(target, /client)) ? key_name(target) : "[target]"
	var/key = "[usr.ckey]|[subject]|[phrase]"
	if(recent_views[key] > world.time)
		return
	recent_views[key] = world.time + 5 MINUTES // Prevent repetitively spamming log everytime they open the same view
	log_admin("[subject] [phrase] by [key_name(usr)].")
