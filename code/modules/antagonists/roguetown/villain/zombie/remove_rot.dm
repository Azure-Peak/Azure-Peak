/proc/remove_rot(mob/living/carbon/human/target, mob/living/user, method = "unknown", damage = 0, success_message = "The rot is removed.", fail_message = "The rot removal failed.", lethal = TRUE)
	if (!istype(target, /mob/living/carbon/human) || QDELETED(target))
		return FALSE

	//Special check preventing skeletons being cautery burned to regrow flesh
	if(istype(target, /mob/living/carbon/human/species/skeleton) && method == "surgery")
		to_chat(user, span_warning("It's going to take a miracle to put flesh back on these bones."))
		return FALSE

	// Check if the target has rot
	var/has_rot = FALSE
	var/datum/antagonist/zombie/was_zombie = target.mind?.has_antag_datum(/datum/antagonist/zombie)

	if (was_zombie)
		has_rot = TRUE
	else if (istype(target, /mob/living/carbon))
		has_rot = check_bodyparts_for_rot(target)
	else if (target.has_status_effect(/datum/status_effect/zombie_infection))
		has_rot = TRUE

	// Remove rot component
	remove_rot_component(target)

	// Remove Infected var
	target.infected = FALSE
	target.remove_status_effect(/datum/status_effect/zombie_infection)

	// Clean body parts
	clean_body_parts(target)

	// Handle failure case
	if (!has_rot)
		to_chat(user, span_warning(fail_message))
		return FALSE

	if (was_zombie)
		remove_zombie_antag(target, user, method, lethal)

	//Doing it out of this proc for now
	//to_chat(user, span_notice(success_message))

	return TRUE

/proc/check_bodyparts_for_rot(mob/living/carbon/target)
	for (var/obj/item/bodypart/bodypart in target.bodyparts)
		if (bodypart.rotted || bodypart.skeletonized)
			return TRUE
	return FALSE


/proc/remove_zombie_antag(mob/living/carbon/target, mob/living/user, method, lethal = TRUE)
	var/datum/antagonist/zombie/was_zombie = target.mind?.has_antag_datum(/datum/antagonist/zombie)
	if (!was_zombie)
		return

	was_zombie.become_rotman = FALSE
	if(!lethal)
		target.Unconscious(20 SECONDS)
		target.emote("breathgasp")
		target.Jitter(100)
	else if(was_zombie.has_turned)
		target.death(nocutscene = TRUE)
	target.mind.remove_antag_datum(/datum/antagonist/zombie)

	if (!HAS_TRAIT(target, TRAIT_IWASUNZOMBIFIED) && user?.ckey)
		adjust_playerquality(PQ_GAIN_UNZOMBIFY, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASUNZOMBIFIED, "[method]")

///Removes the rot amount from the target
/proc/remove_rot_component(mob/living/carbon/target)
	var/datum/component/rot/rot = target.GetComponent(/datum/component/rot)
	if (rot)
		rot.amount = 0
		rot.soundloop.stop()

///Cure bodyparts
/proc/clean_body_parts(mob/living/carbon/target)
	var/da_skin = getblock(target.dna.uni_identity, DNA_SKIN_TONE_BLOCK) // copied from mirror transform, think this is where we store skin data(???)
	for (var/obj/item/bodypart/bodypart in target.bodyparts)
		bodypart.rotted = FALSE
		bodypart.skeletonized = FALSE
		bodypart.update_limb()
		bodypart.update_disabled()

	if(ishuman(target)) // did you know drunk driving is safer if you do it in a car rather than a bike?
		var/mob/living/carbon/human/H = target			
		H.skin_tone = da_skin 
	target.update_body()
