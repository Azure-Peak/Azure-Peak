// Global tracking lists
GLOBAL_LIST_EMPTY(active_container_crafts)
GLOBAL_LIST_INIT(container_craft_to_singleton, init_container_crafts())
GLOBAL_LIST_INIT(container_craft_book_groups, init_container_craft_book_groups())
GLOBAL_LIST_EMPTY(container_craft_family_cache)

/proc/init_container_crafts()
	var/list/recipes = list()
	for(var/datum/container_craft/craft as anything in subtypesof(/datum/container_craft))
		if(IS_ABSTRACT(craft))
			continue
		recipes |= craft
		recipes[craft] = new craft
	synthesize_container_crafts(recipes)
	synthesize_container_handoffs(recipes)
	return recipes

/// What an item becomes under a given cook method. Mirrors set_cook_handoff.
/proc/get_item_cook_result(snack_type, method)
	var/obj/item/reagent_containers/food/snacks/proto = snack_type
	switch(method)
		if(COOK_BAKE)
			return initial(proto.cooked_type)
		if(COOK_FRY)
			return initial(proto.fried_type)
		if(COOK_DEEPFRY)
			return initial(proto.deep_fried_type)
	return null

/proc/synthesize_container_crafts(list/recipes)
	for(var/datum/container_craft/base as anything in subtypesof(/datum/container_craft))
		if(initial(base.abstract_type) != base || !initial(base.synthesize_recipes))
			continue

		var/method = initial(base.cook_method)
		if(!method)
			continue

		var/list/covered = list()
		for(var/declared as anything in subtypesof(base))
			var/datum/container_craft/recipe = recipes[declared]
			if(!recipe)
				continue
			for(var/path in recipe.requirements)
				covered[path] = TRUE
			for(var/path in recipe.wildcard_requirements)
				covered[path] = TRUE

		for(var/obj/item/reagent_containers/food/snacks/snack as anything in subtypesof(/obj/item/reagent_containers/food/snacks))
			if(is_abstract(snack) || covered[snack])
				continue
			var/atom/result = get_item_cook_result(snack, method)
			if(!result || result == snack)
				continue

			var/list/synth_requirements = list()
			synth_requirements[snack] = 1

			var/datum/container_craft/synth = new base
			synth.name = initial(result.name)
			synth.hides_from_books = TRUE
			synth.requirements = synth_requirements
			synth.output = result
			synth.cooked_smell = initial(snack.cooked_smell)
			var/item_cooktime = initial(snack.cooktime)
			if(item_cooktime)
				synth.crafting_time = item_cooktime
			recipes[synth] = synth


/proc/get_cook_handoff_bases(method)
	var/list/bases = list()
	for(var/datum/food_recipe/recipe as anything in subtypesof(/datum/food_recipe))
		if(IS_ABSTRACT(recipe))
			continue
		var/base_item = initial(recipe.base_item)
		if(!base_item)
			continue
		if(initial(recipe.cook_method) == method)
			bases[base_item] = TRUE
		else if(initial(recipe.needs_cooking) && (method == COOK_BAKE || method == COOK_FRY))
			bases[base_item] = TRUE
	return bases

/proc/synthesize_container_handoffs(list/recipes)
	for(var/datum/container_craft/base as anything in subtypesof(/datum/container_craft))
		if(initial(base.abstract_type) != base || !initial(base.handoff_craft))
			continue

		var/method = initial(base.cook_method)
		if(!method)
			continue

		for(var/obj/item/reagent_containers/food/snacks/snack as anything in get_cook_handoff_bases(method))
			var/list/synth_requirements = list()
			synth_requirements[snack] = 1

			var/datum/container_craft/synth = new base
			synth.name = initial(snack.name)
			synth.hides_from_books = TRUE
			synth.requirements = synth_requirements
			var/item_cooktime = initial(snack.cooktime)
			if(item_cooktime)
				synth.crafting_time = item_cooktime
			recipes[synth] = synth

/proc/init_container_craft_book_groups()
	var/list/groups = list()
	for(var/recipe_type in GLOB.container_craft_to_singleton)
		var/datum/container_craft/recipe = GLOB.container_craft_to_singleton[recipe_type]
		if(recipe.hides_from_books)
			continue
		var/key = recipe.book_group_key()
		var/list/members = groups[key]
		if(!members)
			members = list()
			groups[key] = members
		members += recipe_type
	return groups

