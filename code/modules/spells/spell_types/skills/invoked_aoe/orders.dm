/obj/effect/proc_holder/spell/invoked/order
	name = ""
	range = 1
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 1
	chargetime = 15
	releasedrain = 80
	recharge_time = 2 MINUTES
	miracle = FALSE
	sound = 'sound/magic/inspire_02.ogg'
	var/single_target = FALSE
	var/buff_given
	var/msg

/obj/effect/proc_holder/spell/invoked/order/cast(list/targets, mob/living/user)
	. = ..()
	var/affectedjobs = list()
	var/affectedtargets = list()
	if(!single_target) //We want one spell to use the old method so we'll separate this out
		if(user.job == "Sergeant")
			affectedjobs = list("Man at Arms", "Watchman")
		else if(user.job == "Knight Captain")
			affectedjobs = list("Knight", "Squire")
		else if(user.job == "Wretch")
			affectedjobs = list("Brother")
		else //failsafe in case someone somehow gets the spells without a role that uses them
			to_chat(user, span_alert("I don't have authority to order anyone!"))
			revert_cast()
			return FALSE
		for(var/mob/living/carbon/target in view(5, get_turf(user)))
			if(target.job in affectedjobs)
				affectedtargets += target
				continue
			if(user.advjob == "Disgraced Knight" && target.advjob == "Disgraced Man at Arms") //Special line so Disgraced Knight can buff Disgraced Man at Arms
				affectedtargets += target
		if(!length(affectedtargets))
			to_chat(user, span_alert("There are no subordinates close enough to hear my orders!"))
			revert_cast()
			return FALSE
		else
			user.say("[msg]")
			for(var/mob/living/carbon/target in affectedtargets)
				target.apply_status_effect(buff_given)
			return TRUE

//Statbuff orders. Power budget of 2 stat points
/obj/effect/proc_holder/spell/invoked/order/movemovemove
	name = "Move! Move! Move!"
	desc = "Orders your underlings to move faster. +2 Speed."
	overlay_state = "movemovemove"
	buff_given = /datum/status_effect/buff/order/movemovemove

/obj/effect/proc_holder/spell/invoked/order/movemovemove/cast(list/targets, mob/living/user)
	msg = user.mind.movemovemovetext
	.=..()

/datum/status_effect/buff/order/movemovemove/nextmove_modifier()
	return 0.925 //Half as beneficial as Haste

/datum/status_effect/buff/order/movemovemove
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/movemovemove
	effectedstats = list(STATKEY_SPD = 2)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/movemovemove
	name = "Move! Move! Move!"
	desc = "My officer has ordered me to move quickly!"
	icon_state = "buff"

/datum/status_effect/buff/order/movemovemove/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to move!"))


/obj/effect/proc_holder/spell/invoked/order/takeaim
	name = "Take aim!"
	desc = "Orders your underlings to be more precise. +2 Perception."
	overlay_state = "takeaim"
	buff_given = /datum/status_effect/buff/order/takeaim

/datum/status_effect/buff/order/takeaim
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/takeaim
	effectedstats = list(STATKEY_PER = 2)
	duration = 1 MINUTES

/obj/effect/proc_holder/spell/invoked/order/takeaim/cast(list/targets, mob/living/user)
	msg = user.mind.takeaimtext
	. = ..()

/atom/movable/screen/alert/status_effect/buff/order/takeaim
	name = "Take aim!"
	desc = "My officer has ordered me to take aim!"
	icon_state = "buff"

/datum/status_effect/buff/order/takeaim/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to take aim!"))


/obj/effect/proc_holder/spell/invoked/order/hold
	name = "Hold!"
	desc = "Orders your underlings to Endure. +1 Willpower and Constitution."
	overlay_state = "hold"
	buff_given = /datum/status_effect/buff/order/hold

/obj/effect/proc_holder/spell/invoked/order/hold/cast(list/targets, mob/living/user)
	msg = user.mind.holdtext
	. = ..()

/datum/status_effect/buff/order/hold
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/hold
	effectedstats = list(STATKEY_WIL = 1, STATKEY_CON = 1)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/hold
	name = "Hold!"
	desc = "My officer has ordered me to hold!"
	icon_state = "buff"

/datum/status_effect/buff/order/hold/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to hold!"))


/obj/effect/proc_holder/spell/invoked/order/onfeet
	name = "On your feet!"
	desc = "Orders an underling to stand up and fight without fear or pain."
	overlay_state = "onfeet"
	single_target = TRUE

/obj/effect/proc_holder/spell/invoked/order/onfeet/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.onfeettext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(user.job == "Wretch")
			if(!(target.job in list("Brother")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/onfeet)
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.SetUnconscious(0)
			target.SetSleeping(0)
			target.SetParalyzed(0)
			target.SetImmobilized(0)
			target.SetStun(0)
			target.SetKnockdown(0)
			target.set_resting(FALSE)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/onfeet
	id = "onfeet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/onfeet
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/order/onfeet
	name = "On your feet!"
	desc = "My officer has ordered me to my feet!"
	icon_state = "buff"

/datum/status_effect/buff/order/onfeet/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to my feet!"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)

/datum/status_effect/buff/order/onfeet/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)
	. = ..()

//For good roles
/mob/living/carbon/human/mind/proc/setorders()
	set name = "Rehearse Orders"
	set category = "Voice of Command"
	mind.movemovemovetext = input("Send a message.", "Move! Move! Move!") as text|null
	if(!mind.movemovemovetext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.holdtext = input("Send a message.", "Hold!") as text|null
	if(!mind.holdtext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.takeaimtext = input("Send a message.", "Take aim!") as text|null
	if(!mind.takeaimtext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.onfeettext = input("Send a message.", "On your feet!") as text|null
	if(!mind.onfeettext)
		to_chat(src, "I must rehearse something for this order...")
		return

