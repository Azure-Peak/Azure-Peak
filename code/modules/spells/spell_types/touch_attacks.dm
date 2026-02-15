/obj/effect/proc_holder/spell/targeted/touch
	var/hand_path = /obj/item/melee/touch_attack
	var/obj/item/melee/touch_attack/attached_hand = null
	var/drawmessage = "You channel the power of the spell to my hand."
	var/dropmessage = "You draw the power out of my hand."
	invocation_type = "none" //you scream on connecting, not summoning
	include_user = TRUE
	range = -1
	var/castdrain = FALSE // value for if you want a summonable weapon to cost stamina

/obj/effect/proc_holder/spell/targeted/touch/Destroy()
	remove_hand()
	to_chat(usr, span_notice("The power of the spell dissipates from my hand."))
	..()

/obj/effect/proc_holder/spell/targeted/touch/proc/remove_hand(recharge = FALSE)
	QDEL_NULL(attached_hand)
	if(recharge)
		charge_counter = recharge_time

/obj/effect/proc_holder/spell/targeted/touch/proc/on_hand_destroy(obj/item/melee/touch_attack/hand)
	if(hand != attached_hand)
		CRASH("Incorrect touch spell hand.")
	//Start recharging.
	attached_hand = null
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/touch/cast(list/targets, mob/user = usr)
	if(!QDELETED(attached_hand))
		remove_hand(TRUE)
		to_chat(user, span_notice("[dropmessage]"))
		return

	for(var/mob/living/carbon/C in targets)
		if(!attached_hand)
			if(ChargeHand(C))
				return

/obj/effect/proc_holder/spell/targeted/touch/charge_check(mob/user)
	if(!QDELETED(attached_hand)) //Charge doesn't matter when putting the hand away.
		return TRUE
	else
		return ..()

/obj/effect/proc_holder/spell/targeted/touch/proc/ChargeHand(mob/living/carbon/user)
	attached_hand = new hand_path(src)
	attached_hand.attached_spell = src
	if(!user.put_in_hands(attached_hand))
		remove_hand(TRUE)
		if (user.get_num_arms() <= 0)
			to_chat(user, span_warning("I don't have any usable hands!"))
		else
			to_chat(user, span_warning("My hands are full!"))
		return FALSE
	if(castdrain)
		user.stamina_add(castdrain)
	to_chat(user, span_notice("[drawmessage]"))
	return TRUE
