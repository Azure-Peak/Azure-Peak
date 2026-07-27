/*!
## Debugging GC issues

In order to debug `qdel()` failures, there are several tools available.
To enable these tools, define `TESTING` in [_compile_options.dm](https://github.com/tgstation/-tg-station/blob/master/code/_compile_options.dm).

First is a verb called "Find References", which lists **every** refererence to an object in the world. This allows you to track down any indirect or obfuscated references that you might have missed.

Complementing this is another verb, "qdel() then Find References".
This does exactly what you'd expect; it calls `qdel()` on the object and then it finds all references remaining.
This is great, because it means that `Destroy()` will have been called before it starts to find references,
so the only references you'll find will be the ones preventing the object from `qdel()`ing gracefully.

If you have a datum or something you are not destroying directly (say via the singulo),
the next tool is `QDEL_HINT_FINDREFERENCE`. You can return this in `Destroy()` (where you would normally `return ..()`),
to print a list of references once it enters the GC queue.

Finally is a verb, "Show qdel() Log", which shows the deletion log that the garbage subsystem keeps. This is helpful if you are having race conditions or need to review the order of deletions.

Note that for any of these tools to work `TESTING` must be defined.
By using these methods of finding references, you can make your life far, far easier when dealing with `qdel()` failures.
*/

SUBSYSTEM_DEF(garbage)
	name = "Garbage"
	priority = FIRE_PRIORITY_GARBAGE
	wait = 1//2 SECONDS
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	init_order = INIT_ORDER_GARBAGE

	var/list/collection_timeout = list(GC_FILTER_QUEUE, GC_CHECK_QUEUE, GC_DEL_QUEUE) // deciseconds to wait before moving something up in the queue to the next level

	//Stat tracking
	var/delslasttick = 0			// number of del()'s we've done this tick
	var/gcedlasttick = 0			// number of things that gc'ed last tick
	var/totaldels = 0
	var/totalgcs = 0

	var/highest_del_time = 0
	var/highest_del_tickusage = 0
	var/highest_del_type_string = ""

	var/list/pass_counts
	var/list/fail_counts

	var/list/items = list()			// Holds our qdel_item statistics datums

	//Queue
	var/list/queues
	#ifdef LEGACY_REFERENCE_TRACKING
	var/list/reference_find_on_fail = list()
	#endif

	/// Toggle for enabling/disabling hard deletes. Objects that don't explicitly request hard deletion with this disabled will leak.
	var/enable_hard_deletes = FALSE
	var/list/failed_hard_deletes = list()

/datum/controller/subsystem/garbage/PreInit()
	queues = new(GC_QUEUE_COUNT)
	pass_counts = new(GC_QUEUE_COUNT)
	fail_counts = new(GC_QUEUE_COUNT)
	for(var/i in 1 to GC_QUEUE_COUNT)
		queues[i] = list()
		pass_counts[i] = 0
		fail_counts[i] = 0

/datum/controller/subsystem/garbage/Initialize(start_timeofday)
	. = ..()
	if(CONFIG_GET(flag/hard_deletes_enabled))
		enable_hard_deletes = TRUE

/datum/controller/subsystem/garbage/stat_entry(msg)
	var/list/counts = list()
	for (var/list/L in queues)
		counts += length(L)
	msg += "Q:[counts.Join(",")]|D:[delslasttick]|G:[gcedlasttick]|"
	msg += "GR:"
	if (!(delslasttick+gcedlasttick))
		msg += "n/a|"
	else
		msg += "[round((gcedlasttick/(delslasttick+gcedlasttick))*100, 0.01)]%|"

	msg += "TD:[totaldels]|TG:[totalgcs]|"
	if (!(totaldels+totalgcs))
		msg += "n/a|"
	else
		msg += "TGR:[round((totalgcs/(totaldels+totalgcs))*100, 0.01)]%"
	msg += " P:[pass_counts.Join(",")]"
	msg += "|F:[fail_counts.Join(",")]"
	return ..()

