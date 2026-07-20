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
	// Holds the current user's session data: list(list("quest" = Q, "target" = T, "bonus" = B))
	var/list/cached_choices
	// Tracks the parchment item used to initialize the current batch of choices
	var/obj/item/parchment_used

/obj/structure/roguemachine/ritual_rune/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Abyssorites with miracle skill can start rituals here.")
	. += span_info("Anyone with paint affinity, or abyssorites with miracle skill can receive visions here. Requires silver, gold, or dream parchment to do so.")
	. += span_info("Visions yield materials that are used to channel rituals.")
	. += span_info("In order to complete a vision, a specific phrase must be said whilst very close to the vision target.")
	. += span_info("Visions induce a sleeping dream, you will receive a brief glimpse of the target.")
	. += span_info("Everyone on the direct edge of the dream pool can join rituals, but only those with novice+ holy skill can help gain ritual discounts.")
	. += span_info("Some rituals affect everyone nearby. The more valid participants, the more materials might get discounted.")

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
	cached_choices = null
	parchment_used = null
	return ..()

/obj/structure/roguemachine/ritual_rune/proc/populate_vision_quests()
	if(length(GLOB.all_vision_quests))
		return
	GLOB.all_vision_quests = list()
	for(var/quest_type in subtypesof(/datum/vision_quest))
		GLOB.all_vision_quests += new quest_type()

/obj/structure/roguemachine/ritual_rune/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/dream_material))
		return ..()

	if(!linked_pool)
		attempt_pool_link()

	if(!linked_pool || linked_pool.linked_door?.gate_closed)
		to_chat(user, span_warning("The dream pool gate must be open to receive visions."))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!(H.patron?.type == /datum/patron/divine/abyssor) && !HAS_TRAIT(H, TRAIT_INK_AFFINITY))
			to_chat(user, span_warning("You must have some connection to Abyssor or His paints to call forth visions."))
			return

	var/tier = 0
	if(istype(I, /obj/item/dream_material/parchment_silver))
		tier = 1
	else if(istype(I, /obj/item/dream_material/parchment_gold))
		tier = 2
	else if(istype(I, /obj/item/dream_material/parchment_dream))
		tier = 3
	else
		to_chat(user, span_warning("The rune doesn't recognize this material."))
		return

	if(tier <= 0)
		to_chat(user, span_warning("This parchment doesn't seem powerful enough."))
		return

	attempt_vision_quest(user, tier, I)

/obj/structure/roguemachine/ritual_rune/proc/attempt_vision_quest(mob/living/carbon/human/user, tier, obj/item/used_parchment)
	populate_vision_quests()

	var/datum/component/vision_quest_tracker/existing_quest = user.GetComponent(/datum/component/vision_quest_tracker)
	if(existing_quest)
		var/response = tgui_alert(user, "You already have a vision. Override it?", "Vision Active", list("Yes", "No"))
		if(response != "Yes")
			return

	if(!cached_choices)
		cached_choices = list()

	var/tier_key = "[tier]"
	var/list/tier_choices = cached_choices[tier_key]

	if(!tier_choices)
		tier_choices = list()
		cached_choices[tier_key] = tier_choices

	if(length(tier_choices) < 3)
		var/list/existing_types = list()
		for(var/entry in tier_choices)
			var/datum/vision_quest/Q = entry["quest"]
			existing_types += Q.type
		var/list/available = list()
		for(var/datum/vision_quest/Q in GLOB.all_vision_quests)
			if(Q.required_tier == tier && !(Q.type in existing_types))
				available += Q
		if(length(available))
			shuffle(available)
			var/needed = 3 - length(tier_choices)
			for(var/i in 1 to min(needed, length(available)))
				var/datum/vision_quest/Q = available[i]
				var/mob/living/carbon/human/valid_target = find_valid_target_for_quest(Q, user)
				if(!valid_target)
					continue
				Q.required_phrase = pick(Q.possible_phrases)
				var/chosen_bonus_path = pick(Q.possible_bonus_rewards)
				tier_choices += list(list(
					"quest" = Q,
					"target" = valid_target,
					"bonus" = chosen_bonus_path
				))

		if(!length(tier_choices))
			var/list/tiered_quests = list()
			for(var/datum/vision_quest/Q in GLOB.all_vision_quests)
				if(Q.required_tier == tier)
					tiered_quests += Q

			if(!length(tiered_quests))
				to_chat(user, span_warning("The pool shows only empty shadows. No vision is possible at this tier."))
				return

			shuffle(tiered_quests)
			for(var/datum/vision_quest/Q in tiered_quests)
				var/mob/living/carbon/human/valid_target = find_valid_target_for_quest(Q, user)
				if(!valid_target)
					continue

				Q.required_phrase = pick(Q.possible_phrases)
				var/chosen_bonus_path = pick(Q.possible_bonus_rewards)

				tier_choices += list(list(
					"quest" = Q,
					"target" = valid_target,
					"bonus" = chosen_bonus_path
				))
				if(length(tier_choices) >= 3)
					break

		cached_choices[tier_key] = tier_choices
		src.parchment_used = used_parchment

	for(var/entry in tier_choices)
		var/datum/vision_quest/Q = entry["quest"]
		var/mob/living/carbon/human/target_mob = entry["target"]

		if(!target_mob || target_mob.stat == DEAD || !(target_mob in GLOB.human_list))
			var/mob/living/carbon/human/new_target = find_valid_target_for_quest(Q, user)
			if(new_target)
				entry["target"] = new_target
			else
				tier_choices -= list(entry)

	if(!length(tier_choices))
		to_chat(user, span_warning("The visions for this tier are there, but no suitable targets exist in the waking world."))
		cached_choices -= tier_key
		if(!length(cached_choices))
			src.parchment_used = null
		return

	open_quest_selection_ui(user, tier_choices, src.parchment_used, tier)

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
	// for(var/mob/living/carbon/human/H in GLOB.human_list)
	// 	if(H == seeker)
	// 		continue
	// 	if(H.stat == DEAD)
	// 		continue
	// 	if(!H.mind || !H.mind.assigned_role)
	// 		continue
	// 	if(Q.is_valid_target(H, seeker))
	// 		return H
	return null

/obj/structure/roguemachine/ritual_rune/proc/open_quest_selection_ui(mob/living/carbon/human/user, list/available_choices, used_parchment, tier)
	var/list/display_data = list()
	for(var/entry in available_choices)
		var/datum/vision_quest/Q = entry["quest"]
		var/mob/target_mob = entry["target"]
		var/bonus_path = entry["bonus"]
		var/list/reward_options = list()
		for(var/reward_path in Q.possible_rewards)
			reward_options += list(list(
				"path" = "[reward_path]",
				"name" = Q.possible_rewards[reward_path]
			))

		var/bonus_name = Q.possible_bonus_rewards[bonus_path]

		display_data += list(list(
			"id" = "[Q.type]",
			"name" = Q.name,
			"summary" = Q.summary,
			"description" = Q.description,
			"target_name" = target_mob.real_name,
			"target_description" = Q.target_description,
			"required_tier" = Q.required_tier,
			"rewards" = reward_options,
			"bonus_reward_name" = bonus_name
		))

	var/datum/vision_quest_selection/selection = new()
	selection.choices = display_data
	selection.available_choices = available_choices
	selection.user = user
	selection.source_rune = src
	selection.parchment_used = used_parchment
	selection.selected_tier = tier

	var/datum/tgui_module/vision_quest_selection/module = new(selection)
	module.ui_interact(user)
