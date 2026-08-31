GLOBAL_LIST_EMPTY(ghost_images_default) //this is a list of the default (non-accessorized, non-dir) images of the ghosts themselves
GLOBAL_LIST_EMPTY(ghost_images_simple) //this is a list of all ghost images as the simple white ghost

GLOBAL_VAR_INIT(observer_default_invisibility, INVISIBILITY_OBSERVER)
GLOBAL_VAR_CONST(observer_move_delay_multiplier, 0.5)
/mob/dead/observer
	name = "ghost"
	desc = "" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = ""
	pass_flags = PASS_ALL
	layer = GHOST_LAYER
	stat = DEAD
	density = FALSE
	sight = 0
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 10
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	invisibility = INVISIBILITY_OBSERVER
	hud_type = /datum/hud/ghost
	movement_type = GROUND | FLYING
	var/draw_icon = TRUE
	var/trapped = FALSE
	var/can_reenter_corpse
	var/bootime = 0
	var/next_gmove = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/atom/movable/following = null
	var/fun_verbs = 0
	var/image/ghostimage_default = null //this mobs ghost image without accessories and dirs
	var/image/ghostimage_simple = null //this mob with the simple white ghost sprite
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/mob/observetarget = null	//The target mob that the ghost is observing. Used as a reference in logout()
	var/ghost_orbit = GHOST_ORBIT_CIRCLE

	var/updatedir = 1						//Do we have to update our dir as the ghost moves around?

	// Used for displaying in ghost chat, without changing the actual name
	// of the mob
	var/deadchat_name
	var/datum/spawners_menu/spawners_menu
	var/datum/orbit_menu/orbit_menu
	var/orbiting_ref
	var/ghostize_time = 0
	move_resist = INFINITY

/mob/dead/observer/admin
	hud_type = /datum/hud/adminghost
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
	see_in_dark = 100
	draw_icon = FALSE

/mob/dead/observer/nodraw
	draw_icon = FALSE
	icon = 'icons/roguetown/mob/misc.dmi'
	icon_state = "hollow"
	alpha = 150

/mob/dead/observer/profane
	trapped = TRUE

/mob/dead/observer/profane/setup_ghost_verbs()
	return

/mob/dead/observer/eye
	see_in_dark = 0
	draw_icon = FALSE
	hud_type = /datum/hud/obs

/mob/dead/observer/eye/setup_ghost_verbs()
	return

/mob/dead/observer/eye/horde_respawn()
	return

/mob/dead/observer/eye/Move(NewLoc, direct)
	if(updatedir)
		setDir(direct)
	if(NewLoc)
		var/turf/target_turf = get_turf(NewLoc)
		if(target_turf)
			return forceMove(target_turf)
		return FALSE
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return FALSE
	var/turf/step_turf = get_step(current_turf, direct)
	if(step_turf)
		return forceMove(step_turf)
	return FALSE

/mob/dead/observer/eye/screye

/mob/dead/observer/eye/screye/blackmirror
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
	see_in_dark = 100

/mob/dead/observer/eye/screye/Move(n, direct)
	return



/mob/dead/observer/Initialize(mapload)
	set_invisibility(GLOB.observer_default_invisibility)

	add_verb(src, list(
		/mob/dead/observer/proc/dead_tele,
		/mob/dead/observer/proc/open_spawners_menu,
		/mob/dead/observer/proc/tray_view))

	setup_ghost_verbs()

	var/turf/T
	var/mob/body = loc
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?

		if(!T)

			if(istype(body, /mob/living/brain))
				var/obj/Y = body.loc

				T = get_turf(Y)

		gender = body.gender
		if(body.mind && body.mind.name)
			if(body.mind.ghostname)
				name = body.mind.ghostname
			else
				name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				name = random_unique_name(gender)

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

		set_suicide(body.suiciding) // Transfer whether they committed suicide.

		if(draw_icon)
			if(ishuman(body))
				var/mutable_appearance/MA = new()
				MA.appearance = body
				MA.transform = null //so we are standing
				appearance = MA
				layer = GHOST_LAYER
				pixel_x = 0
				pixel_y = 0
				invisibility = INVISIBILITY_OBSERVER
				alpha = 100
	update_icon()

	if(!T)

		T = SSmapping.get_station_center()

	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = random_unique_name(gender)
	real_name = name

	if(!fun_verbs)
		remove_verb(src, /mob/dead/observer/verb/boo)
		remove_verb(src, /mob/dead/observer/verb/possess)

	if(!isscryeye(src))
		GLOB.dead_mob_list += src

	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)
	become_hearing_sensitive()
	. = ..()

	grant_all_languages()

