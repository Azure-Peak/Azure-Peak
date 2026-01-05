GLOBAL_LIST_EMPTY(TodUpdate)

SUBSYSTEM_DEF(nightshift)
	name = "Night Shift"
	wait = 10 SECONDS
	flags = SS_NO_TICK_CHECK
	priority = 1
	var/current_tod = null

	var/nightshift_active = FALSE
	var/nightshift_start_time = 576000	//4pm	//702000=7:30 PM, station time
	var/nightshift_dawn_start = 288000		//198000=    530am
	var/nightshift_day_start = 360000		//270000=    730am
	var/nightshift_dusk_start = 504000		//630000=    530pm

	/* Default STONEKEEP config.
	var/nightshift_start_time = 756000	//9:00 PM - 2100 hrs
	var/nightshift_dawn_start = 216000	//6:00 AM - 0600 hrs
	var/nightshift_day_start = 324000	//9:00 AM - 0900 hrs
	var/nightshift_dusk_start = 648000	//6:00 PM - 1800 hrs
	*/

	//1hr = 36000
	//30m = 18000

	var/nightshift_first_check = 2 SECONDS

	var/high_security_mode = FALSE

/datum/controller/subsystem/nightshift/Initialize()
	if(!CONFIG_GET(flag/enable_night_shifts))
		can_fire = FALSE
	current_tod = settod()
	return ..()

/datum/controller/subsystem/nightshift/fire(resumed = FALSE)
	if(world.time - SSticker.round_start_time < nightshift_first_check)
		return
	check_nightshift()

/datum/controller/subsystem/nightshift/proc/announce(message)
	priority_announce(message, sound='sound/misc/bell.ogg')

/datum/controller/subsystem/nightshift/proc/check_nightshift()
//	var/emergency = GLOB.security_level >= SEC_LEVEL_RED
//	var/announcing = FALSE
//	var/time = station_time()
/*	var/night_time = (time < nightshift_day_start) || (time > nightshift_dusk_start) || (settod() in list("night", "dawn", "dusk"))
	if(high_security_mode != emergency)
		high_security_mode = emergency
		if(night_time)
			announcing = FALSE
			if(!emergency)
				announce("Restoring night lighting configuration to normal operation.")
			else
				announce("Disabling night lighting: Station is in a state of emergency.")
	if(emergency)
		night_time = FALSE
	if(nightshift_active != night_time)
		update_nightshift(night_time, announcing)*/
	var/curtod = settod()
	if(current_tod != curtod)

		current_tod = GLOB.tod
		update_nightshift()

/datum/controller/subsystem/nightshift/proc/update_nightshift()
	set waitfor = FALSE
	for(var/obj/A in GLOB.TodUpdate)
		A.update_tod(GLOB.tod)
	for(var/mob/living/M in GLOB.mob_list)
		M.update_tod(GLOB.tod)

/obj/proc/update_tod(todd)
	return

/mob/living/proc/update_tod(todd)
	return

/mob/living/carbon/human/update_tod(todd)
	if(client)
		var/area/areal = get_area(src)
		if(!cmode)
			SSdroning.play_area_sound(areal, src.client)
		SSdroning.play_loop(areal, src.client)
	if(mode != NPC_AI_OFF)
		return
	switch(todd)
		if("day")
			if(HAS_TRAIT(src, TRAIT_VAMP_DREAMS))
				apply_status_effect(/datum/status_effect/debuff/vamp_dreams)
			if(HAS_TRAIT(src, TRAIT_NIGHT_OWL))
				apply_status_effect(/datum/status_effect/debuff/sleepytime)
			if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA) || HAS_TRAIT(src, TRAIT_NOSLEEP))
				handle_sleep_triumphs()
		if("night")
			if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA) || HAS_TRAIT(src, TRAIT_NOSLEEP))
				return ..()
			if(HAS_TRAIT(src, TRAIT_NIGHT_OWL))
				add_stress(/datum/stressevent/night_owl)
			else
				apply_status_effect(/datum/status_effect/debuff/sleepytime)
				add_stress(/datum/stressevent/sleepytime)

/mob/living/carbon/human/proc/handle_sleep_triumphs()
	if(!mind)
		return
	allmig_reward++
	var/triumphs_to_add = 1
	var/static/list/towner_jobs
	towner_jobs = GLOB.peasant_positions | GLOB.yeoman_positions | GLOB.youngfolk_positions
	if(mind.assigned_role != "Unassigned" && istype(mind.assigned_role, /datum/job) && (mind.assigned_role.title in towner_jobs)) //If you play a towner-related role, you get an additonal triumph
		triumphs_to_add++
	adjust_triumphs(triumphs_to_add)
	to_chat(src, span_danger("Nights Survived: \Roman[allmig_reward]"))
