/obj/effect/proc_holder/spell/invoked/spiritual_siphon
	name = "Spiritual Siphon"
	desc = "Absorbs mosses and select components into your spirit, or manifests up to five stored items onto the ground."
	invocation_type = "whisper"
	invocations = list("Bloom inside.")
	recharge_time = 5 SECONDS
	range = 1

/obj/effect/proc_holder/spell/invoked/spiritual_siphon/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H)
		to_chat(user, span_warning("Your soul lacks the hollow spaces required to store these blossoms."))
		return FALSE

	var/atom/target = targets[1]
	var/turf/T = get_turf(target)

	// Prioritize absorption if there are items on the floor
	var/absorbed_any = FALSE
	for(var/obj/item/I in T)
		if(H.absorb_item(I))
			absorbed_any = TRUE

	if(absorbed_any)
		to_chat(user, span_notice("The mosses dissolve into your shadow."))
		playsound(T, 'sound/magic/magnet.ogg', 50, TRUE)
		return TRUE

	// If nothing was absorbed, try to dump
	if(H.dump_materials(T))
		to_chat(user, span_notice("You manifest a handful of stored components."))
		playsound(T, 'sound/magic/slimesquish.ogg', 50, TRUE)
		return TRUE
	else
		to_chat(user, span_warning("You have nothing stored to manifest."))
		return FALSE

/obj/effect/proc_holder/spell/invoked/spiritual_siphon/get_spell_statistics(mob/living/user)
	. = ..() 

	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H || !length(H.stored_materials))
		. += span_info("Spiritual Veil: Empty")
		return

	. += "<br><span class='notice'><b>Spiritual Veil Contents:</b></span>"
	for(var/path in H.stored_materials)
		var/count = H.stored_materials[path]
		if(count > 0)
			var/name = initial(path:name)
			// Show usage/capacity: e.g., "Sorrow Moss: 4/10"
			var/limit = H.material_limits[path] || "?"
			. += span_info("- [name]: [count]/[limit]")

/obj/effect/proc_holder/spell/invoked/transmutation_rite
	name = "Transmutation"
	//var/mob/living/target_victim
	var/list/selected_boons = list()
	var/selected_curse_path = null
	var/active_victim_name = null

/obj/effect/proc_holder/spell/invoked/transmutation_rite/cast(list/targets, mob/living/user)
	// Capture user so UI actions know who the "Hag" is
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H) return FALSE

	if(!H || !length(H.boon_registry))
		to_chat(user, span_warning("You have no souls bound to your spirit."))
		return FALSE

	ui_interact(user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_state(mob/user)
	return GLOB.always_state

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HagTransmutation", "Rite of Transmutation")
		ui.open()

/obj/effect/proc_holder/spell/invoked/transmutation_rite/proc/toggle_boon_selection(boon_type_string)
	var/datum/component/hag_curio_tracker/H = ranged_ability_user.GetComponent(/datum/component/hag_curio_tracker)
	var/list/registry = H.boon_registry[active_victim_name]
	
	for(var/datum/hag_boon/B in registry)
		if("[B.type]" == boon_type_string)
			if(B in selected_boons)
				selected_boons -= B
			else
				selected_boons += B
			break

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_data(mob/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	
	var/list/victims_data = list()
	for(var/t_name in H.boon_registry)
		var/list/boons = list()
		for(var/datum/hag_boon/B in H.boon_registry[t_name])
			boons += list(list(
				"id" = "[B.type]",
				"victim_name" = t_name, // Added so UI knows where it belongs
				"name" = B.name,
				"points" = B.points,
				"selected" = (B in selected_boons)
			))
		
		victims_data += list(list(
			"name" = t_name,
			"boons" = boons
		))
		
	return list(
		"victims" = victims_data,
		"curse_options" = H.get_available_curses_data(),
		"total_points" = calculate_current_points(),
		"hag_tier" = H.hag_tier,
		"selected_curse_path" = selected_curse_path
	)

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	to_chat(ui.user, "DEBUG: Action [action] received. Params: [json_encode(params)]")
	to_chat(world, "DEBUG: Action [action] received. Params: [json_encode(params)]")
	
	var/mob/living/user = ui.user
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)

	switch(action)
		if("toggle_boon")
			var/boon_id = params["id"]
			var/v_name = params["victim_name"]
			
			if(active_victim_name != v_name)
				selected_boons.Cut()
				active_victim_name = v_name
			
			var/list/registry = H.boon_registry[v_name]
			for(var/datum/hag_boon/B in registry)
				if("[B.type]" == boon_id)
					if(B in selected_boons)
						selected_boons -= B
						if(!selected_boons.len) active_victim_name = null
					else
						selected_boons += B
					return TRUE // THIS IS CRITICAL FOR REFRESH
		
		if("select_curse")
			selected_curse_path = params["path"]
			return TRUE // THIS IS CRITICAL FOR REFRESH

		if("commit_transmutation")
			H.transmute_boons_to_curse(active_victim_name, selected_boons, selected_curse_path, calculate_current_points())
			// ... (Your existing commit logic)
			return TRUE

	return ..()

/obj/effect/proc_holder/spell/invoked/transmutation_rite/proc/calculate_current_points()
	var/points = 0
	for(var/datum/hag_boon/B in selected_boons)
		points += B.points
	return points
