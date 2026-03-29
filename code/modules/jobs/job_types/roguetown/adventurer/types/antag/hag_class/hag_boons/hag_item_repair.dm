/datum/component/hag_artifact_repair
	/// List of hag items currently being tended to
	var/list/tended_items = list()
	/// Timers for items currently in the 'shattered' recovery state
	var/list/reconstruction_timers = list()
	/// How often we tick (5 seconds is a good balance)
	var/process_interval = 5 SECONDS
	var/last_process = 0
	/// Valid soil types for the Mossmother's touch
	var/static/list/natural_turfs = list(
		/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/snow,
		/turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassyel, 
		/turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grasscold,
		/turf/open/water/swamp
	)

/datum/component/hag_artifact_repair/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
	START_PROCESSING(SSprocessing, src)

/datum/component/hag_artifact_repair/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	for(var/obj/item/I in reconstruction_timers)
		deltimer(reconstruction_timers[I])
	tended_items = null
	reconstruction_timers = null
	return ..()

/datum/component/hag_artifact_repair/process(delta_time)
	if(world.time < last_process + process_interval)
		return
	last_process = world.time

	var/mob/living/L = parent
	// Must be on natural soil
	if(!is_type_in_list(get_turf(L), natural_turfs))
		return

	for(var/obj/item/I in tended_items)
		if(I.obj_broken)
			continue // Broken items handled by separate timers

		// Check Keychain Affinity
		var/datum/component/hag_magical_item_affinity/Keychain = L.GetComponent(/datum/component/hag_magical_item_affinity)
		if(!Keychain || !(I.name in Keychain.authorized_ids))
			continue

		// 1% Repair & Sharpening
		var/needs_update = FALSE
		if(I.obj_integrity < I.max_integrity)
			I.obj_integrity = min(I.obj_integrity + (I.max_integrity * 0.01), I.max_integrity)
			needs_update = TRUE
		
		if(I.blade_int < I.max_blade_int)
			I.add_bintegrity(min(I.blade_int + (I.max_blade_int * 0.01), I.max_blade_int), L)

		if(needs_update)
			I.update_icon()
			var/obj/effect/temp_visual/heal_rogue/hag/V = new(get_turf(I))
			V.color = "#3a5a3a"

/datum/component/hag_artifact_repair/proc/on_item_equipped(mob/user, obj/item/I, slot)
	SIGNAL_HANDLER
	// We only care about items with the Hag component/flag
	if(I.item_flags & HAG_ITEM)
		tended_items |= I
		RegisterSignal(I, COMSIG_ITEM_BROKEN, PROC_REF(on_item_broken))
		if(I.obj_broken)
			start_reconstruction(I)

/datum/component/hag_artifact_repair/proc/on_item_dropped(mob/user, obj/item/I)
	SIGNAL_HANDLER
	if(I in tended_items)
		tended_items -= I
		UnregisterSignal(I, COMSIG_ITEM_BROKEN)
		if(reconstruction_timers[I])
			deltimer(reconstruction_timers[I])
			reconstruction_timers -= I

/datum/component/hag_artifact_repair/proc/on_item_broken(obj/item/I)
	SIGNAL_HANDLER
	I.visible_message(span_warning("The [I] shatters! The gnarled wood twitches, seeking the strength of the soil to rebuild."))
	start_reconstruction(I)

/datum/component/hag_artifact_repair/proc/start_reconstruction(obj/item/I)
	if(reconstruction_timers[I])
		deltimer(reconstruction_timers[I])
	reconstruction_timers[I] = addtimer(CALLBACK(src, PROC_REF(finish_reconstruction), I), 1 MINUTES, TIMER_STOPPABLE)

/datum/component/hag_artifact_repair/proc/finish_reconstruction(obj/item/I)
	var/mob/living/L = parent
	if(!I || !(I in tended_items) || !I.obj_broken)
		return

	// Fail-safe: if they aren't on grass when the timer ends, delay it by 10s
	if(!is_type_in_list(get_turf(L), natural_turfs))
		reconstruction_timers[I] = addtimer(CALLBACK(src, PROC_REF(finish_reconstruction), I), 10 SECONDS, TIMER_STOPPABLE)
		return

	I.visible_message(span_notice("The roots within the [I] knit back together, drinking vitality from the ground."))
	I.obj_fix()
	I.obj_integrity = I.max_integrity * 0.25
	I.update_icon()
	reconstruction_timers -= I
