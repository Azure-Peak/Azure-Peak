/datum/component/hag_curio_tracker
	/// The world.time when the Hag was last resurrected by a heart.
	var/last_revive_time = -5 MINUTES
	/// Associative list: [True Name String] = [/datum/hag_boon]
	var/alist/boon_registry = list()
	/// Materials the hag currently has stored in their component.
	var/list/stored_materials = list()
	/// How many of each type of material hags can store, and which ones they can store
	var/static/list/material_limits = list(
		/obj/item/alch/hag_moss/sorrow = 5,
		/obj/item/alch/hag_moss/fury = 5,
		/obj/item/alch/hag_moss/mercy = 5,
		/obj/item/alch/hag_moss/grief = 5,
		/obj/item/alch/hag_moss/envy = 5,
		/obj/item/alch/hag_moss/lullaby = 5,
		/obj/item/alch/hag_moss/pride = 5,
		/obj/item/roguekey/hag = 1,
		/obj/item/leechtick = 3,
		/obj/item/leechtick_bloated = 3,
	)
	var/hag_tier = 1
	var/static/list/curse_registry = list(
		/datum/hag_boon/curse/rotting_touch = list("cost" = 1, "min_tier" = 1),
		/datum/hag_boon/buff/curse/choking_moss = list("cost" = 40, "min_tier" = 1),
		/datum/hag_boon/buff/curse/waterlogged = list("cost" = 25, "min_tier" = 1),
		/datum/hag_boon/buff/curse/slumber = list("cost" = 20, "min_tier" = 1),
		// Trait Curses - Tier 1 (1 - 50 points)
		/datum/hag_boon/trait/curse/ugly = list("cost" = 10, "min_tier" = 1),
		/datum/hag_boon/trait/curse/silver_weakness = list("cost" = 50, "min_tier" = 1),
		// Trait Curses - Tier 2 (51 - 75 points)
		/datum/hag_boon/trait/curse/no_run = list("cost" = 60, "min_tier" = 2),
		/datum/hag_boon/trait/curse/critical_weakness = list("cost" = 75, "min_tier" = 2),
		// Trait Curses - Tier 3 (76+ points)
		/datum/hag_boon/trait/curse/no_spells = list("cost" = 100, "min_tier" = 3),
		/datum/hag_boon/trait/curse/mute = list("cost" = 100, "min_tier" = 3),
		/datum/hag_boon/trait/curse/no_defense = list("cost" = 100, "min_tier" = 3)
	)
	/// List of boon paths the hag has pre-prepared: [boon_path] = quantity
	var/list/prepared_boons = list()

/datum/component/hag_curio_tracker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(src, COMSIG_STATUS_EFFECT_HAG_CURSE_CLEARED, PROC_REF(handle_curse_cleared))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(handle_death))
	GLOB.active_hags |= parent

	// Let's avoid lagging the server on round start.
	addtimer(CALLBACK(src, PROC_REF(recognize_fey)), 10 SECONDS)

/datum/component/hag_curio_tracker/Destroy()
	GLOB.active_hags -= parent
	return ..()

/datum/component/hag_curio_tracker/proc/recognize_fey()
	var/mob/living/hag_mob = parent
	if(!hag_mob || !hag_mob.mind)
		return

	var/found_any = FALSE
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(HAS_TRAIT(H, TRAIT_FEYTOUCHED))
			// The Hag mind learns about the vessel
			hag_mob.mind.i_know_person(H)
			if(H.mind)
				H.mind.i_know_person(hag_mob.mind)
			found_any = TRUE
	if(found_any)
		to_chat(hag_mob, span_boldnotice("As your eyes adjust to the emerald gloom, the threads of the Mossmother's older puppets become visible to you..."))

/datum/component/hag_curio_tracker/proc/grant_boon(true_name, boon_path = /datum/hag_boon, set_points)
	if(!true_name || !ispath(boon_path))
		return

	if(boon_registry[true_name])
		var/list/existing_boons = boon_registry[true_name]
		for(var/datum/hag_boon/existing in existing_boons)
			if(existing.type == boon_path)
				return // Already has this specific boon type
	else
		// First time victim, so we make a list for them AND add them to the hag's known mobs for mindlinking.
		boon_registry[true_name] = list()
		var/mob/living/hag_mob = parent
		var/mob/living/victim = find_target(true_name)
		if(hag_mob && hag_mob.mind && victim)
			hag_mob.mind.i_know_person(victim)

	var/datum/hag_boon/B = new boon_path(true_name, src, set_points)
	var/list/name_list = boon_registry[true_name]
	name_list += B

	return B

