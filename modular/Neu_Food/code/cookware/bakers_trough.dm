/obj/structure/bakers_trough
	name = "baker's trough"
	desc = "A large wooden trough, used by professional bakers to work large quantities of dough at once. One ball of dough at a time will not do when you have a village to feed."
	icon = 'modular/Neu_Food/icons/cookware/bakers_trough.dmi'
	icon_state = "through_empty"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	climbable = TRUE
	climb_offset = 10
	pass_flags = LETPASSTHROW
	pass_flags_self = PASSTABLE | LETPASSTHROW
	resistance_flags = FLAMMABLE
	max_integrity = 70
	integrity_failure = 0.33
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	blade_dulling = DULLING_BASHCHOP
	debris = list(/obj/item/grown/log/tree/small = 1)
	var/flour_amount = 0
	var/water_amount = 0
	var/dough_amount = 0
	var/max_flour = 40
	var/max_water = 200
	var/flour_per_dough = 2
	var/water_per_dough = 10
	var/base_knead_time = 2 SECONDS
	var/busy = FALSE

/obj/structure/bakers_trough/Initialize()
	. = ..()
	update_trough_icon()

/obj/structure/bakers_trough/examine(mob/user)
	. = ..()
	if(!flour_amount && !water_amount && !dough_amount)
		. += span_notice("It is empty.")
		return

	if(flour_amount || water_amount)
		. += span_notice("[src] is full of [flour_amount] handful[flour_amount == 1 ? "" : "s"] of flour and [water_amount] dram[water_amount == 1 ? "" : "s"] of water.")
		var/water_needed = water_needed_for_flour()
		if(water_amount < water_needed)
			var/water_short = water_needed - water_amount
			. += span_warning("The flour is too dry to make a proper dough.")
			. += span_notice("It needs [water_short] more dram[water_short == 1 ? "" : "s"] of water to work all of the flour into dough.")
	if(dough_amount)
		. += span_notice("There [dough_amount == 1 ? "is" : "are"] [dough_amount] finished dough[dough_amount == 1 ? "" : "s"] ready to be turned out.")

/obj/structure/bakers_trough/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click it with an empty hand to knead flour and water into dough.")
	. += span_info("Right-click it to empty it.")

/obj/structure/bakers_trough/attackby(obj/item/I, mob/living/user, params)
	if(busy)
		to_chat(user, span_warning("[src] is already being worked."))
		return TRUE

	if(istype(I, /obj/item/reagent_containers/powder/flour))
		var/obj/item/reagent_containers/powder/flour/F = I
		if(add_flour(F, user))
			return TRUE

	if(istype(I, /obj/item/storage/roguebag))
		var/obj/item/storage/roguebag/sack = I
		if(add_flour_from_sack(sack, user))
			return TRUE

	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/R = I
		if(R.reagents && R.reagents.has_reagent(/datum/reagent/water, 1))
			if(add_water(R, user))
				return TRUE

	return ..()

/obj/structure/bakers_trough/attack_hand(mob/living/user)
	if(user.used_intent.type != INTENT_HELP || user.cmode)
		return ..()

	if(busy)
		to_chat(user, span_warning("[src] is already being worked."))
		return TRUE

	var/dough_to_make = available_dough_count()
	if(dough_to_make <= 0)
		to_chat(user, span_warning("[src] needs at least [flour_per_dough] flour and [water_per_dough] drams of water to knead."))
		return TRUE

	to_chat(user, span_notice("You start kneading the dough in [src]."))
	playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
	busy = TRUE
	if(!do_after(user, get_knead_time(user, dough_to_make), target = src))
		busy = FALSE
		to_chat(user, span_warning("You stop kneading the dough in [src]."))
		return TRUE

	dough_to_make = available_dough_count()
	if(dough_to_make <= 0)
		busy = FALSE
		return TRUE

	flour_amount -= dough_to_make * flour_per_dough
	water_amount -= dough_to_make * water_per_dough
	dough_amount += dough_to_make
	if(user.mind)
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * dough_to_make)
	user.visible_message(span_notice("[user] finishes kneading dough in [src]."), span_notice("You finish kneading the dough in [src]."))
	busy = FALSE
	update_trough_icon()
	return TRUE

/obj/structure/bakers_trough/attack_right(mob/user)
	. = ..()
	if(.)
		return

	if(busy)
		to_chat(user, span_warning("[src] is already being worked."))
		return TRUE

	if(!flour_amount && !water_amount && !dough_amount)
		to_chat(user, span_warning("[src] is already empty."))
		return TRUE

	var/turning_out_dough = dough_amount > 0
	if(turning_out_dough)
		user.visible_message(span_notice("[user] starts turning dough out from [src]."), span_notice("You start turning the dough out from [src]."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
	else
		user.visible_message(span_notice("[user] starts emptying [src]."), span_notice("You start emptying [src]."))
	busy = TRUE
	if(!do_after(user, 3 SECONDS, target = src))
		busy = FALSE
		if(turning_out_dough)
			to_chat(user, span_warning("You stop turning the dough out from [src]."))
		else
			to_chat(user, span_warning("You stop emptying [src]."))
		return TRUE

	empty_trough()
	busy = FALSE
	if(turning_out_dough)
		to_chat(user, span_notice("You finish turning the dough out from [src]."))
	else
		to_chat(user, span_notice("You finish emptying [src]."))
	return TRUE

/obj/structure/bakers_trough/proc/add_flour(obj/item/reagent_containers/powder/flour/F, mob/living/user)
	if(flour_space_left() <= 0)
		to_chat(user, span_warning("[src] can't hold any more flour."))
		return TRUE

	var/needed_water = F.water_added ? water_per_dough : 0
	if(needed_water && water_space_left() < needed_water)
		to_chat(user, span_warning("[src] can't hold any more water."))
		return TRUE

	flour_amount++
	water_amount += needed_water
	qdel(F)
	if(needed_water)
		to_chat(user, span_notice("You add the wet flour to [src]."))
	else
		to_chat(user, span_notice("You add the flour to [src]."))
	update_trough_icon()
	return TRUE

/obj/structure/bakers_trough/proc/add_flour_from_sack(obj/item/storage/roguebag/sack, mob/living/user)
	var/datum/component/storage/STR = sack.GetComponent(/datum/component/storage)
	if(!STR)
		return FALSE

	var/list/things = STR.contents()
	var/added = 0
	for(var/obj/item/reagent_containers/powder/flour/F in things)
		if(flour_space_left() <= 0)
			break
		if(F.water_added && water_space_left() < water_per_dough)
			break
		STR.remove_from_storage(F, get_turf(src))
		flour_amount++
		if(F.water_added)
			water_amount += water_per_dough
		added++
		qdel(F)

	if(!added)
		to_chat(user, span_warning("[src] can't hold any more flour."))
		return TRUE

	user.visible_message(span_notice("[user] dumps flour into [src]."), span_notice("You dump [added] handful[added == 1 ? "" : "s"] of flour into [src]."))
	if(flour_space_left() <= 0)
		to_chat(user, span_warning("[src] can't hold any more flour."))
	update_trough_icon()
	return TRUE

/obj/structure/bakers_trough/proc/add_water(obj/item/reagent_containers/R, mob/living/user)
	var/space_left = water_space_left()
	if(space_left <= 0)
		to_chat(user, span_warning("[src] can't hold any more water."))
		return TRUE

	var/water_available = R.reagents.get_reagent_amount(/datum/reagent/water)
	var/water_to_add = min(space_left, water_available)
	if(water_to_add <= 0)
		return FALSE

	R.reagents.remove_reagent(/datum/reagent/water, water_to_add)
	water_amount += water_to_add
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(flour_amount)
		to_chat(user, span_notice("You wet the flour in [src]."))
	else
		to_chat(user, span_notice("You add [water_to_add] dram[water_to_add == 1 ? "" : "s"] of water to [src]."))
	if(water_space_left() <= 0)
		to_chat(user, span_warning("[src] can't hold any more water."))
	update_trough_icon()
	return TRUE

/obj/structure/bakers_trough/proc/empty_trough()
	var/turf/T = get_turf(src)
	for(var/i in 1 to dough_amount)
		new /obj/item/reagent_containers/food/snacks/rogue/dough(T)

	var/wet_flour_amount = min(flour_amount, floor(water_amount / water_per_dough))
	for(var/i in 1 to wet_flour_amount)
		var/obj/item/reagent_containers/powder/flour/F = new(T)
		F.make_wet()

	var/dry_flour_amount = flour_amount - wet_flour_amount
	for(var/i in 1 to dry_flour_amount)
		new /obj/item/reagent_containers/powder/flour(T)

	flour_amount = 0
	water_amount = 0
	dough_amount = 0
	update_trough_icon()

/obj/structure/bakers_trough/proc/available_dough_count()
	return min(floor(flour_amount / flour_per_dough), floor(water_amount / water_per_dough), floor((max_flour / flour_per_dough) - dough_amount))

/obj/structure/bakers_trough/proc/water_needed_for_flour()
	return floor(flour_amount / flour_per_dough) * water_per_dough

/obj/structure/bakers_trough/proc/flour_space_left()
	return max(0, max_flour - flour_amount - (dough_amount * flour_per_dough))

/obj/structure/bakers_trough/proc/water_space_left()
	return max(0, max_water - water_amount - (dough_amount * water_per_dough))

/obj/structure/bakers_trough/proc/get_knead_time(mob/living/user, dough_to_make)
	var/cooking_skill = SKILL_LEVEL_NONE
	if(user && user.mind)
		cooking_skill = user.get_skill_level(/datum/skill/craft/cooking)
	return (base_knead_time / get_cooktime_divisor(cooking_skill)) * dough_to_make

/obj/structure/bakers_trough/proc/update_trough_icon()
	cut_overlays()
	if(dough_amount > 0)
		add_overlay(mutable_appearance(icon, "dough"))
	else if(flour_amount > 0 && water_amount >= water_per_dough)
		add_overlay(mutable_appearance(icon, "wet_flour"))
	else if(flour_amount > 0)
		add_overlay(mutable_appearance(icon, "flour"))
