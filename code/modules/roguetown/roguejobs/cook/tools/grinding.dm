#define BASE_GRIND_TIME 1 SECONDS
/obj/item/millstone // Previous structure path means it cannot be crafted on tables
	name = "millstone"
	desc = "A millstone used to grind grain into flour."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "millstone"
	density = FALSE
	anchored = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 400
	var/list/obj/item/to_grind = list()

/obj/item/millstone/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking the millstone with certain ingredients, such as grain, will turn it into powder.")
	. += span_info("For powdered grain, left-clicking it with a container of water will wetten it. Left-click it with an open palm to knead it into a half-clump of dough.")
	. += span_info("Once kneaded, left-click the half-clump with another handful of powdered grain to turn it into a completed ball of dough; fit to bake in an oven, or to be further bedazzled upon.")

/obj/item/millstone/attackby(obj/item/W, mob/living/user, params)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/scaled_grind_time = BASE_GRIND_TIME / get_cooktime_divisor(cs)
	if(W.mill_result)
		if(do_after(user, scaled_grind_time, target = src))
			new W.mill_result(get_turf(loc))
			qdel(W)
	..()

#undef BASE_GRIND_TIME
