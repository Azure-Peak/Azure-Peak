/datum/action/cooldown/spell/bonemend
	name = "Bone Mend"
	desc = "Mend the chosen target's bones with a burst of necrotic magick. Requires standing still for a few seconds."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "skeleton"
	cast_range = 2
	sound = 'sound/magic/whiteflame.ogg'
	charge_required = TRUE
	charge_time = 5 SECONDS
	primary_resource_cost = 50
	primary_resource_type = SPELL_COST_STAMINA
	cooldown_time = 30 SECONDS
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE
	spell_requirements = SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/bonemend/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/bonemend/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(target.mob_biotypes & MOB_UNDEAD)
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(owner.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
	return TRUE