/proc/get_container_craft_family(root)
	var/list/cached = GLOB.container_craft_family_cache[root]
	if(cached)
		return cached
	var/list/members = list()
	for(var/key in GLOB.container_craft_to_singleton)
		var/datum/container_craft/recipe = GLOB.container_craft_to_singleton[key]
		if(ispath(recipe.type, root))
			members += key
	members = sortList(members, GLOBAL_PROC_REF(cmp_container_craft_specificity))
	GLOB.container_craft_family_cache[root] = members
	return members

/datum/container_craft
	var/name = "GENERIC RECIPE CHANGE THIS"
	abstract_type = /datum/container_craft

	var/atom/output
	/// How many times the output is made. Preferrably for item outputs.
	var/output_amount = 1
	/// If set, item outputs are dropped on the turf
	var/eject_output = FALSE
	/// If set, the output comes off the consumed instance's stamped cook field instead of `output`
	var/handoff_craft = FALSE
	var/category

	var/user_craft = FALSE

	///if this is set we will only ever craft if only the contents are in the bag
	var/isolation_craft = FALSE

	var/list/requirements
	var/list/reagent_requirements
	///this needs a comment, basically if this is set we check for any of these in the path say /obj/item/sword, it will use /obj/item/sword/wooden
	var/list/wildcard_requirements

	var/subtype_reagents_allowed = FALSE

	var/crafting_time = 0
	var/craft_priority = TRUE

	///COOK_FRY, COOK_BAKE, COOK_BOIL or COOK_DEEPFRY. Names which item field a synthesising family reads.
	var/cook_method
	///families where a one-to-one transform is described by the item instead of a recipe datum
	var/synthesize_recipes = FALSE
	///set on the output when the recipe makes an item
	var/datum/pollutant/cooked_smell

	var/cached_specificity

	///this is literally just for html
	var/atom/movable/required_container
	var/craft_verb
	///do we show up in recipe guides
	var/hides_from_books = FALSE
	///our completed message
	var/complete_message = "Something smells good!"
	var/datum/skill/used_skill = /datum/skill/craft/cooking
	///Path of looping_sound to use while cooking
	var/datum/looping_sound/cooking_sound

/datum/container_craft/proc/get_specificity()
	if(!isnull(cached_specificity))
		return cached_specificity
	cached_specificity = 0
	for(var/path in requirements)
		cached_specificity = max(cached_specificity, (length(splittext("[path]", "/")) * 2) + 1)
	for(var/path in wildcard_requirements)
		cached_specificity = max(cached_specificity, length(splittext("[path]", "/")) * 2)
	if(handoff_craft)
		cached_specificity++
	return cached_specificity

/datum/container_craft/proc/handoff_output(obj/item/reagent_containers/food/snacks/source)
	switch(cook_method)
		if(COOK_BAKE)
			return source.cooked_type
		if(COOK_FRY)
			return source.fried_type
		if(COOK_DEEPFRY)
			return source.deep_fried_type
	return null

/datum/container_craft/proc/is_handoff_stamped(obj/item/reagent_containers/food/snacks/source)
	var/result = handoff_output(source)
	if(!result)
		return FALSE
	return result != get_item_cook_result(source.type, cook_method)

/proc/cmp_container_craft_specificity(a, b)
	var/datum/container_craft/recipe_a = GLOB.container_craft_to_singleton[a]
	var/datum/container_craft/recipe_b = GLOB.container_craft_to_singleton[b]
	return (recipe_b ? recipe_b.get_specificity() : 0) - (recipe_a ? recipe_a.get_specificity() : 0)

/datum/container_craft/proc/find_required_reagent(datum/reagents/holder, reagent_type, amount)
	if(!holder)
		return null
	if(!subtype_reagents_allowed)
		return holder.has_reagent(reagent_type, amount)
	for(var/datum/reagent/reagent as anything in holder.reagent_list)
		if(!ispath(reagent.type, reagent_type))
			continue
		if(holder.has_reagent(reagent.type, amount))
			return reagent
	return null

/**
 * Validates if recipe requirements are still met during crafting
 * @param obj/item/crafter The container being crafted in
 * @param list/obj/item/reserved_items List of actual item references reserved for this craft
 * @return TRUE if requirements are still met, FALSE otherwise
 */
/datum/container_craft/proc/requirements_still_met(obj/item/crafter, list/obj/item/reserved_items)
	if(length(reagent_requirements))
		for(var/reagent_type in reagent_requirements)
			if(!find_required_reagent(crafter.reagents, reagent_type, reagent_requirements[reagent_type]))
				return FALSE

	// Check that all reserved items still exist and are in the container
	for(var/obj/item/item in reserved_items)
		if(QDELETED(item) || item.loc != crafter)
			return FALSE

	return TRUE

