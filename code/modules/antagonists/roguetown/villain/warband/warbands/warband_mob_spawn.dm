
/*	
	CHARACTER SPAWNING
	- everything that happens as a character is spawned from the lobby

	1 - SPAWN CHARACTER			// spawn a character w/the options selected from the warband hud
	2 - EQUIP CHARACTER			// final step of spawning a character | equips them, sets their traits + adds them to the faction			
	3 - ASSIGN GRUNT			// binds lieutenants to grunts and vice versa	
	4 - CHANGE CHARACTER		// changes the current character slot
	5 - LOAD CHARACTER			// loads the current character slot
	6 - STAT WIPE				// performs a full stat & trait wipe on the target mob
	7 - GIVE TREATY				// hands out a treaty item to a Warlord or Lieutenant on spawn
	8 - RANDOM CLASSES			// generates 3 random classes for the Wildcard class
	9 - DETERMINE SQUAD SIZE	// decide the size of a character's NPC squad

*/


///////////////////////////////////////////////////
/////////////////////////////////// SPAWN CHARACTER
/*
	if they're the warlord, move them to their warcamp's warlord spawn landmark, then delete said landmark
		adds them to the warband manager's members list
		gives them:
			knowledge of other members in the warband
			knowledge of important figures in the duchy
			the baseline warband verbs (shortcut & communicate)

*/
/atom/movable/screen/warband/manager/proc/spawn_character(classpath, mob/user, subclasspath, is_leader, is_latespawn = FALSE)
	// getting the classes provided from the lobby
	// they're gonna be passed along to equip_character
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
			src.warband_spawn_turf = warlord_landmark_turf // if we couldn't find one, we'll fall back to where the warlord's landmark was
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

///////////////////////////////////////////////////
/////////////////////////////////// EQUIP CHARACTER
/*
	equips them w/the provided advclasses
	gives them the baseline Warband traits (at the moment: Battle Ready & No XP)
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

//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ASSIGN GRUNT
/*
	binds lieutenants to grunts and vice versa, depending on the provided arguments
	limit of 2 grunts per lieutenant
	
	MODES:
	1. lieutenant provided: when a lieutenant spawns, collect all unassigned grunts. add them to the mind.subordinates list
	2. grunt provided: when a grunt spawns, find them a lieutenant. add their name to the grunt's mind.warband_recruiter_name entry, and adds themselves to the lieutenant's mind
	
*/
/atom/movable/screen/warband/manager/proc/assign_grunt(mob/living/carbon/human/lieutenant, mob/living/carbon/human/grunt)
	// MODE 1: lieutenant spawns
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
			if(assigned_count >= 2)
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

//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CHANGE CHARACTER
/*
	changes the client's active character slot
	this is effectively just the 'change character' button in the pref menu

*/
/atom/movable/screen/warband/manager/proc/select_pref_slot(mob/user)
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

//////////////////////////////
////////////// LOAD APPEARANCE
/*
	applies the client's active character slot to the current mob

*/ 
/atom/movable/screen/warband/manager/proc/load_appearance(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.client.prefs.copy_to(target)
	target.dna.update_dna_identity()
	statwipe(target)
	GLOB.chosen_names += target.real_name

//////////////////////////////////////////////////////////
///////////////////////////////////////////////// STAT WIPE
/*
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

/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// GIVE TREATY
/* 
	after a tiny delay, gives recently-spawned warlords & lieutenants a free treaty

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

//////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// DETERMINE SQUAD SIZE
/*
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

////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// RANDOM CLASSES
/*
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
