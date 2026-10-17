//- Are all the floors with or without air, as they should be? (regular or airless)
//- Does the area have an APC?
//- Does the area have an Air Alarm?
//- Does the area have a Request Console?
//- Does the area have lights?
//- Does the area have a light switch?
//- Does the area have enough intercoms?
//- Does the area have enough security cameras? (Use the 'Camera Range Display' verb under Debug)
//- Is the area connected to the scrubbers air loop?
//- Is the area connected to the vent air loop? (vent pumps)
//- Is everything wired properly?
//- Does the area have a fire alarm and firedoors?
//- Do all pod doors work properly?
//- Are accesses set properly on doors, pod buttons, etc.
//- Are all items placed properly? (not below vents, scrubbers, tables)
//- Does the disposal system work properly from all the disposal units in this room and all the units, the pipes of which pass through this room?
//- Check for any misplaced or stacked piece of pipe (air and disposal)
//- Check for any misplaced or stacked piece of wire
//- Identify how hard it is to break into the area and where the weak points are
//- Check if the area has too much empty space. If so, make it smaller and replace the rest with maintenance tunnels.

GLOBAL_LIST_INIT(admin_verbs_debug_mapping, list(
	/client/proc/intercom_view,			//-errorage
	/client/proc/count_objects_on_z_level,
	/client/proc/count_objects_all,
	/client/proc/cmd_assume_direct_control,	//-errorage
	/client/proc/set_server_fps,	//allows you to set the ticklag.
	/client/proc/cmd_admin_areatest_all,
	/client/proc/cmd_admin_areatest_station,
	#ifdef LOCALTEST
	/client/proc/see_dirty_varedits,
	#endif
	/client/proc/cmd_admin_rejuvenate,
	/datum/admins/proc/show_traitor_panel,
	/client/proc/disable_communication,
	/client/proc/cmd_show_at_list,
	/client/proc/cmd_show_at_markers,
	/client/proc/manipulate_organs,
	/client/proc/start_line_profiling,
	/client/proc/stop_line_profiling,
	/client/proc/show_line_profiling,
	/client/proc/show_sendmaps_profiling,
	/client/proc/create_mapping_job_icons,
	/client/proc/debug_z_levels,
	/client/proc/test_all_spans
))
GLOBAL_PROTECT(admin_verbs_debug_mapping)

/obj/effect/debugging/mapfix_marker
	name = "map fix marker"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "mapfixmarker"
	desc = ""

/obj/effect/debugging/marker
	icon = 'icons/turf/areas.dmi'
	icon_state = "yellow"

/obj/effect/debugging/marker/Move()
	return 0

#ifdef LOCALTEST
GLOBAL_LIST_EMPTY(dirty_vars)

/client/proc/see_dirty_varedits()
	set category = "Debug.Mapping"
	set name = "Dirty Varedits"

	var/list/dat = list()
	dat += "<h3>Abandon all hope ye who enter here</h3><br><br>"
	for(var/thing in GLOB.dirty_vars)
		dat += "[thing]<br>"
		CHECK_TICK
	var/datum/browser/popup = new(usr, "dirty_vars", "Dirty Varedits", 900, 750)
	popup.set_content(dat.Join())
	popup.open()
#endif