/mob/dead/observer/Login()
	. = ..()
	setup_ghost_verbs()

/mob/dead/observer/proc/setup_ghost_verbs()
	if(client)
		add_verb(client, GLOB.ghost_verbs)
	client?.init_verbs()
	to_chat(src, span_danger("Click the <b>SKULL</b> on the left of your HUD to respawn."))

/mob/dead/observer/narsie_act()
	var/old_color = color
	color = "#960000"
	animate(src, color = old_color, time = 10, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 10)

/mob/dead/observer/Destroy()
	STOP_PROCESSING(SShaunting, src)

	QDEL_NULL(spawners_menu)
	QDEL_NULL(orbit_menu)
	return ..()

/mob/dead/CanPass(atom/movable/mover, turf/target)
	return 1

/mob/dead/observer/CanPass(atom/movable/mover, turf/target)
	if(!isinhell && isplayerghost(src) && isplayerghost(mover))
		return 0
	return 1

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/proc/make_observer(ghostpath, reenter = TRUE)
	if(!key)
		return
	stop_sound_channel(CHANNEL_HEARTBEAT)
	if(client)
		SSdroning.kill_rain(client)
		SSdroning.kill_loop(client)
		SSdroning.kill_droning(client)
	var/mob/dead/observer/ghost = new ghostpath(src)
	ghost.ghostize_time = world.time
	SStgui.on_transfer(src, ghost)
	ghost.can_reenter_corpse = reenter
	return ghost

/mob/proc/ghostize(can_reenter_corpse = 1, force_respawn = FALSE, admin = FALSE, drawskip, ignore_zombie = FALSE)
	var/ghostpath = /mob/dead/observer
	if(admin)
		ghostpath = /mob/dead/observer/admin
	else if(drawskip)
		ghostpath = /mob/dead/observer/nodraw
	var/mob/dead/observer/ghost = make_observer(ghostpath, can_reenter_corpse)
	if(!ghost)
		return
	if(!admin)
		ghost.add_client_colour(/datum/client_colour/monochrome)
	ghost.advjob = advjob
	if(click_intercept && istype(click_intercept, /datum/action/cooldown))
		var/datum/action/cooldown/ability = click_intercept
		ability.unset_click_ability(src, refund_cooldown = FALSE)
	ghost.key = key
	return ghost

/mob/living/carbon/human/ghostize(can_reenter_corpse = 1, force_respawn = FALSE, admin = FALSE, drawskip = FALSE, ignore_zombie = FALSE)
	if(mind && !ignore_zombie)
		if(mind.has_antag_datum(/datum/antagonist/zombie))
			if(force_respawn)
				mind.remove_antag_datum(/datum/antagonist/zombie)
				return ..()
			var/datum/antagonist/zombie/Z = mind.has_antag_datum(/datum/antagonist/zombie)
			if(!Z.revived)
				if(!(world.time % 5))
					to_chat(src, span_warning("I'm preparing to walk again."))
				return
	return ..()

/mob/proc/scry_ghost(eyetype = /mob/dead/observer/eye/screye)
	var/mob/dead/observer/eye/ghost = make_observer(eyetype)
	if(!ghost)
		return
	ghost.key = key
	return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set name = "Ghost"
	set desc = ""
	set hidden = 1
	if(!usr.client.holder)
		return
	if(stat != DEAD)
		succumb()
	if(stat == DEAD)
		ghostize(1)
	else
		var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?","Ghost","Stay in body")
		if(response != "Ghost")
			return	//didn't want to ghost after-all
		ghostize(0)						//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3

/mob/camera/verb/ghost()
	set name = "Ghost"
	set desc = ""
	set hidden = 1
	if(!usr.client.holder)
		return
	var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?","Ghost","Stay in body")
	if(response != "Ghost")
		return
	ghostize(0)

/mob/dead/observer/Move(NewLoc, direct)
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own
	if(NewLoc)
		var/turf/target_turf = get_turf(NewLoc)
		if(target_turf)
			return forceMove(target_turf)
		return FALSE
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return FALSE
	var/turf/step_turf = get_step(current_turf, direct)
	if(step_turf)
		return forceMove(step_turf)
	return FALSE

/mob/dead/observer/proc/reenter_corpse()
	set name = "Re-enter Corpse"
	set hidden = 1
	if(!client)
		return
	if(!mind || QDELETED(mind.current))
		to_chat(src, span_warning("I have no body."))
		return
	if(!can_reenter_corpse)
		to_chat(src, span_warning("I cannot re-enter my body."))
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, span_warning("Another consciousness is in my body... It is resisting me."))
		return
//	stop_all_loops()
	SSdroning.kill_rain(src.client)
	SSdroning.kill_loop(src.client)
	SSdroning.kill_droning(src.client)
	remove_client_colour(/datum/client_colour/monochrome)
	client.change_view(CONFIG_GET(string/default_view))
	if(client)
		remove_verb(client, GLOB.ghost_verbs)
	client?.init_verbs()
	SStgui.on_transfer(src, mind.current) // Transfer NanoUIs.
	mind.current.key = key
	return TRUE

/mob/dead/observer/returntolobby(modifier as num)
	set name = "{RETURN TO LOBBY}"
	set category = "Preferences.Options"
	set hidden = 1
	if (CONFIG_GET(flag/norespawn))
		return
	if(trapped)
		return
	if ((stat != DEAD || !( SSticker )))
		to_chat(src, span_boldnotice("I must be dead to use this!"))
		return

//	if(mind?.current && (world.time < mind.current.timeofdeath + RESPAWNTIME))
//		to_chat(usr, span_warning("I can return in [mind.current.timeofdeath + RESPAWNTIME - world.time]."))
//		return

	if(key)
		if(modifier)
			GLOB.respawntimes[key] = world.time + modifier
		else
			GLOB.respawntimes[key] = world.time

	log_game("[key_name(src)] used abandon mob.")

	to_chat(src, span_info("Returned to lobby successfully."))

	if(!client)
		log_game("[key_name(src)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
//	stop_all_loops()
	SSdroning.kill_rain(src.client)
	SSdroning.kill_loop(src.client)
	SSdroning.kill_droning(src.client)
	remove_client_colour(/datum/client_colour/monochrome)
	if(!client)
		log_game("[key_name(src)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(src)] AM failed due to disconnect.")
		qdel(M)
		return

	remove_verb(client, GLOB.ghost_verbs)
	client.init_verbs()
	M.key = key
	return


/mob/dead/observer/verb/stay_dead()
	set name = "Do Not Resuscitate"
	set hidden = 1
	if(!check_rights(R_WATCH))
		return
	if(!client)
		return
	if(!can_reenter_corpse)
		to_chat(usr, span_warning("You're already stuck out of your body!"))
		return FALSE

	var/response = alert(src, "Are you sure you want to prevent (almost) all means of resuscitation? This cannot be undone. ","Are you sure you want to stay dead?","DNR","Save Me")
	if(response != "DNR")
		return

	can_reenter_corpse = FALSE
	to_chat(src, span_boldnotice("I can no longer be brought back into your body."))
	return TRUE

/mob/dead/observer/proc/notify_cloning(message, sound, atom/source, flashwindow = TRUE)
	if(flashwindow)
		window_flash(client)
	if(message)
		to_chat(src, span_ghostalert("[message]"))
		if(source)
			var/atom/movable/screen/alert/A = throw_alert("[REF(source)]_notify_cloning", /atom/movable/screen/alert/notify_cloning)
			if(A)
				A.icon = 'icons/mob/roguehud.dmi'
				A.desc = message
				var/old_layer = source.layer
				var/old_plane = source.plane
				source.layer = FLOAT_LAYER
				source.plane = FLOAT_PLANE
				A.add_overlay(source)
				source.layer = old_layer
				source.plane = old_plane
	to_chat(src, span_ghostalert("<a href=?src=[REF(src)];reenter=1>(Click to re-enter)</a>"))
	if(sound)
		SEND_SOUND(src, sound(sound))

/mob/dead/observer/proc/dead_tele()
	set name = "Teleport"
	set desc= "Teleport to a location"
	set hidden = 1
	if(!isobserver(usr))
		to_chat(usr, span_warning("Not when you're not dead!"))
		return
	if(trapped || isscryeye(src))
		return
	area_tele()

/mob/dead/observer/proc/area_tele()
	var/list/filtered = list()
	for(var/V in GLOB.sortedAreas)
		var/area/A = V
		if(!A.hidden)
			filtered += A
	var/area/thearea	= input(usr, "Area to jump to", "BOOYEA") as null|anything in filtered

	if(!thearea)
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		to_chat(src, span_warning("No area available."))
		return

	forceMove(pick(L))

/mob/dead/observer/verb/follow()
	set name = "Orbit" // "Haunt"
	set desc = ""
	set hidden = 1
	var/list/mobs
	if(usr.client in GLOB.admins)
		mobs = getpois(mobs_only=TRUE,skip_mindless=TRUE,skip_antighost=FALSE)
	else
		mobs = getpois(mobs_only=TRUE,skip_mindless=TRUE)

	var/input = input(usr, "Who?!", "Haunt", null) as null|anything in mobs
	var/mob/target = mobs[input]
	ManualFollow(target)

/datum/mind
	var/list/attackedme = list()

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if (!istype(target))
		return
	if(trapped)
		return

	if(is_hidden_from_ghosts(target, src))
		return

	var/icon/I = icon(target.icon,target.icon_state,target.dir)

	var/orbitsize = (I.Width()+I.Height())*0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

	var/rot_seg

	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36 //360/10 bby, smooth enough aproximation of a circle

	orbit(target,orbitsize, FALSE, 20, rot_seg)
	orbiting_ref = REF(target)

/mob/dead/observer/orbit()
	setDir(2)//reset dir so the right directional sprites show up
	pixel_x = 25 //it's coal sire but it works to properly orbit around your target instead of a tile off to the side
	return ..()

/mob/dead/observer/stop_orbit(datum/component/orbiter/orbits)
	. = ..()
	orbiting_ref = null
	//restart our floating animation after orbit is done.
	pixel_y = 0
	pixel_x = 0
	animate(src, pixel_y = 2, time = 10, loop = -1)

/mob/dead/observer/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set name = "Jump to Mob"
	set desc = ""
	set hidden = 1

	if(trapped || isscryeye(src))
		return
	if(isobserver(usr)) //Make sure they're an observer!


		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null		//Chosen target.

		dest += getpois(mobs_only=TRUE) //Fill list, prompt user with list
		target = input(usr, "Please, select a player!", "Jump to Mob", null) as null|anything in dest

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src				//Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.forceMove(T)
			else
				to_chat(A, span_danger("This mob is not located in the game world."))

/mob/dead/observer/verb/boo()
	set category = "Ghost"
	set name = "Boo!"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time)
		return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return


/mob/dead/observer/memory()
	set hidden = 1
	to_chat(src, span_danger("I are dead! You have no mind to store memory!"))

/mob/dead/observer/add_memory()
	set hidden = 1
	to_chat(src, span_danger("I are dead! You have no mind to store memory!"))

/mob/dead/observer/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = ""
	set hidden = 1
	ghostvision = !(ghostvision)
	update_sight()
	to_chat(usr, span_boldnotice("I [(ghostvision?"now":"no longer")] have ghost vision."))

/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set hidden = 1
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	update_sight()

/mob/dead/observer/update_sight()
	if (!ghostvision)
		see_invisible = SEE_INVISIBLE_LIVING
	else
		see_invisible = SEE_INVISIBLE_OBSERVER

	..()

/mob/dead/observer/proc/horde_respawn()
	if(trapped)
		return
	var/bt = world.time
	SEND_SOUND(src, sound('sound/misc/notice (2).ogg'))
	if(alert(src, "You have been summoned you to destroy Azuria!", "Join the Horde", "Yes", "No") == "Yes")
		if(world.time > bt + 5 MINUTES)
			to_chat(src, span_warning("Too late."))
			return FALSE
		returntolobby(RESPAWNTIME*-1)

/mob/dead/observer/verb/possess()
	set category = "Ghost"
	set name = "Possess!"
	set desc= "Take over the body of a mindless creature!"

	var/list/possessible = list()
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(istype(L,/mob/living/carbon/human/dummy) || !get_turf(L)) //Haha no.
			continue
		if(!(L in GLOB.player_list) && !L.mind)
			possessible += L

	var/mob/living/target = input(usr, "Your new life begins today!", "Possess Mob", null) as null|anything in sortNames(possessible)

	if(!target)
		return FALSE

	if(can_reenter_corpse && mind?.current)
		if(alert(src, "Your soul is still tied to your former life as [mind.current.name], if you go forward there is no going back to that life. Are you sure you wish to continue?", "Move On", "Yes", "No") == "No")
			return FALSE
	if(target.key)
		to_chat(src, span_warning("Someone has taken this body while you were choosing!"))
		return FALSE

	target.key = key
	target.faction = list(FACTION_NEUTRAL)
	return TRUE

/mob/dead/observer/verb/view_manifest()
	set name = "View Crew Manifest"
	set hidden = 1
	if(!check_rights(R_WATCH))
		return
	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += GLOB.data_core.get_manifest()

	src << browse(dat, "window=manifest;size=387x420;can_close=1")

//this is called when a ghost is drag clicked to something.
/mob/dead/observer/MouseDrop(atom/over)
	if(!usr || !over)
		return
	if (isobserver(usr) && usr.client.holder && (isliving(over) || iscameramob(over)) )
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()

