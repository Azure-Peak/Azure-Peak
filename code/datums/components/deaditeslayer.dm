/datum/component/deaditeslayer // this is for stakes, because sharpened stakes and silver-tipped sharpened stakes are two different type paths. sigh
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/staketime

/// time is the time it takes to stake a heart. Silver stakes are 10 seconds, sharpened stakes are 15, base stakes are 20. Generally, the more expensive/anti-undead something is the faster it should be, but don't make it so fast people can't interupt their friend being murdered
/datum/component/deaditeslayer/Initialize(time = 15 SECONDS)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	staketime = time
	RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, PROC_REF(handle_stake))

/// If the target is a deathless character who's incapacitated (in crit), you can stake their heart to properly kill them. They can still be revived, and lorewise they'll pop back up _eventually_, but this is how you properly kill them.
/datum/component/deaditeslayer/proc/handle_stake(datum/source, atom/A, mob/M, params)
	if(!isliving(M) || !ishuman(A))
		return
	var/mob/living/carbon/human/rev = A
	var/mob/living/user = M
	if(!HAS_TRAIT(rev, TRAIT_DEATHLESS))
		return
	if(!rev.stat) // technically this means you can stake sleeping revs. the alternative is making them fully unkillable while sleeping, which they can do in crit - so no
		return
	playsound(user, 'sound/surgery/cautery1.ogg', 100)
	user.visible_message(span_artery("[user] lines up \the [parent] over [rev]'s heart...!"))
	user.apply_status_effect(/datum/status_effect/swingdelay/disrupt, staketime + 2, TRUE)
	if(do_after(user, staketime, TRUE, rev, same_direction = TRUE))
		var/datum/status_effect/swingdelay/disrupt/SW = user.has_status_effect(/datum/status_effect/swingdelay/disrupt)
		if(SW)
			if(SW.is_disrupted()) // you got whacked, why are you trying to hardkill someone midfight with their allies!
				return
		user.visible_message(span_warning("[user] drives [parent] through [rev]'s heart!"))
		rev.death(FALSE)
		playsound(user, 'sound/surgery/cautery2.ogg', 100)
		return COMPONENT_NO_ATTACK
	else
		user.remove_status_effect(/datum/status_effect/swingdelay/disrupt)
