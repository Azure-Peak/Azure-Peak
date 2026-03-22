/* Empower Weapon — Universal spellblade momentum dump.
Burns ALL momentum stacks to empower your next melee swing,
bypassing parry and dodge entirely. Visible red glow while active.
Safety valve for excess momentum — useful but not overpowered
since spellblades have no STR. */

#define EMPOWER_FILTER "empower_glow"

/obj/effect/proc_holder/spell/self/empower_weapon
	name = "Empower Weapon"
	desc = "Channel all accumulated momentum into your next strike, empowering it to bypass parry and dodge. Works with both weapons and unarmed attacks. \
		Requires 5+ momentum. Burns ALL momentum."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	overlay_state = "empower_weapon"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	invocations = list()
	invocation_type = "none"
	gesture_required = FALSE
	xp_gain = FALSE
	var/min_momentum = 5

/obj/effect/proc_holder/spell/self/empower_weapon/can_cast(mob/user = usr, feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/empower_weapon/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("I need at least [min_momentum] momentum to empower my weapon!"))
		revert_cast()
		return

	if(H.has_status_effect(/datum/status_effect/buff/empowered_strike))
		to_chat(H, span_warning("My weapon is already empowered!"))
		revert_cast()
		return

	var/stacks_burned = M.stacks
	M.consume_stacks(stacks_burned)

	H.apply_status_effect(/datum/status_effect/buff/empowered_strike)
	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)
	H.visible_message(
		span_danger("[H]'s weapon flares with a violent red glow!"),
		span_notice("I channel [stacks_burned] momentum into my weapon. The next strike will not be denied."))

	return TRUE

// --- Status effect: one-swing parry/dodge bypass ---

/atom/movable/screen/alert/status_effect/buff/empowered_strike
	name = "Empowered Strike"
	desc = "My next melee strike will bypass parry and dodge."
	icon_state = "buff"

/datum/status_effect/buff/empowered_strike
	id = "empowered_strike"
	alert_type = /atom/movable/screen/alert/status_effect/buff/empowered_strike
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/buff/empowered_strike/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	owner.add_filter(EMPOWER_FILTER, 2, list("type" = "outline", "color" = "#ff2020", "alpha" = 200, "size" = 2))

/datum/status_effect/buff/empowered_strike/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	owner.remove_filter(EMPOWER_FILTER)
	. = ..()

/datum/status_effect/buff/empowered_strike/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(target == owner || target.stat == DEAD)
		return
	// Consume the buff — this swing bypasses defense
	consume_empower()
	return COMPONENT_ITEM_NO_DEFENSE

/datum/status_effect/buff/empowered_strike/proc/on_unarmed_attack(mob/living/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(!isliving(target) || target == owner)
		return
	var/mob/living/L = target
	if(L.stat == DEAD)
		return
	// Flag for the unarmed attack path to skip defense
	ADD_TRAIT(owner, TRAIT_EMPOWERED_UNARMED, "empowered_strike")
	// Consume on next tick after the attack resolves
	addtimer(CALLBACK(src, PROC_REF(consume_empower)), 0)

/datum/status_effect/buff/empowered_strike/proc/consume_empower()
	REMOVE_TRAIT(owner, TRAIT_EMPOWERED_UNARMED, "empowered_strike")
	playsound(get_turf(owner), 'sound/magic/antimagic.ogg', 40, TRUE)
	owner.visible_message(
		span_danger("[owner]'s empowered strike blazes through!"),
		span_notice("My empowered strike lands true!"))
	owner.remove_status_effect(/datum/status_effect/buff/empowered_strike)

#undef EMPOWER_FILTER
