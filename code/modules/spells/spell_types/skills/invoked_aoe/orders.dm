////////////////////
// BASELINE ORDER //
////////////////////

/datum/action/cooldown/spell/order
	name = ""
	background_icon = 'icons/mob/actions/orders.dmi'
	button_icon = 'icons/mob/actions/orders.dmi'
	sound = 'sound/magic/inspire_02.ogg'

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SURGE + 15

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1.5 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	cooldown_time = 2 MINUTES

	shared_cooldown = LEADERSHIP_ORDER_SHARED_COOLDOWN

	ignore_armor_penalty = TRUE
	associated_stat = null
	associated_skill = /datum/skill/misc/athletics
	spell_tier = 0
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/single_target = FALSE
	var/buff_given
	var/msg

/datum/action/cooldown/spell/order/cast(atom/cast_on)
	. = ..()
	var/affectedjobs = list()
	var/affectedtargets = list()
	if(!single_target) //We want one spell to use the old method so we'll separate this out
		if(owner.job == "Sergeant")
			affectedjobs = list("Man at Arms", "Warden", "Watchman")
		else if(owner.job == "Marshal")//He is the boss after all
			affectedjobs = list("Knight", "Squire", "Sergeant", "Man at Arms", "Warden", "Watchman")
		else if(owner.job == "Wretch")
			affectedjobs = list("Brother")
		else if(owner)
			affectedjobs = list("Heartfelt Retinue", "Migrant")
		else //failsafe in case someone somehow gets the spells without a role that uses them
			to_chat(owner, span_alert("I don't have authority to order anyone!"))
			return FALSE
		for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
			if(target.job in affectedjobs)
				affectedtargets += target
				continue
			if(owner.advjob == "Disgraced Knight" && target.advjob == "Disgraced Man at Arms") //Special line so Disgraced Knight can buff Disgraced Man at Arms
				affectedtargets += target
		if(!length(affectedtargets))
			to_chat(owner, span_alert("There are no subordinates close enough to hear my orders!"))
			return FALSE
		else
			owner.say("[msg]", language = /datum/language/common)
			for(var/mob/living/carbon/target in affectedtargets)
				target.apply_status_effect(buff_given)
			return TRUE

//////////////////////////
// MOVEMENT SPEED ORDER //
//////////////////////////

/datum/action/cooldown/spell/order/movemovemove
	name = "Order: Move"
	desc = "Orders your underlings to move faster. +2 Speed."
	button_icon_state = "move"
	buff_given = /datum/status_effect/buff/order/movemovemove

/datum/action/cooldown/spell/order/movemovemove/cast(atom/cast_on)
	msg = owner.mind.movemovemovetext
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

////////////////////
// TAKE AIM ORDER //
////////////////////

/datum/action/cooldown/spell/order/takeaim
	name = "Order: Take Aim"
	desc = "Orders your underlings to be more precise. +2 Perception."
	button_icon_state = "target"
	buff_given = /datum/status_effect/buff/order/takeaim

/datum/status_effect/buff/order/takeaim
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/takeaim
	effectedstats = list(STATKEY_PER = 2)
	duration = 1 MINUTES

/datum/action/cooldown/spell/order/takeaim/cast(atom/cast_on)
	msg = owner.mind.takeaimtext
	. = ..()

/atom/movable/screen/alert/status_effect/buff/order/takeaim
	name = "Take aim!"
	desc = "My officer has ordered me to take aim!"
	icon_state = "buff"

/datum/status_effect/buff/order/takeaim/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to take aim!"))

////////////////
// HOLD ORDER //
////////////////

/datum/action/cooldown/spell/order/hold
	name = "Order: Hold"
	desc = "Orders your underlings to Endure. +1 Willpower and Constitution."
	button_icon_state = "hold"
	buff_given = /datum/status_effect/buff/order/hold

/datum/action/cooldown/spell/order/hold/cast(atom/cast_on)
	msg = owner.mind.holdtext
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

///////////////////
// ON FEET ORDER //
///////////////////

/datum/action/cooldown/spell/order/onfeet
	name = "Order: On your feet"
	desc = "Orders an underling to stand up and fight without fear or pain."
	button_icon_state = "onfeet"
	click_to_activate = TRUE
	single_target = TRUE

/datum/action/cooldown/spell/order/onfeet/cast(atom/cast_on)
	. = ..()
	if(isliving(cast_on))
		var/mob/living/target = cast_on
		var/msg = owner.mind.onfeettext
		if(!msg)
			to_chat(owner, span_alert("I must say something to give an order!"))
			return
		if(owner.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Warden", "Watchman")))
				to_chat(owner, span_alert("I cannot order one not of my ranks!"))
				return
		if(owner.job == "Marshal")
			if(!(target.job in list("Knight", "Squire", "Sergeant", "Man at Arms", "Warden", "Watchman")))
				to_chat(owner, span_alert("I cannot order one not of my ranks!"))
				return
		if(owner.job == "Wretch")
			if(!(target.job in list("Brother")))
				to_chat(owner, span_alert("I cannot order one not of the brotherhood cause!"))
				return
		if(target == owner)
			to_chat(owner, span_alert("I cannot order myself!"))
			return
		owner.say("[msg]", language = /datum/language/common)
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

////////////////////
// REHEARSE ORDER //
////////////////////

/mob/living/carbon/human/mind/proc/setorders()
	set name = "Rehearse Orders"
	set category = "RoleUnique.Voice of Command"
	mind.movemovemovetext = input(src, "Send a message.", "Order: Move") as text|null
	if(!mind.movemovemovetext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.holdtext = input(src, "Send a message.", "Order: Hold") as text|null
	if(!mind.holdtext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.takeaimtext = input(src, "Send a message.", "Order: Take aim") as text|null
	if(!mind.takeaimtext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.onfeettext = input(src, "Send a message.", "Order: On your feet") as text|null
	if(!mind.onfeettext)
		to_chat(src, "I must rehearse something for this order...")
		return

