//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
//the procs are cause you can't put the comments in the GLOB var define

GLOBAL_LIST_INIT(admin_verbs_default, world.AVerbsDefault())
GLOBAL_PROTECT(admin_verbs_default)
/world/proc/AVerbsDefault()
	return list(
	/client/proc/check_pq,
	/client/proc/adjust_pq,
	/client/proc/hearallasghost,
	/client/proc/hearglobalLOOC,
	/client/proc/togglespawnmessages,
	/client/proc/toggle_aghost_invis,
	/client/proc/admin_ghost,
	/datum/admins/proc/start_vote,
	/datum/admins/proc/show_player_panel,
	/datum/admins/proc/admin_heal,
	/datum/admins/proc/admin_show_heal_panel,
	/datum/admins/proc/admin_show_inventory,
	/datum/admins/proc/admin_revive,
	/datum/admins/proc/admin_sleep,
	/client/proc/jumptoarea,
	/client/proc/jumptokey,
	/client/proc/mass_direct,
	/client/proc/local_lightsout,
	/datum/admins/proc/checkpq,
	/datum/admins/proc/adjustpq,
	/client/proc/cmd_assume_direct_control,
	/client/proc/jumptomob,
	/client/proc/returntolobby,
	/datum/verbs/menu/Admin/verb/playerpanel,
	/client/proc/check_antagonists,
	/client/proc/admin_force_next_migrant_wave,
	/client/proc/cmd_admin_say,
	/client/proc/deadmin,				/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/set_context_menu_enabled,
	/client/proc/delete_player_book,
	/client/proc/amend_player_book,
	/client/proc/enable_browser_debug,
	/client/proc/pull_book_file_names,
	/client/proc/admin_spread_effect,
	/client/proc/open_bounty_menu,
	/client/proc/remove_bounty,
	/client/proc/agevet_player,
	// RATWOOD MODULAR START
	/client/proc/bunker_bypass,
	// RATWOOD MODULAR END
	)
GLOBAL_LIST_INIT(admin_verbs_admin, world.AVerbsAdmin())
GLOBAL_PROTECT(admin_verbs_admin)
/world/proc/AVerbsAdmin()
	return list(
	/client/proc/adjusttriumph,
	/client/proc/end_party,
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/toggle_lobby_ooc,
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,				/* Almost entirely non-functional after Azure Peak Debloatening. Final few are redundant, but keeping just in case */
	/client/proc/toggle_hear_radio,		/*allows admins to hide all radio output*/
	/client/proc/reload_admins,
	/client/proc/reload_whitelist,
	/client/proc/reestablish_db_connection, /*reattempt a connection to the database*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,		/*admin-pm list*/
	/client/proc/stop_sounds,
	/client/proc/mark_datum_mapview,

	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage
//	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
//	/datum/verbs/menu/Admin/verb/playerpanel,
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/set_admin_notice, /*announcement all clients see when joining the server.*/
	/client/proc/toggle_aghost_invis, /* lets us choose whether our in-game mob goes visible when we aghost (off by default) */
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/hearallasghost,
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/getserverlogs,		/*for accessing server logs*/
	/client/proc/getcurrentlogs,		/*for accessing server logs for the current round*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage
	/client/proc/jumptoarea,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_local_narrate,	/*sends text to all mobs within view of atom*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_admin_check_player_exp, /* shows players by playtime */
	/client/proc/toggle_combo_hud, // toggle display of the combination pizza antag and taco sci/med/eng hud
	/client/proc/toggle_AI_interact, /*toggle admin ability to interact with machines as an AI*/
	/client/proc/toggleprayers,
	/client/proc/toggle_prayer_sound,
	/client/proc/colorasay,
	/client/proc/resetasaycolor,
	/client/proc/toggleadminhelpsound,
	/client/proc/respawn_character,
	/client/proc/discord_id_manipulation, /* No Discord implementation? */
	/datum/admins/proc/sleep_view,
	/datum/admins/proc/wake_view,
	/datum/admins/proc/extend_round,
	)
GLOBAL_LIST_INIT(admin_verbs_ban, list(
	/client/proc/unban_panel,
	/client/proc/ban_panel,
	/client/proc/stickybanpanel,
	/client/proc/check_pq,
	/client/proc/adjust_pq,
	/client/proc/getcurrentlogs,
	/client/proc/getserverlogs
	))
