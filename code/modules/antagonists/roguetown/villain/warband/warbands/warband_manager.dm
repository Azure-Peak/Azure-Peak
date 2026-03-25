//////////// LOBBY & WARBAND SELECTION
/atom/movable/screen/warband/manager
	name = "BEGIN"
	icon = 'icons/roguetown/hud/warband/warband_hud.dmi'
	icon_state = "begin"
	alpha = 0
	screen_loc = "7.3,8"
	var/list/storyinfluence = list()		// storyteller influences | decides what options are available

	var/list/warbands = list()				// all warbands
	var/list/subtypes = list()				// all subtypes
	var/list/aspects = list()				// all aspects
	var/list/classes = list()				// all warband classes

	var/datum/warbands/selected_warband
	var/datum/warbands/selected_subtype
	var/list/datum/warbands/aspects/selected_aspects = list()

	var/list/members = list()				// players in the warband
	var/list/lobby_members = list()			// players viewing the warband's lobby
	var/list/allies = list()				// players marked as allies
	var/list/importantfigures = list()		// important figures in town | used in the 'know thy enemy' list in the creation menu | helps in plotting an initial gimmick

	var/busy_summoning = FALSE				// active while the warband is polling for ghosts
	var/list/last_action_time = list()		// for rate limits	
	var/spawned_lieutenants = 0				// how many lieutenants have been spawned
	var/warband_ID = 0						// identifying number for the warband |
	var/disorder = 1						// multiplies costs from the campaign planner, disables communication options and Outskirts responses, and determines how many spawns an aspirant steals during a schism | increased by other antagonists being marked as allies
	var/aspirant_chance = 50				// chance that a lieutenant spawns as an aspirant
	var/list/combatmusic = list()			// combat track given to members + people who enter the warcamp/outskirts
	var/finalized = FALSE					// whether or not a warband is finalized
	var/creation_stage = 1  				// 1 = warband selection, 2 = class selection
	var/warlord_spawned = FALSE	
	var/outskirts_established = FALSE		// whether or not the warband has spawned an outskirts map
	var/warcamp_established = FALSE
	var/turf/warband_spawn_turf				// main spawn turf for the warband's characters

	var/spawns = WARBAND_BASE_RESPAWNS		// 400 | lost when an NPC is spawned | combined with spawn contributions from the warband/subtypes/aspects
											// might seem very generous, but this can be reduced in massive chunks by aspirants going rogue & outskirts fights

	var/schism_level = 0					// warbands can split/schism | this number = how many schisms away the warband is from its progenitor warband

	var/datum/territory_faction/linked_faction		// the treaty faction connected to the warband

	var/list/racelocks = list()
	var/list/faithlocks = list()
	var/static_data_set = FALSE

	// outskirts variables
	var/list/incoming_mobs = list()					// this tracks who is attempting to attack the warcamp
	var/list/besieging_mobs = list()				// as above, but those actively in combat
	var/datum/outskirts_encounter/encounter_manager
	var/outskirts_prep_timer

	// time limit for the warband creation phase
	var/creation_time_limit = 15 MINUTES			// total time allowed for creation
	var/creation_warning_threshold = 7.5 MINUTES	// send a warning at this time
	var/warned = FALSE								// if said warning has been sent
	var/creation_start_time = 0
	var/creation_timer_active = FALSE

	var/list/assigned_grunt_cache = list()					// a cache holding pre-equipped goon NPCs
	var/atom/movable/screen/warband/manager/cache_source	// if two opposing warbands have identical grunts, they share an NPC cache | this points to the manager we're sharing with
	var/list/cache_dependents = list()						// list of other managers sharing our cache

	var/list/recycling_bin = list()		// rather than deleting goon NPCs, we'll prefer to send them to a 'recycling bin' where they're healed & re-equipped

////////////////////////////////////////////////////////////
///////////////////////////////////////////////// BASE PROCS
/*
	1 - STORYTELLER REFRESH		// populates the manager's storyinfluence list
	2 - CREATE HUD INSTANCE		// gives someone the HUD icon required to interface with character creation
	3 - VIEW VIP				// examine the flavortext of a mob in Members or Important Figures
	4 - END INTRO				// ends the intro sequence from character creation
	5 - CHOOSE MAP				// choose & spawn the warcamp
	5b - CHOOSE MUSIC			// choose the combat music

	6 - SEND WARNINGS 			// sends warning letters to townsfolk when the warband spawns
	7 - LOCK CHECK 				// checks for race & faithlocks and a character's compliance w/them
	8 - CREATE FACTION 			// creates the faction required to interface w/treaties
	9 - SPAWN WARBAND			// spawns the warband after some final tweaks

	10 - EQUIP CHARACTER		// final step of spawning a character | equips them, sets their traits + adds them to the faction
	11 - SPAWN CHARACTER		// spawn a character w/the options selected from the warband hud
	11b - ASSIGN GRUNT			// binds lieutenants to grunts and vice versa
	12 - RETURN ENVOY			// sends an envoy's client back to their stored character
	13 - SET IDS				// sets the ID of every unregistered warband object
	14 - LINK PORTALS			// called when a warband creates an outskirts map | links together all the portals that got spawned

	15 - SET DEFAULT EXIT		// called when a warcamp spawns | decides the initial exit point for envoys
	16 - CHANGE CHARACTER		// changes the pref character slot
	17 - LOAD CHARACTER			// loads the pref character slot
	18 - STAT WIPE				// performs a full stat & trait wipe on the target mob
	19 - RANDOM CLASSES			// generates 3 random classes for the Wildcard class

	20 - ASPECT TWEAKS
	21 - EXILE					// kicks a character from the warband
	22 - CLEANUP				// combs through the member & ally list for null entries
	23 - DETERMINE SQUAD SIZE	// decide the size of a character's NPC squad

	// lobby timer procs
	24 - LOBBY TIMER			// 

*/


////////////////////////
//////////////////////////////////////////////// INITIALIZING & REFRESHING
////////////////////////

/atom/movable/screen/warband/manager/Initialize()
	..()
	if(!src.finalized)
		src.warbands = SSwarbands.cached_warbands.Copy()
		src.subtypes = SSwarbands.cached_subtypes.Copy()
		src.aspects = SSwarbands.cached_aspects.Copy()
		for(var/class_type in SSwarbands.cached_classes)
			src.classes += SSwarbands.cached_classes[class_type]
		src.classes = sort_list(src.classes)
		storyteller_refresh()
		figure_refresh()

/atom/movable/screen/warband/manager/proc/figure_refresh()
	var/list/important_jobs = list(
		"Grand Duke",
		"Bishop",
		"Consort Dowager",
		"Consort",
		"Hand",
		"Prince",		
		"Marshal",
		"Steward",		
		"Suitor",
		"Knight Captain",
		"Martyr",
		"Guildmaster",
		"Court Magician",
		"Councillor"
	)
	for(var/mob/living/carbon/human/important_figure in GLOB.player_list)
		if(important_jobs.Find(important_figure.job))
			src.importantfigures += important_figure

// 1
///////////////////////////////////////////////////////
/////////////////////////////////// STORYTELLER REFRESH
/* 1
	builds the storyinfluences for warband creation
	takes into account:
		the roundstart storyteller
		the currently active storyteller (only really matters for latespawns)
		each prince has a 50% chance to contribute their patron to the storyteller list
*/
/atom/movable/screen/warband/manager/proc/storyteller_refresh()
	src.storyinfluence.Cut()
	var/active_storyteller = SSgamemode.current_storyteller
	var/roundstart_storyteller_string = SSgamemode.selected_storyteller
	if(active_storyteller)
		src.storyinfluence += active_storyteller

	if(roundstart_storyteller_string)
		src.storyinfluence += new roundstart_storyteller_string()

	for(var/mob/living/carbon/human/deadbeat in src.importantfigures)
		if(deadbeat.job == "Prince" && deadbeat.patron)
			if(prob(50))
				var/datum/patron/prince_patron_datum = deadbeat.patron
				src.storyinfluence += new prince_patron_datum.storyteller()


// 2
///////////////////////////////////////////////////////
/////////////////////////////////// CREATE HUD INSTANCE
/* 2 
	gets the warband associated with the user
	creates an instance of the BEGIN hud (the thing we're using for warband & character creation)
*/
/atom/movable/screen/warband/manager/proc/create_HUD_instance(mob/user)
	for(var/atom/movable/screen/warband/manager/listed_manager in SSwarbands.warband_managers)
		if(listed_manager.warband_ID == user.mind.warband_ID)
			user.client.screen += listed_manager
			animate(listed_manager, alpha = 255, time = 800)
			break

////////////////////////
//////////////////////////////////////////////// INITIALIZING & REFRESHING
////////////////////////



////////////////////////
//////////////////////////////////////////////// UI DATA
////////////////////////
/atom/movable/screen/warband/manager/Click()
	src.ui_interact(usr)

/atom/movable/screen/warband/manager/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WarbandCreation")
		ui.open()


/atom/movable/screen/warband/manager/ui_data(mob/user)
	var/list/data = ..()

	var/finalized_status = src.finalized
	var/user_role = user.mind.special_role
	var/list/noble_list = list()
	var/list/allies_list = list()

	data["creation_stage"] = src.creation_stage
	data["warlord_spawned"] = src.warlord_spawned
	data["is_warlord"] = (user_role == "Warlord")
	data["user_role"] = user_role
	data["finalized_status"] = finalized_status

	var/remaining_time = get_remaining_time()
	if(remaining_time >= 0)
		data["time_remaining"] = remaining_time
		data["timer_active"] = TRUE
	else
		data["time_remaining"] = 0
		data["timer_active"] = FALSE

	for(var/mob/living/carbon/human/quote_importantperson_unquote in src.importantfigures)
		UNTYPED_LIST_ADD(noble_list, list(
			"name" = quote_importantperson_unquote.real_name,
			"job" = quote_importantperson_unquote.job
		))
	data["nobles"] = noble_list

	for(var/mob/living/carbon/human/buddy in src.members)	
		var/member_role = buddy.mind?.special_role || "Unknown"
		UNTYPED_LIST_ADD(allies_list, list(
			"name" = buddy.real_name,
			"job" = buddy.job,
			"special_role" = member_role,
			"in_lobby" = FALSE
		))

	for(var/mob/living/lobby_member in src.lobby_members)
		if(!lobby_member.client || !lobby_member.client.prefs)
			continue
		var/char_name = lobby_member.client.prefs.real_name
		var/member_role = lobby_member.mind?.special_role || "Unknown"
		UNTYPED_LIST_ADD(allies_list, list(
			"name" = char_name,
			"job" = member_role,
			"in_lobby" = TRUE
		))
	data["allies"] = allies_list	
	return data

