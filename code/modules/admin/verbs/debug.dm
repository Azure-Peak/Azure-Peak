/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if(!check_rights(R_DEBUG))
		return

	if(GLOB.Debug2)
		GLOB.Debug2 = 0
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		GLOB.Debug2 = 1
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Debug Two") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!



/* 21st Sept 2010
Updated by Skie -- Still not perfect but better!
Stuff you can't do:
Call proc /mob/proc/Dizzy() for some player
Because if you select a player mob as owner it tries to do the proc for
/mob/living/carbon/human/ instead. And that gives a run-time error.
But you can call procs that are of type /mob/living/carbon/human/proc/ for that player.
*/
/client/proc/cmd_admin_animalize(mob/M in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "Make Simple Animal"

	if(!SSticker.HasRoundStarted())
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(isnewplayer(M))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	INVOKE_ASYNC(M, TYPE_PROC_REF(/mob, Animalize))

//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all(object as text)
	set category = "Debug"
	set name = "Del-All"

	var/list/matches = get_fancy_list_of_atom_types()
	if (!isnull(object) && object!="")
		matches = filter_fancy_list(matches, object)

	if(matches.len==0)
		return
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in sortList(matches)
	if(hsbitem)
		hsbitem = matches[hsbitem]
		var/counter = 0
		for(var/atom/O in world)
			if(istype(O, hsbitem))
				counter++
				qdel(O)
			CHECK_TICK
		log_admin("[key_name(src)] has deleted all ([counter]) instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all ([counter]) instances of [hsbitem].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delete All") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_assume_direct_control(mob/M in GLOB.mob_list)
	set category = "-Admin-"
	set name = "Direct control..."
	set desc = ""

	if(M.ckey)
		if(alert("This mob is being controlled by [M.key]. Are you sure you wish to assume control of it? [M.key] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/dead/observer/ghost = new/mob/dead/observer(M,1)
			ghost.ckey = M.ckey
	message_admins(span_adminnotice("[key_name_admin(usr)] assumed direct control of [M]."))
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if( isobserver(adminmob) )
		qdel(adminmob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Assume Direct Control") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_areatest(on_station)
	set category = "Mapping"
	set name = "Test Areas"

	var/list/dat = list()
	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_multiple_APCs = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()
	var/list/station_areas_blacklist = typecacheof(list())

	if(SSticker.current_state == GAME_STATE_STARTUP)
		to_chat(usr, "Game still loading, please hold!")
		return

	var/log_message
	if(on_station)
		dat += "<b>Only checking areas on station z-levels.</b><br><br>"
		log_message = "station z-levels"
	else
		log_message = "all z-levels"

	message_admins(span_adminnotice("[key_name_admin(usr)] used the Test Areas debug command checking [log_message]."))
	log_admin("[key_name(usr)] used the Test Areas debug command checking [log_message].")

	for(var/area/A in world)
		if(on_station)
			var/turf/picked = safepick(get_area_turfs(A.type))
			if(picked && is_station_level(picked.z))
				if(!(A.type in areas_all) && !is_type_in_typecache(A, station_areas_blacklist))
					areas_all.Add(A.type)
		else if(!(A.type in areas_all))
			areas_all.Add(A.type)
		CHECK_TICK

	for(var/obj/machinery/light/L in GLOB.machines)
		var/area/A = get_area(L)
		if(!A)
			dat += "Skipped over [L] in invalid location, [L.loc].<br>"
			continue
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)
		CHECK_TICK

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	if(areas_without_APC.len)
		dat += "<h1>AREAS WITHOUT AN APC:</h1>"
		for(var/areatype in areas_without_APC)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_with_multiple_APCs.len)
		dat += "<h1>AREAS WITH MULTIPLE APCS:</h1>"
		for(var/areatype in areas_with_multiple_APCs)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_air_alarm.len)
		dat += "<h1>AREAS WITHOUT AN AIR ALARM:</h1>"
		for(var/areatype in areas_without_air_alarm)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_RC.len)
		dat += "<h1>AREAS WITHOUT A REQUEST CONSOLE:</h1>"
		for(var/areatype in areas_without_RC)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_light.len)
		dat += "<h1>AREAS WITHOUT ANY LIGHTS:</h1>"
		for(var/areatype in areas_without_light)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_LS.len)
		dat += "<h1>AREAS WITHOUT A LIGHT SWITCH:</h1>"
		for(var/areatype in areas_without_LS)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_intercom.len)
		dat += "<h1>AREAS WITHOUT ANY INTERCOMS:</h1>"
		for(var/areatype in areas_without_intercom)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(areas_without_camera.len)
		dat += "<h1>AREAS WITHOUT ANY CAMERAS:</h1>"
		for(var/areatype in areas_without_camera)
			dat += "[areatype]<br>"
			CHECK_TICK

	if(!(areas_with_APC.len || areas_with_multiple_APCs.len || areas_with_air_alarm.len || areas_with_RC.len || areas_with_light.len || areas_with_LS.len || areas_with_intercom.len || areas_with_camera.len))
		dat += "<b>No problem areas!</b>"

	var/datum/browser/popup = new(usr, "testareas", "Test Areas", 500, 750)
	popup.set_content(dat.Join())
	popup.open()


/client/proc/cmd_admin_areatest_station()
	set category = "Mapping"
	set name = "Test Areas (STATION Z)"
	cmd_admin_areatest(TRUE)

/client/proc/cmd_admin_areatest_all()
	set category = "Mapping"
	set name = "Test Areas (ALL)"
	cmd_admin_areatest(FALSE)

