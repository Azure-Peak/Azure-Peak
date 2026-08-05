#define BASE_SHUCK_TIME 4 SECONDS

/obj/item/natural/chaff
	icon = 'icons/roguetown/items/produce.dmi'
	var/foodextracted = null
	name = "chaff"
	icon_state = "chaff1"
	desc = "A farmer's chaff." //english is not my native language, upon searching "chaff" i didn't even get what this is.
	var/canthresh = TRUE

/obj/item/natural/chaff/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right click chaff with an empty hand to shuck chaff into grains by hand.")
	. += span_info("Use a thresher on the chaff's tile to thresh all the grains on that tile at once.")
	. += span_info("Use a club on chaff to thresh several grains, easier for stronger individuals and skilled farmers.")
	. += span_info("Use a pitchfork to move a lot of chaff around at once.")

/obj/item/natural/chaff/attack_right(mob/user)
	if(!isliving(user))
		return ..()
	var/mob/living/L = user
	to_chat(L, span_notice("You begin shucking [src]..."))
	INVOKE_ASYNC(src, PROC_REF(shuck_loop), L)
	return TRUE

/obj/item/natural/chaff/proc/shuck_loop(mob/living/user)
	if(!user || user.stat || !src || QDELETED(src))
		return

	var/calculated_time = get_farming_do_time(user, BASE_SHUCK_TIME)

	if(!do_after(user, calculated_time, target = src))
		return
	var/turf/drop_location = get_turf(src)
	if(drop_location)
		new foodextracted(drop_location)
	if(src in user.contents)
		user.transferItemToLoc(src, drop_location)
	var/obj/item/natural/chaff/next_target = find_adjacent_chaff(user)
	if(next_target)
		to_chat(user, span_notice("You move on to shucking the next piece of [next_target.name]..."))
		INVOKE_ASYNC(next_target, PROC_REF(shuck_loop), user)
	qdel(src)

/obj/item/natural/chaff/proc/find_adjacent_chaff(mob/living/user)
	if(!user || QDELETED(user))
		return null

	for(var/obj/item/natural/chaff/W in range(1, user))
		if(!W || QDELETED(W) || W.gc_destroyed || W == src)
			continue
		return W
	return null

/obj/item/natural/chaff/proc/thresh()
	if(foodextracted && canthresh)
		new foodextracted(loc)
		new /obj/item/natural/fibers(loc)
		qdel(src)

/obj/item/natural/chaff/attackby(obj/item/I, mob/living/user, params)

	if(istype(I, /obj/item/rogueweapon/pitchfork))
		if(user.used_intent.type == DUMP_INTENT)
			var/obj/item/rogueweapon/pitchfork/W = I
			if(I.wielded)
				if(isturf(loc))
					var/stuff = 0
					for(var/obj/item/natural/chaff/R in loc)
						if(W.forked.len <= 19)
							R.forceMove(W)
							W.forked += R
							stuff++
					if(stuff)
						to_chat(user, span_notice("I pick up the stalks with the pitchfork."))
					else
						to_chat(user, span_warning("I'm carrying enough with the pitchfork."))
					W.update_icon()
					return

	if(istype(I, /obj/item/rogueweapon/mace/woodclub))//reused some commented out code
		var/statboost = user.STASTR*3 + (user?.get_skill_level(/datum/skill/labor/farming)*5) //a person with no skill and 10 strength will thresh about a third of the stalks on average
		var/threshchance = clamp(statboost, 20, 100)
		for(var/obj/item/natural/chaff/C in get_turf(src))
			if(C == src)//so it doesnt delete itself and stop the loop
				continue
			if(prob(threshchance))
				C.thresh()
		user.visible_message(span_notice("[user] threshes the stalks!"), \
							span_notice("I thresh the stalks."))
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(loc,"plantcross", 100, FALSE)
		playsound(loc,"smashlimb", 50, FALSE)
		src.thresh()
		return
	..()

/obj/item/natural/chaff/wheat
	icon_state = "wheatchaff"
	name = "wheat stalks"
	foodextracted = /obj/item/reagent_containers/food/snacks/grown/wheat

/obj/item/natural/chaff/oat
	name = "oat stalks"
	icon_state = "oatchaff"
	foodextracted = /obj/item/reagent_containers/food/snacks/grown/oat

/obj/item/natural/chaff/rice
	name = "rice stalks"
	icon_state = "ricechaff"
	foodextracted = /obj/item/reagent_containers/food/snacks/grown/rice

#undef BASE_SHUCK_TIME
