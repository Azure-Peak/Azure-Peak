GLOBAL_DATUM_INIT(ssd_indicator, /mutable_appearance, mutable_appearance('icons/mob/ssd_indicator.dmi', "default0", FLY_LAYER))
GLOBAL_LIST_INIT(disconnected_admin_alert_role_times, list(
	// "Grand Duke" = 10 MINUTES,
))

#define DEFAULT_DISCONNECTED_ADMIN_ALERT_TIME 30 MINUTES

/mob/living/proc/set_ssd_indicator(state)
	if(state && stat != DEAD)
		add_overlay(GLOB.ssd_indicator)
	else
		cut_overlay(GLOB.ssd_indicator)
	return state

/mob/living/proc/get_ssd_examine_text(m3)
	if(client || !last_logout_time || stat == DEAD || HAS_TRAIT(src, TRAIT_NOSSDINDICATOR))
		return
	return span_warning("[m3] been in a deep slumber for [DisplayTimeText(world.time - last_logout_time, 1)].")

/mob/living/proc/queue_disconnected_admin_alert()
	cancel_disconnected_admin_alert()
	var/alert_time = get_disconnected_admin_alert_time()
	if(!alert_time)
		return
	disconnected_admin_alert_timer = addtimer(CALLBACK(src, PROC_REF(disconnected_admin_alert)), alert_time, TIMER_STOPPABLE)

/mob/living/proc/cancel_disconnected_admin_alert()
	if(disconnected_admin_alert_timer)
		deltimer(disconnected_admin_alert_timer)
		disconnected_admin_alert_timer = null

/mob/living/proc/disconnected_admin_alert()
	disconnected_admin_alert_timer = null
	if(client || !last_logout_time || stat == DEAD || disconnected_admin_alert_sent || HAS_TRAIT(src, TRAIT_NOSSDINDICATOR) || QDELETED(src))
		return
	if(!ishuman(src))
		return
	disconnected_admin_alert_sent = TRUE
	var/fartravel_link = "(<a href='?_src_=holder;[HrefToken(TRUE)];ssd_sendbacktolobby=[REF(src)]'>Fartravel</a>)"
	message_admins(span_adminnotice("[ADMIN_LOOKUPFLW(src)] ([get_disconnected_admin_alert_job_name()]) has been in a deep slumber for [DisplayTimeText(world.time - last_logout_time, 1)]. [fartravel_link]"))

/mob/living/proc/get_disconnected_admin_alert_time()
	var/role_name = get_disconnected_admin_alert_role_name()
	if(role_name in GLOB.disconnected_admin_alert_role_times)
		return GLOB.disconnected_admin_alert_role_times[role_name]
	return DEFAULT_DISCONNECTED_ADMIN_ALERT_TIME

/mob/living/proc/get_disconnected_admin_alert_role_name()
	return mind?.assigned_role ? mind.assigned_role : job

/mob/living/proc/get_disconnected_admin_alert_job_name()
	var/role_name = get_disconnected_admin_alert_role_name()
	if(advjob && role_name && advjob != role_name)
		return "[role_name] / [advjob]"
	if(role_name)
		return role_name
	if(advjob)
		return advjob
	return "Unknown job"

#undef DEFAULT_DISCONNECTED_ADMIN_ALERT_TIME

