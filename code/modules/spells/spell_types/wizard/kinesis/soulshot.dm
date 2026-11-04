#define SOULSHOT_BASE_DAMAGE SPELL_DMG(80)
#define SOULSHOT_PIERCE_DAMAGE_MULT 0.75
/obj/projectile/magic/soulshot
	name = "soulshot"
	tracer_type = /obj/effect/projectile/tracer/bloodsteal
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = SOULSHOT_BASE_DAMAGE
	damage_type = BRUTE
	woundclass = BCLASS_STAB
	nodamage = FALSE
	intdamfactor = SPELL_INTDAM(1)
	spell_damage_scaled = TRUE
	speed = 0.3
	flag = "piercing"
	hitsound = 'sound/magic/obeliskbeam.ogg'
	light_color = "#9400D3"
	light_outer_range = 7
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	/// How many mob targets have been hit so far.
	var/hits = 0
	/// Maximum mob targets before the beam stops.
	var/max_hits = 4

/obj/projectile/magic/soulshot/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	// Only pierce through mobs, not solid objects
	if(!ismob(target))
		qdel(src)
		return . || BULLET_ACT_HIT
	hits++
	// Halve damage after the first target
	if(hits <= 1)
		damage = SOULSHOT_BASE_DAMAGE
	else
		damage = round(SOULSHOT_BASE_DAMAGE * SOULSHOT_PIERCE_DAMAGE_MULT)
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE

#undef SOULSHOT_BASE_DAMAGE
#undef SOULSHOT_PIERCE_DAMAGE_MULT
