SUBSYSTEM_DEF(chimeric_tech)
	name = "Chimeric Tech Controller"
	priority = FIRE_PRIORITY_DEFAULT
	flags = SS_NO_FIRE

	// The master list of all instantiated nodes, keyed by type path.
	var/list/all_tech_nodes = list()
	var/list/cached_choices = list() // Stores the currently offered choices
	var/list/cached_choices_echoes = list()
	var/list/cached_choices_paths = list()
	var/list/cached_choices_paths_echoes = list()
	var/list/tech_recipe_index = list() // Store references to recipes in the global recipe list to be able to iterate more efficiently later
	var/echo_points = 0

#define CHIMERIC_CACHE_TECH 1
#define CHIMERIC_CACHE_ECHOES 2

/datum/controller/subsystem/chimeric_tech/proc/clear_cached_choices(var/cache_to_clear = CHIMERIC_CACHE_TECH)
	// Clears the cache when a tech is unlocked.
	switch(cache_to_clear)
		if(CHIMERIC_CACHE_TECH)
			cached_choices = list()
			cached_choices_paths = list()
		if(CHIMERIC_CACHE_ECHOES)
			cached_choices_echoes = list()
			cached_choices_paths_echoes = list()

/datum/controller/subsystem/chimeric_tech/Initialize()
	. = ..()
	load_all_tech_nodes()
	init_unlockable_recipes()
	return

/datum/controller/subsystem/chimeric_tech/proc/load_all_tech_nodes()
	for(var/T in typesof(/datum/chimeric_tech_node) - /datum/chimeric_tech_node)
		var/datum/chimeric_tech_node/new_node = new T()
		all_tech_nodes[new_node.string_id] = new_node

/datum/controller/subsystem/chimeric_tech/proc/get_node_status(var/node_path)
	var/datum/chimeric_tech_node/node = all_tech_nodes[node_path]
	if(node)
		return node.unlocked
	return FALSE

/datum/controller/subsystem/chimeric_tech/proc/get_available_choices(var/current_tier, var/current_points, var/max_choices = 3, var/cache_to_select = CHIMERIC_CACHE_TECH)
	if(cache_to_select == CHIMERIC_CACHE_ECHOES && cached_choices_echoes.len)
		return cached_choices_echoes
	if(cache_to_select == CHIMERIC_CACHE_TECH && cached_choices.len)
		return cached_choices

	var/list/eligible_nodes = list()
	var/list/selection_pool = list()

	// Determine Eligibility and Cost Check
	for(var/node_path in all_tech_nodes)
		var/datum/chimeric_tech_node/N = all_tech_nodes[node_path]

		if(N.unlocked)
			continue

		if(cache_to_select == CHIMERIC_CACHE_ECHOES && N.required_tier != 1)
			continue

		if(cache_to_select == CHIMERIC_CACHE_TECH && current_tier < N.required_tier)
			continue

		var/prereqs_met = TRUE
		for(var/required_node_path in N.prerequisites)
			if(!get_node_status(required_node_path)) // Use the global check proc
				prereqs_met = FALSE
				break

		if(prereqs_met)
			eligible_nodes += N

	// Build the Weighted Selection Pool
	for(var/datum/chimeric_tech_node/N in eligible_nodes)
		for(var/i = 1 to N.selection_weight)
			selection_pool += N

	// Select the Limited Choices
	var/list/final_choices = list()
	while(final_choices.len < max_choices && selection_pool.len > 0)
		var/datum/chimeric_tech_node/chosen_node = pick(selection_pool)

		if(!(chosen_node in final_choices))
			final_choices += chosen_node

		selection_pool -= chosen_node // Remove all instances of this node

	if(cache_to_select == CHIMERIC_CACHE_ECHOES)
		cached_choices_echoes = final_choices
		for(var/datum/chimeric_tech_node/N in final_choices)
			cached_choices_paths_echoes += N.type
	if(cache_to_select == CHIMERIC_CACHE_TECH)
		cached_choices = final_choices
		for(var/datum/chimeric_tech_node/N in final_choices)
			cached_choices_paths += N.type

	return final_choices

