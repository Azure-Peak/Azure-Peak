/obj/structure/roguemachine/hag_ward
	name = "Strange Ward"
	desc = "A strange overgrown ward."
	icon = 'icons/roguetown/items/hag/hag_ward.dmi'
	icon_state = "ward"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	pixel_x = -16
	var/required_reagent = null
	var/units_needed = 90

/obj/structure/roguemachine/hag_ward/Initialize(mapload)
	. = ..()
	GLOB.hag_wards += src
	create_reagents(100)
	var/list/possible_reagents = list(
		/datum/reagent/medicine/antidote,
		/datum/reagent/medicine/strong_antidote,
		/datum/reagent/berrypoison,
		/datum/reagent/stampoison,
		/datum/reagent/strongstampoison,
		/datum/reagent/medicine/healthpot,
		/datum/reagent/medicine/stronghealth,
		/datum/reagent/medicine/manapot,
		/datum/reagent/medicine/strongmana,
		/datum/reagent/medicine/stampot,
		/datum/reagent/medicine/strongstam
	)
	required_reagent = pick(possible_reagents)

/obj/structure/roguemachine/hag_ward/Destroy()
	GLOB.hag_wards -= src
	if(GLOB.hag_wards.len)
		src.visible_message(span_warning("The roots surrounding the ward still look strong, this wasn't the last of them."))
	else
		src.visible_message(span_warning("You can feel a faint hum as birds fly away from the center of the bog, something changed."))
	return ..()

/obj/structure/roguemachine/hag_ward/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CURSE_SCAR) || GLOB.hag_rite_active)
		var/datum/reagent/R = required_reagent
		. += "<br><span class='boldwarning'>The scar on your skin pulses. The roots of this ward crave [units_needed] units of [initial(R.name)].</span>"
	else
		. += "<br><span class='notice'>It seems to be feeding on something in the air, but you can't tell what.</span>"

/obj/structure/roguemachine/hag_ward/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_CURSE_SCAR) && !GLOB.hag_rite_active)
		return ..()
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I
		if(!container.reagents.has_reagent(required_reagent))
			to_chat(user, span_warning("The roots recoil from the liquid! It's not what they want."))
			return
		var/amount_to_transfer = min(container.reagents.get_reagent_amount(required_reagent), units_needed)
		var/removed = container.reagents.trans_to(src, amount_to_transfer, transfered_by = user)
		if(removed)
			units_needed -= removed
			to_chat(user, span_notice("The ward greedily drinks the [initial(required_reagent:name)]. Only [max(0, units_needed)] units remain."))

			if(units_needed <= 0)
				src.visible_message(span_warning("The [src] shrivels and rots away as the roots retreat into the soil!"))
				qdel(src)
		return
	..()
