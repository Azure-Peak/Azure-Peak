/obj/item/natural/ash
	name = "ash"
	desc = "A dark remnant of decadent flames."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	w_class = WEIGHT_CLASS_TINY
	var/being_deleted = FALSE
	materia = list(/datum/materia_aspect/fire)
	gender = PLURAL
	bundletype = /obj/item/natural/bundle/ash

/obj/item/natural/ash/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Ash can be used as fertilizer, in order to improve a crop's health. To do so, left-click the crop or its soil while holding the ash.")

/obj/item/natural/ash/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/boat,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/ash/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if(prob(prob2break))
			qdel(src)

/obj/item/natural/ash/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] scatters [src]."))
	if(being_deleted || QDELETED(src))
		return
	being_deleted = TRUE
	qdel(src)

/obj/item/natural/ash/Destroy()
	being_deleted = TRUE
	return ..()

/obj/item/natural/bundle/ash
	name = "pile of ashes"
	desc = "Loose ash gathered into a pile for easier handling."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash2"
	firefuel = 0
	resistance_flags = NONE
	maxamount = 10
	stacktype = /obj/item/natural/ash
	stackname = "portions of ash"
	icon1 = "ash2"
	icon1step = 5
	icon2 = "ash3"
	icon2step = 10

/obj/item/natural/bundle/ash/full
	amount = 10

/proc/is_ash_item(obj/item/I)
	return istype(I, /obj/item/natural/ash) || istype(I, /obj/item/natural/bundle/ash)

/proc/consume_ash_unit(obj/item/I)
	if(istype(I, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = I
		return B.use(1)
	qdel(I)
	return TRUE
