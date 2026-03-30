/datum/aspect_picker
	var/mob/living/owner
	var/initial_setup = TRUE
	var/list/pointbuy_selections = list()
	/// Staged selections - not applied until confirm. List of type paths.
	var/list/staged_majors = list()
	var/list/staged_minors = list()
	/// Selected utility spell paths (string paths)
	var/list/staged_utilities = list()
	/// Staged choice selections — assoc list: aspect_path_str = spell_path_str
	var/list/staged_choices = list()
	/// Staged unbinds — aspect type paths to remove on confirm (edit mode)
	var/list/staged_unbind_aspects = list()
	/// Staged utility unbinds — spell path strings to remove on confirm (edit mode)
	var/list/staged_unbind_utilities = list()
	/// Whether to grant mastery variants (T4)
	var/mastery = FALSE
	/// Overrides for max slots. 0 = tab locked.
	var/override_max_majors
	var/override_max_minors
	var/max_utilities = 0
	/// Aspect type paths that are pre-bound and cannot be removed
	var/list/locked_aspects = list()
	/// TRUE while performing binding/unbinding chants — prevents ui_close from qdel'ing
	var/chanting = FALSE
	/// Assoc list of variant overrides from class config: aspect_path = variant_name (e.g. /datum/magic_aspect/pyromancy = "grenzelhoftian")
	var/list/variant_overrides
	/// Spell paths granted after aspects are bound - ensures proper action bar ordering (e.g. class-granted Message, Magician's Brick)
	var/list/post_aspect_spells

/datum/aspect_picker/New(mob/living/new_owner, setup = TRUE, list/aspect_config)
	owner = new_owner
	initial_setup = setup
	if(length(aspect_config))
		mastery = aspect_config["mastery"]
		override_max_majors = aspect_config["major"]
		override_max_minors = aspect_config["minor"]
		max_utilities = aspect_config["utilities"] || 0
		if(islist(aspect_config["variants"]))
			variant_overrides = aspect_config["variants"]
		if(islist(aspect_config["post_aspect_spells"]))
			post_aspect_spells = aspect_config["post_aspect_spells"]
		if(length(aspect_config["locked_aspects"]))
			for(var/path in aspect_config["locked_aspects"])
				locked_aspects += path
				// Auto-stage locked aspects only if not already bound
				if(new_owner.mind && new_owner.mind.has_aspect(path))
					continue
				var/datum/magic_aspect/temp = new path
				switch(temp.aspect_type)
					if(ASPECT_MAJOR)
						staged_majors |= path
					if(ASPECT_MINOR)
						staged_minors |= path
				qdel(temp)

/datum/aspect_picker/Destroy()
	owner = null
	. = ..()

/datum/aspect_picker/ui_state(mob/user)
	return GLOB.always_state

/datum/aspect_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GrimoireAspectPicker", "Grimoire", 860, 580)
		ui.open()

/datum/aspect_picker/ui_static_data(mob/user)
	var/list/data = list()
	data["major_aspects"] = build_aspect_list(GLOB.magic_aspects_major)
	data["minor_aspects"] = build_aspect_list(GLOB.magic_aspects_minor)
	data["utility_spells"] = build_utility_list()
	return data

