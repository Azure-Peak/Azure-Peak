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
	if(!H || !length(H.stored_materials) && !length(H.prepared_boons))
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
		var/found_any = FALSE
		var/boon_html = "<br><span class='notice'><b>Manifestable Blessings:</b></span>"
		boon_html += "<details><summary><i>View Prepared Pacts</i></summary>"

		for(var/path in H.prepared_boons)
			var/amt = H.prepared_boons[path]
			if(amt <= 0)
				continue

			found_any = TRUE
			var/boon_name = initial(path:name)
			var/boon_desc = initial(path:desc)
			var/boon_points = initial(path:points)
			boon_html += "<details style='margin-left: 2px;'><summary><b>[boon_name]</b> ([amt]) - [boon_points] pts</summary><div style='margin-left: 10px; font-size: 0.9em;'>[boon_desc]</div></details>"

		if(!found_any)
			boon_html += span_info("- None ready.")

		boon_html += "</details>"
		. += boon_html

/obj/effect/proc_holder/spell/invoked/transmutation_rite/get_spell_statistics(mob/living/user)
	. = ..()
	. += "THE ART OF GIVING AND TAKING"
	. += "═══════════════════════════"
	. += "BOON CAPACITY:"
	. += "  • Tier 1: Up to 60 points of boons"
	. += "  • Tier 2: Up to 85 points of boons"
	. += "  • Tier 3: Up to 110 points of boons"
	. += ""
	. += "PROGRESSION:"
	. += "  • Curse 1 person → Tier 2 (Requires 20 points)"
	. += "  • Curse 2 people → Tier 3 (Requires 60 points total)"
	. += ""
	. += "AFFECTED TARGETS:"
	. += "  • Positive Boons: 4/5/6 people (scales with tier)"
	. += ""
	. += "Use this rite to view the boons that you have granted to allies,"
	. += "or twist your gifts into curses against your enemies."
	. += "<span class='notice'>Alt-click to reskin it.</span>"

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
	harms_undead = FALSE
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
	desc = "Weave the minds of up to three others into a shared coven with yourself. All participants communicate via ,m."
	invocation_type = "none"
	recharge_time = 4 MINUTES
	cost = 12
	var/link_duration = 20 MINUTES
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

	// Up to the same max amount of people as a tier 3 hag can bless.
	for(var/i in 1 to 5)
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
		to_chat(M, span_boldnotice("The Coven is formed! Linked minds: [roster]. Use ,Y to speak. Use ,mst to break the coven."))

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

/obj/effect/proc_holder/spell/invoked/take_name
	name = "Onomastic Siphon"
	desc = "Steals the target's name and identity, so long as they give it to you freely. It will become a boon you can bestow, at a cost of 20 points. Must be cast ONLY after you trick or convince the target into 'giving you' their name, even if only technically; for example, if they respond to 'May I have your name?' with just their name, that counts; but if they say 'You may call me XYZ', it doesn't. Has a check to prevent someone masked from giving you a fake name you have no way of knowing is fake, but otherwise, THE RESPONSIBILITY IS ON YOU TO USE THIS PROPERLY. Using this inappropriately will be considered bad faith and punished appropriately."
	invocation_type = "whisper"
	invocations = list("Give me all that you are.")
	recharge_time = 5 SECONDS
	range = 4
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_up"
	var/confirmed_read = FALSE
	var/list/not_part_of_names = list( // titles n such just in case people don't listen
		"dame",
		"ser",
		"lord",
		"lady",
		"of",
		"azure",
		"azuria",
	)

