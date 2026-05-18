/datum/action/cooldown/spell/bonechill
	name = "Bone Chill"
	desc = "Chill the chosen target with a burst of necrotic magicka. Applies a strong slowdown effect to the chosen target, alongside further reducing their Strength and Speed."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "bonechill"
	cast_range = 7
	sound = 'sound/magic/whiteflame.ogg'
	spell_tier = 2
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 5
	associated_skill = /datum/skill/magic/arcane
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_SAME_Z
	self_cast_possible = FALSE
	zizo_spell = TRUE

/datum/action/cooldown/spell/bonechill/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/bonechill/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(target.mob_biotypes & MOB_UNDEAD)
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(owner.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
		return TRUE

	target.visible_message(span_info("Necrotic energy floods over [target]!"), span_userdanger("I feel colder as the dark energy floods into me!"))
	if(iscarbon(target))
		target.apply_status_effect(/datum/status_effect/debuff/chilled)
	else
		target.adjustBruteLoss(20)
	return TRUE
