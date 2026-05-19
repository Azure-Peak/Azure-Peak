#define CLAN_HIERARCHY_JSON_VERSION 1
#define CLAN_HIERARCHY_JSON_MAX_NODES 80
#define CLAN_HIERARCHY_JSON_MAX_LENGTH 50000
#define CLAN_HIERARCHY_JSON_SHOW_ACTION "show_clan_hierarchy_json"
#define CLAN_HIERARCHY_JSON_IMPORT_ACTION "import_clan_hierarchy_json"

/datum/clan/proc/collect_hierarchy_export_nodes(datum/clan_hierarchy_node/position, parent_id, list/nodes, list/node_ids)
	if(!position || node_ids[position])
		return

	var/node_id = "node_[length(nodes) + 1]"
	node_ids[position] = node_id
	nodes += list(list(
		"id" = node_id,
		"parent" = parent_id,
		"name" = position.name,
		"desc" = position.desc,
		"rank_level" = position.rank_level,
		"max_subordinates" = position.max_subordinates,
		"can_assign_positions" = position.can_assign_positions,
		"position_color" = position.position_color,
	))

	for(var/datum/clan_hierarchy_node/subordinate as anything in position.subordinates)
		collect_hierarchy_export_nodes(subordinate, node_id, nodes, node_ids)

/datum/clan/proc/export_hierarchy_data()
	if(!hierarchy_root)
		initialize_hierarchy()

	var/list/nodes = list()
	var/list/node_ids = list()
	collect_hierarchy_export_nodes(hierarchy_root, null, nodes, node_ids)

	return list(
		"format" = "vampire_clan_hierarchy",
		"version" = CLAN_HIERARCHY_JSON_VERSION,
		"clan_name" = name,
		"nodes" = nodes,
	)

/datum/clan/proc/export_hierarchy_json()
	return json_encode(export_hierarchy_data())

/datum/clan/proc/import_hierarchy_cleanup(list/new_positions)
	if(!new_positions)
		return

	for(var/datum/clan_hierarchy_node/position as anything in new_positions)
		qdel(position)

/datum/clan/proc/collect_hierarchy_nodes(datum/clan_hierarchy_node/position, list/collected)
	if(!position || (position in collected))
		return

	collected += position
	for(var/datum/clan_hierarchy_node/subordinate as anything in position.subordinates)
		collect_hierarchy_nodes(subordinate, collected)

