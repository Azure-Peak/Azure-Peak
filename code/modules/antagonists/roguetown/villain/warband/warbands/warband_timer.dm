/*	
	LOBBY TIMER
	- forces people through the creation process at certain intervals
	- eventually auto-finalizes the warband if the clock runs out

	1 - START CREATION TIMER	// starts the creation phase countdown
	2 - SEND WARNING			// sends a warning to anyone in the lobby at the halfway point
	3 - STOP CREATION TIMER		// stops the timer
	4 - TRIGGER TIMEOUT			// fires when time fully expires
	5 - FORCE WARBAND SPAWN		// auto-finalizes the warband if time runs out
	6 - GET REMAINING TIME		// returns remaining creation time in deciseconds

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
		var/subclass_path
		
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
		load_appearance(warlord, warlord)
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
