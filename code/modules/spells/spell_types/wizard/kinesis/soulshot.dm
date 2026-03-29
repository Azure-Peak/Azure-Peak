/datum/action/cooldown/spell/projectile/soulshot
	button_icon = 'icons/mob/actions/mage_shared.dmi'
	name = "Soulshot"
	desc = "Fire a devastating beam of kinetic force that pierces through up to 4 targets. Stopped by solid objects. \
	Damage is halved after the first target. \
	Deals 50% increased damage to simple-minded creechurs. \
	Basic offensive magic, refined for over a millenium since the first Magi expelled mana from their body with pure malice and determination to destroy another."
	fluff_desc = "Basic offensive magic, refined for over two millenium since the first Magi expelled mana from their body with pure malice and determination to destroy another. The natural evolution of the arcyne bolt - a barely held together ball of energy - into a focused beam of destructive force. The name 'soulshot' is derived from the original idea that one must put their soul into it to exert such a powerful projectiles. Its alignment - of pure arcynic energy, means that most magis cannot cast the spell when they are attuned to a 'unpure' aspect - like fire or lightning. Instead, this spell is generally used when one is attuned to Augmentation - one's own body, or Kinesis - the usage of motional force to displace your foes."
	button_icon_state = "soulshot"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/soulshot
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Animus Ictus!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 8 SECONDS
	is_implement_scaled_spell = TRUE
	attunement_school = ASPECT_NAME_KINESIS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

/obj/projectile/magic/soulshot
	name = "soulshot"
	tracer_type = /obj/effect/projectile/tracer/bloodsteal
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	guard_deflectable = TRUE
	damage = 80
	damage_type = BRUTE
	woundclass = BCLASS_STAB
	npc_simple_damage_mult = 1.5
	accuracy = 40
	nodamage = FALSE
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
	if(hits == 1)
		damage = round(damage * 0.5)
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE
