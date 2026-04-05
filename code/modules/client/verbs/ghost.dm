GLOBAL_LIST_INIT(ghost_verbs, list(
	/client/proc/ghost_up,
	/client/proc/ghost_down,
	/client/proc/descend,
	/client/proc/reenter_corpse,
	/client/proc/dead_observe
	))

/client/proc/ghost_up()
	set category = "Spirit"
	set name = "GhostUp"
	if(isobserver(mob))
		mob.ghost_up()

/client/proc/ghost_down()
	set category = "Spirit"
	set name = "GhostDown"
	if(isobserver(mob))
		mob.ghost_down()

/client/proc/descend()
	set name = "Journey to the Underworld"
	set category = "Spirit"

	switch(alert("Descend to the Underworld?",,"Yes","No"))
		if("Yes")
			if(istype(mob, /mob/living/carbon/spirit))
				return

			if(istype(mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/D = mob
				if(D.buried && D.funeral)
					D.returntolobby()
					return
			verbs -= GLOB.ghost_verbs
			mob.returntolobby()
		if("No")
			usr << "You have second thoughts."

/client/proc/dead_observe()
	set category = "Spirit"
	set name = "Leave Your Body"

	if(mob.stat == DEAD && isliving(mob))
		message_admins("[key_name_admin(usr)] is ghosting from their dead body.")
		mob.ghostize(TRUE, ignore_zombie = TRUE)

/client/proc/reenter_corpse()
	set category = "Spirit"
	set name = "Reenter Corpse"
	if(isobserver(mob))
		message_admins("[key_name_admin(usr)] has re-entered their dead body.")
		var/mob/dead/observer/O = mob
		O.reenter_corpse()

/mob/verb/returntolobby()
	set name = "{RETURN TO LOBBY}"
	set category = "Options"
	set hidden = 1

	if(key)
		GLOB.respawntimes[key] = world.time

	// Notify the job datum that this player is permanently leaving the round
	if(mind?.assigned_role)
		var/datum/job/my_job = SSjob.GetJob(mind.assigned_role)
		if(my_job)
			my_job.on_round_removal(src)

	log_game("[key_name(usr)] respawned from underworld")

	to_chat(src, span_info("Returned to lobby successfully."))

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
//	stop_all_loops()
	SSdroning.kill_rain(src.client)
	SSdroning.kill_loop(src.client)
	SSdroning.kill_droning(src.client)
	remove_client_colour(/datum/client_colour/monochrome)
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	client?.verbs -= GLOB.ghost_verbs
	M.key = key
	if(istype(src, /mob/dead/observer)) //Be rid of clogging ghost shades
		qdel(src)
	return
