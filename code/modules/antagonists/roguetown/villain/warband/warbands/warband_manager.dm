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
	var/list/allies = list()				// players marked as allies
	var/list/importantfigures = list()		// important figures in town | used in the 'know thy enemy' list in the creation menu | helps in plotting an initial gimmick

	var/busy_summoning = FALSE				// active while the warband is polling for ghosts
	var/spawned_lieutenants = 0				// how many lieutenants have been spawned
	var/warband_ID = 0						// identifying number for the warband |
	var/disorder = 1						// multiplies costs from the campaign planner, disables communication options and Outskirts responses, and determines how many spawns an aspirant steals during a schism | increased by other antagonists being marked as allies
	var/aspirant_chance = 50				// chance that a lieutenant spawns as an aspirant
	var/list/combatmusic = list()			// combat track given to members + people who enter the warcamp/outskirts
	var/finalized = FALSE					// whether or not a warband is finalized
	var/outskirts_established = FALSE		// whether or not the warband has spawned an outskirts map
	var/warcamp_established = FALSE

	var/spawns = WARBAND_BASE_RESPAWNS		// 400 | lost when an NPC is spawned | combined with spawn contributions from the warband/subtypes/aspects
											// might seem very generous, but this can be reduced in massive chunks by aspirants going rogue & outskirts fights

	var/schism_level = 0					// warbands can split/schism | this number = how many schisms away the warband is from its progenitor warband

	var/list/racelocks = list()
	var/list/faithlocks = list()
	var/static_data_set = FALSE



////////////////////////////////////////////////////////////
///////////////////////////////////////////////// BASE PROCS
/*
	something labelled with (F) is Fucked & Nonfunctional
	1 - STORYTELLER REFRESH		// populates the manager's storyinfluence list
	2 - CREATE HUD INSTANCE		// gives someone the HUD icon required to interface with character creation
	3 - VIEW VIP				// examine the flavortext of a mob in Members or Important Figures
	4 - END INTRO				// ends the intro sequence from character creation
	5 - CHOOSE MAP				// choose & spawn the warcamp
	5b - CHOOSE MUSIC			// choose the combat music

	6 - SEND WARNINGS 	(F)		// sends warning letters to townsfolk when the warband spawns
	7 - LOCK CHECK 		(F)		// checks for race & faithlocks and a character's compliance w/them
	8 - CREATE FACTION 	(F)		// creates the faction required to interface w/treaties
	9 - SPAWN WARBAND			// spawns the warband after some final tweaks

	10 - EQUIP CHARACTER		// equips a spawned character
	11 - SPAWN CHARACTER		// spawn a character w/the options selected from the warband hud
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

*/




////////////////////////
//////////////////////////////////////////////// INITIALIZING & REFRESHING
////////////////////////

