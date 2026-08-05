//////Kitchen Spike
#define VIABLE_MOB_CHECK(X) (isliving(X))

/obj/structure/kitchenspike_frame
	name = "meatspike frame"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spikeframe"
	desc = ""
	density = TRUE
	anchored = FALSE
	max_integrity = 200

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A slender curved hook designed for suspending corpses. Found in kitchens, butcheries, and dungeons alike."
	density = TRUE
	anchored = TRUE
	buckle_lying = 0
	can_buckle = 1
	max_integrity = 250

/obj/structure/kitchenspike/crowbar_act(mob/living/user, obj/item/I)
	if(has_buckled_mobs())
		to_chat(user, span_warning("I can't do that while something's on the spike!"))
		return TRUE

	if(I.use_tool(src, user, 20, volume=100))
		to_chat(user, span_notice("I pry the spikes out of the frame."))
		deconstruct(TRUE)
	return TRUE

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/kitchenspike/attack_hand(mob/user)
	if(VIABLE_MOB_CHECK(user.pulling) && user.used_intent.type == INTENT_GRAB && !has_buckled_mobs())
		var/mob/living/L = user.pulling
		if(do_mob(user, src, 120))
			if(has_buckled_mobs()) //to prevent spam/queing up attacks
				return
			if(L.buckled)
				return
			if(user.pulling != L)
				return
			playsound(src.loc, 'sound/blank.ogg', 25, TRUE)
			L.visible_message(span_danger("[user] slams [L] onto the meat spike!"), span_danger("[user] slams you onto the meat spike!"), span_hear("You hear a squishy wet noise."))
			L.forceMove(drop_location())
			L.emote("scream")
			L.add_splatter_floor()
			L.adjustBruteLoss(30)
			L.setDir(2)
			buckle_mob(L, force=1)
			var/matrix/m180 = matrix(L.transform)
			m180.Turn(180)
			animate(L, transform = m180, time = 3)
			L.pixel_y = L.get_standard_pixel_y_offset(180)
	else if (has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			user_unbuckle_mob(L, user)
	else
		..()



/obj/structure/kitchenspike/user_buckle_mob(mob/living/M, mob/living/user) //Don't want them getting put on the rack other than by spiking
	return

/obj/structure/kitchenspike/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message(span_notice("[user] tries to pull [M] free of [src]!"),\
				span_notice("[user] is trying to pull you off [src], opening up fresh wounds!"),\
				span_hear("I hear a squishy wet noise."))
			if(!do_after(user, 300, target = src))
				if(M && M.buckled)
					M.visible_message(span_notice("[user] fails to free [M]!"),\
					span_notice("[user] fails to pull you off of [src]."))
				return

		else
			M.visible_message(span_warning("[M] struggles to break free from [src]!"),\
			span_notice("I struggle to break free from [src], exacerbating my wounds! (Stay still for two minutes.)"),\
			span_hear("I hear a wet squishing noise..."))
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M && M.buckled)
					to_chat(M, span_warning("I fail to free myself!"))
				return
		if(!M.buckled)
			return
		release_mob(M)

/obj/structure/kitchenspike/proc/release_mob(mob/living/M)
	var/matrix/m180 = matrix(M.transform)
	m180.Turn(180)
	animate(M, transform = m180, time = 3)
	M.pixel_y = M.get_standard_pixel_y_offset(180)
	M.adjustBruteLoss(30)
	src.visible_message(span_danger("[M] falls free of [src]!"))
	unbuckle_mob(M,force=1)
	M.emote("scream")
	M.AdjustParalyzed(20)

/obj/structure/kitchenspike/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()

#undef VIABLE_MOB_CHECK
