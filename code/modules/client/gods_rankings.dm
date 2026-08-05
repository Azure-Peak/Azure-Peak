/proc/check_roundstart_gods_rankings()
	var/json_file = file("data/gods_rankings.json")
	if(!fexists(json_file))
		return

	var/list/json = json_decode(file2text(json_file))
	var/modified = FALSE

	for(var/god_name in json)
		if(json[god_name] >= 100)
			json[god_name] = 0
			modified = TRUE
			for(var/storyteller_name in SSgamemode.storytellers)
				var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller_name]
				if(istype(initialized_storyteller, /datum/storyteller/gamemode))	// a stale preset entry in the json must not mark a preset ascendant
					continue
				if(initialized_storyteller?.name == god_name)
					initialized_storyteller.ascendant = TRUE
					adjust_storyteller_influence(initialized_storyteller.name, 400)
					break

	if(modified)
		fdel(json_file)
		WRITE_FILE(json_file, json_encode(json))

/proc/get_god_rankings()
	var/json_file = file("data/gods_rankings.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
		return list()

	var/list/json = json_decode(file2text(json_file))
	return json

/proc/update_god_rankings()
	var/most_influential
	var/most_frequent
	var/highest_influence = -1
	var/highest_chosen = -1

	for(var/storyteller_name in SSgamemode.storytellers)
		var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller_name]
		if(!initialized_storyteller)
			continue
		if(istype(initialized_storyteller, /datum/storyteller/gamemode))
			continue

		if(initialized_storyteller.ascendant)
			continue

		var/influence = SSgamemode.calculate_storyteller_influence(initialized_storyteller.type)
		if(influence > highest_influence)
			highest_influence = influence
			most_influential = initialized_storyteller.name

		if(initialized_storyteller.times_chosen > highest_chosen)
			highest_chosen = initialized_storyteller.times_chosen
			most_frequent = initialized_storyteller.name

	if(!most_influential || !most_frequent)
		return

	var/json_file = file("data/gods_rankings.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	var/current_points_influential = json[most_influential] || 0
	var/current_points_frequent = json[most_frequent] || 0
	if(most_influential == most_frequent)
		json[most_influential] = current_points_influential + 2
	else
		json[most_influential] = current_points_influential + 1
		json[most_frequent] = current_points_frequent + 1

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

/proc/cmp_god_ranking(list/a, list/b)
	return b["points"] - a["points"]

/proc/create_god_ranking_entry(god_name, points, color_theme)
	var/percentage = min(points, 100)

	return {"
	<div style='margin-bottom: 8px;'>
		<div style='display: flex; align-items: center; gap: 8px;'>
			<div style='width: 80px; margin-left: 40px; color: [color_theme];'>[god_name]</div>
			<div style='flex-grow: 1; background: #333; height: 20px;'>
				<div style='width: [percentage]%; height: 100%; background: [color_theme];'></div>
			</div>
			<div style='width: 50px; text-align: right;'>[points]/100</div>
		</div>
	</div>
	"}
