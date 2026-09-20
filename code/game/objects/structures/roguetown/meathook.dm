////// Roguetown version of the kitchen spike
#define VIABLE_MOB_CHECK(X) (isliving(X))
/// Time to unhook yourself from the meaty.
#define UNHOOK_SELF_TIME 20 SECONDS
/// Time to unhook ANOTHER from the meaty.
#define UNHOOK_OTHER_TIME 10 SECONDS
/// Time to BUCKLE something to the meaty. Should be reduced if they're dead.
#define BUCKLE_SOMETHING_TIME 8 SECONDS

/obj/structure/meathook
	name = "meathook"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "meathook"
	desc = "A hook used to secure livestock for butchering."
	density = TRUE
	anchored = TRUE
	max_integrity = 250
	buckle_lying = 0
	can_buckle = 1
	buckle_prevents_pull = TRUE
	// we're going to prevent mass spam even though you could prolly do the same shit w/ a sack.
	var/last_cleared
	var/buckle_time = BUCKLE_SOMETHING_TIME


/obj/structure/meathook/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("The MEATHOOK is similar to the KITCHEN SPIKE from other places.")
	. += span_info("GRAB a mob and then click onto the meathook to place it upon said hook.")
	. += span_redinfo("Living mobs can be hooked. They will take longer to be put on.")
	. += span_info("CLICK on the hook and WAIT to remove a mob from the hook.")
	. += span_info("HOOKED ANIMALS will drop extra meat and sometimes other items. Also increases speed by 25%.")
	. += span_info("MIDDLE-MOUSE BUTTON on the meathook will \"CLEAR\" it by moving most of the items onto your tile.")

/obj/structure/meathook/attack_hand(mob/user)
	if(VIABLE_MOB_CHECK(user.pulling) && !has_buckled_mobs())
		var/mob/living/L = user.pulling
		L.visible_message(span_danger("[user] starts hanging [L] on [src]!"), span_danger("[user] starts hanging you on [src]]!"), span_hear("I hear the sound of clanging chains..."))
		// speed boost if youre hooking a dead mob so its faster w/o stupid combat weirdness
		if(L.stat == DEAD)
			buckle_time = buckle_time/4
		else // dont remove this or else it gets fucked
			buckle_time = BUCKLE_SOMETHING_TIME
		if(do_mob(user, src, buckle_time, can_move = FALSE))
			if(has_buckled_mobs())
				return
			if(L.buckled)
				return
			if(user.pulling != L)
				return
			if(L.butcher_results)
				for(var/item in L.butcher_results)
					if(ispath(item, /obj/item/reagent_containers/food/snacks))
						L.butcher_results[item] += 1
			if(L.guaranteed_butcher_results)
				for(var/item in L.guaranteed_butcher_results)
					if(ispath(item, /obj/item/reagent_containers/food/snacks))
						L.guaranteed_butcher_results[item] += 1
			playsound(src.loc, 'sound/foley/butcher.ogg', 25, TRUE)
			L.visible_message(span_danger("[user] hangs [L] on [src]!"), span_danger("[user] hangs you on [src]]!"))
			L.forceMove(drop_location())
			L.emote("scream")
			L.add_splatter_floor()
			L.adjustBruteLoss(30)
			L.setDir(2)
			buckle_mob(L, force=1)
			var/matrix/rot = matrix(L.transform)
			if(ispath(L, /mob/living/simple_animal))
				rot.Turn(90)
				animate(L, transform = rot, time = 3)
			else
				rot.Turn(180)
				animate(L, transform = rot, time = 3)
			L.pixel_y = 0
			L.pixel_x = 0
	else if (has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			user_unbuckle_mob(L, user)
	else
		..()

/obj/structure/meathook/user_buckle_mob(mob/living/M, mob/user, check_loc)
	return

/obj/structure/meathook/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if (M != user)
			M.visible_message(span_notice("[user] is trying to pull [M] free of [src]!"),\
				span_notice("[user] is trying to pull you off [src]! It hurts!"),\
				span_hear("I hear the sound of tearing flesh and pained whimpering..."))
			if(!do_after(user, UNHOOK_OTHER_TIME, target = src))
				if(M && M.buckled)
					M.visible_message(span_notice("[user] fails to free [M]!"),\
					span_notice("[user] fails to pull you off of [src]!"))
				return
		else
			M.visible_message(span_warning("[M] struggles to break free from [src]!"),\
				span_notice("I struggle to break free from [src], tearing my legs! (Stay still for two minutes.)"),\
				span_hear("I hear the sound of tearing flesh and pained whimpering..."))
			M.adjustBruteLoss(30)
			if(!do_after(M, UNHOOK_SELF_TIME, target = src))
				if(M && M.buckled)
					to_chat(M, span_warning("I fail to free myself!"))
				return
			if(!M.buckled)
				return
		release_mob(M)

/obj/structure/meathook/proc/release_mob(mob/living/M)
	if(M.butcher_results)
		for(var/item in M.butcher_results)
			if(ispath(item, /obj/item/reagent_containers/food/snacks))
				M.butcher_results[item] -= 1
	if(M.guaranteed_butcher_results)
		for(var/item in M.guaranteed_butcher_results)
			if(ispath(item, /obj/item/reagent_containers/food/snacks))
				M.guaranteed_butcher_results[item] -= 1
	var/matrix/rot = matrix(M.transform)
	if(ispath(M, /mob/living/simple_animal))
		rot.Turn(270)
		animate(M, transform = rot, time = 3)
	else
		rot.Turn(180)
		animate(M, transform = rot, time = 3)
	M.pixel_y = 0
	M.pixel_x = 0
	M.adjustBruteLoss(30)
	src.visible_message(span_danger("[M] falls free of [src]!"))
	unbuckle_mob(M,force=1)
	M.emote("scream")
	M.AdjustParalyzed(20)

/obj/structure/meathook/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()

/obj/structure/meathook/deconstruct()
	new /obj/item/grown/log/tree/small(loc, 1)
	new /obj/item/rope(loc, 1)
	qdel(src)

/// This override lets you "clear" the meathook. It'll move a max of 50 items.
/obj/structure/meathook/MiddleClick(mob/user, params)
	. = ..()
	if(user.mmb_intent)
		return
	// just so that you cant forcemove 50 items easily. this is maybe a shitty idea so lets add a defensive mechanism or two
	if(world.time >= last_cleared + 5 SECONDS)
		user.visible_message(span_notice("[user] begins to clear [src] of debris..."))
		if(do_after(user, 8 SECONDS, TRUE, src, same_direction = TRUE))
			var/items_moved = 0
			for(var/obj/item/I in get_turf(src))
				// defensive mechanism #2
				if(items_moved >= 50)
					break // STOP SEARCHING
				I.forceMove(get_turf(user))
				items_moved++
			last_cleared = world.time
	else
		to_chat(user, span_notice("The hook has been cleared recently. Wait a few seconds."))


#undef VIABLE_MOB_CHECK
#undef UNHOOK_SELF_TIME
#undef UNHOOK_OTHER_TIME
#undef BUCKLE_SOMETHING_TIME