/datum/aspect_picker/ui_data(mob/user)
	var/list/data = list()
	if(!owner?.mind)
		return data
	data["user_tier"] = mastery ? 4 : (HAS_TRAIT(owner, TRAIT_ARCYNE) ? 3 : 0)
	data["max_majors"] = isnull(override_max_majors) ? MAX_MAJOR_ASPECTS : override_max_majors
	data["max_minors"] = isnull(override_max_minors) ? MAX_MINOR_ASPECTS : override_max_minors
	data["max_utilities"] = max_utilities
	data["initial_setup"] = initial_setup
	// Send locked aspect paths to the UI
	var/list/locked_paths = list()
	for(var/path in locked_aspects)
		locked_paths += "[path]"
	data["locked_aspects"] = locked_paths

	// Send variant overrides so the UI can highlight which variant applies per aspect
	var/list/variant_override_paths = list()
	if(LAZYLEN(variant_overrides))
		for(var/path in variant_overrides)
			variant_override_paths["[path]"] = variant_overrides[path]
	data["variant_overrides"] = variant_override_paths

	// Show both already-attuned and staged selections
	data["attuned_majors"] = list()
	for(var/datum/magic_aspect/A in owner.mind.major_aspects)
		data["attuned_majors"] += "[A.type]"
	for(var/path in staged_majors)
		data["attuned_majors"] |= "[path]"

	data["attuned_minors"] = list()
	for(var/datum/magic_aspect/A in owner.mind.minor_aspects)
		data["attuned_minors"] += "[A.type]"
	for(var/path in staged_minors)
		data["attuned_minors"] |= "[path]"

	data["staged_choices"] = staged_choices
	data["pointbuy_selections"] = pointbuy_selections
	data["selected_utilities"] = staged_utilities
	data["utility_points_spent"] = get_utility_points_spent()

	// Utilities the user already knows (for edit mode display)
	var/list/known_utilities = list()
	var/list/given_utilities = list()
	for(var/path in GLOB.utility_spells)
		if(owner.mind.has_spell(path))
			known_utilities += "[path]"
			if(!is_utility_learned(path))
				given_utilities += "[path]"
	data["known_utilities"] = known_utilities
	data["given_utilities"] = given_utilities

	// Reset budget for unbinding (account for staged unbinds)
	var/staged_cost = get_staged_reset_cost()
	data["reset_budget"] = owner.mind.get_aspect_reset_remaining() - staged_cost
	data["reset_budget_max"] = ASPECT_RESET_BUDGET
	data["resets_used"] = owner.mind.aspect_resets_used

	// Staged unbinds
	var/list/unbind_aspect_paths = list()
	for(var/path in staged_unbind_aspects)
		unbind_aspect_paths += "[path]"
	data["staged_unbind_aspects"] = unbind_aspect_paths
	data["staged_unbind_utilities"] = staged_unbind_utilities

	// Collect all selected/granted spell paths so the UI can grey out duplicates
	// This includes choice selections, pointbuy selections, AND fixed spells from all staged aspects
	var/list/all_selected_spells = list()
	for(var/aspect_path_str in staged_choices)
		all_selected_spells |= staged_choices[aspect_path_str]
	for(var/aspect_path_str in pointbuy_selections)
		var/list/selections = pointbuy_selections[aspect_path_str]
		for(var/spell_path_str in selections)
			all_selected_spells |= spell_path_str
	// Include fixed spells from already-attuned and staged aspects
	var/list/all_staged = staged_majors + staged_minors
	for(var/datum/magic_aspect/A in owner.mind.major_aspects)
		for(var/spell_path in A.fixed_spells)
			all_selected_spells |= "[spell_path]"
	for(var/datum/magic_aspect/A in owner.mind.minor_aspects)
		for(var/spell_path in A.fixed_spells)
			all_selected_spells |= "[spell_path]"
	for(var/staged_path in all_staged)
		var/datum/magic_aspect/staged = new staged_path
		for(var/spell_path in staged.fixed_spells)
			all_selected_spells |= "[spell_path]"
		qdel(staged)
	// Include spells the owner already knows (pre-granted by class, etc.)
	for(var/datum/action/cooldown/spell/S in owner.mind.spell_list)
		all_selected_spells |= "[S.type]"
	for(var/obj/effect/proc_holder/spell/S in owner.mind.spell_list)
		all_selected_spells |= "[S.type]"
	data["all_selected_spells"] = all_selected_spells

	// Collect spent budget per aspect
	var/list/spent_budgets = list()
	for(var/aspect_path_str in pointbuy_selections)
		var/resolved = text2path(aspect_path_str)
		if(!resolved)
			continue
		var/datum/magic_aspect/temp = new resolved
		spent_budgets[aspect_path_str] = get_pointbuy_spent(aspect_path_str, temp)
		qdel(temp)
	data["spent_budgets"] = spent_budgets

	return data