/client/proc/intercom_view()
	set category = "Debug.Mapping"
	set name = "Intercom Range Display"

	var/static/intercom_range_display_status = FALSE
	intercom_range_display_status = !intercom_range_display_status //blame cyberboss if this breaks something

	for(var/obj/effect/debugging/marker/M in world)
		qdel(M)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Intercom Range") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_show_at_list()
	set category = "Debug.Mapping"
	set name = "Show roundstart AT list"
	set desc = ""

	var/dat = {"<b>Coordinate list of Active Turfs at Roundstart</b>
		<br>Real-time Active Turfs list you can see in Air Subsystem at active_turfs var<br>"}

	for(var/t in GLOB.active_turfs_startlist)
		var/turf/T = t
		dat += "[ADMIN_VERBOSEJMP(T)]\n"
		dat += "<br>"

	usr << browse(dat, "window=at_list")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Roundstart Active Turfs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_show_at_markers()
	set category = "Debug.Mapping"
	set name = "Show roundstart AT markers"
	set desc = ""

	var/count = 0
	for(var/obj/effect/abstract/marker/at/AT in GLOB.all_abstract_markers)
		qdel(AT)
		count++

	if(count)
		to_chat(usr, "[count] AT markers removed.")
	else
		for(var/t in GLOB.active_turfs_startlist)
			new /obj/effect/abstract/marker/at(t)
			count++
		to_chat(usr, "[count] AT markers placed.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Roundstart Active Turf Markers")

/client/proc/enable_debug_verbs()
	set category = "Debug"
	set name = "Debug verbs - Enable"
	if(!check_rights(R_DEBUG))
		return
	remove_verb(src, /client/proc/enable_debug_verbs)
	add_verb(src, list(/client/proc/disable_debug_verbs, GLOB.admin_verbs_debug_mapping))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Enable Debug Verbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/disable_debug_verbs()
	set category = "Debug"
	set name = "Debug verbs - Disable"
	remove_verb(src, list(/client/proc/disable_debug_verbs, GLOB.admin_verbs_debug_mapping))
	add_verb(src, /client/proc/enable_debug_verbs)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Disable Debug Verbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/count_objects_on_z_level()
	set category = "Debug.Mapping"
	set name = "Count Objects On Level"
	var/level = input(usr, "Which z-level?","Level?") as text|null
	if(!level)
		return
	var/num_level = text2num(level)
	if(!num_level)
		return
	if(!isnum(num_level))
		return

	var/type_text = input(usr, "Which type path?","Path?") as text|null
	if(!type_text)
		return
	var/type_path = text2path(type_text)
	if(!type_path)
		return

	var/count = 0

	var/list/atom/atom_list = list()

	for(var/atom/A in world)
		if(istype(A,type_path))
			var/atom/B = A
			while(!(isturf(B.loc)))
				if(B && B.loc)
					B = B.loc
				else
					break
			if(B)
				if(B.z == num_level)
					count++
					atom_list += A

	to_world("There are [count] objects of type [type_path] on z-level [num_level]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Count Objects Zlevel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/count_objects_all()
	set category = "Debug.Mapping"
	set name = "Count Objects All"

	var/type_text = input(usr, "Which type path?","") as text|null
	if(!type_text)
		return
	var/type_path = text2path(type_text)
	if(!type_path)
		return

	var/count = 0

	for(var/atom/A in world)
		if(istype(A,type_path))
			count++

	to_world("There are [count] objects of type [type_path] in the game world")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Count Objects All") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//This proc is intended to detect lag problems relating to communication procs
GLOBAL_VAR_INIT(say_disabled, FALSE)
/client/proc/disable_communication()
	set category = "Debug.Mapping"
	set name = "Disable all communication verbs"

	GLOB.say_disabled = !GLOB.say_disabled
	if(GLOB.say_disabled)
		message_admins("[key] used 'Disable all communication verbs', killing all communication methods.")
	else
		message_admins("[key] used 'Disable all communication verbs', restoring all communication methods.")

//This generates the icon states for job starting location landmarks.
/client/proc/create_mapping_job_icons()
	set name = "Generate job landmarks icons"
	set category = "Debug.Mapping"
	var/icon/final = icon()
	var/mob/living/carbon/human/dummy/D = new(locate(1,1,1)) //spawn on 1,1,1 so we don't have runtimes when items are deleted
	D.setDir(SOUTH)
	for(var/job in subtypesof(/datum/job))
		var/datum/job/JB = new job
		for(var/obj/item/I in D)
			qdel(I)
		randomize_human(D)
		JB.equip(D, TRUE, FALSE)
		var/icon/I = icon(getFlatIcon(D), frame = 1)
		final.Insert(I, JB.title)
	qdel(D)
	//Also add the x
	for(var/x_number in 1 to 4)
		final.Insert(icon('icons/mob/screen_gen.dmi', "x[x_number == 1 ? "" : x_number]"), "x[x_number == 1 ? "" : x_number]")
	fcopy(final, "icons/mob/landmarks.dmi")

/client/proc/debug_z_levels()
	set name = "Debug Z-Levels"
	set category = "Debug.Mapping"

	var/list/z_list = SSmapping.z_list
	var/list/messages = list()
	messages += "<b>World</b>: [world.maxx] x [world.maxy] x [world.maxz]<br>"

	var/list/linked_levels = list()
	var/min_x = INFINITY
	var/min_y = INFINITY
	var/max_x = -INFINITY
	var/max_y = -INFINITY

	for(var/z in 1 to max(world.maxz, z_list.len))
		if (z > z_list.len)
			messages += "<b>[z]</b>: Unmanaged (out of bounds)<br>"
			continue
		var/datum/space_level/S = z_list[z]
		if (!S)
			messages += "<b>[z]</b>: Unmanaged (null)<br>"
			continue
		var/linkage
		switch (S.linkage)
			if (UNAFFECTED)
				linkage = "no linkage"
			if (SELFLOOPING)
				linkage = "self-looping"
			if (CROSSLINKED)
				linkage = "linked at ([S.xi], [S.yi])"
				linked_levels += S
				min_x = min(min_x, S.xi)
				min_y = min(min_y, S.yi)
				max_x = max(max_x, S.xi)
				max_y = max(max_y, S.yi)
			else
				linkage = "unknown linkage '[S.linkage]'"

		messages += "<b>[z]</b>: [S.name], [linkage], traits: [json_encode(S.traits)]<br>"
		if (S.z_value != z)
			messages += "-- z_value is [S.z_value], should be [z]<br>"
		if (S.name == initial(S.name))
			messages += "-- name not set<br>"
		if (z > world.maxz)
			messages += "-- exceeds max z"

	var/grid[max_x - min_x + 1][max_y - min_y + 1]
	for(var/datum/space_level/S in linked_levels)
		grid[S.xi - min_x + 1][S.yi - min_y + 1] = S.z_value

	messages += "<table border='1'>"
	for(var/y in max_y to min_y step -1)
		var/list/part = list()
		for(var/x in min_x to max_x)
			part += "[grid[x - min_x + 1][y - min_y + 1]]"
		messages += "<tr><td>[part.Join("</td><td>")]</td></tr>"
	messages += "</table>"

	to_chat(src, messages.Join(""))


/client/proc/test_all_spans() // THIS IS A DEBUG PROC!!! DO NOT LEAVE  THIS IN!!! DO NOT COMMIT THIS!!!!!
	set name = "THE SPANNENATOR TEST SPANS"
	set category = "Debug.Spans"

	to_world(span_abductor("span_abductor"))
	to_world(span_admin("span_admin"))
	to_world(span_adminhelp("span_adminhelp"))
	to_world(span_adminnotice("span_adminnotice"))
	to_world(span_adminprefix("span_adminprefix"))
	to_world(span_adminsay("span_adminsay"))
	to_world(span_aiprivradio("span_aiprivradio"))
	to_world(span_voyeurvice("span_voyeurvice"))
	to_world(span_alert("span_alert"))
	to_world(span_alertalien("span_alertalien"))
	to_world(span_alertsyndie("span_alertsyndie"))
	to_world(span_announce("span_announce"))
	to_world(span_artery("span_artery"))
	to_world(span_bad("span_bad"))
	to_world(span_big("span_big"))
	to_world(span_bigbold("span_bigbold"))
	to_world(span_biginfo("span_biginfo"))
	to_world(span_bignotice("span_bignotice"))
	to_world(span_blue("span_blue"))
	to_world(span_bloody("span_bloody"))
	to_world(span_bold("span_bold"))
	to_world(span_boldannounce("span_boldannounce"))
	to_world(span_boldnotice("span_boldnotice"))
	to_world(span_boldwarning("span_boldwarning"))
	to_world(span_bone("span_bone"))
	to_world(span_centcomradio("span_centcomradio"))
	to_world(span_colossus("span_colossus"))
	to_world(span_crit("span_crit"))
	to_world(span_cult("span_cult"))
	to_world(span_cultbigbold("span_cultbigbold"))
	to_world(span_cultlarge("span_cultlarge"))
	to_world(span_cultsmall("span_cultsmall"))
	to_world(span_danger("span_danger"))
	to_world(span_combatprimary("span_combatprimary"))
	to_world(span_combatsecondary("span_combatsecondary"))
	to_world(span_combatsecondarybp("span_combatsecondarybp"))
	to_world(span_combatsecondarysmall("span_combatsecondarysmall"))
	to_world(span_dead("span_dead"))
	to_world(span_deadsay("span_deadsay"))
	to_world(span_deadsayitalicsbold("span_deadsayitalicsbold"))
	to_world(span_emote("span_emote"))
	to_world(span_gamedeadsay("span_gamedeadsay"))
	to_world(span_ghostalert("span_ghostalert"))
	to_world(span_good("span_good"))
	to_world(span_green("span_green"))
	to_world(span_smallgreen("span_smallgreen"))
	to_world(span_boldgreen("span_boldgreen"))
	to_world(span_greenannounce("span_greenannounce"))
	to_world(span_greentext("span_greentext"))
	to_world(span_greentextbig("span_greentextbig"))
	to_world(span_hear("span_hear"))
	to_world(span_header("span_header"))
	to_world(span_hierophant_warning("span_hierophant_warning"))
	to_world(span_highlight("span_highlight"))
	to_world(span_hypnophrase("span_hypnophrase"))
	to_world(span_infection("span_infection"))
	to_world(span_info("span_info"))
	to_world(span_redinfo("span_redinfo"))
	to_world(span_interface("span_interface"))
	to_world(span_italics("span_italics"))
	to_world(span_looc("span_looc"))
	to_world(span_love("span_love"))
	to_world(span_mind_control("span_mind_control"))
	to_world(span_monkeyhive("span_monkeyhive"))
	to_world(span_name("span_name"))
	to_world(span_narsie("span_narsie"))
	to_world(span_necrosis("span_necrosis"))
	to_world(span_nicegreen("span_nicegreen"))
	to_world(span_notice("span_notice"))
	to_world(span_ooc("span_ooc"))
	to_world(span_phobia("span_phobia"))
	to_world(span_prefix("span_prefix"))
	to_world(span_purple("span_purple"))
	to_world(span_racialstatinfo("span_racialstatinfo"))
	to_world(span_reallybig("span_reallybig"))
	to_world(span_reallybighypnophrase("span_reallybighypnophrase"))
	to_world(span_red("span_red"))
	to_world(span_smallred("span_smallred"))
	to_world(span_boldred("span_boldred"))
	to_world(span_redtext("span_redtext"))
	to_world(span_redtextbig("span_redtextbig"))
	to_world(span_revenminor("span_revenminor"))
	to_world(span_revennotice("span_revennotice"))
	to_world(span_revenwarning("span_revenwarning"))
	to_world(span_rose("span_rose"))
	to_world(span_sans("span_sans"))
	to_world(span_say("span_say"))
	to_world(span_secradio("span_secradio"))
	to_world(span_small("span_small"))
	to_world(span_smallnotice("span_smallnotice"))
	to_world(span_smallracialstatinfo("span_smallracialstatinfo"))
	to_world(span_suicide("span_suicide"))
	to_world(span_suppradio("span_suppradio"))
	to_world(span_syndradio("span_syndradio"))
	to_world(span_tinynotice("span_tinynotice"))
	to_world(span_unconscious("span_unconscious"))
	to_world(span_userdanger("span_userdanger"))
	to_world(span_warn("span_warn"))
	to_world(span_warning("span_warning"))
	to_world(span_taunt("span_taunt"))
	to_world(span_warningbig("span_warningbig"))
	to_world(span_yellow("span_yellow"))
	to_world(span_honeyyellow("span_honeyyellow"))
	to_world(span_beautiful_masc("span_beautiful_masc"))
	to_world(span_beautiful_fem("span_beautiful_fem"))
	to_world(span_beautiful_nb("span_beautiful_nb"))
	to_world(span_astrata("span_astrata"))
	to_world(span_undivided("span_undivided"))
	to_world(span_abyssor("span_abyssor"))
	to_world(span_dendor("span_dendor"))
	to_world(span_eora("span_eora"))
	to_world(span_malum("span_malum"))
	to_world(span_necra("span_necra"))
	to_world(span_noc("span_noc"))
	to_world(span_pestra("span_pestra"))
	to_world(span_ravox("span_ravox"))
	to_world(span_xylix("span_xylix"))
	to_world(span_baotha("span_baotha"))
	to_world(span_graggar("span_graggar"))
	to_world(span_matthios("span_matthios"))
	to_world(span_zizo("span_zizo"))
	to_world(span_vheslyn("span_vheslyn"))
	to_world(span_mossmother("span_mossmother"))
	to_world(span_divine("span_divine"))
	to_world(span_profane("span_profane"))
	to_world(span_silver("span_silver"))
