// todo: give a special sprite?
/obj/structure/mirror/fancy/hag
	name = "wyrd mirror"
	desc = "The reflection in the mirror shimmers and warps..."
	var/last_scry
	var/cooldown = 30 SECONDS
	var/fed = TRUE // you get one free use on roundstart

/obj/structure/mirror/fancy/hag/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/alch) && !QDELING(I))
		if(fed)
			to_chat(user, span_notice("The roots are fully sated already!"))
		else
			qdel(I)
			fed = TRUE
			to_chat(user, span_notice("The roots accept the offering and are sated. They will lend you their sight."))

/obj/structure/mirror/fancy/hag/get_mechanics_examine(mob/user)
	. = ..()

	if(HAS_TRAIT(user, TRAIT_ANCIENT_HAG) || HAS_TRAIT(user, TRAIT_FEYTOUCHED))
		. += span_info("Right-click the mirror to scry with it.")

/obj/structure/mirror/fancy/hag/attack_right(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return

	if(!fed)
		to_chat(user, span_warning("The roots hunger. Feed them any moss or herb to peer through them once more."))
		return
	
	if (world.time < (last_scry + cooldown))
		return

	var/mob/living/carbon/human/H = user
	
	if(obj_broken || !Adjacent(user))
		return
	
	if(!HAS_TRAIT(H, TRAIT_ANCIENT_HAG) && !HAS_TRAIT(H, TRAIT_FEYTOUCHED))
		return
	
	var/input = input(user, "WHO DO YOU SEEK?", "THE ROOTS SEE ALL") as text|null
	if(!input)
		return
	if(!user.key)
		return
	
	var/mob/living/carbon/human/target = null
	for(var/mob/living/carbon/human/HL in GLOB.mob_list) 
		if(HL.real_name == input)
			if(HAS_TRAIT(HL, TRAIT_ANTISCRYING))
				to_chat(user, span_warning("They are not within the gaze of the mirror."))
				return
			target = HL
	if(!target)
		to_chat(user, span_warning("They are not within the gaze of the mirror; they may be destroyed, utterly."))
		return

	target.throw_alert("hagscry", /atom/movable/screen/alert/hagscry, override = TRUE)
	message_admins("SCRYING: [user.real_name] ([user.ckey]) has scryed [target.real_name] ([target.ckey]) via the hag hut mirror.")
	log_game("SCRYING: [user.real_name] ([user.ckey]) has scryed [target.real_name] ([target.ckey]) via the hag hut mirror.")
	playsound(src, 'sound/hag/hag_cackles_short.ogg', 100, TRUE)
	to_chat(user, span_warning("You peer into the mirror, gazing through the network of roots..."))
	if(target.stat != DEAD && target.stat != UNCONSCIOUS)
		to_chat(target, span_warning("I feel as though the ground is watching me."))
	ADD_TRAIT(user, TRAIT_NOSSDINDICATOR, "hagmirror")
	var/mob/dead/observer/screye/blackmirror/S = H.scry_ghost()
	if(!S)
		return
	S.ManualFollow(target)
	user.visible_message(span_warning("[user] stares into [src], [user.p_their()] eyes glazing over..."))
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/, clear_alert), "hagscry", TRUE), 8 SECONDS)
	sleep(81)
	REMOVE_TRAIT(user, TRAIT_NOSSDINDICATOR, "hagmirror")
	last_scry = world.time
	fed = FALSE
	return

/obj/item/handmirror/hag
	name = "wyrd hand mirror"
	var/last_scry
	var/cooldown = 30 SECONDS

/obj/item/handmirror/hag/attack_right(mob/user)
	if(!ishuman(user))
		return
	
	var/mob/living/carbon/human/H = user
	
	if (world.time < (last_scry + cooldown))
		return
	
	if(!HAS_TRAIT(H, TRAIT_ANCIENT_HAG) && !HAS_TRAIT(H, TRAIT_FEYTOUCHED))
		return

	if(!length(H.mind.known_people + GLOB.bogged_players))
		to_chat(H, span_warning("I don't know anyone to scry upon."))
		return

	var/list/people_names = list()
	for(var/person_name in (H.mind.known_people + GLOB.bogged_players))
		if(!people_names.Find(person_name))
			people_names += person_name

	var/input = tgui_input_list(user, "Who are you looking for?", "THE ROOTS SEE ALL", people_names)
	if(!input)
		return
	if(!H.key)
		return
	
	var/mob/living/carbon/human/target = null
	for(var/mob/living/carbon/human/HL in GLOB.mob_list) 
		if(HL.real_name == input)
			if(HAS_TRAIT(HL, TRAIT_ANTISCRYING))
				to_chat(user, span_warning("The gaze of the roots is rebuffed by a ward!"))
				return
			target = HL
	if(!target)
		to_chat(user, span_warning("They are not within the gaze of the mirror; they may be destroyed, utterly."))
		return

	target.throw_alert("hagscry", /atom/movable/screen/alert/hagscry, override = TRUE)
	message_admins("SCRYING: [user.real_name] ([user.ckey]) has scryed [target.real_name] ([target.ckey]) via a wyrd mirror.")
	log_game("SCRYING: [user.real_name] ([user.ckey]) has scryed [target.real_name] ([target.ckey]) via a wyrd mirror.")
	playsound(src, 'sound/hag/hag_cackles_short.ogg', 100, TRUE)
	to_chat(user, span_warning("You peer into the mirror, gazing through the network of roots..."))
	if(target.stat != DEAD && target.stat != UNCONSCIOUS)
		to_chat(target, span_warning("I feel as though the ground is watching me."))
	ADD_TRAIT(user, TRAIT_NOSSDINDICATOR, "hagmirror")
	var/mob/dead/observer/screye/blackmirror/S = user.scry_ghost()
	if(!S)
		return
	S.ManualFollow(target)
	user.visible_message(span_warning("[user] stares into [src], [user.p_their()] eyes glazing over..."))
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/, clear_alert), "hagscry", TRUE), 8 SECONDS)
	sleep(81)
	REMOVE_TRAIT(user, TRAIT_NOSSDINDICATOR, "hagmirror")
	last_scry = world.time
	return


/obj/item/handmirror/hag/get_mechanics_examine(mob/user)
	. = ..()

	if(HAS_TRAIT(user, TRAIT_ANCIENT_HAG) || HAS_TRAIT(user, TRAIT_FEYTOUCHED))
		. += span_info("Right-click the mirror to scry with it.")
		. += span_info("You can only scry people if you know them, or if they are in the bog.")

/obj/item/handmirror/hag/rmb_self(mob/user)
	src.attack_right(user)