/datum/aspect_picker/proc/build_aspect_list(list/aspect_paths)
	var/list/result = list()
	for(var/path in aspect_paths)
		var/datum/magic_aspect/A = new path
		var/list/entry = list()
		entry["path"] = "[path]"
		entry["name"] = A.name
		entry["latin_name"] = A.latin_name
		entry["desc"] = A.desc
		entry["aspect_type"] = A.aspect_type
		entry["attuned_name"] = A.attuned_name
		entry["school_color"] = A.school_color
		entry["pointbuy_budget"] = A.pointbuy_budget

		entry["choice_spells"] = list()
		for(var/spell_path in A.choice_spells)
			entry["choice_spells"] += list(build_spell_entry(spell_path))

		entry["fixed_spells"] = list()
		for(var/spell_path in A.fixed_spells)
			entry["fixed_spells"] += list(build_spell_entry(spell_path))

		entry["pointbuy_spells"] = list()
		for(var/spell_path in A.pointbuy_spells)
			entry["pointbuy_spells"] += list(build_spell_entry(spell_path))

		// Include variant info so the UI can show spell swaps
		entry["variants"] = list()
		for(var/variant_name in A.variants)
			var/list/variant_entry = list()
			variant_entry["name"] = variant_name
			variant_entry["swaps"] = list()
			var/list/swaps = A.variants[variant_name]
			for(var/base_path in swaps)
				var/upgrade_path = swaps[base_path]
				var/list/swap_entry = list()
				swap_entry["from"] = (base_path == VARIANT_ADDITIVE) ? null : "[base_path]"
				swap_entry["to"] = build_spell_entry(upgrade_path)
				variant_entry["swaps"] += list(swap_entry)
			entry["variants"] += list(variant_entry)

		result += list(entry)
		qdel(A)
	// Sort alphabetically by name
	sortTim(result, GLOBAL_PROC_REF(cmp_list_name_asc))
	return result

/datum/aspect_picker/proc/build_spell_entry(spell_path)
	var/list/entry = list()
	entry["path"] = "[spell_path]"
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		entry["name"] = initial(S.name)
		entry["desc"] = initial(S.desc)
		entry["fluff_desc"] = initial(S.fluff_desc)
		entry["cost"] = initial(S.point_cost)
	else
		var/obj/effect/proc_holder/spell/S = spell_path
		entry["name"] = initial(S.name)
		entry["desc"] = initial(S.desc)
		entry["fluff_desc"] = ""
		entry["cost"] = initial(S.cost)
	return entry

/datum/aspect_picker/proc/build_utility_list()
	var/list/result = list()
	var/has_aspect_access = (isnull(override_max_minors) || override_max_minors > 0) || (isnull(override_max_majors) || override_max_majors > 0)
	for(var/path in GLOB.utility_spells)
		if(ispath(path, /datum/action/cooldown/spell))
			var/datum/action/cooldown/spell/S = path
			if(initial(S.requires_aspect_access) && !has_aspect_access)
				continue
		result += list(build_spell_entry(path))
	sortTim(result, GLOBAL_PROC_REF(cmp_list_name_asc))
	return result

