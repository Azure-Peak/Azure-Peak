//Non-map stactic version, can be destroyed. (Not craftable, for now.)
/obj/structure/noose
	name = "noose"
	desc = "Abandon all hope."
	icon = 'modular/icons/obj/gallows.dmi'
	pixel_y = 10
	icon_state = "noose"
	can_buckle = 1
	layer = 4.26
	max_integrity = 10
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	max_buckled_mobs = 1
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	static_debris = list(/obj/item/rope = 1)
	breakoutextra = 10 MINUTES
	buckleverb = "tie"

//Map stactic version.
/obj/structure/noose/gallows
	name = "gallows"
	desc = "Stranded and hanging, limp and dead."
	icon_state = "gallows"
	pixel_y = 0
	max_integrity = 9999

/obj/structure/noose/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.visible_message("<span class='danger'>[buckled_mob] falls over and hits the ground!</span>")
			to_chat(buckled_mob, "<span class='userdanger'>You fall over and hit the ground!</span>")
			buckled_mob.adjustBruteLoss(10)
			buckled_mob.Knockdown(60)
	return ..()

/obj/structure/noose/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(!in_range(user, src) || user.stat != CONSCIOUS || !iscarbon(M))
		return FALSE

	if(!M.get_bodypart("head"))
		to_chat(user, "<span class='warning'>[M] has no head!</span>")
		return FALSE

	M.visible_message("<span class='danger'>[user] attempts to tie \the [src] over [M]'s neck!</span>")
	if(do_after(user, user == M ? 0:5 SECONDS, M))
		if(buckle_mob(M))
			user.visible_message("<span class='warning'>[user] ties \the [src] over [M]'s neck!</span>")
			if(user == M)
				to_chat(M, "<span class='userdanger'>You tie \the [src] over your neck!</span>")
			else
				to_chat(M, "<span class='userdanger'>[user] ties \the [src] over your neck!</span>")
			playsound(user, 'sound/foley/noosed.ogg', 50, 1, -1)
			return TRUE
	user.visible_message("<span class='warning'>[user] fails to tie \the [src] over [M]'s neck!</span>")
	to_chat(user, "<span class='warning'>You fail to tie \the [src] over [M]'s neck!</span>")
	return FALSE

/obj/structure/noose/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		START_PROCESSING(SSobj, src)
		M.set_mob_offsets("bed_buckle", _x = 0, _y = 10)

/obj/structure/noose/post_unbuckle_mob(mob/living/M)
	STOP_PROCESSING(SSobj, src)
	M.reset_offsets("bed_buckle")

/obj/structure/noose/process()
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)
		return
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(buckled_mob.get_bodypart("head"))
			if(buckled_mob.stat != DEAD)
				if(locate(/obj/structure/chair) in get_turf(src)) // So you can kick down the chair and make them hang, and stuff.
					return
				if(!HAS_TRAIT(buckled_mob, TRAIT_NOBREATH))
					buckled_mob.adjustOxyLoss(10)
					if(prob(20))
						buckled_mob.emote("gasp")
				playsound(buckled_mob, 'sound/foley/noose_idle.ogg', 30, 1, -3)
			else
				if(prob(1))
					var/obj/item/bodypart/head/head = buckled_mob.get_bodypart("head")
					if(head.brute_dam >= 50)
						if(head.dismemberable)
							head.dismember()
		else
			buckled_mob.visible_message("<span class='danger'>[buckled_mob] drops from the noose!</span>")
			buckled_mob.Knockdown(60)
			buckled_mob.pixel_y = initial(buckled_mob.pixel_y)
			buckled_mob.pixel_x = initial(buckled_mob.pixel_x)
			unbuckle_all_mobs(force=1)
