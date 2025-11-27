// Tests meant to ensure that we don't end up with material duping exploits for salvage result
/*
	Checks for:
	- salvage result duping (salvaging returns more material than recipe consumed)
	- salvage transmutation (salvaging returns material not used in recipe)
*/
/datum/unit_test/nodupe_salvageresult/Run()
	// Material equivalence mapping - treat these materials as equivalent for transmutation checking
	// Empty for now
	var/list/material_equivalents = alist()
	
	for(var/datum/crafting_recipe/recipe as anything in GLOB.crafting_recipes)
		var/list/required_items = recipe.reqs
		var/list/results = recipe.result
		if(recipe.bypass_dupe_test)
			continue
		
		// Handle both single result and list of results
		if(!islist(results))
			results = list(results)
		
		// Build a map of salvage materials from all result items
		var/list/result_salvage_totals = list() // salvage_type = total_amount
		for(var/obj/item/res_item as anything in results)
			var/salvage_result = initial(res_item.salvage_result)
			var/salvage_amount = initial(res_item.salvage_amount)
			
			if(!salvage_result || !salvage_amount)
				continue
			
			var/canonical_salvage = material_equivalents[salvage_result] || salvage_result
			
			result_salvage_totals[canonical_salvage] = (result_salvage_totals[canonical_salvage] || 0) + salvage_amount
		
		// Skip if no salvageable results
		if(!result_salvage_totals.len)
			continue
		
		// For each salvage material type produced by the results
		for(var/salvage_type in result_salvage_totals)
			var/salvage_total = result_salvage_totals[salvage_type]
			var/canonical_salvage_type = material_equivalents[salvage_type] || salvage_type

			// Count how many items with the same salvage material the recipe requires
			var/required_count = 0
			for(var/my_item in required_items)
				var/obj/item/req_item_type = my_item
				// Check if the required item IS the salvage material (direct match)
				var/canonical_req_type = material_equivalents[req_item_type] || req_item_type
				if(canonical_req_type == canonical_salvage_type)
					required_count += required_items[req_item_type]
					continue
				
				// Check if the required item SALVAGES INTO the salvage material
				var/req_salvage = initial(req_item_type.salvage_result)
				if(req_salvage)
					var/canonical_req_salvage = material_equivalents[req_salvage] || req_salvage
					if(canonical_req_salvage == canonical_salvage_type)
						required_count += required_items[req_item_type]
			
			// Check for duping: salvaging gives MORE items than recipe consumed
			if(salvage_total > required_count && required_count > 0)
				TEST_FAIL("Recipe '[recipe.name]' creates items (salvage: [salvage_total]x [salvage_type]) but only requires [required_count] items with same salvage result.")
			
			// Check for transmutation: salvaging gives material that wasn't in the recipe at all
			else if(salvage_total > 0 && required_count == 0)
				TEST_FAIL("Recipe '[recipe.name]' creates items (salvage: [salvage_total]x [salvage_type]) but requires 0 items with same salvage result.")
		