//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/well
	name = "well"
	desc = "Far down inside the dark hole, water laps the walls of smooth brickwork."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	anchored = TRUE
	density = TRUE
	opacity = 0
	climb_time = 40
	climbable = TRUE
	layer = 2.91
	damage_deflection = 30

/obj/structure/well/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking a well with a bucket, pot, or similarly-sized container will eventually fill it to the brim with freshwater.")
	. += span_info("Some wells might provide alternatives to freshwater. Having a level in the Alchemy skill allows you to specifically check for non-freshwatered reagents inside the filled container.")

/obj/structure/well/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket))
		var/obj/item/reagent_containers/glass/bucket/W = I
		if(W.reagents.holder_full())
			to_chat(user, span_warning("[W] is full."))
			return
		if(do_after(user, 1 SECONDS, target = src))
			var/list/waterl = list(/datum/reagent/water = 250)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>I fill [W] from [src].</span>")
			playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
			return
	else ..()

/obj/structure/well/poisoned
	name = "dubious well"
	desc = "A fetid stench eminates from this orifice of brick-and-wood, yearning to be ladled into unsuspecting buckets."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	color = "#59aa65"
	anchored = TRUE
	density = TRUE
	opacity = 0
	climb_time = 40
	climbable = TRUE
	layer = 2.91
	damage_deflection = 30

/obj/structure/well/poisoned/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket))
		var/obj/item/reagent_containers/glass/bucket/W = I
		if(W.reagents.holder_full())
			to_chat(user, span_warning("[W] is full."))
			return
		if(do_after(user, 30, target = src))
			var/list/waterl = list(/datum/reagent/water = 50, /datum/reagent/organpoison = 50)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>I fill [W] from [src]. The water looks vile, am I really going to drink this?</span>")
			playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
			return
	else ..()

/obj/structure/well/fountain
	name = "water fountain"
	desc = "A slightly more civilized alternative to drinking straight from a river."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER

/obj/structure/well/fountain/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		user.visible_message(span_info("[user] starts to drink from [src]."))
		drink_act(user, L)
		return
	..()

/obj/structure/well/fountain/proc/drink_act(mob/user, mob/living/L)
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	if(L.stat != CONSCIOUS)
		return
	if(do_after(L, 25, target = src))
		var/list/waterl = list(/datum/reagent/water = 5)
		var/datum/reagents/reagents = new()
		reagents.add_reagent_list(waterl)
		reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
		playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		drink_act(user, L)
	return