/mob/dead/observer/Topic(href, href_list)
	..()
	if(usr == src)
		if(href_list["follow"])
			var/atom/movable/target = locate(href_list["follow"])
			if(istype(target) && (target != src))
				ManualFollow(target)
				return
		if(href_list["x"] && href_list["y"] && href_list["z"])
			var/tx = text2num(href_list["x"])
			var/ty = text2num(href_list["y"])
			var/tz = text2num(href_list["z"])
			var/turf/target = locate(tx, ty, tz)
			if(istype(target))
				forceMove(target)
				return
		if(href_list["reenter"])
			reenter_corpse()
			return

//We don't want to update the current var
//But we will still carry a mind.
/mob/dead/observer/mind_initialize()
	return

/mob/dead/observer/verb/restore_ghost_appearance()
	set name = "Restore Ghost Character"
	set desc = "Sets your deadchat name and ghost appearance to your \
		roundstart character."
	set hidden = 1
	if(!check_rights(R_WATCH))
		return
	set_ghost_appearance()
	if(client && client.prefs)
		deadchat_name = client.prefs.real_name
		mind.ghostname = client.prefs.real_name
		name = client.prefs.real_name

/mob/dead/observer/proc/set_ghost_appearance()
	if((!client) || (!client.prefs))
		return

	update_icon()

/mob/dead/observer/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	return IsAdminGhost(usr)

/mob/dead/observer/is_literate()
	return TRUE

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	switch(var_name)
		if("icon")
			ghostimage_default.icon = icon
			ghostimage_simple.icon = icon
		if("icon_state")
			ghostimage_default.icon_state = icon_state
			ghostimage_simple.icon_state = icon_state
		if("fun_verbs")
			if(fun_verbs)
				add_verb(src, /mob/dead/observer/verb/boo)
				add_verb(src, /mob/dead/observer/verb/possess)
			else
				remove_verb(src, /mob/dead/observer/verb/boo)
				remove_verb(src, /mob/dead/observer/verb/possess)

/mob/dead/observer/reset_perspective(atom/A)
	if(client)
		if(ismob(client.eye) && (client.eye != src))
			var/mob/target = client.eye
			observetarget = null
			if(target.observers)
				target.observers -= src
				UNSETEMPTY(target.observers)
	if(..())
		if(hud_used)
			client.screen = list()
			hud_used.show_hud(hud_used.hud_version)

/mob/dead/observer/verb/observe()
	set name = "Observe"
	set hidden = 1
	if(!check_rights(R_WATCH))
		return
	var/list/creatures = getpois()

	reset_perspective(null)

	var/eye_name = null

	eye_name = input(usr, "Please, select a player!", "Observe", null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]
	//Istype so we filter out points of interest that are not mobs
	if(client && mob_eye && istype(mob_eye))
		client.eye = mob_eye
		if(mob_eye.hud_used)
			client.screen = list()
			LAZYINITLIST(mob_eye.observers)
			mob_eye.observers |= src
			mob_eye.hud_used.show_hud(mob_eye.hud_used.hud_version, src)
			observetarget = mob_eye

/mob/dead/observer/CtrlShiftClick(mob/user)
	if(isobserver(user) && check_rights(R_SPAWN))
		change_mob_type( /mob/living/carbon/human , null, null, TRUE) //always delmob, ghosts shouldn't be left lingering

/mob/dead/observer/examine(mob/user)
	. = ..()
	if(!invisibility)
		. += "It seems extremely obvious."

/mob/dead/observer/proc/set_invisibility(value)
	invisibility = value
	if(!value)
		set_light(1, 1, 2)
	else
		set_light(0, 0, 0)

/mob/dead/observer/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == "invisibility")
		set_invisibility(invisibility) // updates light

/proc/set_observer_default_invisibility(amount, message=null)
	for(var/mob/dead/observer/G in GLOB.player_list)
		G.set_invisibility(amount)
		if(message)
			to_chat(G, message)
	GLOB.observer_default_invisibility = amount

/mob/dead/observer/proc/open_spawners_menu()
	set name = "Spawners Menu"
	set desc = ""
	set hidden = 1
	if(!check_rights(R_DEBUG))
		return
	if(!spawners_menu)
		spawners_menu = new(src)

	spawners_menu.ui_interact(src)

/mob/dead/observer/proc/open_orbit_menu()
	set name = "Orbit"
	set desc = ""
	set category = "Ghost"
	set hidden = 1
	if(!orbit_menu)
		orbit_menu = new(src)

	orbit_menu.ui_interact(src)

