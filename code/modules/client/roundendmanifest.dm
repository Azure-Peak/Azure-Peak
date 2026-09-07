/client/proc/view_rogue_manifest()
	var/dat
	dat += "<h3>Round ID: [GLOB.rogue_round_id]</h1>"
	for(var/X in GLOB.character_list)
		dat += "[GLOB.character_list[X]]"

	var/datum/browser/popup = new(src, "actors", "<center>Inhabitants of Azure Peak</center>", 387, 420)
	popup.set_content(dat)
	popup.open(FALSE)

/client/verb/view_actors_manifest()
	set category = "OOC"
	set name = "View Actors"
	if(!holder && !isobserver(mob) && SSticker.current_state < GAME_STATE_FINISHED && !istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("I can't use this while alive. No spoilers!"))
		return
	var/list/actors_list = get_sorted_actors_list()
	var/list/categories_used = list()

	var/dat
	for(var/mob_id in actors_list)
		var/list/actor_data = actors_list[mob_id]
		var/category = actor_data["category"]
		if(!(category in categories_used))
			if(length(categories_used))
				dat += "<br>"
			dat += "<center><h1 style='padding-top: 0;'>-- [category] --</h1></center>"
			categories_used += category
		var/list/character_data = actor_data["data"]
		dat += "<b>[character_data["name"]]</b> as <b>[character_data["rank"]]</b><br>"

	var/datum/browser/popup = new(src, "actors", "<center>This Story's Actors</center>", 387, 420)
	popup.set_content(dat)
	popup.open(FALSE)