/atom/movable/screen/warband/manager/Initialize()
	..()
	if(!src.finalized)
		for(var/warband_type in WARBANDS)
			var/datum/warbands/added_warband = new warband_type() 
			src.warbands += added_warband

		var/list/all_subtypes = WARBAND_UNTAGGED_SUBTYPES + WARBAND_MERCENARIES + WARBAND_SECTS
		for(var/sub_type in all_subtypes)
			var/datum/warbands/subtypes/added_subtype = new sub_type() 
			src.subtypes += added_subtype

		for(var/aspect_type in ASPECTS)
			var/datum/warbands/added_aspect = new aspect_type() 
			src.aspects += added_aspect

		for(var/datum/warbands/warband in src.warbands)
			if(warband.warlordclasses)
				for(var/class_type in warband.warlordclasses)
					src.classes += new class_type()
			if(warband.lieutenantclasses)
				for(var/class_type in warband.lieutenantclasses)
					src.classes += new class_type()
			if(warband.gruntclasses)
				for(var/class_type in warband.gruntclasses)
					src.classes += new class_type()

		for(var/datum/warbands/subtypes/subtype in src.subtypes)
			if(subtype.warlordclasses)
				for(var/class_type in subtype.warlordclasses)
					src.classes += new class_type()
			if(subtype.lieutenantclasses)
				for(var/class_type in subtype.lieutenantclasses)
					src.classes += new class_type()
			if(subtype.gruntclasses)
				for(var/class_type in subtype.gruntclasses)
					src.classes += new class_type()

		for(var/datum/warbands/aspects/aspect in src.aspects)
			if(aspect.warlordclasses)
				for(var/class_type in aspect.warlordclasses)
					src.classes += new class_type()
			if(aspect.lieutenantclasses)
				for(var/class_type in aspect.lieutenantclasses)
					src.classes += new class_type()
			if(aspect.gruntclasses)
				for(var/class_type in aspect.gruntclasses)
					src.classes += new class_type()


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


	data["user_role"] = user_role
	data["finalized_status"] = finalized_status


	for(var/mob/living/carbon/human/quote_importantperson_unquote in src.importantfigures)
		UNTYPED_LIST_ADD(noble_list, list(
			"name" = quote_importantperson_unquote.real_name,
			"job" = quote_importantperson_unquote.job
		))
	data["nobles"] = noble_list

	for(var/mob/living/carbon/human/buddy in src.members)
		UNTYPED_LIST_ADD(allies_list, list(
			"name" = buddy.real_name,
			"job" = buddy.job
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

	switch(action)
		if("swap_character_slot")
			use_character_appearance(user)
		if("refresh")
			update_static_data(user, ui)
		if("edit_character")
			user.client.prefs.current_tab = 1
			user.client.prefs.ShowChoices(usr, 4)
		if("create_character")
			SStgui.close_user_uis(user)
			user.mind.warband_manager = src				
			var/class_path = text2path(params["class"])
			var/subclass_path = text2path(params["subclass"])	
			create_character(user, user)
			lock_check(user)
			spawn_character(class_path, user, subclass_path, is_leader = 0)
			end_intro(user)


		if("create_warband")
			if(SSwarbands.warband_managers_busy == TRUE)
				to_chat(src, span_bold("Warband Generation is occupied. Please wait."))
				return
			SSwarbands.warband_managers_busy = TRUE				
			SStgui.close_user_uis(user)		
			var/warband_path = text2path(params["warband"])
			if(ispath(warband_path, /datum/warbands))
				src.selected_warband = new warband_path
			
			var/subtype_path = text2path(params["subtype"])
			if(ispath(subtype_path, /datum/warbands/subtypes))
				src.selected_subtype = new subtype_path

			var/list/aspect_paths = params["aspects"]
			for(var/aspect_path in aspect_paths)
				var/aspect_datum = text2path(aspect_path)
				if(ispath(aspect_datum, /datum/warbands/aspects))
					src.selected_aspects += new aspect_datum
			var/class_path = text2path(params["class"])
			var/subclass_path = text2path(params["subclass"])
			create_character(user, user)
			lock_check()
			spawn_warband(user)
			spawn_character(class_path, user, subclass_path, is_leader = 1,)
			set_IDs()
			set_default_exit()
			SSwarbands.warband_managers_busy = FALSE
			src.finalized = TRUE
			user.mind.warband_manager = src		
			end_intro(user)
			return
		if("interaction_sound")
			user.playsound_local(user, 'sound/misc/warband/menusound1.ogg', 150, FALSE)
			return

////////////////////////////////////////////////////////////
/////////////////////////////////// VIEW LAWS & VIEW DECREES

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
	user.playsound_local(user, 'sound/misc/warband/warband_warhorn3.ogg', 150, FALSE, pressure_affected = FALSE)
	for(var/atom/movable/screen/introtext/text in user.client.screen)
		animate(text, alpha = 0, time = 50)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), text), 50)

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
	selects a map
	prioritizes a choice from a aspect or subtype before falling back on the warband map
*/
/atom/movable/screen/warband/manager/proc/choose_map(latespawn = FALSE)
	var/datum/map_template/chosenmap
	if(selected_aspects)
		for(var/datum/warbands/aspects/aspect in src.selected_aspects)
			if(aspect.warcamp)
				chosenmap = aspect.warcamp
				break

	if(!chosenmap)
		if(selected_subtype && selected_subtype.warcamp)
			chosenmap = selected_subtype.warcamp

	if(!chosenmap)
		if(selected_warband && selected_warband.warcamp)
			chosenmap = selected_warband.warcamp

	if(!chosenmap)
		return

	if(chosenmap)
		for(var/obj/effect/landmark/warcamp/warcamp_landmark in GLOB.landmarks_list)
			var/datum/map_template/new_map = new chosenmap()
			new_map.load(warcamp_landmark.loc, centered = TRUE)
			qdel(warcamp_landmark)
			src.warcamp_established = TRUE
			break
	if(latespawn == TRUE) // when we spawn a camp via a schism, we don't want to leave behind a warlord spawn landmark
		for(var/obj/effect/landmark/start/warlordlate/warlord_spawn in GLOB.landmarks_list)
			qdel(warlord_spawn)
			break

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
	FIXNOTE

	creates a list of people from GLOB.player_list
		a warning letter is created and sent out
		the chance of reception varies depending on each person's job

	1 is chosen to receive a warning letter containing information on:
		the main warband type 
		any subtype
		any selected aspects

	cancels immediately if the spawning Warband has taken the "Surprise" aspect

