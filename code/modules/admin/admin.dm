////////////////////////////////
/proc/message_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">[msg]</span></span>"
	for(var/client/C in GLOB.admins)
		if(check_rights_for(C, R_ADMIN))
			to_chat(C, msg)

/proc/spawn_message_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">[msg]</span></span>"
	for(var/client/C in GLOB.admins)
		if(check_rights_for(C, R_ADMIN) && (C.prefs.admin_chat_toggles & CHAT_ADMINSPAWN))
			to_chat(C, msg)

/proc/relay_msg_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">RELAY:</span> <span class=\"message linkify\">[msg]</span></span>"
	to_chat(GLOB.admins, msg)


///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel_next(mob/M, clicked_flag = null)
	log_admin("[key_name(usr)] checked the individual player panel for [key_name(M)][isobserver(usr)?"":" while in game"].")

	if(!M)
		to_chat(usr, "<span class='warning'>I seem to be selecting a mob that doesn't exist anymore.</span>")
		return

	var/body = "<html><head><title>Options for [M.key]</title><style>"
	body += "<style>"
	body += "html, body { height: 100%; margin: 0; padding: 0; overflow-x: hidden; }"
	body += "#container { display: flex; flex-direction: row; align-items: flex-start; width: 100%; overflow-x: hidden; flex-wrap: nowrap; }"
	body += "#left { flex: 2; padding-right: 10px; min-width: 0; }"
	body += "#skills-section, #languages-section, #stats-section { display: none; background: white; border: 1px solid black; padding: 10px; width: 100%; box-sizing: border-box; max-width: 100%; overflow-x: hidden; word-wrap: break-word; }"
	body += "#right { flex: 1; border-left: 2px solid black; padding-left: 10px; max-height: 500px; overflow-y: auto; width: 250px; min-width: 250px; box-sizing: border-box; position: relative; }"
	body += "#right-header { display: flex; justify-content: space-around; padding: 5px; background: white; border-bottom: 2px solid black; position: sticky; top: 0; z-index: 10; }"
	body += "#right-header button { flex: 1; margin: 2px; padding: 5px; cursor: pointer; font-weight: bold; border: none; background-color: #ddd; border-radius: 5px; }"
	body += "#right-header button:hover { background-color: #ccc; }"

	body += "</style>"

	body += "<script>"
	body += "function toggleSection(section) {"
	body += "    localStorage.setItem('activeSection', section);"
	body += "    document.getElementById('skills-section').style.display = (section === 'skills') ? 'block' : 'none';"
	body += "    document.getElementById('languages-section').style.display = (section === 'languages') ? 'block' : 'none';"
	body += "	 document.getElementById('stats-section').style.display = (section === 'stats') ? 'block' : 'none';"
	body += "}"

	body += "function refreshAndKeepSection(section) {"
	body += "    localStorage.setItem('activeSection', section);"
	body += "    location.reload();"
	body += "}"

	body += "window.onload = function() {"
	body += "    var activeSection = \"[clicked_flag]\";"
	body += "    if (activeSection !== \"0\" && activeSection !== \"\") {"
	body += "        toggleSection(activeSection);"
	body += "    }"
	body += "}"
	body += "</script>"

	body +="</head>"
	body += "<body><div id='container'>"
	body += "<div id='left'>"
	body += "<body>Options panel for <b>[M]</b>"
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='?_src_=holder;[HrefToken()];editrights=[(GLOB.admin_datums[M.client.ckey] || GLOB.deadmins[M.client.ckey]) ? "rank" : "add"];key=[M.key]'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"
		if(CONFIG_GET(flag/use_exp_tracking))
			body += "\[<A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(M)]'>" + M.client.get_exp_living() + "</a>\]"

	if(isnewplayer(M))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='?_src_=holder;[HrefToken()];revive=[REF(M)]'>Heal</A>\] "

	if(M.client)
		body += "<br>\[<b>First Seen:</b> [M.client.player_join_date]\]\[<b>Byond account registered on:</b> [M.client.account_join_date]\] IP: [M.client.address]"
		body += "<br><br><b>Show related accounts by:</b> "
		body += "\[ <a href='?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(M.client)]'>CID</a> | "
		body += "<a href='?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(M.client)]'>IP</a> \]"

		var/pq = get_playerquality(M.ckey, TRUE)
		var/pq_num = get_playerquality(M.ckey, FALSE)
		body += "<br><br>Player Quality: [pq] ([pq_num])"
		body += "<br><a href='?_src_=holder;[HrefToken()];editpq=add;mob=[REF(M)]'>\[Modify PQ\]</a> "
		body += "<a href='?_src_=holder;[HrefToken()];showpq=add;mob=[REF(M)]'>\[Check PQ\]</a> "
		body += "<br><a href='?_src_=holder;[HrefToken()];edittriumphs=add;mob=[REF(M)]'>\[Modify Triumphs\]</a> "
		body += "<br>"
		body += "<a href='?_src_=holder;[HrefToken()];roleban=add;mob=[REF(M)]'>\[Role Ban Panel\]</a> "

		var/patron = "NA"
		if(isliving(M))
			var/mob/living/living = M
			patron = initial(living.patron.name)
		body += "<br><br>Current Patron: [patron]"

		var/idstatus = "<br>ID Status: "
		if(!M.ckey)
			idstatus += "No key!"
		else if(!M.check_agevet())
			idstatus += "Unverified"
		else
			var/vetadmin = LAZYACCESS(GLOB.agevetted_list, M.ckey)
			idstatus += "<b>Age Verified</b> by [vetadmin]"
		body += idstatus

		//Azure port. Incompatibility.
		/*var/curse_string = ""
		if(ishuman(M))
			var/mob/living/carbon/human/living = M
			for(var/datum/curse/curse in living.curses)
				curse_string += "<br> - [curse.name]"
		body += "<br>Curses: [curse_string]"*/

		var/full_version = "Unknown"
		if(M.client.byond_version)
			full_version = "[M.client.byond_version].[M.client.byond_build ? M.client.byond_build : "xxx"]"
		body += "<br>\[<b>Byond version:</b> [full_version]\]<br>"


	body += "<br><br>\[ "
	body += "<a href='?_src_=vars;[HrefToken()];Vars=[REF(M)]'>VV</a> - "
	if(M.mind)
		body += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>TP</a> - "
	else
		body += "<a href='?_src_=holder;[HrefToken()];initmind=[REF(M)]'>Init Mind</a> - "
	body += "<a href='?priv_msg=[M.ckey]'>PM</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>SM</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M)]'>FLW</a> - "
	//Default to client logs if available
	var/source = LOGSRC_MOB
	if(M.client)
		source = LOGSRC_CLIENT
	body += "<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_src=[source]'>LOGS</a>\] <br>"

	body += "<b>Mob type</b> = [M.type]<br><br>"

	body += "<A href='?_src_=holder;[HrefToken()];boot2=[REF(M)]'>Kick</A> | "
	if(M.client)
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key];newbanip=[M.client.address];newbancid=[M.client.computer_id]'>Ban</A> | "
	else
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key]'>Ban</A> | "

	body += "<A href='?_src_=holder;[HrefToken()];showmessageckey=[M.ckey]'>Notes | Messages | Watchlist</A> | "
	if(M.client)
		body += "\ <A href='?_src_=holder;[HrefToken()];sendbacktolobby=[REF(M)]'>Send back to Lobby</A> | "
		var/muted = M.client.prefs.muted
		body += "<br><b>Mute: </b> "
		body += "\[<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"blue"]'>LOOC</font></a>\]"
		body += "(<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];jumpto=[REF(M)]'><b>Jump to</b></A> | "
	body += "<A href='?_src_=holder;[HrefToken()];getmob=[REF(M)]'>Get</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];sendmob=[REF(M)]'>Send To</A>"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>Traitor panel</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];narrateto=[REF(M)]'>Narrate to</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>Subtle message</A> | "
	//body += "<A href='?_src_=holder;[HrefToken()];languagemenu=[REF(M)]'>Language Menu</A>"

	body += "</div>"

	body += "<div id='right'>"
	body += "<div id='right-header'>"
	body += "<button onclick=\"toggleSection('skills')\">Skills</button>"
	body += "<button onclick=\"toggleSection('languages')\">Languages</button>"
	body += "<button onclick=\"toggleSection('stats')\">Stats</button>"
	body += "</div>"


	body += "<div id='skills-section'>"
	body += "<h3>Skills</h3><ul>"
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill = GetSkillRef(skill_type)
		if(skill in M.skills?.known_skills)
			body += "<li>[initial(skill.name)]: [M.skills?.known_skills[skill]] "
		else
			body += "<li>[initial(skill.name)]: 0"
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];increase_skill=[REF(M)];skill=[skill.type]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];decrease_skill=[REF(M)];skill=[skill.type]'>-</a></li>"
	body += "</ul></div>"

	body += "<div id='languages-section'>"
	body += "<h3>Languages</h3><ul>"
	for(var/datum/language/ld as anything in GLOB.all_languages)
		body += "<li>[initial(ld.name)] - "
		if (M.mind?.language_holder?.has_language(ld))
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];remove_language=[REF(M)];language=[ld]'>Remove</a></li>"
		else
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_language=[REF(M)];language=[ld]'>Grant</a></li>"
	body += "</ul></div>"

	body += "<div id='stats-section'>"
	// Stats Section
	body += "<h3>Stats</h3><ul>"
	if(isliving(M)) // Ensure M is a living mob
		var/mob/living/living = M // Explicitly cast M to /mob/living
		body += "<li>Strength: [living.STASTR] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=strength'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=strength'>-</a></li>"

		body += "<li>Perception: [living.STAPER] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=perception'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=perception'>-</a></li>"

		body += "<li>Willpower: [living.STAWIL] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=willpower'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=willpower'>-</a></li>"

		body += "<li>Constitution: [living.STACON] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=constitution'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=constitution'>-</a></li>"

		body += "<li>Intelligence: [living.STAINT] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=intelligence'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=intelligence'>-</a></li>"

		body += "<li>Speed: [living.STASPD] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=speed'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=speed'>-</a></li>"

		body += "<li>Luck: [living.STALUC] "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=fortune'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=fortune'>-</a></li>"
		body += "</ul>"


		body += "</div>"
		body += "</div>"


		body += "<br>"
		body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-[REF(M)];size=800x600")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/admin_heal(mob/living/M in GLOB.mob_list)
	set name = "Mob - Heal"
	set desc = "Heal a mob to full health"
	set category = "-GameMaster-"

	if(!check_rights())
		return

	M.fully_heal(admin_revive = TRUE, break_restraints = TRUE)
	message_admins(span_danger("Admin [key_name_admin(usr)] healed [key_name_admin(M)]!"))
	log_admin("[key_name(usr)] healed [key_name(M)].")

