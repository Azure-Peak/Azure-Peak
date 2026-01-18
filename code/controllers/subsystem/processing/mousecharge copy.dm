// Smooth HUD updates, but low priority
PROCESSING_SUBSYSTEM_DEF(mousecharge)
	name = "mouse charging prog"
	wait = 1
	flags = SS_KEEP_TIMING //Surely nothing bad will happen.
	priority = FIRE_PRIORITY_MOUSECHARGE
	stat_tag = "MOUSE"
	var/list/mouse_icons = list(
	'icons/effects/mousemice/swang/0.dmi',\
	'icons/effects/mousemice/swang/5.dmi',\
	'icons/effects/mousemice/swang/10.dmi',\
	'icons/effects/mousemice/swang/15.dmi',\
	'icons/effects/mousemice/swang/20.dmi',\
	'icons/effects/mousemice/swang/25.dmi',\
	'icons/effects/mousemice/swang/30.dmi',\
	'icons/effects/mousemice/swang/35.dmi',\
	'icons/effects/mousemice/swang/40.dmi',\
	'icons/effects/mousemice/swang/45.dmi',\
	'icons/effects/mousemice/swang/50.dmi',\
	'icons/effects/mousemice/swang/55.dmi',\
	'icons/effects/mousemice/swang/60.dmi',\
	'icons/effects/mousemice/swang/65.dmi',\
	'icons/effects/mousemice/swang/70.dmi',\
	'icons/effects/mousemice/swang/75.dmi',\
	'icons/effects/mousemice/swang/80.dmi',\
	'icons/effects/mousemice/swang/85.dmi',\
	'icons/effects/mousemice/swang/90.dmi',\
	'icons/effects/mousemice/swang/95.dmi',\
	'icons/effects/mousemice/swang/100.dmi'
)
/datum/controller/subsystem/processing/mousecharge/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/client/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			processing -= thing
		else if(thing.process(wait) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/processing/mousecharge/proc/access(var/percentage)
	percentage = clamp(percentage,0,100)///Only here bc I'm a lazy ass and want all my math on one screen.
	return SSmousecharge.mouse_icons[floor(percentage / 5) + 1]