/mob/dead/observer/proc/tray_view()
	set name = "T-ray view"
	set desc = ""
	set hidden = 1
	if(!check_rights(R_WATCH))
		return
	var/static/t_ray_view = FALSE
	t_ray_view = !t_ray_view

	var/list/t_ray_images = list()
	var/static/list/stored_t_ray_images = list()
	for(var/obj/O in orange(client.view, src) )
		if(O.level != 1)
			continue

		if(O.invisibility == INVISIBILITY_MAXIMUM)
			var/image/I = new(loc = get_turf(O))
			var/mutable_appearance/MA = new(O)
			MA.alpha = 128
			MA.dir = O.dir
			I.appearance = MA
			t_ray_images += I
	stored_t_ray_images += t_ray_images
	if(t_ray_images.len)
		if(t_ray_view)
			client.images += t_ray_images
		else
			client.images -= stored_t_ray_images


/datum/orbit_menu
	var/mob/dead/observer/owner
	var/list/cached_orbit_data
	var/cached_orbit_data_user_ref
	var/cached_orbit_data_time = 0
	var/orbit_cache_ttl_ds = 10

/datum/orbit_menu/New(mob/dead/observer/new_owner)
	if(!istype(new_owner))
		qdel(src)
		return
	owner = new_owner
	..()

/datum/orbit_menu/Destroy()
	cached_orbit_data = null
	cached_orbit_data_user_ref = null
	owner = null
	return ..()

/datum/orbit_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Orbit", "Orbit", 460, 560)
		ui.set_state(GLOB.observer_state)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/orbit_menu/ui_static_data(mob/user)
	return get_orbit_data_snapshot(user)

/datum/orbit_menu/ui_data(mob/user)
	var/list/data = list()
	data["orbiting_ref"] = owner?.orbiting_ref
	return data

/datum/orbit_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!istype(owner) || !isobserver(ui?.user))
		return TRUE

	switch(action)
		if("orbit")
			var/ref = params["ref"]
			if(!ref)
				return TRUE

			var/atom/movable/target = locate(ref)
			if(!istype(target))
				to_chat(ui.user, span_notice("That target is no longer available."))
				return TRUE

			if(istype(target, /mob/dead/new_player))
				to_chat(ui.user, span_notice("You cannot orbit lobby players."))
				return TRUE

			if(is_hidden_from_ghosts(target, owner))
				to_chat(ui.user, span_notice("That target is protected from ghost orbit."))
				return TRUE

			owner.ManualFollow(target)
			SStgui.update_uis(src)
			return TRUE

		if("refresh")
			invalidate_orbit_cache()
			ui.send_full_update()
			return TRUE

	return FALSE

/datum/orbit_menu/proc/invalidate_orbit_cache()
	cached_orbit_data = null
	cached_orbit_data_user_ref = null
	cached_orbit_data_time = 0

/datum/orbit_menu/proc/get_orbit_data_snapshot(mob/user)
	if(!istype(user))
		return build_orbit_data(user)

	var/user_ref = REF(user)
	if(cached_orbit_data && cached_orbit_data_user_ref == user_ref && (world.time - cached_orbit_data_time) <= orbit_cache_ttl_ds)
		return cached_orbit_data

	var/list/data = build_orbit_data(user)

	cached_orbit_data = data
	cached_orbit_data_user_ref = user_ref
	cached_orbit_data_time = world.time
	return data

/datum/orbit_menu/proc/build_orbit_data(mob/user)
	var/list/data = list(
		"alive" = list(),
		"dead" = list(),
		"ghosts" = list(),
	)

	var/list/namecounts_alive = list()
	var/list/namecounts_dead = list()
	var/list/namecounts_ghosts = list()
	var/list/role_color_cache = list()

	for(var/mob/M in sortmobs())
		if(M.client?.holder?.fakekey)
			continue
		if(istype(M, /mob/dead/new_player))
			continue
		if(is_hidden_from_ghosts(M, user))
			continue

		if(isobserver(M))
			append_serialized_target(data["ghosts"], M, namecounts_ghosts, role_color_cache)
			continue

		if(M.stat == DEAD)
			if(!M.mind && !M.ckey)
				continue
			append_serialized_target(data["dead"], M, namecounts_dead, role_color_cache)
			continue

		if(istype(M, /mob/living/carbon/human/species/npc/deadite))
			continue

		if(!M.mind && !M.ckey)
			continue

		append_serialized_target(data["alive"], M, namecounts_alive, role_color_cache)

	return data

/datum/orbit_menu/proc/append_serialized_target(list/bucket, atom/movable/target, list/namecounts, list/role_color_cache)
	if(!islist(bucket))
		return

	var/list/entry = serialize_atom(target, namecounts, role_color_cache)
	if(!entry)
		return

	bucket += list(entry)