/datum/clan/proc/import_hierarchy_data(list/import_data, mob/living/carbon/human/importing_user)
	if(!islist(import_data))
		return "Import failed: JSON root must be an object."

	if(import_data["format"] && import_data["format"] != "vampire_clan_hierarchy")
		return "Import failed: unsupported hierarchy format."

	var/list/nodes = import_data["nodes"]
	if(!islist(nodes) || !length(nodes))
		return "Import failed: JSON must contain a non-empty nodes array."

	if(length(nodes) > CLAN_HIERARCHY_JSON_MAX_NODES)
		return "Import failed: hierarchy has too many nodes. Limit: [CLAN_HIERARCHY_JSON_MAX_NODES]."

	var/list/node_lookup = list()
	var/list/parent_lookup = list()
	var/list/new_positions = list()
	var/datum/clan_hierarchy_node/new_root
	var/root_count = 0

	for(var/node_entry as anything in nodes)
		if(!islist(node_entry))
			import_hierarchy_cleanup(new_positions)
			return "Import failed: every node must be an object."

		var/list/node_data = node_entry
		var/node_id = node_data["id"]
		if(!istext(node_id) || !length(node_id))
			import_hierarchy_cleanup(new_positions)
			return "Import failed: every node needs a text id."

		if(node_lookup[node_id])
			import_hierarchy_cleanup(new_positions)
			return "Import failed: duplicate node id '[node_id]'."

		var/position_name = node_data["name"]
		if(!istext(position_name) || !length(position_name))
			position_name = "Position"
		position_name = copytext_char(strip_html_simple(position_name), 1, 51)

		var/position_desc = node_data["desc"]
		if(!istext(position_desc))
			position_desc = ""
		position_desc = copytext_char(strip_html_simple(position_desc), 1, 201)

		var/rank_value = node_data["rank_level"]
		var/rank_level = isnum(rank_value) ? rank_value : text2num("[rank_value]")
		if(isnull(rank_level))
			rank_level = 1
		rank_level = clamp(round(rank_level), 0, 10)

		var/max_subordinates_value = node_data["max_subordinates"]
		var/max_subordinates = isnum(max_subordinates_value) ? max_subordinates_value : text2num("[max_subordinates_value]")
		if(isnull(max_subordinates))
			max_subordinates = 5
		max_subordinates = clamp(round(max_subordinates), 1, 100)

		var/position_color = sanitize_hexcolor(node_data["position_color"], 6, TRUE, "#ffffff")
		var/can_assign = node_data["can_assign_positions"] ? TRUE : FALSE

		var/datum/clan_hierarchy_node/new_position = new /datum/clan_hierarchy_node(position_name, position_desc, rank_level)
		new_position.max_subordinates = max_subordinates
		new_position.position_color = position_color
		new_position.can_assign_positions = can_assign

		node_lookup[node_id] = new_position
		new_positions += new_position

		var/parent_id = node_data["parent"]
		if(isnull(parent_id) || parent_id == "")
			root_count++
			new_root = new_position
		else
			parent_lookup[node_id] = "[parent_id]"

	if(root_count != 1)
		import_hierarchy_cleanup(new_positions)
		return "Import failed: hierarchy must have exactly one root node."

	new_root.rank_level = 0
	new_root.can_assign_positions = TRUE
	new_root.max_subordinates = max(new_root.max_subordinates, 1)
	if(new_root.position_color == "#ffffff")
		new_root.position_color = "#ffd700"

	for(var/node_id as anything in node_lookup)
		var/datum/clan_hierarchy_node/new_position = node_lookup[node_id]
		if(new_position == new_root)
			continue

		var/parent_id = parent_lookup[node_id]
		var/datum/clan_hierarchy_node/parent_position = node_lookup[parent_id]
		if(!parent_position)
			import_hierarchy_cleanup(new_positions)
			return "Import failed: node '[node_id]' references missing parent '[parent_id]'."

		if(length(parent_position.subordinates) >= parent_position.max_subordinates)
			import_hierarchy_cleanup(new_positions)
			return "Import failed: parent '[parent_position.name]' has more children than max_subordinates allows."

		parent_position.add_subordinate(new_position)

	var/list/reachable = list()
	collect_hierarchy_nodes(new_root, reachable)
	if(length(reachable) != length(new_positions))
		import_hierarchy_cleanup(new_positions)
		return "Import failed: hierarchy contains disconnected nodes or a cycle."

	var/mob/living/carbon/human/leader_to_restore = (istype(clan_leader) && clan_leader.clan == src) ? clan_leader : importing_user

	var/list/old_positions = all_positions ? all_positions.Copy() : list()
	for(var/datum/clan_hierarchy_node/old_position as anything in old_positions)
		old_position.remove_member()
		qdel(old_position)

	all_positions = new_positions
	hierarchy_root = new_root

	if(istype(leader_to_restore) && leader_to_restore.clan == src)
		hierarchy_root.assign_member(leader_to_restore)

	return "Imported [length(new_positions)] hierarchy positions. Member assignments were not imported."

/datum/clan_menu_interface/proc/ensure_hierarchy_interface()
	if(!hierarchy_interface && user_clan)
		hierarchy_interface = new /datum/clan_hierarchy_interface(user)
	return hierarchy_interface

/datum/clan_menu_interface/proc/can_import_hierarchy()
	var/datum/clan_hierarchy_interface/interface = ensure_hierarchy_interface()
	return interface && interface.can_manage_hierarchy()

