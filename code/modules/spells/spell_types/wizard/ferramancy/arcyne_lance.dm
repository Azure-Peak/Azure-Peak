/datum/action/cooldown/spell/projectile/arcyne_lance
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	name = "Arcyne Lance"
	desc = "Hurl a spectral arcyne lance that pierces through up to 3 targets without losing momentum. \
	Toggle arc mode (Ctrl+G) to lob over obstacles at reduced damage. Arced projectiles will not pierce multiple targets."
	button_icon_state = "arcyne_lance"
	sound = 'sound/magic/scrapeblade.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_FERRAMANCY

	projectile_type = /obj/projectile/magic/arcyne_lance
	projectile_type_arc = /obj/projectile/magic/arcyne_lance/arc
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Hastae Ferri!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5.5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

// --- Arcyne spear projectile ---

/obj/projectile/magic/arcyne_lance
	name = "arcyne lance"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "air_blade_stab"
	guard_deflectable = TRUE
	damage = 55
	damage_type = BRUTE
	woundclass = BCLASS_STAB
	npc_simple_damage_mult = 1.5
	nodamage = FALSE
	speed = MAGE_PROJ_MEDIUM
	armor_penetration = PEN_LIGHT
	movement_type = UNSTOPPABLE
	range = SPELL_RANGE_PROJECTILE
	flag = "piercing"
	hitsound = 'sound/combat/hits/bladed/genthrust (1).ogg'
	/// How many mob targets have been pierced
	var/hits = 0
	/// Max mob targets before stopping
	var/max_hits = 3

/obj/projectile/magic/arcyne_lance/arc
	name = "arced arcyne lance"
	damage = 45
	arcshot = TRUE
	max_hits = 1 // Arced version does not pierce

/obj/projectile/magic/arcyne_lance/on_hit(target)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] shatters on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		playsound(get_turf(target), 'sound/combat/hits/bladed/genthrust (1).ogg', 80, TRUE)
	. = ..()
	// Pierce through mobs, stop on solids
	if(!ismob(target))
		qdel(src)
		return . || BULLET_ACT_HIT
	hits++
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE
