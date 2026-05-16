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

/obj/item/broom/attack_obj(obj/O, mob/living/user)
	if(istype(O, /obj/structure/spider/stickyweb)) // perish, spiders
		O.take_damage(50, BRUTE, "blunt", FALSE)

	if(do_after(user, 15, target = O))
		user.visible_message("<span class='notice'>[user] dutifully sweeps \the [O.name].</span>", "<span class='notice'>I dutifully sweep \the [O.name].</span>")
		playsound(user, "clothwipe", 100, TRUE)		
		broom_fu(O, user)

// Even if there's nothing mechanically dirty about the floor, you can still sweep it! Anything to look busy. // added a few more to it cause why not
/obj/item/broom/attack_turf(turf/T, mob/living/user)
	if(istype(T, /turf/open/lava)) // lol
		return
	if(istype(T, /turf/open/water))
		return
	if(do_after(user, 20, target = T))
		user.visible_message("<span class='notice'>[user] dutifully sweeps \the [T.name].</span>", "<span class='notice'>I dutifully sweep \the [T.name].</span>")
		playsound(user, 'sound/items/broom_sweep.ogg', 150, TRUE)
		broom_fu(T, user)
		gather_clutter(T, user)


/obj/item/broom/attack_obj(obj/O, mob/living/user)
	if(istype(O, /obj/structure/spider/stickyweb)) // perish, spiders
		O.take_damage(200, BRUTE, "blunt", FALSE)
		playsound(loc,"smashlimb", 50, FALSE)
		return

	if(do_after(user, 15, target = O))
		user.visible_message("<span class='notice'>[user] dutifully sweeps \the [O.name].</span>", "<span class='notice'>I dutifully sweep \the [O.name].</span>")
		playsound(user, "clothwipe", 100, TRUE)		
		broom_fu(O, user)

// Even if there's nothing mechanically dirty about the floor, you can still sweep it! Anything to look busy. // added a few more to it cause why not
/obj/item/broom/attack_turf(turf/T, mob/living/user)
	if(istype(T, /turf/open/lava)) // lol
		return
	if(istype(T, /turf/open/water))
		return
	if(do_after(user, 20, target = T))
		user.visible_message("<span class='notice'>[user] dutifully sweeps \the [T.name].</span>", "<span class='notice'>I dutifully sweep \the [T.name].</span>")
		playsound(user, 'sound/items/broom_sweep.ogg', 150, TRUE)
		broom_fu(T, user)
		gather_clutter(T, user)

// i should make this delete squires who try to steal your butter too it'll probably be funny
/obj/item/broom/proc/broom_fu(atom/A, mob/living/user)
	if(!A)
		return

	var/turf/T = get_turf(A)
	if(!T)
		return

	for(var/obj/O in T.contents)
		if(O.loc != T) // think this might stop it from deleting clutter from bags? oughh...
			continue

		if(istype(O, /obj/effect/decal/cleanable/dirt) || \
		   istype(O, /obj/item/paper/crumpled) || \
		   istype(O, /obj/item/ash) || \
		   istype(O, /obj/item/natural/glass_shard) || \
		   istype(O, /obj/effect/decal/cleanable/debris) || \
		   istype(O, /obj/effect/decal/remains/human))
			qdel(O)

/obj/item/broom/proc/gather_clutter(turf/T, mob/living/user)
	if(!T)
		return

	var/count = 0
	var/flufftext = FALSE

	for(var/atom/movable/A in range(1, T))
		if(count >= 10)
			break
		if(A.loc == T) 
			continue
		if(istype(A, /obj/item/natural/stone) || istype(A, /obj/item/scrap) || istype(A, /obj/item/paper/crumpled) || istype(A, /obj/item/grown/log/tree/stick) || istype(A, /obj/item/ash) || istype(A, /obj/item/natural/glass_shard) || istype(A, /obj/item/natural/cloth) || istype(A, /obj/item/natural/fibers) || istype(A, /obj/item/natural/silk) || istype(A, /obj/item/ammo_casing) || istype(A, /obj/item/rogueweapon/huntingknife/throwingknife))
			if(A.loc != T && !QDELETED(A))
				A.forceMove(T)
				count++
				flufftext = TRUE

	if(flufftext)
		user.visible_message("<span class='notice'>[user] gathers the clutter into \the [T.name].</span>", "<span class='notice'>I gather the clutter into \the [T.name].</span>")