/datum/component/hag_curio_tracker/proc/find_boon_by_type(true_name, typepath)
	if(!boon_registry[true_name])
		return null
	var/list/B_list = boon_registry[true_name]
	for(var/datum/hag_boon/B in B_list)
		if(istype(B, typepath))
			return B
	return null

/datum/component/hag_curio_tracker/proc/receive_enchanted_item(mob/living/receiver, points = 1)
	var/t_name = receiver.real_name

	var/datum/hag_boon/item_debt/existing_debt = find_boon_by_type(t_name, /datum/hag_boon/item_debt)

	if(existing_debt)
		existing_debt.add_points(points)
		to_chat(parent, span_notice("The debt of [t_name] deepens. Their material pact now holds [existing_debt.points] points of power."))
	else
		// They don't have one, create a fresh one
		var/datum/hag_boon/item_debt/D = grant_boon(t_name, /datum/hag_boon/item_debt)
		if(D)
			D.add_points(points)
			to_chat(parent, span_notice("[t_name] has accepted your gift, unwittingly binding their name to a debt of [points] points."))

/datum/component/hag_curio_tracker/proc/handle_curse_cleared(datum/source, victim_name, curse_type)
	SIGNAL_HANDLER

	var/datum/hag_boon/curse/B = find_boon_by_type(victim_name, curse_type)
	if(B)
		to_chat(parent, span_danger("You feel like the [B.name] affecting [victim_name] was just cleared."))

		// Remove from registry
		var/list/name_list = boon_registry[victim_name]
		name_list -= B
		if(!length(name_list))
			boon_registry -= victim_name
		qdel(B)

/datum/component/hag_curio_tracker/proc/get_limit(obj/item/I)
	for(var/path in material_limits)
		if(istype(I, path))
			return material_limits[path]
	return 0

/datum/component/hag_curio_tracker/proc/absorb_item(obj/item/I)
	var/limit = get_limit(I)
	if(!limit)
		return FALSE

	var/current = stored_materials[I.type] || 0
	if(current >= limit)
		return FALSE

	stored_materials[I.type] = current + 1
	qdel(I)
	return TRUE

/datum/component/hag_curio_tracker/proc/dump_materials(turf/T)
	if(!length(stored_materials))
		return FALSE

	var/total_dumped = 0
	var/max_dump = 10

	for(var/path in stored_materials)
		while(stored_materials[path] > 0 && total_dumped < max_dump)
			new path(T)
			stored_materials[path]--
			total_dumped++

		if(total_dumped >= max_dump)
			break

	return total_dumped > 0

/datum/component/hag_curio_tracker/proc/get_available_curses_data()
	var/list/data = list()
	for(var/path in curse_registry)
		var/list/details = curse_registry[path]
		if(details["min_tier"] > hag_tier)
			continue
		data += list(list(
			"name" = initial(path:name),
			"path" = "[path]",
			"cost" = details["cost"],
			"min_tier" = details["min_tier"]
		))
	return data

/datum/component/hag_curio_tracker/proc/transmute_boons_to_curse(true_name, list/boons, curse_path, points)
	var/list/name_list = boon_registry[true_name]
	for(var/datum/hag_boon/B in boons)
		name_list -= B
		qdel(B)

	var/datum/hag_boon/curse/C = new curse_path(true_name, src, points)
	name_list += C

	var/datum/hag_boon/curse_scar/scar = find_boon_by_type(true_name, /datum/hag_boon/curse_scar)
	if(scar)
		scar.points += points
	else
		var/mob/living/victim = find_target(true_name)
		if(victim)
			ADD_TRAIT(victim, TRAIT_CURSE_SCAR, "hag_curse")
		scar = new /datum/hag_boon/curse_scar(true_name, src, points)
		name_list += scar
	check_tier_upgrade()

