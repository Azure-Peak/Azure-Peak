GLOBAL_LIST_EMPTY(players_in_dream)

/obj/effect/dream_horror
	name = "Dream Horror"
	desc = "?????"
	icon = 'icons/effects/dad.dmi'
	icon_state = "dad"

/obj/effect/dream_horror/Initialize()
	. = ..()
	if(prob(1))
		name = "Dad"
		desc = "Dad is back! He even brought the milk!"

/obj/effect/dream_horror/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/divine/abyssor)
			. += span_danger("One of the greatest and eldest of the dreamfiends. It's said creatures of the dream take ages to grow in size... And this one is a true leviathan.")

/datum/stressevent/dream_horror
	timer = 999 MINUTES
	stressadd = 20
	desc = span_userdanger("WHAT IS THAT THING?!")

/proc/teleport_to_dream(mob/living/carbon/human/user, base_probability = 10000, probability = 10, weapons = TRUE)
	if(!ishuman(user))
		return

	var/effective_probability = probability
	if(user.patron.type == /datum/patron/divine/abyssor)
		effective_probability *= 5

	// Look kids, if you want accurate probability, don't use fractional numbers. Pickweight is safer and more accurate than prob() here.
	var/list/options = list("teleport" = effective_probability, "no_teleport" = base_probability - effective_probability)
	if(pickweight(options) == "no_teleport")
		return

	var/area/dream_area = GLOB.areas_by_type[/area/rogue/underworld/dream]
	if(!dream_area)
		return

	var/turf/original_turf = get_turf(user)
	if(!original_turf)
		return

	// Find safe turfs in dream area
	// I shouldn't really need this in an empty area but we have dearly beloved monkeys we call Admins.
	var/list/safe_turfs = list()
	for(var/turf/T in get_area_turfs(dream_area))
		if(T.density)
			continue
		var/valid = TRUE
		for(var/atom/movable/AM in T)
			if(AM.density && AM.anchored)
				valid = FALSE
				break
		if(valid)
			safe_turfs += T

	if(!safe_turfs.len)
		return

	var/turf/destination = pick(safe_turfs)
	if(!do_teleport(user, destination))
		return

	GLOB.players_in_dream |= user
	original_turf.visible_message(span_danger("[user] seems to vanish into thin air completely."))
	playsound(original_turf, 'sound/misc/area.ogg')
	user.add_stress(/datum/stressevent/dream_horror)
	user.blind_eyes(2)
	user.AddComponent(/datum/component/dream_echo, original_turf)
	if(!HAS_TRAIT(user, TRAIT_DARKVISION))
		ADD_TRAIT(user, TRAIT_DARKVISION, CULT_TRAIT)

	// Spawn weapons
	if (weapons) 
		for(var/i in 1 to 2)
			var/turf/weapon_turf = pick(safe_turfs)
			new /obj/effect/spawner/lootdrop/roguetown/abyssor(weapon_turf)

	// Schedule return
	user.apply_status_effect(/datum/status_effect/dream_teleport, original_turf)
	return TRUE

/proc/return_from_dream(mob/living/carbon/human/user, turf/original_turf)
	if(!user || QDELETED(user) || !original_turf)
		return

	GLOB.players_in_dream -= user
	user.remove_stress(/datum/stressevent/dream_horror)
	REMOVE_TRAIT(user, TRAIT_DARKVISION, CULT_TRAIT)
	user.blind_eyes(2)
	do_teleport(user, original_turf)
	qdel(user.GetComponent(/datum/component/dream_echo))
	if(!length(GLOB.players_in_dream))
		clean_dream_area(original_turf)

/proc/clean_dream_area(turf/target_turf)
	var/area/dream_area = GLOB.areas_by_type[/area/rogue/underworld/dream]
	if(!dream_area || !target_turf)
		return

	var/list/items_to_return = list()

	for(var/turf/T in dream_area)
		for(var/obj/item/I in T)
			//If you build a statue in here, MORE POWER TO YOU...
			if(!I.anchored)
				items_to_return += I

	for(var/obj/item/I in items_to_return)
		do_teleport(I, target_turf)

/obj/effect/spawner/lootdrop/roguetown/abyssor
	icon_state = "cot"
	loot = list(
		/obj/item/rogueweapon/greataxe/dreamscape = 50,
		/obj/item/rogueweapon/halberd/glaive/dreamscape = 25,
		/obj/item/rogueweapon/greatsword/bsword/dreamscape = 25,
		/obj/item/abyssal_marker/volatile = 150,
		/obj/item/rogueweapon/spear/dreamscape_trident = 5,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 1,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 1,
	)
	lootcount = 1

/datum/component/dream_echo
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/turf/original_location

/datum/component/dream_echo/Initialize(turf/original_turf)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	original_location = original_turf
	RegisterSignal(parent, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/component/dream_echo/proc/handle_speech(mob/living/speaker, list/args)
	var/message = args[1]

	// Create cleaned message without prefixes
	var/cleaned_message = message
	if(copytext(cleaned_message, 1, 2) in GLOB.department_radio_prefixes)
		cleaned_message = copytext(cleaned_message, 3)

	// Remove leading space if present
	if(findtext_char(cleaned_message, " ", 1, 2))
		cleaned_message = copytext(cleaned_message, 2)

	original_location.audible_message(
		span_danger("<b>[speaker]</b> [speaker.verb_say], [span_italics("\"[cleaned_message]\"")]"),
		hearing_distance = 7
	)

/datum/component/dream_echo/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_SAY)
	return ..()

/datum/status_effect/dream_teleport
	id = "dream_teleport"
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dream_teleport
	var/turf/original_turf

/atom/movable/screen/alert/status_effect/debuff/dream_teleport
	name = "A strange place"
	desc = "The air feels humid, the floor cold and the void whispers to me. Where am I?"
	icon_state = "abyssal"

/datum/status_effect/dream_teleport/on_creation(mob/living/new_owner, turf/origin)
	. = ..()
	if(!.)
		return
	original_turf = origin

/datum/status_effect/dream_teleport/on_remove()
	return_from_dream(owner, original_turf)
	return ..()
