/obj/effect/proc_holder/spell/invoked/order/heartfelt/proc/can_order(mob/living/target, mob/living/user)
	if(target == user)
		to_chat(user, span_alert("I cannot order myself!"))
		return 0
	if(HAS_TRAIT(target, TRAIT_HEARTFELT))
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return 0
		else
			return 1
	if(!(target.job in list("Heartfelt Retinue", "Knight of Heartfelt")))
		to_chat(user, span_alert("I cannot order one not in our cause!"))
		return 0
	return 1


/obj/effect/proc_holder/spell/invoked/order/heartfelt
    name = "Heartfelt Order"
    var/effect_to_apply
    var/message_varname

/obj/effect/proc_holder/spell/invoked/order/heartfelt/cast(list/targets, mob/living/user)
    . = ..()
    if(!isliving(targets[1]))
        revert_cast()
        return FALSE

    var/mob/living/target = targets[1]
    var/msg = user.mind.vars[message_varname]

    if(!msg)
        to_chat(user, span_alert("I must say something to give an order!"))
        return

    var/allowed = can_order(target, user)
    if(!allowed)
        return

    user.say("[msg]")
    target.apply_status_effect(effect_to_apply)
    on_success(user, target)
    return TRUE

/obj/effect/proc_holder/spell/invoked/order/heartfelt/proc/on_success(mob/living/user, mob/living/target)
    return

/***************************************************************
 *  INDIVIDUAL HEARTFELT ORDERS
 ***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat
    name = "Retreat!"
    overlay_state = "movemovemove"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/retreat
    message_varname = "retreattext"

/datum/status_effect/buff/order/heartfelt/retreat
    id = "retreat"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/retreat
    effectedstats = list(STATKEY_SPD = 3)
    duration = 30 SECONDS

/datum/status_effect/buff/order/heartfelt/retreat/on_apply()
    . = ..()
    to_chat(owner, span_blue("My commander orders me to fall back!"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/retreat
    name = "Retreat!"
    desc = "My commander orders me to fall back!"
    icon_state = "buff"

/***************************************************************/


/obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster
    name = "Hold the Line!"
    overlay_state = "bolster"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/bolster
    message_varname = "bolstertext"

/datum/status_effect/buff/order/heartfelt/bolster
    id = "bolster"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/bolster
    effectedstats = list(STATKEY_CON = 3)
    duration = 1 MINUTES

/datum/status_effect/buff/order/heartfelt/bolster/on_apply()
    . = ..()
    to_chat(owner, span_blue("My commander orders me to hold the line!"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/bolster
    name = "Hold the Line!"
    desc = "My commander inspires me to endure and last a little longer!"
    icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt
    name = "Stand and fight!"
    overlay_state = "onfeet"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/forheartfelt
    message_varname = "onfeettext"

/obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt/on_success(mob/living/user, mob/living/target)
    if(!(target.mobility_flags & MOBILITY_STAND))
        target.SetUnconscious(0)
        target.SetSleeping(0)
        target.SetParalyzed(0)
        target.SetImmobilized(0)
        target.SetStun(0)
        target.SetKnockdown(0)
        target.set_resting(FALSE)

/datum/status_effect/buff/order/heartfelt/forheartfelt
    id = "forheartfelt"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/forheartfelt
    duration = 15 SECONDS

/datum/status_effect/buff/order/heartfelt/forheartfelt/on_apply()
    . = ..()
    to_chat(owner, span_blue("I must stand and fight!"))
    ADD_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)

/datum/status_effect/buff/order/heartfelt/forheartfelt/on_remove()
    REMOVE_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)
    . = ..()

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/forheartfelt
    name = "Stand your Ground!"
    desc = "My commander has ordered me to stand proud for Heartfelt!"
    icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/charge
    name = "Charge!"
    overlay_state = "charge"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/charge
    message_varname = "chargetext"

/datum/status_effect/buff/order/heartfelt/charge
    id = "charge"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/charge
    effectedstats = list(STATKEY_STR = 2, STATKEY_LCK = 2)
    duration = 1 MINUTES

/datum/status_effect/buff/order/heartfelt/charge/on_apply()
    . = ..()
    to_chat(owner, span_blue("My commander orders me to charge! For Heartfelt!"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/charge
    name = "Charge!"
    desc = "My commander wills it - now is the time to charge!"
    icon_state = "buff"

/***************************************************************/

// Doesn't work at the moment

// /obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget
    // name = "Focus Target!"
    // overlay_state = "focustarget"
    // effect_to_apply = /datum/status_effect/debuff/order/heartfelt/focustarget
    // message_varname = "targettext"

// /datum/status_effect/debuff/order/heartfelt/focustarget
	//id = "target"
	// alert_type = /atom/movable/screen/alert/status_effect/debuff/order/heartfelt/focustarget
	// effectedstats = list("fortune" = -2)
	// duration = 1 MINUTES
	// var/outline_colour = "#69050a"

// /atom/movable/screen/alert/status_effect/debuff/order/heartfelt/focustarget
	// name = "Targetted"
	// desc = "A officer has marked me for death!"
	// icon_state = "targetted"

// /datum/status_effect/debuff/order/heartfelt/focustarget/on_apply()
	// . = ..()
	// to_chat(owner, span_alert("I have been marked for death by a officer!"))
	// ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	// return TRUE

// /datum/status_effect/debuff/order/heartfelt/focustarget/on_remove()
	// . = ..()
	// REMOVE_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

// /obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget
	// name = "Focus target!"
	// overlay_state = "focustarget"

// #undef TARGET_FILTER

/***************************************************************
 *  ORDER SETUP PROC
 ***************************************************************/

/mob/living/carbon/human/mind/proc/setordersheartfelt()
    set name = "Rehearse Orders"
    set category = "Voice of Command"

    #define ORDER_INPUT(varname, prompt) \
        mind.varname = input("Send a message.", prompt) as text|null; \
        if(!mind.varname) { to_chat(src, "I must rehearse something for this order..."); return }

    ORDER_INPUT(retreattext, "Fall back!!")
    ORDER_INPUT(chargetext, "Push them back!!")
    ORDER_INPUT(bolstertext, "Hold the line!!")
    ORDER_INPUT(onfeettext, "Stand proud for Heartfelt!!")

    #undef ORDER_INPUT

//GARRISON
