#define RCP_CONTRIBUTION_CAP 20 // How much RCP can contribute to PQ gain total.

/proc/get_playerquality(key, text)
	if(!key)
		return
	var/the_pq = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/pq_num.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	if(json[ckey(key)])
		the_pq = json[ckey(key)]
	if(!the_pq)
		the_pq = 0
	if(!text)
		return the_pq
	var/list/display = get_playerquality_display(the_pq)
	if(!display["color"])
		return display["label"]
	return "<span style='color: [display["color"]];'>[display["label"]]</span>"

/// Returns list("label" = tier name, "color" = hex color or null) for a numeric PQ value.
/proc/get_playerquality_display(the_pq)
	if(the_pq >= 100)
		return list("label" = "TRUE VALMORIAN", "color" = "#74cde0")
	if(the_pq >= 70)
		return list("label" = "Magnificent!", "color" = "#00ff00")
	if(the_pq >= 50)
		return list("label" = "Exceptional!", "color" = "#00ff00")
	if(the_pq >= 30)
		return list("label" = "Great!", "color" = "#47b899")
	if(the_pq >= 10)
		return list("label" = "Good!", "color" = "#69c975")
	if(the_pq >= 5)
		return list("label" = "Nice", "color" = "#58a762")
	if(the_pq >= -4)
		return list("label" = "Normal", "color" = null)
	if(the_pq >= -30)
		return list("label" = "Poor", "color" = "#be6941")
	if(the_pq >= -70)
		return list("label" = "Terrible", "color" = "#cd4232")
	if(the_pq >= -99)
		return list("label" = "Abysmal", "color" = "#e2221d")
	return list("label" = "Shitter", "color" = "#ff00ff")

/proc/adjust_playerquality(amt, key, admin, reason)
	var/curpq = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/pq_num.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))
	if(json[key])
		curpq = json[key]
	curpq += amt
	curpq = CLAMP(curpq, -100, 100)
	json[key] = curpq
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	if(reason || admin)
		var/thing = ""
		if(amt > 0)
			thing += "+[amt]"
		if(amt < 0)
			thing += "[amt]"
		if(admin)
			thing += " by [admin]"
		if(reason)
			thing += " for reason: [reason]"
		if(amt == 0)
			if(!reason && !admin)
				return
			if(admin)
				thing = "NOTE from [admin]: [reason]"
			else
				thing = "NOTE: [reason]"
		thing += " ([GLOB.rogue_round_id])"
		thing += "\n"
		text2file(thing,"data/player_saves/[copytext(key,1,2)]/[key]/playerquality.txt")

		var/msg
		if(!amt)
			msg = "[key] triggered event [msg]"
		else
			if(amt > 0)
				msg = "[key] ([amt])"
			else
				msg = "[key] ([amt])"
		if(admin)
			msg += " - GM: [admin]"
		if(reason)
			msg += " - RSN: [reason]"
		message_admins("[admin] adjusted [key]'s PQ by [amt] for reason: [reason]")
		log_admin("[admin] adjusted [key]'s PQ by [amt] for reason: [reason]")

/client/proc/check_pq()
	set category = "Admin.Special"
	set name = "PQ - Check"
	if(!holder)
		return
	var/selection = alert(src, "Check VIA...", "Check PQ", "Character List", "Player List", "Player Name")
	if(!selection)
		return
	var/list/selections = list()
	var/theykey
	if(selection == "Character List")
		for(var/mob/living/H in GLOB.player_list)
			selections[H.real_name] = H.ckey
		if(!selections.len)
			to_chat(src, span_boldwarning("No characters found."))
			return
		selection = input("Which Character?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player List")
		for(var/client/C in GLOB.clients)
			var/usedkey = C.ckey
			selections[usedkey] = C.ckey
		selection = input("Which Player?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player Name")
		selection = input("Which Player?", "CKEY", "") as text|null
		if(!selection)
			return
		theykey = selection
	check_pq_menu(theykey)

/proc/check_pq_menu(ckey)
	if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences.sav"))
		to_chat(usr, span_boldwarning("User does not exist."))
		return
	var/datum/pq_menu/menu = new(ckey)
	menu.ui_interact(usr)

/// TGUI player quality panel - replaces the legacy "playerquality" browser popup
/// (and inlines the admin-only "cursecheck"/"commendscheck" popups as sections).
/datum/pq_menu
	var/target_ckey

/datum/pq_menu/New(target_ckey)
	src.target_ckey = target_ckey

