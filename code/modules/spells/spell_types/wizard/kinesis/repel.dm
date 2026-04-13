/datum/action/cooldown/spell/projectile/repel
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Repel"
	desc = "Shoot out a magical bolt that pushes out the target struck away from the caster. Instead of repelling a target, it will throw an object in your hand if cast while in throw mode."
	button_icon_state = "repel"
	sound = 'sound/magic/unmagnet.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/repel
	cast_range = 15
	point_cost = 2

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Exmoveo!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MINOR
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

/datum/action/cooldown/spell/projectile/repel/cast(atom/cast_on)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/obj/proj = H.get_active_held_item()
		if(isobj(proj))
			var/obj/I = proj
			if(I && H.in_throw_mode)
				var/atom/throw_target = get_edge_target_turf(H, get_dir(owner, get_step(owner, owner.dir)))
				if(throw_target)
					H.dropItemToGround(I)
					if(I) // In case it's something that gets qdel'd on drop
						I.throw_at(throw_target, 7, 4)
						H.throw_mode_off()
					return TRUE
	return ..()

/obj/projectile/magic/repel
	name = "bolt of repeling"
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	flag = "blunt"
	speed = MAGE_PROJ_FAST
	range = 15
	cannot_cross_z = TRUE

/obj/projectile/magic/repel/on_hit(target)
	var/atom/throw_target = get_edge_target_turf(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check() || !firer)
			L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			return BULLET_ACT_BLOCK
		L.throw_at(throw_target, 7, 4)
	else
		if(isitem(target))
			var/obj/item/I = target
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_edge_target_turf(firer, get_dir(firer, target))
			I.throw_at(throw_target, 7, 4)