/datum/controller/subsystem/chimeric_tech/proc/unlock_node(var/string_id, var/datum/component/chimeric_heart_beast/beast_component, var/cache_to_clear = CHIMERIC_CACHE_TECH)
	var/datum/chimeric_tech_node/node = all_tech_nodes[string_id]

	if(!node)
		return "Error: Node not found."
	if(node.unlocked)
		clear_cached_choices(CHIMERIC_CACHE_ECHOES)
		clear_cached_choices(CHIMERIC_CACHE_TECH)
		return "Already unlocked."

	// Sanity check
	if(cache_to_clear == CHIMERIC_CACHE_TECH)
		if(beast_component.language_tier < node.required_tier || beast_component.tech_points < node.cost)
			return "Requirements not met."

	// Sanity check
	for(var/required_node_path in node.prerequisites)
		if(!get_node_status(required_node_path))
			return "Missing prerequisite: [required_node_path]"

	if(cache_to_clear == CHIMERIC_CACHE_TECH)
		beast_component.tech_points -= node.cost
		clear_cached_choices()
	if(cache_to_clear == CHIMERIC_CACHE_ECHOES)
		echo_points -= node.cost
		clear_cached_choices(CHIMERIC_CACHE_ECHOES)
	node.unlocked = TRUE

	if(node.is_recipe_node)
		update_recipes_for_tech(string_id)

	return "Successfully unlocked [node.name]!"

/datum/controller/subsystem/chimeric_tech/proc/update_recipes_for_tech(var/tech_id)
	var/list/recipes_to_unlock = tech_recipe_index[tech_id]
	var/datum/chimeric_tech_node/node = all_tech_nodes[tech_id]

	if(!recipes_to_unlock)
		return
	for(var/rec in recipes_to_unlock)
		var/datum/crafting_recipe/R = rec
		R.tech_unlocked = TRUE
		if(node.recipe_override)
			R.reqs = node.recipe_override

/datum/controller/subsystem/chimeric_tech/proc/init_unlockable_recipes()
	tech_recipe_index = list()
	for(var/rec_datum in GLOB.crafting_recipes)
		var/datum/crafting_recipe/R = rec_datum
		if(R.required_tech_node)
			if(!tech_recipe_index[R.required_tech_node])
				tech_recipe_index[R.required_tech_node] = list()
			tech_recipe_index[R.required_tech_node] += R

/datum/controller/subsystem/chimeric_tech/proc/get_healing_multiplier()
	var/multiplier = 0.85

	var/advanced_healing_path = "HEAL_TIER1"
	var/enhanced_healing_path = "HEAL_TIER2"
	
	if(get_node_status(advanced_healing_path))
		multiplier = 1.0
	if(get_node_status(enhanced_healing_path))
		multiplier = 1.25
	
	return multiplier

/datum/controller/subsystem/chimeric_tech/proc/get_resurrection_multiplier()
	var/multiplier = 2

	if(get_node_status("REVIVE_TIER1"))
		multiplier = 1
	return multiplier

/datum/controller/subsystem/chimeric_tech/proc/has_revival_cost_reduction()
	return get_node_status("REVIVE_TIER2")

/datum/controller/subsystem/chimeric_tech/proc/get_infestation_max_charges()
	var/max_charges = 30

	if(SSchimeric_tech.get_node_status("INFESTATION_TIER3"))
		max_charges = 100
	else if(SSchimeric_tech.get_node_status("INFESTATION_TIER2"))
		max_charges = 90
	else if(SSchimeric_tech.get_node_status("INFESTATION_TIER1"))
		max_charges = 50
	return max_charges

/datum/controller/subsystem/chimeric_tech/proc/get_infestation_food_rot_count()
	var/amount = 0

	if(SSchimeric_tech.get_node_status("INFESTATION_ROT_MULTIPLE_2"))
		amount = 4
	else if(SSchimeric_tech.get_node_status("INFESTATION_ROT_MULTIPLE_1"))
		amount = 2
	return amount

#undef CHIMERIC_CACHE_TECH
#undef CHIMERIC_CACHE_ECHOES