/datum/aspect_picker/ui_act(action, list/params)
	if(..())
		return
	if(!owner?.mind)
		return

	var/max_majors = isnull(override_max_majors) ? MAX_MAJOR_ASPECTS : override_max_majors
	var/max_minors_resolved = isnull(override_max_minors) ? MAX_MINOR_ASPECTS : override_max_minors

	switch(action)
		if("attune")
			var/path = text2path(params["path"])
			if(!path)
				return
			// Don't re-select something already live or staged
			if(owner.mind.has_aspect(path))
				return
			// Determine if major or minor
			var/datum/magic_aspect/temp = new path
			var/aspect_type = temp.aspect_type
			qdel(temp)
			// Count live aspects minus pending unbinds for effective slot usage
			var/major_unbind_count = 0
			var/minor_unbind_count = 0
			for(var/unbind_path in staged_unbind_aspects)
				var/datum/magic_aspect/utemp = new unbind_path
				if(utemp.aspect_type == ASPECT_MAJOR)
					major_unbind_count++
				else
					minor_unbind_count++
				qdel(utemp)
			switch(aspect_type)
				if(ASPECT_MAJOR)
					var/effective = LAZYLEN(owner.mind.major_aspects) - major_unbind_count + length(staged_majors)
					if(effective >= max_majors)
						to_chat(owner, span_warning("I cannot select another major aspect."))
						return
					if(path in staged_majors)
						return
					staged_majors += path
				if(ASPECT_MINOR)
					var/effective = LAZYLEN(owner.mind.minor_aspects) - minor_unbind_count + length(staged_minors)
					if(effective >= max_minors_resolved)
						to_chat(owner, span_warning("I cannot select another minor aspect."))
						return
					if(path in staged_minors)
						return
					staged_minors += path
			. = TRUE

		if("remove")
			var/path = text2path(params["path"])
			if(!path)
				return
			if(path in locked_aspects)
				return
			if(initial_setup)
				staged_majors -= path
				staged_minors -= path
				pointbuy_selections -= params["path"]
			else
				// Edit mode — stage the unbind, check budget
				var/is_live = owner.mind.has_aspect(path)
				if(is_live)
					if(path in staged_unbind_aspects)
						return // Already staged for unbind
					// Check if budget allows this unbind (preview cost)
					var/datum/magic_aspect/temp = new path
					var/cost = (temp.aspect_type == ASPECT_MAJOR) ? ASPECT_RESET_COST_MAJOR : ASPECT_RESET_COST_MINOR
					qdel(temp)
					if(get_staged_reset_cost() + cost > owner.mind.get_aspect_reset_remaining())
						to_chat(owner, span_warning("I cannot reshape any more attunements without rest."))
						return
					staged_unbind_aspects += path
				else
					// It was a newly staged pick, just remove it
					staged_majors -= path
					staged_minors -= path
					pointbuy_selections -= params["path"]
			. = TRUE

		if("undo_unbind")
			var/path = text2path(params["path"])
			if(!path)
				return
			staged_unbind_aspects -= path
			// If undoing this unbind would exceed the slot limit, clear staged replacements of the same type
			var/datum/magic_aspect/temp = new path
			var/restored_type = temp.aspect_type
			qdel(temp)
			if(restored_type == ASPECT_MAJOR)
				var/max_maj = isnull(override_max_majors) ? MAX_MAJOR_ASPECTS : override_max_majors
				var/current_count = length(owner.mind.major_aspects) - length(staged_unbind_aspects & get_attuned_paths(ASPECT_MAJOR))
				// Remove staged majors that aren't already attuned until we're within budget
				while(current_count + length(staged_majors - get_attuned_paths(ASPECT_MAJOR)) > max_maj)
					var/list/removable = staged_majors - get_attuned_paths(ASPECT_MAJOR)
					removable -= locked_aspects
					if(!length(removable))
						break
					staged_majors -= removable[length(removable)]
			else if(restored_type == ASPECT_MINOR)
				var/max_min = isnull(override_max_minors) ? MAX_MINOR_ASPECTS : override_max_minors
				var/current_count = length(owner.mind.minor_aspects) - length(staged_unbind_aspects & get_attuned_paths(ASPECT_MINOR))
				while(current_count + length(staged_minors - get_attuned_paths(ASPECT_MINOR)) > max_min)
					var/list/removable = staged_minors - get_attuned_paths(ASPECT_MINOR)
					removable -= locked_aspects
					if(!length(removable))
						break
					staged_minors -= removable[length(removable)]
			. = TRUE

		if("unbind_utility")
			var/spell_path_str = params["spell_path"]
			if(!spell_path_str)
				return
			if(spell_path_str in staged_unbind_utilities)
				return
			var/spell_path = text2path(spell_path_str)
			if(!spell_path || !owner.mind.has_spell(spell_path))
				return
			// Can't unbind spells given by aspects — only player-picked utilities
			if(!is_utility_learned(spell_path))
				return
			if(get_staged_reset_cost() + ASPECT_RESET_COST_UTILITY > owner.mind.get_aspect_reset_remaining())
				to_chat(owner, span_warning("I cannot reshape any more attunements without rest."))
				return
			staged_unbind_utilities += spell_path_str
			. = TRUE

		if("undo_unbind_utility")
			var/spell_path_str = params["spell_path"]
			if(!spell_path_str)
				return
			staged_unbind_utilities -= spell_path_str
			. = TRUE

		if("choice_toggle")
			var/aspect_path = params["aspect_path"]
			var/spell_path = params["spell_path"]
			if(!aspect_path || !spell_path)
				return
			// Exclusive toggle — selecting one deselects the previous
			if(staged_choices[aspect_path] == spell_path)
				staged_choices -= aspect_path
			else
				if(is_spell_selected_elsewhere(spell_path, aspect_path))
					to_chat(owner, span_warning("I have already selected this spell from another aspect."))
					return
				staged_choices[aspect_path] = spell_path
			. = TRUE

		if("pointbuy_toggle")
			var/aspect_path = params["aspect_path"]
			var/spell_path = params["spell_path"]
			if(!aspect_path || !spell_path)
				return
			if(!pointbuy_selections[aspect_path])
				pointbuy_selections[aspect_path] = list()
			var/list/selections = pointbuy_selections[aspect_path]
			if(spell_path in selections)
				selections -= spell_path
			else
				// Check if this spell is already selected in another aspect
				if(is_spell_selected_elsewhere(spell_path, aspect_path))
					to_chat(owner, span_warning("I have already selected this spell from another aspect."))
					return
				// Check budget before adding
				var/resolved_aspect_path = text2path(aspect_path)
				if(resolved_aspect_path)
					var/datum/magic_aspect/temp = new resolved_aspect_path
					var/budget = temp.pointbuy_budget
					var/spent = get_pointbuy_spent(aspect_path, temp)
					var/spell_cost = get_spell_cost_from_path(text2path(spell_path))
					qdel(temp)
					if(spent + spell_cost > budget)
						to_chat(owner, span_warning("Not enough points remaining in this aspect's budget."))
						return
				selections += spell_path
			. = TRUE

		if("utility_toggle")
			var/spell_path = params["spell_path"]
			if(!spell_path)
				return
			if(spell_path in staged_utilities)
				staged_utilities -= spell_path
			else
				var/resolved_path = text2path(spell_path)
				if(ispath(resolved_path, /datum/action/cooldown/spell))
					var/datum/action/cooldown/spell/S = resolved_path
					if(initial(S.requires_aspect_access))
						var/has_aspect_access = (isnull(override_max_minors) || override_max_minors > 0) || (isnull(override_max_majors) || override_max_majors > 0)
						if(!has_aspect_access)
							to_chat(owner, span_warning("This spell requires deeper arcyne training to learn."))
							return
				var/spell_cost = get_spell_cost_from_path(text2path(spell_path))
				if(get_utility_points_spent() + spell_cost > max_utilities)
					to_chat(owner, span_warning("Not enough utility points remaining."))
					return
				staged_utilities += spell_path
			. = TRUE

		if("confirm")
			var/has_new_aspects = length(staged_majors) || length(staged_minors)
			var/has_new_utilities = length(staged_utilities)
			var/has_unbinds = length(staged_unbind_aspects) || length(staged_unbind_utilities)
			var/has_pointbuy = length(pointbuy_selections)
			var/has_choices = length(staged_choices)
			if(!has_new_aspects && !has_new_utilities && !has_unbinds && !has_pointbuy && !has_choices)
				owner.mind.ensure_mage_basics()
				owner.mind.check_learnspell()
				to_chat(owner, span_warning("You must select something before sealing."))
				return

			// Choice spell validation removed — attune_aspect() auto-resolves:
			// prefers an already-inscribed choice spell, else falls back to first in list

			if(chanting)
				return
			// Hand off to async proc - do_after sleeps, which ui_act cannot do directly
			INVOKE_ASYNC(src, PROC_REF(perform_confirm), max_majors, max_minors_resolved)
			return TRUE