/datum/pq_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/pq_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlayerQuality")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/pq_menu/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/pq_menu/ui_data(mob/user)
	var/list/data = list()
	data["ckey"] = target_ckey
	data["pq_num"] = get_playerquality(target_ckey)
	var/list/pq_display = get_playerquality_display(data["pq_num"])
	data["pq_text"] = pq_display["label"]
	data["pq_color"] = pq_display["color"]
	data["commends"] = get_commends(target_ckey)
	data["roundpoints"] = get_roundpoints(target_ckey)
	data["roundsplayed"] = get_roundsplayed(target_ckey)

	var/list/history = list()
	var/list/listy = world.file2list("data/player_saves/[copytext(target_ckey,1,2)]/[target_ckey]/playerquality.txt")
	for(var/i = listy.len to 1 step -1)
		if(listy[i])
			history += listy[i]
	data["history"] = history

	var/is_admin = !!user?.client?.holder
	data["is_admin"] = is_admin
	if(is_admin)
		var/list/commend_rows = list()
		var/json_file = file("data/player_saves/[copytext(target_ckey,1,2)]/[target_ckey]/commends.json")
		if(fexists(json_file))
			var/list/json = json_decode(file2text(json_file))
			for(var/giver in json)
				commend_rows += list(list("giver" = giver, "amount" = json[giver]))
		data["commend_rows"] = commend_rows
		var/list/curse_rows = list()
		var/curse_file = file("data/player_saves/[copytext(target_ckey,1,2)]/[target_ckey]/curses.json")
		var/list/cursed = list()
		if(fexists(curse_file))
			cursed = json_decode(file2text(curse_file))
		for(var/curse in CURSE_MASTER_LIST)
			curse_rows += list(list("name" = curse, "enabled" = (curse in cursed)))
		data["curse_rows"] = curse_rows
	return data

/client/proc/adjust_pq()
	set category = "Admin.Special"
	set name = "PQ - Adjust"
	if(!holder)
		return
	var/selection = alert(src, "Adjust VIA...", "MODIFY PQ", "Character List", "Player List", "Player Name")
	var/list/selections = list()
	var/theykey
	if(selection == "Character List")
		for(var/mob/living/H in GLOB.player_list)
			selections[H.real_name] = H.ckey
		if(!selections.len)
			to_chat(src, span_boldwarning("No characters found."))
			return
		selection = input("Which Character?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player List")
		for(var/client/C in GLOB.clients)
			var/usedkey = C.ckey
//			if(!check_rights(R_ADMIN,0))
//				if(C.ckey in GLOB.anonymize)
//					usedkey = get_fake_key(C.ckey)
			selections[usedkey] = C.ckey
		selection = input("Which Player?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player Name")
		selection = input("Which Player?", "CKEY", "") as text|null
		if(!selection)
			return
		theykey = selection
	if(!fexists("data/player_saves/[copytext(theykey,1,2)]/[theykey]/preferences.sav"))
		to_chat(src, span_boldwarning("User does not exist."))
		return
	var/amt2change = input("How much to modify the PQ by? (20 to -20, or 0 to just add a note)") as null|num
	if(!check_rights(R_ADMIN,0))
		amt2change = CLAMP(amt2change, -20, 20)
	var/raisin = stripped_input("State a short reason for this change", "Game Master", "", null)
	if((!isnull(amt2change) && amt2change != 0) && !raisin)
		return
	adjust_playerquality(amt2change, theykey, src.ckey, raisin)
	for(var/client/C in GLOB.clients) // I hate this, but I'm not refactoring the cancer above this point.
		if(lowertext(C.key) == lowertext(theykey))
			to_chat(C, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">Your PQ has been adjusted by [amt2change] by [key] for reason: [raisin]</span></span>")
			return

/proc/add_commend(key, giver)
	if(!giver || !key)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/commends.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))
	if(json[giver])
		curcomm = json[giver]
	curcomm++
	json[giver] = curcomm
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	//add the pq, only on the first commend
	if(curcomm == 1)
//	if(get_playerquality(key) < 29)
		adjust_playerquality(1, ckey(key))

/proc/get_commends(key)
	if(!key)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/commends.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	for(var/X in json)
		curcomm += json[X]
	if(!curcomm)
		curcomm = 0
	return curcomm

/proc/add_roundpoints(amt, key) //Each round contributor point counts as 0.1 of a PQ.
	if(!key)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/rcp.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))
	if(json["RCP"])
		curcomm = json["RCP"]

	curcomm += amt
	json["RCP"] = curcomm
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	if(curcomm < 100 || get_playerquality(key) < RCP_CONTRIBUTION_CAP)
		adjust_playerquality(round(amt/10,0.1), ckey(key))

/proc/get_roundpoints(key)
	if(!key)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/rcp.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	if(json["RCP"])
		curcomm = json["RCP"]
	if(!curcomm)
		curcomm = 0
	return curcomm

#undef RCP_CONTRIBUTION_CAP

