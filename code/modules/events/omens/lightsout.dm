/datum/round_event_control/lightsout
	name = "Lights Out"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/lightsout
	weight = 5
	max_occurrences = 1
	min_players = 0
	req_omen = TRUE
	todreq = list("dusk", "night")

/datum/round_event/lightsout
	announceWhen	= 1

/datum/round_event/lightsout/setup()
	return

/datum/round_event/lightsout/start()
	if(LAZYLEN(GLOB.fires_list))
		for(var/obj/fire in GLOB.fires_list)
			INVOKE_ASYNC(fire, TYPE_PROC_REF(/obj, extinguish))
	if(LAZYLEN(GLOB.streetlamp_list))
		for(var/obj/machinery/light/roguestreet/light in GLOB.streetlamp_list)
			INVOKE_ASYNC(light, TYPE_PROC_REF(/obj/machinery/light/roguestreet, lights_out))
	return
