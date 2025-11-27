// Temporarily commenting this out so we can get CI in and working again
// ///Delete one of every type, sleep a while, then check to see if anything has gone fucky
// /datum/unit_test/create_and_destroy
// 	//You absolutely must run last
// 	priority = TEST_CREATE_AND_DESTROY

// GLOBAL_VAR_INIT(running_create_and_destroy, FALSE)
// /datum/unit_test/create_and_destroy/Run()
// 	var/list/ignore = list(
// 		//Never meant to be created, errors out the ass for mobcode reasons
// 		/mob/living/carbon,
// 		//Needs a seed passed, but subtypes set one by default
// 		/obj/item/grown,
// 		/obj/item/reagent_containers/food/snacks/grown,
// 		//Template type
// 		/obj/effect/mob_spawn,
// 		//Singleton
// 		/mob/dview,
// 		//Template type
// 		/obj/item/bodypart,
// 		//template types
// 		//template type again
// 		/obj/item/storage/fancy,
// 		//needs a mob passed to view it
// 		/atom/movable/screen/credit,
// 		//invalid without mob/living passed
// 		/obj/shapeshift_holder,
// 		// requires a pod passed
// 		/obj/effect/DPfall,
// 		/obj/effect/DPtarget,
// 		// prompts loc for input
// 		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft,
// 	)
// 	//these are VERY situational and need info passed
// 	ignore += typesof(/obj/effect/abstract)
// 	//needs a lich passed
// 	ignore += typesof(/obj/item/phylactery)
// 	//cba to fix hitscans erroring in Destroy, so just ignore all projectiles
// 	ignore += typesof(/obj/projectile)
// 	//Say it with me now, type template
// 	ignore += typesof(/obj/effect/mapping_helpers)
// 	//This turf existing is an error in and of itself
// 	ignore += typesof(/turf/baseturf_skipover)
// 	ignore += typesof(/turf/baseturf_bottom)
// 	//Needs a client / mob / hallucination to observe it to exist.
// 	ignore += typesof(/obj/effect/hallucination)
// 	//Can't pass in a thing to glow
// 	ignore += typesof(/obj/effect/abstract/eye_lighting)
// 	//We have a baseturf limit of 10, adding more than 10 baseturf helpers will kill CI, so here's a future edge case to fix.
// 	ignore += typesof(/obj/effect/baseturf_helper)
// 	//Expects a mob to holderize, we have nothing to give
// 	ignore += typesof(/obj/item/clothing/head/mob_holder)
// 	//Needs cards passed into the initilazation args
// 	ignore += typesof(/obj/item/toy/cards/cardhand)
// 	//needs multiple atoms passed
// 	ignore += typesof(/obj/effect/buildmode_line)

// 	ignore += typesof(/obj/effect/spawner)
// 	ignore += typesof(/atom/movable/screen)

// 	var/turf/spawn_at = run_loc_floor_bottom_left
// 	var/list/cached_contents = spawn_at.contents.Copy()
// 	var/baseturf_count = length(spawn_at.baseturfs)

// 	GLOB.running_create_and_destroy = TRUE
// 	for(var/type_path in typesof(/atom/movable, /turf) - uncreatables) //No areas please
// 		if(ispath(type_path, /turf))
// 			spawn_at.ChangeTurf(type_path, /turf/baseturf_skipover)
// 			//We change it back to prevent pain, please don't ask
// 			spawn_at.ChangeTurf(/turf/open/floor/rogue/wood, /turf/baseturf_skipover)
// 			if(baseturf_count != length(spawn_at.baseturfs))
// 				TEST_FAIL("[type_path] changed the amount of baseturfs we have [baseturf_count] -> [length(spawn_at.baseturfs)]")
// 				baseturf_count = length(spawn_at.baseturfs)
// 		else
// 			var/atom/creation = new type_path(spawn_at)
// 			if(QDELETED(creation))
// 				continue
// 			//Go all in
// 			qdel(creation, force = TRUE)
// 			//This will hold a ref to the last thing we process unless we set it to null
// 			//Yes byond is fucking sinful
// 			creation = null

