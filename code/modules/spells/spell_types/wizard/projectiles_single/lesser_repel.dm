/datum/action/cooldown/spell/projectile/lesser_repel
	name = "Lesser Repel"
	desc = "Shoot out a magical bolt that pushes away a freestanding item from the caster. Doesn't work on large or living targets. Instead of repelling a target, it will throw an object in your hand if cast while in throw mode."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "fetch"
	sound = 'sound/magic/unmagnet.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Minora Exmoveo!")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 15 SECONDS

	projectile_type = /obj/projectile/magic/lesser_repel

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_LOW
	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/projectile/lesser_repel/cast(atom/cast_on)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/obj/I = H.get_active_held_item()
		if(isobj(I) && H.in_throw_mode)
			var/atom/throw_target = get_edge_target_turf(H, get_dir(H, get_step(H, H.dir)))
			if(throw_target)
				H.dropItemToGround(I)
				if(I)
					I.throw_at(throw_target, 7, 4)
					H.throw_mode_off()
				return ..()
	return ..()

/obj/projectile/magic/lesser_repel
	name = "lesser bolt of repelling"
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	flag = "blunt"
	range = 15
	cannot_cross_z = TRUE

/obj/projectile/magic/lesser_repel/on_hit(target)
	var/atom/throw_target = get_edge_target_turf(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
		return BULLET_ACT_BLOCK
	else
		if(isitem(target))
			var/obj/item/I = target
			I.throw_at(throw_target, 7, 4)
	return ..()
