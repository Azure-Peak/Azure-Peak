/datum/action/cooldown/spell/projectile/frost_bolt
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Frost Bolt"
	desc = "A shard of frozen energy that slows and damages a target. \
	Applies one stack of frost on hit. \
	Damage is increased by 100% versus simple-minded creechurs. \
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	button_icon_state = "frost_bolt"
	sound = 'sound/spellbooks/icicle.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/frostbolt
	projectile_type_arc = /obj/projectile/magic/frostbolt/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Sagitta Glaciei!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5.5 SECONDS
	attunement_school = ASPECT_NAME_CRYOMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 3
	spell_impact_intensity = SPELL_IMPACT_LOW

/obj/projectile/magic/frostbolt
	name = "frost bolt"
	icon_state = "ice_2"
	damage = 28
	npc_simple_damage_mult = 2
	damage_type = BURN
	woundclass = BCLASS_BURN
	flag = "fire"
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_FAST
	accuracy = 40
	nodamage = FALSE

/obj/projectile/magic/frostbolt/arc
	name = "arced frost bolt"
	damage = 21
	arcshot = TRUE

/obj/projectile/magic/frostbolt/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with \the [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(L.on_fire)
				L.adjust_fire_stacks(-1)
				L.visible_message(span_warning("The frost dampens the flames on [L]!"))
			apply_frost_stack(L)
			playsound(get_turf(L), pick('sound/combat/fracture/fracturedry (1).ogg', 'sound/combat/fracture/fracturedry (2).ogg', 'sound/combat/fracture/fracturedry (3).ogg'), 80, TRUE)
			new /obj/effect/temp_visual/snap_freeze(get_turf(L))
	else if(isobj(target))
		var/obj/O = target
		O.extinguish()
		var/turf/target_turf = get_turf(target)
		var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in target_turf)
		if(hotspot)
			new /obj/effect/temp_visual/small_smoke(target_turf)
			qdel(hotspot)
	qdel(src)
