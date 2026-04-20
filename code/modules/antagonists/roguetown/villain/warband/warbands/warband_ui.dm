// gets the warband associated with the user
// creates an instance of the BEGIN hud (the thing we're using for warband & character creation)
/atom/movable/screen/warband/manager/proc/create_HUD_instance(mob/user)
	for(var/atom/movable/screen/warband/manager/listed_manager in SSwarbands.warband_managers)
		if(listed_manager.warband_ID == user.mind.warband_ID)
			user.client.screen += listed_manager
			animate(listed_manager, alpha = 255, time = 800)
			break

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

	// a list of important figures in town | used in the 'know thy enemy' list in the creation menu | helps in plotting an initial gimmick
	for(var/mob/living/carbon/human/quote_importantperson_unquote in src.importantfigures)
		UNTYPED_LIST_ADD(noble_list, list(
			"name" = quote_importantperson_unquote.real_name,
			"job" = quote_importantperson_unquote.job
		))
	data["nobles"] = noble_list

	// a list of teammates (living)
	for(var/mob/living/carbon/human/buddy in src.members)	
		var/member_role = buddy.mind?.special_role || "Unknown"
		UNTYPED_LIST_ADD(allies_list, list(
			"name" = buddy.real_name,
			"job" = buddy.job,
			"special_role" = member_role,
			"in_lobby" = FALSE
		))

	// a list of teammates (in the lobby)
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

	// casus belli voting state (per-user)
	var/user_ckey = user.ckey
	var/user_proposal_id_out	// proposal_id of the term the user authored
	var/user_vote_id_out 		// proposal_id of the term the user is voting on
	var/user_vote_confirmed_flag = FALSE
	var/warlord_selected_id		// proposal_id the warlord has selected
	var/list/proposals_out = list()

	for(var/list/proposal in src.casus_belli_proposals)
		var/list/confirmed_votes = proposal["confirmed_votes"]
		var/list/pending_votes = proposal["pending_votes"]
		var/is_user_proposal = (proposal["author"] == user_ckey)
		var/user_is_pending = (user_ckey in pending_votes)
		var/user_vote_confirmed = (user_ckey in confirmed_votes)
		var/is_user_vote = user_is_pending || user_vote_confirmed
		if(is_user_proposal)
			user_proposal_id_out = proposal["proposal_id"]
		if(is_user_vote)
			user_vote_id_out = proposal["proposal_id"]
			user_vote_confirmed_flag = user_vote_confirmed
		if(proposal["is_selected"])
			warlord_selected_id = proposal["proposal_id"]
		var/list/details = proposal["term_details"] || list()
		UNTYPED_LIST_ADD(proposals_out, list(
			"proposal_id" = proposal["proposal_id"],
			"term_type" = proposal["term_type"],
			"term_name" = proposal["term_name"],
			"term_desc" = proposal["term_desc"],
			"vote_count" = confirmed_votes.len,
			"pending_count" = pending_votes.len,
			"is_user_proposal" = is_user_proposal,
			"is_user_vote_confirmed" = user_vote_confirmed,
			"is_warlord_selected" = proposal["is_selected"],
			"term_custom_name" = details["custom_name"],
			"term_text" = details["text"],
			"term_number" = details["number"],
			"term_target" = details["target"],
			"term_receiver" = details["receiver"],
			"term_obj_target" = details["obj_target"]
		))
	data["casus_belli_proposals"] = proposals_out
	data["user_proposal"] = user_proposal_id_out
	data["user_vote"] = user_vote_id_out
	data["user_vote_confirmed"] = user_vote_confirmed_flag
	data["warlord_selected_proposal"] = warlord_selected_id

	if(src.casus_belli_selection)
		data["warlord_casus_belli"] = list(
			"name" = src.casus_belli_selection.name,
			"desc" = src.casus_belli_selection.desc,
			"type" = "[src.casus_belli_selection.type]",
			"target_options" = src.casus_belli_selection.target_options,
			"requires_text" = src.casus_belli_selection.requires_text,
			"requires_number" = src.casus_belli_selection.requires_number,
			"open_signatures" = src.casus_belli_selection.open_signatures,
			"target" = src.casus_belli_selection.target,
			"receiver" = src.casus_belli_selection.receiver,
			"obj_target" = src.casus_belli_selection.obj_target,
			"text" = src.casus_belli_selection.text,
			"number" = src.casus_belli_selection.number,
			"custom_name" = src.casus_belli_selection.custom_name
		)
	else
		data["warlord_casus_belli"] = null

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

	if(!static_data_set) // we want to be absolutely sure we're only checking storytellers Once
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

	// faction & territory data for drafting terms that need targets
	var/list/cb_faction_list = list()
	for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
		if(faction.type in DEFAULT_TERRITORY_FACTIONS)
			UNTYPED_LIST_ADD(cb_faction_list, list(
				"name" = faction.name,
				"desc" = faction.desc,
				"vault" = faction.vault,
				"owner" = faction.owner,
				"territories" = list(),
				"type" = "[faction.type]",
				"icon" = ""
			))

	if(src.linked_faction)
		UNTYPED_LIST_ADD(cb_faction_list, list(
			"name" = src.linked_faction.name,
			"desc" = src.linked_faction.desc,
			"vault" = src.linked_faction.vault,
			"owner" = src.linked_faction.owner,
			"territories" = list(),
			"type" = "[src.linked_faction.type]",
			"icon" = ""
		))
	data["backend_factions"] = cb_faction_list

	var/list/cb_territory_list = list()
	for(var/datum/territory/land in SSwarbands.territory)
		var/cb_faction_name
		if(land.associated_faction)
			cb_faction_name = land.associated_faction.name
		var/list/aspect_data = list()
		if(land.aspects && islist(land.aspects))
			for(var/datum/territory/aspect/asp in land.aspects)
				if(istype(asp))
					aspect_data += list(list("name" = asp.name, "desc" = asp.desc))
		var/prized_good_name
		if(land.prized_good)
			prized_good_name = land.prized_good.name
		UNTYPED_LIST_ADD(cb_territory_list, list(
			"name" = land.name,
			"desc" = land.desc,
			"prized_good" = prized_good_name,
			"faction_name" = cb_faction_name,
			"aspects" = aspect_data
		))
	data["backend_territories"] = cb_territory_list

	// a list of treaty terms for casus belli browsing & proposal
	// gets rebuilt in stage 2, as the decisions in stage 1 can potentially make more available
	var/obj/item/treaty/temp_treaty = new /obj/item/treaty()
	if(src.creation_stage >= 2 && src.selected_warband)
		temp_treaty.add_unique_terms(src)
	var/list/all_terms_list = list()
	for(var/datum/treaty/terms/term in temp_treaty.terms)
		UNTYPED_LIST_ADD(all_terms_list, list(
			"name" = term.name,
			"desc" = term.desc,
			"hint" = term.hint,
			"requires_text" = term.requires_text,
			"requires_number" = term.requires_number,
			"open_signatures" = term.open_signatures,
			"target_options" = term.target_options,
			"type" = "[term.type]",
			"warbandlock" = (term.warbandlock ? "[term.warbandlock]" : null)
		))
	qdel(temp_treaty)
	data["all_terms"] = all_terms_list
	src.static_data_set = TRUE
	return data


