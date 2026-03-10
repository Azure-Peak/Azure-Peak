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

/obj/effect/proc_holder/spell/self/learnspell/proc/legacy_pointbuy_spells(mob/user)
	var/list/choices = list()
	var/list/spell_descriptions = list()
	var/user_spell_tier = get_user_spell_tier(user)
	var/user_evil = get_user_evilness(user)
	var/list/spell_choices = GLOB.learnable_spells

	for(var/i = 1, i <= spell_choices.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = spell_choices[i]
		if(spell_item.spell_tier > user_spell_tier)
			continue
		if(spell_item.zizo_spell > user_evil)
			continue
		var/display_key = "[spell_item.name]: [spell_item.cost]"
		choices[display_key] = spell_item
		if(spell_item.desc)
			spell_descriptions[display_key] = spell_item.desc

	choices = sortList(choices)

	var/choice = tgui_input_list(user, "Choose a spell. Points left: [user.mind.spell_points - user.mind.used_spell_points]", "Learn Spell", choices, descriptions = spell_descriptions)
	var/obj/effect/proc_holder/spell/item = choices[choice]

	if(!item)
		return
	if(tgui_alert(user, "Learn [item.name] for [item.cost] point(s)?", "[item.name]", list("Cancel", "Learn")) == "Cancel")
		return
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == item.type)
			to_chat(user, span_warning("You already know this one!"))
			return
	if(item.cost > user.mind.spell_points - user.mind.used_spell_points)
		to_chat(user, span_warning("You do not have enough experience to create a new spell."))
		return
	user.mind.used_spell_points += item.cost
	var/obj/effect/proc_holder/spell/new_spell = new item
	new_spell.refundable = TRUE
	user.mind.AddSpell(new_spell)
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

	for(var/i = 1, i <= pool_spells.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = pool_spells[i]
		if(spell_item.spell_tier > user_spell_tier)
			continue
		if(spell_item.cost > remaining)
			continue
		var/already_known = FALSE
		for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
			if(knownspell.type == spell_item.type)
				already_known = TRUE
				break
		if(already_known)
			continue
		var/display_key = "[spell_item.name]: [spell_item.cost]"
		choices[display_key] = spell_item
		if(spell_item.desc)
			spell_descriptions[display_key] = spell_item.desc

	if(!length(choices))
		to_chat(user, span_warning("No spells available to learn."))
		return

	choices = sortList(choices)

	var/choice = tgui_input_list(user, "[capitalize(pool_name)] spells. Points left: [remaining]", "Learn Spell", choices, descriptions = spell_descriptions)
	var/obj/effect/proc_holder/spell/item = choices[choice]

	if(!item)
		return
	if(tgui_alert(user, "Learn [item.name] for [item.cost] point(s)?", "[item.name]", list("Cancel", "Learn")) == "Cancel")
		return

	user.mind.spell_points_used_by_pool[pool_name] += item.cost
	var/obj/effect/proc_holder/spell/new_spell = new item
	new_spell.refundable = TRUE
	new_spell.learned_from_pool = pool_name
	user.mind.AddSpell(new_spell)
	addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
	return TRUE
