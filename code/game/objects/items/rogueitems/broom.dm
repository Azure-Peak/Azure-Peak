/obj/item/broom
	name = "broom"
	desc = "A robust-looking broom, made from a bundle of twigs. Sweep away debris, glass, blood, dirt, and time without a care in the world."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "broom"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	force = 10
	force_wielded = 14
	throwforce = 1
	firefuel = 10 MINUTES
	wlength = WLENGTH_LONG
	sharpness = IS_BLUNT
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	can_parry = TRUE
	wdefense = 4
	walking_stick = TRUE
	associated_skill = /datum/skill/craft/cooking
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ash

/obj/item/broom/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/broom/proc/sweep_message(atom/A, mob/living/user)
	user.visible_message(span_notice("[user] dutifully sweeps \the [A]."), span_notice("I dutifully sweep \the [A]."))

/obj/item/broom/proc/is_sweep_trash(obj/O)
	return istype(O, /obj/effect/decal/cleanable/dirt) || \
		istype(O, /obj/item/paper/crumpled) || \
		istype(O, /obj/item/ash) || \
		istype(O, /obj/item/natural/glass_shard) || \
		istype(O, /obj/effect/decal/cleanable/debris) || \
		istype(O, /obj/effect/decal/remains/human)

/obj/item/broom/proc/is_clutter(atom/movable/A)
	return istype(A, /obj/item/natural/stone) || \
		istype(A, /obj/item/scrap) || \
		istype(A, /obj/item/paper/crumpled) || \
		istype(A, /obj/item/grown/log/tree/stick) || \
		istype(A, /obj/item/ash) || \
		istype(A, /obj/item/natural/glass_shard) || \
		istype(A, /obj/item/natural/cloth) || \
		istype(A, /obj/item/natural/fibers) || \
		istype(A, /obj/item/natural/silk) || \
		istype(A, /obj/item/natural/bone) || \
		istype(A, /obj/item/natural/bundle) || \
		istype(A, /obj/item/ammo_casing) || \
		istype(A, /obj/item/rogueweapon/huntingknife/throwingknife)

/obj/item/broom/attack_obj(obj/O, mob/living/user)
	if(!user.used_intent || !istype(user.used_intent, /datum/intent/use))
		return ..()
	if(istype(O, /obj/structure/spider/stickyweb))
		O.take_damage(200, BRUTE, "blunt", FALSE)
		playsound(loc, "smashlimb", 50, FALSE)
		return
	if(!do_after(user, 15, target = O))
		return
	sweep_message(O, user)
	playsound(user, "clothwipe", 100, TRUE)
	broom_fu(O)

/obj/item/broom/attack_turf(turf/T, mob/living/user)
	if(!user.used_intent || !istype(user.used_intent, /datum/intent/use))
		return ..()
	if(istype(T, /turf/open/lava) || istype(T, /turf/open/water))
		return
	if(!do_after(user, 20, target = T))
		return
	sweep_message(T, user)
	playsound(user, 'sound/items/broom_sweep.ogg', 150, TRUE)
	broom_fu(T)
	gather_clutter(T, user)
	for(var/obj/O in T)
		broom_fu(O)

/obj/item/broom/proc/broom_fu(atom/A)
	var/turf/T = get_turf(A)
	if(!T)
		return
	for(var/obj/O in T.contents)
		if(O.loc != T)
			continue
		if(is_sweep_trash(O))
			qdel(O)

/obj/item/broom/proc/gather_clutter(turf/T, mob/living/user)
	if(!T)
		return
	var/moved = 0
	for(var/atom/movable/A in range(1, T))
		if(moved >= 10)
			break
		if(A.loc == T)
			continue
		if(QDELETED(A))
			continue
		if(!is_clutter(A))
			continue
		A.forceMove(T)
		moved++
	if(moved)
		user.visible_message(span_notice("[user] gathers the clutter into \the [T]."), span_notice("I gather the clutter into \the [T]."))