/obj/effect/proc_holder/spell/invoked/take_name/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H)
		to_chat(user, span_warning("How did you even get access to this without being a hag?"))
		return FALSE

	var/mob/living/carbon/human/victim = targets[1]
	if(!ishuman(victim))
		to_chat(user, span_warning("I need to cast this on a person!"))
		return FALSE

	if(user == victim)
		to_chat(user, span_warning("I can't take my own name!"))
		return FALSE

	if(!victim.client)
		to_chat(user, span_warning("They're not aware enough to give me their name!"))
		return FALSE

	if(!confirmed_read) // i know how you people are
		if(alert(user, "Have you read the description of this spell? It contains EXTREMELY important information about its use. Please, PLEASE read it, or you might do something rule-breaking.", "Confirmation", "Stop", "Proceed") != "Proceed")
			return FALSE
		confirmed_read = TRUE

	var/name2check = tgui_input_text(user, "What name did they give you? (Don't include titles; just the first or last name alone is fine, as long as it's what they gave you)", max_length=MAX_NAME_LEN, encode=FALSE) // we do not want html formatting to fuck up apostrophes and the like

	var/list/check_strings = splittext(name2check, regex(@"\b"))
	var/list/name_strings = splittext(victim.real_name, regex(@"\b"))
	var/found = FALSE
	for(var/substr in name_strings)
		if(length(substr)<=2)
			continue
		if(not_part_of_names.Find(substr))
			continue
		for(var/checkstr in check_strings)
			if(length(checkstr)<=2)
				continue
			if(not_part_of_names.Find(checkstr))
				continue
			if(checkstr == substr)
				to_chat(user, "")
				found = TRUE
				break
	if(!found)
		to_chat(user, span_warning("That's not the right name! They fooled me!"))
		return FALSE

	var/datum/hag_identity/ID = victim.make_hag_identity()

	H.stored_names[ID.name] = ID
	H.prepared_boons[/datum/hag_boon/name] = (H.prepared_boons[/datum/hag_boon/name] || 0) + 1
	victim.AddComponent(/datum/component/hag_name, new /datum/hag_identity())

	message_admins("NAMESTEAL: [user.real_name] ([user.ckey]) has stolen [victim.real_name] ([victim.ckey])'s name.")
	log_game("NAMESTEAL: [user.real_name] ([user.ckey]) has stolen [victim.real_name] ([victim.ckey])'s name.")

	to_chat(victim, span_boldwarning("What manner of trickery is this? My name... why can't I recall my name?!")) // let them know shit's gone down
	to_chat(user, span_danger("Their name is now mine... I can hoard it for my own use, or bestow it upon another."))
	return TRUE

/// doesn't make any changes to the mob, just creates a hag_identity datum from them
/mob/living/carbon/human/proc/make_hag_identity()
	return new /datum/hag_identity( // yoink
		real_name, voice_color,
		get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_TRAIT, mob_descriptors),
		get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_STATURE, mob_descriptors),
		get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE, mob_descriptors),
		custom_descriptors[12],
		custom_descriptors[10],
		custom_descriptors[9],
		HAS_TRAIT(src, TRAIT_NOBLE)
	)

/obj/effect/proc_holder/spell/invoked/possess_vessel
	name = "Take Vessel"
	desc = "Possess any vessel under your command, taking full control of their body. Your original body will lie dormant until you cast the spell again. The vessel's previous occupant will remain nearby, able to observe and communicate with you, but not act."
	recharge_time = 1 MINUTES
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_down"
	var/mob/living/carbon/human/original	// if this is null, we're in our original body. otherwise, it stores a ref to our original body
	var/datum/mind/vessel_orig_mind			// oh gods. oh fuck. this might go horribly wrong i hope it does not
	var/mob/dead/observer/eye/screye/displaced_soul/soul	// self explanatory

/obj/effect/proc_holder/spell/invoked/possess_vessel/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/HCT = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT || !ishuman(user))
		to_chat(user, span_warning("You lack the connection needed to take control of a vessel."))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!original) // we're casting this from our original body: possess a vessel.
		var/list/vessels = list()
		for(var/mob/living/carbon/human/candidate in GLOB.fey_vessels)
			if(GLOB.fey_vessels[candidate])
				vessels["[candidate.real_name] (Available)"] = candidate
			else
				vessels["[candidate.real_name] (Unavailable)"] = candidate
		var/mob/living/carbon/human/choice = vessels[tgui_input_list(user, "Which vessel to command?", "THE ROOTS CONNECT", vessels)]
		if(!choice)
			revert_cast()
			return FALSE
		if(!GLOB.fey_vessels[choice])
			to_chat(user, span_warning("That vessel is inaccessible to me, for now."))
			revert_cast()
			return FALSE
		original = H
		vessel_orig_mind = choice.mind
		vessel_orig_mind.current = null
		soul = H.possess_vessel(choice)
		if(!soul)
			revert_cast()
			return FALSE
		return TRUE
	// we're casting this from a vessel: restore them, and return to our original body
	release_vessel(H, HCT)
	return TRUE

