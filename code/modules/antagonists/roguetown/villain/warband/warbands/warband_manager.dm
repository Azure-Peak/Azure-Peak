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

	var/spawns = WARBAND_BASE_RESPAWNS		// 400 minimum | lost when an NPC is spawned | combined with spawn contributions from the warband/subtypes/aspects
											// might seem very generous, but this can be reduced in massive chunks by aspirants going rogue & outskirts fights

	var/schism_level = 0					// warbands can split/schism | this number = how many schisms away the warband is from its progenitor warband | doesn't actually influence anything atm, but for posterity's sake

	var/datum/territory_faction/linked_faction		// the treaty faction connected to the warband

	var/list/racelocks = list()
	var/list/faithlocks = list()
	var/static_data_set = FALSE

	// outskirts variables
	var/list/incoming_mobs = list()					// this tracks who is attempting to attack the warcamp 	(aka currently in the warband's Intermission map)
	var/list/besieging_mobs = list()				// as above, but those actively in combat				(aka currently in the warband's Outskirts map)
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

////////////////////////////////////////////////////////////
///////////////////////////////////////////////// BASE PROCS
/*
	// INITIALIZING
	1  - FIGURE REFRESH			// populates the importantfigures list from current player_list
	2  - STORYTELLER REFRESH	// populates the manager's storyinfluence list

	// LORE LOCKS
	1 - LOCK CHECK 				// compares a mob against the warband's faith & racelocks
	2 - SET LOCKS				// collects all race & faith locks from the selected warband/subtype/aspects
	3 - NOTIFY SECT				// notifies lobby members of sect restrictions
	4 - APPLY SECT FAITHLOCK	// after a Sect Warlord spawns, updates the faithlock to match their patron

	// ASPECT HANDLING
	1 - ASPECT TWEAKS		// makes final tweaks to the warband's stats based on aspects
	2 - ENVY CHECK			// converts lieutenants to aspirants if Throne of Envy is selected

	// OUTSKIRTS
	1 - INITIALIZE OUTSKIRTS ENCOUNTER		// sets up the outskirts encounter manager
	2 - FINALIZE OUTSKIRTS ENCOUNTER		// populates entry points & spawns the encounter objective
	3 - CHOOSE OUTSKIRTS WAVE				// picks an appropriate wave type from aspects/subtype/warband

	// MISC
	1 - EXILE			// kicks a character from the warband
	2 - CLEANUP			// combs through the member & ally list for null entries
	3 - RETURN ENVOY	// sends an envoy's client back to their stored character
	4 - CANCEL LOBBY	// if the lobby is absolutely bricked, Cancel Lobby gets called and sends all the warband members into observer
	5 - END INTRO		// clears the intro text from a mob's screen

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

///////////////////////////////////////////////////////
/////////////////////////////////// STORYTELLER REFRESH
/*
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

//////////////////////////////////////////////
/////////////////////////////////// LOCK CHECK
/*
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
		user.set_patron(user.patron.type) // no faithlocks, but we'll still want to reapply the current patron to restore any patron-relevant traits after the statwipe
	return

/////////////////////////////////////////////////
/////////////////////////////////// SET LOCKS
/*
	collects all race and faith locks from the selected warband, subtype, and aspects
	stores them in the manager's racelocks and faithlocks lists
	called long before any characters are actually spawned

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
				var/datum/species/temp_species = new race_type() // initial doesn't work here
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

////////////////////////////////////////////////////////
/////////////////////////////////// APPLY SECT FAITHLOCK
/*
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

/atom/movable/screen/warband/manager/proc/notify_sect()
	if(!istype(src.selected_warband, /datum/warbands/sect))
		return

	for(var/mob/living/member in src.lobby_members)
		to_chat(member, "<span style='color:#e8bf67'>SECT RESTRICTION:</span> Once the Warlord finalizes, all members will be faithlocked to the Warlord's chosen patron.")
		member.playsound_local(member, 'sound/misc/notice (2).ogg', 100, FALSE)
	return

//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// RETURN ENVOY
/*
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

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ASPECT TWEAKS
/*
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

///////////////////////////////////////////////////////
///////////////////////////////////////////////// EXILE
/*
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
							to_chat(user, span_warning("I've branded [target.real_name] as an exile. But unless their Lieutenant, [target.mind.warband_recruiter_name], approves of this, [target.real_name] will remain associated with them."))
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

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CLEAN MEMBERS
/*
	cleans nulls out of the members & ally list

*/
/atom/movable/screen/warband/manager/proc/clean_members()
	for(var/member in src.members)
		if(member == null)
			src.members -= member
	for(var/ally in src.allies)
		if(ally == null)
			src.allies -= ally

// CANCEL LOBBY
// if the lobby is absolutely Deep Fried, we'll send everyone back as a ghost
/atom/movable/screen/warband/manager/proc/cancel_lobby(mob/lobby_member)
	to_chat(lobby_member, span_userdanger("The lobby system failed catastrophically. Go home."))
	GLOB.chosen_names -= lobby_member.real_name
	src.lobby_members -= lobby_member
	lobby_member.ghostize(FALSE)

// INITIALIZE OUTSKIRTS ENCOUNTER
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

/////////////////////////////////////////////
/////////////////////////////////// END INTRO
/*
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