/datum/controller/subsystem/garbage/Shutdown()
	//Adds the del() log to the qdel log file
	var/list/del_log = list()

	if(highest_del_type_string)
		del_log += "Highest hard-delete this round: [highest_del_tickusage] ticks ([highest_del_type_string])"

	//sort by how long it's wasted hard deleting
	sortTim(items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in items)
		var/datum/qdel_item/I = items[path]
		var/list/entry = list()
		del_log[path] = entry
		if (I.qdel_flags & QDEL_ITEM_SUSPENDED_FOR_LAG)
			del_log += "\tSUSPENDED FOR LAG"
		if (I.failures)
			entry["Failures"] = I.failures
		entry["qdel() Count"] = I.qdels
		entry["Destroy() Cost (ms)"] = I.destroy_time

		if (I.hard_deletes)
			entry["Total Hard Deletes"] = I.hard_deletes
			entry["Time Spend Hard Deleting (ms)"] = I.hard_delete_time
			entry["Highest Time Spent Hard Deleting (ms)"] = I.hard_delete_max
			if (I.hard_deletes_over_threshold)
				entry["Hard Deletes Over Threshold"] = I.hard_deletes_over_threshold
		if (I.slept_destroy)
			entry["Total Sleeps"] = I.slept_destroy
		if (I.no_respect_force)
			entry["Total Ignored Force"] = I.no_respect_force
		if (I.no_hint)
			entry["Total No Hint"] = I.no_hint

		if(LAZYLEN(I.extra_details))
			del_log += "\tExtra Info:\n\t\t- [I.extra_details.Join("\n\t\t- ")]"
	log_qdel("", del_log)

/datum/controller/subsystem/garbage/fire()
	//the fact that this resets its processing each fire (rather then resume where it left off) is intentional.
	var/queue = GC_QUEUE_FILTER

	while (state == SS_RUNNING)
		switch (queue)
			if (GC_QUEUE_FILTER)
				HandleQueue(GC_QUEUE_FILTER)
				queue = GC_QUEUE_FILTER+1
			if (GC_QUEUE_CHECK)
				HandleQueue(GC_QUEUE_CHECK)
				queue = GC_QUEUE_CHECK+1
			if (GC_QUEUE_HARDDELETE)
				HandleQueue(GC_QUEUE_HARDDELETE)
				if (state == SS_PAUSED) //make us wait again before the next run.
					state = SS_RUNNING
				break