/datum/admins/proc/show_player_panel(mob/M in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!check_rights())
		return

	show_player_panel_next(M)

/client/proc/show_player_panel_next(mob/M)
	holder?.show_player_panel_next(M)

/datum/admins/proc/admin_revive(mob/living/M in GLOB.mob_list)
	set name = "Mob - Revive"
	set desc = "Resuscitate a mob"
	set category = "-GameMaster-"

	if(!check_rights())
		return

	M.revive(full_heal = TRUE, admin_revive = TRUE)
	message_admins(span_danger("Admin [key_name_admin(usr)] revived [key_name_admin(M)]!"))
	log_admin("[key_name(usr)] Revived [key_name(M)].")

/datum/admins/proc/checkpq(mob/living/M in GLOB.mob_list)
	set name = "Check PQ"
	set desc = "Check a mob's PQ"
	set category = null

	if(!check_rights())
		return

	if(!M.ckey)
		to_chat(src, span_warning("There is no ckey attached to this mob."))
		return

	check_pq_menu(M.ckey)

/datum/admins/proc/admin_sleep(mob/living/M in GLOB.mob_list)
	set name = "Toggle Sleeping"
	set desc = "Toggle a mob's sleeping state"
	set category = "-GameMaster-"

	if(!check_rights())
		return

	var/S = M.IsSleeping()
	if(S)
		M.remove_status_effect(S)
		M.set_resting(FALSE, TRUE)
		M.fallingas = FALSE
	else
		M.SetSleeping(999999)
	message_admins(span_danger("Admin [key_name_admin(usr)] toggled [key_name_admin(M)]'s sleeping state!"))
	log_admin("[key_name(usr)] toggled [key_name(M)]'s sleeping state.")