/datum/clan_menu_interface/proc/show_hierarchy_json(status_text = null)
	if(!user || !user_clan)
		return

	var/hierarchy_json = user_clan.export_hierarchy_json()
	var/status_html = ""
	if(status_text)
		status_html = "<div style='margin: 0 0 14px 0; padding: 10px 12px; background: rgba(80, 20, 20, 0.72); border: 1px solid #8B4513; color: #FFD700;'>[html_encode(status_text)]</div>"

	var/import_html = ""
	if(can_import_hierarchy())
		import_html = "<a href='?src=[REF(src)];action=[CLAN_HIERARCHY_JSON_IMPORT_ACTION]' class='btn-primary' style='display:inline-block; margin-top:12px; text-decoration:none;'>Import JSON</a>"
	else
		import_html = "<div style='margin-top:12px; color:#999;'>Only clan leadership can import hierarchy JSON.</div>"

	var/content = {"
	<div style='padding: 28px; color: #ddd; max-width: 980px;'>
		<h2 style='color:#FFD700; margin-top:0;'>Clan Hierarchy JSON</h2>
		[status_html]
		<p style='line-height:1.45; color:#ccc;'>Export the clan position tree as JSON, or paste a previous export to rebuild the hierarchy. Import replaces positions and keeps only the clan leader assigned to the root.</p>
		<textarea readonly rows='24' style='width:100%; box-sizing:border-box; resize:vertical; background:#111; color:#f0e3c4; border:1px solid #8B4513; border-radius:4px; padding:12px; font-family:Consolas, monospace; font-size:12px;'>[html_encode(hierarchy_json)]</textarea>
		<div>
			[import_html]
			<a href='?src=[REF(src)];action=show_hierarchy' class='btn-secondary' style='display:inline-block; margin-top:12px; text-decoration:none;'>View Hierarchy</a>
		</div>
	</div>
	"}

	user << browse(generate_combined_html(content), "window=clan_menu")

/datum/clan_menu_interface/proc/import_hierarchy_prompt()
	if(!user || !user_clan)
		return

	if(!can_import_hierarchy())
		to_chat(user, span_warning("You do not have permission to import clan hierarchy JSON."))
		show_hierarchy_json("Import failed: insufficient hierarchy permissions.")
		return

	var/raw_json = input(user, "Paste clan hierarchy JSON. This replaces positions and clears member assignments except the clan leader.", "Import Clan Hierarchy") as null|message
	if(!raw_json)
		show_hierarchy_json()
		return

	if(!user || user.clan != user_clan || !can_import_hierarchy())
		return

	raw_json = trim(raw_json)
	if(!length(raw_json))
		show_hierarchy_json()
		return

	if(length(raw_json) > CLAN_HIERARCHY_JSON_MAX_LENGTH)
		to_chat(user, span_warning("Clan hierarchy JSON is too large."))
		show_hierarchy_json("Import failed: JSON is too large.")
		return

	var/list/import_data = safe_json_decode(raw_json)
	if(!islist(import_data))
		to_chat(user, span_warning("Clan hierarchy JSON could not be parsed."))
		show_hierarchy_json("Import failed: invalid JSON.")
		return

	var/import_result = user_clan.import_hierarchy_data(import_data, user)
	to_chat(user, span_notice(import_result))

	var/datum/clan_hierarchy_interface/interface = ensure_hierarchy_interface()
	if(interface)
		interface.selected_position = null
	interface?.calculate_hierarchy_positions()
	show_hierarchy_json(import_result)

/datum/clan_menu_interface/generate_combined_html(research_content, in_preview = FALSE)
	. = ..(research_content, in_preview)

	var/settings_html = {"
				<h3>Clan Settings</h3>
				<ul class=\"coven-list\">
					<li class=\"coven-item hierarchy-button\">
						<a href=\"?src=[REF(src)];action=[CLAN_HIERARCHY_JSON_SHOW_ACTION]\" class=\"coven-name\" style=\"display:block; text-decoration:none; user-select:none;\">Hierarchy JSON</a>
						<div class=\"coven-stats\">
							<a href=\"?src=[REF(src)];action=[CLAN_HIERARCHY_JSON_SHOW_ACTION]\" style=\"color:#FFFFFF; text-decoration:underline; user-select:none;\">Export</a>
							<a href=\"?src=[REF(src)];action=[CLAN_HIERARCHY_JSON_IMPORT_ACTION]\" style=\"color:#FFFFFF; text-decoration:underline; user-select:none;\">Import</a>
						</div>
					</li>
				</ul>
	"}

	. = replacetext(., "<h3>Your Covens</h3>", "[settings_html]<h3>Your Covens</h3>")

#undef CLAN_HIERARCHY_JSON_VERSION
#undef CLAN_HIERARCHY_JSON_MAX_NODES
#undef CLAN_HIERARCHY_JSON_MAX_LENGTH
#undef CLAN_HIERARCHY_JSON_SHOW_ACTION
#undef CLAN_HIERARCHY_JSON_IMPORT_ACTION