/datum/container_craft/proc/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	var/highest_multiplier = 0

	if(handoff_craft)
		var/list/stamped_items = list()
		for(var/obj/item/reagent_containers/food/snacks/candidate in crafter.contents)
			if(!pathed_items[candidate.type] || !is_handoff_stamped(candidate))
				continue
			stamped_items |= candidate.type
			stamped_items[candidate.type]++
		if(!length(stamped_items))
			return FALSE
		pathed_items = stamped_items

	// Check reagent requirements
	var/reagent_multiplier = 0
	if(length(reagent_requirements))
		for(var/reagent_type in reagent_requirements)
			var/datum/reagent/found_reagent = find_required_reagent(crafter.reagents, reagent_type, reagent_requirements[reagent_type])
			if(!found_reagent)
				return FALSE
			var/possible_multiplier = FLOOR(found_reagent.volume / reagent_requirements[reagent_type], 1)
			if(!reagent_multiplier || possible_multiplier < reagent_multiplier)
				reagent_multiplier = possible_multiplier
		// var/list/fake_reagents = reagent_requirements.Copy()
		// var/list/available_reagents = list()
		// for(var/datum/reagent/listed_reagent as anything in crafter.reagents.reagent_list)
		// 	available_reagents[listed_reagent.type] = listed_reagent.volume

		// for(var/required_path as anything in fake_reagents)
		// 	var/required_amount = fake_reagents[required_path]
		// 	for(var/path in available_reagents)
		// 		if(subtype_reagents_allowed ? !ispath(path, required_path) : path != required_path)
		// 			continue
		// 		required_amount -= available_reagents[path]
		// 		if(required_amount <= 0)
		// 			break
		// 	if(required_amount > 0)
		// 		return FALSE

	// Make copies to track what we're consuming
	var/list/fake_requirements = requirements?.Copy()
	var/list/fake_wildcards = wildcard_requirements?.Copy()
	var/list/available_items = pathed_items.Copy()

	// Process regular requirements first
	if(length(fake_requirements))
		for(var/requirement_path in fake_requirements)
			if(!available_items[requirement_path] || available_items[requirement_path] < fake_requirements[requirement_path])
				return FALSE

			var/potential_multiplier = FLOOR(available_items[requirement_path] / fake_requirements[requirement_path], 1)
			if(!highest_multiplier)
				highest_multiplier = potential_multiplier
			else if(potential_multiplier < highest_multiplier)
				highest_multiplier = potential_multiplier

			// Mark these items as consumed
			available_items[requirement_path] -= fake_requirements[requirement_path]
			if(available_items[requirement_path] <= 0)
				available_items -= requirement_path

	// Process wildcard requirements
	if(length(fake_wildcards))
		for(var/wildcard in fake_wildcards)
			var/needed = fake_wildcards[wildcard]
			var/found = 0

			// Find items that match this wildcard
			for(var/obj/item/path as anything in available_items)
				if(!ispath(path, wildcard))
					continue

				var/can_use = min(available_items[path], needed - found)
				found += can_use
				available_items[path] -= can_use

				if(available_items[path] <= 0)
					available_items -= path

				if(found >= needed)
					break

			// Check if we found enough items for this wildcard
			if(found < needed)
				return FALSE

			// Calculate multiplier based on what we found
			var/potential_multiplier = FLOOR(found / fake_wildcards[wildcard], 1)
			if(!highest_multiplier)
				highest_multiplier = potential_multiplier
			else if(potential_multiplier < highest_multiplier)
				highest_multiplier = potential_multiplier

	if(reagent_multiplier && reagent_multiplier < highest_multiplier)
		highest_multiplier = reagent_multiplier

	if(isolation_craft && length(available_items))
		return FALSE

	//if we don't have at least this nothing worked
	if(highest_multiplier < 1)
		return FALSE

	if(!initiator)
		initiator = get_mob_by_ckey(crafter.fingerprintslast)
	var/datum/callback/on_craft_start_ref = on_craft_start
	var/datum/callback/on_craft_fail_ref = on_craft_failed
	if(!on_craft_start_ref)
		on_craft_start_ref = create_start_callback(crafter, initiator, highest_multiplier)
	if(!on_craft_fail_ref)
		on_craft_fail_ref = create_fail_callback(crafter, initiator, highest_multiplier)
	new /datum/container_craft_operation(crafter, src, initiator, highest_multiplier, on_craft_start_ref, on_craft_fail_ref, cooking_sound)
	return TRUE