/datum/controller/subsystem/garbage/proc/HandleQueue(level = GC_QUEUE_FILTER)
	if (level == GC_QUEUE_FILTER)
		delslasttick = 0
		gcedlasttick = 0
	var/cut_off_time = world.time - collection_timeout[level] //ignore entries newer then this
	var/list/queue = queues[level]
	var/static/lastlevel
	var/static/count = 0
	if (count) //runtime last run before we could do this.
		var/c = count
		count = 0 //so if we runtime on the Cut, we don't try again.
		var/list/lastqueue = queues[lastlevel]
		lastqueue.Cut(1, c+1)

	lastlevel = level

	//We do this rather then for(var/refID in queue) because that sort of for loop copies the whole list.
	//Normally this isn't expensive, but the gc queue can grow to 40k items, and that gets costly/causes overrun.
	for (var/i in 1 to length(queue))
		var/list/L = queue[i]
		if (length(L) < 2)
			count++
			if (MC_TICK_CHECK)
				break
			continue

		var/GCd_at_time = L[1]
		if(GCd_at_time > cut_off_time)
			break // Everything else is newer, skip them
		count++
		var/refID = L[2]
		var/datum/D
		D = locate(refID)

		if (!D || D.gc_destroyed != GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by mistake
			++gcedlasttick
			++totalgcs
			pass_counts[level]++
			#ifdef LEGACY_REFERENCE_TRACKING
			reference_find_on_fail -= refID	//It's deleted we don't care anymore.
			#endif
			if (MC_TICK_CHECK)
				break
			continue

		// Something's still referring to the qdel'd object.
		fail_counts[level]++
		switch (level)
			if (GC_QUEUE_CHECK)
				#ifdef REFERENCE_TRACKING
				D.find_references()
				#elif defined(LEGACY_REFERENCE_TRACKING)
				if(reference_find_on_fail[refID])
					D.find_references_legacy()
				#ifdef GC_FAILURE_HARD_LOOKUP
				else
					D.find_references_legacy()
				#endif
				reference_find_on_fail -= refID
				#endif
				var/type = D.type
				var/datum/qdel_item/I = items[type]
				var/detail = D.dump_harddel_info()
				if(detail)
					LAZYADD(I.extra_details, detail)
				#ifdef TESTING
				log_world("## TESTING: GC: -- \ref[D] | [type] was unable to be GC'd --")
				for(var/c in GLOB.admins) //Using here would fill the logs with ADMIN_VV garbage
					var/client/admin = c
					if(!check_rights_for(admin, R_ADMIN))
						continue
					to_chat(admin, "## TESTING: GC: -- [ADMIN_VV(D)] | [type] was unable to be GC'd --")
				#endif
				#ifdef REFERENCE_TRACKING
				GLOB.deletion_failures += D //It should no longer be bothered by the GC, manual deletion only.
				continue
				#endif
				I.failures++
				if(I.qdel_flags & QDEL_ITEM_SUSPENDED_FOR_LAG)
					#ifdef LEGACY_REFERENCE_TRACKING
					// We do not have the modern TG ref tracking PR on main
					// This does nothing, and should not be added to until it is ported
					#endif
					continue
			if (GC_QUEUE_HARDDELETE)
				if(!HardDelete(D))
					D = null
				if (MC_TICK_CHECK)
					break
				continue

		Queue(D, level+1)

		if (MC_TICK_CHECK)
			break
	if (count)
		queue.Cut(1,count+1)
		count = 0

/datum/controller/subsystem/garbage/proc/Queue(datum/D, level = GC_QUEUE_FILTER)
	if (isnull(D))
		return
	if (level > GC_QUEUE_COUNT)
		HardDelete(D)
		return
	var/gctime = world.time
	var/refid = "\ref[D]"

	D.gc_destroyed = gctime
	var/list/queue = queues[level]

	queue[++queue.len] = list(gctime, refid) // not += for byond reasons

//this is mainly to separate things profile wise.
/datum/controller/subsystem/garbage/proc/HardDelete(datum/D, override = FALSE)
	if(!D)
		return
	if(!enable_hard_deletes && !override)
		failed_hard_deletes |= D
		return
	var/time = world.timeofday
	var/tick = TICK_USAGE
	var/ticktime = world.time
	++delslasttick
	++totaldels
	var/type = D.type
	var/refID = "\ref[D]"
	var/datum/qdel_item/I = items[type]
	var/detail = D.dump_harddel_info()
	if(detail)
		LAZYADD(I.extra_details, detail)

	del(D)

	tick = (TICK_USAGE-tick+((world.time-ticktime)/world.tick_lag*100))

	I.hard_deletes++
	I.hard_delete_time += TICK_DELTA_TO_MS(tick)
	if(TICK_DELTA_TO_MS(tick) > I.hard_delete_max)
		I.hard_delete_max = TICK_DELTA_TO_MS(tick)
	if (tick > highest_del_tickusage)
		highest_del_tickusage = tick
		highest_del_type_string = "[type]"
	
	time = world.timeofday - time
	if (!time && TICK_DELTA_TO_MS(tick) > 1)
		time = TICK_DELTA_TO_MS(tick)/100
	if (time > highest_del_time)
		highest_del_time = time
	// Vanderlin garbage.dm:319-330. `time` is deciseconds (world.timeofday delta).
	if(time > 1) // >0.1s: postpone the GC regardless of threshold config
		postpone(time)
	var/threshold = CONFIG_GET(number/hard_deletes_overrun_threshold)
	if(threshold && (time > threshold * 10)) // threshold is seconds; time is deciseconds
		if(!(I.qdel_flags & QDEL_ITEM_ADMINS_WARNED))
			log_game("Error: [type]([refID]) took longer than [threshold] seconds to delete (took [round(time/10, 0.1)] seconds to delete)")
			message_admins("Error: [type]([refID]) took longer than [threshold] seconds to delete (took [round(time/10, 0.1)] seconds to delete).")
			I.qdel_flags |= QDEL_ITEM_ADMINS_WARNED
		I.hard_deletes_over_threshold++
		var/overrun_limit = CONFIG_GET(number/hard_deletes_overrun_limit)
		if(overrun_limit && I.hard_deletes_over_threshold >= overrun_limit)
			I.qdel_flags |= QDEL_ITEM_SUSPENDED_FOR_LAG
	return TRUE

/datum/controller/subsystem/garbage/Recover()
	if (istype(SSgarbage.queues))
		for (var/i in 1 to SSgarbage.queues.len)
			queues[i] |= SSgarbage.queues[i]


/datum/qdel_item
	var/name = ""
	var/qdels = 0			//Total number of times it's passed thru qdel.
	var/destroy_time = 0	//Total amount of milliseconds spent processing this type's Destroy()
	var/failures = 0		//Times it was queued for soft deletion but failed to soft delete.
	var/hard_deletes = 0 	//Different from failures because it also includes QDEL_HINT_HARDDEL deletions
	var/hard_delete_time = 0//Total amount of milliseconds spent hard deleting this type.
	var/hard_delete_max = 0	//Highest time spent hard_deleting this in ms.
	var/hard_deletes_over_threshold = 0	//Number of times hard deletes took longer than the configured threshold
	var/no_respect_force = 0//Number of times it's not respected force=TRUE
	var/no_hint = 0			//Number of times it's not even bother to give a qdel hint
	var/slept_destroy = 0	//Number of times it's slept in its destroy
	var/qdel_flags = 0		//Bitfield of QDEL_ITEM_* flags
	var/list/extra_details	//Lazylist of string metadata about the deleted objects

/datum/qdel_item/New(mytype)
	name = "[mytype]"


/// Should be treated as a replacement for the 'del' keyword.
///
/// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(datum/D, force=FALSE, ...)
	if(!istype(D))
		if(isnull(D))
			return
		else if(islist(D))
			stack_trace("Lists should not be directly passed to qdel! You likely want either list.Cut(), QDEL_LIST(list), QDEL_LIST_ASSOC(list), or QDEL_LIST_ASSOC_VAL(list)")
		else if(D != world)
			stack_trace("Tried to qdel possibly invalid value: [D]")
		del(D)
		return

	var/datum/qdel_item/I = SSgarbage.items[D.type]
	if (!I)
		I = SSgarbage.items[D.type] = new /datum/qdel_item(D.type)
	I.qdels++

	if(isnull(D.gc_destroyed))
		if (SEND_SIGNAL(D, COMSIG_PARENT_PREQDELETED, force)) // Give the components a chance to prevent their parent from being deleted
			return
		D.gc_destroyed = GC_CURRENTLY_BEING_QDELETED
		var/start_time = world.time
		var/start_tick = world.tick_usage
		SEND_SIGNAL(D, COMSIG_PARENT_QDELETING, force) // Let the (remaining) components know about the result of Destroy
		var/hint = D.Destroy(arglist(args.Copy(2))) // Let our friend know they're about to get fucked up.
		if(world.time != start_time)
			I.slept_destroy++
		else
			I.destroy_time += TICK_USAGE_TO_MS(start_tick)
		if(!D)
			return
		switch(hint)
			if (QDEL_HINT_QUEUE)		//qdel should queue the object for deletion.
				SSgarbage.Queue(D)
			if (QDEL_HINT_IWILLGC)
				D.gc_destroyed = world.time
				return
			if (QDEL_HINT_LETMELIVE)	//qdel should let the object live after calling destory.
				if(!force)
					D.gc_destroyed = null //clear the gc variable (important!)
					return
				// Returning LETMELIVE after being told to force destroy
				// indicates the objects Destroy() does not respect force
				I.no_respect_force++

				SSgarbage.Queue(D)
			if (QDEL_HINT_HARDDEL)		//qdel should assume this object won't gc, and queue a hard delete
				SSgarbage.Queue(D, GC_QUEUE_HARDDELETE)
			if (QDEL_HINT_HARDDEL_NOW)	//qdel should assume this object won't gc, and hard del it post haste.
				SSgarbage.HardDelete(D, override = TRUE)
			#ifdef LEGACY_REFERENCE_TRACKING
			if (QDEL_HINT_FINDREFERENCE) //qdel will, if LEGACY_REFERENCE_TRACKING is enabled, display all references to this object, then queue the object for deletion.
				SSgarbage.Queue(D)
				D.find_references_legacy()
			if (QDEL_HINT_IFFAIL_FINDREFERENCE)
				SSgarbage.Queue(D)
				SSgarbage.reference_find_on_fail[REF(D)] = TRUE
			#endif
			else
				#ifdef TESTING
				if(!I.no_hint)

				#endif
				I.no_hint++
				SSgarbage.Queue(D)
	else if(D.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)
		CRASH("[D.type] destroy proc was called multiple times, likely due to a qdel loop in the Destroy logic")