/datum/component/hag_curio_tracker/proc/check_tier_upgrade()
	var/scar_60_count = 0
	var/has_scar_20 = FALSE

	for(var/t_name in boon_registry)
		var/datum/hag_boon/curse_scar/S = find_boon_by_type(t_name, /datum/hag_boon/curse_scar)
		if(!S)
			continue
		if(S.points >= 60)
			scar_60_count++
		if(S.points >= 20)
			has_scar_20 = TRUE

	if(hag_tier == 1 && has_scar_20)
		hag_tier = 2
		to_chat(parent, span_boldnotice("Your connection to the Mossmother's roots deepens. You have reached Tier 2."))

	if(hag_tier == 2 && scar_60_count >= 2)
		hag_tier = 3
		to_chat(parent, span_boldnotice("The Mossmother sees you. You have reached Tier 3."))

/datum/component/hag_curio_tracker/proc/find_target(true_name)
	// Less heavy of a check than in boons itself.
	// Don't use this proc if the player's mind is in question...
	for(var/mob/living/L in GLOB.player_list)
		if(L.real_name == true_name)
			return L
	for(var/mob/living/L in GLOB.mob_living_list)
		if(L.real_name == true_name)
			return L
	return null

/datum/component/hag_curio_tracker/proc/can_grant_boon(boon_path)
	if(!prepared_boons[boon_path] || prepared_boons[boon_path] <= 0)
		return FALSE
	return TRUE

/datum/component/hag_curio_tracker/proc/user_can_receive_boon(boon_path, name_to_check)
	if(find_boon_by_type(name_to_check, boon_path))
		to_chat(parent, span_warning("[name_to_check] already carries this pact!"))
		return FALSE

	var/mob/living/L = find_target(name_to_check)
	if(L && !antag_check(L))
		to_chat(parent, span_warning("[name_to_check] can't hold your ancient magycks, they are already blessed by another force."))
		return FALSE

	var/active_victims = 0
	for(var/v_name in boon_registry)
		var/has_real_boon = FALSE
		for(var/datum/hag_boon/B in boon_registry[v_name])
			// If they have a valid hag boon that IS NOT a curse and IS NOT a scar
			if(B.hag_is_valid && !B.hag_curse && !istype(B, /datum/hag_boon/curse_scar))
				has_real_boon = TRUE
				break
		
		if(has_real_boon)
			active_victims++

	var/max_victims
	var/max_points
	switch(hag_tier)
		if(1)
			max_victims = 4
			max_points = 60
		if(2)
			max_victims = 5
			max_points = 85
		else
			max_victims = 6
			max_points = 110

	// Only block if we are trying to boon a NEW person and we're at the limit
	// We check if the target currently has a real boon.
	var/target_has_boon = FALSE
	if(boon_registry[name_to_check])
		for(var/datum/hag_boon/B in boon_registry[name_to_check])
			if(B.hag_is_valid && !B.hag_curse && !istype(B, /datum/hag_boon/curse_scar))
				target_has_boon = TRUE
				break

	if(!target_has_boon && active_victims >= max_victims)
		to_chat(parent, span_warning("Your spirit cannot tether more than [max_victims] blessed souls at this tier."))
		return FALSE

	// --- Individual Point/Trait Logic ---
	var/current_total_points = 0
	var/trait_boon_count = 0
	
	if(boon_registry[name_to_check])
		for(var/datum/hag_boon/B in boon_registry[name_to_check])
			if(!B.hag_is_valid || !B.hag_curse)
				continue
			
			// Scars and Curses STILL count toward the soul's total capacity (max_points)
			current_total_points += B.points
			
			// Only count traits for the 3-trait limit
			if(B.hag_trait)
				trait_boon_count++

	var/datum/hag_boon/checking = boon_path
	if(initial(checking.hag_trait) && trait_boon_count >= 3)
		to_chat(parent, span_warning("[name_to_check]'s body cannot withstand more than 3 trait-altering boons!"))
		return FALSE

	// Individual capacity check
	var/new_boon_points = initial(checking.points)
	if((current_total_points + new_boon_points) > max_points)
		to_chat(parent, span_warning("This blessing is too heavy. [name_to_check] only has room for [max_points - current_total_points] more points of power."))
		return FALSE

	// Spell check
	if(ispath(boon_path, /datum/hag_boon/spell))
		if(L && L.mind)
			var/datum/hag_boon/spell/spell_boon_path = boon_path
			var/target_spell_type = initial(spell_boon_path.spell_type)
			for(var/obj/effect/proc_holder/spell/S in L.mind.spell_list)
				if(S.type == target_spell_type)
					to_chat(parent, span_warning("[name_to_check] already possesses the knowledge this boon would grant."))
					return FALSE
					
	return TRUE