/datum/container_craft/proc/create_start_callback(crafter, initiator, highest_multiplier)
	return CALLBACK(src, PROC_REF(announce_start))

/datum/container_craft/proc/create_fail_callback(crafter, initiator, highest_multiplier)
	return CALLBACK(src, PROC_REF(announce_fail))

/datum/container_craft/proc/announce_start(atom/crafter, mob/initiator, estimated_multiplier)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_notice("The [LOWER_TEXT(name)] starts to cook."))

/datum/container_craft/proc/announce_fail(atom/crafter, mob/initiator)
	if(QDELETED(crafter))
		return
	crafter.visible_message(span_warning("The [LOWER_TEXT(name)] stops cooking."))

/datum/container_craft/proc/get_craft_candidates(obj/item/crafter, list/obj/item/reserved_items)
	var/list/obj/item/off_limits = list()
	for(var/datum/container_craft_operation/other_craft in GLOB.active_container_crafts)
		if(other_craft.crafter != crafter)
			continue
		off_limits |= other_craft.stored_items

	var/list/obj/item/candidates = list()
	for(var/obj/item/item in reserved_items)
		if(QDELETED(item) || item.loc != crafter)
			continue
		candidates |= item
	for(var/obj/item/item in crafter.contents)
		if(item in off_limits)
			continue
		candidates |= item
	return candidates

/**
 * Handles the final execution of the craft after processing is complete
 */
/datum/container_craft/proc/execute_craft_completion(obj/item/crafter, mob/living/initiator, estimated_multiplier, list/obj/item/reserved_items)
	var/crafted_any = FALSE
	for(var/i = 1 to estimated_multiplier)
		// First validate that all requirements are still present
		var/list/obj/item/candidates = get_craft_candidates(crafter, reserved_items)
		var/list/stored_items = list()
		for(var/obj/item/item as anything in candidates)
			stored_items |= item.type
			stored_items[item.type]++

		// Track which items to remove, indexed by type
		var/list/items_to_remove = list()
		// Track which actual item objects we'll remove
		var/list/obj/item/items_to_delete = list()

		var/list/passed_reagents = list()
		var/batch_exhausted = FALSE

		if(length(reagent_requirements))
			for(var/reagent as anything in reagent_requirements)
				var/datum/reagent/reagent_found = find_required_reagent(crafter.reagents, reagent, reagent_requirements[reagent])
				if(!reagent_found)
					batch_exhausted = TRUE
					break
				passed_reagents[reagent_found.type] = reagent_requirements[reagent]

		if(!batch_exhausted && length(requirements))
			for(var/item_type in requirements)
				if(stored_items[item_type] < requirements[item_type])
					batch_exhausted = TRUE
					break
				items_to_remove[item_type] = requirements[item_type]

		if(!batch_exhausted && length(wildcard_requirements))
			for(var/wildcard in wildcard_requirements)
				var/items_found = 0
				var/amount_needed = wildcard_requirements[wildcard]

				for(var/obj/item/candidate_item as anything in candidates)
					if(ispath(candidate_item.type, wildcard) && !(candidate_item in items_to_delete))
						items_found++
						items_to_delete += candidate_item

						if(items_found >= amount_needed)
							break

				if(items_found < amount_needed)
					batch_exhausted = TRUE
					break

		if(batch_exhausted)
			break

		// Remove reagents first
		for(var/reagent in passed_reagents)
			crafter.reagents.remove_reagent(reagent, passed_reagents[reagent])

		// Remove items by type
		for(var/item_type in items_to_remove)
			var/amount_to_remove = items_to_remove[item_type]
			for(var/obj/item/candidate_item as anything in candidates)
				if(amount_to_remove <= 0)
					break
				if(candidate_item.type == item_type && !(candidate_item in items_to_delete))
					items_to_delete += candidate_item
					amount_to_remove--

		for(var/obj/item/item_to_delete in items_to_delete)
			SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_TAKE, item_to_delete, get_turf(crafter))

		create_item(crafter, initiator, items_to_delete)

		if(isliving(initiator) && initiator.mind)
			add_sleep_experience(initiator, used_skill, initiator.STAINT * 0.5)
		// Remove all tracked items
		for(var/obj/item/item_to_delete in items_to_delete)
			qdel(item_to_delete)

		crafted_any = TRUE

	if(!crafted_any || QDELETED(crafter))
		return FALSE
	crafter.visible_message(span_green(complete_message))
	return TRUE

