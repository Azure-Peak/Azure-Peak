/atom/movable/screen/ghost
	icon = 'icons/mob/screen_ghost.dmi'
	nomouseover = FALSE

/atom/movable/screen/ghost/MouseEntered()
//	flick(icon_state + "_anim", src)
	..()

/atom/movable/screen/ghost/jumptomob
	name = "Jump to mob"
	icon_state = "jumptomob"

/atom/movable/screen/ghost/jumptomob/Click()
	var/mob/dead/observer/G = usr
	G.jumptomob()

/atom/movable/screen/ghost/orbit
	name = "Orbit"
	icon_state = "orbit"

/atom/movable/screen/ghost/orbit/Click()
	var/mob/dead/observer/G = usr
	G.follow()
//skull
/atom/movable/screen/ghost/orbit/rogue
	name = "AFTER LIFE"
	icon = 'icons/mob/ghostspin.dmi'
	icon_state = ""
	screen_loc = "WEST-4,SOUTH+6"

/atom/movable/screen/ghost/orbit/rogue/Click(location, control, params)
	var/mob/dead/observer/G = usr
	var/paramslist = params2list(params)
	if(paramslist["right"]) // screen objects don't do the normal Click() stuff so we'll cheat
		G.follow()
	else
		if(G.client)
			if(istype(G, /mob/dead/observer/rogue/arcaneeye))
				return
			if(alert("Travel with the boatman?", "", "Yes", "No") == "Yes")
				if(G.mind)
					var/datum/job/target_job = SSjob.GetJob(G.mind.assigned_role)
					if(target_job)
						if(target_job.job_reopens_slots_on_death)
							target_job.current_positions = max(0, target_job.current_positions - 1)
						if(target_job.same_job_respawn_delay)
							// Store the current time for the player
							GLOB.job_respawn_delays[G.ckey] = world.time + target_job.same_job_respawn_delay

				G.returntolobby(0)

/atom/movable/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"

/atom/movable/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/teleport
	name = "Teleport"
	icon_state = "teleport"

/atom/movable/screen/ghost/teleport/Click()
	var/mob/dead/observer/G = usr
	G.dead_tele()

/atom/movable/screen/ghost/moveup
	name = "Move Up"
	icon_state = "up"

/atom/movable/screen/ghost/moveup/Click()
	var/mob/dead/observer/G = usr
	G.ghost_up()

/atom/movable/screen/ghost/movedown
	name = "Move Down"
	icon_state = "down"

/atom/movable/screen/ghost/bigassuselessbutton
	name = "AFTER LIFE"
	icon = 'icons/mob/ghostspin.dmi'
	icon_state = ""
	screen_loc = "WEST-4,SOUTH+6"
	nomouseover = FALSE

/atom/movable/screen/ghost/movedown/Click()
	var/mob/dead/observer/G = usr
	G.ghost_down()

/datum/hud/ghost/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/ghost/orbit(null, src)
	using.screen_loc = ui_ghost_orbit
	static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse(null, src)
	using.screen_loc = ui_ghost_reenter_corpse
	static_inventory += using

	using = new /atom/movable/screen/ghost/teleport(null, src)
	using.screen_loc = ui_ghost_teleport
	static_inventory += using

	using =  new /atom/movable/screen/backhudl/ghost()
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/moveup(null, src)
	using.screen_loc = ui_ghost_moveup
	static_inventory += using

	using = new /atom/movable/screen/ghost/movedown(null, src)
	using.screen_loc = ui_ghost_movedown
	static_inventory += using

	grain = new /atom/movable/screen/grain
	grain.hud = src
	static_inventory += grain
	if(owner.client?.prefs?.grain == TRUE)
		grain.alpha = 55

	scannies = new /atom/movable/screen/scannies
	scannies.hud = src
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

	using = new /atom/movable/screen/ghost/orbit/rogue()
	using.hud = src
	static_inventory += using

/datum/hud/adminghost/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/ghost/orbit(null, src)
	using.screen_loc = ui_ghost_orbit
	static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse(null, src)
	using.screen_loc = ui_ghost_reenter_corpse
	static_inventory += using

	using = new /atom/movable/screen/ghost/teleport(null, src)
	using.screen_loc = ui_ghost_teleport
	static_inventory += using

	using = new /atom/movable/screen/ghost/moveup(null, src)
	using.screen_loc = ui_ghost_moveup
	static_inventory += using

	using = new /atom/movable/screen/ghost/movedown(null, src)
	using.screen_loc = ui_ghost_movedown
	static_inventory += using

	using = new /atom/movable/screen/ghost/bigassuselessbutton(null, src)
	static_inventory += using

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

/datum/hud/eye/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using =  new /atom/movable/screen/backhudl/ghost()
	using.hud = src
	static_inventory += using

	grain = new /atom/movable/screen/grain
	grain.hud = src
	static_inventory += grain
	if(owner.client?.prefs?.grain == TRUE)
		grain.alpha = 55

	scannies = new /atom/movable/screen/scannies
	scannies.hud = src
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

/datum/hud/eye/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

/datum/hud/obs/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using =  new /atom/movable/screen/backhudl/obs()
	using.hud = src
	static_inventory += using

	grain = new /atom/movable/screen/grain
	grain.hud = src
	static_inventory += grain
	if(owner.client?.prefs?.grain == TRUE)
		grain.alpha = 55

	scannies = new /atom/movable/screen/scannies
	scannies.hud = src
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70