/datum/admins/proc/start_vote()
	set name = "Start Vote"
	set desc = "Start a vote"
	set category = "-Server-"

	if(!check_rights(R_POLL))
		to_chat(usr, span_warning("You do not have the rights to start a vote."))
		return

	var/list/allowed_modes = list("End Round", "Storyteller", "Custom")

	var/type = input("What kind of vote?") as null|anything in allowed_modes
	switch(type)
		//if("Gamemode")
			//type = "gamemode"
		if("End Round")
			type = "endround"
		if("Custom")
			type = "custom"
		if("Storyteller")
			type = "storyteller"
	SSvote.initiate_vote(type, usr.key)

/datum/admins/proc/adjustpq(mob/living/M in GLOB.mob_list)
	set name = "Adjust PQ of Anything"
	set desc = "Adjust a player's PQ"
	set category = "-GameMaster-"
	set hidden = 1

	if(!check_rights())
		return
	
	if(!M.ckey)
		to_chat(src, span_warning("There is no ckey attached to this mob."))
		return

	var/ckey = lowertext(M.ckey)
	var/admin = lowertext(usr.key)

	/*if(ckey == admin)
		to_chat(src, span_boldwarning("That's you!"))
		return
	*/
	if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences.sav"))
		to_chat(src, span_boldwarning("User does not exist."))
		return
	var/amt2change = input("How much to modify the PQ by? (20 to -20, or 0 to just add a note)") as null|num
	if(!check_rights(R_ADMIN,0))
		amt2change = CLAMP(amt2change, -20, 20)
	var/raisin = stripped_input("State a short reason for this change", "Game Master", "", null)
	if((!isnull(amt2change) && amt2change != 0) && !raisin)
		return
	adjust_playerquality(amt2change, ckey, admin, raisin)
	to_chat(M.client, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">Your PQ has been adjusted by [amt2change] by [admin] for reason: [raisin]</span></span>")

