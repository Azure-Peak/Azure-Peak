/datum/action/cooldown/spell/augment_buff/precognition
	name = "Precognition"
	desc = "Peer a few moments into the future for yourself or an ally, readying them before the moment arrives. Cuts 15 seconds from the remaining cooldown of the target's Defend and Special."
	button_icon_state = "readomen"

	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Praescientia!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 75 SECONDS
	other_cast_cooldown_reduction = 0 // Does not benefit from ally-cast cooldown reduction

	point_cost = 2

/datum/action/cooldown/spell/augment_buff/precognition/cast(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		to_chat(owner, span_warning("That is not a valid target!"))
		return FALSE
	var/mob/living/target = cast_on

	var/hastened = FALSE
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/clashcd)
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/specialcd)

	var/obj/effect/temp_visual/origin_haste/V = new
	target.vis_contents += V

	if(hastened)
		target.balloon_alert_to_viewers("<font color='#66ffcc'>cooldowns -15s!</font>")
		to_chat(target, span_notice("I glimpse the moments ahead, and ready myself for the next move."))
	else
		to_chat(target, span_notice("I glimpse the moments ahead, but there is nothing left to hasten."))
	return TRUE

/proc/reduce_intent_cooldown(mob/living/target, effect_type, amount = 15 SECONDS)
	var/datum/status_effect/S = target.has_status_effect(effect_type)
	if(!S)
		return FALSE
	S.duration -= amount
	if(S.duration <= world.time)
		target.remove_status_effect(effect_type)
	return TRUE
