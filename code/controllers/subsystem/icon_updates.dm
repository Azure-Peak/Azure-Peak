PROCESSING_SUBSYSTEM_DEF(iconupdates)
	name = "icon_updates"
	wait = 1
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_MOBS
	processing_flag = PROCESSING_ICON_UPDATES

	var/list/image_removal_schedule = list()
	var/list/cleanup_run = list()

/datum/controller/subsystem/processing/iconupdates/fire(resumed = 0)
	if(!resumed)
		src.cleanup_run = image_removal_schedule.Copy()
		src.currentrun = processing.Copy()

	var/list/cleanup_run = src.cleanup_run
	while(length(cleanup_run))
		var/image/I = cleanup_run[length(cleanup_run)]
		cleanup_run.len--

		process_image(I)

		if(MC_TICK_CHECK)
			return
		else
			CHECK_TICK

	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/mob/living/carbon/thing = currentrun[length(currentrun)]
		currentrun.len--
		if (!thing || QDELETED(thing))
			processing -= thing
			if(MC_TICK_CHECK)
				return
			else
				CHECK_TICK
			continue
		
		if(thing.pending_icon_updates)
			thing.process_pending_icon_updates()
		
		if(!thing.pending_icon_updates)
			STOP_PROCESSING(SSiconupdates, thing)
		
		if(MC_TICK_CHECK)
			return
		else
			CHECK_TICK

/datum/controller/subsystem/processing/iconupdates/proc/process_image(image/I)
	if(!image_removal_schedule[I])
		return

	if(!I || QDELETED(I))
		var/list/client_schedule = image_removal_schedule[I]
		if(client_schedule)
			for(var/client/C as anything in client_schedule)
				if(C && !QDELETED(C))
					C.images -= I
		image_removal_schedule -= I
		return

	var/list/client_schedule = image_removal_schedule[I]
	if(!client_schedule || !length(client_schedule))
		image_removal_schedule -= I
		return

	var/current_time = world.time
	var/list/clients_to_remove = list()

	for(var/client/C as anything in client_schedule)
		if(!C || QDELETED(C))
			clients_to_remove += C
			continue

		var/expire_time = client_schedule[C]
		if(current_time >= expire_time)
			C.images -= I
			clients_to_remove += C

	for(var/client/C as anything in clients_to_remove)
		client_schedule -= C

	if(!length(client_schedule))
		image_removal_schedule -= I
