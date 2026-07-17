/obj/structure/roguemachine/dream_pool
	name = "dream pool"
	desc = ""
	icon = 'icons/obj/structures/abyssor_pool.dmi'
	icon_state = "whirl"
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -32
	pixel_y = -32
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	var/obj/structure/dream_pool_door/linked_door
	/// Tracks if a group ritual is actively processing right now
	var/ritual_active = FALSE

/obj/structure/roguemachine/dream_pool/Initialize(mapload)
	. = ..()
	linked_door = new /obj/structure/dream_pool_door(get_turf(src))
	linked_door.linked_pool = src
	update_icon()

/obj/structure/roguemachine/dream_pool/proc/get_outer_rim_turfs()
	var/list/turf/outer_rim = list()
	var/turf/center = get_turf(src)
	if(!center)
		return outer_rim
	for(var/turf/T in range(2, center))
		if(get_dist(center, T) == 2)
			outer_rim += T
	return outer_rim

/obj/structure/roguemachine/dream_pool/examine(mob/user)
	. = ..()
	if(linked_door?.gate_closed)
		. += "\n<span class='notice'>Incredibly heavy, rusty doors obscure the contents of this elaborate metallic indentation. It looks very old.</span>"
	else
		. += "\n<span class='notice'>The gate doors have retracted. A swirling vortex bombards you with imagery of a strange realm. Just looking into it makes you dizzy, best not to stare... Especially as something gazes back from beneath the surface.</span>"

/obj/structure/roguemachine/dream_pool/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(linked_door)
		linked_door.attack_hand(user, modifiers)

/obj/structure/dream_pool_door
	name = "dream pool door"
	desc = ""
	icon = 'icons/obj/structures/abyssor_pool.dmi'
	icon_state = "door"
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -32
	pixel_y = -32
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/gate_closed = TRUE
	var/animating = FALSE
	var/obj/structure/roguemachine/dream_pool/linked_pool
	var/mutable_appearance/frame_overlay

/obj/structure/dream_pool_door/Initialize(mapload)
	. = ..()
	frame_overlay = mutable_appearance(icon, "frame")
	update_icon()

/obj/structure/dream_pool_door/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(animating)
		to_chat(user, span_warning("The gate mechanism is currently operating!"))
		return
	if(gate_closed)
		open_gate(user)
	else
		close_gate(user)

/obj/structure/dream_pool_door/proc/open_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("[src]'s heavy frame groans as the portal lock turns."))
	flick("door_opening", src)
	addtimer(CALLBACK(src, PROC_REF(finish_open_gate)), 50)

/obj/structure/dream_pool_door/proc/close_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("The frame clangs as the pool doors begin sliding back into place."))
	flick("door_closing", src)
	addtimer(CALLBACK(src, PROC_REF(finish_close_gate)), 50)

/obj/structure/dream_pool_door/proc/finish_open_gate()
	gate_closed = FALSE
	animating = FALSE
	icon_state = null
	visible_message(span_purple("With a heavy hiss, the dream pool's gate slides fully open!"))
	update_icon()
	playsound(src, 'sound/foley/lever.ogg', 100)

/obj/structure/dream_pool_door/proc/finish_close_gate()
	gate_closed = TRUE
	animating = FALSE
	icon_state = "door"
	visible_message(span_notice("[src]'s rusty seal locks tightly into place."))
	update_icon()
	playsound(src, 'sound/foley/lever.ogg', 100)

/obj/structure/dream_pool_door/update_overlays()
	. = ..()
	if(frame_overlay)
		. += frame_overlay

/obj/structure/dream_pool_door/Destroy()
	if(linked_pool)
		linked_pool.linked_door = null
		linked_pool = null
	return ..()