/// Async confirm handler - performs chants then applies all staged changes.
/// Chanting only happens when there are unbinds (i.e. reshaping, not initial setup).
/// If interrupted, staged data is preserved so the player can retry.
/datum/aspect_picker/proc/perform_confirm(max_majors, max_minors_resolved)
	var/major_unbinds = 0
	for(var/unbind_path in staged_unbind_aspects)
		var/datum/magic_aspect/utemp = new unbind_path
		if(utemp.aspect_type == ASPECT_MAJOR)
			major_unbinds++
		qdel(utemp)
	var/effective_majors = LAZYLEN(owner.mind.major_aspects) - major_unbinds + length(staged_majors)
	if(effective_majors > max_majors)
		to_chat(owner, span_warning("Too many major aspects selected."))
		return

	// Validate minor aspect count
	var/minor_unbinds = 0
	for(var/unbind_path in staged_unbind_aspects)
		var/datum/magic_aspect/utemp = new unbind_path
		if(utemp.aspect_type == ASPECT_MINOR)
			minor_unbinds++
		qdel(utemp)
	var/effective_minors = LAZYLEN(owner.mind.minor_aspects) - minor_unbinds + length(staged_minors)
	if(effective_minors > max_minors_resolved)
		to_chat(owner, span_warning("Too many minor aspects selected."))
		return

	// Validate utility points - count already-known picked utilities plus new staged ones
	if(max_utilities > 0)
		var/util_total = 0
		for(var/path in GLOB.utility_spells)
			var/path_str = "[path]"
			if(path_str in staged_unbind_utilities)
				continue
			if(owner.mind.has_spell(path))
				if(!is_utility_learned(path))
					continue
				util_total += get_spell_cost_from_path(path)
		for(var/spell_path_str in staged_utilities)
			util_total += get_spell_cost_from_path(text2path(spell_path_str))
		if(util_total > max_utilities)
			to_chat(owner, span_warning("Too many utility spells selected."))
			return

	chanting = TRUE
	var/has_unbinds = length(staged_unbind_aspects) || length(staged_unbind_utilities)

	// Close the UI before chanting begins
	SStgui.close_uis(src)

	if(has_unbinds)
		// Build a list of spells that will survive the reshaping — from aspects being kept and newly staged aspects.
		// revoke_spells() will skip these so overlapping spells aren't deleted.
		var/list/surviving_spells = list()
		// Spells from aspects that are staying (not being unbound)
		for(var/datum/magic_aspect/A in owner.mind.major_aspects + owner.mind.minor_aspects)
			if(A.type in staged_unbind_aspects)
				continue
			surviving_spells |= A.fixed_spells
			// Only preserve the choice spell this aspect actually granted, not all options
			if(A.chosen_spell)
				surviving_spells |= A.chosen_spell
		// Spells from newly staged aspects about to be added
		for(var/staged_path in staged_majors + staged_minors)
			var/datum/magic_aspect/staged = new staged_path
			surviving_spells |= staged.fixed_spells
			// Preserve the explicit choice, or the one the player already has (attune_aspect will auto-resolve)
			var/chosen = staged_choices["[staged_path]"] ? text2path(staged_choices["[staged_path]"]) : null
			if(!chosen)
				for(var/candidate in staged.choice_spells)
					if(owner.mind.has_spell(candidate))
						chosen = candidate
						break
			if(!chosen && length(staged.choice_spells))
				chosen = staged.choice_spells[1]
			if(chosen)
				surviving_spells |= chosen
			qdel(staged)
		// Post-aspect spells from class config
		for(var/post_path in post_aspect_spells)
			surviving_spells |= post_path
		// Utility spells the player learned (not being unbound)
		for(var/spell_path_str in staged_utilities)
			surviving_spells |= text2path(spell_path_str)

		// Perform unbinding chants for staged aspect unbinds (not utility unbinds)
		for(var/unbind_path in staged_unbind_aspects)
			var/datum/magic_aspect/target
			for(var/datum/magic_aspect/A in owner.mind.major_aspects)
				if(A.type == unbind_path)
					target = A
					break
			if(!target)
				for(var/datum/magic_aspect/A in owner.mind.minor_aspects)
					if(A.type == unbind_path)
						target = A
						break
			if(!target)
				continue
			if(!target.perform_chant(owner, binding = FALSE))
				to_chat(owner, span_warning("The unbinding chant was interrupted. I can try again."))
				chanting = FALSE
				return
			if(!owner.mind.spend_aspect_reset(target))
				to_chat(owner, span_warning("Not enough reset budget remaining."))
				continue
			owner.mind.remove_aspect(target, surviving_spells)
			qdel(target)

		// Utility unbinds - no chant required
		for(var/unbind_spell_str in staged_unbind_utilities)
			var/unbind_spell = text2path(unbind_spell_str)
			if(unbind_spell && owner.mind.has_spell(unbind_spell))
				if(!owner.mind.spend_utility_reset())
					to_chat(owner, span_warning("Not enough reset budget remaining."))
					continue
				owner.mind.RemoveSpell(unbind_spell)

	// Apply new aspect attunements - chant only if reshaping (has_unbinds)
	for(var/path in staged_majors)
		if(owner.mind.has_aspect(path))
			continue
		var/datum/magic_aspect/aspect = new path
		if(has_unbinds)
			if(!aspect.perform_chant(owner, binding = TRUE))
				to_chat(owner, span_warning("The binding chant was interrupted. I can try again."))
				qdel(aspect)
				chanting = FALSE
				return
		// Check for class variant override on this specific aspect, otherwise mastery
		var/variant = LAZYLEN(variant_overrides) ? variant_overrides[path] : null
		if(!variant && mastery)
			variant = "mastery"
		var/choice = staged_choices["[path]"] ? text2path(staged_choices["[path]"]) : null
		if(!owner.mind.attune_aspect(aspect, variant, choice))
			qdel(aspect)
	for(var/path in staged_minors)
		if(owner.mind.has_aspect(path))
			continue
		var/datum/magic_aspect/aspect = new path
		if(has_unbinds)
			if(!aspect.perform_chant(owner, binding = TRUE))
				to_chat(owner, span_warning("The binding chant was interrupted. I can try again."))
				qdel(aspect)
				chanting = FALSE
				return
		var/variant = LAZYLEN(variant_overrides) ? variant_overrides[path] : null
		if(!variant && mastery)
			variant = "mastery"
		var/choice = staged_choices["[path]"] ? text2path(staged_choices["[path]"]) : null
		if(!owner.mind.attune_aspect(aspect, variant, choice))
			qdel(aspect)
	// Apply pointbuy selections for attuned aspects
	for(var/aspect_path_str in pointbuy_selections)
		var/aspect_path = text2path(aspect_path_str)
		if(!aspect_path)
			continue
		var/datum/magic_aspect/attuned
		for(var/datum/magic_aspect/A in owner.mind.major_aspects)
			if(A.type == aspect_path)
				attuned = A
				break
		if(!attuned)
			for(var/datum/magic_aspect/A in owner.mind.minor_aspects)
				if(A.type == aspect_path)
					attuned = A
					break
		if(!attuned)
			continue
		var/list/selections = pointbuy_selections[aspect_path_str]
		for(var/spell_path_str in selections)
			var/spell_path = text2path(spell_path_str)
			if(!spell_path)
				continue
			if(owner.mind.has_spell(spell_path))
				continue
			var/datum/new_spell = new spell_path
			attuned.mark_aspect_spell(new_spell)
			owner.mind.AddSpell(new_spell)
	// Grant post-aspect spells (class-granted spells ordered after aspect spells)
	for(var/post_path in post_aspect_spells)
		if(owner.mind.has_spell(post_path))
			continue
		owner.mind.AddSpell(new post_path)

	// Apply utility spell selections - no chant required
	for(var/spell_path_str in staged_utilities)
		var/spell_path = text2path(spell_path_str)
		if(!spell_path)
			continue
		if(owner.mind.has_spell(spell_path))
			continue
		var/datum/new_spell = new spell_path
		if(istype(new_spell, /datum/action/cooldown/spell))
			var/datum/action/cooldown/spell/S = new_spell
			S.utility_learned = TRUE
		owner.mind.AddSpell(new_spell)

	if(has_unbinds)
		to_chat(owner, span_notice("The inscriptions in my grimoire shift and reform..."))
	owner.mind.ensure_mage_basics()
	owner.mind.check_learnspell()

	chanting = FALSE

	// Check if there are remaining aspect slots
	var/current_majors = LAZYLEN(owner.mind.major_aspects)
	var/current_minors = LAZYLEN(owner.mind.minor_aspects)
	var/has_remaining = (current_majors < max_majors) || (current_minors < max_minors_resolved)

	if(has_remaining)
		staged_majors.Cut()
		staged_minors.Cut()
		staged_utilities.Cut()
		staged_unbind_aspects.Cut()
		staged_unbind_utilities.Cut()
		staged_choices = list()
		pointbuy_selections = list()
		to_chat(owner, span_notice("Aspects applied. You have remaining slots - use your spellbook to continue selecting."))
	else
		qdel(src)

