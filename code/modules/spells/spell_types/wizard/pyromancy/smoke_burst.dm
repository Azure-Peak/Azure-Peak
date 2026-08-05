/datum/action/cooldown/spell/projectile/smoke_burst
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "Smoke Burst"
	desc = "Hurl a harmless ball of smouldering cinders that bursts into a thick 3x3 cloud of smoke on impact, blocking sight for around 15 seconds.\
	Deals no damage. \
	Toggle arc mode (Shift+G) while the spell is active to lob it over intervening mobs and obstacles."
	button_icon_state = "smoke_burst"
	sound = 'sound/items/firesnuff.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/smoke_burst
	projectile_type_arc = /obj/projectile/magic/smoke_burst/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Evomere Fumum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 45 SECONDS
	attunement_school = ASPECT_NAME_PYROMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/smoke_burst
	name = "smoke burst"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "spark"
	light_color = "#8a8a8a"
	light_outer_range = 2
	speed = MAGE_PROJ_VERY_SLOW
	nodamage = TRUE
	damage = 0
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	reflectable = FALSE
	guard_deflectable = FALSE
	var/smoke_range = 1
	var/has_burst = FALSE

/obj/projectile/magic/smoke_burst/arc
	name = "arced smoke burst"
	arcshot = TRUE

/obj/projectile/magic/smoke_burst/proc/burst_smoke(turf/epicenter)
	if(has_burst || !epicenter)
		return
	has_burst = TRUE
	playsound(epicenter, 'sound/items/firesnuff.ogg', 70, TRUE)
	for(var/turf/T in range(smoke_range, epicenter))
		if(T.density)
			continue
		new /obj/effect/particle_effect/smoke/pyro_screen(T)

/obj/projectile/magic/smoke_burst/on_hit(atom/target, blocked = FALSE)
	. = ..()
	burst_smoke(get_turf(target))

/obj/projectile/magic/smoke_burst/on_range()
	burst_smoke(get_turf(src))
	. = ..()

/obj/effect/particle_effect/smoke/pyro_screen
	lifetime = 7