/obj/structure/roguemachine/dream_pool/proc/handle_ritual_start(mob/living/carbon/human/user)
	if(!linked_door || linked_door.gate_closed)
		to_chat(user, span_warning("The dream pool's gate must be wide open to harness the abyss!"))
		return
	if(ritual_active)
		to_chat(user, span_warning("The pool is already fluctuating with a ritualistic current!"))
		return
	if(!length(GLOB.abyssal_rituals))
		initialize_abyssal_rituals()

	var/list/selectable_menu = list()
	var/list/display_to_ritual = list()
	for(var/ritual_name in GLOB.abyssal_rituals)
		var/datum/abyssal_ritual/R = GLOB.abyssal_rituals[ritual_name]
		var/menu_line = "\n[R.name] - Requires: "
		if(length(R.required_ingredients))
			var/list/ing_strings = list()
			for(var/ing_type in R.required_ingredients)
				var/qty = R.required_ingredients[ing_type]
				var/obj/item/dummy = initial(ing_type:name)
				ing_strings += "[qty]x [dummy]"
			menu_line += jointext(ing_strings, ", ")
		else
			menu_line += "No external offerings"
		var/has_mats = R.check_ingredients(src)
		if(has_mats)
			menu_line = "\[READY\] [menu_line]"
		else
			menu_line = "\[MISSING MATERIALS\] [menu_line]"
		selectable_menu += menu_line
		display_to_ritual[menu_line] = R

	var/choice = tgui_input_list(user, "Select an abyssal ritual to execute via the vortex:", "Vortex Ritual Chamber", selectable_menu)

	if(!choice || QDELETED(src) || QDELETED(user) || user.stat != CONSCIOUS)
		return
	var/datum/abyssal_ritual/chosen_ritual = display_to_ritual[choice]
	if(!chosen_ritual)
		return

	if(user.get_skill_level(/datum/skill/magic/holy) < 1)
		to_chat(user, span_warning("You lack the holy proficiency required to initiate an abyssal ritual."))
		return FALSE
	if(!istype(user.patron, /datum/patron/divine/abyssor))
		to_chat(user, span_warning("Only a true follower of Abyssor can initiate this ritual."))
		return FALSE
	if(!chosen_ritual.check_ingredients(src))
		to_chat(user, span_warning("You do not have the required materials arrayed on the outer rim for [chosen_ritual.name]!"))
		return

	INVOKE_ASYNC(src, PROC_REF(coordinate_channeling_loop), user, chosen_ritual)

/obj/structure/roguemachine/dream_pool/proc/coordinate_channeling_loop(mob/living/carbon/human/leader, datum/abyssal_ritual/R)
	ritual_active = TRUE
	visible_message(span_purple("[leader] begins chanting, calling upon the abyssal currents…"))

	var/duration = R.base_channel_time
	var/list/turf/outer_rim = get_outer_rim_turfs()
	var/list/mob/living/active_channelers
	var/list/datum/beam/active_beams

	var/list/invocations = list(
		"Abyssor, hwja'ajaba!",
		"Iä! Iä! Abyssor fhtagn!",
		"The deep rises to my call!",
		"By the salt and the tide, awaken!"
	)
	var/phases = invocations.len
	var/phase_time = duration / phases

	playsound(src, 'sound/magic/teleport_diss.ogg', 100, TRUE)

	for(var/phase in 1 to phases)
		active_channelers = list(leader)
		for(var/mob/living/carbon/human/M in range(2, src))
			if(M == leader || M.stat != CONSCIOUS)
				continue
			if(get_turf(M) in outer_rim)
				active_channelers += M

		if(!active_channelers.len)
			visible_message(span_warning("No one remains to channel the ritual! It collapses."))
			collapse_ritual()
			return

		var/phase_invocation = invocations[phase] || "Abyssor, hwja'ajaba!"
		for(var/mob/living/P in active_channelers)
			P.say(phase_invocation, language = /datum/language/abyssal, ignore_spam = TRUE)

		active_beams = list()
		var/turf/pool_turf = get_turf(src)
		for(var/mob/living/P in active_channelers)
			active_beams += pool_turf.Beam(P, icon_state = "b_beam", time = phase_time, maxdistance = 10)

		var/drain_per_phase = 15
		for(var/mob/living/P in active_channelers)
			if(P.energy)
				P.energy_add(-drain_per_phase)

		if(!do_after(leader, phase_time, target = src, extra_checks = CALLBACK(src, PROC_REF(channel_check), leader, outer_rim)))
			to_chat(leader, span_warning("Your connection falters! The ritual is interrupted."))
			for(var/datum/beam/B in active_beams)
				B.End()
			collapse_ritual()
			return

		for(var/datum/beam/B in active_beams)
			B.End()

		if(linked_door?.gate_closed || !R.check_ingredients(src))
			visible_message(span_warning("The pool's configuration changed mid‑ritual! The abyss recoils."))
			collapse_ritual()
			return

	var/list/mob/living/final_channelers = list()
	for(var/mob/living/M in range(2, src))
		if(M.stat == CONSCIOUS && (get_turf(M) in outer_rim))
			final_channelers += M

	R.consume_ingredients(src, final_channelers)
	R.on_success(src, leader, final_channelers)
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 100, TRUE)
	ritual_active = FALSE

/obj/structure/roguemachine/dream_pool/proc/collapse_ritual()
	ritual_active = FALSE
	playsound(src, 'sound/misc/slip.ogg', 100, TRUE)

/obj/structure/roguemachine/dream_pool/proc/channel_check(mob/living/carbon/human/leader, list/turf/outer_rim)
	if(QDELETED(leader) || leader.stat != CONSCIOUS)
		return FALSE
	return (get_turf(leader) in outer_rim)
