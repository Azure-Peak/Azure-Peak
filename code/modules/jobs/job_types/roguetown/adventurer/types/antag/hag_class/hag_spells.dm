/obj/effect/proc_holder/spell/invoked/spiritual_siphon
	name = "Spiritual Siphon"
	desc = "Absorbs mosses and select components into your spirit, or manifests up to five stored items onto the ground."
	invocation_type = "whisper"
	invocations = list("Bloom inside.")
	recharge_time = 5 SECONDS
	range = 1
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_lux"

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
		// Check for enchanted moss first
		if(istype(I, /obj/item/alch/hag_moss/enchanted))
			if(H.absorb_enchanted_moss(I))
				absorbed_any = TRUE
		// Otherwise, standard material absorption
		else if(H.absorb_item(I))
			absorbed_any = TRUE

	if(absorbed_any)
		to_chat(user, span_notice("The mosses dissolve into your spirit."))
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
	if(length(H.prepared_boons))
		. += "<br><span class='notice'><b>Manifestable Blessings:</b></span>"
		var/found_any = FALSE
		for(var/path in H.prepared_boons)
			if(H.prepared_boons[path] > 0)
				. += span_info("- [initial(path:name)]: [H.prepared_boons[path]]")
				found_any = TRUE
		if(!found_any)
			. += span_info("- None ready.")