GLOBAL_PROTECT(admin_verbs_ban)
GLOBAL_LIST_INIT(admin_verbs_sounds, list(
	/client/proc/play_local_sound,
	/client/proc/play_local_sound_variable,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound
	))
GLOBAL_PROTECT(admin_verbs_sounds)
GLOBAL_LIST_INIT(admin_verbs_fun, list(
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/set_dynex_scale,
	/client/proc/drop_dynex_bomb,
	/client/proc/cinematic,
//	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/object_say,
	/client/proc/force_say,
	/client/proc/toggle_random_events,
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/forceEvent,
	/client/proc/forceGamemode,
//	/client/proc/admin_change_sec_level,
//	/client/proc/run_weather,
	/client/proc/run_particle_weather,
	/client/proc/manage_fog_schedule,
	/client/proc/run_custom_particle_weather,
	/client/proc/show_tip,
	/client/proc/smite
	))
GLOBAL_PROTECT(admin_verbs_fun)
GLOBAL_LIST_INIT(admin_verbs_spawn, list(/datum/admins/proc/spawn_atom, /datum/admins/proc/podspawn_atom, /client/proc/respawn_character, /datum/admins/proc/beaker_panel))
GLOBAL_PROTECT(admin_verbs_spawn)
GLOBAL_LIST_INIT(admin_verbs_server, world.AVerbsServer())
GLOBAL_PROTECT(admin_verbs_server)
/world/proc/AVerbsServer()
	return list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/end_round,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
//	/client/proc/everyone_random,
//	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
	/client/proc/toggle_random_events,
	/client/proc/forcerandomrotate,
	/client/proc/adminchangemap,
	/client/proc/panicbunker,
	/datum/admins/proc/BC_WhitelistKeyVerb,
	/datum/admins/proc/BC_RemoveKeyVerb,
	/datum/admins/proc/admin_add_donator_verb,
	/datum/admins/proc/admin_remove_donator_verb,
	/client/proc/toggle_hub
	)
GLOBAL_LIST_INIT(admin_verbs_debug, world.AVerbsDebug())
GLOBAL_PROTECT(admin_verbs_debug)
/world/proc/AVerbsDebug()
	return list(
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/restart_controller,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/SDQL2_query,
	/client/proc/test_movable_UI,
	/client/proc/test_snap_UI,
	/client/proc/check_bomb_impacts,
	/client/proc/debug_influences,
	/client/proc/get_dynex_power,		//*debug verbs for dynex explosions.
	/client/proc/get_dynex_range,		//*debug verbs for dynex explosions.
	/client/proc/set_dynex_scale,
	/client/proc/cmd_display_del_log,
	/client/proc/outfit_manager,
	/client/proc/debug_huds,
	/client/proc/map_template_load,
	/client/proc/map_template_upload,
	/client/proc/jump_to_ruin,
	/client/proc/toggle_medal_disable,
	/client/proc/view_runtimes,
	/client/proc/pump_random_event,
	/client/proc/cmd_display_init_log,
	/client/proc/cmd_display_overlay_log,
	/client/proc/reload_configuration,
	/datum/admins/proc/create_or_modify_area,
	/client/proc/returntolobby,
	/client/proc/set_tod_override,
	/client/proc/stresstest_chat,
	/client/proc/performance_stress_test, // Uncomment these if you tick the performance stress test .dm file
	/client/proc/cleanup_stress_test_mobs
	)
GLOBAL_LIST_INIT(admin_verbs_possess, list(/proc/possess, GLOBAL_PROC_REF(release)))
GLOBAL_PROTECT(admin_verbs_possess)
GLOBAL_LIST_INIT(admin_verbs_permissions, list(/client/proc/edit_admin_permissions))
GLOBAL_PROTECT(admin_verbs_permissions)
GLOBAL_LIST_INIT(admin_verbs_poll, list(/client/proc/poll_panel))
GLOBAL_PROTECT(admin_verbs_poll)

