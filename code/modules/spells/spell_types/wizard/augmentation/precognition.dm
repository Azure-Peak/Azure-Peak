/datum/action/cooldown/spell/precognition
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Precognition"
	desc = "Peer a few moments into the future for yourself or an ally, readying them before the moment arrives. Cuts 30 seconds from the remaining cooldown of the target's Defend, Feint, Bait, and Special."
	button_icon_state = "readomen"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Praevidere.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 0.5 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/precognition/cast(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		to_chat(owner, span_warning("That is not a valid target!"))
		return FALSE
	var/mob/living/target = cast_on

	var/hastened = FALSE
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/clashcd)
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/feintcd)
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/baitcd)
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/specialcd)

	var/obj/effect/temp_visual/origin_haste/V = new
	target.vis_contents += V

	if(hastened)
		target.balloon_alert_to_viewers("<font color='#66ffcc'>cooldowns -30s!</font>")
		to_chat(target, span_notice("I glimpse the moments ahead, and ready myself for the next move."))
	else
		to_chat(target, span_notice("I glimpse the moments ahead, but there is nothing left to hasten."))
	return TRUE

/datum/action/cooldown/spell/precognition/proc/reduce_intent_cooldown(mob/living/target, effect_type)
	var/datum/status_effect/S = target.has_status_effect(effect_type)
	if(!S)
		return FALSE
	S.duration -= 30 SECONDS
	if(S.duration <= world.time)
		target.remove_status_effect(effect_type)
	return TRUE