/// Check if a spell is already selected in a different aspect's pointbuy, choice, or granted as a fixed spell
/datum/aspect_picker/proc/is_spell_selected_elsewhere(spell_path, exclude_aspect_path)
	// Check pointbuy selections in other aspects
	for(var/other_aspect_path in pointbuy_selections)
		if(other_aspect_path == exclude_aspect_path)
			continue
		var/list/other_selections = pointbuy_selections[other_aspect_path]
		if(spell_path in other_selections)
			return TRUE
	// Check choice selections in other aspects
	for(var/other_aspect_path in staged_choices)
		if(other_aspect_path == exclude_aspect_path)
			continue
		if(staged_choices[other_aspect_path] == spell_path)
			return TRUE
	// Check fixed spells in all staged and already-attuned aspects
	var/resolved_spell = text2path(spell_path)
	if(resolved_spell)
		var/list/all_staged = staged_majors + staged_minors
		for(var/staged_path in all_staged)
			if("[staged_path]" == exclude_aspect_path)
				continue
			var/datum/magic_aspect/staged = new staged_path
			if(resolved_spell in staged.fixed_spells)
				qdel(staged)
				return TRUE
			qdel(staged)
		// Check already-attuned aspects
		for(var/datum/magic_aspect/A in owner.mind.major_aspects)
			if("[A.type]" == exclude_aspect_path)
				continue
			if(resolved_spell in A.fixed_spells)
				return TRUE
		for(var/datum/magic_aspect/A in owner.mind.minor_aspects)
			if("[A.type]" == exclude_aspect_path)
				continue
			if(resolved_spell in A.fixed_spells)
				return TRUE
	return FALSE

