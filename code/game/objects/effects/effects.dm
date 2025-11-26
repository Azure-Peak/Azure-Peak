
//objects in /obj/effect should never be things that are attackable, use obj/structure instead.
//Effects are mostly temporary visual effects like sparks, smoke, as well as decals, etc...
/obj/effect
	icon = 'icons/effects/effects.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	move_resist = INFINITY
	obj_flags = 0
	anchored = TRUE
	density = FALSE

/obj/effect/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	return

/obj/effect/fire_act(added, maxstacks)
	return

/obj/effect/acid_act()
	return

/obj/effect/ex_act(severity, target)
	if(target == src)
		qdel(src)
	else
		switch(severity)
			if(1)
				qdel(src)
			if(2)
				if(prob(60))
					qdel(src)
			if(3)
				if(prob(25))
					qdel(src)


/obj/effect/ConveyorMove()
	return

/obj/effect/abstract/ex_act(severity, target)
	return


/obj/effect/solid_invisible_barrier
	density = TRUE
	opacity = 0
	invisibility = INVISIBILITY_MAXIMUM
	icon_state = "nothing"

/obj/effect/soul
	name = "\improper soul"
	desc = null
	anchored = TRUE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	alpha = 0

/obj/effect/soul/proc/soul_mark()
	icon_state = "soul_marked"
	var/turf/T = get_turf(src)
	animate(src, alpha = 255, time = 3 SECONDS, easing = EASE_IN)
	sleep(3 SECONDS)
	alpha = 255
	for(var/obj/item/I in T.contents)
		if(istype(I, /obj/item/skull))
			src.visible_message(span_notice("[src] move into [I]."))
			new /obj/item/necro_relics/zskull(T)
			qdel(I)
			qdel(src)
		return
	return