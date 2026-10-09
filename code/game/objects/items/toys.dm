/* Toys!
 * Contains
 *		Balloons
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		Mech prizes
 *		AI core prizes
 *		Toy codex gigas
 *		Skeleton toys
 *		Cards
 *		Toy nuke
 *		Fake meteor
 *		Foam armblade
 *		Toy big red button
 *		Beach ball
 *		Toy xeno
 *		Kitty toys!
 *		Snowballs
 *		Clockwork Watches
 *		Toy Daggers
 */


/obj/item/toy
	throwforce = 0
	throw_speed = 1
	throw_range = 7
	force = 0

/*
 * Snap pops
 */

/obj/item/toy/snappop
	name = "powder pack"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = WEIGHT_CLASS_TINY
	var/ash_type = /obj/item/ash

/obj/item/toy/snappop/proc/pop_burst(n=3, c=1)
	var/datum/effect_system/spark_spread/s = new()
	s.set_up(n, c, src)
	s.start()
	new ash_type(loc)
	visible_message("<span class='warning'>[src] explodes!</span>",
		"<span class='hear'>I hear a explosion!</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	qdel(src)

/obj/item/toy/snappop/fire_act(added, maxstacks)
	pop_burst()

/obj/item/toy/snappop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		pop_burst()

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if(ishuman(H)) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(M.m_intent == MOVE_INTENT_RUN)
			to_chat(M, "<span class='danger'>I step on the snap pop!</span>")
			pop_burst(2, 0)

/obj/item/toy/snappop/phoenix
	name = "magic powder pack"
	desc = ""
	ash_type = /obj/item/ash/snappop_phoenix

/obj/item/ash/snappop_phoenix
	var/respawn_time = 300

/obj/item/ash/snappop_phoenix/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(respawn)), respawn_time)

/obj/item/ash/snappop_phoenix/proc/respawn()
	new /obj/item/toy/snappop/phoenix(get_turf(src))
	qdel(src)