/// Get total points spent in an aspect's pointbuy selections
/datum/aspect_picker/proc/get_pointbuy_spent(aspect_path_str, datum/magic_aspect/aspect)
	var/list/selections = pointbuy_selections[aspect_path_str]
	if(!length(selections))
		return 0
	var/total = 0
	for(var/spell_path_str in selections)
		total += get_spell_cost_from_path(text2path(spell_path_str))
	return total

/// Get total utility points spent — includes already-known utilities (minus pending unbinds) and staged selections
/datum/aspect_picker/proc/get_utility_points_spent()
	var/total = 0
	// Always count already-known utility spells that the player manually learned (not given by aspects)
	for(var/path in GLOB.utility_spells)
		var/path_str = "[path]"
		if(path_str in staged_unbind_utilities)
			continue
		// Skip spells we're about to add from staged — they're counted below
		if(path_str in staged_utilities)
			continue
		if(owner.mind.has_spell(path))
			if(!is_utility_learned(path))
				continue
			total += get_spell_cost_from_path(path)
	// Count new staged selections
	for(var/spell_path_str in staged_utilities)
		total += get_spell_cost_from_path(text2path(spell_path_str))
	return total

/// Check if a known utility spell was manually learned by the player (counts against budget)
/// Returns FALSE for spells given free by aspects.
/datum/aspect_picker/proc/is_utility_learned(spell_path)
	for(var/datum/action/cooldown/spell/S in owner.mind.spell_list)
		if(S.type == spell_path && S.utility_learned)
			return TRUE
	return FALSE

/// Get spell cost from a type path (handles both spell systems)
/datum/aspect_picker/proc/get_spell_cost_from_path(spell_path)
	if(!spell_path)
		return 0
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.point_cost)
	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.cost)

/// Calculate the total reset budget cost of all staged unbinds
/datum/aspect_picker/proc/get_staged_reset_cost()
	var/total = 0
	for(var/path in staged_unbind_aspects)
		var/datum/magic_aspect/temp = new path
		total += (temp.aspect_type == ASPECT_MAJOR) ? ASPECT_RESET_COST_MAJOR : ASPECT_RESET_COST_MINOR
		qdel(temp)
	total += length(staged_unbind_utilities) * ASPECT_RESET_COST_UTILITY
	return total

/// Get type paths of currently-attuned aspects of a given type
/datum/aspect_picker/proc/get_attuned_paths(aspect_type)
	var/list/paths = list()
	var/list/source = (aspect_type == ASPECT_MAJOR) ? owner.mind.major_aspects : owner.mind.minor_aspects
	for(var/datum/magic_aspect/A in source)
		paths += A.type
	return paths

/datum/aspect_picker/ui_close(mob/user)
	if(!chanting)
		qdel(src)
