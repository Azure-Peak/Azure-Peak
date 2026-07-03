/datum/action/cooldown/spell/fly
	name = "Fly"
	desc = "Levitate yourself or another off the ground, granting flight over dangerous terrain and the ability to travel between floors freely.\nAny hit, attack, or spell cast will shatter concentration and drop the flyer immediately."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune4"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE
	charge_then_click = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Volāre!","Leviosa!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 10 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	point_cost = 4
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/fly/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!istype(cast_on, /mob/living/carbon/human))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/carbon/human/T = cast_on
	var/dur = (1 MINUTES) + min(max(H.STAINT - 10, 0) * 10 SECONDS, 2 MINUTES)

	if(T == H)
		H.visible_message(span_warning("<b>[H] exclaims an incantation and slowly rises into the air!</b>"),
			span_notice("<b>I exclaim the words of ascension and feel gravity loosen its grip.</b>"))
	else
		H.visible_message(span_warning("<b>[H] exclaims an incantation and [T] slowly rises into the air!</b>"),
			span_notice("<b>I reach out with my incantation and lift [T] into the air.</b>"))
		to_chat(T, span_warning("I feel gravity loosen its grip — [H] has lifted me into the air!"))

	T.apply_status_effect(/datum/status_effect/buff/fly, dur)
	return TRUE

// --- Fly Up/Down spell buttons (granted/removed with the status effect) ---

/datum/action/cooldown/spell/fly_up
	name = "Fly Up"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune5"
	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 3 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/fly_up/cast(atom/cast_on)
	. = ..()
	var/mob/living/M = cast_on
	if(!isliving(M))
		return FALSE
	if(M.pulledby)
		to_chat(M, span_notice("I can't fly up while being grabbed!"))
		return FALSE
	M.visible_message(span_notice("[M] begins to ascend!"), span_notice("I take flight upward..."))
	if(do_after(M, 3 SECONDS))
		if(!M.has_status_effect(/datum/status_effect/buff/fly))
			return FALSE
		M.zMove(UP, TRUE)
	return TRUE

/datum/action/cooldown/spell/fly_down
	name = "Fly Down"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune3"
	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 3 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/fly_down/cast(atom/cast_on)
	. = ..()
	var/mob/living/M = cast_on
	if(!isliving(M))
		return FALSE
	if(M.pulledby)
		to_chat(M, span_notice("I can't fly down while being grabbed!"))
		return FALSE
	M.visible_message(span_notice("[M] begins to descend!"), span_notice("I descend..."))
	if(do_after(M, 1 SECONDS))
		if(!M.has_status_effect(/datum/status_effect/buff/fly))
			return FALSE
		M.zMove(DOWN, TRUE)
	return TRUE

// --- Screen alert ---

/atom/movable/screen/alert/status_effect/buff/fly
	name = "Flying"
	desc = "I am levitating. Use the Fly Up and Fly Down action buttons to move between floors. Any hit, attack, or spell cast will break my concentration and send me down. Sneaking is disabled while airborne."
	icon_state = "buff"

// --- Status effect ---

/datum/status_effect/buff/fly
	id = "fly"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fly
	var/datum/action/cooldown/spell/fly_up/fly_up_action
	var/datum/action/cooldown/spell/fly_down/fly_down_action

/datum/status_effect/buff/fly/on_creation(mob/living/new_owner, new_duration)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/fly/on_apply()
	. = ..()
	owner.movement_type |= FLYING
	owner.float(TRUE)
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_hit))
	RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_MOB_CAST_SPELL, PROC_REF(on_cast))
	fly_up_action = new /datum/action/cooldown/spell/fly_up(owner)
	fly_up_action.Grant(owner)
	fly_down_action = new /datum/action/cooldown/spell/fly_down(owner)
	fly_down_action.Grant(owner)

/datum/status_effect/buff/fly/on_remove()
	. = ..()
	owner.movement_type &= ~FLYING
	owner.float(FALSE)
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_CAST_SPELL)
	if(fly_up_action)
		fly_up_action.Remove(owner)
		qdel(fly_up_action)
		fly_up_action = null
	if(fly_down_action)
		fly_down_action.Remove(owner)
		qdel(fly_down_action)
		fly_down_action = null
	var/turf/T = get_turf(owner)
	if(T?.zFall(owner))
		to_chat(owner, span_warning("My concentration breaks and I fall!"))
	else
		to_chat(owner, span_warning("My concentration breaks! I stumble as I touch down."))
		owner.Immobilize(0.5 SECONDS)

/datum/status_effect/buff/fly/proc/on_hit(mob/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(!damage)
		return
	owner.remove_status_effect(/datum/status_effect/buff/fly)

/datum/status_effect/buff/fly/proc/on_attack(mob/source, ...)
	SIGNAL_HANDLER
	owner.remove_status_effect(/datum/status_effect/buff/fly)

/datum/status_effect/buff/fly/proc/on_cast(mob/source, datum/action/cooldown/spell/spell, atom/cast_on)
	SIGNAL_HANDLER
	if(istype(spell, /datum/action/cooldown/spell/fly_up) || istype(spell, /datum/action/cooldown/spell/fly_down))
		return
	owner.remove_status_effect(/datum/status_effect/buff/fly)
