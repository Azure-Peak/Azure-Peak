///////////////////////////////////////////////////////
///////////////////////////////////////////////// VERBS
/*
	1 - Abandon Envoy			// returns an envoy's client to their original character
	2 - Communicate				// warband comms
	3 - Abandon Warband			// desertion mechanic for Lieutenants 
	4 - Take Shortcut			// allows for a quick teleport over to the warcamp
	5 - Connect Warcamp			// connects the Warcamp Z-Level to the main map
	6 - Accept Kick				// when a lieutenant's subordinate is kicked by their warlord, they can choose to remain associated with them

*/


// 1
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ABANDON ENVOY
/* 1
	a verb to manually perform the return_envoy proc in emergencies
	abandons a character's envoy & sends them back to their stored character w/return_envoy
*/
/mob/living/carbon/human/proc/abandon_envoy()
	set name = "ABANDON ENVOY"
	set category = "Warband"


	var/list/style_options = list()
	
	if(src.mind.warband_manager.selected_warband?.title == "SORCERER-KING")
		style_options += "BLOW UP HEAD"
	if(src.mind.warband_manager.selected_subtype?.title == "ASCENDANT")
		style_options += "DEADITE"

	style_options += "POISON TOOTH"

	var/style_choice = input(src, "How should they go out?", "ABANDON SHIP") as null|anything in style_options


	switch(style_choice)
		if("POISON TOOTH")
			ADD_TRAIT(src, TRAIT_NOSSDINDICATOR, TRAIT_GENERIC)
			src.visible_message(span_boldred("[src] suddenly seizes up, blood-laced foam bubbling from the corners of their mouth!"))
			src.mind.warband_manager.return_envoy(src, abandoned = TRUE)
			src.adjustOxyLoss(200)
			src.adjustToxLoss(200)
			return TRUE
		if("DEADITE")
			if(prob(90))
				ADD_TRAIT(src, TRAIT_NOSSDINDICATOR, TRAIT_GENERIC)
				src.emote("agony", forced = TRUE)
				src.visible_message(span_boldred("[src] digs their nails into their flesh. Once they have a solid grip, they yank themselves free!"))
				src.mind.warband_manager.return_envoy(src, abandoned = TRUE)
				addtimer(CALLBACK(src, PROC_REF(abandon_followup), 1), 3 SECONDS)
				return TRUE
			else
				ADD_TRAIT(src, TRAIT_NOSSDINDICATOR, TRAIT_GENERIC)
				src.emote("agony", forced = TRUE)
				src.visible_message(span_boldred("[src] contorts in agony as wisps of a dark, terrible energy rise from their screaming lips and bleeding ears. Something wicked is coming..."))
				src.mind.warband_manager.return_envoy(src, abandoned = TRUE)
				addtimer(CALLBACK(src, PROC_REF(abandon_followup), 2), 3 SECONDS)
				return TRUE

		if("BLOW UP HEAD")
			ADD_TRAIT(src, TRAIT_NOSSDINDICATOR, TRAIT_GENERIC)
			src.visible_message(span_boldred("[src]'s skull hums with a swelling, arcane force! Holy shit! They're gonna blow!"))
			src.flash_fullscreen("redflash3")
			src.emote("agony", forced = TRUE)			
			src.mind.warband_manager.return_envoy(src, abandoned = TRUE)
			addtimer(CALLBACK(src, PROC_REF(abandon_followup), 3), 3 SECONDS)
			return TRUE
	return TRUE


