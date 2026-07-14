/obj/item/poultrice
	name = "poultice"
	desc = "A thick bundle of berry sludge wrapped in cloth. Excellent for treating burns and stemming the bleeding of open wounds."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "cream"
	color = "#6300a5"
	w_class = WEIGHT_CLASS_SMALL

	var/uses = 5

/obj/item/poultrice/attack(mob/living/M, mob/user)
	poultrice(M, user)

/obj/item/poultrice/proc/poultrice(mob/living/target, mob/living/user)
	if(!istype(user))
		return FALSE

	if(uses <= 0)
		to_chat(user, span_warning("The poultice has been exhausted."))
		qdel(src)
		return FALSE

	var/mob/living/doctor = user
	var/mob/living/patient = target

	var/list/treatable
	var/obj/item/bodypart/affecting
	var/is_simple_animal = !iscarbon(patient)

	if(iscarbon(patient))
		affecting = patient.get_bodypart(check_zone(doctor.zone_selected))
		if(!affecting)
			to_chat(doctor, span_warning("That limb is missing."))
			return FALSE

		treatable = affecting.get_poultriceable_wounds()
	else
		treatable = patient.get_poultriceable_wounds()

	if(!length(treatable))
		to_chat(doctor, span_warning("There are no wounds that can benefit from a poultice."))
		return FALSE

	var/datum/wound/target_wound = treatable.len > 1 ? input(doctor, "Which wound?", "[src]") as null|anything in treatable : treatable[1]
	if(!target_wound)
		return FALSE

	if(!do_after(doctor, 3 SECONDS, target = patient))
		return FALSE

	playsound(loc, 'modular/Creechers/sound/milking1.ogg', 100, TRUE)

	if(target_wound.can_sew)
		target_wound.set_bleed_rate(target_wound.bleed_rate * 0.5)

		if(patient == doctor)
			if(is_simple_animal)
				doctor.visible_message(span_notice("[doctor] packs a poultice into [doctor.p_them()]self."), span_notice("I pack a poultice into myself, slowing the bleeding."))
			else
				doctor.visible_message(span_notice("[doctor] packs a poultice into [doctor.p_them()]self."), span_notice("I pack a poultice into my [affecting], slowing the bleeding."))
		else
			if(is_simple_animal)
				doctor.visible_message(span_notice("[doctor] packs a poultice into [patient]."), span_notice("I pack a poultice into [patient], slowing the bleeding."))
			else
				doctor.visible_message(span_notice("[doctor] packs a poultice into [patient]'s [affecting]."), span_notice("I pack a poultice into [patient]'s [affecting], slowing the bleeding."))
	else
		target_wound.sew_wound()

		if(patient == doctor)
			if(is_simple_animal)
				doctor.visible_message(span_notice("[doctor] applies a poultice to [doctor.p_them()]self."), span_notice("I apply a poultice to myself."))
			else
				doctor.visible_message(span_notice("[doctor] applies a poultice to [doctor.p_them()]self."), span_notice("I apply a poultice to my [affecting]."))
		else
			if(is_simple_animal)
				doctor.visible_message(span_notice("[doctor] applies a poultice to [patient]."), span_notice("I apply a poultice to [patient]."))
			else
				doctor.visible_message(span_notice("[doctor] applies a poultice to [patient]'s [affecting]."), span_notice("I apply a poultice to [patient]'s [affecting]."))

	uses -= 1

	log_combat(doctor, patient, "treated", "poultice")

	if(uses <= 0)
		to_chat(user, span_warning("The poultice has been exhausted."))
		qdel(src)

	return TRUE

/obj/item/poultrice/honey
	name = "honeyed poultice"
	desc = "A thick bundle of berry sludge and honey wrapped in cloth. Excellent for treating burns and stemming the bleeding of open wounds. The honey's potent properties mean far less is consumed with each application."
	uses = 25
	color = "#d3be00"
