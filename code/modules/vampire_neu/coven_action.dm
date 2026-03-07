/datum/action/coven
	check_flags = NONE
	background_icon_state = "spell" //And this is the state for the background icon
	button_icon_state = "coven" //And this is the state for the action icon
	button_icon = 'icons/mob/actions/vampspells.dmi'
	icon_icon = 'icons/mob/actions/vampspells.dmi'

	var/level_icon_state = "1" //And this is the state for the action icon
	var/datum/coven/coven
	var/targeting = FALSE
	var/active = FALSE

/datum/action/coven/New(target, datum/coven/coven)
	. = ..()
	src.coven = coven
	coven.coven_action = src

/datum/action/coven/Grant(mob/M)
	. = ..()
	coven.assign(M)

	register_to_availability_signals()

/datum/action/coven/proc/register_to_availability_signals()
	//this should only go through if it's the first Coven gained by the mob
	for (var/datum/action/action in owner.actions)
		if (action == src)
			continue
		if (istype(action, /datum/action/coven))
			return

	//irrelevant for NPCs
	if (!owner.client)
		return

	var/list/relevant_signals = list(
		SIGNAL_ADDTRAIT(TRAIT_TORPOR),
		SIGNAL_REMOVETRAIT(TRAIT_TORPOR),
		COMSIG_LIVING_STATUS_KNOCKDOWN,
		COMSIG_LIVING_STATUS_UNCONSCIOUS,
		COMSIG_LIVING_STATUS_IMMOBILIZE,
		COMSIG_LIVING_STATUS_PARALYZE,
		SIGNAL_ADDTRAIT(TRAIT_BLIND),
		SIGNAL_REMOVETRAIT(TRAIT_BLIND),
		SIGNAL_ADDTRAIT(TRAIT_MUTE),
		SIGNAL_REMOVETRAIT(TRAIT_MUTE),
		SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED),
		SIGNAL_REMOVETRAIT(TRAIT_HANDS_BLOCKED),
		SIGNAL_ADDTRAIT(TRAIT_PACIFISM),
		SIGNAL_REMOVETRAIT(TRAIT_PACIFISM),
	)

	RegisterSignal(owner, relevant_signals, PROC_REF(update_mob_buttons))

/datum/action/coven/proc/update_mob_buttons()
	owner.update_action_buttons()

/datum/action/coven/UpdateButtonIcon(status_only, force)
	button.icon = icon_icon
	if(coven)
		name = coven.current_power.name
		button.name = name
		desc = coven.current_power.desc
		button.desc = desc
		button_icon_state = coven.icon_state
		background_icon_state = "[initial(background_icon_state)][active]"
		button.icon_state = background_icon_state
		overlay_state = "[coven.level_casting]"
	else
		button_icon_state = initial(button_icon_state)
		background_icon_state = "[initial(background_icon_state)][active]"
		button.icon_state = background_icon_state
		overlay_state = initial(overlay_state)
	ApplyIcon(button, TRUE)

	if(!IsAvailable())
		button.update_maptext(coven.current_power.get_cooldown())
	else
		button.update_maptext(0)

/datum/action/coven/IsAvailable()
	return coven.current_power.can_activate_untargeted()

/datum/action/coven/Trigger(trigger_flags)
	. = ..()

	UpdateButtonIcon()

	//easy de-targeting
	if (targeting)
		end_targeting()
		. = FALSE
		return .

	//cancel targeting of other Covens when one is activated
	for (var/datum/action/action in owner.actions)
		if (istype(action, /datum/action/coven))
			var/datum/action/coven/other_coven = action
			other_coven.end_targeting()

	//ensure it's actually possible to trigger this
	if (!coven?.current_power || !isliving(owner))
		. = FALSE
		return .

	var/datum/coven_power/power = coven.current_power
	if (power.active) //deactivation logic
		if (power.cancelable || power.toggled)
			power.try_deactivate(direct = TRUE, alert = TRUE)
			active = FALSE
		else
			to_chat(owner, span_warning("[power] is already active!"))
	else //activate
		if (power.target_type == NONE) //self activation
			if(power.try_activate())
				active = TRUE
		else //ranged targeted activation
			begin_targeting()
			active = TRUE

	UpdateButtonIcon()

	return .


/datum/action/coven/proc/switch_level(to_advance = 1)
	if(coven.level_casting + to_advance > length(coven.known_powers))
		coven.level_casting = 1
	else if(coven.level_casting + to_advance < 1)
		coven.level_casting = length(coven.known_powers)
	else
		coven.level_casting += to_advance

	if(targeting)
		end_targeting()

	coven.current_power = coven.known_powers[coven.level_casting]
	UpdateButtonIcon()

/datum/action/coven/proc/end_targeting()
	var/client/client = owner?.client
	if (!client)
		return
	if (!targeting)
		return

	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	targeting = FALSE
	active = FALSE
	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
	UpdateButtonIcon()

/datum/action/coven/proc/handle_click(mob/source, atom/target, click_parameters)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(click_parameters)

	//ensure we actually need a target, or cancel on right click
	if (!targeting || modifiers["right"])
		end_targeting()
		return

	//actually try to use the Coven on the target
	spawn()
		if (coven.current_power.try_activate(target))
			end_targeting()

	return COMSIG_MOB_CANCEL_CLICKON

/datum/action/coven/proc/begin_targeting()
	var/client/client = owner?.client
	if (!client)
		return
	if (targeting)
		return
	if (!coven.current_power.can_activate_untargeted(TRUE))
		return
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(handle_click))
	//client.mouse_pointer_icon = 'icons/effects/mousemice/charge/spell_charged.dmi'
	targeting = TRUE

/atom/movable/screen/movable/action_button/Click(location, control, params)
	if(istype(linked_action, /datum/action/coven))
		var/list/modifiers = params2list(params)

		//increase on right click, decrease on shift right click
		if(LAZYACCESS(modifiers, "right"))
			var/datum/action/coven/coven = linked_action
			usr.playsound_local(usr, 'sound/misc/click.ogg', 100)
			if(LAZYACCESS(modifiers, "alt"))
				coven.switch_level(-1)
			else
				coven.switch_level(1)
			return
		//TODO: middle click to swap loadout
	. = ..()