/datum/admins/proc/Game()
	if(!check_rights(0))
		return

	var/dat = "<html><meta charset='UTF-8'><head><title>Game Panel</title></head><body>"
	dat += {"
		<center><B>Game Panel</B></center><hr>\n
		"}
	if(GLOB.master_mode == "secret")
		dat += "<A href='?src=[REF(src)];[HrefToken()];f_secret=1'>(Force Secret Mode)</A><br>"
	if(SSticker.IsRoundInProgress())
		dat += "<a href='?src=[REF(src)];[HrefToken()];gamemode_panel=1'>(Game Mode Panel)</a><BR>"
	dat += {"
		<BR>
		<A href='?src=[REF(src)];[HrefToken()];create_object=1'>Create Object</A><br>
		<A href='?src=[REF(src)];[HrefToken()];quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_turf=1'>Create Turf</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_mob=1'>Create Mob</A><br>
		"}

	if(marked_datum && istype(marked_datum, /atom))
		dat += "<A href='?src=[REF(src)];[HrefToken()];dupe_marked_datum=1'>Duplicate Marked Datum</A><br>"

	dat += "</body></html>"
	usr << browse(dat, "window=admin2;size=240x280")
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "-Server-"
	set name = "Reboot World"
	set desc="Restarts the world immediately"
	if (!usr.client.holder)
		return

	var/list/options = list("Regular Restart", "Hard Restart (No Delay/Feeback Reason)", "Hardest Restart (No actions, just reboot)")
	if(world.TgsAvailable())
		options += "Server Restart (Kill and restart DD)";

	var/rebootconfirm
	if(SSticker.admin_delay_notice)
		if(alert(usr, "Are you sure? An admin has already delayed the round end for the following reason: [SSticker.admin_delay_notice]", "Confirmation", "Yes", "No") == "Yes")
			rebootconfirm = TRUE
	else
		rebootconfirm = TRUE
	if(rebootconfirm)
		var/result = input(usr, "Select reboot method", "World Reboot", options[1]) as null|anything in options
		if(result)
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			var/init_by = "Initiated by Admin."
			switch(result)
				if("Regular Restart")
					SSticker.Reboot(init_by, "admin reboot - by Admin", 10)
				if("Hard Restart (No Delay, No Feeback Reason)")
					to_chat(world, "World reboot - [init_by]")
					world.Reboot()
				if("Hardest Restart (No actions, just reboot)")
					to_chat(world, "Hard world reboot - [init_by]")
					world.Reboot(fast_track = TRUE)
				if("Server Restart (Kill and restart DD)")
					to_chat(world, "Server restart - [init_by]")
					world.TgsEndProcess()

/datum/admins/proc/end_round()
	set category = "-Server-"
	set name = "End Round"
	set desc = ""

	if (!usr.client.holder)
		return
	var/confirm = alert("End the round and restart the game world?", "End Round", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		SSticker.force_ending = 1
		SSblackbox.record_feedback("tally", "admin_verb", 1, "End Round") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/announce()
	set category = "-Special Verbs-"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))
		return

	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		to_chat(world, "<span class='adminnotice'><b>[usr.client.holder.fakekey ? "Administrator" : usr.key] Announces:</b></span>\n \t [message]")
		log_admin("Announce: [key_name(usr)] : [message]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Announce") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/set_admin_notice()
	set category = "-Server-"
	set name = "Set Admin Notice"
	set desc ="Set an announcement that appears to everyone who joins the server. Only lasts this round"
	if(!check_rights(0))
		return

	var/new_admin_notice = input(src,"Set a public notice for this round. Everyone who joins the server will see it.\n(Leaving it blank will delete the current notice):","Set Notice",GLOB.admin_notice) as message|null
	if(new_admin_notice == null)
		return
	if(new_admin_notice == GLOB.admin_notice)
		return
	if(new_admin_notice == "")
		message_admins("[key_name(usr)] removed the admin notice.")
		log_admin("[key_name(usr)] removed the admin notice:\n[GLOB.admin_notice]")
	else
		message_admins("[key_name(usr)] set the admin notice.")
		log_admin("[key_name(usr)] set the admin notice:\n[new_admin_notice]")
		to_chat(world, span_adminnotice("<b>Admin Notice:</b>\n \t [new_admin_notice]"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Admin Notice") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	GLOB.admin_notice = new_admin_notice
	return

/datum/admins/proc/toggleooc()
	set category = "-Server-"
	set desc="Toggle dis bitch"
	set name="Toggle OOC"
	toggle_ooc()
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle OOC", "[GLOB.ooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleoocdead()
	set category = "-Server-"
	set desc="Toggle dis bitch"
	set name="Toggle Dead OOC"
	toggle_dooc()

	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Dead OOC", "[GLOB.dooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = "-Server-"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(SSticker.current_state == GAME_STATE_PREGAME || SSticker.current_state == GAME_STATE_STARTUP)
		SSticker.start_immediately = TRUE
		log_admin("[usr.key] has started the game.")
		var/msg = ""
		if(SSticker.current_state == GAME_STATE_STARTUP)
			msg = " (The server is still setting up, but the round will be \
				started as soon as possible.)"
		message_admins("<font color='blue'>\
			[usr.key] has started the game.[msg]</font>")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Now") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return 1
	else
		to_chat(usr, "<font color='red'>Error: Start Now: Game has already started.</font>")

	return 0

/datum/admins/proc/toggleenter()
	set category = "-Server-"
	set desc="People can't enter"
	set name="Toggle Entering"
	GLOB.enter_allowed = !( GLOB.enter_allowed )
	if (!( GLOB.enter_allowed ))
		to_chat(world, "<B>New players may no longer enter the game.</B>")
	else
		to_chat(world, "<B>New players may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled new player game entering.")
	message_admins(span_adminnotice("[key_name_admin(usr)] toggled new player game entering."))
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Entering", "[GLOB.enter_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "-Server-"
	set desc="People can't be AI"
	set name="Toggle AI"
	set hidden = 1
	var/alai = CONFIG_GET(flag/allow_ai)
	CONFIG_SET(flag/allow_ai, !alai)
	if (alai)
		to_chat(world, "<B>The AI job is no longer chooseable.</B>")
	else
		to_chat(world, "<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle AI", "[!alai ? "Disabled" : "Enabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "-Server-"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	set hidden = 1
	var/new_nores = !CONFIG_GET(flag/norespawn)
	CONFIG_SET(flag/norespawn, new_nores)
	if (!new_nores)
		to_chat(world, "<B>I may now respawn.</B>")
	else
		to_chat(world, "<B>I may no longer respawn :(</B>")
	message_admins(span_adminnotice("[key_name_admin(usr)] toggled respawn to [!new_nores ? "On" : "Off"]."))
	log_admin("[key_name(usr)] toggled respawn to [!new_nores ? "On" : "Off"].")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Respawn", "[!new_nores ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "-Server-"
	set desc="Delay the game start"
	set name="Delay pre-game"

	var/newtime = input("Set a new time in seconds. Set -1 for indefinite delay.","Set Delay",round(SSticker.GetTimeLeft()/10)) as num|null
	if(SSticker.current_state > GAME_STATE_PREGAME)
		return alert("Too late... The game has already started!")
	if(newtime)
		newtime = newtime*10
		SSticker.SetTimeLeft(newtime)
		if(newtime < 0)
			to_chat(world, "<b>The game start has been delayed.</b>")
			log_admin("[key_name(usr)] delayed the round start.")
		else
			to_chat(world, "<b>The game will start in [DisplayTimeText(newtime)].</b>")
			SEND_SOUND(world, sound('sound/blank.ogg'))
			log_admin("[key_name(usr)] set the pre-game delay to [DisplayTimeText(newtime)].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delay Game Start") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/unprison(mob/M in GLOB.mob_list)
	set category = "-Admin-"
	set name = "Unprison"
	if (is_centcom_level(M.z))
		SSjob.SendToLateJoin(M)
		message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]")
		log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
	else
		alert("[M.name] is not prisoned.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unprison") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/datum/admins/proc/spawn_atom(object as text)
	set category = "-GameMaster-"
	set desc = ""
	set name = "Spawn..."

	if(!check_rights(R_SPAWN) || !object)
		return

	var/list/preparsed = splittext(object,":")
	var/path = preparsed[1]
	var/amount = 1
	if(preparsed.len > 1)
		amount = CLAMP(text2num(preparsed[2]),1,ADMIN_SPAWN_CAP)

	var/chosen = pick_closest_path(path)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		for(var/i in 1 to amount)
			var/atom/A = new chosen(T)
			A.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(usr)] spawned [amount] x [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/podspawn_atom(object as text)
	set category = "Debug"
	set desc = ""
	set name = "Podspawn"

	if(!check_rights(R_SPAWN))
		return

	var/chosen = pick_closest_path(object)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		var/obj/structure/closet/supplypod/centcompod/pod = new()
		var/atom/A = new chosen(pod)
		A.flags_1 |= ADMIN_SPAWNED_1
		new /obj/effect/DPtarget(T, pod)

	log_admin("[key_name(usr)] pod-spawned [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Podspawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/spawn_cargo(object as text)
	set category = "Debug"
	set desc = ""
	set name = "Spawn Cargo"

	if(!check_rights(R_SPAWN))
		return

	var/chosen = pick_closest_path(object, make_types_fancy(subtypesof(/datum/supply_pack)))
	if(!chosen)
		return
	var/datum/supply_pack/S = new chosen
	S.admin_spawned = TRUE
	S.generate(get_turf(usr))

	log_admin("[key_name(usr)] spawned cargo pack [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Cargo") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/show_traitor_panel(mob/M in GLOB.mob_list)
	set category = "-Admin-"
	set desc = ""
	set name = "Show Traitor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.traitor_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Traitor Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmes"
	GLOB.tinted_weldhelh = !( GLOB.tinted_weldhelh )
	if (GLOB.tinted_weldhelh)
		to_chat(world, "<B>The tinted_weldhelh has been enabled!</B>")
	else
		to_chat(world, "<B>The tinted_weldhelh has been disabled!</B>")
	log_admin("[key_name(usr)] toggled tinted_weldhelh.")
	message_admins("[key_name_admin(usr)] toggled tinted_weldhelh.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Tinted Welding Helmets", "[GLOB.tinted_weldhelh ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "-Server-"
	set desc="Guests can't enter"
	set name="Toggle guests"
	set hidden = 1
	var/new_guest_ban = !CONFIG_GET(flag/guest_ban)
	CONFIG_SET(flag/guest_ban, new_guest_ban)
	if (new_guest_ban)
		to_chat(world, "<B>Guests may no longer enter the game.</B>")
	else
		to_chat(world, "<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed.")
	message_admins(span_adminnotice("[key_name_admin(usr)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed."))
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Guests", "[!new_guest_ban ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/manage_free_slots()
	if(!check_rights())
		return
	var/datum/browser/browser = new(usr, "jobmanagement", "Manage Free Slots", 520)
	var/list/dat = list()
	var/count = 0

	if(!SSjob.initialized)
		alert(usr, "You cannot manage jobs before the job subsystem is initialized!")
		return

	dat += "<table>"

	for(var/j in SSjob.occupations)
		var/datum/job/job = j
		count++
		var/J_title = html_encode(job.title)
		var/J_opPos = html_encode(job.total_positions - (job.total_positions - job.current_positions))
		var/J_totPos = html_encode(job.total_positions)
		dat += "<tr><td>[J_title]:</td> <td>[J_opPos]/[job.total_positions < 0 ? " (unlimited)" : J_totPos]"

		dat += "</td>"
		dat += "<td>"
		if(job.total_positions >= 0)
			dat += "<A href='?src=[REF(src)];[HrefToken()];customjobslot=[job.title]'>Custom</A> | "
			dat += "<A href='?src=[REF(src)];[HrefToken()];addjobslot=[job.title]'>Add 1</A> | "
			if(job.total_positions > job.current_positions)
				dat += "<A href='?src=[REF(src)];[HrefToken()];removejobslot=[job.title]'>Remove</A> | "
			else
				dat += "Remove | "
			dat += "<A href='?src=[REF(src)];[HrefToken()];unlimitjobslot=[job.title]'>Unlimit</A></td>"
		else
			dat += "<A href='?src=[REF(src)];[HrefToken()];limitjobslot=[job.title]'>Limit</A></td>"

	browser.height = min(100 + count * 20, 650)
	browser.set_content(dat.Join())
	browser.open()

/datum/admins/proc/create_or_modify_area()
	set category = "Debug"
	set name = "Create/Modify area"
	create_area(usr)

//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//

//RIP ferry snowflakes

//Kicks all the clients currently in the lobby. The second parameter (kick_only_afk) determins if an is_afk() check is ran, or if all clients are kicked
//defaults to kicking everyone (afk + non afk clients in the lobby)
//returns a list of ckeys of the kicked clients
/proc/kick_clients_in_lobby(message, kick_only_afk = 0)
	var/list/kicked_client_names = list()
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			if(kick_only_afk && !C.is_afk()) //Ignore clients who are not afk
				continue
			if(message)
				to_chat(C, message)
			kicked_client_names.Add("[C.key]")
			qdel(C)
	return kicked_client_names

//returns 1 to let the dragdrop code know we are trapping this event
//returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(mob/dead/observer/frommob, mob/tomob)

	//this is the exact two check rights checks required to edit a ckey with vv.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_SPAWN|R_DEBUG,0))
		return 0

	if (!frommob.ckey)
		return 0

	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"

	var/ask = alert(question, "Place ghost in control of mob?", "Yes", "No")
	if (ask != "Yes")
		return 1

	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return 1

	tomob.ghostize(0)

	message_admins(span_adminnotice("[key_name_admin(usr)] has put [frommob.key] in control of [tomob.name]."))
	log_admin("[key_name(usr)] stuffed [frommob.key] into [tomob.name].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Ghost Drag Control")

	tomob.ckey = frommob.ckey
	qdel(frommob)

	return 1

/client/proc/adminGreet(logout)
	if(SSticker.HasRoundStarted())
		var/string
		if(logout && CONFIG_GET(flag/announce_admin_logout))
			string = pick(
				"Admin logout: [key_name(src)]")
		else if(!logout && CONFIG_GET(flag/announce_admin_login) && (prefs.toggles & ANNOUNCE_LOGIN))
			string = pick(
				"Admin login: [key_name(src)]")
		if(string)
			message_admins("[string]")


/client/proc/returntolobby()
	set category = "-Special Verbs-"
	set name = "Back to Lobby"

	var/mob/living/carbon/human/H = mob
	var/datum/job/mob_job
	var/target_job = SSrole_class_handler.get_advclass_by_name(H.advjob)

	if(H.mind)
		mob_job = SSjob.GetJob(H.mind.assigned_role)
		if(mob_job)
			mob_job.current_positions = max(0, mob_job.current_positions - 1)
		if(target_job)
			SSrole_class_handler.adjust_class_amount(target_job, -1)
		H.mind.unknow_all_people()
		for(var/datum/mind/MF in get_minds())
			H.mind.become_unknown_to(MF)
		for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
			if(removing_bounty.target == H.real_name)
				GLOB.head_bounties -= removing_bounty
	else
		alert(usr, "Target has no mind!") // Optional Error check that may or may not be neccessary
	GLOB.chosen_names -= H.real_name
	LAZYREMOVE(GLOB.actors_list, H.mobid)
	LAZYREMOVE(GLOB.roleplay_ads, H.mobid)
	H.returntolobby()


/datum/admins/proc/sleep_view()
	set name = "inview Sleep"
	set category = "-GameMaster-"
	set hidden = FALSE

	if(!check_rights(R_ADMIN))
		return

	if(alert("This will sleep ALL mobs within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return
	for(var/mob/living/M in view(usr.client))
		M.SetSleeping(999999)

	message_admins("[key_name(usr)] used Toggle Sleep In View.")

/datum/admins/proc/wake_view()
	set name = "inview Wake"
	set category = "-GameMaster-"
	set hidden = FALSE

	if(!check_rights(R_ADMIN))
		return

	if(alert("This wake ALL mobs within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return
	for(var/mob/living/M in view(usr.client))
		var/S = M.IsSleeping()
		if(S)
			M.remove_status_effect(S)
			M.set_resting(FALSE, TRUE)
			M.fallingas = FALSE

	message_admins("[key_name(usr)] used Toggle Wake In View.")

GLOBAL_VAR_INIT(extend_round_timestamp, 0)
/datum/admins/proc/extend_round()
	set name = "Extend Round"
	set category = "-Server-"
	set hidden = FALSE

	if(!check_rights(R_ADMIN))
		return

	if(alert("Prolong the end of the round by 30 minutes. This delays the vote, or delays the end after the vote is successful. Are you sure?",,"Yes","Cancel") == "Cancel")
		return

	if(world.time < GLOB.extend_round_timestamp + (1 MINUTES))
		to_chat(usr, "<span class='notice'>Someone recently pressed this button! Wait a minute before pressing it again.</span>")
		return

	if((GLOB.round_timer > world.time + (3 * ROUND_EXTENSION_TIME)) || SSgamemode.round_ends_at - world.time > (3 * ROUND_EXTENSION_TIME))
		to_chat(usr, "<span class='notice'>Failsafe! Round end is already over 3 times out! Ignoring.</span>")
		return
	if(SSgamemode.round_ends_at != 0) // End round is already ticking.
		SSgamemode.round_ends_at += ROUND_EXTENSION_TIME
	else //We push back the automated endround vote.
		GLOB.round_timer = GLOB.round_timer + ROUND_EXTENSION_TIME
	log_admin("[key_name(usr)] extended the round by 30 minutes.")
	message_admins("[key_name(usr)] extended the round by 30 minutes.")
	GLOB.extend_round_timestamp = world.time
