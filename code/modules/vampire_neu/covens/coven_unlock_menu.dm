/datum/coven_research_node
	var/name = "Research Node"
	var/desc = "A research node description"
	var/list/prerequisites = list()
	var/research_cost = 10
	var/required_level = 1
	var/minimal_generation = 0
	var/unlocks_power = null
	var/special_effect = null
	var/node_x = 0
	var/node_y = 0
	var/icon = 'icons/effects/clan.dmi'
	var/icon_state = "research_node"

	var/showcase_gif = null
	var/gif_width = 160
	var/gif_height = 160

/datum/coven_research_interface
	var/datum/coven/parent_coven
	var/mob/living/carbon/human/user
	var/list/research_nodes = list()
	var/list/available_research = list()


/datum/coven_research_interface/New(datum/coven/coven)
	parent_coven = coven
	..()

/datum/coven_research_interface/proc/initialize_coven_tree()
	// Create research nodes for each power and enhancement
	for(var/power_type in parent_coven.all_powers)
		var/datum/coven_power/power = new power_type(parent_coven)
		var/datum/coven_research_node/node = new /datum/coven_research_node()
		node.name = power.name
		node.desc = power.desc
		node.unlocks_power = power_type
		node.research_cost = power.research_cost
		node.required_level = power.level
		node.minimal_generation = power.minimal_generation
		node.node_x = (power.level - 1) * 150
		node.node_y = rand(-100, 100)
		node.icon_state = power.discipline?.icon_state
		node.icon = 'icons/mob/actions/roguespells.dmi'
		node.showcase_gif = power.gif

		// Set prerequisites based on power level
		if(power.level > 1)
			for(var/other_power in parent_coven.all_powers)
				var/datum/coven_power/other = new other_power(parent_coven)
				if(other.level == power.level - 1)
					node.prerequisites += other_power
				qdel(other)

		research_nodes[power_type] = node
		qdel(power)

/datum/coven_research_interface/proc/get_research_node(research_type)
	return research_nodes[research_type]

/datum/coven_research_interface/proc/unlock_research_node(research_type)
	if(research_type in available_research)
		return
	available_research += research_type

/datum/coven_research_interface/proc/get_available_research()
	var/list/available = list()
	for(var/research_type in research_nodes)
		var/datum/coven_research_node/node = research_nodes[research_type]

		// Check if already unlocked
		if(research_type in parent_coven.unlocked_research)
			continue

		// Check if player level is high enough
		if(parent_coven.level < node.required_level)
			continue

		// Check prerequisites
		var/prereqs_met = TRUE
		for(var/prereq in node.prerequisites)
			if(!(prereq in parent_coven.unlocked_research))
				prereqs_met = FALSE
				break

		if(prereqs_met)
			available += research_type

	return available

/datum/coven_research_interface/proc/generate_coven_connections_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	for(var/research_type in research_nodes)
		var/datum/coven_research_node/node = research_nodes[research_type]

		// Draw connections to prerequisites
		for(var/prereq_type in node.prerequisites)
			var/datum/coven_research_node/prereq_node = research_nodes[prereq_type]
			if(!prereq_node) continue

			// Calculate center positions (adding center offsets)
			var/start_center_x = center_x + prereq_node.node_x + 16 // Center of prereq node
			var/start_center_y = center_y + prereq_node.node_y + 16
			var/end_center_x = center_x + node.node_x + 16	// Center of current node
			var/end_center_y = center_y + node.node_y + 16

			// Calculate distance and angle using corrected method
			var/dx = end_center_x - start_center_x
			var/dy = end_center_y - start_center_y
			var/distance = sqrt(dx*dx + dy*dy)

			if(distance == 0)
				continue

			// Use corrected arctan parameter order and angle normalization
			var/angle = arctan(dx, dy)
			if(angle < 0)
				angle += 360

			var/unlocked_class = ""
			if((prereq_type in parent_coven.unlocked_research) && (research_type in parent_coven.unlocked_research))
				unlocked_class = " unlocked"

			// Use corrected positioning with transform-origin and z-index
			html += {"<div class="connection-line[unlocked_class]"
				style="left: [start_center_x]px; top: [start_center_y - 1.5]px; width: [distance]px;
				transform: rotate([angle]deg); transform-origin: 0 50%; z-index: 1;"></div>"}

	return html

