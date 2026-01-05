/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB


/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R")
	classic_keys = list("R") // END
	name = "toggle_throw_mode"
	full_name = "Toggle throw mode"
	description = "Toggle throwing the current item or not."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode()
	return TRUE

//****** Base Intents ******

/datum/keybinding/carbon/intent_one
	hotkey_keys = list("1")
	name = "intent_one"
	full_name = "Cycle Intent Slot 1"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_one/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(1)
/*	if(C.active_hand_index == 2)
		if(C.swap_hand(1))
			C.rog_intent_change(1)
	else
		if(C.l_index == 1)
			C.rog_intent_change(3)
		else
			C.rog_intent_change(1)*/

	return TRUE

/datum/keybinding/carbon/intent_two
	hotkey_keys = list("2")
	name = "intent_two"
	full_name = "Cycle Intent Slot 2"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_two/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(2)
	return TRUE

/datum/keybinding/carbon/intent_three
	hotkey_keys = list("3")
	name = "intent_three"
	full_name = "Cycle Intent Slot 3"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_three/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(3)
	return TRUE

/datum/keybinding/carbon/intent_four
	hotkey_keys = list("4")
	name = "intent_four"
	full_name = "Cycle Intent Slot 4"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_four/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(4)
	return TRUE

//****** Quad Intents ******
/*
/datum/keybinding/carbon/give_intent
	hotkey_keys = list("G")
	name = "intent_give"
	full_name = "Select Give Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/give_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_GIVE)
	return TRUE*/

/datum/keybinding/carbon/bite_intent
	hotkey_keys = list("H")
	name = "intent_bite"
	full_name = "Select Bite Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/bite_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_BITE)
	return TRUE

/datum/keybinding/carbon/jump_intent
	hotkey_keys = list("J")
	name = "intent_jump"
	full_name = "Select Jump Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/jump_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP)
	return TRUE

/datum/keybinding/carbon/kick_intent
	hotkey_keys = list("K")
	name = "intent_kick"
	full_name = "Select Kick Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/kick_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_KICK)
	return TRUE

/datum/keybinding/carbon/special_intent
	hotkey_keys = list("L")
	name = "intent_special"
	full_name = "Select Special Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/special_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_SPECIAL)
	return TRUE

/*

/datum/keybinding/carbon/select_help_intent
	hotkey_keys = null
	name = "select_help_intent"
	full_name = "Select help intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_help_intent/down(client/user)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HELP)
	return TRUE


/datum/keybinding/carbon/select_disarm_intent
	hotkey_keys = null
	name = "select_disarm_intent"
	full_name = "Select disarm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_disarm_intent/down(client/user)
	user.mob?.a_intent_change(INTENT_DISARM)
	return TRUE


/datum/keybinding/carbon/select_grab_intent
	hotkey_keys = null
	name = "select_grab_intent"
	full_name = "Select grab intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_grab_intent/down(client/user)
	user.mob?.a_intent_change(INTENT_GRAB)
	return TRUE


/datum/keybinding/carbon/select_harm_intent
	hotkey_keys = null
	name = "select_harm_intent"
	full_name = "Select harm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_harm_intent/down(client/user)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HARM)
	return TRUE
*/

//****** RMB Intents ******

/datum/keybinding/carbon/rmb_intent_1
    hotkey_keys = list("Shift1")
    name = "rmb_intent_1"
    full_name = "Select Feint Stance"
    description = "Selects the Feint RMB stance."
    category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_1/down(client/user)
    if (!iscarbon(user.mob))
        return FALSE
    var/mob/living/carbon/C = user.mob
    C.swap_rmb_intent(null, 1)
    return TRUE

/datum/keybinding/carbon/rmb_intent_2
    hotkey_keys = list("Shift2")
    name = "rmb_intent_2"
    full_name = "Select Aimed Stance"
    description = "Selects the Aimed RMB stance."
    category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_2/down(client/user)
    if (!iscarbon(user.mob))
        return FALSE
    var/mob/living/carbon/C = user.mob
    C.swap_rmb_intent(null, 2)
    return TRUE

/datum/keybinding/carbon/rmb_intent_3
    hotkey_keys = list("Shift3")
    name = "rmb_intent_3"
    full_name = "Select Strong Stance"
    description = "Selects the Strong RMB stance."
    category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_3/down(client/user)
    if (!iscarbon(user.mob))
        return FALSE
    var/mob/living/carbon/C = user.mob
    C.swap_rmb_intent(null, 3)
    return TRUE

