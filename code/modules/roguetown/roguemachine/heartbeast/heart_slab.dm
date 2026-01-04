/obj/structure/roguemachine/chimeric_slab
	name = "Chimeric Echo Slab"
	desc = "A specialized interface for accessing fundamental Tier 1 chimeric knowledge."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "blackrot1"
	density = FALSE
	anchored = TRUE
	pixel_y = 32

/obj/structure/roguemachine/chimeric_slab/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/roguemachine/chimeric_slab/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChimericTechWeb", "Echo Knowledge Base")
		ui.open()

/obj/structure/roguemachine/chimeric_slab/ui_data(mob/user)
	. = list()

	var/current_points = SSchimeric_tech.echo_points
	.["points"] = current_points
	.["tier"] = 1

	// Get ONLY echoes (Tier 1) from the subsystem
	var/list/echo_choices = SSchimeric_tech.get_available_choices(1, current_points, 3, 2)

	var/list/choices_data = list()
	for(var/datum/chimeric_tech_node/N in echo_choices)
		UNTYPED_LIST_ADD(choices_data, list(
			"name" = N.name,
			"desc" = N.description,
			"cost" = N.cost,
			"path" = N.string_id,
			"required_tier" = 1,
			"can_afford" = current_points >= N.cost,
		))

	.["choices"] = choices_data

	var/list/unlocked_data = list()
	for(var/string_id in SSchimeric_tech.all_tech_nodes)
		var/datum/chimeric_tech_node/N = SSchimeric_tech.all_tech_nodes[string_id]
		if(N.unlocked)
			UNTYPED_LIST_ADD(unlocked_data, list(
				"name" = N.name,
				"desc" = N.description,
				"tier" = N.required_tier,
			))
	.["unlocked"] = unlocked_data

	return .

/obj/structure/roguemachine/chimeric_slab/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return

	var/mob/user = ui.user

	switch(action)
		if("unlock_node")
			var/string_id = params["path"]
			var/datum/chimeric_tech_node/node = SSchimeric_tech.all_tech_nodes[string_id]
			if(!node) return

			// Check subsystem echo points instead of heartbeast
			if(SSchimeric_tech.echo_points < node.cost)
				to_chat(user, "Insufficient Echo Points.")
				return TRUE

			SSchimeric_tech.echo_points -= node.cost
			node.unlocked = TRUE

			SSchimeric_tech.clear_cached_choices(2)

			to_chat(user, "Successfully harmonized with [node.name].")
			return TRUE
