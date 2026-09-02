/datum/unit_test/container_craft_recipe_collisions
/datum/unit_test/container_craft_recipe_collisions/Run()
	var/list/recipes = list()
	for(var/key in GLOB.container_craft_to_singleton)
		recipes += GLOB.container_craft_to_singleton[key]

	for(var/i in 1 to (recipes.len-1))
		for(var/i2 in (i+1) to recipes.len)
			var/datum/container_craft/r1 = recipes[i]
			var/datum/container_craft/r2 = recipes[i2]
			if(container_craft_recipes_do_conflict(r1, r2))
				TEST_FAIL("Container craft recipe conflict between [r1.type] ([r1.name]) and [r2.type] ([r2.name])")

/**
 * Two recipes conflict when one would fire on the other's ingredient set and the runtime
 * would try it first. Families are sorted by get_specificity() descending, so a broader
 * recipe only shadows a narrower one if it sorts at or before it.
 */
/proc/container_craft_recipes_do_conflict(datum/container_craft/r1, datum/container_craft/r2)
	if(r1.required_container != r2.required_container)
		return FALSE
	if(r1.isolation_craft != r2.isolation_craft)
		return FALSE
	if(r1.craft_priority != r2.craft_priority)
		return FALSE
	if(r1.handoff_craft != r2.handoff_craft)
		return FALSE

	var/spec1 = r1.get_specificity()
	var/spec2 = r2.get_specificity()
	if(spec1 >= spec2 && container_craft_shadows(r1, r2))
		return TRUE
	if(spec2 >= spec1 && container_craft_shadows(r2, r1))
		return TRUE
	return FALSE


/proc/container_craft_shadows(datum/container_craft/broad, datum/container_craft/narrow)
	for(var/req_type in broad.requirements)
		if(!narrow.requirements || !(req_type in narrow.requirements))
			return FALSE
		if(narrow.requirements[req_type] < broad.requirements[req_type])
			return FALSE

	for(var/reagent_type in broad.reagent_requirements)
		var/found_reagent = FALSE
		for(var/narrow_reagent_type in narrow.reagent_requirements)
			if(reagent_type == narrow_reagent_type || (broad.subtype_reagents_allowed && ispath(narrow_reagent_type, reagent_type)))
				if(narrow.reagent_requirements[narrow_reagent_type] >= broad.reagent_requirements[reagent_type])
					found_reagent = TRUE
					break
		if(!found_reagent)
			return FALSE

	for(var/broad_wildcard in broad.wildcard_requirements)
		var/satisfied_amount = 0
		for(var/narrow_req_type in narrow.requirements)
			if(ispath(narrow_req_type, broad_wildcard))
				satisfied_amount += narrow.requirements[narrow_req_type]
		for(var/narrow_wildcard in narrow.wildcard_requirements)
			if(ispath(narrow_wildcard, broad_wildcard))
				satisfied_amount += narrow.wildcard_requirements[narrow_wildcard]
		if(satisfied_amount < broad.wildcard_requirements[broad_wildcard])
			return FALSE

	return TRUE
