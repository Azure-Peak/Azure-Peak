/datum/action/cooldown/spell/augment_buff/augment_defense
	name = "Augment Defense"
	desc = "Uses arcyne energy to restore a target's defenses, clearing away any vulnerability or exposure they may have suffered."
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "stoneskin"

	primary_resource_cost = 5

	invocations = list("Resta!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE

	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/augment_buff/augment_defense/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		return FALSE
	if(!isliving(cast_on))
		to_chat(caster, span_warning("That is not a valid target!"))
		return FALSE
	var/mob/living/target = cast_on

	if(target.has_status_effect(/datum/status_effect/debuff/exposed))
		target.remove_status_effect(/datum/status_effect/debuff/exposed)
	if(target.has_status_effect(/datum/status_effect/debuff/vulnerable))
		target.remove_status_effect(/datum/status_effect/debuff/vulnerable)
	if(target.has_status_effect(/datum/status_effect/debuff/feinted))
		target.remove_status_effect(/datum/status_effect/debuff/feinted)

	target.balloon_alert_to_viewers("<font color='[spell_color]'>guarded!</font>")
	target.visible_message(span_warning("[target] 's defenses are reinforced!"), span_notice("My defense snaps back into place."))
	if(target != caster)
		to_chat(caster, span_notice("I shore up [target]'s defenses, clearing their openings."))
	return TRUE
