/**
 * Datum to track a specific crafting operation in progress
 */
/datum/container_craft_operation
	/// The container being crafted in
	var/obj/item/crafter
	/// The recipe being crafted
	var/datum/container_craft/recipe
	/// The user initiating the craft, if any
	var/mob/initiator
	/// The estimated multiplier for this craft
	var/estimated_multiplier = 1
	/// Progress time in deciseconds
	var/progress = 0
	/// Target time in deciseconds
	var/target_time = 0
	/// Last time progress was made
	var/last_progress_time = 0
	/// If the craft has been aborted
	var/aborted = FALSE
	var/stalled = FALSE
	/// List of actual item references reserved for this craft
	var/list/obj/item/stored_items
	/// Callback for when craft is started
	var/datum/callback/on_craft_start
	/// Callback for when craft fails
	var/datum/callback/on_craft_failed
	/// Time with no progress before auto-aborting (in deciseconds)
	var/timeout_period = 30 SECONDS // 30 seconds default
	///do we need the initator near us
	var/requires_proximity = FALSE
	///Path of looping_sound to use while cooking
	var/cooking_sound_type

/**
 * Initialize a new crafting operation
 */
/datum/container_craft_operation/New(obj/item/crafter, datum/container_craft/recipe, mob/initiator, estimated_multiplier, datum/callback/on_craft_start, datum/callback/on_craft_failed, datum/looping_sound/cooking_sound)
	src.crafter = crafter
	src.recipe = recipe
	src.initiator = initiator
	src.estimated_multiplier = estimated_multiplier
	src.on_craft_start = on_craft_start
	src.on_craft_failed = on_craft_failed

	if(recipe.user_craft)
		target_time = recipe.get_real_time(crafter, initiator, estimated_multiplier)
		src.requires_proximity = TRUE
	else
		target_time = recipe.get_real_time(crafter, initiator, 1)

	stored_items = list()

	// Get all items already reserved by other crafts in this container
	var/list/obj/item/reserved_items = list()
	for(var/datum/container_craft_operation/other_craft in GLOB.active_container_crafts)
		if(other_craft == src || other_craft.crafter != crafter)
			continue
		reserved_items |= other_craft.stored_items

	// Determine which requirements are wildcards
	var/list/wildcard_paths = list()
	for(var/path in recipe.wildcard_requirements)
		wildcard_paths[path] = recipe.wildcard_requirements[path]

	// Build list of all requirements
	var/list/all_requirements = list()
	for(var/path in recipe.requirements)
		all_requirements[path] = recipe.requirements[path]
	for(var/path in wildcard_paths)
		all_requirements[path] = wildcard_paths[path]

	// Reserve actual items from the container
	for(var/requirement_path in all_requirements)
		var/needed = all_requirements[requirement_path] * estimated_multiplier
		var/reserved = 0
		var/is_wildcard = (requirement_path in wildcard_paths)

		for(var/obj/item/item in crafter.contents)
			if(reserved >= needed)
				break

			// Skip if already reserved by another craft
			if(item in reserved_items)
				continue

			// Check if this item matches the requirement
			var/matches = FALSE
			if(is_wildcard)
				// Wildcard: accept exact type or subtypes
				matches = ispath(item.type, requirement_path)
			else
				// Exact: only accept exact type match
				matches = (item.type == requirement_path)

			if(matches)
				stored_items += item
				reserved++

	last_progress_time = world.time

	START_PROCESSING(SSprocessing, src)
	GLOB.active_container_crafts += src

	if(on_craft_start)
		on_craft_start.InvokeAsync(crafter, initiator, estimated_multiplier)

	if(cooking_sound)
		var/datum/component/container_craft/craft_component = crafter.GetComponent(/datum/component/container_craft)
		if(craft_component?.acquire_cooking_sound(cooking_sound))
			cooking_sound_type = cooking_sound

/**
 * Process tick for crafting progress
 */
/datum/container_craft_operation/process()
	// Check if the container or user are still valid
	if(recipe.user_craft)
		if(QDELETED(initiator) || initiator.incapacitated())
			return FALSE

	if(QDELETED(crafter))
		abort_craft("Container or user no longer valid")
		return

	// Check if reserved items still exist and are in the container
	for(var/obj/item/item in stored_items)
		if(QDELETED(item) || item.loc != crafter)
			abort_craft("Requirements no longer met")
			return

	if(!recipe.can_progress(crafter, initiator))
		last_progress_time = world.time
		if(!stalled)
			stalled = TRUE
			recipe.announce_stall(crafter, initiator)
		return

	if(stalled)
		stalled = FALSE
		recipe.announce_resume(crafter, initiator)

	if(recipe.check_failure(crafter, initiator))
		abort_craft("Craft conditions no longer met")
		return

	// Check for timeout (no progress in a while)
	if((world.time - last_progress_time) > timeout_period)
		abort_craft("Craft timed out")
		return

	if(requires_proximity && !initiator.CanReach(crafter))
		return

	// Update progress
	progress += SSprocessing.wait
	last_progress_time = world.time

	// Check if craft is complete
	if(progress >= target_time)
		complete_craft()

/datum/container_craft_operation/proc/add_progress(amount)
	if(aborted || amount <= 0)
		return
	if(!recipe.can_progress(crafter, initiator))
		return
	progress += amount
	last_progress_time = world.time
	if(progress >= target_time)
		complete_craft()

/**
 * Completes the crafting operation successfully
 */
/datum/container_craft_operation/proc/complete_craft()
	STOP_PROCESSING(SSprocessing, src)
	GLOB.active_container_crafts -= src
	release_sound()

	// Check for failure one last time
	if(recipe.check_failure(crafter, initiator))
		if(on_craft_failed)
			on_craft_failed.InvokeAsync(crafter, initiator)
		qdel(src)
		return

	// Execute the craft
	recipe.execute_craft_completion(crafter, initiator, estimated_multiplier, stored_items)
	qdel(src)

/**
 * Aborts the crafting operation
 * @param reason The reason for aborting
 */
/datum/container_craft_operation/proc/abort_craft(reason)
	if(aborted)
		return

	aborted = TRUE
	STOP_PROCESSING(SSprocessing, src)
	GLOB.active_container_crafts -= src
	release_sound()

	if(on_craft_failed)
		on_craft_failed.InvokeAsync(crafter, initiator)

	if(!QDELETED(crafter))
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_ABORTED, src, reason)

	qdel(src)

/datum/container_craft_operation/proc/release_sound()
	if(!cooking_sound_type)
		return
	var/datum/component/container_craft/craft_component = crafter?.GetComponent(/datum/component/container_craft)
	craft_component?.release_cooking_sound(cooking_sound_type)
	cooking_sound_type = null

/**
 * Clean up when the datum is destroyed
 */
/datum/container_craft_operation/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	GLOB.active_container_crafts -= src
	on_craft_start = null
	on_craft_failed = null
	stored_items = null
	release_sound()
	crafter = null
	return ..()
