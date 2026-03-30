/datum/action/cooldown/spell/projectile/arc_bolt
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Arc Bolt"
	desc = "Fire a quick jolt of lightning at a target. Deals less damage than most other minor offensive spells, but strikes instantly. \
	Toggle arc mode (Ctrl+G) to lob over obstacles at reduced damage. \
	Damage is increased by 100% versus simple-minded creechurs."
	button_icon_state = "shock"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/arc_bolt
	projectile_type_arc = /obj/projectile/magic/arc_bolt/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Fulgur!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 6.5 SECONDS
	is_implement_scaled_spell = TRUE
	attunement_school = ASPECT_NAME_FULGURMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

/obj/projectile/magic/arc_bolt
	name = "arc bolt"
	tracer_type = /obj/effect/projectile/tracer/wormhole
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = LIGHT_COLOR_WHITE
	damage = 30
	npc_simple_damage_mult = 2
	damage_type = BURN
	woundclass = BCLASS_BURN
	accuracy = 40
	nodamage = FALSE
	guard_deflectable = TRUE
	speed = 0.3
	flag = "fire"
	light_outer_range = 5

/obj/projectile/magic/arc_bolt/arc
	name = "arced arc bolt"
	damage = 22
	arcshot = TRUE

/obj/projectile/magic/arc_bolt/on_hit(target)
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
			L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
	qdel(src)
