//A hay bale that stops fall damage and can be hidden in, yes, asscreed style.

/obj/structure/haybale
	name = "hay bale"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "haybale"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	climbable = TRUE
	climb_offset = 10
	can_buckle = TRUE
	buckle_lying = 90
	buckleverb = "lay"
	sleepy = 2
	resistance_flags = FLAMMABLE
	max_integrity = 70
	static_debris = list(/obj/item/natural/chaff/wheat = 3)
	destroy_sound = "plantcross"
	attacked_sound = "plantcross"
	blade_dulling = DULLING_BASHCHOP
	hidingspot = TRUE
	var/mob/living/hiddenguy = null

/obj/structure/haybale/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Click-dragging yourself onto a hay bale, while on the same tile, will 'buckle' you in; this represents your character laying down. Laying down gradually restores energy, and allows your character to begin sleeping.")
	. += span_info("Some structures can be used as hiding places. Toggle the 'SNEAK' button on your HUD, then click the structure to hide in it. You can stop hiding by clicking the structure again, or by moving out of it.")

/obj/structure/haybale/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 5)

/obj/structure/haybale/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

/obj/structure/haybale/proc/rustle()
	playsound(src.loc, "plantcross", 100, FALSE, -1)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/haybale/onkick(mob/user)
	to_chat(user, span_warning("I kick [src]!"))
	rustle()
	if(occupied && hiddenguy)
		to_chat(hiddenguy, span_danger("Someone kicks the hay bale you are hiding in!"))
		unhide(hiddenguy)

/obj/structure/haybale/attack_hand(mob/living/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	rustle()
	if(user.m_intent == MOVE_INTENT_SNEAK)
		hideinside(user)
		return
	return ..()

/obj/structure/haybale/proc/can_hide(mob/living/user)
	var/turf/T = get_turf(src)
	for(var/obj/structure/bars/B in T)
		to_chat(user, span_warning("I can't fit down there with the bars in the way!"))
		return FALSE
	for(var/obj/structure/mineral_door/wood/deadbolt/shutter/b in T)
		if(!b.door_opened)
			to_chat(user, span_warning("I can't fit down there with the shutter in the way!"))
			return FALSE
	return TRUE

/obj/structure/haybale/proc/hideinside(mob/living/user)
	if(user.in_combat_until > world.time)
		return
	var/sneak_level = user.get_skill_level(/datum/skill/misc/sneaking) || 0
	var/sneaktime = max(10, 45 - (sneak_level * 5))
	if(user.loc == src)
		unhide(user)
		return
	if(occupied)
		to_chat(user, span_warning("Someone is already hiding under [src]!"))
		return
	if(!can_hide(user))
		return
	if(!do_after(user, sneaktime, src))
		return
	hidebale(user)

/obj/structure/haybale/proc/hidebale(mob/living/user)
	user.forceMove(src)
	occupied = TRUE
	hiddenguy = user
	to_chat(user, span_warning("I hide under [src]!"))

/obj/structure/haybale/proc/unhide(mob/living/user)
	var/turf/T = get_turf(src)
	if(!T) return
	user.forceMove(T)
	occupied = FALSE
	hiddenguy = null
	to_chat(user, span_warning("I come out from under [src]!"))

/obj/structure/haybale/relaymove(mob/user)
	if(user.loc == src)
		unhide(user)

/obj/structure/haybale/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return 1
	return !density

/obj/structure/haybale/CanAStarPass(ID, dir, caller)
	. = ..()
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		. ||= (mover.pass_flags & PASSTABLE)

/obj/structure/haybale/attackby(obj/item/I, mob/user, params)
	if(user.used_intent?.blade_class == BCLASS_CUT && !(flags_1 & NODECONSTRUCT_1))
		to_chat(user, span_notice("I start disassembling [src]..."))
		if(do_after(user, 20, target = src))
			deconstruct(TRUE)
		return

	if(!user.cmode)
		if(!(I.item_flags & ABSTRACT))
			if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
				var/list/click_params = params2list(params)
				if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
					return
				I.pixel_x = initial(I.pixel_x) += CLAMP(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
				I.pixel_y = initial(I.pixel_y) += CLAMP(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
				return 1

	return ..()

/obj/structure/haybale/ongive(mob/user, params)
	var/obj/item/I = user.get_active_held_item()
	if(I)
		if(!(I.item_flags & ABSTRACT))
			if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
				var/list/click_params = params2list(params)
				//Center the icon where the user clicked.
				if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
					return
				//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
				I.pixel_x = initial(I.pixel_x) += CLAMP(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
				I.pixel_y = initial(I.pixel_y) += CLAMP(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
				return 1

/obj/structure/haybale/intercept_zImpact(atom/movable/AM, levels = 1)
	. = ..()
	if(!isliving(AM))
		return
	. |= FALL_INTERCEPTED | FALL_NO_MESSAGE
	rustle()
	if(!occupied && can_hide(AM))
		hidebale(AM)

/obj/structure/haybale/burn()
	static_debris = list(/obj/item/ash = 1)
	return ..()

/obj/structure/haybale/deconstruct(disassembled = TRUE)
	if(hiddenguy)
		unhide(hiddenguy)
	if(islist(static_debris))
		for(var/I in static_debris)
			for(var/i in 1 to static_debris[I])
				new I (get_turf(src))
	qdel(src)