/datum/keybinding/carbon/rmb_intent_4
    hotkey_keys = list("Shift4")
    name = "rmb_intent_4"
    full_name = "Select Swift Stance"
    description = "Selects the Swift RMB stance."
    category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_4/down(client/user)
    if (!iscarbon(user.mob))
        return FALSE
    var/mob/living/carbon/C = user.mob
    C.swap_rmb_intent(null, 4)
    return TRUE

/datum/keybinding/carbon/rmb_intent_5
    hotkey_keys = list("Shift5")
    name = "rmb_intent_5"
    full_name = "Select Defend Stance"
    description = "Selects the Defend RMB stance."
    category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_5/down(client/user)
    if (!iscarbon(user.mob))
        return FALSE
    var/mob/living/carbon/C = user.mob
    C.swap_rmb_intent(null, 5)
    return TRUE

/datum/keybinding/carbon/rmb_intent_6
    hotkey_keys = list("Shift6")
    name = "rmb_intent_6"
    full_name = "Select Weak Stance"
    description = "Selects the Weak RMB stance."
    category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_6/down(client/user)
    if (!iscarbon(user.mob))
        return FALSE
    var/mob/living/carbon/C = user.mob
    C.swap_rmb_intent(null, 6)
    return TRUE

/datum/keybinding/carbon/cycle_rmb_intent
	hotkey_keys = list("N")
	name = "cycle_rmb_intent"
	full_name = "Cycle RMB Stance"
	description = "Cycle through available Right Mouse Button (RMB) Stances."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/cycle_rmb_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.cycle_rmb_intent()
	return TRUE

// ** Action Buttons **
// I stopped at 6 because it is probably the maximum number you can comfortably reach on keyboard
/datum/keybinding/carbon/actions
	var/action_taken = 1
/datum/keybinding/carbon/actions/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	var/list/datum/action/actions = C.actions
	if(actions.len < action_taken) // Dodge a runtime
		return FALSE
	var/datum/action/action = actions[action_taken]
	if(!action)
		return FALSE
	action.Trigger()

/datum/keybinding/carbon/actions/action_1
	hotkey_keys = list("Alt1")
	name = "action_1"
	full_name = "Action 1"
	description = "Select the first action."
	category = CATEGORY_CARBON
	action_taken = 1

/datum/keybinding/carbon/actions/action_2
	hotkey_keys = list("Alt2")
	name = "action_2"
	full_name = "Action 2"
	description = "Select the second action."
	category = CATEGORY_CARBON
	action_taken = 2

/datum/keybinding/carbon/actions/action_3
	hotkey_keys = list("Alt3")
	name = "action_3"
	full_name = "Action 3"
	description = "Select the third action."
	category = CATEGORY_CARBON
	action_taken = 3

/datum/keybinding/carbon/actions/action_4
	hotkey_keys = list("Alt4")
	name = "action_4"
	full_name = "Action 4"
	description = "Select the fourth action."
	category = CATEGORY_CARBON
	action_taken = 4

/datum/keybinding/carbon/actions/action_5
	hotkey_keys = list("Alt5")
	name = "action_5"
	full_name = "Action 5"
	description = "Select the fifth action."
	category = CATEGORY_CARBON
	action_taken = 5

/datum/keybinding/carbon/actions/action_6
	hotkey_keys = list("Alt6")
	name = "action_6"
	full_name = "Action 6"
	description = "Select the sixth action."
	category = CATEGORY_CARBON
	action_taken = 6

/datum/keybinding/carbon/actions/action_7
	hotkey_keys = list("Alt7")
	name = "action_7"
	full_name = "Action 7"
	description = "Select the seventh action."
	category = CATEGORY_CARBON
	action_taken = 7

	
/datum/keybinding/carbon/actions/action_8
	hotkey_keys = list("Alt8")
	name = "action_8"
	full_name = "Action 8"
	description = "Select the eighth action."
	category = CATEGORY_CARBON
	action_taken = 8

	
/datum/keybinding/carbon/actions/action_9
	hotkey_keys = list("Alt9")
	name = "action_9"
	full_name = "Action 9"
	description = "Select the ninth action."
	category = CATEGORY_CARBON
	action_taken = 9