*/
/obj/item/paper/warband_warning
	name = "hastily-written parchment"

/atom/movable/screen/warband/manager/proc/send_warnings()
	var/atom/movable/screen/warband/manager/incoming_warband = src
	if(/datum/warbands/aspects/surprise in incoming_warband.selected_aspects)
		return

	// draw from the most_likely pool on a 75% chance
	// send it to someone random on a 25% chance	

	// if no one's playing one of the jobs in the most_likely pool, it'll just be sent to someone random

	// check their special role: if it lands on someone with "Warlord", "Aspirant Lieutenant", "Lieutenant", or "Grunt", reroll
	// stop after 2 rerolls, so there's a very tiny chance no one receives a warning, even w/o Surprise in effect

	// var/list/most_likely = list(
	// 	"Hand",
	// 	"Councillor",
	// 	"Inquisitor",
	// 	"Marshal",
	// 	"Towner",
	// 	"Soilson",
	// )

	// for(var/mob/living/carbon/human/character in GLOB.player_list)
	// 	if(most_likely.Find(character.job))

	// var/final_readout = ""

	// final_readout += "Terrible news has been hastily scrawled upon old, torn parchment. It warns of...\n\n"

	// if(incoming_warband.selected_warband && incoming_warband.selected_warband.warning)
	// 	final_readout += "[incoming_warband.selected_warband.warning]\n"

	// if(incoming_warband.selected_subtype && incoming_warband.selected_subtype.warning)
	// 	final_readout += "[incoming_warband.selected_subtype.warning]\n"

	// for(var/datum/warbands/aspects/chosenaspect in incoming_warband.selected_aspects)
	// 	if(chosenaspect && chosenaspect.warning)
	// 		final_readout += "[chosenaspect.warning]\n"

	// var/obj/item/paper/newparchment = new /obj/item/paper/warband_warning

	// newparchment.info = final_readout



//////////////////////
//////////////////////
//////////////////////


// 7
//////////////////////////////////////////////
/////////////////////////////////// LOCK CHECK
/* 7 
	FIXNOTE
	checks the loaded warband for any patron & or faith locks
	if the loaded character doesn't match them, fixes the discrepancy
*/
/atom/movable/screen/warband/manager/proc/lock_check(mob/living/carbon/human/user)

	// user.set_patron(pick(src.faithlocks))

	// user.set_species(pick(src.racelocks))
	// if we had to race swap, assume the flavortext & headshot would be unfitting and just clear them
	// assign a random name too


	return

// 8
//////////////////////////////////////////////////////////
/////////////////////////////////// CHOOSE WARBAND FACTION
/* 8
	FIXNOTE
	generate a faction for treaties
*/
/atom/movable/screen/warband/manager/proc/choose_warband_faction(owner)
	// var/datum/territory_faction/newfaction
	// var/chosen_name
	// var/chosen_desc

	// if(selected_subtype && selected_subtype.treaty_name)
	// 	chosen_name = selected_subtype.treaty_name

	// if(!chosen_name)
	// 	chosen_name = selected_warband.treaty_name


	// newfaction.generate_faction(owner, chosen_name) FIXNOTE


// 9
/////////////////////////////////////////////////
/////////////////////////////////// SPAWN WARBAND
/* 9
	chooses variables with priority & spawns the final result
	for example, a map provided from an aspect is prioritized over one from a subtype, and a subtype map's prioritized over the base warband's map
*/

/atom/movable/screen/warband/manager/proc/spawn_warband(user, rebellion = FALSE)
	if(rebellion == FALSE)
		choose_map()
	choose_combat_music()
	aspect_tweaks()
	choose_warband_faction(user)
	src.finalized = TRUE
	send_warnings()

