/obj/effect/proc_holder/spell/self/learnspell
	name = "Attempt to learn a new spell"
	desc = "Weave a new spell"
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0
	skipcharge = TRUE

/obj/effect/proc_holder/spell/self/learnspell/cast(list/targets, mob/user = usr)
	. = ..()
	if(!user.mind)
		return
	// Pool-based system always takes priority to prevent unexpected spell point sources from bypassing pool restrictions
	if(LAZYLEN(user.mind.spell_point_pools))
		return class_based_spells(user)
	return legacy_pointbuy_spells(user)

/// Get the spell cost from a typepath (works for both old proc_holder and new action spells)
/obj/effect/proc_holder/spell/self/learnspell/proc/get_spell_cost(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.point_cost)
	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.cost)

/// Get the spell tier from a typepath (works for both types)
/obj/effect/proc_holder/spell/self/learnspell/proc/get_spell_tier(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.spell_tier)
	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.spell_tier)

/// Get the spell name from a typepath
/obj/effect/proc_holder/spell/self/learnspell/proc/get_spell_name(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.name)
	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.name)

/// Get the spell desc from a typepath
/obj/effect/proc_holder/spell/self/learnspell/proc/get_spell_desc(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.desc)
	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.desc)

/// Get the zizo_spell flag from a typepath
/obj/effect/proc_holder/spell/self/learnspell/proc/get_spell_zizo(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.zizo_spell)
	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.zizo_spell)

/// Check if user already knows a spell by typepath (checks both spell systems)
/obj/effect/proc_holder/spell/self/learnspell/proc/user_knows_spell(mob/user, spell_path)
	for(var/datum/known in user.mind.spell_list)
		if(known.type == spell_path)
			return TRUE
	return FALSE

/// Instantiate and add a spell from a typepath (handles both types)
/obj/effect/proc_holder/spell/self/learnspell/proc/learn_spell_from_path(mob/user, spell_path, pool_name = null)
	var/datum/new_spell = new spell_path

	if(istype(new_spell, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/action_spell = new_spell
		action_spell.refundable = TRUE
		if(pool_name)
			action_spell.learned_from_pool = pool_name
	else if(istype(new_spell, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/proc_spell = new_spell
		proc_spell.refundable = TRUE
		if(pool_name)
			proc_spell.learned_from_pool = pool_name

	user.mind.AddSpell(new_spell)
	return TRUE

/obj/effect/proc_holder/spell/self/learnspell/proc/legacy_pointbuy_spells(mob/user)
	var/list/choices = list()
	var/list/spell_descriptions = list()
	var/user_spell_tier = get_user_spell_tier(user)
	var/user_evil = get_user_evilness(user)
	var/list/spell_choices = GLOB.learnable_spells

	for(var/spell_path in spell_choices)
		var/tier = get_spell_tier(spell_path)
		if(tier > user_spell_tier)
			continue
		var/zizo = get_spell_zizo(spell_path)
		if(zizo > user_evil)
			continue
		var/spell_name = get_spell_name(spell_path)
		var/cost = get_spell_cost(spell_path)
		var/display_key = "[spell_name]: [cost]"
		choices[display_key] = spell_path
		var/spell_desc = get_spell_desc(spell_path)
		if(spell_desc)
			spell_descriptions[display_key] = spell_desc

	choices = sortList(choices)

	var/choice = tgui_input_list(user, "Choose a spell. Points left: [user.mind.spell_points - user.mind.used_spell_points]", "Learn Spell", choices, descriptions = spell_descriptions)
	var/chosen_path = choices[choice]

	if(!chosen_path)
		return
	var/chosen_name = get_spell_name(chosen_path)
	var/chosen_cost = get_spell_cost(chosen_path)
	if(tgui_alert(user, "Learn [chosen_name] for [chosen_cost] point(s)?", "[chosen_name]", list("Cancel", "Learn")) == "Cancel")
		return
	if(user_knows_spell(user, chosen_path))
		to_chat(user, span_warning("You already know this one!"))
		return
	if(chosen_cost > user.mind.spell_points - user.mind.used_spell_points)
		to_chat(user, span_warning("You do not have enough experience to create a new spell."))
		return
	user.mind.used_spell_points += chosen_cost
	learn_spell_from_path(user, chosen_path)
	addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/self/learnspell/proc/class_based_spells(mob/user)
	var/list/available_pools = list()
	for(var/pool_name in user.mind.spell_point_pools)
		var/max_pts = user.mind.spell_point_pools[pool_name]
		var/used_pts = user.mind.spell_points_used_by_pool?[pool_name] || 0
		if(used_pts < max_pts)
			available_pools["[capitalize(pool_name)] ([max_pts - used_pts] pts)"] = pool_name

	if(!length(available_pools))
		to_chat(user, span_warning("No spell points remaining."))
		return

	var/chosen_pool_display
	if(length(available_pools) == 1)
		chosen_pool_display = available_pools[1]
	else
		chosen_pool_display = tgui_input_list(user, "Choose a spell school.", "Learn Spell", available_pools)
	if(!chosen_pool_display)
		return

	var/pool_name = available_pools[chosen_pool_display]
	var/max_pts = user.mind.spell_point_pools[pool_name]
	var/used_pts = user.mind.spell_points_used_by_pool?[pool_name] || 0
	var/remaining = max_pts - used_pts

	var/list/pool_spells = get_spell_pool_list(pool_name)
	var/user_spell_tier = get_user_spell_tier(user)
	var/list/choices = list()
	var/list/spell_descriptions = list()

	for(var/spell_path in pool_spells)
		var/tier = get_spell_tier(spell_path)
		if(tier > user_spell_tier)
			continue
		var/cost = get_spell_cost(spell_path)
		if(cost > remaining)
			continue
		if(user_knows_spell(user, spell_path))
			continue
		var/spell_name = get_spell_name(spell_path)
		var/display_key = "[spell_name]: [cost]"
		choices[display_key] = spell_path
		var/spell_desc = get_spell_desc(spell_path)
		if(spell_desc)
			spell_descriptions[display_key] = spell_desc

	if(!length(choices))
		to_chat(user, span_warning("No spells available to learn."))
		return

	choices = sortList(choices)

	var/choice = tgui_input_list(user, "[capitalize(pool_name)] spells. Points left: [remaining]", "Learn Spell", choices, descriptions = spell_descriptions)
	var/chosen_path = choices[choice]

	if(!chosen_path)
		return
	var/chosen_name = get_spell_name(chosen_path)
	var/chosen_cost = get_spell_cost(chosen_path)
	if(tgui_alert(user, "Learn [chosen_name] for [chosen_cost] point(s)?", "[chosen_name]", list("Cancel", "Learn")) == "Cancel")
		return

	user.mind.spell_points_used_by_pool[pool_name] += chosen_cost
	learn_spell_from_path(user, chosen_path, pool_name)
	addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
	return TRUE