/client/proc/cmd_admin_dress(mob/M in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "Select Loadout"
	if(!(ishuman(M) || isobserver(M)))
		alert("Invalid mob")
		return

	var/mob/living/carbon/human/H
	if(isobserver(M))
		H = M.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
		// Ensure the new human inherits the ckey from the observer
		if(!H.ckey && M.ckey)
			H.ckey = M.ckey
	else
		H = M
	
	// Show the loadout panel window
	show_loadout_panel(H)

/client/proc/show_loadout_panel(mob/living/carbon/human/H)
	if(!H)
		return
	
	var/body = "<html><head><title>Loadout Manager - [H.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body += "</head>"
	body += "<body>"
	
	body += "<b>Loadout Manager: [H.name]</b><br><br>"
	
	// Current job display
	var/selected_job_path = GLOB.loadout_selected_jobs[REF(H)]
	var/selected_job_title = "None"
	if(selected_job_path)
		// Check if it's a migrant role or regular job
		if(ispath(selected_job_path, /datum/migrant_role))
			var/datum/migrant_role/MR = selected_job_path
			selected_job_title = initial(MR.name)
		else
			var/datum/job/J = selected_job_path
			selected_job_title = initial(J.title)
	var/selected_advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	var/selected_advclass_name = "None"
	if(selected_advclass_path)
		var/datum/advclass/AC = selected_advclass_path
		selected_advclass_name = initial(AC.name)
	
	body += "Selected Job: <b>[selected_job_title]</b><br>"
	body += "Selected Advclass: <b>[selected_advclass_name]</b><br>"
	body += "<br>"
	
	// Job selection
	body += "<b>Job Selection:</b><br>"
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=select_job;target=[REF(H)]'>Select Job</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=select_advclass;target=[REF(H)]'>Select Advclass</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=copy_from_mob;target=[REF(H)]'>Copy From...</A>"
	body += "<br><br>"
	
	// Application section
	body += "<b>Apply Components:</b><br>"
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_stats;target=[REF(H)]'>Apply Stats</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_equipment_spells;target=[REF(H)]'>Apply Equipment/Spells</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_skills;target=[REF(H)]'>Apply Skills</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_traits;target=[REF(H)]'>Apply Traits</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_examine_title;target=[REF(H)]'>Apply Examine Title</A><br>"
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=apply_all;target=[REF(H)]'>Apply All</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];loadout_action=clean_slate;target=[REF(H)]'>Clean Slate</A>"
	
	body += "</body></html>"
	
	usr << browse(body, "window=loadout_manager[REF(H)];size=500x400")

// Global variables to store selected job and advclass for each target mob
GLOBAL_LIST_EMPTY(loadout_selected_jobs)
GLOBAL_LIST_EMPTY(loadout_selected_advclasses)

/// Builds an associative list of all available jobs and migrant roles for the loadout panel
/client/proc/build_loadout_job_list()
	var/list/job_list = list()
	for(var/job_type in subtypesof(/datum/job))
		var/datum/job/J = job_type
		var/job_title = initial(J.title)
		var/job_outfit = initial(J.outfit)
		var/list/job_subclasses = initial(J.job_subclasses)
		if(job_title && (job_outfit || job_subclasses))
			job_list[job_title] = job_type

	for(var/migrant_type in subtypesof(/datum/migrant_role))
		var/datum/migrant_role/MR = migrant_type
		var/migrant_name = initial(MR.name)
		var/migrant_outfit = initial(MR.outfit)
		var/migrant_advclass = initial(MR.advclass_cat_rolls)
		if(migrant_name && (migrant_outfit || migrant_advclass) && migrant_name != "MIGRANT ROLE")
			job_list["[migrant_name] (Migrant)"] = migrant_type

	return job_list

/// After a job is selected in the loadout panel, store it and auto-select advclass if applicable
/client/proc/apply_loadout_job_selection(mob/living/carbon/human/H, job_type_path, selected_title)
	GLOB.loadout_selected_jobs[REF(H)] = job_type_path
	GLOB.loadout_selected_advclasses[REF(H)] = null
	to_chat(usr, span_notice("Job selected: [selected_title]"))
	if(!H.mind)
		H.mind_initialize()
	H.mind.assigned_role = selected_title

	// Auto-select advclass if job has only one, or open selection if multiple
	if(ispath(job_type_path, /datum/migrant_role))
		var/datum/migrant_role/migrant_datum = new job_type_path()
		if(migrant_datum.advclass_cat_rolls && length(migrant_datum.advclass_cat_rolls))
			var/list/advclass_choices = list()
			for(var/category in migrant_datum.advclass_cat_rolls)
				for(var/datum/advclass/advclass_instance in SSrole_class_handler.sorted_class_categories[category])
					advclass_choices[advclass_instance.name] = advclass_instance.type

			if(length(advclass_choices) == 0)
				to_chat(usr, span_warning("No advclasses found for this migrant role."))
			else if(length(advclass_choices) == 1)
				var/only_choice_name = advclass_choices[1]
				var/only_choice = advclass_choices[only_choice_name]
				GLOB.loadout_selected_advclasses[REF(H)] = only_choice
				to_chat(usr, span_notice("Auto-selected advclass: [only_choice_name]"))
			else
				var/selected = input("Select advclass:", "Advclass Selection") as null|anything in sortList(advclass_choices)
				if(selected)
					GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
					to_chat(usr, span_notice("Advclass selected: [selected]"))
		qdel(migrant_datum)
	else
		var/datum/job/job_datum = new job_type_path()
		if(job_datum.job_subclasses && length(job_datum.job_subclasses))
			if(length(job_datum.job_subclasses) == 1)
				GLOB.loadout_selected_advclasses[REF(H)] = job_datum.job_subclasses[1]
				var/datum/advclass/AC = job_datum.job_subclasses[1]
				to_chat(usr, span_notice("Auto-selected advclass: [initial(AC.name)]"))
			else
				var/list/advclass_choices = list()
				for(var/advclass_path in job_datum.job_subclasses)
					var/datum/advclass/AC = advclass_path
					advclass_choices[initial(AC.name)] = advclass_path

				var/selected = input("Select advclass:", "Advclass Selection") as null|anything in sortList(advclass_choices)
				if(selected)
					GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
					to_chat(usr, span_notice("Advclass selected: [selected]"))
		qdel(job_datum)

/client/proc/handle_loadout_action(href_list)
	if(!check_rights(R_ADMIN))
		return FALSE
	
	if(!href_list["loadout_action"])
		return FALSE
	
	var/mob/living/carbon/human/H = locate(href_list["target"])
	if(!H || !ishuman(H))
		to_chat(usr, span_warning("Target no longer exists or is not human!"))
		return TRUE
	
	switch(href_list["loadout_action"])
		if("select_job")
			var/list/job_list = build_loadout_job_list()
			var/list/all_jobs = list("Search..." = "search") + sortList(job_list)
			var/selected_title = input("Select job:", "Job Selection") as null|anything in all_jobs
			if(!selected_title)
				show_loadout_panel(H)
				return TRUE

			var/job_type_path
			if(all_jobs[selected_title] == "search")
				var/search_term = input("Enter job name or search term:", "Job Search") as text|null
				if(!search_term)
					show_loadout_panel(H)
					return TRUE

				// Filter by search term
				var/list/matching_jobs = list()
				for(var/job_title in job_list)
					if(findtext(lowertext(job_title), lowertext(search_term)))
						matching_jobs[job_title] = job_list[job_title]

				if(!matching_jobs.len)
					to_chat(usr, span_warning("No jobs found matching '[search_term]'."))
					show_loadout_panel(H)
					return TRUE

				selected_title = input("Select job (found [matching_jobs.len] matches):", "Job Search Results") as null|anything in sortList(matching_jobs)
				if(!selected_title)
					show_loadout_panel(H)
					return TRUE
				job_type_path = matching_jobs[selected_title]
			else
				job_type_path = all_jobs[selected_title]

			apply_loadout_job_selection(H, job_type_path, selected_title)
			show_loadout_panel(H)

		if("select_advclass")
			var/job_type_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_type_path)
				to_chat(usr, span_warning("No job selected! Select a job first to see its advclasses."))
				show_loadout_panel(H)
				return TRUE
			
			// Check if it's a migrant role
			if(ispath(job_type_path, /datum/migrant_role))
				var/datum/migrant_role/migrant_datum = new job_type_path()
				if(!migrant_datum.advclass_cat_rolls || !length(migrant_datum.advclass_cat_rolls))
					to_chat(usr, span_warning("This migrant role has no advclasses available."))
					qdel(migrant_datum)
					show_loadout_panel(H)
					return TRUE
				
				// Get advclasses from the role class handler
				var/list/advclass_choices = list()
				for(var/category in migrant_datum.advclass_cat_rolls)
					for(var/datum/advclass/advclass_instance in SSrole_class_handler.sorted_class_categories[category])
						advclass_choices[advclass_instance.name] = advclass_instance.type
				
				qdel(migrant_datum)
				
				if(!length(advclass_choices))
					to_chat(usr, span_warning("No advclasses found for this migrant role."))
					show_loadout_panel(H)
					return TRUE
				
				var/selected = input("Select advclass:", "Advclass Selection") as null|anything in sortList(advclass_choices)
				if(selected)
					GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
					to_chat(usr, span_notice("Advclass selected: [selected]"))
			else
				// Regular job
				var/datum/job/selected_job
				for(var/datum/job/J in SSjob.occupations)
					if(J.type == job_type_path)
						selected_job = J
						break
				
				if(!selected_job || !selected_job.job_subclasses || !length(selected_job.job_subclasses))
					to_chat(usr, span_warning("This job has no advclasses available."))
					show_loadout_panel(H)
					return TRUE
				
				var/list/advclass_choices = list()
				for(var/advclass_path in selected_job.job_subclasses)
					var/datum/advclass/AC = advclass_path
					advclass_choices[initial(AC.name)] = advclass_path
				
				var/selected = input("Select advclass:", "Advclass Selection") as null|anything in sortList(advclass_choices)
				if(selected)
					GLOB.loadout_selected_advclasses[REF(H)] = advclass_choices[selected]
				to_chat(usr, span_notice("Advclass selected: [selected]"))
			show_loadout_panel(H)
		
		if("copy_from_mob")
			copy_loadout_from_mob(H)
			show_loadout_panel(H)
		
		if("apply_stats")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("No job selected! Use 'Select Job' first."))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("This job requires an advclass! Use 'Select Advclass' first."))
				return TRUE
			// Ask for confirmation
			var/confirm = alert(usr, "Reset stats to baseline (with racial/stat-pack bonuses) before applying job stats?", "Apply Stats", "Reset First", "Add to Current", "Cancel")
			if(confirm == "Cancel")
				return TRUE
			var/delete_existing = (confirm == "Reset First")
			apply_job_stats(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_equipment_spells")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("No job selected! Use 'Select Job' first."))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("This job requires an advclass! Use 'Select Advclass' first."))
				return TRUE
			// Ask for confirmation with clear explanation
			var/confirm = alert(usr, "Delete all current equipment and spells before applying?\n\nNote: Some outfits may grant spells as part of their equipment process.", "Apply Equipment/Spells", "Yes", "No", "Cancel")
			if(confirm == "Cancel")
				return TRUE
			var/delete_existing = (confirm == "Yes")
			apply_job_equipment_and_spells(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_skills")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("No job selected! Use 'Select Job' first."))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("This job requires an advclass! Use 'Select Advclass' first."))
				return TRUE
			// Ask for confirmation
			var/confirm = alert(usr, "Delete all current skills before applying?", "Apply Skills", "Yes", "No", "Cancel")
			if(confirm == "Cancel")
				return TRUE
			var/delete_existing = (confirm == "Yes")
			apply_job_skills(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_traits")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("No job selected! Use 'Select Job' first."))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("This job requires an advclass! Use 'Select Advclass' first."))
				return TRUE
			// Ask for confirmation
			var/confirm = alert(usr, "Delete all current job traits before applying?", "Apply Traits", "Yes", "No", "Cancel")
			if(confirm == "Cancel")
				return TRUE
			var/delete_existing = (confirm == "Yes")
			apply_job_traits(H, job_path, delete_existing)
			show_loadout_panel(H)
		
		if("apply_examine_title")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("No job selected! Use 'Select Job' first."))
				return TRUE
			// No need for delete confirmation - this just overwrites
			apply_job_examine_title(H, job_path)
			show_loadout_panel(H)
		
		if("apply_all")
			var/job_path = GLOB.loadout_selected_jobs[REF(H)]
			if(!job_path)
				to_chat(usr, span_warning("No job selected! Use 'Select Job' first."))
				return TRUE
			// Check if advclass is required
			var/datum/job/J = job_path
			var/list/subclasses = initial(J.job_subclasses)
			if(subclasses && !GLOB.loadout_selected_advclasses[REF(H)])
				to_chat(usr, span_warning("This job requires an advclass! Use 'Select Advclass' first."))
				return TRUE
			// Ask to delete current equipment
			if(alert(usr, "Delete all current equipment?", "Confirm", "Yes", "No") == "Yes")
				for(var/obj/item/I in H.get_equipped_items(TRUE))
					qdel(I)
				for(var/obj/item/I in H.held_items)
					qdel(I)
			apply_full_job_loadout(H, job_path)
			show_loadout_panel(H)
		
		if("clean_slate")
			if(alert(usr, "This will reset [H.name] to a blank state, removing all equipment, skills, examine title, traits, and resetting stats. Continue?", "Confirm Clean Slate", "Yes", "No") == "Yes")
				clean_slate_mob(H)
				show_loadout_panel(H)
	
	return TRUE

/client/proc/robust_dress_shop()

	var/list/baseoutfits = list("Naked","Custom", "As Roguetown Job...", "Search Jobs...")
	var/list/outfits = list()
	var/list/paths = subtypesof(/datum/outfit) - typesof(/datum/outfit/job)  - typesof(/datum/outfit/job/roguetown)

	for(var/path in paths)
		var/datum/outfit/O = path //not much to initalize here but whatever
		if(initial(O.can_be_admin_equipped))
			outfits[initial(O.name)] = path

	var/dresscode = input("Select outfit", "Robust quick dress shop") as null|anything in baseoutfits + sortList(outfits)
	if (isnull(dresscode))
		return

	if (outfits[dresscode])
		dresscode = outfits[dresscode]

	if (dresscode == "Custom")
		var/list/custom_names = list()
		for(var/datum/outfit/D in GLOB.custom_outfits)
			custom_names[D.name] = D
		var/selected_name = input("Select outfit", "Robust quick dress shop") as null|anything in sortList(custom_names)
		dresscode = custom_names[selected_name]
		if(isnull(dresscode))
			return
	
	if (dresscode == "Search Jobs...")
		var/search_term = input("Search for a job (enter keywords):", "Job Search") as text|null
		if(!search_term)
			return
		
		var/list/roguejob_paths = subtypesof(/datum/outfit/job/roguetown)
		var/list/matching_jobs = list()
		
		for(var/path in roguejob_paths)
			var/datum/outfit/O = path
			var/path_string = "[path]"
			if(findtext(lowertext(path_string), lowertext(search_term)))
				if(initial(O.can_be_admin_equipped))
					matching_jobs["[path]"] = path
		
		if(!matching_jobs.len)
			to_chat(usr, span_warning("No jobs found matching '[search_term]'."))
			return
		
		dresscode = input("Select job (found [matching_jobs.len] matches)", "Job Search Results") as null|anything in sortList(matching_jobs)
		dresscode = matching_jobs[dresscode]
		if(isnull(dresscode))
			return

	if (dresscode == "As Roguetown Job...")
		var/list/roguejob_paths = subtypesof(/datum/outfit/job/roguetown)
		var/list/roguejob_outfits = list()
		for(var/path in roguejob_paths)
			var/datum/outfit/O = path
			//roguetown coders are morons and didn't give ANY outfits proper fucking names
			if(initial(O.can_be_admin_equipped))
				roguejob_outfits["[path]"] = path

		dresscode = input("Select job equipment", "Robust quick dress shop") as null|anything in sortList(roguejob_outfits)
		dresscode = roguejob_outfits[dresscode]
		if(isnull(dresscode))
			return


	return dresscode

// Apply full job loadout including stats, skills, traits, and spells
/client/proc/apply_full_job_loadout(mob/living/carbon/human/H, job_type_path)
	if(!ishuman(H))
		return
	
	// Determine if this is a migrant role or regular job
	var/is_migrant = FALSE
	if(ispath(job_type_path, /datum/migrant_role))
		is_migrant = TRUE
	
	var/datum/outfit/outfit_path = null
	var/datum/outfit/actual_outfit = null
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	if(is_migrant)
		// Get outfit from migrant role - check if it uses advclass_cat_rolls or direct outfit
		var/datum/migrant_role/MR = new job_type_path()
		outfit_path = MR.outfit
		
		// If migrant role has direct outfit, use it
		if(outfit_path)
			actual_outfit = outfit_path
		// If migrant role uses advclass system, get outfit from selected advclass
		else if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
		else if(MR.advclass_cat_rolls)
			to_chat(usr, span_warning("No advclass selected for this migrant role. Use the Advclass button to select one."))
		qdel(MR)
	else
		// Get outfit from job type
		var/datum/job/JobType = job_type_path
		outfit_path = initial(JobType.outfit)
		
		var/datum/advclass/advclass_datum = null
		actual_outfit = outfit_path
		
		// If advclass is selected, use its outfit instead
		if(advclass_path)
			advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
	
	// Equip the outfit if available - equipOutfit handles pre_equip and post_equip internally
	if(actual_outfit)
		H.equipOutfit(actual_outfit)
	else
		to_chat(usr, span_warning("No outfit available for this [is_migrant ? "migrant role" : "job"]."))
	
	// Find the corresponding job datum to apply stats/skills (only for regular jobs)
	var/datum/job/job_datum = null
	if(!is_migrant)
		for(var/job_type in subtypesof(/datum/job))
			var/datum/job/J = job_type
			if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
				job_datum = new job_type()
				break
	
	// Remove old job traits before applying new ones
	if(H.status_traits)
		var/list/traits_to_remove = list()
		for(var/trait in H.status_traits)
			var/list/sources = H.status_traits[trait]
			if(JOB_TRAIT in sources)
				traits_to_remove += trait
		for(var/trait in traits_to_remove)
			REMOVE_TRAIT(H, trait, JOB_TRAIT)
	
	// For migrant roles, equipment and stats are applied via the outfit's pre_equip
	// For regular jobs, we need to handle advclass and job separately
	if(!is_migrant)
		var/datum/advclass/advclass_datum = null
		
		// Apply advclass stats/skills/traits if available, otherwise use job
		if(advclass_path)
			advclass_datum = new advclass_path()
			// Apply advclass stats
			if(length(advclass_datum.subclass_stats))
				for(var/stat in advclass_datum.subclass_stats)
					H.change_stat(stat, advclass_datum.subclass_stats[stat])
			
			// Apply advclass skills
			if(length(advclass_datum.subclass_skills))
				for(var/skill in advclass_datum.subclass_skills)
					H.adjust_skillrank(skill, advclass_datum.subclass_skills[skill], TRUE)
			
			// Apply advclass spell points
			if(advclass_datum.subclass_spellpoints > 0 && H.mind)
				H.mind.adjust_spellpoints(advclass_datum.subclass_spellpoints)
			
			// Apply advclass traits
			if(advclass_datum.traits_applied)
				for(var/trait in advclass_datum.traits_applied)
					ADD_TRAIT(H, trait, JOB_TRAIT)
		else if(job_datum)
			// Apply job stats
			if(length(job_datum.job_stats))
				for(var/stat in job_datum.job_stats)
					H.change_stat(stat, job_datum.job_stats[stat])
			
			// Apply job traits
			if(job_datum.job_traits)
				for(var/trait in job_datum.job_traits)
					ADD_TRAIT(H, trait, JOB_TRAIT)
		
		// Apply spells from job
		if(job_datum && job_datum.spells && H.mind)
			for(var/S in job_datum.spells)
				H.mind.AddSpell(new S)
	
	// Apply racial bonuses for reading (elves) and engineering (constructs)
	if(H.dna?.species)
		if(H.dna.species.name in list("Elf", "Half-Elf"))
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if(H.dna.species.name in list("Metal Construct"))
			H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	
	// Call after_spawn if job exists (latejoin=TRUE to skip spawn protection and ready-up bonuses)
	if(job_datum && hascall(job_datum, "after_spawn"))
		H.islatejoin = TRUE  // Mark as latejoin to prevent ready-up bonuses
		job_datum.after_spawn(H, H, TRUE)
	
	// Call after_spawn for migrant roles if it exists
	if(is_migrant)
		var/datum/migrant_role/migrant_datum = new job_type_path()
		if(hascall(migrant_datum, "after_spawn"))
			migrant_datum.after_spawn(H)
		qdel(migrant_datum)
	
	// Clean up any advclass selection hugbox state that may have been applied by after_spawn
	// This must happen AFTER after_spawn since that proc may apply hugbox for advclass selection
	H.advsetup = 0
	H.invisibility = 0
	H.cure_blind("advsetup")
	if(H.status_flags & GODMODE)
		H.status_flags &= ~GODMODE
	REMOVE_TRAIT(H, TRAIT_PACIFISM, HUGBOX_TRAIT)
	// Unregister the movement signal if it exists
	UnregisterSignal(H, COMSIG_MOVABLE_MOVED)
	// Clear any hugbox-related messages
	H.clear_fullscreen("blind")
	// Force end any hugbox timers by calling the end proc (safe to call even if not in hugbox)
	if(hascall(H, "adv_hugboxing_end"))
		H.adv_hugboxing_end()
	
	// Apply examine title
	if(is_migrant)
		// For migrant roles, set the name directly
		var/datum/migrant_role/MR = job_type_path
		H.job = initial(MR.name)
		H.advjob = null
		to_chat(H, span_notice("Examine title set to: [initial(MR.name)]"))
	else if(job_datum)
		// Determine the appropriate gendered title
		var/title = job_datum.title
		if(job_datum.f_title && (H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F))
			title = job_datum.f_title
		H.job = title
		if(advclass_path)
			var/datum/advclass/adv_for_title = new advclass_path()
			H.advjob = adv_for_title.name
	
	to_chat(H, span_notice("Full job loadout applied! Stats, skills, and traits have been configured."))
	message_admins("[key_name_admin(usr)] applied full job loadout [actual_outfit] to [ADMIN_LOOKUPFLW(H)].")
	log_admin("[key_name(usr)] applied full job loadout [actual_outfit] to [key_name(H)].")

// Individual application functions
/client/proc/apply_job_equipment_and_spells(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	if(!H.mind)
		H.mind_initialize()
		to_chat(usr, span_notice("Initialized mind for target."))
	
	// Determine if this is a migrant role or regular job
	var/is_migrant = FALSE
	if(ispath(job_type_path, /datum/migrant_role))
		is_migrant = TRUE
	
	var/datum/outfit/outfit_path = null
	var/datum/outfit/actual_outfit = null
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	if(is_migrant)
		// Get outfit from migrant role - check if it uses advclass_cat_rolls or direct outfit
		var/datum/migrant_role/MR = new job_type_path()
		outfit_path = MR.outfit
		
		// If migrant role has direct outfit, use it
		if(outfit_path)
			actual_outfit = outfit_path
		// If migrant role uses advclass system, get outfit from selected advclass
		else if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
		else if(MR.advclass_cat_rolls)
			to_chat(usr, span_warning("No advclass selected for this migrant role. Use the Advclass button to select one."))
		qdel(MR)
	else
		// Get outfit from job type
		var/datum/job/JobType = job_type_path
		outfit_path = initial(JobType.outfit)
		
		actual_outfit = outfit_path
		
		// If advclass is selected, use its outfit instead
		if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.outfit)
				actual_outfit = advclass_datum.outfit
	
	// Clear existing equipment and spells if requested
	if(delete_existing)
		// Clear equipment
		for(var/obj/item/I in H.get_equipped_items(TRUE))
			qdel(I)
		for(var/obj/item/I in H.held_items)
			qdel(I)
		// Clear spells and spell points
		for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
			H.mind.RemoveSpell(S)
		H.mind.spell_points = 0
		H.mind.used_spell_points = 0
	
	// Equip the outfit if available - equipOutfit handles pre_equip and post_equip internally
	// Note: pre_equip hooks may grant spells as part of the equipment process
	if(actual_outfit)
		H.equipOutfit(actual_outfit)
		H.regenerate_icons()
	
	// For migrant roles, spells are already applied via the outfit
	// For regular jobs, apply additional job spells if available
	if(!is_migrant)
		// Find the corresponding job datum to apply any additional job spells
		var/datum/job/job_datum = null
		for(var/job_type in subtypesof(/datum/job))
			var/datum/job/J = job_type
			if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
				job_datum = new job_type()
				break
		
		// Apply spells from job if available (separate from outfit)
		if(job_datum && job_datum.spells)
			for(var/S in job_datum.spells)
				H.mind.AddSpell(new S)
	
		// Apply spell points from advclass if available
		if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			if(advclass_datum.subclass_spellpoints > 0)
				H.mind.adjust_spellpoints(advclass_datum.subclass_spellpoints)
	
	if(actual_outfit)
		to_chat(H, span_notice("Equipment and spells applied[is_migrant ? " from migrant role" : ""]!"))
		message_admins("[key_name_admin(usr)] applied equipment and spells from [actual_outfit] to [ADMIN_LOOKUPFLW(H)].")
		log_admin("[key_name(usr)] applied equipment and spells from [actual_outfit] to [key_name(H)].")
	else
		to_chat(usr, span_warning("No outfit available for this [is_migrant ? "migrant role" : "job"]."))

/client/proc/apply_job_stats(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	// Get outfit from job type for job finding
	var/datum/job/JobType = job_type_path
	var/datum/outfit/outfit_path = initial(JobType.outfit)
	
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	// Reset stats to baseline (with racial and stat-pack bonuses) if requested
	if(delete_existing)
		H.roll_stats()
	
	// Find the job datum
	var/datum/job/job_datum = null
	for(var/job_type in subtypesof(/datum/job))
		var/datum/job/J = job_type
		if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
			job_datum = new job_type()
			break
	
	// Apply job stats first
	if(job_datum && length(job_datum.job_stats))
		for(var/stat in job_datum.job_stats)
			H.change_stat(stat, job_datum.job_stats[stat])
	
	// Then apply advclass stats on top
	if(advclass_path)
		var/datum/advclass/advclass_datum = new advclass_path()
		if(length(advclass_datum.subclass_stats))
			for(var/stat in advclass_datum.subclass_stats)
				H.change_stat(stat, advclass_datum.subclass_stats[stat])
	
	to_chat(H, span_notice("Stats applied from job[advclass_path ? " and advclass" : ""]!"))
	message_admins("[key_name_admin(usr)] applied stats from [outfit_path] to [ADMIN_LOOKUPFLW(H)].")
	log_admin("[key_name(usr)] applied stats from [outfit_path] to [key_name(H)].")

/client/proc/apply_job_skills(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	// Get outfit from job type for job finding
	var/datum/job/JobType = job_type_path
	var/datum/outfit/outfit_path = initial(JobType.outfit)
	
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	// Clear all skills if requested
	if(delete_existing)
		for(var/skill_type in subtypesof(/datum/skill))
			var/current_rank = H.get_skill_level(skill_type)
			if(current_rank > 0)
				H.adjust_skillrank(skill_type, -current_rank, TRUE)
	
	// Apply racial skill bonuses first
	if(H.dna?.species)
		if(H.dna.species.name in list("Elf", "Half-Elf"))
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if(H.dna.species.name in list("Metal Construct"))
			H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
	
	// Apply advclass skills if available
	if(advclass_path)
		var/datum/advclass/advclass_datum = new advclass_path()
		if(length(advclass_datum.subclass_skills))
			for(var/skill in advclass_datum.subclass_skills)
				H.adjust_skillrank(skill, advclass_datum.subclass_skills[skill], TRUE)
	
	to_chat(H, span_notice("Skills applied[advclass_path ? " from advclass" : ""]!"))
	message_admins("[key_name_admin(usr)] applied skills from [outfit_path] to [ADMIN_LOOKUPFLW(H)].")
	log_admin("[key_name(usr)] applied skills from [outfit_path] to [key_name(H)].")

/client/proc/apply_job_traits(mob/living/carbon/human/H, job_type_path, delete_existing = FALSE)
	if(!ishuman(H))
		return
	
	// Get outfit from job type for job finding
	var/datum/job/JobType = job_type_path
	var/datum/outfit/outfit_path = initial(JobType.outfit)
	
	var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
	
	// Remove old job traits if requested
	if(delete_existing && H.status_traits)
		var/list/traits_to_remove = list()
		for(var/trait in H.status_traits)
			var/list/sources = H.status_traits[trait]
			if(JOB_TRAIT in sources)
				traits_to_remove += trait
		for(var/trait in traits_to_remove)
			REMOVE_TRAIT(H, trait, JOB_TRAIT)
	
	// Find the job datum
	var/datum/job/job_datum = null
	for(var/job_type in subtypesof(/datum/job))
		var/datum/job/J = job_type
		if(initial(J.outfit) == outfit_path || initial(J.outfit_female) == outfit_path)
			job_datum = new job_type()
			break
	
	// Apply job traits first
	if(job_datum && job_datum.job_traits)
		for(var/trait in job_datum.job_traits)
			ADD_TRAIT(H, trait, JOB_TRAIT)
	
	// Then apply advclass traits on top
	if(advclass_path)
		var/datum/advclass/advclass_datum = new advclass_path()
		if(advclass_datum.traits_applied)
			for(var/trait in advclass_datum.traits_applied)
				ADD_TRAIT(H, trait, JOB_TRAIT)
	
	to_chat(H, span_notice("Traits applied from job[advclass_path ? " and advclass" : ""]!"))
	message_admins("[key_name_admin(usr)] applied traits from [outfit_path] to [ADMIN_LOOKUPFLW(H)].")
	log_admin("[key_name(usr)] applied traits from [outfit_path] to [key_name(H)].")

/client/proc/apply_job_examine_title(mob/living/carbon/human/H, job_type_path)
	if(!ishuman(H))
		return
	
	// Determine if this is a migrant role or regular job
	var/is_migrant = FALSE
	if(ispath(job_type_path, /datum/migrant_role))
		is_migrant = TRUE
	
	// Clear any excommunicated/outlawed status before applying new title
	if(H.real_name in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= H.real_name
	if(H.real_name in GLOB.outlawed_players)
		GLOB.outlawed_players -= H.real_name
	
	if(is_migrant)
		// For migrant roles, set the name directly
		var/datum/migrant_role/migrant_datum = new job_type_path()
		var/title = migrant_datum.name
		H.job = title
		H.advjob = null
		to_chat(H, span_notice("Examine title set to: [title]"))
		message_admins("[key_name_admin(usr)] set examine title for [ADMIN_LOOKUPFLW(H)] to [title].")
		log_admin("[key_name(usr)] set examine title for [key_name(H)] to [title].")
		qdel(migrant_datum)
	else
		// Get the job datum directly from the path
		var/datum/job/job_datum = new job_type_path()
		
		var/advclass_path = GLOB.loadout_selected_advclasses[REF(H)]
		
		if(!job_datum)
			to_chat(usr, span_warning("Could not find job datum."))
			return
		
		// Determine the appropriate title based on gender
		var/title = job_datum.title
		if(job_datum.f_title && (H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F))
			title = job_datum.f_title
		
		// Set the job
		H.job = title
		
		// Set advclass if selected
		if(advclass_path)
			var/datum/advclass/advclass_datum = new advclass_path()
			H.advjob = advclass_datum.name
			to_chat(H, span_notice("Examine title set to: [advclass_datum.name]"))
			message_admins("[key_name_admin(usr)] set examine title for [ADMIN_LOOKUPFLW(H)] to [advclass_datum.name].")
			log_admin("[key_name(usr)] set examine title for [key_name(H)] to [advclass_datum.name].")
		else
			// For jobs with advjob_examine = TRUE, set H.advjob to the appropriate title
			if(job_datum.advjob_examine)
				H.advjob = title
			// Get display title if available
			var/display_title = job_datum.display_title || title
			to_chat(H, span_notice("Examine title set to: [display_title]"))
			message_admins("[key_name_admin(usr)] set examine title for [ADMIN_LOOKUPFLW(H)] to [display_title].")
			log_admin("[key_name(usr)] set examine title for [key_name(H)] to [display_title].")

/client/proc/clean_slate_mob(mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	
	// Delete all equipment including items in hands
	for(var/obj/item/I in H.get_equipped_items(TRUE))
		qdel(I)
	// Delete items in hands
	for(var/obj/item/I in H.held_items)
		qdel(I)
	
	// Reset stats to baseline (10) plus racial and stat-pack modifiers
	H.roll_stats()
	
	// Clear all skills
	for(var/skill_type in subtypesof(/datum/skill))
		var/current_rank = H.get_skill_level(skill_type)
		if(current_rank > 0)
			H.adjust_skillrank(skill_type, -current_rank, TRUE)
	
	// Remove all job traits (but preserve species traits)
	if(H.status_traits)
		for(var/trait in H.status_traits)
			if(HAS_TRAIT_FROM(H, trait, JOB_TRAIT))
				REMOVE_TRAIT(H, trait, JOB_TRAIT)
	
	// Clear spells and spell points if they have a mind
	if(H.mind)
		for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
			H.mind.RemoveSpell(S)
		// Reset spell points
		H.mind.spell_points = 0
		H.mind.used_spell_points = 0
	
	// Remove from excommunicated and outlawed lists (clears examine text like "HERETIC! SHAME!")
	// Check both real_name and name to be thorough
	if(H.real_name)
		GLOB.excommunicated_players -= H.real_name
		GLOB.outlawed_players -= H.real_name
	if(H.name && H.name != H.real_name)
		GLOB.excommunicated_players -= H.name
		GLOB.outlawed_players -= H.name
	
	// Clear job and advjob to remove examine title
	H.job = null
	H.advjob = null
	
	// Don't clear selected job - let it persist for reapplication
	
	H.regenerate_icons()
	
	to_chat(H, span_warning("You have been reset to a blank slate!"))
	message_admins("[key_name_admin(usr)] reset [ADMIN_LOOKUPFLW(H)] to a clean slate.")
	log_admin("[key_name(usr)] reset [key_name(H)] to a clean slate.")

// Copy loadout from one mob to another
/client/proc/copy_loadout_from_mob(mob/living/carbon/human/target)
	if(!ishuman(target))
		to_chat(usr, span_warning("Target must be a human!"))
		return
	
	var/list/possible_sources = list()
	// Include all human mobs, whether connected or disconnected
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H != target)
			var/display_name = "[H.name]"
			if(H.ckey)
				display_name += " ([H.ckey])"
			else
				display_name += " (Disconnected)"
			possible_sources[display_name] = H
	
	if(!possible_sources.len)
		to_chat(usr, span_warning("No valid humanoid mobs found!"))
		return
	
	var/source_name = input("Select character to copy from:", "Copy From...") as null|anything in sortList(possible_sources)
	if(!source_name)
		return
	
	var/mob/living/carbon/human/source = possible_sources[source_name]
	if(!source || QDELETED(source))
		to_chat(usr, span_warning("Source mob no longer exists!"))
		return
	
	// Confirm what to copy
	var/list/copy_options = list("Equipment Only", "Equipment + Skills", "Equipment + Skills + Stats", "Everything (Equipment + Skills + Stats + Traits)")
	var/copy_choice = input("What should be copied?", "Copy Options") as null|anything in copy_options
	if(!copy_choice)
		return
	
	// Clear target's equipment first
	if(alert("Clear target's current equipment?", "Confirm", "Yes", "No") == "Yes")
		for(var/obj/item/I in target.get_equipped_items(TRUE))
			qdel(I)
	
	// Copy equipment
	copy_equipment(source, target)
	
	// Copy skills if requested
	if(copy_choice in list("Equipment + Skills", "Equipment + Skills + Stats", "Everything (Equipment + Skills + Stats + Traits)"))
		copy_skills(source, target)
	
	// Copy stats if requested
	if(copy_choice in list("Equipment + Skills + Stats", "Everything (Equipment + Skills + Stats + Traits)"))
		copy_stats(source, target)
	
	// Copy traits if requested  
	if(copy_choice == "Everything (Equipment + Skills + Stats + Traits)")
		copy_traits(source, target)
	
	target.regenerate_icons()
	to_chat(usr, span_notice("Loadout copied from [source.name] to [target.name]!"))
	message_admins("[key_name_admin(usr)] copied loadout from [ADMIN_LOOKUPFLW(source)] to [ADMIN_LOOKUPFLW(target)] ([copy_choice]).")
	log_admin("[key_name(usr)] copied loadout from [key_name(source)] to [key_name(target)] ([copy_choice]).")

/client/proc/copy_equipment(mob/living/carbon/human/source, mob/living/carbon/human/target)
	// Copy all worn/held items by creating duplicates
	var/list/items_to_copy = source.get_equipped_items(TRUE)
	// Also add held items
	for(var/obj/item/held in source.held_items)
		if(held && !(held in items_to_copy))
			items_to_copy += held
	
	for(var/obj/item/I in items_to_copy)
		var/obj/item/copy = new I.type()
		
		// Try to equip in appropriate slot
		var/equipped = FALSE
		
		// Check each possible slot
		if(source.head == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_HEAD)
		else if(source.wear_mask == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_WEAR_MASK)
		else if(source.wear_neck == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_NECK)
		else if(source.back == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BACK)
		else if(source.wear_armor == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_ARMOR)
		else if(source.wear_shirt == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_SHIRT)
		else if(source.wear_pants == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_PANTS)
		else if(source.belt == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BELT)
		else if(source.beltl == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BELT_L)
		else if(source.beltr == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BELT_R)
		else if(source.gloves == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_GLOVES)
		else if(source.shoes == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_SHOES)
		else if(source.cloak == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_CLOAK)
		else if(source.backr == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BACK_R)
		else if(source.backl == I)
			equipped = target.equip_to_slot_or_del(copy, SLOT_BACK_L)
		else if(I in source.held_items)
			// Try to put in hands
			equipped = target.put_in_hands(copy)
		
		// If couldn't equip, drop it at their feet
		if(!equipped)
			copy.forceMove(get_turf(target))

/client/proc/copy_skills(mob/living/carbon/human/source, mob/living/carbon/human/target)
	if(!source.mind || !target.mind)
		return
	
	// Copy all skill ranks
	for(var/skill_type in subtypesof(/datum/skill))
		var/source_rank = source.get_skill_level(skill_type)
		var/target_rank = target.get_skill_level(skill_type)
		
		if(source_rank != target_rank)
			var/difference = source_rank - target_rank
			target.adjust_skillrank(skill_type, difference, TRUE)
	
	to_chat(target, span_notice("Skills have been copied to match [source.name]'s abilities."))

/client/proc/copy_stats(mob/living/carbon/human/source, mob/living/carbon/human/target)
	// Copy all stats using the correct stat names
	var/list/stat_names = list(STAT_STRENGTH, STAT_PERCEPTION, STAT_INTELLIGENCE, STAT_CONSTITUTION, STAT_WILLPOWER, STAT_SPEED, STAT_FORTUNE)
	
	for(var/stat in stat_names)
		var/source_stat = source.get_stat(stat)
		var/target_stat = target.get_stat(stat)
		var/difference = source_stat - target_stat
		
		if(difference != 0)
			target.change_stat(stat, difference)
	
	to_chat(target, span_notice("Stats have been copied to match [source.name]'s attributes."))

/client/proc/copy_traits(mob/living/carbon/human/source, mob/living/carbon/human/target)
	// Get source's job datum to find job traits
	var/datum/job/source_job = null
	if(source.mind?.assigned_role)
		for(var/job_type in subtypesof(/datum/job))
			var/datum/job/J = job_type
			if(initial(J.title) == source.mind.assigned_role)
				source_job = new job_type()
				break
	
	// Clear target's job traits first (remove traits from JOB_TRAIT source)
	if(target.status_traits)
		for(var/trait in target.status_traits)
			// Only remove if it's from job trait source
			if(HAS_TRAIT_FROM(target, trait, JOB_TRAIT))
				REMOVE_TRAIT(target, trait, JOB_TRAIT)
	
	// Apply source job's traits to target
	if(source_job && source_job.job_traits)
		for(var/trait in source_job.job_traits)
			ADD_TRAIT(target, trait, JOB_TRAIT)
	
	// Make sure racial traits are preserved for target's actual race
	if(target.dna?.species)
		// Re-apply any racial traits that might have been overwritten
		var/datum/species/S = target.dna.species
		if(S.species_traits)
			for(var/trait in S.species_traits)
				ADD_TRAIT(target, trait, SPECIES_TRAIT)
	
	to_chat(target, span_notice("Job traits have been copied, but your racial traits remain unchanged."))

/client/proc/cmd_debug_mob_lists()
	set category = "Debug"
	set name = "Debug Mob Lists"
	set desc = ""

	switch(input("Which list?") in list("Players","Admins","Mobs","Living Mobs","Dead Mobs","Clients","Joined Clients"))
		if("Players")
			to_chat(usr, jointext(GLOB.player_list,","))
		if("Admins")
			to_chat(usr, jointext(GLOB.admins,","))
		if("Mobs")
			to_chat(usr, jointext(GLOB.mob_list,","))
		if("Living Mobs")
			to_chat(usr, jointext(GLOB.alive_mob_list,","))
		if("Dead Mobs")
			to_chat(usr, jointext(GLOB.dead_mob_list,","))
		if("Clients")
			to_chat(usr, jointext(GLOB.clients,","))
		if("Joined Clients")
			to_chat(usr, jointext(GLOB.joined_player_list,","))

/client/proc/cmd_display_del_log()
	set category = "Debug"
	set name = "Display del() Log"
	set desc = ""

	var/list/dellog = list("<B>List of things that have gone through qdel this round</B><BR><BR><ol>")
	sortTim(SSgarbage.items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in SSgarbage.items)
		var/datum/qdel_item/I = SSgarbage.items[path]
		dellog += "<li><u>[path]</u><ul>"
		if (I.failures)
			dellog += "<li>Failures: [I.failures]</li>"
		dellog += "<li>qdel() Count: [I.qdels]</li>"
		dellog += "<li>Destroy() Cost: [I.destroy_time]ms</li>"
		if (I.hard_deletes)
			dellog += "<li>Total Hard Deletes [I.hard_deletes]</li>"
			dellog += "<li>Time Spent Hard Deleting: [I.hard_delete_time]ms</li>"
		if (I.slept_destroy)
			dellog += "<li>Sleeps: [I.slept_destroy]</li>"
		if (I.no_respect_force)
			dellog += "<li>Ignored force: [I.no_respect_force]</li>"
		if (I.no_hint)
			dellog += "<li>No hint: [I.no_hint]</li>"
		dellog += "</ul></li>"

	dellog += "</ol>"

	usr << browse(dellog.Join(), "window=dellog")

/client/proc/cmd_display_overlay_log()
	set category = "Debug"
	set name = "Display overlay Log"
	set desc = ""

	render_stats(SSoverlays.stats, src)

/client/proc/cmd_display_init_log()
	set category = "Debug"
	set name = "Display Initialize() Log"
	set desc = ""

	usr << browse(replacetext(SSatoms.InitLog(), "\n", "<br>"), "window=initlog")

/client/proc/debug_huds(i as num)
	set category = "Debug"
	set name = "Debug HUDs"
	set desc = ""

	if(!holder)
		return
	debug_variables(GLOB.huds[i])

/client/proc/jump_to_ruin()
	set category = "Debug"
	set name = "Jump to Ruin"
	set desc = ""
	if(!holder)
		return
	var/list/names = list()
	for(var/i in GLOB.ruin_landmarks)
		var/obj/effect/landmark/ruin/ruin_landmark = i
		var/datum/map_template/ruin/template = ruin_landmark.ruin_template

		var/count = 1
		var/name = template.name
		var/original_name = name

		while(name in names)
			count++
			name = "[original_name] ([count])"

		names[name] = ruin_landmark

	var/ruinname = input("Select ruin", "Jump to Ruin") as null|anything in sortList(names)


	var/obj/effect/landmark/ruin/landmark = names[ruinname]

	if(istype(landmark))
		var/datum/map_template/ruin/template = landmark.ruin_template
		usr.forceMove(get_turf(landmark))
		to_chat(usr, span_name("[template.name]"))
		to_chat(usr, span_italics("[template.description]"))

/client/proc/toggle_medal_disable()
	set category = "Debug"
	set name = "Toggle Medal Disable"
	set desc = ""

	if(!check_rights(R_DEBUG))
		return

	SSachievements.hub_enabled = !SSachievements.hub_enabled

	message_admins(span_adminnotice("[key_name_admin(src)] [SSachievements.hub_enabled ? "disabled" : "enabled"] the medal hub lockout."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Medal Disable") // If...
	log_admin("[key_name(src)] [SSachievements.hub_enabled ? "disabled" : "enabled"] the medal hub lockout.")

/client/proc/view_runtimes()
	set category = "Debug"
	set name = "View Runtimes"
	set desc = ""

	if(!holder)
		return

	GLOB.error_cache.show_to(src)

/client/proc/pump_random_event()
	set category = "Debug"
	set name = "Pump Random Event"
	set desc = ""
	if(!holder)
		return

	SSevents.scheduled = world.time

	message_admins(span_adminnotice("[key_name_admin(src)] pumped a random event."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Pump Random Event")
	log_admin("[key_name(src)] pumped a random event.")

/client/proc/start_line_profiling()
	set category = "Profile"
	set name = "Start Line Profiling"
	set desc = ""

	LINE_PROFILE_START

	message_admins(span_adminnotice("[key_name_admin(src)] started line by line profiling."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Line Profiling")
	log_admin("[key_name(src)] started line by line profiling.")

/client/proc/stop_line_profiling()
	set category = "Profile"
	set name = "Stops Line Profiling"
	set desc = ""

	LINE_PROFILE_STOP

	message_admins(span_adminnotice("[key_name_admin(src)] stopped line by line profiling."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stop Line Profiling")
	log_admin("[key_name(src)] stopped line by line profiling.")

/client/proc/show_line_profiling()
	set category = "Profile"
	set name = "Show Line Profiling"
	set desc = ""

	var/sortlist = list(
		"Avg time"		=	/proc/cmp_profile_avg_time_dsc,
		"Total Time"	=	/proc/cmp_profile_time_dsc,
		"Call Count"	=	/proc/cmp_profile_count_dsc
	)
	var/sort = input(src, "Sort type?", "Sort Type", "Avg time") as null|anything in sortlist
	if (!sort)
		return
	sort = sortlist[sort]
	profile_show(src, sort)

/client/proc/reload_configuration()
	set category = "Debug"
	set name = "Reload Configuration"
	set desc = ""
	if(!check_rights(R_DEBUG))
		return
	if(alert(usr, "Are you absolutely sure you want to reload the configuration from the default path on the disk, wiping any in-round modificatoins?", "Really reset?", "No", "Yes") == "Yes")
		config.admin_reload()
