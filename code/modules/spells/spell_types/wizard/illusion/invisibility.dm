/datum/action/cooldown/spell/invisibility
	name = "Invisibility"
	desc = "Make another (or yourself) invisible for some time. Duration scales with intelligence. Casting, attacking or being attacked will cancel the duration."
	button_icon = 'icons/mob/actions/nocmiracles.dmi'
	button_icon_state = "invisibility"
	sound = null
	spell_color = GLOW_COLOR_ILLUSION
	has_visual_effects = FALSE
	hide_charge_effect = TRUE

	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = 30

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_swingdelay_type = NONE
	charge_time = CHARGETIME_MINOR
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	point_cost = 3
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/invisibility/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	if(!isliving(cast_on))
		to_chat(user, span_warning("That is not a valid target!"))
		return FALSE
	var/mob/living/target = cast_on
	if(target.anti_magic_check(TRUE, TRUE))
		return FALSE
	target.visible_message(span_warning("[target] starts to fade into thin air!"), span_notice("You start to become invisible!"))
	var/dur = 15 + min(max(user.STAINT - 10, 0) * 2.5, 12.5)
	animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
	target.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
	return TRUE
