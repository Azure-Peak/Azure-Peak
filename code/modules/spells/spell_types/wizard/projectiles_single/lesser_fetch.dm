/datum/action/cooldown/spell/projectile/lesser_fetch
	name = "Lesser Fetch"
	desc = "Shoot out a magical bolt that draws in a freestanding item towards the caster. Doesn't work on living targets."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "fetch"
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Recolligere Minora")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 8 SECONDS

	projectile_type = /obj/projectile/magic/lesser_fetch

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_LOW
	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/obj/projectile/magic/lesser_fetch
	name = "lesser bolt of fetching"
	icon_state = "cursehand0"
	flag = "blunt"
	range = 15
	cannot_cross_z = TRUE

/obj/projectile/magic/lesser_fetch/on_hit(target)
	. = ..()
	var/atom/throw_target = get_step(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
		return BULLET_ACT_BLOCK
	else
		if(isitem(target))
			var/obj/item/I = target
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_turf(firer)
			I.throw_at(throw_target, 200, 3)
