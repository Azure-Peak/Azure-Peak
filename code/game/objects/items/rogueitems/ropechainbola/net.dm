/obj/item/net
	name = "net"
	desc = "A weighed net used to entrap foes. Can be thrown to ensnare a target's legs and slow them down. Victims can struggle out of it and it will fall off after a short time."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	force = 10
	throwforce = 5
	throw_range = 9
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "net"
	gender = NEUTER
	throw_speed = 0.8

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
	if(throwingdatum)
		ensnare(hit_atom, throwingdatum.dist_travelled)

/obj/item/net/proc/ensnare(mob/living/carbon/C, dist_travelled)
	if(!C.legcuffed && C.get_num_legs(FALSE) >= 2)
		switch(dist_travelled)
			if(0 to 2)	//Point-blank. Easy to land, so it does nothing.
				C.Immobilize(0.75 SECONDS)
			if(3 to 5)	//Some actual aiming happened.
				C.Immobilize(2.5 SECONDS)
				C.OffBalance(3 SECONDS)
				C.apply_status_effect(/datum/status_effect/debuff/vulnerable, 3 SECONDS)
				C.apply_status_effect(/datum/status_effect/debuff/netted, 5 SECONDS)
				visible_message("<span class='danger'>\The [src] ensnares [C]!</span>")
				to_chat(C, "<span class='danger'>\The [src] entraps you!</span>")
				playsound(C, 'sound/effects/net_impact.ogg', 100, TRUE)
				qdel(src)
			if(6 to 99)	//Aced it across the screen.
				C.Knockdown(3 SECONDS)
				C.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
				C.apply_status_effect(/datum/status_effect/debuff/netted, 9 SECONDS)
				visible_message("<span class='danger'>\The [src] <b>EXPERTLY</b> ensnares [C]!</span>")
				to_chat(C, "<span class='danger'>\The [src] <b>EXPERTLY</b> entraps you!</span>")
				playsound(C, 'sound/effects/net_impact_heavy.ogg', 100, TRUE, 5)
				qdel(src)
			else //Uh, negative / null dist travelled?
				return


// Failsafe in case the item somehow ends up being destroyed
/obj/item/net/Destroy()
	remove_effect()
	return ..()
