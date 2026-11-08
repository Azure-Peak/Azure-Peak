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
	if(HAS_TRAIT(dropping, TRAIT_CONJURED_SUMMON))
		to_chat(user, "<span class='warning'>This is not your true body, why are you leaving?</span>")
		return
	if(in_use) // Someone's already going in.
		return
	var/mob/living/carbon/human/departing_mob = dropping
	if(departing_mob != user && departing_mob.client)
		to_chat(user, "<span class='warning'>This one retains their free will. It's their choice if they want to leave the round or not.</span>")
		return
	if(alert(user, "Are you sure you want to [departing_mob == user ? "depart the round for good (you" : "send this person away (they"] will be removed from the current round, and their role's slot will reopen for another to take)?", "Departing", "Confirm", "Cancel") != "Confirm")
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
	departing_mob.process_far_travel(user, src)
	if(departing_mob.stat == DEAD)
		departing_mob.visible_message("<span class='notice'>[user] safely sends [departing_mob] away./span>")
	else
		departing_mob.visible_message("<span class='notice'>[departing_mob == user ? "Out of their own volition, " : "Ushered by [user], "][departing_mob] leaves [SSticker.realm_name].</span>")
	if(departing_mob.has_embedded_objects())
		var/list/embeds = departing_mob.get_embedded_objects()
		for(var/thing in embeds)
			QDEL_NULL(thing)
	QDEL_NULL(departing_mob)

/// Shared far travel cleanup: frees the job slot, clears the manifest, treasury, bounties etc.
/// Used by the far travel tile and the admin send-to-lobby. Does not delete the mob.
/mob/living/carbon/human/proc/process_far_travel(mob/user, atom/location)
	var/dat = "[user ? ADMIN_LOOKUPFLW(user) : "Unknown"] has despawned [src == user ? "themselves" : src], job [job], at [AREACOORD(location || src)]. Contents despawned along:"
	if(!length(contents))
		dat += " none."
	else
		var/list/content_names = list()
		for(var/atom/movable/content as anything in contents)
			content_names += content.name
		dat += " [content_names.Join(", ")]."
	if(mind)
		release_far_travel_job()
		mind.unknow_all_people()
		for(var/datum/mind/MF in get_minds())
			mind.become_unknown_to(MF)
		for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
			if(removing_bounty.target == real_name)
				GLOB.head_bounties -= removing_bounty
	GLOB.dominant_faith_tracker.handle_removal(src)
	if(SSticker.rulermob == src)
		SSticker.rulermob = null
	if(SSticker.regentmob == src)
		SSticker.regentmob = null
	GLOB.chosen_names -= real_name
	LAZYREMOVE(GLOB.actors_list, mobid)
	if(SStreasury)
		dat += process_far_travel_treasury()
	message_admins(dat)
	log_admin(dat)
	if(job in ANNOUNCE_ON_FAR_TRAVEL_ROLES)
		var/datum/job/announce_job = SSjob.GetJob(job)
		var/announce_title = announce_job ? announce_job.get_informed_title(src) : job
		scom_announce("[real_name] the [announce_title] has left the vicinity of [SSticker.realm_name].")

/// Reopens the job and advclass slots, and tells the court the departing agent/spymaster is gone.
/mob/living/carbon/human/proc/release_far_travel_job()
	var/datum/job/mob_job = SSjob.GetJob(mind.assigned_role)
	if(!mob_job)
		return
	mob_job.current_positions = max(0, mob_job.current_positions - 1)
	var/datum/advclass/target_job = get_advclass_datum()
	if(target_job)
		SSrole_class_handler.adjust_class_amount(target_job, -1)
	if(istype(mob_job, /datum/job/roguetown/adventurer/courtagent))
		GLOB.court_agents -= real_name
		notify_far_travel_departure(GLOB.court_spymaster)
	if(istype(mob_job, /datum/job/roguetown/hand))
		GLOB.court_spymaster -= real_name
		notify_far_travel_departure(GLOB.court_agents)

/// Tells everyone in the given name -> mob list that this mob has left.
/mob/living/carbon/human/proc/notify_far_travel_departure(list/recipients)
	for(var/name in recipients)
		var/mob/living/carbon/human/recipient = recipients[name]
		if(recipient)
			to_chat(recipient, span_notice("[real_name] has left the vicinity of [SSticker.realm_name]."))

/// Keep insiders' bank balance forfeits to the Crown's Purse on far-travel (silent OOC).
/// Day 0 is a grace window so roundstart bailouts don't accidentally hand the Crown a
/// windfall from a player who never had time to act in role. Loose mammon is tallied
/// separately for admin review so withdraw-to-pouch patterns leave a paper trail.
/// Removes the mob from the treasury and returns text to append to the admin log (may be empty).
/mob/living/carbon/human/proc/process_far_travel_treasury()
	var/recovered = 0
	var/datum/fund/account = SStreasury.get_account(src)
	var/is_keep_insider = (job in KEEP_INSIDER_JOBS)
	var/post_grace = GLOB.dayspassed >= 1
	if(account && is_keep_insider && post_grace && account.balance > 0)
		recovered = account.balance
		SStreasury.transfer(account, SStreasury.discretionary_fund, recovered, "Crown forfeiture: [real_name] (far-travel)", null, LEDGER_CROWN_REV_OTHER)
		record_round_statistic(STATS_FORFEITURE_AMOUNT, recovered)
		record_round_statistic(STATS_FORFEITURE_COUNT, 1)
	var/loose = get_mammons_in_atom(src) || 0
	SStreasury.remove_person(src)
	if(recovered > 0 || loose > 0 || is_keep_insider)
		return " | Coin at far-travel (day [GLOB.dayspassed]): [recovered]m forfeit from bank, [loose]m loose on person."
	return ""
