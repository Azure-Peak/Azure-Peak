//AKA cryosleep.

/obj/structure/far_travel //Shamelessly jury-rigged from the way Fallout13 handles this.
	name = "far travel"
	desc = "Frankly, my dear, I don't give a damn. </br>Click-drag yourself onto this tile to take your character out of the round. This leaves behind any important equipment and frees up your role's slot for another to take."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "fartravel"
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/in_use = FALSE

/obj/structure/far_travel/MouseDrop_T(atom/dropping, mob/user)
	. = ..()
	if(!isliving(user) || user.incapacitated())
		return //No ghosts or incapacitated folk allowed to do this.
	if(!ishuman(dropping))
		return //Only humans have job slots to be freed.
	if(in_use) // Someone's already going in.
		return
	var/mob/living/carbon/human/departing_mob = dropping
	var/datum/job/mob_job
	if(departing_mob != user && departing_mob.client)
		to_chat(user, "<span class='warning'>This one retains their free will. It's their choice if they want to leave the round or not.</span>")
		return
	if(alert("Are you sure you want to [departing_mob == user ? "depart the round for good (you" : "send this person away (they"] will be removed from the current round, and their role's slot will reopen for another to take)?", "Departing", "Confirm", "Cancel") != "Confirm")
		return
	if(user.incapacitated() || QDELETED(departing_mob) || (departing_mob != user && departing_mob.client) || get_dist(src, dropping) > 2 || get_dist(src, user) > 2)
		return //Things have changed since the alert happened.
	user.visible_message("<span class='warning'>[user] [departing_mob == user ? "is trying to depart from [SSticker.realm_name]!" : "is trying to send [departing_mob] away!"]</span>", "<span class='notice'>You [departing_mob == user ? "are trying to depart from [SSticker.realm_name]." : "are trying to send [departing_mob] away."]</span>")
	in_use = TRUE
	if(!do_after(user, 50, target = src))
		in_use = FALSE
		return
	in_use = FALSE
	update_icon()
	var/dat = "[ADMIN_LOOKUPFLW(user)] has despawned [departing_mob == user ? "themselves" : departing_mob], job [departing_mob.job], at [AREACOORD(src)]. Contents despawned along:"
	if(departing_mob.mind)
		mob_job = SSjob.GetJob(departing_mob.mind.assigned_role)
		if(mob_job)
			mob_job.current_positions = max(0, mob_job.current_positions - 1)
			var/target_job = SSrole_class_handler.get_advclass_by_name(user.advjob)
			if(target_job)
				SSrole_class_handler.adjust_class_amount(target_job, -1)
	if(!length(departing_mob.contents))
		dat += " none."
	else
		var/atom/movable/content = departing_mob.contents[1]
		dat += " [content.name]"
		for(var/i in 2 to length(departing_mob.contents))
			content = departing_mob.contents[i]
			dat += ", [content.name]"
		dat += "."
	if(departing_mob.mind)
		departing_mob.mind.unknow_all_people()
		for(var/datum/mind/MF in get_minds())
			departing_mob.mind.become_unknown_to(MF)
		for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
			if(removing_bounty.target == departing_mob.real_name)
				GLOB.head_bounties -= removing_bounty
	if(SSticker.rulermob == departing_mob)
		SSticker.rulermob = null
	if(SSticker.regentmob == departing_mob)
		SSticker.regentmob = null
	GLOB.chosen_names -= departing_mob.real_name
	LAZYREMOVE(GLOB.actors_list, departing_mob.mobid)
	LAZYREMOVE(GLOB.roleplay_ads, departing_mob.mobid)
	// Keep insiders' bank balance forfeits to the Crown's Purse on far-travel (silent OOC).
	// Day 0 is a grace window so roundstart bailouts don't accidentally hand the Crown a
	// windfall from a player who never had time to act in role. Loose mammon is tallied
	// separately for admin review so withdraw-to-pouch patterns leave a paper trail.
	if(SStreasury)
		var/recovered = 0
		var/datum/fund/account = SStreasury.get_account(departing_mob)
		var/is_keep_insider = (departing_mob.job in KEEP_INSIDER_JOBS)
		var/post_grace = GLOB.dayspassed >= 1
		if(account && is_keep_insider && post_grace && account.balance > 0)
			recovered = account.balance
			SStreasury.transfer(account, SStreasury.discretionary_fund, recovered, "Crown forfeiture: [departing_mob.real_name] (far-travel)")
			record_round_statistic(STATS_FORFEITURE_AMOUNT, recovered)
			record_round_statistic(STATS_FORFEITURE_COUNT, 1)
		var/loose = 0
		if(istype(departing_mob, /mob/living))
			loose = get_mammons_in_atom(departing_mob) || 0
		if(recovered > 0 || loose > 0 || is_keep_insider)
			dat += " | Coin at far-travel (day [GLOB.dayspassed]): [recovered]m forfeit from bank, [loose]m loose on person."
		SStreasury.remove_person(departing_mob)
	message_admins(dat)
	log_admin(dat)
	if(departing_mob.stat == DEAD)
		departing_mob.visible_message("<span class='notice'>[user] safely sends [departing_mob] away./span>")
	else
		departing_mob.visible_message("<span class='notice'>[departing_mob == user ? "Out of their own volition, " : "Ushered by [user], "][departing_mob] leaves [SSticker.realm_name].</span>")
	if(departing_mob.has_embedded_objects())
		var/list/embeds = departing_mob.get_embedded_objects()
		for(var/thing in embeds)
			QDEL_NULL(thing)
	QDEL_NULL(departing_mob)

