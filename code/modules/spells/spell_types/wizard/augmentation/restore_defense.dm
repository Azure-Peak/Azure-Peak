/datum/action/cooldown/spell/augment_buff/restore_defense
	name = "Restore Defense"
	desc = "Uses arcyne energy to restore an ally's defenses, clearing away any exposure, vulnerability or feint they may have suffered. Cannot be cast on yourself."
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "stoneskin"

	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Resta!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE

	cooldown_time = 30 SECONDS

	point_cost = 1

/datum/action/cooldown/spell/augment_buff/restore_defense/cast(atom/cast_on)
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
	to_chat(caster, span_notice("I shore up [target]'s defenses, clearing their openings."))
	return TRUE
