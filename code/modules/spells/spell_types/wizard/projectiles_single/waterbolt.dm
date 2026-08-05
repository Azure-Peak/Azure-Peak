/datum/action/cooldown/spell/projectile/waterbolt
	name = "Water Bolt"
	desc = "Shoot out a magical bolt of water that extinguishes fires from a distance."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "frost_bolt"
	sound = 'sound/foley/water_land1.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Vel Aquarus")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 8 SECONDS

	projectile_type = /obj/projectile/energy/waterbolt

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_LOW
	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

// Harmless water bolt
/obj/projectile/energy/waterbolt
	name = "water bolt"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = 0
	nodamage = TRUE
	alpha = 127
	color = "#5599FF"
	speed = MAGE_PROJ_FAST
	hitsound = null
	var/zone_aimed = null

/obj/projectile/energy/waterbolt/on_hit(target)
	..()
	if(istype(target, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/L = target
		if(L.on)
			L.extinguish()
	else if(isobj(target))
		var/obj/O = target
		if((O.resistance_flags & ON_FIRE) && O.extinguishable)
			O.extinguish()
	if(ismob(target))
		var/mob/living/M = target
		if(M.fire_stacks > 0)
			M.adjust_fire_stacks(-10)
			if(M.fire_stacks <= 0)
				M.extinguish_mob()
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(zone_aimed in list(
				BODY_ZONE_HEAD,
				BODY_ZONE_PRECISE_SKULL,
				BODY_ZONE_PRECISE_EARS,
				BODY_ZONE_PRECISE_R_EYE,
				BODY_ZONE_PRECISE_L_EYE,
				BODY_ZONE_PRECISE_NOSE,
				BODY_ZONE_PRECISE_MOUTH
			))
				if(H.is_noble())
					H.add_stress(/datum/stressevent/water_splashed_noble)
	return BULLET_ACT_HIT
