// Lightning Bolt - Fulgurmancy staple hitscan CC spell
// Hitscan projectile that immobilizes and applies lightningstruck (speed -2 for 6s)
// Has lightning adaptation: ALL CC effects cannot be reapplied within 15 seconds
/datum/action/cooldown/spell/projectile/lightning_bolt
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Bolt of Lightning"
	desc = "Emit a bolt of lightning that burns a target, slowing them down and impairing their accuracy for 6 seconds. \
	Damage is increased by 100% versus simple-minded creechurs. \
	The CC effects cannot be reapplied to the same target within 15 seconds."
	button_icon_state = "lightning_bolt"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_FULGURMANCY

	projectile_type = /obj/projectile/magic/lightning
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Fulmen!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/lightning
	name = "bolt of lightning"
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	light_color = LIGHT_COLOR_WHITE
	damage = 60
	npc_simple_damage_mult = 2
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	flag = "fire"
	light_outer_range = 7

/obj/projectile/magic/lightning/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(out_of_effective_range())
				return
			L.lightning_shock(src)
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()
	qdel(src)