/datum/coven_research_interface/proc/generate_coven_nodes_html()
	var/html = ""

	for(var/research_type in research_nodes)
		var/datum/coven_research_node/node = research_nodes[research_type]

		var/node_classes = "research-node"
		var/power_level_html = ""

		// Determine node state and styling based on level
		if(research_type in parent_coven.unlocked_research)
			node_classes += " unlocked"
		else if(parent_coven.level >= node.required_level)
			// Check if prerequisites are met
			var/prereqs_met = TRUE
			for(var/prereq in node.prerequisites)
				if(!(prereq in parent_coven.unlocked_research))
					prereqs_met = FALSE
					break

			if(prereqs_met)
				node_classes += " available"
			else
				node_classes += " prereq-locked"
		else
			node_classes += " level-locked"

		// Special node types
		if(node.unlocks_power)
			var/datum/coven_power/power = new node.unlocks_power(parent_coven)
			if(power.level >= 3)
				node_classes += " power-node"
				power_level_html = "<div class='power-level'>[power.level]</div>"
			qdel(power)
		else if(node.special_effect)
			node_classes += " enhancement-node"

		// Create node data JSON for tooltip
		var/list/node_data = list(
			"name" = node.name,
			"desc" = node.desc,
			"required_level" = node.required_level,
			"current_level" = parent_coven.level,
			"special_effect" = node.special_effect,
		)

		if(node.unlocks_power)
			var/datum/coven_power/power = new node.unlocks_power(parent_coven)
			node_data["cooldown"] = power.cooldown_length * 0.1
			if(power.toggled && power.duration_length)
				node_data["upkeep_cost"] = power.vitae_cost
				node_data["upkeep_duration"] = power.duration_length * 0.1
			else
				node_data["vitae_cost"] = power.vitae_cost
			qdel(power)

		if(node.research_cost)
			node_data["research_cost"] = node.research_cost

		if(node.minimal_generation)
			node_data["minimal_generation"] = GLOB.vamp_generation_to_text[node.minimal_generation]

		if(node.showcase_gif)
			node_data["showcase_gif"] = node.showcase_gif
			node_data["gif_width"] = node.gif_width
			node_data["gif_height"] = node.gif_height

		if(length(node.prerequisites))
			var/list/prereq_names = list()
			for(var/prereq in node.prerequisites)
				var/datum/coven_research_node/prereq_node = research_nodes[prereq]
				if(prereq_node)
					prereq_names += prereq_node.name
			node_data["prerequisites"] = prereq_names

		var/node_data_json = json_encode(node_data)

		// Get icon for the node
		var/icon_html = ""
		if(node.icon && node.icon_state)
			icon_html = "<img src='\ref[node.icon]?state=[node.icon_state]' alt=\"[node.name]\" />"
		else
			// Default icons based on node type
			if(node.special_effect)
				icon_html = "<img src='\ref['icons/effects/clan.dmi']?state=vampire' alt=\"[node.name]\" />"
			else if(node.unlocks_power)
				icon_html = "<img src='\ref['icons/effects/clan.dmi']?state=howl' alt=\"[node.name]\" />"
			else
				icon_html = "<img src='\ref['icons/effects/clan.dmi']?state=watch' alt=\"[node.name]\" />"

		var/encoded_json = replacetext(node_data_json, "'", "&#39;")
		html += {"<div class="[node_classes]"
			style="left: [node.node_x]px; top: [node.node_y]px;"
			data-node-id="[research_type]"
			data-user-ref="[REF(user)]"
			data-node-data='[encoded_json]'>
			[icon_html]
			[power_level_html]
		</div>"}

	return html

/datum/coven_research_interface/proc/get_experience_percentage()
	if(parent_coven.experience_needed <= 0)
		return 100
	return round((parent_coven.experience / parent_coven.experience_needed) * 100, 1)

/datum/coven_research_interface/Topic(href, href_list)
	if(!user || !parent_coven)
		return

	if(href_list["action"] == "research_node")
		var/node_id = text2path(href_list["node_id"])
		if(!node_id || !(node_id in research_nodes))
			return

		var/datum/coven_research_node/node = research_nodes[node_id]

		// Show information about the node
		var/info_text = ""

		if(node_id in parent_coven.unlocked_research)
			info_text = "<span class='boldnotice'>[node.name] is already unlocked!</span>"
		else if(parent_coven.level >= node.required_level)
			// Check prerequisites
			if(node.minimal_generation > user.get_vampire_generation())
				to_chat(user, span_warning("[node.name] can be unlocked only by vampires of [GLOB.vamp_generation_to_text[node.minimal_generation]]. You are [GLOB.vamp_generation_to_text[user.get_vampire_generation()]]"))
				return
			var/prereqs_met = TRUE
			var/missing_prereqs = list()
			for(var/prereq in node.prerequisites)
				if(!(prereq in parent_coven.unlocked_research))
					prereqs_met = FALSE
					var/datum/coven_research_node/prereq_node = research_nodes[prereq]
					if(prereq_node)
						missing_prereqs += prereq_node.name

			var/datum/antagonist/vampire/vampire = parent_coven.owner.mind?.has_antag_datum(/datum/antagonist/vampire)
			if(prereqs_met && node.research_cost && vampire.research_points < node.research_cost)
				to_chat(user, "<span class='warning'>[node.name] requires [node.research_cost] RP.</span>")
				return

			if(prereqs_met)
				// Auto-unlock if available
				if(parent_coven.unlock_power_from_tree(node_id))
					info_text = "<span class='boldnotice'>[node.name] has been unlocked!</span>"
				else
					info_text = "<span class='warning'>Unable to unlock [node.name].</span>"
			else
				info_text = "<span class='warning'>[node.name] requires: [jointext(missing_prereqs, ", ")]</span>"
		else
			info_text = "<span class='warning'>[node.name] requires level [node.required_level] (currently level [parent_coven.level])</span>"

		to_chat(user, info_text)

	else if(href_list["action"] == "close_research")
		user << browse(null, "window=coven_research")

// Additional utility functions
/datum/coven_research_interface/proc/get_node_icon_state(datum/coven_research_node/node)
	if(node.special_effect)
		switch(node.special_effect)
			if("reduce_vitae_cost")
				return "vitae_efficiency"
			if("increase_range")
				return "range_boost"
			if("reduce_cooldown")
				return "speed_boost"
			else
				return "enhancement"
	else if(node.unlocks_power)
		var/datum/coven_power/power = node.unlocks_power
		var/icon_state = "power_level_[initial(power.level)]"

		return icon_state
	else
		return "research_base"

/datum/coven_research_interface/proc/calculate_optimal_layout()
	// Auto-arrange nodes in a more organized layout
	var/list/levels = list()

	// Group nodes by level/tier
	for(var/research_type in research_nodes)
		var/datum/coven_research_node/node = research_nodes[research_type]
		var/level = 1

		if(node.unlocks_power)
			var/datum/coven_power/power = node.unlocks_power
			level = initial(power.level)


		if(!levels["[level]"])
			levels["[level]"] = list()
		levels["[level]"] += research_type

	// Position nodes in organized columns
	var/base_x = 100
	var/base_y = 200
	var/level_spacing = 200
	var/node_spacing = 80

	for(var/level_str in levels)
		var/level_num = text2num(level_str)
		var/list/level_nodes = levels[level_str]
		var/nodes_in_level = length(level_nodes)

		var/start_y = base_y - (nodes_in_level * node_spacing / 2)

		for(var/i = 1; i <= nodes_in_level; i++)
			var/research_type = level_nodes[i]
			var/datum/coven_research_node/node = research_nodes[research_type]

			node.node_x = base_x + (level_num - 1) * level_spacing
			node.node_y = start_y + (i - 1) * node_spacing
