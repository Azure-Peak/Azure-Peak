/datum/intent/kick
	name = "kick"
	candodge = TRUE
	canparry = TRUE
	chargetime = 0
	chargedrain = 0
	noaa = FALSE
	swingdelay = 5
	misscost = 20
	unarmed = TRUE
	animname = "kick"
	pointer = 'icons/effects/mousemice/human_kick.dmi'

/datum/intent/kick/on_mmb(atom/target, mob/living/user, params)
	user.try_kick(target)

/atom/proc/onkick(mob/user)
	return

/obj/item/onkick(mob/user)
	if(!ontable())
		if(w_class < WEIGHT_CLASS_HUGE)
			throw_at(get_ranged_target_turf(src, get_dir(user,src), 2), 2, 2, user, FALSE)

/// Performs a kick. Used by the kick MMB intent. Returns TRUE if a kick was performed.
/mob/living/proc/try_kick(atom/A)
	if(!can_kick(A))
		return FALSE
	changeNext_move(mmb_intent.clickcd)
	face_atom(A)
	SEND_SIGNAL(src, COMSIG_MOB_ON_KICK)
	playsound(src, pick(PUNCHWOOSH), 100, FALSE, -1)
	// play the attack animation even when kicking non-mobs
	if(mmb_intent) // why this would be null and not INTENT_KICK i have no clue, but the check already existed
		do_attack_animation_simple(A, visual_effect_icon = mmb_intent.animname)

	var/atom/target = A
	if(isturf(A))
		for(var/mob/living/M in A)
			target = M
			break
	// but the rest of the logic is pretty much mob-only
	if(ismob(target) && mmb_intent)
		var/mob/living/M = target
		sleep(mmb_intent.swingdelay)
		if(QDELETED(src) || QDELETED(M))
			return FALSE
		if(!M.Adjacent(src))
			return FALSE
		if(incapacitated())
			return FALSE
		if(M.checkmiss(src))
			return FALSE
		SEND_SIGNAL(M, COMSIG_MOB_KICKED)
		if(M.checkdefense(mmb_intent, src))
			return FALSE
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.dna.species.kicked(src, H)
		else
			M.onkick(src)
	else
		target.onkick(src)
	OffBalance(3 SECONDS)
	return TRUE

/mob/living/proc/can_kick(atom/A, do_message = TRUE)
	if(get_num_legs() < 2)
		return FALSE
	if(!A.Adjacent(src))
		return FALSE
	if(A == src)
		return FALSE
	if(IsOffBalanced())
		if(do_message)
			to_chat(src, span_warning("I haven't regained my balance yet."))
		return FALSE
	if(QDELETED(src) || QDELETED(A))
		return FALSE
	return TRUE