/datum/orbit_menu/proc/get_role_selection_color(assigned_role, list/role_color_cache, datum/job/J = null)
	if(!assigned_role)
		return null

	if(role_color_cache)
		var/cached_color = role_color_cache[assigned_role]
		if(!isnull(cached_color))
			return cached_color || null

	var/resolved_color = null
	if(!J)
		J = SSjob.GetJob(assigned_role)
	if(J)
		var/department = SSjob.bitflag_to_department(J.department_flag, J.obsfuscated_job)
		var/list/department_colors = JCOLOR_BY_DEPARTMENT
		if(department_colors[department])
			resolved_color = department_colors[department]
		else if(J.selection_color)
			resolved_color = J.selection_color

	if(role_color_cache)
		role_color_cache[assigned_role] = resolved_color || ""

	return resolved_color

/datum/orbit_menu/proc/get_orbit_antag_group(mob/M)
	if(!istype(M) || !M.mind)
		return null

	var/special_role = M.mind.special_role
	var/assigned_role = M.mind.assigned_role || M.job

	for(var/datum/antagonist/A in M.mind.antag_datums)
		var/list/candidate = get_orbit_antag_candidate(M, A, special_role, assigned_role)
		if(candidate && candidate["group"])
			return candidate["group"]

	var/static/list/major_antag_typecache = typecacheof(list(
		/datum/antagonist/werewolf,
		/datum/antagonist/vampire,
		/datum/antagonist/lich,
	))
	var/static/list/minor_antag_typecache = typecacheof(list(
		/datum/antagonist/bandit,
		/datum/antagonist/wretch,
		/datum/antagonist/gnoll,
	))

	var/has_minor = FALSE
	for(var/datum/antagonist/A in M.mind.antag_datums)
		if(is_type_in_typecache(A, major_antag_typecache))
			return "major"
		if(is_type_in_typecache(A, minor_antag_typecache))
			has_minor = TRUE

	if(has_minor)
		return "minor"

	return null

/datum/orbit_menu/proc/get_orbit_antag_info(mob/M)
	if(!istype(M) || !M.mind)
		return null

	var/best_priority = 100000
	var/best_group = null
	var/best_label = null
	var/special_role = M.mind.special_role
	var/assigned_role = M.mind.assigned_role || M.job

	for(var/datum/antagonist/A in M.mind.antag_datums)
		var/list/candidate = get_orbit_antag_candidate(M, A, special_role, assigned_role)
		if(!candidate)
			continue

		var/candidate_priority = candidate["priority"]
		if(candidate_priority < best_priority)
			best_priority = candidate_priority
			best_group = candidate["group"]
			best_label = candidate["label"]

	if(best_group && best_label)
		return list(
			"group" = best_group,
			"label" = best_label,
		)

	return null

/datum/orbit_menu/proc/get_orbit_antag_candidate(mob/M, datum/antagonist/A, special_role, assigned_role)
	if(!istype(A))
		return null

	if(istype(A, /datum/antagonist/vampire/lord))
		return list("priority" = 10, "group" = "major", "label" = "Vampire Lord")
	if(istype(A, /datum/antagonist/vampire/ancillae))
		return list("priority" = 11, "group" = "major", "label" = "Ancillae Vampire")
	if(istype(A, /datum/antagonist/vampire/licker))
		return list("priority" = 12, "group" = "major", "label" = "Lesser Vampire")
	if(istype(A, /datum/antagonist/vampire/thinblood))
		return list("priority" = 13, "group" = "major", "label" = "Thinblood Vampire")
	if(istype(A, /datum/antagonist/vampire))
		var/datum/antagonist/vampire/V = A
		if(V.generation >= GENERATION_METHUSELAH)
			return list("priority" = 14, "group" = "major", "label" = "Vampire Lord")
		if(special_role == "Vampire Spawn")
			return list("priority" = 15, "group" = "major", "label" = "Vampire Spawn")
		return list("priority" = 16, "group" = "major", "label" = "Lesser Vampire")

	if(istype(A, /datum/antagonist/werewolf))
		if(A.name == "Lesser Verevolf")
			return list("priority" = 20, "group" = "major", "label" = "Lesser Werewolf")
		return list("priority" = 21, "group" = "major", "label" = "Werewolf")

	if(istype(A, /datum/antagonist/lich))
		return list("priority" = 30, "group" = "major", "label" = "Lich")

	if(istype(A, /datum/antagonist/skeleton/knight))
		return list("priority" = 40, "group" = "minor", "label" = "Death Knight")
	if(istype(A, /datum/antagonist/skeleton))
		if(special_role == ROLE_LICH_SKELETON)
			return list("priority" = 41, "group" = "minor", "label" = "Lich Skeleton")
		if(special_role == ROLE_NECRO_SKELETON)
			return list("priority" = 42, "group" = "minor", "label" = "Necromancer Skeleton")
		if(HAS_TRAIT(M, TRAIT_LICHLAIR))
			return list("priority" = 43, "group" = "minor", "label" = "Lich Skeleton")
		if(assigned_role == "Fortified Skeleton" || assigned_role == "Greater Skeleton")
			return list("priority" = 44, "group" = "minor", "label" = "Necromancer Skeleton")
		return list("priority" = 45, "group" = "minor", "label" = "Skeleton")

	if(istype(A, /datum/antagonist/bandit))
		return list("priority" = 50, "group" = "minor", "label" = "Bandit")
	if(istype(A, /datum/antagonist/wretch))
		return list("priority" = 51, "group" = "minor", "label" = "Wretch")
	if(istype(A, /datum/antagonist/gnoll))
		return list("priority" = 52, "group" = "minor", "label" = "Gnoll")

	var/list/extra_candidate = get_orbit_extra_antag_candidate(A, special_role)
	if(extra_candidate)
		return extra_candidate

	return null