//verbs which can be hidden - needs work
GLOBAL_LIST_INIT(admin_verbs_hideable, list(
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/deadmin,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/datum/admins/proc/set_admin_notice,
	/client/proc/toggle_aghost_invis,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/client/proc/cmd_admin_subtle_message,
//	/client/proc/cmd_admin_headset_message,
	/client/proc/cmd_admin_check_contents,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/play_local_sound,
	/client/proc/play_local_sound_variable,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/drop_dynex_bomb,
	/client/proc/get_dynex_range,
	/client/proc/get_dynex_power,
	/client/proc/set_dynex_scale,
	/client/proc/cinematic,
//	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
//	/client/proc/cmd_change_command_name,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
//	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/enable_debug_verbs,
	/proc/possess,
	/proc/release,
	/client/proc/reload_whitelist,
	/client/proc/panicbunker,
//	/client/proc/admin_change_sec_level,
	/client/proc/cmd_display_del_log,
	/client/proc/toggle_combo_hud,
	/client/proc/debug_huds
	))
GLOBAL_PROTECT(admin_verbs_hideable)

/client/proc/add_admin_verbs()
	if(holder)
		control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS

		var/rights = holder.rank.rights
		verbs += GLOB.admin_verbs_default
		if(rights & R_BUILD)
			verbs += /client/proc/togglebuildmodeself
		if(rights & R_ADMIN)
			verbs += GLOB.admin_verbs_admin
		if(rights & R_BAN)
			verbs += GLOB.admin_verbs_ban
		if(rights & R_FUN)
			verbs += GLOB.admin_verbs_fun
		if(rights & R_SERVER)
			verbs += GLOB.admin_verbs_server
		if(rights & R_DEBUG)
			verbs += GLOB.admin_verbs_debug
		if(rights & R_POSSESS)
			verbs += GLOB.admin_verbs_possess
		if(rights & R_PERMISSIONS)
			verbs += GLOB.admin_verbs_permissions
		if(rights & R_STEALTH)
			verbs += /client/proc/stealth
		if(rights & R_ADMIN)
			verbs += GLOB.admin_verbs_poll
		if(rights & R_SOUND)
			verbs += GLOB.admin_verbs_sounds
			if(CONFIG_GET(string/invoke_youtubedl))
				verbs += /client/proc/play_web_sound
		if(rights & R_SPAWN)
			verbs += GLOB.admin_verbs_spawn

