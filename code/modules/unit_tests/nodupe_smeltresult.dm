// Tests meant to ensure that we don't end up with material duping exploits for smelting
/*
	Checks for:
	- Smeltresult
*/
/datum/unit_test/nodupe_smeltresult/Run()
	// Material equivalence mapping - treat these materials as equivalent for transmutation checking
	// Smeltresult Checking Section //
	var/list/material_equivalents = list(
		/obj/item/ingot/silverblessed = /obj/item/ingot/silver,  // blessed silver counts as silver
		/obj/item/ingot/purifiedaalloy = /obj/item/ingot/aaslag, // purified alloy counts as slag
		/obj/item/ingot/aalloy = /obj/item/ingot/aaslag          // ancient alloy counts as slag
	)
	
	for(var/datum/anvil_recipe/recipe as anything in GLOB.anvil_recipes)
		if(recipe.bypass_dupe_test)
			continue
		var/obj/item/created_item = recipe.created_item
		var/createditem_num = recipe.createditem_num
		var/smelt_result = initial(created_item.smeltresult)
		var/smelt_bar_num = initial(created_item.smelt_bar_num)
		var/list/bad_materials = list(
			/obj/item/ingot/aaslag,
			/obj/item/ash,
			/obj/item/rogueore/coal
		)

		// Skip it if it doesn't have a smelt result
		if(!smelt_result)
			continue

		// Skip intentional bad/waste materials
		if(smelt_result in bad_materials)
			continue

		var/list/required_items = list()
		if(recipe.req_bar)
			required_items += recipe.req_bar
		if(recipe.additional_items)
			required_items += recipe.additional_items

		var/target_item_count = createditem_num ? createditem_num : 1
		var/built_item_count = 0

		// Get the "normalized" smelt result (checking equivalents)
		var/normalized_smelt_result = material_equivalents[smelt_result] ? material_equivalents[smelt_result] : smelt_result

		// Count how many required items have the same smelt result
		for(var/obj/item/req_item_type as anything in required_items)
			var/req_smelt = initial(req_item_type.smeltresult)
			// Normalize the required item's smelt result too
			var/normalized_req_smelt = material_equivalents[req_smelt] ? material_equivalents[req_smelt] : req_smelt

			// Check if they match after normalization, OR if the required item itself is the smelt result
			if(normalized_req_smelt == normalized_smelt_result || req_item_type == smelt_result || ispath(req_item_type, smelt_result))
				built_item_count += 1

		var/bars_produced = target_item_count * (smelt_bar_num ? smelt_bar_num : 1)

		if(bars_produced > built_item_count && built_item_count > 0)
			TEST_FAIL("Recipe '[recipe.name]' creates [target_item_count]x [created_item] (smelt: [smelt_result], bars: [bars_produced]) but only requires [built_item_count] items with same smelt result.")
		else if(bars_produced > 0 && built_item_count == 0)
			TEST_FAIL("Recipe '[recipe.name]' creates [target_item_count]x [created_item] (smelt: [smelt_result], bars: [bars_produced]) but requires 0 items with same smelt result.")
