/obj/item/net
	name = "net"
	desc = "A weighed net used to entrap foes. Can be thrown to ensnare a target's legs and slow them down. Victims can struggle out of it and it will fall off after a short time."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	force = 10
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "net"
	slipouttime = 2 SECONDS //ideally you're using this to catch a dodger, not in the middle of combat
	gender = NEUTER
	throw_speed = 2
	var/knockdown = 0

/obj/item/net/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/obj/item/net/proc/on_drop()
	remove_effect()

/obj/item/net/proc/remove_effect()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.legcuffed == src)
			M.legcuffed = null
			M.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN, TRUE)
			M.update_inv_legcuffed()
			if(M.has_status_effect(/datum/status_effect/debuff/netted))
				M.remove_status_effect(/datum/status_effect/debuff/netted)
		forceMove(M.loc)

/obj/item/net/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback)
	if(!..())
		return
	playsound(src.loc,'sound/blank.ogg', 75, TRUE)

/obj/item/net/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !iscarbon(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	ensnare(hit_atom)
	// Nets always fall off after 10 seconds resist or not, so that the advantage it brings you is limited
	// Being hit by a net and instalossing isn't fun for anyone because removing can be interrupted
	addtimer(CALLBACK(src, PROC_REF(remove_effect)), 10 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)

/obj/item/net/proc/ensnare(mob/living/carbon/C)
	if(!C.legcuffed && C.get_num_legs(FALSE) >= 2)
		visible_message("<span class='danger'>\The [src] ensnares [C]!</span>")
		C.legcuffed = src
		forceMove(C)
		C.update_inv_legcuffed()
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		to_chat(C, "<span class='danger'>\The [src] entraps you!</span>")
		C.Knockdown(knockdown)
		C.apply_status_effect(/datum/status_effect/debuff/netted)
		playsound(src, 'sound/blank.ogg', 50, TRUE)

// Failsafe in case the item somehow ends up being destroyed
/obj/item/net/Destroy()
	remove_effect()
	return ..()
