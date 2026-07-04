#define EMPOWER_FILTER "empower_glow"

/datum/action/cooldown/spell/empower_weapon
	name = "Empower Weapon"
	desc = "Channel all accumulated momentum into your next strike, empowering it to bypass parry and dodge. Works with both weapons and unarmed attacks. \
		Requires 5+ momentum. Burns ALL momentum."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "empower_weapon"
	sound = 'sound/magic/antimagic.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0

	invocations = list()
	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/min_momentum = 5

/datum/action/cooldown/spell/empower_weapon/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/empower_weapon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("I need at least [min_momentum] momentum to empower my weapon!"))
		return FALSE

	if(H.has_status_effect(/datum/status_effect/buff/empowered_strike))
		to_chat(H, span_warning("My weapon is already empowered!"))
		return FALSE

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
	// Consume the buff - this swing bypasses defense
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