/obj/effect/proc_holder/spell/invoked/possess_vessel/proc/release_vessel(mob/living/carbon/human/H, datum/component/hag_curio_tracker/HCT)
	GLOB.fey_vessels[H] = TRUE															// make them possessable again
	original.TakeComponent(HCT)															// transfer the hag curio tracker back
	H.mind.transfer_to(original) 														// then transfer the mind back
	H.custom_descriptors[9] = soul.original_identity.custom_voice 						// reset the vessel's voice to the non-possessed one
	H.remove_mob_descriptor(H.get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE))
	H.add_mob_descriptor(soul.original_identity.descriptor_voice)
	H.voice_color = soul.original_identity.name_color
	vessel_orig_mind.transfer_to(H)														// this should automatically set the key and thereby transfer the client - edit I WAS VERY WRONG
	H.key = soul.key																	// ????????
	QDEL_NULL(soul)
	original = null																		// reset the spell state
	vessel_orig_mind = null

/mob/living/carbon/human/proc/possess_vessel(mob/living/carbon/human/vessel)
	var/datum/component/hag_curio_tracker/HCT = GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT) // don't add this spell to nonhags kthxbye
		return FALSE
	if(!istype(vessel) || !vessel.key || vessel.GetComponent(/datum/component/hag_curio_tracker)) // you should never be able to possess other hags. lmao
		to_chat(src, span_warning("Invalid vessel!"))
		return FALSE
	if(!(vessel in GLOB.fey_vessels)) // shouldn't happen, but just in case there's an edge case
		to_chat(src, span_warning("They are not a vessel!"))
		return FALSE
	if(!GLOB.fey_vessels[vessel] || !vessel.mind || vessel.stat)
		to_chat(src, span_warning("They are beyond your grasp, for now at least.")) // they're probably sceneing. or they're SSD, or incapacitated
		return FALSE
	GLOB.fey_vessels[vessel] = FALSE // in case there are two hags somehow
	// before ANYTHING else we need to clear the mob's spells so the hag won't have access to them. they'll get re-added when the hag
	// goes back to their original body and the vessel's original mind transfers back in
	for(var/X in vessel.mind.spell_list)
		// New action-based spells ARE actions — grant them directly
		if(istype(X, /datum/action/cooldown/spell))
			var/datum/action/cooldown/spell/action_spell = X
			action_spell.Remove(vessel)
		// Old proc_holder spells have a separate action wrapper
		else if(istype(X, /obj/effect/proc_holder/spell))
			var/obj/effect/proc_holder/spell/S = X
			S.action?.Remove(vessel)
	// ok so here's how this works. first, we ghostize the vessel and force them to orbit their old body.
	// we store a copy of the things that change (voice color and descriptor) using the namesteal datum, then transfer over the hag's.
	// we also move the hag curio tracker to the vessel, and add all the hag spells, then transfer the hag player into the vessel
	// when the ghost mob talks, the hag hears it as a psychic message, but nobody else can. they also can't move around or stop orbiting
	// when the hag relinquishes control, we remove the hag spells, transfer the hag curio tracker back, reset the name and voice colors
	// then transfer the hag back into the original mob, then move the ghostmob back into the vessel. i sincerely hope nothing breaks in that.
	// update 2026-08-25: how very glib. things did, in fact, break in that.
	var/mob/dead/observer/eye/screye/displaced_soul/dsoul = make_observer(/mob/dead/observer/eye/screye/displaced_soul, FALSE)
	if(!dsoul)
		return FALSE
	dsoul.ManualFollow(vessel)
	dsoul.vessel = vessel
	dsoul.original_identity = vessel.make_hag_identity()
	dsoul.key = vessel.key
	// we've already archived the original identity, so it's safe to make destructive changes here. something something yuri
	vessel.voice_color = voice_color
	vessel.remove_mob_descriptor(vessel.get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE, vessel.mob_descriptors))
	vessel.add_mob_descriptor(get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE, mob_descriptors))
	vessel.custom_descriptors[9] = custom_descriptors[9] // this is the voice. i hate that custom descriptor code uses magic numbers
	mind.transfer_to(vessel)
	vessel.TakeComponent(HCT)
	return dsoul