/atom/movable/screen/warband/manager/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/storyteller_list = list()

	var/list/warbands_list = list()
	var/list/subtypes_list = list()
	var/list/aspects_list = list()

	var/list/class_list = list()

	var/list/backend_warband_list = list()
	var/list/backend_subtype_list = list()
	var/list/backend_aspects_list = list()

	if(src.selected_warband)
		UNTYPED_LIST_ADD(backend_warband_list, list(
			"title" = selected_warband.title,
			"summary" = selected_warband.summary,
			"storyinfluence" = selected_warband.storytellerlimit,
			"subtyperequired" = selected_warband.subtyperequired,
			"rarity" = selected_warband.rarity,
			"subtypes" = selected_warband.subtypes,
			"aspects" = selected_warband.aspects,
			"points" = selected_warband.points,
			"type" = selected_warband.type,
			"warlordclasses" = selected_warband.warlordclasses,
			"lieuclasses" = selected_warband.lieutenantclasses,
			"gruntclasses" = selected_warband.gruntclasses
		))
	data["backend_warband"] = backend_warband_list

	if(src.selected_subtype)
		UNTYPED_LIST_ADD(backend_subtype_list, list(
			"title" = selected_subtype.title,
			"summary" = selected_subtype.summary,
			"storyinfluence" = selected_subtype.storytellerlimit,
			"rarity" = selected_subtype.rarity,
			"aspects" = selected_subtype.aspects,
			"points" = selected_subtype.points,
			"type" = selected_subtype.type,
			"warlordclasses" = selected_subtype.warlordclasses,
			"lieuclasses" = selected_subtype.lieutenantclasses,
			"gruntclasses" = selected_subtype.gruntclasses
		))
	data["backend_subtype"] = backend_subtype_list

	for(var/datum/warbands/aspects/selected_aspect in src.selected_aspects)
		UNTYPED_LIST_ADD(backend_aspects_list, list(
			"title" = selected_aspect.title,
			"summary" = selected_aspect.summary,
			"storyinfluence" = selected_aspect.storytellerlimit,
			"rarity" = selected_aspect.rarity,
			"class" = selected_aspect.asclass,
			"points" = selected_aspect.points,
			"type" = selected_aspect.type,
			"warlordclasses" = selected_aspect.warlordclasses,
			"lieuclasses" = selected_aspect.lieutenantclasses,
			"gruntclasses" = selected_aspect.gruntclasses
		))
	data["backend_aspects"] = backend_aspects_list

	if(!static_data_set)
		for(var/datum/storyteller/storyteller in src.storyinfluence)
			UNTYPED_LIST_ADD(storyteller_list, list(
				"title" = storyteller.name,
				"summary" = storyteller.desc,
				"type" = storyteller.type
			))
	data["backendstorytellers"] = storyteller_list

	for(var/datum/warbands/warband in src.warbands)
		UNTYPED_LIST_ADD(warbands_list, list(
			"title" = warband.title,
			"summary" = warband.summary,
			"storyinfluence" = warband.storytellerlimit,
			"subtyperequired" = warband.subtyperequired,
			"rarity" = warband.rarity,			
			"subtypes" = warband.subtypes,
			"aspects" = warband.aspects,
			"points" = warband.points,
			"type" = warband.type,
			"warlordclasses" = warband.warlordclasses,
			"lieuclasses" = warband.lieutenantclasses,
			"gruntclasses" = warband.gruntclasses
		))
	data["warbands"] = warbands_list

	for(var/datum/warbands/subtypes/subtype in src.subtypes)
		UNTYPED_LIST_ADD(subtypes_list, list(
			"title" = subtype.title,
			"summary" = subtype.summary,
			"storyinfluence" = subtype.storytellerlimit,
			"rarity" = subtype.rarity,
			"aspects" = subtype.aspects,
			"points" = subtype.points,
			"type" = subtype.type,
			"quote" = subtype.quote,
			"quote_followup" = subtype.quote_followup,
			"warlordclasses" = subtype.warlordclasses,
			"lieuclasses" = subtype.lieutenantclasses,
			"gruntclasses" = subtype.gruntclasses
		))
	data["subtypes"] = subtypes_list

	for(var/datum/warbands/aspects/aspect in src.aspects)
		UNTYPED_LIST_ADD(aspects_list, list(
			"title" = aspect.title,
			"summary" = aspect.summary,
			"storyinfluence" = aspect.storytellerlimit,
			"rarity" = aspect.rarity,
			"class" = aspect.asclass,
			"points" = aspect.points,
			"type" = aspect.type,
			"warlordclasses" = aspect.warlordclasses,
			"lieuclasses" = aspect.lieutenantclasses,
			"gruntclasses" = aspect.gruntclasses
		))
	data["aspects"] = aspects_list

	for(var/datum/advclass/class in src.classes)
		UNTYPED_LIST_ADD(class_list, list(
			"name" = class.title,
			"desc" = class.tutorial,
			"alt_name" = class.name,
			"storyinfluence" = class.storytellerlimit,
			"rarity" = class.rarity,
			"slots" = class.maximum_possible_slots,
			"type" = class.type
		))
	data["classes"] = class_list

	src.static_data_set = TRUE

	return data


