
/datum/action/cooldown/spell/conjure_dismiss
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Dismiss Conjuration"
	desc = "Release your conjured servants back to the leyline. They vanish quietly, sparing you the violent recoil of one struck down."
	button_icon_state = "dismiss_conjure"
	sound = null
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	charge_time = CHARGETIME_BARRAGE
	charge_swingdelay_type = SWINGDELAY_CANCEL // People CAN take advantage of you trying to combat unsummon if they are in a tight spot. This is on purpose
	cooldown_time = 30 SECONDS

	charge_slowdown = CHARGING_SLOWDOWN_HEAVY

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/conjure_dismiss/can_cast_spell(feedback = TRUE)
	return !isnull(owner)

/datum/action/cooldown/spell/conjure_dismiss/cast(atom/cast_on)
	. = ..()
	var/count = 0
	for(var/datum/action/cooldown/spell/conjure_summon/summon_spell in owner.actions)
		for(var/mob/living/M in summon_spell.conjured_mobs.Copy())
			if(QDELETED(M))
				continue
			dismiss_conjured_minion(M)
			count++
	if(count)
		to_chat(owner, span_notice("I begin to release my conjured servants back to the leyline."))
	else
		to_chat(owner, span_warning("I have no conjured servants to dismiss."))
		reset_spell_cooldown()
	return TRUE
