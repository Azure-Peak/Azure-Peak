
/datum/component/container_craft
	/// Recipe types that can be used with this container
	var/list/viable_recipe_types = list()
	/// Low priority recipes (craft_priority = FALSE)
	var/list/fallback_recipe_types = list()
	/// Callback when craft starts
	var/datum/callback/on_craft_start
	/// Callback when craft fails
	var/datum/callback/on_craft_failed
	/// Callback when craft is successful
	var/datum/callback/on_craft_finished
	var/list/cooking_sounds
	var/list/cooking_sound_users

/**
 * Initialize the component
 */
/datum/component/container_craft/Initialize(list/recipes, temperature_listener, datum/callback/start, datum/callback/fail, datum/callback/success)
	. = ..()
	if(!length(recipes))
		return COMPONENT_INCOMPATIBLE

	viable_recipe_types = list()
	fallback_recipe_types = list()

	for(var/datum/container_craft/recipe as anything in recipes)
		var/datum/container_craft/singleton = GLOB.container_craft_to_singleton[recipe]
		if(!singleton)
			continue

		if(singleton.craft_priority)
			viable_recipe_types += recipe
		else
			fallback_recipe_types += recipe

	on_craft_start = start
	on_craft_failed = fail
	on_craft_finished = success
	RegisterSignal(parent, COMSIG_STORAGE_CLOSED, PROC_REF(async_start))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(async_start))
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(on_item_entered))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(on_item_exited))
	RegisterSignal(parent, COMSIG_CONTAINER_CRAFT_COMPLETE, PROC_REF(on_craft_complete))
	RegisterSignal(parent, COMSIG_CONTAINER_CRAFT_ABORTED, PROC_REF(on_craft_aborted))
	if(temperature_listener && isatom(parent))
		var/atom/parent_atom = parent
		RegisterSignal(parent_atom.reagents, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(on_temperature_change))

/datum/component/container_craft/Destroy()
	if(cooking_sounds)
		for(var/sound_type in cooking_sounds)
			var/datum/looping_sound/loop = cooking_sounds[sound_type]
			qdel(loop)
		cooking_sounds = null
	cooking_sound_users = null
	return ..()

/datum/component/container_craft/proc/acquire_cooking_sound(sound_type)
	if(!ispath(sound_type, /datum/looping_sound))
		return FALSE
	LAZYINITLIST(cooking_sounds)
	LAZYINITLIST(cooking_sound_users)
	cooking_sound_users[sound_type] += 1
	if(!cooking_sounds[sound_type])
		cooking_sounds[sound_type] = new sound_type(parent, TRUE)
	return TRUE

/datum/component/container_craft/proc/release_cooking_sound(sound_type)
	if(!cooking_sound_users?[sound_type])
		return
	cooking_sound_users[sound_type] -= 1
	if(cooking_sound_users[sound_type] > 0)
		return
	cooking_sound_users -= sound_type
	var/datum/looping_sound/loop = cooking_sounds?[sound_type]
	cooking_sounds -= sound_type
	if(loop)
		qdel(loop)

/**
 * Asynchronously start crafting
 */
/datum/component/container_craft/proc/async_start(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_crafts), source, user)

/datum/component/container_craft/proc/queue_attempt()
	addtimer(CALLBACK(src, PROC_REF(attempt_crafts), parent, null), 0, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/container_craft/proc/on_item_entered(datum/source, atom/movable/entered, atom/old_loc)
	SIGNAL_HANDLER
	queue_attempt()

/datum/component/container_craft/proc/on_item_exited(datum/source, atom/movable/exited, atom/new_loc)
	SIGNAL_HANDLER
	queue_attempt()

/datum/component/container_craft/proc/on_craft_aborted(datum/source, datum/container_craft_operation/operation, reason)
	SIGNAL_HANDLER
	queue_attempt()

/datum/component/container_craft/proc/on_temperature_change(datum/source, new_temp, old_temp)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_crafts), source, null)

/datum/component/container_craft/proc/on_craft_complete(datum/source, atom/created_output)
	SIGNAL_HANDLER
	queue_attempt()

/**
 * Attempt to craft all possible recipes - try normal priority first, then fallbacks
 */
/datum/component/container_craft/proc/attempt_crafts(datum/source, mob/user)
	var/list/stored_items = list()
	var/atom/host = parent
	if(!length(host.contents))
		return

	if(!istype(user))
		user = get_mob_by_ckey(host.fingerprintslast)

	// Build list of all items in container by type
	for(var/obj/item/item in host.contents)
		stored_items |= item.type
		stored_items[item.type]++

	// Subtract items already reserved by active crafts in this container
	for(var/datum/container_craft_operation/op in GLOB.active_container_crafts)
		if(op.crafter != host)
			continue

		// op.stored_items is now a list of item references, convert to type counts
		for(var/obj/item/reserved_item in op.stored_items)
			if(QDELETED(reserved_item))
				continue
			var/item_type = reserved_item.type
			if(stored_items[item_type])
				stored_items[item_type]--
				if(stored_items[item_type] <= 0)
					stored_items -= item_type

	// First try normal priority recipes
	for(var/datum/container_craft/recipe as anything in viable_recipe_types)
		var/datum/container_craft/singleton = GLOB.container_craft_to_singleton[recipe]
		if(!singleton)
			continue
		// Try to start the craft
		if(singleton.try_craft(host, stored_items.Copy(), user, on_craft_start, on_craft_failed))
			return  // Success! Stop here

	// If no normal priority recipes worked, try fallback recipes
	for(var/datum/container_craft/recipe as anything in fallback_recipe_types)
		var/datum/container_craft/singleton = GLOB.container_craft_to_singleton[recipe]
		if(!singleton)
			continue
		// Try to start the craft
		if(singleton.try_craft(host, stored_items.Copy(), user, on_craft_start, on_craft_failed))
			return  // Success! Stop here