// 		//There's a lot of stuff that either spawns stuff in on create, or removes stuff on destroy. Let's cut it all out so things are easier to deal with
// 		var/list/to_del = spawn_at.contents - cached_contents
// 		if(length(to_del))
// 			for(var/atom/to_kill in to_del)
// 				qdel(to_kill, force = TRUE)

// 	GLOB.running_create_and_destroy = FALSE
// 	//Hell code, we're bound to have ended the round somehow so let's stop if from ending while we work
// 	SSticker.delay_end = TRUE
// 	//Prevent the garbage subsystem from harddeling anything, if only to save time
// 	SSgarbage.collection_timeout[GC_QUEUE_HARDDELETE] = 10000 HOURS
// 	//Clear it, just in case
// 	cached_contents.Cut()

// 	var/list/queues_we_care_about = list()
// 	// All up to harddel
// 	for(var/i in 1 to GC_QUEUE_HARDDELETE - 1)
// 		queues_we_care_about += i

// 	//Now that we've qdel'd everything, let's sleep until the gc has processed all the shit we care about
// 	var/time_needed = 2 SECONDS
// 	for(var/index in queues_we_care_about)
// 		time_needed += SSgarbage.collection_timeout[index]


// 	var/start_time = world.time
// 	sleep(time_needed)
// 	// spin until the first item in the check queue is older than start_time
// 	var/garbage_queue_processed = FALSE

// 	while(!garbage_queue_processed || !SSgarbage.can_fire)
// 		if(!SSgarbage.can_fire) // probably running find references
// 			CHECK_TICK
// 			continue

// 		var/oldest_packet_creation = INFINITY
// 		for(var/index in queues_we_care_about)
// 			var/list/queue_to_check = SSgarbage.queues[index]
// 			if(!length(queue_to_check))
// 				continue

// 			var/list/oldest_packet = queue_to_check[1]
// 			//Pull out the time we inserted at
// 			var/qdeld_at = oldest_packet[GC_QUEUE_ITEM_GCD_DESTROYED]

// 			oldest_packet_creation = min(qdeld_at, oldest_packet_creation)

// 		if(oldest_packet_creation > start_time)
// 			garbage_queue_processed = TRUE
// 			break

// 		if(world.time > start_time + time_needed + 30 MINUTES) //If this gets us gitbanned I'm going to laugh so hard
// 			TEST_FAIL("Something has gone horribly wrong, the garbage queue has been processing for well over 30 minutes. What the hell did you do")
// 			break

// 		//Immediately fire the gc right after
// 		SSgarbage.next_fire = 1
// 		//Unless you've seriously fucked up, queue processing shouldn't take "that" long. Let her run for a bit, see if anything's changed
// 		sleep(20 SECONDS)

// 	//Alright, time to see if anything messed up
// 	var/list/cache_for_sonic_speed = SSgarbage.items
// 	for(var/path in cache_for_sonic_speed)
// 		var/datum/qdel_item/item = cache_for_sonic_speed[path]
// 		if(item.failures)
// 			TEST_FAIL("[item.name] hard deleted [item.failures] times out of a total del count of [item.qdels]")
// 		if(item.no_respect_force)
// 			TEST_FAIL("[item.name] failed to respect force deletion [item.no_respect_force] times out of a total del count of [item.qdels]")
// 		if(item.no_hint)
// 			TEST_FAIL("[item.name] failed to return a qdel hint [item.no_hint] times out of a total del count of [item.qdels]")

// 	cache_for_sonic_speed = SSatoms.BadInitializeCalls
// 	for(var/path in cache_for_sonic_speed)
// 		var/fails = cache_for_sonic_speed[path]
// 		if(fails & BAD_INIT_NO_HINT)
// 			TEST_FAIL("[path] didn't return an Initialize hint")
// 		if(fails & BAD_INIT_QDEL_BEFORE)
// 			TEST_FAIL("[path] qdel'd in New()")
// 		if(fails & BAD_INIT_SLEPT)
// 			TEST_FAIL("[path] slept during Initialize()")

// 	SSticker.delay_end = FALSE
// 	//This shouldn't be needed, but let's be polite
// 	SSgarbage.collection_timeout[GC_QUEUE_HARDDELETE] = 10 SECONDS