// 10
///////////////////////////////////////////////////
/////////////////////////////////// EQUIP CHARACTER
/* 10
	equip them w/the provided advclasses

*/

/atom/movable/screen/warband/manager/proc/equip_character(datum/advclass/class_path, datum/advclass/subclass_path, isleader, mob/living/carbon/human/user)
	user.cmode_music_override = src.combatmusic
	user.advjob = class_path.name
	class_path.equipme(user)
	user.job = class_path.name
	if(subclass_path)
		subclass_path.equipme(user)
		user.job = subclass_path.name
	if(should_wear_femme_clothes(user))
		user.job = class_path.f_name
		return
	if(isleader)
		if(ASPECT_FIGUREHEAD in src.selected_aspects) // fixnote: This Shit Don't Work
			for(var/atom/movable/screen/movable/action_button/hud_button in user.client.screen)
				if(hud_button.name == "Sweep")
					qdel(hud_button)
			for(var/datum/action/spell_action/spell/action in user.client.screen)
				if(action.name == "Sweep")
					qdel(action)
			if(user.STASTR < 7)
				user.STASTR = 7
			if(user.STASPD < 10)
				user.STASPD = 10
			if(user.STACON < 10)
				user.STACON = 10
	user.faction |= list("[user.real_name]_faction")
	ADD_TRAIT(user, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NO_XP, TRAIT_GENERIC) // we want them doing Literally Anything Else besides farming for skills
	determine_squad_size(user)

// 11
///////////////////////////////////////////////////
/////////////////////////////////// SPAWN CHARACTER
/* 11
	if they're the warlord, move them to their warcamp's warlord spawn landmark, then delete said landmark
		adds them to the warband manager's members list
		give them:
			knowledge of other members in the warband
			knowledge of important figures in the duchy
			the baseline warband verbs (shortcut & communicate)
*/
/atom/movable/screen/warband/manager/proc/spawn_character(classpath, mob/user, subclasspath, is_leader)
	var/datum/advclass/class_path = new classpath()
	var/datum/advclass/subclass_path

	if(subclasspath)
		subclass_path = new subclasspath()

	if(is_leader)
		for(var/obj/effect/landmark/start/warlordlate/warlord_spawn in GLOB.landmarks_list)
			user.loc = warlord_spawn.loc
			qdel(warlord_spawn)
			break

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
		if(!is_leader)
			user.verbs += /mob/living/carbon/human/proc/desert
			user.verbs += /mob/living/carbon/human/proc/accept_kick
			
	user.verbs += /mob/living/carbon/human/proc/shortcut
	user.verbs += /mob/living/carbon/human/proc/communicate

	src.members += user
	return

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

	2. USING A CLIENT
		we'll do this if:
		an Envoy uses their ABANDON ENVOY verb
		an Envoy interacts with a recruitment point
		an Envoy re-enters their corpse

	search all rally points for the envoy's stored character
	puts the envoy back in their stored character, and then delete the envoy



*/
/atom/movable/screen/warband/manager/proc/return_envoy(mob/living/carbon/human/envoy, mob/returning_character, obj/return_recruitmentpoint, abandoned = FALSE)
	// USING A STORED CHARACTER
	// requires the recruitment point & the stored/returning character
	if(returning_character && return_recruitmentpoint)
		for(var/mob/living/stored_character in return_recruitmentpoint.contents)
			for(var/mob/living/potential_envoy in src.members)
				if(potential_envoy.canon_client.key == returning_character.canon_client.key && potential_envoy.mind.special_role == "Warlord's Envoy")
					potential_envoy.visible_message(span_boldred("[potential_envoy] suddenly collapses. They won't be getting up."))
					stored_character.loc = return_recruitmentpoint.loc
					returning_character.key = potential_envoy.key
					returning_character.loc = return_recruitmentpoint.loc
			for(var/mob/living/carbon/spirit/ghost in GLOB.player_list) // if the envoy isn't found, we check the ghosts
				if(ghost.canon_client.key == returning_character.canon_client.key && ghost.mind.special_role == "Warlord's Envoy")
					stored_character.loc = return_recruitmentpoint.loc
					returning_character.key = ghost.key
					returning_character.loc = return_recruitmentpoint.loc

	// USING A CLIENT
	else
		for(var/obj/structure/fluff/warband/warband_recruit/recruitment_point in SSwarbands.warband_machines)
			if(recruitment_point.contents.len)
				for(var/mob/living/stored_character in recruitment_point.contents)
					if(stored_character.canon_client.key == envoy.canon_client.key)
						stored_character.loc = recruitment_point.loc
						stored_character.key = envoy.key
						envoy.mind.warband_manager.members -= envoy
						if(abandoned)
							break
						envoy.unequip_everything()
						qdel(envoy)
						break
	return

