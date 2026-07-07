/datum/action/cooldown/spell/augment_buff/surge
	name = "Surge"
	desc = "Flood someone's body with vigors, instantly shaking off any stun, restoring their stamina and bringing them back to their feet. Cannot be cast on yourself"
	button_icon_state = "enlarge"

	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_PHASED

	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 100

	invocations = list("Impetus!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE

	point_cost = 1
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

/datum/action/cooldown/spell/augment_buff/surge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		return FALSE
	if(!isliving(cast_on))
		to_chat(caster, span_warning("That is not a valid target!"))
		return FALSE
	var/mob/living/target = cast_on

	target.SetUnconscious(0)
	target.SetSleeping(0)
	target.SetParalyzed(0)
	target.SetImmobilized(0)
	target.SetStun(0)
	target.SetKnockdown(0)
	if(target.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		target.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.stam_paralyzed = FALSE
	target.stamina_reset()
	target.set_resting(FALSE)

	target.balloon_alert_to_viewers("<font color='[spell_color]'>surge!</font>")
	target.visible_message(span_warning("[target] surges back up, wreathed in energy!"), span_notice("Arcyne energy floods my body - I rise!"))
	if(target != caster)
		to_chat(caster, span_notice("I flood [target] with arcyne vigor, hauling them back to their feet!"))
	new /obj/effect/temp_visual/spell_impact(get_turf(target), spell_color, spell_impact_intensity)
	return TRUE
