SUBSYSTEM_DEF(event_scheduler)
	name = "Event Scheduler"
	flags = SS_NO_FIRE
	var/fog_active = FALSE

/datum/controller/subsystem/event_scheduler/Initialize()
	. = ..()
	show_current_datetime()
	// for testing purposes
	addtimer(CALLBACK(src, .proc/trigger_fog_event), 1 MINUTES)

/datum/controller/subsystem/event_scheduler/proc/schedule_fog(storyteller_name)
	to_chat(world, span_userdanger("[storyteller_name] has brought the fog..."))
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
