/obj/item/cross_construction_kit
	name = "blessed fog repelling cross construction kit"
	desc = "A bundle of sanctified wood and nails. Cannot be placed near existing holy sanctuaries. It doesn't work without a lamptern."
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "crosskit"

/obj/item/cross_construction_kit/attack_self(mob/user)
	// Check 8 tiles in every direction for ANY fog protection
	for(var/turf/T in range(4, user))
		var/area/A = get_area(T)
		if(A.fog_protected)
			to_chat(user, span_warning("The holy energies here are already saturated. You must find a place further from existing sanctuaries to plant this cross."))
			return

	to_chat(user, span_notice("You begin assembling the cross..."))
	if(do_after(user, 5 SECONDS, target = user))
		new /obj/structure/fluff/psycross/fog(get_turf(user))
		to_chat(user, span_notice("You finish the cross. It stands tall, ready to receive a light."))
		qdel(src)

/obj/structure/fluff/psycross/fog
	name = "fog-repelling cross"
	desc = "A tall wooden cross. It has a hook for a lantern to provide the light of sanctuary."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "cross_fog"
	anchored = TRUE
	density = TRUE
	var/active = FALSE
	var/range = 3
	var/obj/item/flashlight/flare/torch/lantern/inserted_lantern
	var/list/turf/affected_turfs = list()
	var/list/turf_to_original_area = list() // Stores the actual area instance to return to

/obj/structure/fluff/psycross/fog/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/flashlight/flare/torch/lantern))
		if(inserted_lantern)
			to_chat(user, span_warning("There is already a lantern on [src]."))
			return
		if(!I.forceMove(src))
			return
		inserted_lantern = I
		to_chat(user, span_notice("You hang the lantern on the cross."))
		icon_state = "cross_fog0"
		update_icon()
		return
	return ..()

/obj/structure/fluff/psycross/fog/attack_hand(mob/user)
	if(!inserted_lantern)
		to_chat(user, span_warning("[src] needs a lantern to be activated!"))
		return

	if(do_after(user, 5 SECONDS, target = src))
		active = !active
	if(active)
		activate_sanctuary()
		to_chat(user, span_notice("You light the lantern. The cross begins to hum with a protective aura."))
		icon_state = "cross_fog1"
		set_light(5, 2, "#fff2aa")
	else
		deactivate_sanctuary()
		to_chat(user, span_warning("You extinguish the lantern. The aura fades."))
		icon_state = "cross_fog0"
		set_light(0)
	update_icon()

/obj/structure/fluff/psycross/fog/proc/activate_sanctuary()
	var/turf/center = get_turf(src)
	var/area/rogue/indoors/sanctuary/my_sanctuary = new()
	my_sanctuary.name = "Sanctuary of [src.name]"

	for(var/turf/T in range(range, center))
		var/area/old_area = get_area(T)

		// Juuust in case admins place these too close to one another.
		if(old_area.fog_protected)
			continue

		turf_to_original_area[T] = old_area

		// Move turf into our new sanctuary instance
		my_sanctuary.contents += T
		affected_turfs += T

	for(var/mob/living/carbon/human/H in range(range, center))
		SSevent_scheduler.update_mob_fog_status(H, TRUE)

/obj/structure/fluff/psycross/fog/proc/deactivate_sanctuary()
	if(!affected_turfs.len) // Sanity check
		return

	for(var/turf/T in affected_turfs)
		var/area/original_instance = turf_to_original_area[T]
		if(original_instance)
			// Move the turf back into its original area instance
			original_instance.contents += T
	var/turf/center = get_turf(src)
	for(var/mob/living/carbon/human/H in range(range, center))
		SSevent_scheduler.update_mob_fog_status(H, FALSE)
	affected_turfs.Cut()
	turf_to_original_area.Cut()

/obj/structure/fluff/psycross/fog/Destroy()
	deactivate_sanctuary()
	if(inserted_lantern)
		inserted_lantern.forceMove(get_turf(src))
	return ..()

/area/rogue/indoors/sanctuary
	name = "Sanctified Ground"
	fog_protected = TRUE
