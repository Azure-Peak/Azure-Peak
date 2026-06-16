/obj/structure/roguemachine/ritual_rune
	name = "abyssal focal rune"
	desc = "A dark, engraved sigil etched into the floor. It hums with faint oceanic energy when near a dream pool."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssor_pool"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	/// The specific dream pool this rune has permanently bonded with
	var/obj/structure/roguemachine/dream_pool/linked_pool

/obj/structure/roguemachine/ritual_rune/proc/attempt_pool_link()
	if(linked_pool)
		return TRUE
	var/obj/structure/roguemachine/dream_pool/found_pool = locate() in range(5, src)
	if(found_pool)
		linked_pool = found_pool
		return TRUE
	return FALSE

/obj/structure/roguemachine/ritual_rune/attack_hand(mob/user, params)
	MiddleClick(user, params)

/obj/structure/roguemachine/ritual_rune/MiddleClick(mob/user, params)
	if(!ishuman(user) || user.stat == DEAD || user.stat == UNCONSCIOUS)
		return ..()
	if(!linked_pool)
		if(attempt_pool_link())
			to_chat(user, span_purple("The rune flares to life, establishing a permanent link with a nearby dream pool!"))
		else
			to_chat(user, span_warning("The rune glows faintly but fails to locate a dream pool within 7 tiles to anchor its power."))
			return TRUE
	if(!user.Adjacent(src))
		to_chat(user, span_warning("You are too far away from the focal rune to channel through it."))
		return TRUE
	linked_pool.handle_ritual_start(user)
	return TRUE

/obj/structure/roguemachine/ritual_rune/examine(mob/user)
	. = ..()
	if(linked_pool)
		. += "\n<span class='purple'>It is attuned to a nearby dream pool.</span>"
	else
		. += "\n<span class='warning'>It lies completely dormant. It needs to be activated near a dream pool to get attuned.</span>"

/obj/structure/roguemachine/ritual_rune/Destroy()
	linked_pool = null
	return ..()

/obj/structure/roguemachine/ritual_rune/proc/populate_vision_quests()
	if(length(GLOB.all_vision_quests))
		return
	GLOB.all_vision_quests = list(
		new /datum/vision_quest/orthodox_hunt,
		new /datum/vision_quest/knight_challenge,
		new /datum/vision_quest/abyssor_follower,
	)

/obj/structure/roguemachine/ritual_rune/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/dream_material/parchment_silver))
		if(!linked_pool || linked_pool.linked_door?.gate_closed)
			to_chat(user, span_warning("The dream pool gate must be open to receive visions."))
			return
		var/tier = 1
		if(istype(I, /obj/item/dream_material/parchment_gold))
			tier = 2
		else if(istype(I, /obj/item/dream_material/parchment_dream))
			tier = 3
		attempt_vision_quest(user, tier, I)
		return
	return ..()

/obj/structure/roguemachine/ritual_rune/proc/attempt_vision_quest(mob/living/carbon/human/user, tier, obj/item/used_parchment)
	populate_vision_quests()

	var/list/tiered_quests = list()
	for(var/datum/vision_quest/Q in GLOB.all_vision_quests)
		if(Q.required_tier <= tier)
			tiered_quests += Q

	if(!length(tiered_quests))
		to_chat(user, span_warning("The pool shows only empty shadows. No vision is possible at this time."))
		return

	shuffle(tiered_quests)
	var/list/selected_quests = tiered_quests.Copy(1, min(4, length(tiered_quests) + 1))

	var/list/available_choices = list()
	for(var/datum/vision_quest/Q in selected_quests)
		var/mob/living/carbon/human/valid_target = find_valid_target_for_quest(Q, user)
		if(valid_target)
			available_choices += list(list("quest" = Q, "target" = valid_target))

	if(!length(available_choices))
		to_chat(user, span_warning("The visions are there, but no suitable targets exist in the waking world."))
		return

	var/list/choice_names = list()
	var/list/choice_map = list()
	for(var/entry in available_choices)
		var/datum/vision_quest/Q = entry["quest"]
		var/mob/target_mob = entry["target"]
		var/display = "[Q.name] (Target: [target_mob.real_name]) - [Q.description]"
		choice_names += display
		choice_map[display] = entry

	var/selected = tgui_input_list(user, "Choose a vision to pursue:", "The Dream Pool", choice_names)
	if(!selected || QDELETED(src) || QDELETED(user))
		return

	var/selected_entry = choice_map[selected]
	if(!selected_entry)
		return

	var/datum/vision_quest/chosen_quest = selected_entry["quest"]
	var/mob/living/carbon/human/chosen_target = selected_entry["target"]

	qdel(used_parchment)
	user.AddComponent(/datum/component/vision_quest_tracker, chosen_quest, chosen_target, src)

/obj/structure/roguemachine/ritual_rune/proc/find_valid_target_for_quest(datum/vision_quest/Q, mob/living/carbon/human/seeker)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H == seeker)
			continue
		if(H.stat == DEAD)
			continue
		if(!H.mind || !H.mind.assigned_role)
			continue
		if(Q.is_valid_target(H, seeker))
			return H

	// For debug purposes only
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H == seeker)
			continue
		if(H.stat == DEAD)
			continue
		if(!H.mind || !H.mind.assigned_role)
			continue
		if(Q.is_valid_target(H, seeker))
			return H
	return null
