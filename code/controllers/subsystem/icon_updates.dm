PROCESSING_SUBSYSTEM_DEF(iconupdates)
	name = "icon_updates"
	wait = 1
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_MOBS
	processing_flag = PROCESSING_ICON_UPDATES

/datum/controller/subsystem/processing/iconupdates/fire(resumed = 0)
	if(!resumed)
		src.currentrun = processing.Copy()

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