/datum/orbit_menu/proc/get_orbit_extra_antag_candidate(datum/antagonist/A, special_role)
	var/static/list/orbit_extra_antag_definitions = list(
		list("type" = /datum/antagonist/ascendant, "group" = "major", "priority" = 60),
		list("type" = /datum/antagonist/dreamwalker, "group" = "major", "priority" = 61),
		list("type" = /datum/antagonist/unbound_death_knight, "group" = "major", "priority" = 62),
		list("type" = /datum/antagonist/zizo_knight, "group" = "major", "priority" = 63),
		list("type" = /datum/antagonist/prebel/head, "group" = "minor", "priority" = 70),
		list("type" = /datum/antagonist/prebel, "group" = "minor", "priority" = 71),
		list("type" = /datum/antagonist/aspirant, "group" = "minor", "priority" = 72),
		list("type" = /datum/antagonist/assassin, "group" = "minor", "priority" = 73),
		list("type" = /datum/antagonist/hag, "group" = "minor", "priority" = 74)
	)

	for(var/list/def in orbit_extra_antag_definitions)
		if(istype(A, def["type"]))
			return list(
				"priority" = def["priority"],
				"group" = def["group"],
				"label" = A.name || special_role || "Antagonist",
			)

	return null

/datum/orbit_menu/proc/serialize_atom(atom/movable/target, list/namecounts, list/role_color_cache)
	if(!istype(target))
		return null

	var/display_name
	if(ismob(target))
		var/mob/M = target
		display_name = avoid_assoc_duplicate_keys(M.real_name || M.name, namecounts)
		if(M.real_name && M.real_name != M.name)
			display_name += " \[[M.name]\]"
	else
		display_name = avoid_assoc_duplicate_keys(target.name, namecounts)

	var/orbiter_count = 0
	if(target.orbiters)
		orbiter_count = length(target.orbiters.orbiters)

	var/list/entry = list(
		"full_name" = display_name,
		"ref" = REF(target),
		"orbiters" = orbiter_count,
	)

	if(ismob(target))
		var/mob/M = target
		if(M.stat != DEAD && !isobserver(M))
			var/list/antag_info = get_orbit_antag_info(M)
			if(antag_info)
				entry["antag_group"] = antag_info["group"]
				entry["antag_role"] = antag_info["label"]
			else
				var/antag_group = get_orbit_antag_group(M)
				if(antag_group)
					entry["antag_group"] = antag_group
		if(M.mind?.assigned_role)
			var/assigned_role = M.mind.assigned_role
			entry["role"] = assigned_role
			var/datum/job/J = SSjob.GetJob(assigned_role)
			if(J)
				var/job_department = SSjob.bitflag_to_department(J.department_flag, J.obsfuscated_job)
				if(job_department)
					entry["department"] = job_department
			var/selection_color = get_role_selection_color(assigned_role, role_color_cache, J)
			if(selection_color)
				entry["selection_color"] = selection_color
		if(M.job)
			entry["job"] = M.job
		if(isliving(M))
			var/mob/living/L = M
			if(L.maxHealth > 0)
				entry["health_percent"] = round(clamp((L.health / L.maxHealth) * 100, 0, 100))
		if(istype(M, /mob/living/carbon/human/species/npc/deadite))
			entry["role"] = "Deadite NPC"

	return entry
