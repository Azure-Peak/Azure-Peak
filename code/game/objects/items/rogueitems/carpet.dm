/obj/item/carpet
	name = "roll of carpet"
	desc = "a roll of carpet, it can be rolled out onto a floor. "
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clothroll"
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	damtype = BRUTE
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	var/rug_to_layout = null
	var/amount = 6

/obj/item/carpet/examine(mob/user)
	. = ..()
	desc += "It has [amount] uses left."

/obj/item/carpet/exotic
	name = "roll of exotic carpet"
	desc = "a roll of exotic carpet, it can be rolled out onto a floor."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clothroll"
	amount = 1

/obj/item/carpet/exotic/examine(mob/user)
	. = ..()
	desc += "It has [amount] uses left."

/obj/item/carpet/exotic/attack_self(mob/living/carbon/human/user)
	var/obj/effect/decal/carpet/pickrug
	var/rugnameinput = input(user, "Exotic Rugs", "choose a rug to lay on the ground") as null|anything in GLOB.exoticrug_types
	testing("rugnameinput [rugnameinput]")
	pickrug = GLOB.exoticrug_types[rugnameinput]
	rug_to_layout = pickrug
	if(rug_to_layout == null)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/carpet) in Turf)
		to_chat(user, span_cult("There is already a rug here."))
		return
	var/crafttime = (31 - ((user.get_skill_level(/datum/skill/craft/carpentry))*5))

	user.visible_message(span_notice("\The [user] begins to roll out [user.p_their()] [name] over \the [Turf]."), span_notice("I start to roll out the [name] over \the [Turf]."))
	playsound(loc, 'sound/foley/bandage.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		user.visible_message(span_warning("[user] rolls out [user.p_their()] [name] onto [Turf]!"), \
		span_notice("I finish rolling out the [name] onto [Turf]!"))
		src.amount --
		new rug_to_layout(Turf)
	if(amount == 0)
		qdel(src)

/obj/item/carpet/standard
	name = "roll of standard carpet"
	desc = "a roll of standard carpet, it can be rolled out onto a floor."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clothroll"
	amount = 6

/obj/item/carpet/standard/examine(mob/user)
	. = ..()
	desc += "It has [amount] uses left."

/obj/item/carpet/standard/attack_self(mob/living/carbon/human/user)
	var/turf/open/floor/carpet/pickrug
	var/rugnameinput = input(user, "Standard Rugs", "choose a rug to lay on the ground") as null|anything in list("Inn", "Purple", "Red", "Stellar", "Royal Black")
	switch(rugnameinput)
		if("Inn")
			pickrug = /turf/open/floor/carpet/inn
		if("Purple")
			pickrug = /turf/open/floor/carpet/purple
		if("Red")
			pickrug = /turf/open/floor/carpet/red
		if("Stellar")
			pickrug = /turf/open/floor/carpet/stellar
		if("Royal Black")
			pickrug = /turf/open/floor/carpet/royalblack
	rug_to_layout = pickrug
	if(rug_to_layout == null)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/turf/open/floor/carpet) in Turf)
		to_chat(user, span_cult("There is already a rug here."))
		return
	var/crafttime = (31 - ((user.get_skill_level(/datum/skill/craft/carpentry))*5))

	user.visible_message(span_notice("\The [user] begins to roll out [user.p_their()] [name] over \the [Turf]."), span_notice("I start to roll out the [name] over \the [Turf]."))
	playsound(loc, 'sound/foley/bandage.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		user.visible_message(span_warning("[user] rolls out [user.p_their()] [name] onto [Turf]!"), \
		span_notice("I finish rolling out the [name] onto [Turf]!"))
		src.amount --
		new rug_to_layout(Turf)
	if(amount == 0)
		qdel(src)


GLOBAL_LIST_INIT(exoticrug_types, generate_exotic_rug_types())

/proc/generate_exotic_rug_types()
	RETURN_TYPE(/list)
	var/list/rugs = list()
	for(var/obj/effect/decal/carpet/rug as anything in subtypesof(/obj/effect/decal/carpet))
		rugs[initial(rug.name)] = rug // Uses the invoker name for displaying purposes
	return rugs

GLOBAL_LIST_INIT(standardrug_types, generate_standard_rug_types())

/proc/generate_standard_rug_types()
	RETURN_TYPE(/list)
	var/list/rugs = list()
	for(var/turf/open/floor/carpet/rug as anything in subtypesof(/turf/open/floor/carpet/))
		rugs[initial(rug.name)] = rug // Uses the invoker name for displaying purposes
	return rugs