/client/proc/remove_admin_verbs()
	verbs.Remove(
		GLOB.admin_verbs_default,
		/client/proc/togglebuildmodeself,
		GLOB.admin_verbs_admin,
		GLOB.admin_verbs_ban,
		GLOB.admin_verbs_fun,
		GLOB.admin_verbs_server,
		GLOB.admin_verbs_debug,
		GLOB.admin_verbs_possess,
		GLOB.admin_verbs_permissions,
		/client/proc/stealth,
		GLOB.admin_verbs_poll,
		GLOB.admin_verbs_sounds,
		/client/proc/play_web_sound,
		GLOB.admin_verbs_spawn,
		/*Debug verbs added by "show debug verbs"*/
		GLOB.admin_verbs_debug_mapping,
		/client/proc/disable_debug_verbs,
		/client/proc/readmin
		)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Prefs - Admin"

	verbs.Remove(/client/proc/hide_most_verbs, GLOB.admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	to_chat(src, span_interface("Most of your adminverbs have been hidden."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Hide Most Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Prefs - Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	to_chat(src, span_interface("Almost all of your adminverbs have been hidden."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Hide All Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Prefs - Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	to_chat(src, span_interface("All of your adminverbs are now visible."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/set_context_menu_enabled()
	set category = "Prefs - Admin"
	set name = "Toggle Context Menu"
	if(!holder)
		return
	show_popup_menus = !show_popup_menus
	to_chat(src, show_popup_menus ? "Right click menus are now enabled" : "Right click menus are now disabled")

/client/proc/open_bounty_menu()
	set category = "-Admin-"
	set name = "View Bounty List"
	if(!holder)
		return
	var/bounty_found = FALSE
	var/consult_menu
	consult_menu += "<center>BOUNTIES<BR>"
	consult_menu += "--------------<BR>"
	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		consult_menu += saved_bounty.banner
		bounty_found = TRUE
	if(bounty_found)
		var/datum/browser/popup = new(mob, "BOUNTIES", "", 500, 300)
		popup.set_content(consult_menu)
		popup.open()
	else
		to_chat(mob, "No bounties are currently active.")

/client/proc/toggle_aghost_invis()
	set category = "Prefs - Admin"
	set name = "Aghost (Toggle Invisibility)"
	if (!holder)
		return
	aghost_toggle = !aghost_toggle
	to_chat(src, aghost_toggle ? "Aghosting will now turn your mob invisible." : "Aghost will no longer turn your mob invisible.")

/client/proc/admin_ghost()
	set category = "-Admin-"
	set name = "Aghost"
	if(!holder)
		return
	. = TRUE
	if(isobserver(mob))
		//re-enter
		var/mob/dead/observer/ghost = mob
		if(!ghost.mind || !ghost.mind.current) //won't do anything if there is no body
			return FALSE
		if(!ghost.can_reenter_corpse)
			log_admin("[key_name(usr)] re-entered corpse")
			message_admins("[key_name_admin(usr)] re-entered corpse")
		if(istype(ghost.mind.current, /mob/living))
			var/mob/living/M = ghost.mind.current
			var/datum/status_effect/incapacitating/sleeping/S = M.IsSleeping()
			if(S && !M.IsKnockdown() && !M.IsStun() && !M.IsParalyzed()) // Wake them up unless they're asleep for another reason
				M.remove_status_effect(S)
				M.set_resting(FALSE, TRUE)
			M.density = initial(M.density)
			M.invisibility = initial(M.invisibility)
		else
			var/mob/M = ghost.mind.current
			M.invisibility = initial(M.invisibility)
			M.density = initial(M.density)
		ghost.can_reenter_corpse = 1 //force re-entering even when otherwise not possible
		ghost.reenter_corpse()
		show_popup_menus = FALSE
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Reenter") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else if(isnewplayer(mob))
//		to_chat(src, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>")
//		return FALSE
		var/mob/dead/new_player/NP = mob
		NP.make_me_an_observer()
	else
		//ghostize
		log_admin("[key_name(usr)] admin ghosted.")
		message_admins("[key_name_admin(usr)] admin ghosted.")
		var/mob/body = mob
		if (aghost_toggle)
			body.invisibility = INVISIBILITY_MAXIMUM
			body.density = 0
		body.ghostize(TRUE, admin = TRUE)
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		show_popup_menus = TRUE
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Ghost") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Prefs - Admin"
	set desc = ""
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			to_chat(mob, span_boldannounce("Invisimin off. Invisibility reset."))
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			to_chat(mob, span_adminnotice("<b>Invisimin on. You are now as invisible as a ghost.</b>"))

/client/proc/check_antagonists()
	set name = "Check Antags"
	set category = "-GameMaster-"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
		if(!isobserver(usr) && SSticker.HasRoundStarted())
			message_admins("[key_name_admin(usr)] checked antagonists.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Check Antagonists") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/set_tod_override()
	set category = "Debug"
	set name = "SetTODOverride"
	var/list/TODs = list("dawn","day","dusk","night")
	var/choice = input(src,"","Set time of day override") as null|anything in TODs
	if(choice)
		GLOB.todoverride = choice
		world << "[ckey] has set the time of day override to [choice]."
	else
		GLOB.todoverride = null
		world << "[ckey] has disabled the time of day override."
	settod()

/client/proc/stresstest_chat()
	set name = "Stress Chat"
	set category = "Debug"
	set hidden = TRUE

	if(!holder)
		return

	var/who = usr
	var/languages = list(
		"human",
		"dwarf",
		"elf",
		"sandspeak",
		"delf",
		"beast",
		"orc",
		//"undead",
		"hellspeak",
		"reptile",
		"lupian",
		//"cat"

	)

	for(var/i = 1; i <= 100; i++)
		for(var/lang in languages)
			to_chat(who, "<span class='say'><span class='name'><span style='color:#ff6600;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>Jorrel</span></span> <span class='message'>says, \"<span class=' [lang] '>This is me speaking [lang].</span>\"</span></span>")


/client/proc/ban_panel()
	set name = "Banning Panel"
	set category = "-Admin-"
	if(!check_rights(R_BAN))
		return
	holder.ban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Banning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/unban_panel()
	set name = "Unbanning Panel"
	set category = "-Admin-"
	if(!check_rights(R_BAN))
		return
	holder.unban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unbanning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "-Admin-"
	if(holder)
		holder.Game()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Game Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/secrets()
	set name = "Secrets"
	set category = "-Admin-"
	set hidden = 1
	if (holder)
		holder.Secrets()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Secrets Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/poll_panel()
	set name = "Server Poll Management"
	set category = "-Server-"
	if(!check_rights(R_POLL))
		return
	holder.poll_list_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Server Poll Management") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in GLOB.stealthminID)
			if(GLOB.stealthminID[P] == txt)
				return P
	txt = GLOB.stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	GLOB.stealthminID["[ckey]"] = "@[num2text(num)]"

/client/proc/stealth()
	set category = "Prefs - Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
			if(isobserver(mob))
				mob.invisibility = initial(mob.invisibility)
				mob.alpha = initial(mob.alpha)
				mob.name = initial(mob.name)
				mob.mouse_opacity = initial(mob.mouse_opacity)
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)
				return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
			createStealthKey()
			if(isobserver(mob))
				mob.invisibility = INVISIBILITY_MAXIMUM //JUST IN CASE
				mob.alpha = 0 //JUUUUST IN CASE
				mob.name = " "
				mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stealth Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_bomb()
	set category = "-GameMaster-"
	set name = "Bomb..."
	set desc = ""

	var/list/choices = list("Small Bomb (1, 2, 3, 3)", "Medium Bomb (2, 3, 4, 4)", "Big Bomb (3, 5, 7, 5)", "Maxcap", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce? NOTE: You can do all this rapidly and in an IC manner (using cruise missiles!) with the Config/Launch Supplypod verb. WARNING: These ignore the maxcap") as null|anything in choices
	var/turf/epicenter = mob.loc

	switch(choice)
		if(null)
			return 0
		if("Small Bomb (1, 2, 3, 3)")
			explosion(epicenter, 1, 2, 3, 3, TRUE, TRUE)
		if("Medium Bomb (2, 3, 4, 4)")
			explosion(epicenter, 2, 3, 4, 4, TRUE, TRUE)
		if("Big Bomb (3, 5, 7, 5)")
			explosion(epicenter, 3, 5, 7, 5, TRUE, TRUE)
		if("Maxcap")
			explosion(epicenter, GLOB.MAX_EX_DEVESTATION_RANGE, GLOB.MAX_EX_HEAVY_RANGE, GLOB.MAX_EX_LIGHT_RANGE, GLOB.MAX_EX_FLASH_RANGE)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as null|num
			if(devastation_range == null)
				return
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as null|num
			if(heavy_impact_range == null)
				return
			var/light_impact_range = input("Light impact range (in tiles):") as null|num
			if(light_impact_range == null)
				return
			var/flash_range = input("Flash range (in tiles):") as null|num
			if(flash_range == null)
				return
			if(devastation_range > GLOB.MAX_EX_DEVESTATION_RANGE || heavy_impact_range > GLOB.MAX_EX_HEAVY_RANGE || light_impact_range > GLOB.MAX_EX_LIGHT_RANGE || flash_range > GLOB.MAX_EX_FLASH_RANGE)
				if(alert("Bomb is bigger than the maxcap. Continue?",,"Yes","No") != "Yes")
					return
			epicenter = mob.loc //We need to reupdate as they may have moved again
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, TRUE, TRUE)
	message_admins("[ADMIN_LOOKUPFLW(usr)] creating an admin explosion at [epicenter.loc].")
	log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_dynex_bomb()
	set category = "-GameMaster-"
	set name = "Bomb - DynEx..."
	set desc = ""

	var/ex_power = input("Explosive Power:") as null|num
	var/turf/epicenter = mob.loc
	if(ex_power && epicenter)
		dyn_explosion(epicenter, ex_power)
		message_admins("[ADMIN_LOOKUPFLW(usr)] creating an admin explosion at [epicenter.loc].")
		log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Dynamic Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_dynex_range()
	set category = "Debug"
	set name = "Get DynEx Range"
	set desc = ""

	var/ex_power = input("Explosive Power:") as null|num
	if (isnull(ex_power))
		return
	var/range = round((2 * ex_power)**GLOB.DYN_EX_SCALE)
	to_chat(usr, "Estimated Explosive Range: (Devastation: [round(range*0.25)], Heavy: [round(range*0.5)], Light: [round(range)])")

/client/proc/get_dynex_power()
	set category = "Debug"
	set name = "Get DynEx Power"
	set desc = ""

	var/ex_range = input("Light Explosion Range:") as null|num
	if (isnull(ex_range))
		return
	var/power = (0.5 * ex_range)**(1/GLOB.DYN_EX_SCALE)
	to_chat(usr, "Estimated Explosive Power: [power]")

/client/proc/set_dynex_scale()
	set category = "Debug"
	set name = "Set DynEx Scale"
	set desc = ""

	var/ex_scale = input("New DynEx Scale:") as null|num
	if(!ex_scale)
		return
	GLOB.DYN_EX_SCALE = ex_scale
	log_admin("[key_name(usr)] has modified Dynamic Explosion Scale: [ex_scale]")
	message_admins("[key_name_admin(usr)] has  modified Dynamic Explosion Scale: [ex_scale]")

/client/proc/give_spell(mob/T in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "Give Spell"
	set desc = ""

	var/list/spell_list = list()
	var/type_length = length("/obj/effect/proc_holder/spell") + 2
	for(var/A in GLOB.spells)
		spell_list[copytext("[A]", type_length)] = A
	var/obj/effect/proc_holder/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in sortList(spell_list)
	if(!S)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins(span_adminnotice("[key_name_admin(usr)] gave [key_name_admin(T)] the spell [S]."))

	S = spell_list[S]
	if(T.mind)
		T.mind.AddSpell(new S)
	else
		T.AddSpell(new S)
		message_admins(span_danger("Spells given to mindless mobs will not be transferred in mindswap or cloning!"))

/client/proc/remove_spell(mob/T in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "Remove Spell"
	set desc = ""

	if(T && T.mind)
		var/obj/effect/proc_holder/spell/S = input("Choose the spell to remove", "NO ABRAKADABRA") as null|anything in sortList(T.mind.spell_list)
		if(S)
			T.mind.RemoveSpell(S)
			log_admin("[key_name(usr)] removed the spell [S] from [key_name(T)].")
			message_admins(span_adminnotice("[key_name_admin(usr)] removed the spell [S] from [key_name_admin(T)]."))
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Remove Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/object_say(obj/O in world)
	set category = "-Special Verbs-"
	set name = "OSay"
	set desc = ""
	var/message = input(usr, "What do you want the message to be?", "Make Sound") as text | null
	if(!message)
		return
	O.say(message)
	log_admin("[key_name(usr)] made [O] at [AREACOORD(O)] say \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(usr)] made [O] at [AREACOORD(O)]. say \"[message]\""))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Object Say") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/force_say(mob/living/L in GLOB.mob_list)
	set category = "-Special Verbs-"
	set name = "Force Speech"
	set desc = ""
	
	if(!L)
		to_chat(usr, span_warning("No mob selected."))
		return
	
	if(!isliving(L))
		to_chat(usr, span_warning("Target must be a living mob."))
		return
	
	if(!L.loc)
		to_chat(usr, span_warning("Target mob has no location."))
		return
	
	var/message = input(usr, "What do you want them to say?", "Force Say") as text | null
	if(!message)
		return
	
	L.say(message)
	log_admin("[key_name(usr)] forced [key_name(L)] at [AREACOORD(L)] to say \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(usr)] forced [key_name_admin(L)] at [AREACOORD(L)] to say \"[message]\""))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Force Say") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode"
	set category = "-Special Verbs-"
	if (!(holder.rank.rights & R_BUILD))
		return
	if(src.mob)
		togglebuildmode(src.mob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Build Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/deadmin()
	set name = "Deadmin"
	set category = "Prefs - Admin"
	set desc = ""

	if(!holder)
		return

	if(has_antag_hud())
		toggle_combo_hud()

	holder.deactivate()

	to_chat(src, span_interface("I are now a normal player."))
	update_ooc_verb_visibility()
	log_admin("[src] deadmined themself.")
	message_admins("[src] deadmined themself.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Deadmin")

/client/proc/readmin()
	set name = "Readmin"
	set category = "-Admin-"
	set desc = ""

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if (!A)
			var/msg = " is trying to readmin but they have no deadmin entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	A.associate(src)

	if (!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, span_interface("I am now an admin."))
	message_admins("[src] re-adminned themselves.")
	log_admin("[src] re-adminned themselves.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Readmin")
	update_ooc_verb_visibility()

/client/proc/toggle_AI_interact()
	set name = "Toggle Admin AI Interact"
	set category = "-Admin-"
	set desc = ""
	set hidden = 1

	AI_Interact = !AI_Interact
	if(mob && IsAdminGhost(mob))
		mob.has_unlimited_silicon_privilege = AI_Interact

	log_admin("[key_name(usr)] has [AI_Interact ? "activated" : "deactivated"] Admin AI Interact")
	message_admins("[key_name_admin(usr)] has [AI_Interact ? "activated" : "deactivated"] their AI interaction")

/client/proc/toggle_lobby_ooc()
	set name = "Show/Hide Lobby OOC"
	set category = "Prefs - Admin"
	set desc = "Toggle seeing lobby OOC messages while not in the lobby."
	if(!holder)
		return
	show_lobby_ooc = !show_lobby_ooc
	to_chat(src, span_interface("Lobby OOC visibility is now [show_lobby_ooc ? "ON" : "OFF"]."))

/client/proc/end_party()
	set category = "-GameMaster-"
	set name = "EndPlaytest"
	set hidden = 1
	if(!holder)
		return
	if(!SSticker.end_party)
		SSticker.end_party=TRUE
		to_chat(src, span_interface("Ending enabled."))
	else
		SSticker.end_party=FALSE
		to_chat(src, span_interface("Ending DISABLED."))

/client/proc/delete_player_book()
	set name = "Database Delete Player Book"
	set category = "Debug"
	set desc = ""
	if(!holder)
		return
	var/player_book = input(src, "What is the book file you want to delete? (spaces and other characters are their url encode versions for the file name, so for example spaces are +)")
	if(player_book)
		SSlibrarian.del_player_book(player_book)
		message_admins("[src] has deleted the player book: [player_book]")
	else
		to_chat(src, span_notice("Either the book file doesn't exist or you have failed to type it in properly (you can look up the file name by the verb 'database book file names'"))

/client/proc/pull_book_file_names()
	set name = "Database Book File Names"
	set category = "Debug"
	set desc = ""
	if(!holder)
		return
	var/list/book_titles = SSlibrarian.pull_player_book_titles()
	if(!book_titles)
		return
	var/dat = ""
	for(var/I in book_titles)
		dat += "[I]<br>"
	src << browse(dat, "window=reading;size=250x500;can_close=1;can_minimize=1;can_maximize=1;can_resize=1;titlebar=1")

/client/proc/amend_player_book()
	set name = "Database Amend Player Book"
	set category = "Debug"
	set desc = ""
	if(!holder)
		return
	var/book_title = input(src, "What is the book file name?")
	var/amend_type = alert(src, "What type of text do you want to amend?", "", "book_title", "author", "icon")
	var/amend_text = input(src, "What do you want to amend it to? (you don't have to make it in the file name format, use normal spaces)")
	if(SSlibrarian.amend_player_book(book_title, amend_type, amend_text))
		message_admins("[src] has amended [book_title]'s [amend_type] to [amend_text]")
	else
		to_chat(src, span_notice("Either the book file doesn't exist or you have failed to type something in properly (you can look up the file name by the verb 'database book file names'"))

/client/proc/remove_bounty()
	set category = "-Admin-"
	set name = "Remove Bounty"
	if(!holder)
		return
	var/list/bounty_list = list()

	for(var/datum/bounty/removable_bounties in GLOB.head_bounties)
		bounty_list += removable_bounties.target

	if(!bounty_list.len)
		to_chat(src, "There are no active bounties to remove.")
		return

	var/target_name = input(src, "Whose name shall be struck from the wanted list?", src) as null|anything in bounty_list
	if(!target_name)
		return

	to_chat(src,"Removing [target_name] from bounty list...")

	for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
		if(removing_bounty.target == target_name)
			GLOB.head_bounties -= removing_bounty
			scom_announce("An unknown force has erased the bounty on [target_name]. The gods are displeased.")
			message_admins("[ADMIN_LOOKUPFLW(src)] has removed the bounty on [ADMIN_LOOKUPFLW(target_name)]")
			return
	to_chat(src, "Error. Bounty no longer active.") 

/client/proc/enable_browser_debug()
	set category = "Debug"
	set name = "Enable Browser Debug"
	if(!holder)
		return

	to_chat(src, "Browser tools are now enabled.")
	winset(src, null, "browser-options=devtools,find,byondstorage")

