/datum/action/cooldown/spell/projectile/spitfire
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "Spitfire"
	desc = "Shoot out a low-powered ball of fire that ignites a target with a small amount of fire on impact. \
	Damage is increased by 100% versus simple-minded creechurs. \
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	button_icon_state = "spitfire"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/aoe/fireball/spitfire
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/spitfire/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Evomere Flammas!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 5.5 SECONDS
	is_implement_scaled_spell = TRUE
	attunement_school = ASPECT_NAME_PYROMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

/obj/projectile/magic/aoe/fireball/spitfire
	name = "spitfire"
	speed = MAGE_PROJ_MEDIUM
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 0
	damage = 30
	npc_simple_damage_mult = 2
	accuracy = 40
	damage_type = BURN
	woundclass = BCLASS_BURN
	nodamage = FALSE
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0

/obj/projectile/magic/aoe/fireball/spitfire/arc
	name = "arced spitfire"
	damage = 23
	arcshot = TRUE

/obj/projectile/magic/aoe/fireball/spitfire/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(has_frost_stacks(M))
			remove_frost_stack(M)
			visible_message(span_warning("The fire thaws the frost on [target]!"))
			playsound(get_turf(target), 'sound/items/firesnuff.ogg', 100)
			new /obj/effect/temp_visual/snap_freeze(get_turf(M))
		M.adjust_fire_stacks(1)
		M.ignite_mob()
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()
