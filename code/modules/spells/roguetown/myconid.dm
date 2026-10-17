/obj/effect/proc_holder/spell/targeted/myconid_telepathy
	name = "Telepathy"
	desc = "Transmit a message to a single mind within 7 tiles, or to everyone within them."
	recharge_time = 0
	range = 7
	antimagic_allowed = TRUE
	action_icon = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "telepathy"

/obj/effect/proc_holder/spell/targeted/myconid_telepathy/can_target(mob/living/target)
	return iscarbon(target)

/obj/effect/proc_holder/spell/targeted/myconid_telepathy/choose_targets(mob/user = usr)
	var/list/possible_targets = list()
	for(var/mob/living/M in view_or_range(range, user, selection_type))
		if(M == user || !can_target(M))
			continue
		possible_targets += M
	if(!possible_targets.len)
		revert_cast(user)
		return
	var/list/choices = list("All")
	choices += sortNames(possible_targets)
	var/choice = tgui_input_list(user, "Choose a target.", name, choices)
	var/list/targets = list()
	if(!choice)
		revert_cast(user)
		return
	if(istext(choice))
		targets = possible_targets
	else if(isliving(choice))
		targets += choice
	if(!targets.len)
		revert_cast(user)
		return
	perform(targets, user = user)

/obj/effect/proc_holder/spell/targeted/myconid_telepathy/cast(list/targets, mob/user)
	if(!targets.len)
		return FALSE
	var/broadcast = targets.len > 1
	var/msg
	user.display_typing_indicator()
	if(broadcast)
		msg = stripped_input(user, "What do you wish to broadcast?", "Telepathy", "")
	else
		msg = stripped_input(user, "What do you wish to tell [targets[1]]?", "Telepathy", "")
	user.clear_typing_indicator()
	if(!msg)
		return FALSE
	if(broadcast)
		log_game("MYCONID TELEPATHY: [user.real_name] ([user.ckey]) broadcast \"[msg]\" to [targets.len] minds.")
		to_chat(user, span_boldnotice("You send your thoughts rippling outward:</span> <span class='notice'>[msg]"))
	else
		var/mob/living/chosen = targets[1]
		log_directed_talk(user, chosen, msg, LOG_SAY, "[name]")
		to_chat(user, span_boldnotice("You transmit to [chosen]:</span> <span class='notice'>[msg]"))
	for(var/mob/living/M in targets)
		if(M.anti_magic_check(FALSE, FALSE, TRUE, 0))
			continue
		if(broadcast)
			to_chat(M, span_boldnotice("A chorus of thoughts from [user] settles over your mind...</span> <span class='notice'>[msg]"))
		else
			to_chat(M, span_boldnotice("[user]'s echoing voice settles in the back of your mind...</span> <span class='notice'>[msg]"))
	var/ghost_suffix = broadcast ? "" : " to <span class='name'>[targets[1]]</span>"
	for(var/ded in GLOB.dead_mob_list)
		if(!isobserver(ded))
			continue
		to_chat(ded, "[FOLLOW_LINK(ded, user)] <span class='boldnotice'>[user] [name]:</span> <span class='notice'>\"[msg]\"[ghost_suffix]</span>")
	return TRUE