/atom/movable/screen/warband/manager/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr

	var/user_key = user.ckey
	if(last_action_time[user_key] && world.time < last_action_time[user_key] + 10)
		return TRUE
	
	last_action_time[user_key] = world.time

	switch(action)
		if("swap_character_slot")
			use_character_appearance(user)
		if("refresh")
			update_static_data(user, ui)
		if("edit_character")
			user.client.prefs.current_tab = 1
			user.client.prefs.ShowChoices(usr, 4)
		if("create_character")
			if(user.mind.special_role == "Warlord")
				to_chat(user, span_warning("Use the finalize button to complete your warband."))
				return
			if(!src.warlord_spawned)
				to_chat(user, span_warning("Wait for the Warlord to finalize first."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			SStgui.close_user_uis(user)
			user.mind.warband_manager = src
			var/class_path = text2path(params["class"])
			var/subclass_path = text2path(params["subclass"])
			if(user in src.lobby_members)
				lobby_members -= user
			create_character(user, user)
			lock_check(user)
			var/latespawn = user.mind.warband_latespawn
			spawn_character(class_path, user, subclass_path, is_leader = 0, is_latespawn = latespawn)
			end_intro(user)
			return
		if("advance_stage")
			if(user.mind.special_role != "Warlord")
				to_chat(user, span_warning("Only the Warlord can advance stages."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			if(src.creation_stage != 1)
				return
			
			var/warband_path = text2path(params["warband"])
			if(warband_path && SSwarbands.warband_lookup[warband_path])
				src.selected_warband = SSwarbands.warband_lookup[warband_path]
			var/subtype_path = text2path(params["subtype"])
			if(subtype_path && SSwarbands.subtype_lookup[subtype_path])
				src.selected_subtype = SSwarbands.subtype_lookup[subtype_path]
			var/list/aspect_paths = params["aspects"]
			for(var/aspect_path in aspect_paths)
				var/aspect_type = text2path(aspect_path)
				if(aspect_type && SSwarbands.aspect_lookup[aspect_type])
					src.selected_aspects += SSwarbands.aspect_lookup[aspect_type]

			src.creation_stage = 2
			envy_check() // check for Throne of Envy once a warband is locked in, so we can update any lieutenants
			set_race_and_faith_locks()
			notify_sect()
			send_warnings() // send a warning to a non-warband player
			for(var/mob/living/carbon/human/member in src.lobby_members)
				to_chat(member, span_greenteamradio("The Warlord has advanced to class selection. You may now choose your class."))
				SStgui.update_uis(member)
				update_static_data(member)
			return

		if("create_warband")
			if(user.mind.special_role != "Warlord")
				to_chat(user, span_warning("Only the Warlord may finalize the warband."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			if(src.creation_stage != 2)
				to_chat(user, span_warning("Select a Warband first."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			if(SSwarbands.warband_managers_busy == TRUE)
				to_chat(src, span_bold("Warband Generation is occupied. Please wait."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			SSwarbands.warband_managers_busy = TRUE
			SStgui.close_user_uis(user)
			var/class_path = text2path(params["class"])
			var/subclass_path = text2path(params["subclass"])
			if(user in src.lobby_members)
				lobby_members -= user
			create_character(user, user)
			lock_check(user)
			apply_sect_faithlock(user)
			spawn_warband(user)
			set_IDs()
			spawn_character(class_path, user, subclass_path, is_leader = 1)			
			set_default_exit()
			
			src.warlord_spawned = TRUE
			SSwarbands.warband_managers_busy = FALSE
			src.finalized = TRUE
			user.mind.warband_manager = src
			end_intro(user)
			for(var/mob/living/carbon/human/member in src.lobby_members) 
				if(member.mind.special_role == "Lieutenant" || member.mind.special_role == "Aspirant Lieutenant" || member.mind.special_role == "Grunt")
					to_chat(member, span_greenteamradio("The Warlord has established the warband. You may now finalize your character."))
					member.playsound_local(member, 'sound/misc/warband/menusound3.ogg', 100, FALSE)
			return
		if("interaction_sound")
			user.playsound_local(user, 'sound/misc/warband/menusound1.ogg', 100, FALSE)
			return

		if("view_laws")
			to_chat(user, span_greenteamradio("AZURIA'S LAWS ARE AS FOLLOWS:"))
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
			for(var/law in GLOB.laws_of_the_land)
				to_chat(user, span_memo(law))
			return

		if("view_decrees")
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
			for(var/decree in GLOB.lord_decrees)
				to_chat(user, span_memo(decree))
			return

// 3
////////////////////////////////////////////
/////////////////////////////////// VIEW VIP
/* 3
	views the flavortext of a given character
*/
		if("view_vip")
			var/returned_vip = params["enemy"]
			var/returned_ally = params["ally"]

			var/mob/living/carbon/human/matched_vip

			for(var/mob/living/carbon/human/vip in src.importantfigures)
				if(vip.real_name == returned_vip)
					matched_vip = vip
					break
			for(var/mob/living/carbon/human/pal in src.members)
				if(pal.real_name == returned_ally)
					matched_vip = pal
					break

			if(matched_vip)
				if(!ismob(usr))
					return
				var/datum/examine_panel/mob_examine_panel = new(matched_vip)
				mob_examine_panel.holder = matched_vip
				mob_examine_panel.viewing = usr
				mob_examine_panel.ui_interact(usr)
				return
			else
				return




/atom/movable/screen/warband/manager/ui_close(mob/user, datum/tgui/ui)
	. = ..()

/atom/movable/screen/warband/manager/ui_status(mob/user)
	if(user)
		return UI_INTERACTIVE
	return ..()

////////////////////////
//////////////////////////////////////////////// UI DATA
////////////////////////


//////////////////////
////////////////////////////////////////////// SPAWNING
//////////////////////

// 4
/////////////////////////////////////////////
/////////////////////////////////// END INTRO
/* 4
	fades the intro text from the client's screen
	removes the "BEGIN" text from the client's screen
	heals the loaded character to clear the stun & blindness
	makes them visible
*/
/atom/movable/screen/warband/manager/proc/end_intro(mob/living/user)
	if(!user || !user.client)
		return
	for(var/atom/movable/screen/warband/manager/loaded_manager in user.client.screen)
		user.client.screen -= loaded_manager
	user.mind.warbandsetup = FALSE
	user.invisibility = INVISIBILITY_NONE
	user.fully_heal()
	SEND_SOUND(user, sound(null)) // cuts the selection music
	user.playsound_local(user, 'sound/misc/warband/warband_warhorn3.ogg', 100, FALSE, pressure_affected = FALSE)
	for(var/atom/movable/screen/introtext/text in user.client.screen)
		animate(text, alpha = 0, time = 50)
		addtimer(CALLBACK(src, PROC_REF(remove_intro), user.client, text), 5 SECONDS)

/atom/movable/screen/warband/manager/proc/remove_intro(client/user, atom/movable/screen/introtext/text)
	if(user)
		user.screen -= text
	qdel(text)

//////////////////////
//////////////////////
//////////////////////



//////////////////////
//////////////////////
//////////////////////



// 5
//////////////////////////////////////////////
/////////////////////////////////// CHOOSE MAP
/* 5
	selects & spawns a map
	prioritizes a choice from an aspect or subtype before falling back on the warband map
*/
/atom/movable/screen/warband/manager/proc/choose_map(latespawn = FALSE)
	var/datum/map_template/warcamp_template_type

	if(selected_aspects)
		for(var/datum/warbands/aspects/aspect in src.selected_aspects)
			if(aspect.warcamp)
				warcamp_template_type = aspect.warcamp
				break
	if(!warcamp_template_type && selected_subtype && selected_subtype.warcamp)
		warcamp_template_type = selected_subtype.warcamp
	if(!warcamp_template_type && selected_warband && selected_warband.warcamp)
		warcamp_template_type = selected_warband.warcamp

	var/warcamp_key = SSwarbands.get_warcamp(warcamp_template_type)

	
	if(!warcamp_key)
		return FALSE
		
	var/datum/map_template/chosenmap = SSwarbands.get_cached_template(TEMPLATE_WARCAMP, warcamp_key)
	
	if(!chosenmap)
		return FALSE

	for(var/obj/effect/landmark/warcamp/warcamp_landmark in GLOB.landmarks_list)
		var/list/bounds = chosenmap.load(warcamp_landmark.loc, centered = TRUE)
		
		if(!bounds)
			qdel(warcamp_landmark)
			return FALSE
		qdel(warcamp_landmark)
		src.warcamp_established = TRUE
		break

	if(latespawn == TRUE)
		for(var/obj/effect/landmark/start/warlordlate/warlord_spawn in GLOB.landmarks_list)
			qdel(warlord_spawn)
			break
	return TRUE

// 5b
//////////////////////////////////////////////
/////////////////////////////////// CHOOSE MUSIC
/* 5b
	same process as map selection, but for music
*/

/atom/movable/screen/warband/manager/proc/choose_combat_music()
	var/chosen_combatmusic
	if(src.selected_aspects)
		for(var/datum/warbands/aspects/aspect in src.selected_aspects)
			if(aspect.combatmusic.len)
				chosen_combatmusic = aspect.combatmusic
				break

	if(!chosen_combatmusic)
		if(selected_subtype && selected_subtype.combatmusic)
			chosen_combatmusic = selected_subtype.combatmusic

	if(!chosen_combatmusic)
		if(selected_warband && selected_warband.combatmusic)
			chosen_combatmusic = selected_warband.combatmusic

	if(!chosen_combatmusic)
		return

	if(chosen_combatmusic)
		src.combatmusic = chosen_combatmusic
		return

//////////////////////
//////////////////////
//////////////////////

// 6
/////////////////////////////////////////////////
/////////////////////////////////// SEND WARNINGS
/* 6
	creates a list of people from GLOB.player_list
		a warning letter is created and sent out
		the chance of reception varies depending on each person's job

	1 is chosen to receive a warning letter containing information on:
		the main warband type 
		any subtype
		any selected aspects

	cancels immediately if the spawning Warband has taken the "Surprise" aspect

*/
/atom/movable/screen/warband/manager/proc/send_warnings()
	var/atom/movable/screen/warband/manager/incoming_warband = src
	for(var/datum/warbands/aspects/chosen_aspect in incoming_warband.selected_aspects)
		if(istype(chosen_aspect, /datum/warbands/aspects/surprise))
			return // if the incoming warband has the Surprise aspect, no one's getting warned

	// most likely roles to be chosen to receive the warning
	var/list/most_likely = list(
		"Hand",
		"Councillor",
		"Inquisitor",
		"Marshal",
		"Towner",
		"Soilson",
	) 

	var/mob/living/carbon/human/recipient
	var/list/priority_candidates = list()
	var/list/general_candidates = list()

	// roles in this list are blacklisted from being warned
	var/list/warband_roles = list("Warlord", "Aspirant Lieutenant", "Lieutenant", "Grunt")
	for(var/mob/living/carbon/human/candidate in GLOB.player_list)
		if(candidate.stat == DEAD || !candidate.client)
			continue
		if(candidate.mind && (candidate.mind.special_role in warband_roles))
			continue
		var/turf/T = get_turf(candidate)
		if(!T || !istype(T.loc, /area/rogue/outdoors))
			continue // skip candidates who aren't outside
		if(candidate.job in most_likely)
			priority_candidates += candidate
		else
			general_candidates += candidate

	if(!priority_candidates.len && !general_candidates.len)
		return // if no one's outside, no warning is getting sent
	
	// 75% chance to choose a likely candidate, 25% chance for anyone
	if(prob(75) && priority_candidates.len)
		recipient = pick(priority_candidates)
	else if(general_candidates.len)
		recipient = pick(general_candidates)
	else if(priority_candidates.len)
		recipient = pick(priority_candidates)

	if(!recipient)
		return

	var/final_readout = "Terrible news has been hastily scrawled upon old, torn parchment. It warns...<BR>\n"
	if(incoming_warband.selected_warband && incoming_warband.selected_warband.warning)
		final_readout += "<BR>\n[incoming_warband.selected_warband.warning]"
	if(incoming_warband.selected_subtype && incoming_warband.selected_subtype.warning)
		final_readout += "<BR>\n[incoming_warband.selected_subtype.warning]"
	for(var/datum/warbands/aspects/chosenaspect in incoming_warband.selected_aspects)
		if(chosenaspect && chosenaspect.warning)
			final_readout += "<BR>\n[chosenaspect.warning]"

	var/obj/item/paper/warband_warning/newparchment = new /obj/item/paper/warband_warning(recipient.loc)
	newparchment.info = final_readout
	to_chat(recipient, span_warning("Something crunches underfoot. I've stepped on a crumpled, blood-stained heap of parchment.")) 

	recipient.playsound_local(recipient, 'sound/villain/littlescary.ogg', 100, FALSE)

/obj/item/paper/warband_warning
	name = "hastily-written parchment"

//////////////////////
//////////////////////
//////////////////////


// 7
//////////////////////////////////////////////
/////////////////////////////////// LOCK CHECK
/* 7 
	checks for any patron & or faith locks
	if the given mob doesn't match them, fixes the discrepancy
*/
/atom/movable/screen/warband/manager/proc/lock_check(mob/living/carbon/human/user)
	if(src.racelocks && src.racelocks.len)
		var/user_species_type = user.dna?.species?.type
		var/species_allowed = FALSE
		
		for(var/allowed_species in src.racelocks)
			if(ispath(user_species_type, allowed_species))
				species_allowed = TRUE
				break
		
		if(!species_allowed)
			var/new_species = pick(src.racelocks)
			user.set_species(new_species)
			to_chat(user, span_warning("Your character's species has been adjusted to match the warband's requirements."))

	if(src.faithlocks && src.faithlocks.len)
		var/patron_allowed = FALSE
		if(user.patron)
			for(var/allowed_patron in src.faithlocks)
				if(ispath(user.patron.type, allowed_patron))
					patron_allowed = TRUE
					break
		if(!patron_allowed)
			var/new_patron = pick(src.faithlocks)
			user.set_patron(new_patron)
			to_chat(user, span_warning("Your character's patron has been adjusted to match the warband's requirements."))
		else
			user.set_patron(user.patron.type)
	else
		user.set_patron(user.patron.type) // no faithlocks, just reapply current patron to restore traits after the statwipe
	return

// 7b
/////////////////////////////////////////////////
/////////////////////////////////// COLLECT LOCKS
/* 7b
	collects all race and faith locks from the selected warband, subtype, and aspects
	stores them in the manager's racelocks and faithlocks lists
	called during warband creation before characters are spawned
*/
/atom/movable/screen/warband/manager/proc/set_race_and_faith_locks()
	src.racelocks = list()
	src.faithlocks = list()
	
	if(src.selected_warband)
		if(src.selected_warband.racelock && src.selected_warband.racelock.len)
			for(var/race in src.selected_warband.racelock)
				if(!(race in src.racelocks))
					src.racelocks += race
		
		if(src.selected_warband.faithlock && src.selected_warband.faithlock.len)
			for(var/faith in src.selected_warband.faithlock)
				if(!(faith in src.faithlocks))
					src.faithlocks += faith
	
	if(src.selected_subtype)
		if(src.selected_subtype.racelock && src.selected_subtype.racelock.len)
			for(var/race in src.selected_subtype.racelock)
				if(!(race in src.racelocks))
					src.racelocks += race
		
		if(src.selected_subtype.faithlock && src.selected_subtype.faithlock.len)
			for(var/faith in src.selected_subtype.faithlock)
				if(!(faith in src.faithlocks))
					src.faithlocks += faith
	

	if(src.selected_aspects.len)
		for(var/datum/warbands/aspects/aspect in src.selected_aspects)
			if(aspect.racelock && aspect.racelock.len)
				for(var/race in aspect.racelock)
					if(!(race in src.racelocks))
						src.racelocks += race
			
			if(aspect.faithlock && aspect.faithlock.len)
				for(var/faith in aspect.faithlock)
					if(!(faith in src.faithlocks))
						src.faithlocks += faith
	
	// notify lobby members of any restrictions
	if(src.racelocks.len || src.faithlocks.len)
		var/lock_message = span_bold("<span style='color:#e8bf67'>WARBAND RESTRICTIONS:</span> ")
		
		if(src.racelocks.len)
			var/list/race_names = list()
			for(var/race_type in src.racelocks)
				var/datum/species/temp_species = new race_type()
				race_names += temp_species.name
				qdel(temp_species)
			
			lock_message += "Species limited to: [race_names.Join(", ")]"
		
		if(src.faithlocks.len)
			if(src.racelocks.len)
				lock_message += " | "
			
			var/list/faith_names = list()
			for(var/faith_type in src.faithlocks)
				var/datum/patron/temp_patron = new faith_type()
				faith_names += temp_patron.name
				qdel(temp_patron)
			lock_message += "Faith limited to: [faith_names.Join(", ")]"
		lock_message += ". Your character will be adjusted if necessary."
		for(var/mob/living/member in src.lobby_members)
			to_chat(member, lock_message)
			member.playsound_local(member, 'sound/misc/notice (2).ogg', 100, FALSE)
	
	return

// 7c
///////////////////////////////////////////////
/////////////////////////////////// NOTIFY SECT
/* 7c

*/
/atom/movable/screen/warband/manager/proc/notify_sect()
	if(!istype(src.selected_warband, /datum/warbands/sect))
		return

	for(var/mob/living/member in src.lobby_members)
		to_chat(member, "<span style='color:#e8bf67'>SECT RESTRICTION:</span> Once the Warlord finalizes, all members will be faithlocked to the Warlord's chosen patron.")
		member.playsound_local(member, 'sound/misc/notice (2).ogg', 100, FALSE)
	return


// 7d
////////////////////////////////////////////////////////
/////////////////////////////////// APPLY SECT FAITHLOCK
/* 7d
	after a Sect Warlord spawns, updates the faithlock to match the warlord's specific patron
*/
/atom/movable/screen/warband/manager/proc/apply_sect_faithlock(mob/living/carbon/human/warlord)
	if(!istype(src.selected_warband, /datum/warbands/sect))
		return

	// verify the warlord's patron is within the allowed faithlocks from the subtype
	var/patron_allowed = FALSE
	if(src.faithlocks.len)
		for(var/allowed_patron in src.faithlocks)
			if(ispath(warlord.patron.type, allowed_patron))
				patron_allowed = TRUE
				break
	
	if(!patron_allowed && src.faithlocks.len)
		var/new_patron = pick(src.faithlocks)
		warlord.set_patron(new_patron)
		to_chat(warlord, span_warning("Your patron has been adjusted to match the sect's requirements."))
	
	src.faithlocks = list(warlord.patron.type)
	var/patron_name = warlord.patron.name
	for(var/mob/living/member in src.lobby_members)
		to_chat(member, span_boldwarning("<span style='color:#e8bf67'>SECT FAITHLOCK APPLIED:</span> All characters are now required to serve <span style='color:#e8bf67'>[patron_name].</span>"))
		member.playsound_local(member, 'sound/misc/notice (2).ogg', 100, FALSE)
	
	return

// 8
//////////////////////////////////////////////////////////
/////////////////////////////////// CHOOSE WARBAND FACTION
/* 8
	generate a faction for dealing w/treaties
	receives the faction & initial territory's name from the selected warband & subtype datums
*/
/atom/movable/screen/warband/manager/proc/choose_warband_faction(owner)
	var/chosen_name
	var/chosen_desc
	var/land_name
	var/land_desc
	var/datum/territory_faction/new_faction = new /datum/territory_faction/custom

	if(selected_subtype) // look for a subtype first
		if(selected_subtype.treaty_name != "Warband")
			chosen_name = selected_subtype.treaty_name
		if(selected_subtype.treaty_desc != "Azuria bears no shortage of enemies.")
			chosen_desc = selected_subtype.treaty_desc

		if(selected_subtype.territory_name != "Unknown Territory")
			land_name = selected_subtype.territory_name
		if(selected_subtype.territory_desc != "")
			land_desc = selected_subtype.territory_desc

	if(!chosen_name) // if there's no subtype, fall back on the warband's descriptions
		chosen_name = selected_warband.treaty_name
	if(!chosen_desc)
		chosen_desc = selected_warband.treaty_desc

	if(!land_name)
		land_name = selected_warband.territory_name
	if(!land_desc)
		land_desc = selected_warband.territory_desc

	var/returned_faction = new_faction.generate_faction(owner, chosen_name, chosen_desc, land_name, land_desc, TRUE)
	return returned_faction

// 9
/////////////////////////////////////////////////
/////////////////////////////////// SPAWN WARBAND
/* 9
	chooses variables with priority & spawns the final result
	for example, a map provided from an aspect is prioritized over one from a subtype, and a subtype map's prioritized over the base warband's map
*/
/atom/movable/screen/warband/manager/proc/spawn_warband(mob/user, rebellion = FALSE)
	if(rebellion == FALSE)
		choose_map()
	stop_creation_timer()
	choose_combat_music()
	aspect_tweaks(user)
	for(var/atom/movable/screen/warband/manager/other_manager in SSwarbands.warband_managers)
		if(other_manager == src)
			continue
		if(other_manager.finalized && has_compatible_cache(other_manager))
			share_cache_with(other_manager)
			break
	initialize_outskirts_encounter()
	src.linked_faction = choose_warband_faction(user)
	src.linked_faction.member_names += user.real_name
	src.finalized = TRUE

// 10
///////////////////////////////////////////////////
/////////////////////////////////// EQUIP CHARACTER
/* 10
	equips them w/the provided advclasses
	gives them the baseline Warband traits (at the moment Battle Ready & No XP)
	makes any aspect tweaks to their stats

*/
/atom/movable/screen/warband/manager/proc/equip_character(datum/advclass/class_path, datum/advclass/subclass_path, isleader, mob/living/carbon/human/user)
	user.cmode_music_override = src.combatmusic
	user.advjob = class_path.name
	class_path.equipme(user)
	user.job = class_path.name
	if(subclass_path)
		subclass_path.equipme(user)
		user.job = subclass_path.name
	if(isleader)
		var/is_figurehead = FALSE
		for(var/datum/warbands/aspects/found_aspect in src.selected_aspects)
			if(istype(found_aspect, ASPECT_FIGUREHEAD))
				is_figurehead = TRUE
				break
		if(is_figurehead)
			if(user.mind)
				for(var/obj/effect/proc_holder/spell/sweep_spell in user.mind.spell_list)
					if(sweep_spell.name == "Sweep")
						user.mind.RemoveSpell(sweep_spell)
				if(user.actions)
					for(var/datum/action/spell_action/sweepaction in user.actions)
						if(sweepaction.name == "Sweep")
							qdel(sweepaction)
			// STR: 8 | SPD: 10 | CON: 10
			if(user.STASTR > 8)
				user.STASTR = 8
			if(user.STASPD > 10)
				user.STASPD = 10
			if(user.STACON > 10)
				user.STACON = 10
	else
		if(src.linked_faction) // if they aren't the warlord we'll need to add them as a member of the linked faction
			src.linked_faction.member_names += user.real_name
			if(!(src.linked_faction in user.mind.associated_factions))
				user.mind.associated_factions += src.linked_faction
			if(user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant")// and if they're a lieutenant we also give them one of their own
				var/datum/territory_faction/lieu_faction = new /datum/territory_faction()
				lieu_faction.generate_faction(user, stewardhidden = TRUE)
				user.mind.associated_factions |= lieu_faction
	user.faction |= list("[user.real_name]_faction")
	ADD_TRAIT(user, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NO_XP, TRAIT_GENERIC) // we want them doing Literally Anything Else besides farming for skills | this should actually be the case for everyone but we'll never be ready for that conversation
	determine_squad_size(user)

// 11c
//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ASSIGN GRUNT
/* 11c
	binds lieutenants to grunts and vice versa, depending on the provided arguments
	
	MODES:
	1. lieutenant provided: when a lieutenant spawns, collect all unassigned grunts. add them to the mind.subordinates list
	2. grunt provided: when a grunt spawns, find them a lieutenant. add their name to the grunt's mind.warband_recruiter_name entry, and adds themselves to the lieutenant's mind
	
*///
/atom/movable/screen/warband/manager/proc/assign_grunt(mob/living/carbon/human/lieutenant = null, mob/living/carbon/human/grunt = null)
	// 1: lieutenant spawns
	if(lieutenant && !grunt)
		if(!lieutenant.mind)
			return
		
		if(lieutenant.mind.special_role != "Lieutenant" && lieutenant.mind.special_role != "Aspirant Lieutenant")
			return

		var/list/unassigned_grunts = list()
		for(var/mob/living/carbon/human/member in src.members)
			if(!member.mind)
				continue
			if(member.mind.special_role == "Grunt" && !member.mind.warband_recruiter_name)
				unassigned_grunts += member
		if(!unassigned_grunts.len)
			to_chat(lieutenant, span_greenteamradio("My subordinates are yet to arrive."))
			return
		
		var/assigned_count = 0
		for(var/mob/living/carbon/human/waiting_grunt in unassigned_grunts)
			if(assigned_count >= 2)  // Maximum 2 grunts per lieutenant
				break
			
			lieutenant.mind.subordinates += waiting_grunt
			waiting_grunt.mind.warband_recruiter_name = lieutenant.real_name
			to_chat(waiting_grunt, span_greenteamradio("My Lieutenant, [lieutenant.real_name], has arrived."))
			to_chat(lieutenant, span_greenteamradio("[waiting_grunt.real_name] is my subordinate."))
			assigned_count++
		return
	
	// MODE 2: grunt spawns
	if(grunt && !lieutenant)
		if(!grunt.mind || grunt.mind.special_role != "Grunt")
			return
		var/list/available_lieutenants = list()
		for(var/mob/living/carbon/human/member in src.members)
			if(!member.mind)
				continue
			if(member.mind.special_role == "Lieutenant" || member.mind.special_role == "Aspirant Lieutenant")
				if(member.mind.subordinates.len < 2)
					available_lieutenants += member
		
		if(!available_lieutenants.len)
			to_chat(grunt, span_greenteamradio("My Lieutenant is yet to arrive."))
			return

		var/mob/living/carbon/human/chosen_lieutenant
		var/lowest_count = 999

		for(var/mob/living/carbon/human/lieu in available_lieutenants)
			var/current_count = lieu.mind.subordinates.len
			if(current_count < lowest_count)
				lowest_count = current_count
				chosen_lieutenant = lieu
		
		if(chosen_lieutenant)
			chosen_lieutenant.mind.subordinates += grunt
			grunt.mind.warband_recruiter_name = chosen_lieutenant.real_name
			to_chat(grunt, span_greenteamradio("[chosen_lieutenant.real_name] is my Lieutenant."))
			to_chat(chosen_lieutenant, span_greenteamradio("[grunt.real_name], my subordinate, has arrived."))
		return

	return

// 11
///////////////////////////////////////////////////
/////////////////////////////////// SPAWN CHARACTER
/* 11
	if they're the warlord, move them to their warcamp's warlord spawn landmark, then delete said landmark
		adds them to the warband manager's members list
		gives them:
			knowledge of other members in the warband
			knowledge of important figures in the duchy
			the baseline warband verbs (shortcut & communicate)
*/
/atom/movable/screen/warband/manager/proc/spawn_character(classpath, mob/user, subclasspath, is_leader, is_latespawn = FALSE)
	var/datum/advclass/class_path = new classpath()
	var/datum/advclass/subclass_path

	if(subclasspath)
		subclass_path = new subclasspath()

	if(is_leader)
		var/turf/warlord_landmark_turf
		for(var/obj/effect/landmark/start/warlordlate/warlord_spawn in GLOB.landmarks_list)
			warlord_landmark_turf = get_turf(warlord_spawn)
			user.forceMove(warlord_spawn.loc)
			qdel(warlord_spawn)
			break
		
		// we mark the nearest rally point to the warlord's spawn as the spawn turf for anyone coming out of the lobby
		var/obj/structure/fluff/warband/warband_recruit/nearest_rally
		var/shortest_distance = 99
		
		for(var/obj/structure/fluff/warband/warband_recruit/rally in SSwarbands.warband_machines)
			if(rally.warband_ID == src.warband_ID)
				var/distance = get_dist(user, rally)
				if(distance < shortest_distance)
					shortest_distance = distance
					nearest_rally = rally

		if(nearest_rally)
			src.warband_spawn_turf = get_turf(nearest_rally)
		else if(warlord_landmark_turf)
			src.warband_spawn_turf = warlord_landmark_turf // if we couldn't find one for some reason, we'll fall back to where the warlord's landmark was
	else
		if(!is_latespawn)
			user.forceMove(src.warband_spawn_turf)

	for(var/mob/living/carbon/human/important_figure in src.importantfigures)
		user.mind.i_know_person(important_figure.mind)

	for(var/mob/living/carbon/human/pal in src.members)
		user.mind.i_know_person(pal.mind)
		user.mind.person_knows_me(pal.mind)

	equip_character(class_path, subclass_path, is_leader, user)
	user.faction |= list("warband_[src.warband_ID]")
	if(user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant" || is_leader)
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/exile)
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/associate)
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/grunt_order)
		addtimer(CALLBACK(src, PROC_REF(give_treaty), user), 10 SECONDS)
		if(!is_leader)
			user.verbs += /mob/living/carbon/human/proc/desert
			user.verbs += /mob/living/carbon/human/proc/accept_kick
		else
			ADD_TRAIT(user, TRAIT_TEMPO, TRAIT_GENERIC)
	if(user.job == "Prophet")
		user.verbs += /mob/living/carbon/human/proc/enlighten
	user.verbs += /mob/living/carbon/human/proc/shortcut
	user.verbs += /mob/living/carbon/human/proc/communicate
	REMOVE_TRAIT(user, TRAIT_FORCED_LOOC, TRAIT_GENERIC)
	src.members += user
	user.nutrition = NUTRITION_LEVEL_FULL
	user.hydration = HYDRATION_LEVEL_FULL
	if(user.mind.special_role == "Grunt")
		assign_grunt(grunt = user)
	else if(user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant")
		src.spawned_lieutenants++
		assign_grunt(lieutenant = user)


//////////////////////
////////////////////////////////////////////// SPAWNING
//////////////////////


// 12
//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// RETURN ENVOY
/* 12
	returns an envoy's client to their original character

	does via two potential routes
	1. USING A STORED CHARACTER
		we'll do this if:
		a recruitment point holding a stored character is captured

	2. USING A LINKED MOB
		we'll do this if:
		an Envoy uses their ABANDON ENVOY verb
		an Envoy interacts with a recruitment point
		an Envoy re-enters their corpse

	search all rally points for the envoy's stored character
	puts the envoy back in their stored character, and then delete the envoy
*/
/atom/movable/screen/warband/manager/proc/return_envoy(mob/living/carbon/human/envoy, mob/returning_character, obj/return_recruitmentpoint, abandoned = FALSE)
	// USING A STORED CHARACTER
	// aka: home <- envoy
	// requires the recruitment point & the stored/returning character
	if(returning_character && return_recruitmentpoint)
		for(var/mob/living/carbon/human/stored_character in return_recruitmentpoint.contents)
			for(var/mob/living/potential_envoy in src.members)
				if(potential_envoy.canon_client.key == returning_character.canon_client.key && potential_envoy.mind.special_role == "Warlord's Envoy")
					potential_envoy.visible_message(span_boldred("[potential_envoy] suddenly collapses. They won't be getting up."))
					stored_character.forceMove(return_recruitmentpoint.loc)
					returning_character.key = potential_envoy.key
					returning_character.forceMove(return_recruitmentpoint.loc)
			for(var/mob/living/carbon/spirit/ghost in GLOB.player_list) // if the envoy isn't found, we check the ghosts
				if(ghost.canon_client.key == returning_character.canon_client.key && ghost.mind.special_role == "Warlord's Envoy")
					stored_character.forceMove(return_recruitmentpoint.loc)
					returning_character.forceMove(return_recruitmentpoint.loc)					
					returning_character.key = ghost.key
			stored_character.mode = NPC_AI_OFF

	// USING A LINKED MOB
	// aka: envoy -> home
	else
		var/mob/living/carbon/human/target_character = envoy?.mind.original_char
		target_character.mode = NPC_AI_OFF
		target_character.key = envoy.key
		target_character.forceMove(target_character.loc.loc)
		src.members -= envoy
		if(abandoned)
			return
		src.spawns++ // if they made it back alive refund the spawn spent on them
		envoy.unequip_everything()
		qdel(envoy)
	return

// 13
/////////////////////////////////////////////////////////
///////////////////////////////////////////////// SET IDS
/* 13
	sets the ID of every unregistered warband object

	called when a warband is created
	called again when the warband spawns an outskirts & intermission map

*///
/atom/movable/screen/warband/manager/proc/set_IDs()
	for(var/obj/structure/fluff/warband/warband_object in SSwarbands.warband_machines)
		if(warband_object.warband_ID == 0)
			warband_object.linked_warband = src
			warband_object.warband_ID = src.warband_ID
	for(var/obj/effect/solid_invisible_barrier/warband_spawnbarrier/spawn_blocker in SSwarbands.warband_machines)
		if(spawn_blocker.warband_ID == 0)
			spawn_blocker.linked_warband = src
			spawn_blocker.warband_ID = src.warband_ID
	for(var/obj/structure/fluff/traveltile/warband/warband_tile in SSwarbands.warband_machines)
		if(warband_tile.warband_ID == 0 || (warband_tile.warband_ID == src.warband_ID && !warband_tile.linked_warband))
			warband_tile.linked_warband = src
			warband_tile.warband_ID = src.warband_ID
		if(warband_tile.type == /obj/structure/fluff/traveltile/warband/camp_to_outskirts && warband_tile.warband_ID == src.warband_ID)
			warband_tile.aportalid = "camp_[src.warband_ID]"
			warband_tile.aportalgoesto = "outskirts_[src.warband_ID]"

// 14
//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// LINK PORTALS
/* 14
	links together all travel tiles with a shared warband_ID
*/
/atom/movable/screen/warband/manager/proc/link_portals()
	for(var/obj/structure/fluff/traveltile/warband/warband_tile in SSwarbands.warband_machines)
		if(warband_tile.warband_ID == src.warband_ID)
			if(warband_tile.type == /obj/structure/fluff/traveltile/warband/azure_to_intermission)
				warband_tile.aportalid = "azureside_[src.warband_ID]"
				warband_tile.aportalgoesto = "intermission_[src.warband_ID]"
			if(warband_tile.type == /obj/structure/fluff/traveltile/warband/intermission_to_azure)
				warband_tile.aportalid = "intermission_[src.warband_ID]"
				warband_tile.aportalgoesto = "azureside_[src.warband_ID]"
			if(warband_tile.type == /obj/structure/fluff/traveltile/warband/intermission_to_outskirts)
				warband_tile.aportalid = "pre_outskirts_[src.warband_ID]"
				warband_tile.aportalgoesto = "azureside_outskirts_[src.warband_ID]"
			if(warband_tile.type == /obj/structure/fluff/traveltile/warband/outskirts_to_intermission)
				warband_tile.aportalid = "azureside_outskirts_[src.warband_ID]"
				warband_tile.aportalgoesto = "pre_outskirts_[src.warband_ID]"
			if(warband_tile.type == /obj/structure/fluff/traveltile/warband/outskirts_to_camp)
				warband_tile.aportalid = "outskirts_[src.warband_ID]"
				warband_tile.aportalgoesto = "camp_[src.warband_ID]"

// 15
//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// SET DEFAULT EXIT
/* 15
	before the warcamp's z-level is connected to the main z-level, they need envoys to establish travel tiles
	before those travel tiles are established, the envoys spawn on a Default Exit

	at the moment, we're using the quest landmarks to pick a Default Exit
	65% chance for an Easy landmark to be chosen
	35% chance to be Immediately Killed By Shadow People (medium or hard landmark)

	if there's no quest landmarks, we just dump them at spawn
*/
/atom/movable/screen/warband/manager/proc/set_default_exit()
	var/chosen_landmark_type
	var/random_landmark

	var/has_badspawn = FALSE
	for(var/datum/warbands/aspects/aspect in src.selected_aspects)
		if(istype(aspect, ASPECT_BADSPAWN))
			has_badspawn = TRUE
			break

	if(has_badspawn)
		chosen_landmark_type = pick(/obj/effect/landmark/quest_spawner/medium, /obj/effect/landmark/quest_spawner/hard)
	else
		if(prob(65))
			chosen_landmark_type = /obj/effect/landmark/quest_spawner/easy
		else
			if(prob(50))
				chosen_landmark_type = /obj/effect/landmark/quest_spawner/medium
			else
				chosen_landmark_type = /obj/effect/landmark/quest_spawner/hard

	var/list/candidates = list()
	for(var/landmark in GLOB.quest_landmarks_list)
		if(istype(landmark, chosen_landmark_type)) 
			candidates += landmark 

	if(candidates.len) 
		random_landmark = pick(candidates) 
	else
		for(var/fallback_spawn_landmark in GLOB.start_landmarks_list)
			if(istype(fallback_spawn_landmark, /obj/effect/landmark/start/adventurerlate))
				random_landmark = fallback_spawn_landmark
				message_admins("Warband [src.warband_ID] couldn't find a default exit landmark. Exit is defaulting to the Adventurer Spawn.")				
				break

	for(var/obj/structure/fluff/traveltile/warband/camp_to_outskirts/exit_tile in SSwarbands.warband_machines)
		if(exit_tile.warband_ID == src.warband_ID)
			exit_tile.chosen_landmark = random_landmark


// 16
//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CHANGE CHARACTER
/* 16
	changes the client's active character slot
*/
/atom/movable/screen/warband/manager/proc/use_character_appearance(mob/user)
	var/list/choices = list()
	var/datum/preferences/prefs = user.client.prefs

	if(!prefs || !prefs.path)
		return

	var/savefile/S = new /savefile(prefs.path)
	if(!S)
		return

	for(var/i=1, i<=prefs.max_save_slots, i++)
		var/name
		S.cd = "/character[i]"
		S["real_name"] >> name
		if(name) // only show slots with a name saved
			choices["[name] (SLOT [i])"] = i

	if(!choices.len)
		return

	var/choice_slot = input(user, "CHOOSE A HERO", "ROGUETOWN") as null|anything in choices
	if(!choice_slot)
		return

	prefs.load_character(choices[choice_slot])
	return

// 17
/////////////////////////////
////////////// LOAD CHARACTER
/* 17
	applies the client's active character slot to the current mob
*/ 
/atom/movable/screen/warband/manager/proc/create_character(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.client.prefs.copy_to(target)
	target.dna.update_dna_identity()
	statwipe(target)
	GLOB.chosen_names += target.real_name


// 18
//////////////////////////////////////////////////////////
///////////////////////////////////////////////// STATWIPE
/* 18
	wipes the stats given by preference copying (statpacks, virtue traits, etc)
*/

/atom/movable/screen/warband/manager/proc/statwipe(mob/living/carbon/human/user)
// skillwipe
	if(!user.skills || !user.skills.known_skills) 
		return 
	user.skills.known_skills = list()
	user.skills.skill_experience = list()

// traitwipe
	if(!user.status_traits) 
		return
	for(var/trait in user.status_traits)
		if(trait != "hearing_sensitive") // they can keep their ears. As A Treat
			user.status_traits -= trait

// statwipe
	user.STASTR = 10
	user.STASPD = 10
	user.STACON = 10
	user.STAWIL = 10
	user.STAINT = 10
	user.STAPER = 10

// spellwipe
	user.actions = list()
	user.mind.RemoveAllSpells()
	if(/mob/living/carbon/human/proc/devotionreport in user.verbs)
		user.verbs -= /mob/living/carbon/human/proc/devotionreport
		user.verbs -= /mob/living/carbon/human/proc/clericpray

// 19
////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// RANDOM CLASSES
/* 19
	the Random Classes proc for the Wildcard Lieutenant Class
	this needs to draw on the Warbands list, so we're putting it here
*/

/datum/outfit/job/roguetown/warband/rebellion/lieutenant/wildcard/proc/random_classes()
	var/list/final_class_list = list()
	var/list/all_lieutenant_classes = list()
	var/list/all_warlord_classes = list()
	// we don't want to draw another wildcard,
	// nor a mercenary class (which spawns naked as it's a template for its subclass)
	var/list/excluded_classes = list(
		/datum/advclass/warband/rebellion/lieutenant/wildcard,
		/datum/advclass/warband/mercenary
	)

	for(var/warband_type in WARBANDS)
		var/datum/warbands/warband = new warband_type()
		if(!warband)
			continue

		for(var/lieutenant_type in warband.lieutenantclasses)
			var/excluded = FALSE
			for(var/path in excluded_classes)
				if(ispath(lieutenant_type, path))
					excluded = TRUE
					break
			if(!excluded)
				all_lieutenant_classes += new lieutenant_type
		
		for(var/warlord_type in warband.warlordclasses)
			var/excluded = FALSE
			for(var/path in excluded_classes)
				if(ispath(warlord_type, path))
					excluded = TRUE
					break
			if(!excluded)
				all_warlord_classes += new warlord_type
		
		qdel(warband)

	// roll 3 classes
	// 90% chance for a lieutenant class, 10% for a warlord class
	for(var/i in 1 to 3)
		if(prob(90))
			if(all_lieutenant_classes.len)
				final_class_list += pick(all_lieutenant_classes)
		else
			if(all_warlord_classes.len)
				final_class_list += pick(all_warlord_classes)

	return final_class_list


/datum/outfit/job/roguetown/warband/rebellion/lieutenant/wildcard/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/rolled_classes = src.random_classes()
	var/datum/advclass/classchoice = input("Choose your class", "WILDCARD") as anything in rolled_classes
	if(istype(classchoice, /datum/advclass))
		classchoice.equipme(H)


// 20
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ASPECT TWEAKS
/* 20
	makes a few final tweaks to a warband's stats based on their aspects
*/
/atom/movable/screen/warband/manager/proc/aspect_tweaks(mob/living/carbon/human/warlord)
	if(ASPECT_HOST in src.selected_aspects)
		src.spawns += 150

/atom/movable/screen/warband/manager/proc/envy_check()
	var/has_throne_of_envy = FALSE
	for(var/datum/warbands/aspects/aspect in src.selected_aspects)
		if(istype(aspect, /datum/warbands/aspects/envy))
			has_throne_of_envy = TRUE
			break

	if(!has_throne_of_envy)
		return

	for(var/mob/living/carbon/human/member in src.lobby_members)
		if(member.mind.special_role != "Lieutenant" && member.mind.special_role != "Aspirant Lieutenant")
			continue
		
		var/was_already_aspirant = (member.mind.special_role == "Aspirant Lieutenant")
		member.mind.special_role = "Aspirant Lieutenant"
		
		var/datum/antagonist/warlord_lieutenant/lieu_antag
		for(var/datum/antagonist/antag in member.mind.antag_datums)
			if(istype(antag, /datum/antagonist/warlord_lieutenant))
				lieu_antag = antag
				break

		lieu_antag.aspirant = TRUE
		var/list/aspirant_objectives = list(
			/datum/objective/warband/aspirant/wormtongue,
			/datum/objective/warband/aspirant/disorder,
			/datum/objective/warband/aspirant/order,
			/datum/objective/warband/aspirant/standard,
			/datum/objective/warband/aspirant/coin
		)
		if(was_already_aspirant)
			for(var/datum/objective/existing_obj in lieu_antag.objectives)
				for(var/obj_type in aspirant_objectives)
					if(istype(existing_obj, obj_type))
						aspirant_objectives -= obj_type
						break
		var/chosen_type = pick(aspirant_objectives)
		var/datum/objective/warband/aspirant/new_objective = new chosen_type
		new_objective.owner = member.mind
		lieu_antag.objectives += new_objective
		member.mind.announce_objectives()

		if(was_already_aspirant)
			to_chat(member, span_userdanger("Throne of Envy has been selected. I have been given an additional objective."))
		else
			to_chat(member, span_userdanger("Throne of Envy has been selected. I am now an Aspirant Lieutenant with my own ambitions."))

// 21
///////////////////////////////////////////////////////
///////////////////////////////////////////////// EXILE
/* 21
	kicks someone out of the warband
	varies depending on whether or not they were just an ally, or an Actual Member of the warband

*/
/atom/movable/screen/warband/manager/proc/exile(mob/initial_target, mob/living/carbon/human/user, menu_name, personal = FALSE)
	var/faction_tag = "warband_[src.warband_ID]"
	var/personal_faction_tag
	var/mob/exiled_creecher = initial_target
	if(menu_name)	// get the mob w/the name given from the exile menu
		for(var/mob/living/member in src.members)
			if(member.real_name == menu_name)
				exiled_creecher = member
				break
	if(user)
		personal_faction_tag = "[user.real_name]_faction"

	if(exiled_creecher == user) 		// against yourself
		to_chat(user, span_warning("I shouldn't exile myself."))
		return FALSE

	if(exiled_creecher.stat == DEAD) 	// against a corpse
		to_chat(user, span_warning("They're dead. That's exile enough."))
		return
		
	if(exiled_creecher.mind && exiled_creecher.mind.special_role == "Warlord's Envoy")
		to_chat(user, span_warning("No point in killing the messenger."))
		return

	if(exiled_creecher in user.friends) // against one of your own NPCs
		to_chat(user, span_warning("[exiled_creecher.name] is one of my finest soldiers! I could never consider such a thing..."))
		return FALSE

	// for warlords exiling a re-associated exiled lieutenant or grunt
	if(user.mind && user.mind.special_role == "Warlord" && exiled_creecher.mind && (user.mind.warband_ID in exiled_creecher.mind.warband_exile_IDs))
		if(exiled_creecher in user.mind.warband_manager.allies)
			to_chat(user, span_red("[exiled_creecher.real_name] is branded as an exile yet again."))
			if(faction_tag in exiled_creecher.faction)
				exiled_creecher.faction -= faction_tag		
			if(personal_faction_tag in exiled_creecher.faction)
				exiled_creecher.faction -= personal_faction_tag
			if(personal)
				user.say("HOSTIS DECLARATUS ES!")
				user.linepoint(exiled_creecher)
			user.mind.warband_manager.allies -= exiled_creecher
			user.mind.warband_manager.disorder ++ 	// adds a permanent stack of disorder. Something has to be going horribly wrong
		return TRUE									// The Boss Has Lost His Fucking Mind

	// if they're a lieutenant's exiled subordinate, this confirms they want them gone
	if(exiled_creecher.real_name in user.mind.unresolved_exile_names)
		if(exiled_creecher.real_name in user.mind.unresolved_exile_names)
			user.mind.unresolved_exile_names -= exiled_creecher.real_name
			user.mind.subordinates -= exiled_creecher

	if(istype(exiled_creecher, /mob/living/simple_animal))
		if(personal_faction_tag in exiled_creecher.faction)
			exiled_creecher.faction -= personal_faction_tag
			to_chat(user, span_warning("I have released the [exiled_creecher.name] from my protection."))
			return TRUE
		return

	else if(istype(exiled_creecher, /mob/living/carbon/human))
		var/mob/living/carbon/human/target = exiled_creecher


		// against allies
		if(target.mind && (target in src.allies))
			if((faction_tag in target.faction))
				if(personal) // if the exile's being done manually via the spell
					user.say("Hostis declaratus es.")
					user.linepoint(target)
				target.mind.current.faction -= faction_tag
				if(personal_faction_tag && (personal_faction_tag in target.faction))
					target.mind.current.faction -= personal_faction_tag

				src.allies -= target
				target.mind.warband_recruiter_name = null

				// if they were an antagonist (and not a warband member), reduce disorder
				if(target.mind.special_role && target.mind.warband_ID != user.mind.warband_ID)
					to_chat(user, span_warning("I have exiled [target.name] from our ranks. Some measure of order has been restored."))
					src.disorder --
					return
				else
					to_chat(user, span_warning("I have exiled [target.name] from our ranks."))
					return

		// against other warband members
		if(target.mind && (target in src.members))
			if(user.mind.special_role == "Warlord" || (target in user.mind.subordinates))
				var/readycheck = input(user, "Am I sure I want to exile [target.real_name]? This will be final.") in list("EXILE", "Cancel")
				if(readycheck == "EXILE")
					if(target.mind.special_role == "Grunt")
						if(target in user.mind.subordinates) // if they're exiled by their own boss, ignore the deliberation phase
							target.abandon_warband(grunt_kick = TRUE, autoresolve = TRUE)
							target.faction -= personal_faction_tag
							if(target.real_name in user.mind.unresolved_exile_names) // if they were an unresolved exile we consider them resolved
								user.mind.unresolved_exile_names -= target.real_name
							return
						else
							target.abandon_warband(grunt_kick = TRUE)
							to_chat(user, span_warning("I've branded [target.real_name] as an exile but unless their Lieutenant, [target.mind.warband_recruiter_name], approves of this, [target.real_name] will remain associated with them."))
							return
					else
						target.abandon_warband(kicked = TRUE)
						return
			else
				to_chat(user, span_warning("I don't bear the authority to exile the [target.job]."))


		if((personal_faction_tag in target.faction)) // you should always be able to remove your personal faction tag from someone
			target.faction -= personal_faction_tag
			if(target.mind.warband_recruiter_name == user.real_name)
				target.mind.warband_recruiter_name = null
			if(personal)
				user.say("Hostis declaratus es.")
				user.linepoint(exiled_creecher)

		if(!(faction_tag in target.faction)) // if you're completely unrelated to them
			to_chat(user, span_warning("They're not with us. Exile would be pointless."))
			return FALSE
		return
	return

// 22
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CLEAN MEMBERS
/* 22
	cleans nulls out of the members & ally list

*/
/atom/movable/screen/warband/manager/proc/clean_members()
	for(var/member in src.members)
		if(member == null)
			src.members -= member
	for(var/ally in src.allies)
		if(ally == null)
			src.allies -= ally

// 23
//////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// DETERMINE SQUAD SIZE
/* 23
	determine the size of the character's NPC squad
	4 by default
	warlords will always receive double the expected squad size

*/


/atom/movable/screen/warband/manager/proc/determine_squad_size(mob/user)
	var/calculated_size = 4


	if(src.selected_warband && src.selected_warband.name == "Peasant Rebellion")
		calculated_size = 30 // DELETENOTE: set back to 8
	else if(user.job == "Rival Lord")
		calculated_size = 8
	
	if(user.mind.special_role == "Warlord")
		calculated_size *= 2

	user.mind.squad_size = calculated_size



// 24
/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// LOBBY TIMER
/* 24
	
*/
/atom/movable/screen/warband/manager/proc/start_creation_timer()
	if(creation_timer_active)
		return
	creation_start_time = world.time
	creation_timer_active = TRUE
	var/time_until_warning = creation_time_limit - creation_warning_threshold
	addtimer(CALLBACK(src, PROC_REF(send_warning)), time_until_warning)

/atom/movable/screen/warband/manager/proc/send_warning()
	if(!creation_timer_active || src.finalized)
		return // bail if timer was stopped or the warband was finalized
	warned = TRUE
	var/minutes_left = round(creation_warning_threshold / 600)
	for(var/mob/living/member in src.lobby_members)
		to_chat(member, span_boldwarning("WARBAND CREATION TIME WARNING: [minutes_left] minute(s) remain."))
		member.playsound_local(member, 'sound/misc/notice (2).ogg', 100, FALSE)
	addtimer(CALLBACK(src, PROC_REF(trigger_timeout)), creation_warning_threshold)

/atom/movable/screen/warband/manager/proc/stop_creation_timer()
	if(!creation_timer_active)
		return
	creation_timer_active = FALSE

/atom/movable/screen/warband/manager/proc/trigger_timeout()
	if(!creation_timer_active || src.finalized)
		return
	stop_creation_timer()
	force_warband_spawn()

/atom/movable/screen/warband/manager/proc/force_warband_spawn()
	var/mob/living/warlord
	for(var/mob/living/member in src.lobby_members)
		if(member.mind && member.mind.special_role == "Warlord")
			warlord = member
			break
	
	if(!warlord) // this absolutely shouldn't happen
		for(var/mob/living/member in src.lobby_members)
			if(member.mind && member.mind.special_role == "Grunt") // but if it does, we'll prefer grunts over lieutenants for warlord replacements
				warlord = member
				member.mind.special_role = "Warlord"
				to_chat(member, span_userdanger("The Warlord has abandoned the lobby. You have been elected to serve as the warlord."))
				message_admins("Warband [src.warband_ID] elected grunt [member.real_name] as the new warlord during timeout.")
				break
		if(!warlord)
			for(var/mob/living/member in src.lobby_members)
				if(member.mind && (member.mind.special_role == "Lieutenant" || member.mind.special_role == "Aspirant Lieutenant"))
					warlord = member
					member.mind.special_role = "Warlord"
					to_chat(member, span_userdanger("The Warlord has abandoned the lobby. You have been elected to serve as the warlord."))
					message_admins("Warband [src.warband_ID] elected lieutenant [member.real_name] as the new warlord during timeout.")
					break
		if(!warlord)
			for(var/mob/living/member in src.lobby_members)
				cancel_lobby(member)
		if(lobby_members.len == 0)
			qdel(src)
			return
	
	to_chat(warlord, span_userdanger("TIME'S UP! THE WARBAND IS BEING FORCED TO SPAWN!"))
	if(src.creation_stage == 1)
		to_chat(warlord, span_warning("Selecting random warband configuration..."))
		
		if(!src.warbands.len)
			for(var/mob/living/member in src.lobby_members)
				cancel_lobby(member)
			return
		
		var/datum/warbands/random_warband = pick(src.warbands)
		src.selected_warband = random_warband
		to_chat(warlord, span_notice("Warband: [random_warband.title]"))

		if(random_warband.subtypes && random_warband.subtypes.len > 0)
			var/list/available_subtypes = list()
			var/list/compatible_types = random_warband.subtypes[1]
			for(var/datum/warbands/subtypes/potential_subtype in src.subtypes)
				if(potential_subtype.type in compatible_types)
					available_subtypes += potential_subtype

			if(available_subtypes.len > 0)
				if(random_warband.subtyperequired || prob(50)) // if a subtype's required, always pick one. Otherwise it's a 50% chance
					var/datum/warbands/subtypes/random_subtype = pick(available_subtypes)
					src.selected_subtype = random_subtype
					to_chat(warlord, span_notice("Subtype: [random_subtype.title]"))
		
		// we'll build a list of available aspects and randomize selections that keep us above a defecit
		var/list/available_aspects = list()
		var/list/negative_aspects = list()
		var/list/positive_aspects = list()
		
		for(var/datum/warbands/aspects/potential_aspect in src.aspects)
			var/is_compatible = random_warband.aspects.Find(potential_aspect.type)
			if(src.selected_subtype && src.selected_subtype.aspects)
				if(src.selected_subtype.aspects.Find(potential_aspect.type))
					is_compatible = TRUE
			if(is_compatible)
				available_aspects += potential_aspect
				if(potential_aspect.points > 0)
					negative_aspects += potential_aspect
				else if(potential_aspect.points < 0)
					positive_aspects += potential_aspect
		
		// we want 1 negative and 1 positive aspect
		src.selected_aspects = list()	
		if(negative_aspects.len > 0)
			var/datum/warbands/aspects/picked_negative = pick(negative_aspects)
			src.selected_aspects += picked_negative
			to_chat(warlord, span_notice("Negative Aspect: [picked_negative.title]"))
		
		if(positive_aspects.len > 0)
			var/datum/warbands/aspects/picked_positive = pick(positive_aspects)
			var/class_conflict = FALSE
			for(var/datum/warbands/aspects/existing in src.selected_aspects)
				if(existing.asclass && picked_positive.asclass && existing.asclass == picked_positive.asclass)
					class_conflict = TRUE
					break
			
			if(!class_conflict)
				src.selected_aspects += picked_positive
				to_chat(warlord, span_notice("Positive Aspect: [picked_positive.title]"))
			else
				for(var/datum/warbands/aspects/alternate in positive_aspects)
					if(alternate == picked_positive)
						continue
					var/alt_conflict = FALSE
					for(var/datum/warbands/aspects/existing in src.selected_aspects)
						if(existing.asclass && alternate.asclass && existing.asclass == alternate.asclass)
							alt_conflict = TRUE
							break
					if(!alt_conflict)
						src.selected_aspects += alternate
						to_chat(warlord, span_notice("Positive Aspect: [alternate.title]"))
						break

		src.creation_stage = 2
		set_race_and_faith_locks()
		envy_check()
		send_warnings()
		for(var/mob/living/carbon/human/member in src.lobby_members)
			to_chat(member, span_boldwarning("TIME EXPIRED! The warband has been randomly configured and auto-advanced to class selection."))
			SStgui.update_uis(member)
			update_static_data(member)
		apply_sect_faithlock(warlord)
	
	if(src.creation_stage >= 2)
		if(!src.selected_warband)
			if(src.warbands.len > 0)
				src.selected_warband = pick(src.warbands)
			else
				for(var/mob/living/carbon/human/member in src.lobby_members)
					cancel_lobby(member)
				return

		to_chat(warlord, span_boldwarning("Spawning with current selections..."))
		var/class_path = /datum/advclass/warband/standard/warlord/lord
		var/subclass_path = null
		
		if(src.selected_warband.warlordclasses && src.selected_warband.warlordclasses.len > 0)
			class_path = pick(src.selected_warband.warlordclasses)
		else if(src.selected_subtype && src.selected_subtype.warlordclasses && src.selected_subtype.warlordclasses.len > 0)
			class_path = pick(src.selected_subtype.warlordclasses)

		if(src.selected_warband.title == "MERCENARY COMPANY" && src.selected_subtype)
			var/list/available_subclasses = list()
			var/list/subtype_classes
			if(warlord.mind.special_role == "Warlord")
				subtype_classes = src.selected_subtype.warlordclasses
			else if(warlord.mind.special_role == "Lieutenant" || warlord.mind.special_role == "Aspirant Lieutenant")
				subtype_classes = src.selected_subtype.lieutenantclasses
			else
				subtype_classes = src.selected_subtype.gruntclasses
			
			// filter out base classes
			for(var/class_type in subtype_classes)
				if(warlord.mind.special_role == "Warlord" && class_type == /datum/advclass/warband/mercenary/warlord/captain)
					continue
				if(warlord.mind.special_role == "Lieutenant" || warlord.mind.special_role == "Aspirant Lieutenant")
					if(class_type == /datum/advclass/warband/mercenary/lieutenant/vanguard)
						continue
					if(class_type == /datum/advclass/warband/mercenary/lieutenant/tactician)
						continue
					if(class_type == /datum/advclass/warband/mercenary/lieutenant/skirmisher)
						continue
				if(warlord.mind.special_role == "Grunt" && class_type == /datum/advclass/warband/mercenary/grunt/merc)
					continue
				available_subclasses += class_type
			
			if(available_subclasses.len > 0)
				subclass_path = pick(available_subclasses)
		SSwarbands.warband_managers_busy = TRUE
		SStgui.close_user_uis(warlord)
		if(warlord in src.lobby_members)
			lobby_members -= warlord
		create_character(warlord, warlord)
		lock_check(warlord)
		spawn_warband(warlord)
		set_IDs()
		spawn_character(class_path, warlord, subclass_path, is_leader = 1)
		set_default_exit()
		apply_sect_faithlock(warlord)
		src.warlord_spawned = TRUE
		SSwarbands.warband_managers_busy = FALSE
		src.finalized = TRUE
		warlord.mind.warband_manager = src
		end_intro(warlord)
		for(var/mob/living/carbon/human/member in src.lobby_members)
			if(member.mind.special_role == "Lieutenant" || member.mind.special_role == "Aspirant Lieutenant" || member.mind.special_role == "Grunt")
				to_chat(member, span_boldwarning("TIME EXPIRED! The warband has been auto-finalized. You may now create your character."))
				member.playsound_local(member, 'sound/misc/warband/menusound3.ogg', 100, FALSE)

// get remaining time in deciseconds
/atom/movable/screen/warband/manager/proc/get_remaining_time()
	if(!creation_timer_active)
		return -1
	var/elapsed = world.time - creation_start_time
	var/remaining = creation_time_limit - elapsed
	return max(0, remaining)

// if the lobby is absolutely Deep Fried, we'll send everyone back as a ghost
/atom/movable/screen/warband/manager/proc/cancel_lobby(mob/lobby_member)
	to_chat(lobby_member, span_userdanger("The lobby system failed catastrophically. Go home."))
	GLOB.chosen_names -= lobby_member.real_name
	src.lobby_members -= lobby_member
	lobby_member.ghostize(FALSE)

/atom/movable/screen/warband/manager/proc/initialize_outskirts_encounter()
	encounter_manager = new /datum/outskirts_encounter()
	encounter_manager.linked_warband = src
	encounter_manager.custom_wave = choose_outskirts_wave()
	encounter_manager.outskirts_locked = TRUE
	return encounter_manager

/atom/movable/screen/warband/manager/proc/finalize_outskirts_encounter()
	if(!encounter_manager)
		initialize_outskirts_encounter()
	encounter_manager.find_defender_entry()
	encounter_manager.find_attacker_entry()
	encounter_manager.spawn_objective()
	return TRUE

/atom/movable/screen/warband/manager/proc/choose_outskirts_wave()
	var/datum/outskirts_wave/chosen_wave
	if(selected_aspects)
		for(var/datum/warbands/aspects/aspect in src.selected_aspects)
			if(aspect.outskirts_wave)
				chosen_wave = aspect.outskirts_wave
				return new chosen_wave()
	if(!chosen_wave)
		if(selected_subtype && selected_subtype.outskirts_wave)
			chosen_wave = selected_subtype.outskirts_wave
			return new chosen_wave()
	if(!chosen_wave)
		if(selected_warband && selected_warband.outskirts_wave)
			chosen_wave = selected_warband.outskirts_wave
			return new chosen_wave()
	if(!chosen_wave)
		chosen_wave = /datum/outskirts_wave/feud
		return new chosen_wave()
	return


/atom/movable/screen/warband/manager/proc/get_cached_grunt(turf/spawn_location, mob/owner)
	var/list/cache_to_use = get_grunt_cache()
	var/mob/living/carbon/human/species/human/northern/goon/grunt
	if(cache_to_use.len)
		grunt = cache_to_use[1]
		cache_to_use -= grunt
		grunt.forceMove(spawn_location)
		grunt.mode = NPC_AI_IDLE
		grunt.warband_ID = src.warband_ID
		grunt.faction = list()  // clear any old factions
		grunt.faction |= list("warband_[src.warband_ID]")
		START_PROCESSING(SShumannpc, grunt)
	else
		grunt = new /mob/living/carbon/human/species/human/northern/goon(spawn_location)
		grunt.warband = src.selected_warband
		if(src.selected_subtype)
			grunt.subtype = src.selected_subtype
		grunt.warband_ID = src.warband_ID
		grunt.equip_for_warband()
	return grunt


// proc # Who Knows. i stopped labeling this shit. i don't know where i am
////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// MINI-TUTORIALS
/* 
	
*/
/atom/movable/screen/warband/manager/proc/give_treaty(mob/living/carbon/human/user)
	var/user_role = user.mind.special_role
	if(user_role != "Warlord" && user_role != "Lieutenant" && user_role != "Aspirant Lieutenant")
		return
	
	var/obj/item/treaty/new_treaty = new /obj/item/treaty(user.loc)
	new /obj/item/natural/feather(user.loc)
	new_treaty.firstparty = linked_faction.name
	if(src.selected_warband)
		new_treaty.warband_sources += src.selected_warband.title
	if(src.selected_subtype)
		new_treaty.warband_sources += src.selected_subtype.title
	for(var/datum/warbands/aspects/aspect in src.selected_aspects)
		new_treaty.warband_sources += aspect.title
	
	new_treaty.add_unique_terms()
	to_chat(user, span_notice("I fetch the Treaty from my bag. If I lose it, I can draft spares from the Campaign Planner."))
	user.playsound_local(src, 'sound/foley/dropsound/gen_drop.ogg', 100, FALSE)


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// NPC CACHE SHARING
/* 
	
*/
/atom/movable/screen/warband/manager/proc/has_compatible_cache(atom/movable/screen/warband/manager/other_manager)
	if(src.selected_warband.type != other_manager.selected_warband.type)
		return FALSE
	
	if(src.selected_subtype?.type != other_manager.selected_subtype?.type)
		return FALSE
	
	return TRUE // we'll assume they're compatible if they have the same warband and subtype

/atom/movable/screen/warband/manager/proc/share_cache_with(atom/movable/screen/warband/manager/source_manager)
	if(!source_manager)
		return FALSE
	
	var/atom/movable/screen/warband/manager/root_source = source_manager
	while(root_source.cache_source) 
		root_source = root_source.cache_source 
	
	src.cache_source = root_source
	root_source.cache_dependents += src
	return TRUE

/atom/movable/screen/warband/manager/proc/get_grunt_cache()
	if(src.cache_source)
		return src.cache_source.assigned_grunt_cache
	return src.assigned_grunt_cache