/obj/effect/proc_holder/spell/invoked/transmutation_rite
	name = "Transmutation"
	//var/mob/living/target_victim
	var/list/selected_boons = list()
	var/selected_curse_path = null
	var/active_victim_name = null
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_up"

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
	if(!H)
		return FALSE
	
	var/list/victims_data = list()
	for(var/t_name in H.boon_registry)
		var/list/boons = list()
		for(var/datum/hag_boon/B in H.boon_registry[t_name])
			boons += list(list(
				"id" = "[B.type]",
				"victim_name" = t_name, // Added so UI knows where it belongs
				"name" = B.name,
				"points" = B.points,
				"selected" = (B in selected_boons),
				"transmutable" = B.transmutable
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
	// to_chat(ui.user, "DEBUG: Action [action] received. Params: [json_encode(params)]")
	// to_chat(world, "DEBUG: Action [action] received. Params: [json_encode(params)]")
	
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
					return TRUE
		
		if("select_curse")
			selected_curse_path = params["path"]
			return TRUE

		if("commit_transmutation")
			if(!active_victim_name || !selected_curse_path || !selected_boons.len)
				return TRUE

			var/points_gathered = calculate_current_points()
			var/curse_cost = 999
			var/list/curses = H.get_available_curses_data()
			for(var/list/C in curses)
				if(C["path"] == selected_curse_path)
					curse_cost = C["cost"]
					break

			if(points_gathered < curse_cost)
				to_chat(user, span_warning("The soul-tithe is insufficient. You require [curse_cost] points, but have only gathered [points_gathered]."))
				return TRUE

			H.transmute_boons_to_curse(active_victim_name, selected_boons, selected_curse_path, points_gathered)

			selected_boons.Cut()
			selected_curse_path = null
			active_victim_name = null
			return TRUE
	return ..()

/obj/effect/proc_holder/spell/invoked/transmutation_rite/proc/calculate_current_points()
	var/points = 0
	for(var/datum/hag_boon/B in selected_boons)
		points += B.points
	return points

/obj/effect/proc_holder/spell/invoked/grant_boon
	name = "Manifest Boon"
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_lux"

/obj/effect/proc_holder/spell/invoked/grant_boon/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H || !length(H.prepared_boons))
		to_chat(user, span_warning("You have no prepared blessings to manifest."))
		return FALSE

	var/list/options = list()
	for(var/path in H.prepared_boons)
		if(H.prepared_boons[path] > 0)
			options[initial(path:name)] = path

	if(!length(options))
		to_chat(user, span_warning("You have no prepared blessings with enough essence to manifest."))
		return FALSE

	var/choice = input(user, "Which blessing do you wish to manifest?", "Manifestation") as null|anything in options
	if(!choice) return FALSE

	var/path = options[choice]
	var/default_points = initial(path:points)

	// Spawn the physical blessing item
	var/obj/item/hag_blessing_item/B = new(user.loc)
	B.name = "[choice] blessing"
	B.AddComponent(/datum/component/hag_boon_manifestation, path, default_points)

	user.put_in_hands(B)
	to_chat(user, span_notice("You pull a sliver of [choice] from your spirit."))
	return TRUE

/obj/effect/proc_holder/spell/invoked/resurrect/hag
	name = "Thorny Regrowth"
	desc = "Knit a fallen soul back into a body using parasitic vines. The target is revived, but incurs a 50-point debt to your Curio."
	recharge_time = 10 MINUTES 
	sound = 'sound/hag/hag_cackles.ogg'
	required_structure = /obj/structure/roguemachine/mossmother
	required_items = list()
	req_items = list()
	alt_required_items = list()
	miracle = FALSE
	devotion_cost = 0
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_revive"

	var/boon_path = /datum/hag_boon/revival_debt

/obj/effect/proc_holder/spell/invoked/resurrect/hag/cast(list/targets, mob/living/carbon/human/user)
	. = ..()

	if(.)
		var/mob/living/carbon/human/target = targets[1]
		if(!istype(target))
			return FALSE

		var/datum/component/hag_curio_tracker/HCT = user.GetComponent(/datum/component/hag_curio_tracker)
		if(HCT)
			HCT.grant_boon(target.real_name, boon_path, 50)
			to_chat(user, span_notice("You've tethered [target.real_name] to your garden. Their life is now your currency."))
	return TRUE

/datum/hag_boon/revival_debt
	name = "Soul Tether"
	desc = "A portion of your vitality is bound to the Hag who pulled you from the brink."
	points = 50

/obj/effect/proc_holder/spell/invoked/mindlink/hag
	name = "Coven Link"
	desc = "Weave the minds of up to three others into a shared coven with yourself. All participants communicate via ,y."
	invocation_type = "none"
	recharge_time = 4 MINUTES
	cost = 12
	var/link_duration = 5 MINUTES
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_down"

/obj/effect/proc_holder/spell/invoked/mindlink/hag/cast(list/targets, mob/living/user)
	var/list/possible = user.mind.known_people.Copy()
	var/list/mob/living/carbon/human/coven_members = list(user)

	if(!possible.len)
		to_chat(user, span_warning("I have no puppets to bind to my web."))
		revert_cast()
		return FALSE

	for(var/i in 1 to 3)
		var/prompt = "Choose member #[i] to bind (Cancel to finalize coven with [coven_members.len] members)"
		var/target_name = tgui_input_list(user, prompt, "Coven Link", sort_list(possible))

		if(!target_name)
			break

		var/mob/living/carbon/human/found_mob
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.real_name == target_name)
				found_mob = HL
				break

		if(found_mob)
			var/already_linked = FALSE
			for(var/datum/mindlink/coven/ML in GLOB.mindlinks)
				if(found_mob in ML.members)
					already_linked = TRUE
					break
			
			if(already_linked)
				to_chat(user, span_warning("[found_mob.real_name]'s mind is already bound by another thread! I cannot reach them."))
				continue

			coven_members += found_mob
			possible -= target_name 
		
		if(!possible.len)
			break

	if(coven_members.len < 2)
		to_chat(user, span_warning("A coven of one is just a lonely old woman. I need at least one other."))
		revert_cast()
		return FALSE

	user.visible_message(span_warning("[user]'s fingers twitch as if pulling invisible strings..."), \
						 span_notice("I have woven the coven web between [coven_members.len] souls."))

	var/datum/mindlink/coven/C = new(coven_members)
	GLOB.mindlinks += C

	var/list/names = list()
	for(var/mob/living/M in coven_members)
		names += M.real_name
	var/roster = names.Join(", ")

	for(var/mob/living/M in coven_members)
		to_chat(M, span_boldnotice("The Coven is formed! Linked minds: [roster]. Use ,y to speak."))

	addtimer(CALLBACK(src, PROC_REF(break_coven), C), link_duration)
	return TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/hag/proc/break_coven(datum/mindlink/coven/C)
	if(!C)
		return
	for(var/mob/living/M in C.members)
		if(M)
			to_chat(M, span_warning("The coven web snaps and withers..."))
	GLOB.mindlinks -= C
	qdel(C)
