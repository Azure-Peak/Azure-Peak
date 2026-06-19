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
	return GLOB.tgui_always_state // Or GLOB.default_state

/datum/tgui_module/vision_quest_selection/ui_data(mob/user)
	. = ..()
	.["choices"] = selection_data.choices
	return .

/datum/tgui_module/vision_quest_selection/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_quest")
			selection_data.selected_quest_id = params["quest_id"]
			selection_data.selected_reward_path = null
			selection_data.selected_bonus_path = null
			return TRUE
		
		if("select_reward")
			selection_data.selected_reward_path = params["reward_path"]
			return TRUE
		
		if("select_bonus")
			selection_data.selected_bonus_path = params["bonus_path"]
			return TRUE
		
		if("confirm_quest")
			var/quest_id = params["quest_id"]
			var/reward_path = params["reward_path"]
			var/bonus_path = params["bonus_path"]
			
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

			if(selection_data.parchment_used)
				qdel(selection_data.parchment_used)
			var/datum/component/vision_quest_tracker/existing = selection_data.user.GetComponent(/datum/component/vision_quest_tracker)
			if(existing)
				qdel(existing)

			selection_data.user.AddComponent(/datum/component/vision_quest_tracker, Q, target_mob, selection_data.source_rune, text2path(reward_path), text2path(bonus_path))

			// Close the UI properly
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