// 13
/////////////////////////////////////////////////////////
///////////////////////////////////////////////// SET IDS
/* 13
	sets the ID of every unregistered warband object

	called when a warband is created
	called again when the warband spawns an outskirts & intermission map

*/
/atom/movable/screen/warband/manager/proc/set_IDs()
	for(var/obj/structure/fluff/warband/warband_object in SSwarbands.warband_machines)
		if(warband_object.warband_ID == 0)
			warband_object.linked_warband = src
			warband_object.warband_ID = src.warband_ID
	for(var/obj/structure/fluff/traveltile/warband/warband_tile in SSwarbands.warband_machines)
		if(warband_tile.warband_ID == 0)
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

	if(ASPECT_BADSPAWN in src.selected_aspects)	// this aspect will force a terrible exit point
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
				log_admin("Warband [src.warband_ID] couldn't find a default exit landmark. Exit is defaulting to the Adventurer Spawn.")				
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
	user.mind.spell_list = list()
	for(var/atom/movable/screen/movable/action_button/hud_button in user.client.screen)
		qdel(hud_button)
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

// istype didn't work in random_classes. i'm probably just stupid but Who Cares Anymore.
/datum/outfit/job/roguetown/warband/rebellion/lieutenant/wildcard/proc/is_excluded_class_path(class_path, list/excluded_paths)
    for(var/path in excluded_paths)
        if(ispath(class_path, path))
            return TRUE
    return FALSE

/datum/outfit/job/roguetown/warband/rebellion/lieutenant/wildcard/proc/random_classes()
	var/list/final_class_list = list()
	var/list/all_lieutenant_classes = list()
	var/list/all_warlord_classes = list()
	
	// we don't want to draw another wildcard,
	// nor a mercenary class (which spawns naked atm, as it's a template for its subclass)
	var/list/excluded_classes = list(
		/datum/advclass/warband/rebellion/lieutenant/wildcard,
		/datum/advclass/warband/mercenary
	)

	for(var/warband_type in WARBANDS)
		var/datum/warbands/warband = new warband_type()
		if(!warband)
			continue

		for(var/lieutenant_type in warband.lieutenantclasses)
			if(!is_excluded_class_path(lieutenant_type, excluded_classes))
				all_lieutenant_classes += new lieutenant_type
		
		for(var/warlord_type in warband.warlordclasses)
			if(!is_excluded_class_path(warlord_type, excluded_classes))
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

	if(ASPECT_CULT in src.selected_aspects)
		src.faithlocks = list(warlord.patron)

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
				target.mind.recruiter_name = null

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
							to_chat(user, span_warning("I've branded [target.real_name] as an exile but unless their Lieutenant, [target.mind.recruiter_name], approves of this, [target.real_name] will remain associated with them."))
							return
					else
						target.abandon_warband(kicked = TRUE)
						return
			else
				to_chat(user, span_warning("I don't bear the authority to exile the [target.job]."))


		if((personal_faction_tag in target.faction)) // you should always be able to remove your personal faction tag from someone
			target.faction -= personal_faction_tag
			if(target.mind.recruiter_name == user.real_name)
				target.mind.recruiter_name = null
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
	(someone getting gibbed leaves behind a null, but only sometimes??)
	(i don't know what the fuck's going on anymore bro)

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
	2 by default
	5 for warlords, aspirant lieutenants and defecting lieutenants

*/
/atom/movable/screen/warband/manager/proc/determine_squad_size(mob/user)
	if(user.mind.special_role == "Warlord" || user.mind.special_role == "Aspirant Lieutenant")
		user.mind.squad_size = 5
	if(user.job == "Rival Lord")
		user.mind.squad_size = 8
	if(src.selected_warband && src.selected_warband.name == "Peasant Rebellion")
		user.mind.squad_size = 8