/atom/movable/screen/warband/manager/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr

	var/user_key = user.ckey
	if(last_action_time[user_key] && world.time < last_action_time[user_key] + 10)
		return TRUE // slight throttling to all of the UI actions
	
	last_action_time[user_key] = world.time

	switch(action)
		if("swap_character_slot")
			select_pref_slot(user)
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
				to_chat(user, span_warning("Wait for the Warlord to be finalized, first."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			SStgui.close_user_uis(user)
			user.mind.warband_manager = src
			var/class_path = text2path(params["class"])
			var/subclass_path = text2path(params["subclass"])
			if(user in src.lobby_members)
				lobby_members -= user
			load_appearance(user, user)
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

			// stage 1 -> 2: commit the warband selection and move to casus belli phase
			// the warband's mob cache will start filling up at this point, too
			if(src.creation_stage == 1)
				var/warband_path = text2path(params["warband"])
				if(!warband_path || !SSwarbands.warband_lookup[warband_path])
					to_chat(user, span_warning("Select a valid warband before advancing."))
					user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
					return
				src.selected_warband = SSwarbands.warband_lookup[warband_path]
				var/subtype_path = text2path(params["subtype"])
				if(subtype_path && SSwarbands.subtype_lookup[subtype_path])
					src.selected_subtype = SSwarbands.subtype_lookup[subtype_path]
				var/list/aspect_paths = params["aspects"]
				for(var/aspect_path in aspect_paths)
					var/aspect_type = text2path(aspect_path)
					if(aspect_type && SSwarbands.aspect_lookup[aspect_type])
						src.selected_aspects += SSwarbands.aspect_lookup[aspect_type]
				if(!src.linked_faction)
					var/datum/territory_faction/custom/seed_faction = new /datum/territory_faction/custom()
					SSwarbands.territory_factions += seed_faction	// added first so verify_faction_name sees it
					seed_faction.name = seed_faction.verify_faction_name("The Warband", null)
					src.linked_faction = seed_faction
				src.creation_stage = 2
				SStgui.update_uis(user)
				for(var/mob/living/carbon/human/member in src.lobby_members)
					to_chat(member, span_greenteamradio("The Warlord has chosen a warband. But what are you fighting for? Propose a Casus Belli."))
					SStgui.update_uis(member)
					update_static_data(member)
				envy_check()
				set_race_and_faith_locks()
				notify_sect()
				send_warnings()	
				reset_creation_timer()							
				return

			// stage 2 -> 3: commit the casus belli and open up class selection & finalization
			if(src.creation_stage == 2)
				if(!src.casus_belli_selection)
					to_chat(user, span_warning("A casus belli must be chosen before advancing."))
					user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
					return
				src.creation_stage = 3
				reset_creation_timer()

				for(var/mob/living/carbon/human/member in src.lobby_members)
					to_chat(member, span_greenteamradio("The Warlord has advanced to class selection. You may now choose your class."))
					SStgui.update_uis(member)
					update_static_data(member)
				return

		// warband finalization
		// spawns the map & the warlord
		if("create_warband")
			if(user.mind.special_role != "Warlord")
				to_chat(user, span_warning("Only the Warlord may finalize the warband."))
				user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
				return
			if(src.creation_stage != 3)
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
			load_appearance(user, user)
			lock_check(user) 		// checks if the warlord is breaking any faith or species limits, and corrects them if so
			apply_sect_faithlock(user)
			spawn_warband(user) 	// this spawns the map, too
			set_IDs()
			if(src.linked_faction && !src.linked_faction.owner)
				src.linked_faction.owner = user.real_name
				src.linked_faction.name = src.linked_faction.verify_faction_name("[user.real_name]'s Warband", user)
			// we use "The Warband" as a placeholder faction for the UI. once we're actually in-game, we need to update it
			if(src.casus_belli_selection && src.linked_faction)
				var/real_name = src.linked_faction.name
				if(src.casus_belli_selection.target == "The Warband") 
					src.casus_belli_selection.target = real_name
				if(src.casus_belli_selection.receiver == "The Warband") 
					src.casus_belli_selection.receiver = real_name
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

		// submits a term to the list of casus belli proposals
		// big, but this is rate limited so it should be fine
		if("propose_casus_belli")
			var/term_type_str = params["term_type"]
			var/term_name = params["term_name"]
			if(!term_type_str || !term_name)
				return
			var/found_type = text2path(term_type_str)
			if(!found_type)
				return
			var/list/term_details = list()
			if(params["custom_name"])
				term_details["custom_name"] = sanitize(copytext(params["custom_name"], 1, MAX_MESSAGE_LEN))
			if(params["text"])
				term_details["text"] = sanitize(copytext(params["text"], 1, MAX_MESSAGE_LEN))
			if(params["number"])
				term_details["number"] = text2num(params["number"])
			if(params["target"]) // copytext rather than sanitize at this point, because factions are already set in stone. nothing to worry about
				term_details["target"] = copytext(params["target"], 1, MAX_MESSAGE_LEN)
			if(params["receiver"])
				term_details["receiver"] = copytext(params["receiver"], 1, MAX_MESSAGE_LEN)
			if(params["obj_target"])
				term_details["obj_target"] = copytext(params["obj_target"], 1, MAX_MESSAGE_LEN)

			// removes authorship from the previous proposal BEFORE the duplicate check
			for(var/list/existing in src.casus_belli_proposals)
				if(existing["author"] == user.ckey)
					existing["author"] = null
					var/list/existing_confirmed = existing["confirmed_votes"]
					var/list/existing_pending = existing["pending_votes"]
					if(!existing_confirmed.len && !existing_pending.len)
						src.casus_belli_proposals -= list(existing)
					break

			var/datum/treaty/terms/new_term = new found_type()
			if(term_details["text"]) 
				new_term.text = term_details["text"]
			if(term_details["number"]) 
				new_term.number = term_details["number"]
			if(term_details["target"]) 
				new_term.target = term_details["target"]
			if(term_details["receiver"]) 
				new_term.receiver = term_details["receiver"]
			if(term_details["obj_target"]) 
				new_term.obj_target = term_details["obj_target"]

			// check for duplicate proposals
			for(var/list/existing_proposal in src.casus_belli_proposals)
				var/existing_type = text2path(existing_proposal["term_type"])
				if(!existing_type)
					continue
				var/datum/treaty/terms/existing_term = new existing_type()
				var/list/ed = existing_proposal["term_details"] || list()
				if(ed["text"]) 
					existing_term.text = ed["text"]
				if(ed["number"]) 
					existing_term.number = ed["number"]
				if(ed["target"]) 
					existing_term.target = ed["target"]
				if(ed["receiver"]) 
					existing_term.receiver = ed["receiver"]
				if(ed["obj_target"]) 
					existing_term.obj_target = ed["obj_target"]

				var/is_dup = FALSE
				if(istype(new_term, /datum/treaty/terms/territory_loss) && istype(existing_term, /datum/treaty/terms/territory_loss))
					is_dup = (new_term.obj_target == existing_term.obj_target)
				else if(istype(new_term, /datum/treaty/terms/cointribute) && istype(existing_term, /datum/treaty/terms/cointribute))
					is_dup = (new_term.target == existing_term.target && new_term.receiver == existing_term.receiver)
				else if(istype(new_term, /datum/treaty/terms/exile) && istype(existing_term, /datum/treaty/terms/exile))
					is_dup = (new_term.target == existing_term.target)
				else if(istype(new_term, /datum/treaty/terms/remove_law) && istype(existing_term, /datum/treaty/terms/remove_law))
					is_dup = (new_term.number == existing_term.number)
				else if(istype(new_term, /datum/treaty/terms/codify_law) && istype(existing_term, /datum/treaty/terms/codify_law))
					is_dup = (new_term.text == existing_term.text)
				else if(istype(new_term, /datum/treaty/terms/set_tax) && istype(existing_term, /datum/treaty/terms/set_tax))
					is_dup = (new_term.number == existing_term.number)

				qdel(existing_term)

				if(is_dup)
					qdel(new_term)
					to_chat(user, span_warning("An identical proposition already exists. Your proposal was cancelled."))
					user.playsound_local(user, 'sound/misc/warband/menusound_fail.ogg', 100, FALSE)
					return

			qdel(new_term)
			user.playsound_local(user, 'sound/misc/warband/menusound1.ogg', 100, FALSE)
			var/term_desc = ""
			var/datum/treaty/terms/proto = new found_type()
			term_desc = proto.desc
			qdel(proto)
			var/new_proposal_id = "[user.ckey]_[world.time]"
			var/list/new_proposal = list(
				"proposal_id" = new_proposal_id,
				"term_type" = term_type_str,
				"term_name" = term_name,
				"term_desc" = term_desc,
				"term_details" = term_details,
				"author" = user.ckey,
				"confirmed_votes" = list(),
				"pending_votes" = list(),
				"is_selected" = FALSE
			)
			src.casus_belli_proposals += list(new_proposal)
			SStgui.update_uis(src)
			return

		// vote on a proposal
		if("vote_casus_belli")
			if(user.mind.special_role == "Warlord")
				return
			var/target_id = params["proposal_id"]
			if(!target_id)
				return
			// if they already have a confirmed vote, cancel it
			for(var/list/proposal in src.casus_belli_proposals)
				if(user.ckey in proposal["confirmed_votes"])
					return
			// if they're already pending on the chosen proposal, toggle it off
			var/already_pending = FALSE
			for(var/list/proposal in src.casus_belli_proposals)
				if(proposal["proposal_id"] == target_id)
					if(user.ckey in proposal["pending_votes"])
						already_pending = TRUE
					break
			// if they have a vote pending elsewhere, remove them
			for(var/list/proposal in src.casus_belli_proposals)
				proposal["pending_votes"] -= user.ckey
			if(!already_pending)
				for(var/list/proposal in src.casus_belli_proposals)
					if(proposal["proposal_id"] == target_id)
						proposal["pending_votes"] += user.ckey
						break
			SStgui.update_uis(src)
			return

		// lock in your pending vote
		if("confirm_casus_belli")
			if(user.mind.special_role == "Warlord")
				return
			var/target_id = params["proposal_id"]
			if(!target_id)
				return
			for(var/list/proposal in src.casus_belli_proposals)
				if(proposal["proposal_id"] == target_id && (user.ckey in proposal["pending_votes"]))
					proposal["pending_votes"] -= user.ckey
					proposal["confirmed_votes"] += user.ckey
					user.playsound_local(user, 'sound/misc/warband/menusound1.ogg', 100, FALSE)
					SStgui.update_uis(src)
					return
			return

		// warlord only | selects a proposal as the warband's casus belli
		if("select_casus_belli")
			if(user.mind.special_role != "Warlord")
				return
			var/target_id = params["proposal_id"]
			if(!target_id)
				return
			var/list/target_proposal
			for(var/list/proposal in src.casus_belli_proposals)
				if(proposal["proposal_id"] == target_id)
					target_proposal = proposal
					break
			if(!target_proposal)
				return
			var/found_type = text2path(target_proposal["term_type"])
			if(!found_type)
				return
			var/was_selected = target_proposal["is_selected"]
			for(var/list/proposal in src.casus_belli_proposals)
				proposal["is_selected"] = FALSE
			if(src.casus_belli_selection && was_selected)
				qdel(src.casus_belli_selection)
				src.casus_belli_selection = null
			else
				target_proposal["is_selected"] = TRUE
				if(src.casus_belli_selection)
					qdel(src.casus_belli_selection)
				src.casus_belli_selection = new found_type()
				var/list/details = target_proposal["term_details"] || list()
				if(details["custom_name"]) 
					src.casus_belli_selection.custom_name = details["custom_name"]
				if(details["text"]) 
					src.casus_belli_selection.text = details["text"]
				if(details["number"]) 
					src.casus_belli_selection.number = details["number"]
				if(details["target"]) 
					src.casus_belli_selection.target = details["target"]
				if(details["receiver"]) 
					src.casus_belli_selection.receiver = details["receiver"]
				if(details["obj_target"]) 
					src.casus_belli_selection.obj_target = details["obj_target"]
			SStgui.update_uis(src)
			return

		// view a list of the current laws
		if("view_laws")
			to_chat(user, span_greenteamradio("AZURIA'S LAWS ARE AS FOLLOWS:"))
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
			for(var/law in GLOB.laws_of_the_land)
				to_chat(user, span_memo(law))
			return

		// view a list of the current decrees
		if("view_decrees")
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
			for(var/decree in GLOB.lord_decrees)
				to_chat(user, span_memo(decree))
			return

		// view the flavortext of a given character
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
				SStgui.close_user_uis(usr, /datum/examine_panel)
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