/mob/living/carbon/human/proc/abandon_followup(event)
	if(event == 1)
		var/deathloc = src.loc
		var/mob/living/carbon/human/species/skeleton/npc/no_equipment/skeleton = new /mob/living/carbon/human/species/skeleton/npc/no_equipment(deathloc)
		skeleton.emote("laugh", forced = TRUE)
		src.gib()
		return TRUE

	if(event == 2)
		var/deathloc = src.loc
		src.gib()
		new /mob/living/simple_animal/hostile/rogue/haunt/omen(deathloc)
		return TRUE

	if(event == 3)
		src.mind = null
		var/obj/item/bodypart/head = src.get_bodypart(BODY_ZONE_HEAD)
		if(head)
			explosion(src, light_impact_range = 4,  smoke = TRUE)
			head.drop_limb()
			qdel(head)
		return TRUE

// 2
/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// COMMUNICATE
/* 2
	cross-map communication between warband characters
*/
/mob/living/carbon/human/proc/communicate()
	set name = "COMMUNICATE"
	set category = "Warband"
	var/list/random_flavortone = list("caw", "weep", "croak", "scream", "gurgle", "sing", "murmur", "wail", "chirp", "babble")

	if(!src.mind.warband_manager)
		to_chat(src, span_bold("I call, but no Carrier Zad heeds me."))
		return

	if(src.mind.warband_manager.disorder >= 8 && !src.mind.special_role == "Warlord") // warlord can always use Communicate
		to_chat(src, span_bold("I call, but no Carrier Zad heeds me. It's likely disturbed by the disorder in our Warband."))
		return

	if(src.mind.warband_manager.disorder >= 8 && src.mind.special_role == "Warlord")
		to_chat(src, span_warning("My Carrier Zad arrives, but my Warband's morale is too low for my men to utilize their own. I can still send out a message, I shouldn't expect a direct response."))

	if(istype(src.loc.loc, /area/rogue/outdoors))
		var/input_text = input(src, "Enter your message", "Message")
		if(input_text)
			var/sanitized_text = html_encode(input_text)
			src.visible_message(span_boldred("[src] begins binding a sealed letter to a zad's leg..."))
			if(do_after(src, 100, FALSE, src))
				if(istype(src.loc.loc, /area/rogue/outdoors)) // another area check, in case someone starts the prompt outside and moves back inside for the doafter
					var/random_tone = pick(random_flavortone)
					src.visible_message(span_boldred("[src] releases a carrier zad!"))
					playsound(src, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
					for(var/mob/warband_member in src.mind.warband_manager.members)
						if(!warband_member)	// if there's a null in here, we remove them from the member list, call a cleanup, and skip them
							src.mind.warband_manager.members -= warband_member
							src.mind.warband_manager.clean_members()
							continue
						if(!warband_member.loc)
							continue
						if(isliving(warband_member))
							if(istype(warband_member.loc.loc, /area/rogue/outdoors))
								if(src.mind.special_role == "Warlord")
									to_chat(warband_member, span_highlight("A carrier zad flutters down and perches nearby. It recites a missive clutched in its talons with absolute, cold authority: <span style='color:#[src.voice_color]'>''[sanitized_text]''</span>"))								
								else
									to_chat(warband_member, span_red("A zad-bound message arrives with the seal of the [src.job]: <span style='color:#[src.voice_color]'>''[sanitized_text]''</span> - [src.real_name]"))
							else
								to_chat(warband_member, span_warning("Beyond the walls, I faintly hear a carrier zad [random_tone] in mimicry: <span style='color:#[src.voice_color]'>''[sanitized_text]''</span>"))
	else
		to_chat(src, span_bold("I'll need to be outside."))

// 3
/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ABANDON WARBAND
/* 3
	handles both desertions & exiles

	both aspirant & regular lieutenants can do this - aspirant lieutenants just do so to greater effect

	WHO GETS WHAT IN THE DIVORCE:
		everyone the deserter marked as an ally shifts factions w/them
		the deserter's subordinates shift factions w/them

	it's possible for both parties to become allies again, but it builds up a ton of Disorder between them when they use Associate


*/
/mob/living/carbon/human/proc/desert()
	set name = "DESERT WARBAND"
	set category = "Warband"

	if(src.stat == DEAD)
		to_chat(src, span_boldred("It's too late..."))
		return FALSE
	src.abandon_warband(FALSE, FALSE, FALSE)


/mob/living/carbon/human/proc/abandon_warband(kicked = FALSE, grunt_kick = FALSE, autoresolve = FALSE)
	var/disorder = src.mind.warband_manager.disorder
	var/initial_ID	= src.mind.warband_ID
	var/old_faction_string = "warband_[src.mind.warband_ID]"

	var/troops_available = src.mind.warband_manager.spawns

	var/stolen_troop_percentage
	if(src.mind.special_role == "Aspirant Lieutenant")
		stolen_troop_percentage = 30
	else
		stolen_troop_percentage = 3

	// each point of disorder increases the number of stolen troops by 15%
	stolen_troop_percentage += (disorder * 15)

	var/stolen_troops = round((troops_available * stolen_troop_percentage) / 100)

	if(grunt_kick) // if a grunt is kicked
		for(var/mob/living/bossman in src.mind.warband_manager.members)
			if(isliving(bossman))
				to_chat(bossman, span_boldred("Word spreads that [src.real_name], our [src.job], has been exiled."))
				bossman.playsound_local(bossman, 'sound/misc/warband/exile_warhorn_altb.ogg', 80, FALSE, pressure_affected = FALSE)
			if(bossman.real_name == src.mind.recruiter_name)
				if(!autoresolve) // if we're autoresolving, their direct boss is the one who exiled them, so we can skip past this as they don't need to be alerted
					bossman.mind.unresolved_exile_names += src.real_name
					to_chat(bossman, span_warning("My [src.job] and subordinate, [src.real_name], has been branded an exile by my Warband. I can resolve this (RESOLVE EXILES in the Warband Tab)"))
		to_chat(src, span_boldred("I have been exiled from the Warband."))
		src.faction.Remove(old_faction_string)
		src.faction -= list("warband_[initial_ID]")
		src.mind.warband_manager.members -= src		
		src.mind.warband_manager = null		
		src.mind.warband_ID = 0
		src.mind.warband_exile_IDs += initial_ID
		return

	// if they weren't kicked, they're manually deserting
	if(!kicked) // allows them to Go Out In Style (make an announcement)
		manual_desertion(stolen_troops, troops_available, old_faction_string, initial_ID)

	else // if they WERE kicked
		to_chat(src, span_userdanger("I have been declared an exile by my Warband."))
		src.verbs -= /mob/living/carbon/human/proc/desert
		src.mind.warband_exile_IDs += initial_ID
		for(var/mob/warband_member in src.mind.warband_manager.members)
			if(isliving(warband_member))
				to_chat(warband_member, span_boldred("Word spreads that [src.real_name], our [src.job], has been exiled. [stolen_troops] of our rank-and-file \
				have deserted to accompany them."))
				warband_member.playsound_local(warband_member, 'sound/misc/warband/exile_warhorn_altb.ogg', 100, FALSE, pressure_affected = FALSE)
		desertion_results(stolen_troops, troops_available, old_faction_string, initial_ID)
		return
	return TRUE

// desertion w/announcement
/mob/living/carbon/human/proc/manual_desertion(stolen_troops, troops_available, old_faction_string, initial_ID)
	var/calltext = input("You are preparing to DESERT your Warband. This will be a public declaration. What will you say?", "DESERTION") as text|null
	if(!calltext)
		return
	src.visible_message(span_boldred("[src] blows into a warhorn!"))
	priority_announce("The [src.job] has deserted the [src.mind.warband_manager.selected_warband.name] accompanied by around [stolen_troops] of their rank-and-file. \
	Their words of departure are rumored to be as follows:\n \n [calltext]", title = "WORD SPREADS OF DESERTION", sound = 'sound/misc/warband/exile_warhorn_altb.ogg', sender = src, receiver = /mob/living/carbon/human)
	// if this being a round-wide announcement would be too annoying, it could be restricted to only display to warband members
	// but atm i think it'd be fun to let everyone in on the drama

	if(!src.mind.warband_ID == initial_ID)							// if the initial ID doesn't match, they likely got kicked while they were preparing the message
		to_chat(src, span_userdanger("I've already been exiled."))	// so we'll skip the desertion results
		return
	desertion_results(stolen_troops, troops_available, old_faction_string, initial_ID)

// effects of desertion take place
/mob/living/carbon/human/proc/desertion_results(stolen_troops, troops_available, old_faction_string, initial_ID)
	var/extra_item = FALSE	// for schism variants
	troops_available = src.mind.warband_manager.spawns // reaffirm the available troops | could've changed while a manual desertion message was being typed
	if(stolen_troops > troops_available)
		stolen_troops = troops_available
	src.mind.warband_manager.spawns -= stolen_troops

	src.mind.warband_manager.members -= src

	var/atom/movable/screen/warband/manager/new_warband_manager
	new_warband_manager = new /atom/movable/screen/warband/manager
	new_warband_manager.schism_level = src.mind.warband_manager.schism_level + 1

	src.mind.special_role = "Warlord"
	SSmapping.retainer.warlords |= src.mind	
	src.mind.warband_ID = SSwarbands.warband_managers.len + 1
	new_warband_manager.warband_ID = src.mind.warband_ID
	src.mind.warband_exile_IDs += initial_ID
	src.mind.warband_manager.disorder ++

	src.faction.Remove(old_faction_string)
	src.faction |= list("warband_[src.mind.warband_ID]")


	for(var/mob/living/carbon/human/species/human/northern/grunt/goon in src.friends)
		goon.faction.Remove(old_faction_string)
		goon.faction |= list("warband_[src.mind.warband_ID]")
		goon.warband_ID = src.mind.warband_ID
	new_warband_manager.members += src
	SSwarbands.warband_managers += new_warband_manager

	switch(src.advjob)
		if("Preacher") // a preacher in schism creates a faithlocked sect
			new_warband_manager.selected_warband = new /datum/warbands/sect
			if(src.patron.type in ALL_DIVINE_PATRONS)
				new_warband_manager.selected_subtype = new WARBAND_SECT_TEN
			else if(src.patron.type in ALL_INHUMEN_PATRONS)
				new_warband_manager.selected_subtype = new WARBAND_SECT_FOUR
			else if(src.patron.name == "Psydon")
				new_warband_manager.selected_subtype = new WARBAND_SECT_PSYDON
			new_warband_manager.faithlocks = list(src.patron)

		if("Magician") // a magician in schism (potentially) creates a sorcerer-king 
			if(src.mind.warband_manager.disorder >= 5)
				for(var/obj/item/potential_rod in src.contents) // fixnote: This Shit Don't Work. UUghh h
					if(istype(potential_rod, /obj/item/rogueweapon/woodstaff/riddle_of_steel))
						extra_item = TRUE
						break
			if(extra_item == TRUE)
				new_warband_manager.selected_warband = new /datum/warbands/storyteller/wizard
				to_chat(src, span_boldred("I feel a shift in destiny's tides with my declaration. <span style='color:#801d1d'>The Wandering Tower calls to me.</span>"))
			else
				new_warband_manager.selected_warband = src.mind.warband_manager.selected_warband
				new_warband_manager.selected_subtype = src.mind.warband_manager.selected_subtype
		else
			new_warband_manager.selected_warband = src.mind.warband_manager.selected_warband
			new_warband_manager.selected_subtype = src.mind.warband_manager.selected_subtype

	for(var/mob/living/subordinate in src.mind.subordinates) // bring along associated grunts
		to_chat(subordinate, span_boldred("My Lieutenant has embraced open rebellion. My relations with the [src.mind.warband_manager.selected_warband.name] are in tatters."))
		subordinate.faction.Remove(old_faction_string)
		subordinate.faction |= list("warband_[src.mind.warband_ID]")
		subordinate.mind.warband_manager = new_warband_manager
		subordinate.mind.warband_ID = new_warband_manager.warband_ID
		subordinate.mind.warband_exile_IDs += initial_ID
		src.mind.warband_manager.members -= subordinate
		new_warband_manager.members += subordinate

	for(var/mob/living/ally in src.mind.warband_manager.allies)	// bring along associated allies
		if(ally.mind.recruiter_name == src.real_name)
			if(ally.mind.special_role) // if they were an antagonist, bring their disorder over to the new warband. They're your problem now, Bro.
				src.mind.warband_manager.disorder --
				new_warband_manager.disorder ++
			to_chat(ally, span_boldred("The one who swore I'd be unharmed by the [src.mind.warband_manager.selected_warband.name] has embraced open rebellion. \
			I should assume my accord with their former allies is to be forgotten."))
			ally.faction.Remove(old_faction_string)
			ally.faction |= list("warband_[src.mind.warband_ID]")
			src.mind.warband_manager.allies -= ally
			new_warband_manager.allies += ally
	new_warband_manager.spawns -= WARBAND_BASE_RESPAWNS	// we want their respawns to ONLY!! be drawn from the number of stolen troops
	new_warband_manager.finalized = TRUE
	src.verbs -= /mob/living/carbon/human/proc/abandon_warband
	src.verbs += /mob/living/carbon/human/proc/connect_warcamp
	src.mind.warband_manager = new_warband_manager


// 4
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TAKE SHORTCUT
/* 4
	teleports someone to their camp's Shortcut Tile
	FAILS IF:
		they aren't near an existing travel tile. any will do
		the shortcut tile is disabled/captured
		the camp hasn't been connected to the main z-level via an Envoy using a "SCOUT A PATH" verb
*/ 
/mob/living/carbon/human/proc/shortcut()
	set name = "TAKE SHORTCUT"
	set desc = "Attempt to take a shortcut to your warcamp."
	set category = "Warband"

	var/can_shortcut = FALSE
	if(!src.mind.warband_manager)
		to_chat(src, span_warning("There's nowhere for me to go. I am alone."))
		return


	if(!src.mind.warband_manager.outskirts_established)
		to_chat(src, span_bold("Before I can take a shortcut back to the Warcamp, an ENVOY needs to Scout a Path."))
		return

	for(var/obj/structure/object in range(1, src))
		if(istype(object, /obj/structure/fluff/traveltile) || istype(object, /obj/structure/far_travel))
			can_shortcut = TRUE
			break

	if(!can_shortcut)
		to_chat(src, span_bold("Should I find a Travel Tile of any kind, I can TAKE A SHORTCUT back to my Warcamp."))
		return

	if(do_after(src, 100, FALSE, src))
		for(var/obj/structure/fluff/warband/shortcut/warband_shortcut in SSwarbands.warband_machines)
			if(warband_shortcut.warband_ID == src.mind.warband_ID)
				if(warband_shortcut.disabled)
					to_chat(src, span_userdanger("Something's wrong. I've been cut off, and I'll need to return through the frontline."))
				else
					src.visible_message(span_bold("[src] slips somewhere beyond sight!"))
					src.loc = warband_shortcut.loc
				break 
		return TRUE



	return TRUE

// 5
/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CONNECT WARCAMP
/* 5
	spawns a travel tile to a newly spawned set of intermission & outskirts maps, which connect to the warcamp
	the spawned maps vary depending on where the travel tile is spawned
	
	requires a rock wall nearby
	area limited

	spawns a few extra tiles near the first that will try to place themselves adjacent to a rock wall

*/
/mob/living/carbon/human/proc/connect_warcamp()
	set name = "SCOUT PATH TO WARCAMP"
	set category = "Warband"

	if(SSwarbands.warband_managers_busy == TRUE) // we don't want multiple maps getting spawned at the same time
		to_chat(src, span_userdanger("I'll need to wait for a moment."))

	var/area/zone = src.loc.loc

	var/list/allowed_area_types = list(
		/area/rogue/under/underdark,
		/area/rogue/under/cave,
		/area/rogue/under/cavewet,
		/area/rogue/outdoors/woods,
		/area/rogue/outdoors/bog,
		/area/rogue/outdoors/mountains/decap,
		/area/rogue/outdoors/beach,
		/area/rogue/outdoors/mountains
	)
	var/list/blacklisted_area_types = list(
		/area/rogue/outdoors/beach/forest/hamlet
	)

	var/is_allowed = FALSE
	for(var/type_path in allowed_area_types)
		if(istype(zone, type_path))
			is_allowed = TRUE
			break

	if(!is_allowed)
		to_chat(src, span_danger("This isn't a suitable location."))        
		return

	var/has_mineral_turf = locate(/turf/closed/mineral) in range(1, src)
	if(!has_mineral_turf)
		to_chat(src, span_green("This is a good location. I should get my bearings beside a ROCK WALL before I plot a route back to camp."))		
		return


	if(is_allowed && !istype(zone, blacklisted_area_types))
		if(SSwarbands.warband_managers_busy == TRUE)	// we don't want multiple maps getting spawned at the same time
			to_chat(src, span_userdanger("I'll need to wait for a moment."))
			return

		if(src.mind.warband_manager.outskirts_established == TRUE)
			to_chat(src, span_userdanger("A path has already been scouted."))
			return

		for(var/turf/nearby_turf in range(4, src))
			if(nearby_turf.contents == /obj/structure/fluff/traveltile)
				to_chat(src, span_userdanger("I'm too close to an existing path."))				
				return

		if(!src.mind.warband_manager.warcamp_established) // if this is being done without a warcamp, we check if there's a free space.
			var/obj/effect/landmark/warcamp/found_slot
			for(var/obj/effect/landmark/warcamp/open_warcamp_slot in GLOB.landmarks_list)
				found_slot = TRUE
				break
			if(!found_slot)
				to_chat(src, span_userdanger("The entire countryside is occupied. I can't establish a Warcamp."))
				if(src.mind.special_role == "Warlord") // if they're a warlord, assume they're a deserter and let them place a Recruitment Point
					to_chat(src, span_userdanger("I can, however, declare a Recruitment Point to rally my troops..."))
					if(do_after(src, 90, target = src))
						new /obj/structure/fluff/warband/warband_recruit(src)
						src.mind.warband_manager.warcamp_established = TRUE
				return

		SSwarbands.warband_managers_busy = TRUE
		src.visible_message(span_notice("[src] begins scouting for a new path..."))

		if(do_after(src, 30, target = src))
			var/chosen_outskirts_map
			var/chosen_intermission_map

			if(istype(zone, /area/rogue/under/cave) || istype(zone, /area/rogue/under/underdark) || istype(zone, /area/rogue/under/cavewet) || istype(zone, /area/rogue/indoors/cave) || istype(zone, /area/rogue/outdoors/caves))
				chosen_outskirts_map = pick(list(/datum/map_template/outskirts/cave_a))
				chosen_intermission_map = pick(list(/datum/map_template/intermission/cave_a))
			else if(istype(zone, /area/rogue/outdoors/mountains) || istype(zone, /area/rogue/outdoors/mountains/decap))
				chosen_outskirts_map = pick(list(/datum/map_template/outskirts/mountains_a))
				chosen_intermission_map = pick(list(/datum/map_template/intermission/mountains_a))
			else if(istype(zone, /area/rogue/outdoors/beach))
				chosen_outskirts_map = pick(list(/datum/map_template/outskirts/coast_a))
				chosen_intermission_map = pick(list(/datum/map_template/intermission/coast_a))
			else if(istype(zone, /area/rogue/outdoors/woods))
				chosen_outskirts_map = pick(list(/datum/map_template/outskirts/river_a))
				chosen_intermission_map = pick(list(/datum/map_template/intermission/woods_a))
			else if(istype(zone, /area/rogue/outdoors/bog))
				chosen_outskirts_map = pick(list(/datum/map_template/outskirts/bog_a))
				chosen_intermission_map = pick(list(/datum/map_template/intermission/bog_a))

			if(!chosen_outskirts_map || !chosen_intermission_map) // this shouldn't happen | if you've added a new area, make sure it's in the allowed_area_types at the start of this proc, AND the type selection above this line
				to_chat(src, span_userdanger("Something's wrong. I should attempt this somewhere else."))
				SSwarbands.warband_managers_busy = FALSE
				return
			if(src.mind.warband_manager.outskirts_established == TRUE)
				to_chat(src, span_userdanger("A path has already been scouted."))
				return
			var/outskirts_landmark_found = FALSE
			var/obj/effect/landmark/warcamp_outskirts/used_outskirts_landmark
			for(var/obj/effect/landmark/warcamp_outskirts/outskirts_landmark in GLOB.landmarks_list)
				var/datum/map_template/new_outskirts = new chosen_outskirts_map()
				new_outskirts.load(outskirts_landmark.loc, centered = TRUE)
				used_outskirts_landmark = outskirts_landmark
				outskirts_landmark_found = TRUE
				break

			if(used_outskirts_landmark)
				qdel(used_outskirts_landmark)

			var/intermission_landmark_found = FALSE
			var/obj/effect/landmark/warcamp_intermission/used_intermission_landmark
			for(var/obj/effect/landmark/warcamp_intermission/intermission_landmark in GLOB.landmarks_list)
				var/datum/map_template/new_intermission = new chosen_intermission_map()
				new_intermission.load(intermission_landmark.loc, centered = TRUE)
				used_intermission_landmark = intermission_landmark
				intermission_landmark_found = TRUE
				break

			if(used_intermission_landmark)
				qdel(used_intermission_landmark)

			// spawns the travel tiles to the intermission
			// attempts to get the spawned tiles to hug the wall
			if(outskirts_landmark_found && intermission_landmark_found)
				src.visible_message(span_info("[src] reveals a path to the Warcamp!"))
				src.mind.warband_manager.outskirts_established = TRUE
				var/obj/structure/fluff/traveltile/warband/new_path = new /obj/structure/fluff/traveltile/warband/azure_to_intermission(src.loc)
				new_path.warband_ID = src.mind.warband_ID

				var/list/spawn_locations = list()
				var/list/preferred_spawn_locations = list()
				var/turf/user_turf = src.loc

				for(var/turf/T in range(1, user_turf))
					if(istype(T, /turf/open/floor) && T != user_turf) // not the turf we're on
						spawn_locations += T
						for(var/turf/neighbor_turf in range(1, T))
							if(istype(neighbor_turf, /turf/closed/mineral))
								preferred_spawn_locations += T
								break

				// create a warcamp next, if there's an available space and no warcamp
				// guaranteed to be the case during a Desertion
				if(src.mind.warband_manager.warcamp_established == FALSE)
					for(var/obj/effect/landmark/warcamp/open_warcamp_slot in GLOB.landmarks_list)
						src.mind.warband_manager.choose_map(latespawn = TRUE)
						break

				var/list/final_spawn_locations
				if(preferred_spawn_locations.len >= 2)
					final_spawn_locations = preferred_spawn_locations
				else
					final_spawn_locations = spawn_locations

				final_spawn_locations = shuffle(final_spawn_locations)

				var/tiles_to_place = min(2, final_spawn_locations.len)

				for(var/i = 1, i <= tiles_to_place, i++)
					var/turf/chosen_turf = final_spawn_locations[i]
					var/obj/structure/fluff/traveltile/warband/new_tile = new /obj/structure/fluff/traveltile/warband/azure_to_intermission(chosen_turf)
					new_tile.warband_ID = src.mind.warband_ID

				src.mind.warband_manager.set_IDs()
				src.mind.warband_manager.link_portals()					
				SSwarbands.warband_managers_busy = FALSE
			else
				return
		else
			src.visible_message(span_warning("[src] halts their scouting."))
			SSwarbands.warband_managers_busy = FALSE
			return
	else
		to_chat(src, span_warning("This isn't a suitable location."))
		return

	return TRUE

// 6
/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ACCEPT KICK
/* 6
	when a lieutenant's subordinate is exiled by their warlord, they are given a choice

	DEFY EXILE
		the subordinate keeps their lieutenant's mob faction
		exile is defied by default (otherwise, a subordinate getting exiled mid-coup (and seperately from the lieutenant) could result in a bunch of Silly Situations)
		this just affirms it

	ACCEPT
		the subordinate is removed from their lieutenant's mob faction
		the subordinate is removed from their lieutenant's list of subordinates
		alternatively, they can just directly use the Exile spell on them to the same effect



*/
/mob/living/carbon/human/proc/accept_kick()
	set name = "RESOLVE EXILES"
	set category = "Warband"

	var/mob/living/carbon/human/target
	var/personal_faction_tag = "[src.real_name]_faction"

	if(!src.mind.unresolved_exile_names.len)
		to_chat(src, span_warning("There are no decrees I must resolve."))
		return

	var/exile_choice = input(src, "Who should I settle?", "EXILE") as null|anything in src.mind.unresolved_exile_names
	if(exile_choice)
		for(var/mob/living/carbon/human/exile in GLOB.player_list) // get the mob w/the exile's name
			if(exile.real_name == exile_choice)
				target = exile
				break
	else
		return



	if(!target)
		to_chat(src, span_warning("They're gone. I should consider the matter resolved."))
		src.mind.unresolved_exile_names -= exile_choice
		return

	if(!(target.real_name in src.mind.unresolved_exile_names))
		to_chat(src, span_warning("I've already made a decision."))
		return

	var/readycheck = input(src, "Will I endorse the exile of [target.real_name]?") in list("Defy Exile (Keep as Personal Associate)", "Accept (Cut Ties)", "Cancel")

	if(!target) // last check, in case they far travel mid deliberation
		to_chat(src, span_warning("They're gone. I should consider the matter resolved."))
		src.mind.unresolved_exile_names -= exile_choice
		return

	if(readycheck == "Defy Exile (Keep as Personal Associate)")
		if(target && target.mind.recruiter_name != src.real_name) // if they have a new recruiter, set the recruiter back to us
			target.mind.recruiter_name = src.real_name
		for(var/mob/warband_member in src.mind.warband_manager.members)
			if(isliving(warband_member))
				to_chat(warband_member, span_warning("A zad arrives with the [src.job]'s seal. They reject the decree of [target.real_name]'s exile, and have ordered their own men to treat [target.real_name] as an associate."))
		src.mind.unresolved_exile_names -= target.real_name

	if(readycheck == "Accept (Cut Ties)")
		if(personal_faction_tag in target.faction)
			target.faction -= personal_faction_tag

		for(var/mob/warband_member in src.mind.warband_manager.members)
			if(isliving(warband_member))
				to_chat(warband_member, span_warning("A zad arrives with the [src.job]'s seal. They have embraced the decree of [target.real_name]'s exile."))
		if(target && target.mind.recruiter_name != src.real_name) // if they have a new recruiter, another lieutenant stole them, so we stop here
			src.mind.subordinates -= target
			src.mind.unresolved_exile_names -= target.real_name			
			return
		
		src.mind.unresolved_exile_names -= target.real_name

		target.mind.recruiter_name = null

	else
		return
