/obj/item/soap
	name = "soap"
	desc = "One of Pestra's more humble and unassuming gifts. Take care not to slip!"
	gender = PLURAL
	icon = 'icons/roguetown/items/soaps.dmi'
	icon_state = "soap_plain"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	throwforce = 0
	throw_speed = 1
	throw_range = 1
	grind_results = list(/datum/reagent/lye = 10)
	dropshrink = 0.7
	var/cleanspeed = 20 //as fast as 5 arcyne Prestidigitation
	var/uses = 100
	var/datum/pollutant/fragrance/fragrance_type
	fragrance_type = 0
	var/datum/reagent/medicine/medicine_type
	medicine_type = 0

/obj/item/soap/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 10)

/obj/item/soap/examine(mob/user)
	. = ..()
	var/max_uses = initial(uses)
	var/msg = "It looks freshly-made."
	if(uses != max_uses)
		var/percentage_left = uses / max_uses
		switch(percentage_left)
			if(0 to 0.15)
				msg = "There's just a tiny bit left of what it used to be; You're not sure it'll last much longer."
			if(0.15 to 0.30)
				msg = "It's dissolved quite a bit, but there's still some life to it."
			if(0.30 to 0.50)
				msg = "It's past its prime, but it's definitely still good."
			if(0.50 to 0.75)
				msg = "It's started to get a little smaller than it used to be, but it'll definitely still last for a while."
			else
				msg = "It's seen some light use, but it's still pretty fresh."
	. += span_notice("[msg]")

/obj/item/soap/proc/decreaseUses(mob/user)
	uses--
	if(uses <= 0)
		to_chat(user, span_warning("[src] crumbles into tiny bits!"))
		qdel(src)

/obj/item/soap/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/turf/bathspot = get_turf(target)
	if(ishuman(target) && (istype(bathspot, /turf/open/water/bath) || locate(/obj/structure/hotspring) in bathspot))
		return
	if(!proximity || !check_allowed_items(target, target_self=1))
		return
	if(istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user] begins to scrub \the [target.name] out with [src]."), span_warning("I begin to scrub \the [target.name] out with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("I scrub \the [target.name] out."))
			qdel(target)
			decreaseUses(user)

	else if(ishuman(target) && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/mob/living/carbon/human/H = user
		user.visible_message(span_warning("\the [user] washes \the [target]'s mouth out with [src.name]!"), span_notice("I wash \the [target]'s mouth out with [src.name]!")) //washes mouth out with soap sounds better than 'the soap' here			if(user.zone_selected == "mouth")
		H.lip_style = null //removes lipstick
		H.update_body()
		decreaseUses(user)
		return
	else if(istype(target, /obj/structure/roguewindow))
		user.visible_message(span_notice("[user] begins to clean \the [target.name] with [src]..."), span_notice("I begin to clean \the [target.name] with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("I clean \the [target.name]."))
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.set_opacity(initial(target.opacity))
			decreaseUses(user)
	else
		user.visible_message(span_notice("[user] begins to clean \the [target.name] with [src]..."), span_notice("I begin to clean \the [target.name] with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("I clean \the [target.name]."))
			for(var/obj/effect/decal/cleanable/C in target)
				qdel(C)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
			decreaseUses(user)
	return


/obj/item/soap/attack(mob/target, mob/user)
	var/turf/bathspot = get_turf(target)
	if(!istype(bathspot, /turf/open/water/bath) && !locate(/obj/structure/hotspring) in bathspot)
		return
	if(ishuman(target))
		visible_message(span_info("[user] begins washing [target] with the [src]."))
		if(do_after(user, 50))
			wash_atom(target,CLEAN_MEDIUM)
			if(HAS_TRAIT(user, TRAIT_GOODLOVER))
				visible_message(span_info("[user] expertly cleans and soothes [target] with the [src]."))
				to_chat(target, span_love("I feel so relaxed and clean!"))
				target.add_stress(/datum/stressevent/bathcleaned)
				if(fragrance_type)
					target.AddComponent(/datum/component/temporary_pollution_emission, fragrance_type, 5, 10 MINUTES)
				if(medicine_type && target.reagents)
					target.reagents.add_reagent(medicine_type, 1)
			else
				visible_message(span_info("[user] tries their best to scrub [target] with the [src]."))
				to_chat(target, span_warning("That's a bit nicer, I guess."))
				target.add_stress(/datum/stressevent/bath)
				if(fragrance_type)
					target.AddComponent(/datum/component/temporary_pollution_emission, fragrance_type, 5, 10 MINUTES)
				if(medicine_type && target.reagents)
					target.reagents.add_reagent(medicine_type, 1)
			uses -= 1
			if(uses == 0)
				qdel(src)

/obj/item/soap/bath
	name = "herbal soap"
	desc = "A soap made from various herbs"
	icon_state = "soap_herbal"
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON

/obj/item/soap/rosa
	name = "rosa soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar has a pleasant rosa aroma. It has a cute heart stamped into the center."
	icon_state = "soap_rosa"
	fragrance_type = /datum/pollutant/fragrance/rose

/obj/item/soap/vanilla //
	name = "vanilla soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar has a pleasant vanilla aroma."
	icon_state = "soap_vanilla"
	fragrance_type = /datum/pollutant/fragrance/vanilla

/obj/item/soap/calendula // Has to be used in bath or hotspring turfs, gotta work up some soapysuds to get the healing juices to work
	name = "calendula soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar carries minor healing properties when used in bathwaters."
	icon_state = "soap_calendula"
	fragrance_type = /datum/pollutant/fragrance/floral
	medicine_type = /datum/reagent/medicine/healthpot

/obj/item/soap/mana // Has to be used in bath or hotspring turfs
	name = "mana soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar carries minor restorative properties when used in bathwaters."
	icon_state = "soap_mana"
	fragrance_type = /datum/pollutant/fragrance/floral
	medicine_type = /datum/reagent/medicine/manapot

/obj/item/soap/citrus
	name = "citrus soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar has a pleasant citrus aroma."
	icon_state = "soap_citrus"
	fragrance_type = /datum/pollutant/fragrance/citrus

/obj/item/soap/tea
	name = "tea-leaf soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar has a pleasant tea aroma."
	icon_state = "soap_tea"
	fragrance_type = /datum/pollutant/fragrance/tea

/obj/item/soap/coffee
	name = "coffee soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar has a pleasant coffee aroma."
	icon_state = "soap_coffee"
	fragrance_type = /datum/pollutant/fragrance/coffee

/obj/item/soap/jackberry
	name = "jackberry soap"
	uses = 100
	cleanspeed = 50
	desc = "One of Pestra's more humble and unassuming gifts. This bar has a pleasant jackberry aroma."
	icon_state = "soap_jackberry"
	fragrance_type = /datum/pollutant/fragrance/Jackberry
