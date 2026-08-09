/datum/tgui_module/vision_quest_selection
	var/datum/vision_quest_selection/selection_data
	var/name

/datum/tgui_module/vision_quest_selection/New(datum/vision_quest_selection/data)
	. = ..()
	selection_data = data
	src.name = "VisionQuestSelection"

/datum/tgui_module/vision_quest_selection/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VisionQuestSelection")
		ui.open()

/datum/tgui_module/vision_quest_selection/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/tgui_module/vision_quest_selection/ui_data(mob/user)
	. = ..()
	.["choices"] = selection_data.choices
	return .

/datum/tgui_module/vision_quest_selection/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("confirm_quest")
			var/quest_id = params["quest_id"]
			var/reward_path = params["reward_path"]
			var/selected_entry = null
			for(var/entry in selection_data.available_choices)
				var/datum/vision_quest/Q = entry["quest"]
				if("[Q.type]" == quest_id)
					selected_entry = entry
					break

			if(!selected_entry)
				to_chat(selection_data.user, span_warning("The vision has faded..."))
				return TRUE

			var/datum/vision_quest/Q = selected_entry["quest"]
			var/mob/target_mob = selected_entry["target"]
			var/bonus_path = selected_entry["bonus"]

			if(selection_data.parchment_used)
				qdel(selection_data.parchment_used)

			var/datum/component/vision_quest_tracker/existing = selection_data.user.GetComponent(/datum/component/vision_quest_tracker)
			if(existing)
				qdel(existing)
			selection_data.user.AddComponent(/datum/component/vision_quest_tracker, Q, target_mob, selection_data.source_rune, text2path(reward_path), bonus_path)
			selection_data.user.Sleeping(10 SECONDS)

			to_chat(selection_data.user, span_notice("<b>Your mind floods with a vision:</b> [Q.vision_text]"))
			if(selection_data.source_rune && selection_data.source_rune.cached_choices)
				var/tier_key = "[selection_data.selected_tier]"
				selection_data.source_rune.cached_choices -= tier_key
				if(!length(selection_data.source_rune.cached_choices))
					selection_data.source_rune.parchment_used = null

			ui.close()
			return TRUE

/datum/vision_quest_selection
	var/list/choices
	var/list/available_choices
	var/mob/living/carbon/human/user
	var/obj/structure/roguemachine/ritual_rune/source_rune
	var/obj/item/parchment_used
	var/selected_quest_id
	var/selected_reward_path
	var/selected_bonus_path
	var/selected_tier

/datum/tgui_module/vortex_ritual_selection
	var/obj/structure/roguemachine/dream_pool/pool
	var/mob/living/carbon/human/user
	var/name

/datum/tgui_module/vortex_ritual_selection/New(obj/structure/roguemachine/dream_pool/pool, mob/living/carbon/human/user)
	. = ..()
	src.pool = pool
	src.user = user
	src.name = "VortexRitualSelection"

/datum/tgui_module/vortex_ritual_selection/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VortexRitualSelection")
		ui.open()

/datum/tgui_module/vortex_ritual_selection/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/tgui_module/vortex_ritual_selection/ui_data(mob/user)
	. = list()
	var/list/ritual_choices = list()

	for(var/ritual_name in GLOB.abyssal_rituals)
		var/datum/abyssal_ritual/R = GLOB.abyssal_rituals[ritual_name]

		// Compile ingredient breakdown for React transparency
		var/list/ingredients_data = list()
		for(var/ing_type in R.required_ingredients)
			var/qty_needed = R.required_ingredients[ing_type]
			var/obj/item/dummy_item = initial(ing_type)
			ingredients_data += list(list(
				"name" = initial(dummy_item.name),
				"required" = qty_needed
			))

		ritual_choices += list(list(
			"id" = R.name,
			"name" = R.name,
			"desc" = R.desc || "A mysterious chant querying the void.",
			"channel_time" = R.base_channel_time / 10, // convert deciseconds to seconds
			"has_materials" = R.check_ingredients(pool),
			"ingredients" = ingredients_data
		))

	.["rituals"] = ritual_choices
	return .

/datum/tgui_module/vortex_ritual_selection/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("execute_ritual")
			var/ritual_id = params["ritual_id"]
			var/datum/abyssal_ritual/chosen_ritual = GLOB.abyssal_rituals[ritual_id]

			if(!pool || QDELETED(pool) || pool.ritual_active)
				return TRUE
			if(!user || QDELETED(user) || user.stat != CONSCIOUS)
				return TRUE

			if(!chosen_ritual)
				to_chat(user, span_warning("The chosen ritual configuration has dissolved back into the tide."))
				return TRUE

			if(user.get_skill_level(/datum/skill/magic/holy) < 1)
				to_chat(user, span_warning("You lack the holy proficiency required to initiate an abyssal ritual."))
				return TRUE
			if(!istype(user.patron, /datum/patron/divine/abyssor))
				to_chat(user, span_warning("Only a true follower of Abyssor can initiate this ritual."))
				return TRUE
			if(!chosen_ritual.check_ingredients(pool))
				to_chat(user, span_warning("The materials on the rim shifted! You no longer have the correct alignment for [chosen_ritual.name]."))
				return TRUE
			if(!chosen_ritual.can_commence_ritual(pool, user))
				return TRUE

			// Success, close interface and kick off loop
			ui.close()
			INVOKE_ASYNC(pool, /obj/structure/roguemachine/dream_pool/proc/coordinate_channeling_loop, user, chosen_ritual)
			return TRUE