/datum/container_craft/proc/create_item(obj/item/crafter, mob/living/initiator, list/removing_items)
	if(handoff_craft)
		create_handoff_items(crafter, initiator, removing_items)
		return
	for(var/j = 1 to output_amount)
		var/atom/created_output = new output(get_turf(crafter))
		if(!eject_output)
			SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, TRUE, TRUE)
		after_craft(created_output, crafter, initiator, removing_items)
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/datum/container_craft/proc/create_handoff_items(obj/item/crafter, mob/living/initiator, list/removing_items)
	for(var/obj/item/reagent_containers/food/snacks/source as anything in removing_items.Copy())
		var/atom/result = handoff_output(source)
		if(!result || !is_handoff_stamped(source))
			removing_items -= source
			SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, source, null, TRUE, TRUE)
			continue
		var/atom/created_output = new result(get_turf(crafter))
		if(!eject_output)
			SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, TRUE, TRUE)
		if(source.cooked_smell)
			created_output.AddComponent(/datum/component/temporary_pollution_emission, source.cooked_smell, 20, 5 MINUTES)
		after_craft(created_output, crafter, initiator, list(source))
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/datum/container_craft/proc/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/removing_items)
	// This is an extension point for specific crafting types to do additional processing
	return

/datum/container_craft/proc/get_real_time(atom/host, mob/user, estimated_multiplier)
	return crafting_time * estimated_multiplier

/datum/container_craft/proc/check_failure(obj/item/crafter, mob/user)
	return FALSE

/datum/container_craft/proc/can_progress(obj/item/crafter, mob/user)
	return TRUE

/datum/container_craft/proc/announce_stall(atom/crafter, mob/initiator)
	return

/datum/container_craft/proc/announce_resume(atom/crafter, mob/initiator)
	return

/datum/container_craft/proc/extra_html()
	return

/datum/container_craft/proc/ingredient_html(mob/user, path, amount, subtypes_allowed = FALSE)
	var/atom/ingredient = path
	var/mutable_appearance/preview = mutable_appearance(initial(ingredient.icon), initial(ingredient.icon_state))
	var/line = "<li>[icon2html(preview, user)] [initial(ingredient.name)]"
	if(amount > 1)
		line += " &times; [amount]"
	if(subtypes_allowed)
		line += " <i>(or anything of the kind)</i>"
	return line + "</li>"

/// Group recipes that makes the same products together
/datum/container_craft/proc/book_group_key()
	return "[required_container]|[name]"

/datum/container_craft/proc/book_group()
	var/list/members = GLOB.container_craft_book_groups[book_group_key()]
	return length(members) ? members : list(type)

/datum/container_craft/proc/is_book_canonical()
	var/list/members = book_group()
	return members[1] == type

/datum/container_craft/proc/generate_html(mob/user)
	var/atom/vessel = required_container
	var/html = "<h2>[name]</h2>"

	if(vessel)
		html += "<p>Prepared in a [LOWER_TEXT(initial(vessel.name))].</p>"

	var/list/members = book_group()
	var/list/alternatives = list()
	for(var/member_type as anything in members)
		var/datum/container_craft/member = GLOB.container_craft_to_singleton[member_type]
		if(!member)
			continue
		for(var/path in member.requirements)
			alternatives |= ingredient_html(user, path, member.requirements[path])
		for(var/path in member.wildcard_requirements)
			alternatives |= ingredient_html(user, path, member.wildcard_requirements[path], TRUE)

	if(length(alternatives))
		html += length(alternatives) > 1 ? "<p>Needs any one of:</p><ul>" : "<p>Needs:</p><ul>"
		html += alternatives.Join("")
		html += "</ul>"

	if(length(reagent_requirements))
		html += "<p>Plus:</p><ul>"
		for(var/datum/reagent/path as anything in reagent_requirements)
			html += "<li>[reagent_requirements[path]]dr of [initial(path.name)]</li>"
		html += "</ul>"

	var/extra = extra_html()
	if(extra)
		html += "<p>Yields [extra]</p>"
	else if(output)
		var/atom/result = output
		html += "<p>Yields [output_amount > 1 ? "[output_amount] &times; " : ""][initial(result.name)].</p>"

	html += "<p>Takes about [crafting_time / 10] seconds, faster the more skilled you are.</p>"
	return html
