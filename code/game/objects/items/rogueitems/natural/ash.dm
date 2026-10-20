/obj/item/ash
	name = "ash"
	desc = "A dark remnant of decadent flames."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	w_class = WEIGHT_CLASS_TINY
	var/being_deleted = FALSE
	materia = list(/datum/materia_aspect/fire)
	gender = PLURAL

/obj/item/ash/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Ash can be used as fertilizer, in order to improve a crop's health. To do so, left-click the crop or its soil while holding the ash.")

/obj/item/ash/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/boat,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/ash/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/ash))
		var/obj/item/natural/bundle/ash/B = new(src.loc)
		to_chat(user, span_info("I gather the ash into a pile."))
		qdel(W)
		qdel(src)
		user.put_in_hands(B)
		return
	if(istype(W, /obj/item/natural/bundle/ash))
		var/obj/item/natural/bundle/ash/B = W
		if(B.amount < B.maxamount)
			B.amount++
			B.update_bundle()
			user.visible_message(span_info("[user] adds [src] to the pile."), span_info("I add [src] to the pile."))
			qdel(src)
		else
			to_chat(user, span_info("I can't add any more ash to the pile without it falling apart."))
		return
	return ..()

/obj/item/ash/attack_right(mob/user)
	. = ..()
	if(user.get_active_held_item())
		return
	to_chat(user, span_notice("I begin to collect [src]."))
	if(move_after(user, 4 SECONDS, target = src))
		var/list/ash_to_bundle = list()
		for(var/obj/item/ash/A in get_turf(src))
			ash_to_bundle += A
		var/ash_count = ash_to_bundle.len
		while(ash_count > 0)
			if(ash_count == 1)
				var/obj/item/ash/A = ash_to_bundle[1]
				ash_to_bundle.Remove(A)
				ash_count--
			else
				var/obj/item/natural/bundle/ash/B = new(get_turf(user))
				var/add_amount_clamped = clamp(ash_count, 2, B.maxamount)
				B.amount = add_amount_clamped
				B.update_bundle()
				ash_count -= add_amount_clamped
				user.put_in_hands(B)
		playsound(user, drop_sound, 70, FALSE, -4)
		for(var/obj/item/ash/A in ash_to_bundle)
			qdel(A)

/obj/item/ash/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if(prob(prob2break))
			qdel(src)

/obj/item/ash/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] scatters [src]."))
	if(being_deleted || QDELETED(src))
		return
	being_deleted = TRUE
	qdel(src)

/obj/item/ash/Destroy()
	being_deleted = TRUE
	return ..()

/proc/is_ash_item(obj/item/I)
	return istype(I, /obj/item/ash) || istype(I, /obj/item/natural/bundle/ash)

/proc/consume_ash_unit(obj/item/I)
	if(istype(I, /obj/item/natural/bundle/ash))
		var/obj/item/natural/bundle/ash/pile = I
		return pile.use(1)
	if(istype(I, /obj/item/ash))
		qdel(I)
		return TRUE
	return FALSE

/obj/item/natural/bundle/ash
	name = "pile of ashes"
	desc = "Loose ash gathered into a pile for easier handling."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	maxamount = 10
	stacktype = /obj/item/ash
	stackname = "portions of ash"
	icon1 = "ash2"
	icon1step = 5
	icon2 = "ash3"
	icon2step = 10

/obj/item/natural/bundle/ash/use(used)
	if(amount < used)
		return FALSE
	amount -= used
	if(amount <= 0)
		qdel(src)
	else if(amount == 1)
		replace_with_single_ash()
	else
		update_bundle()
	return TRUE

/obj/item/natural/bundle/ash/proc/replace_with_single_ash()
	var/turf/drop_location = get_turf(src)
	var/obj/item/ash/single_ash = new(drop_location)
	var/mob/holder
	if(ismob(loc))
		holder = loc
	var/was_held = holder?.is_holding(src)
	if(was_held)
		holder.doUnEquip(src, TRUE, drop_location, silent = TRUE)
	qdel(src)
	if(was_held)
		holder.put_in_hands(single_ash)

/obj/item/natural/bundle/ash/attack_right(mob/user)
	if(item_flags & IN_STORAGE)
		return
	if(amount < 1)
		qdel(src)
		return
	if(amount == 1)
		var/obj/item/ash/single_ash = new(get_turf(src))
		user.put_in_hands(single_ash)
		qdel(src)
		return
	amount--
	var/obj/item/ash/single_ash = new(get_turf(src))
	user.put_in_hands(single_ash)
	if(amount == 1)
		replace_with_single_ash()
	else
		update_bundle()
		user.visible_message(span_info("[user] removes [single_ash] from [src]."), span_info("I remove [single_ash] from [src]."))