/datum/component/hag_curio_tracker/proc/antag_check(mob/living/carbon/C)
	if(!C.mind)
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/gnoll))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/hag))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/skeleton))
		return FALSE
	if(HAS_TRAIT(C, TRAIT_FEYTOUCHED))
		return FALSE
	return TRUE

/datum/component/hag_curio_tracker/proc/consume_prepared_boon(boon_path)
	if(!can_grant_boon(boon_path))
		return FALSE
	prepared_boons[boon_path]--
	return TRUE

/datum/component/hag_curio_tracker/proc/absorb_enchanted_moss(obj/item/alch/hag_moss/enchanted/M)
	if(!M.boon_path)
		return FALSE

	prepared_boons[M.boon_path] = (prepared_boons[M.boon_path] || 0) + 1

	to_chat(parent, span_notice("The [M] dissolves into your spirit, preparing a blessing of [initial(M.boon_path:name)]."))
	qdel(M)
	return TRUE

/datum/component/hag_curio_tracker/proc/hag_teleport_check()
	if(world.time < last_revive_time + 5 MINUTES)
		return FALSE
	return TRUE

/datum/component/hag_curio_tracker/proc/handle_death(mob/living/carbon/L)
	SIGNAL_HANDLER

	L.visible_message(span_boldnotice("The corpse of [L.name] starts to dissolve into the soil"))
	addtimer(CALLBACK(src, PROC_REF(move_hag), L), 10 SECONDS)

/datum/component/hag_curio_tracker/proc/move_hag(mob/living/L)
	if(!length(GLOB.hag_hearts))
		ADD_TRAIT(L, TRAIT_DNR, "hag_final_death")
		L.visible_message(span_danger("The roots that once sustained [L.name] wither and turn to ash! There is no sanctuary for the hag left."))
		to_chat(L, span_userdanger("Your connection to the Mossmother's hearts has been severed. This is the end."))
		var/mob/living/simple_animal/hostile/retaliate/rogue/hag_shapeshift/S = new(get_turf(L))
		S.death()
		playsound(L, 'sound/hag/hag_cackles.ogg', 100, TRUE)
		execute_final_spite()
		return

	var/obj/structure/roguemachine/hag_heart/heart = pick(GLOB.hag_hearts)
	var/turf/heart_turf = get_turf(heart)
	if(!heart_turf)
		return

	to_chat(L, span_userdanger("Death's cold grip is denied by the Mossmother's roots! The heart prepares to revive you."))
	L.forceMove(heart_turf)
	addtimer(CALLBACK(src, PROC_REF(revive_hag), L), 90 SECONDS)

/datum/component/hag_curio_tracker/proc/revive_hag(mob/living/L)
	L.grab_ghost(force = TRUE)
	L.revive(full_heal = TRUE, admin_revive = FALSE)
	playsound(L, 'sound/magic/slimesquish.ogg', 100, TRUE)
	last_revive_time = world.time

/datum/component/hag_curio_tracker/proc/execute_final_spite()
	for(var/t_name in boon_registry)
		var/datum/hag_boon/curse_scar/S = find_boon_by_type(t_name, /datum/hag_boon/curse_scar)
		var/list/name_list = boon_registry[t_name]

		if(S && S.points > 10)
			for(var/datum/hag_boon/curse/C in name_list)
				// boons clean themselves up when qdel'd
				var/mob/living/L = find_target(t_name)
				if(L)
					to_chat(L, span_notice("The heavy weight of your curse lifts as a distant, pained shriek echoes in your mind."))
				qdel(C)

		// If you've got no scars or real curses, you've betrayed the hag's pact. Enjoy being cursed.
		else
			var/mob/living/victim = find_target(t_name)
			if(!victim)
				continue
			to_chat(victim, span_userdanger("With her dying breath, the Hag weaves a final, spiteful knot into your soul!"))
			// Filter curses that cost more than 10
			var/list/valid_curses = list()
			for(var/path in curse_registry)
				var/list/details = curse_registry[path]
				if(details["cost"] > 10)
					valid_curses += path

			if(!length(valid_curses))
				continue
			// Give 2 random curses
			for(var/i in 1 to 2)
				var/curse_path = pick(valid_curses)
				grant_boon(t_name, curse_path, 100)
