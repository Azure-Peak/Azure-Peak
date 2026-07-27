#define MT_FROST_SHARD "frost_shard"
#define FROST_SHARD_DR_DURATION 1 SECONDS

/datum/action/cooldown/spell/projectile/frost_bolt
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Frost Shards"
	desc = "Loose a concentrated spray of frozen shards. The shards lose damage and efffects past 4 paces . \
	The first shard to hit a foe deals full damage and applies a stack of frost - further shards from the same volley deals slight damage, and do not stack more frost. \
	Damage is increased by 100% versus simple-minded creechurs."
	button_icon_state = "frost_bolt"
	sound = 'sound/spellbooks/icicle.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/frost_shard
	projectile_type_arc = /obj/projectile/magic/frost_shard/arc
	cast_range = SPELL_RANGE_PROJECTILE
	projectiles_per_fire = 5
	var/spread_step = 8

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Fragmenta Glaciei!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_swingdelay_duration = 6 SECONDS
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 6 SECONDS
	attunement_school = ASPECT_NAME_CRYOMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 3
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/projectile/frost_bolt/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/base_angle = to_fire.Angle
	if(isnull(base_angle))
		base_angle = Get_Angle(user, target)
	var/center_index = (projectiles_per_fire + 1) / 2
	to_fire.Angle = base_angle + ((iteration - center_index) * spread_step)

/obj/projectile/magic/frost_shard
	name = "frost shard"
	expose_caster_on_deflect = TRUE
	icon_state = "ice_2"
	damage = 35
	npc_simple_damage_mult = 2
	damage_type = BURN
	woundclass = BCLASS_BURN
	flag = "fire"
	range = 7
	max_range = 4
	suppress_effects_past_range = TRUE
	speed = MAGE_PROJ_FAST
	nodamage = FALSE
	var/reduced_damage = 9
	var/repeat_hit = FALSE

/obj/projectile/magic/frost_shard/arc
	name = "arced frost shard"
	damage = 30
	reduced_damage = 8
	arcshot = TRUE

/obj/projectile/magic/frost_shard/prehit(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M == firer)
			return ..()
		if(M.mob_timers[MT_FROST_SHARD] && world.time < M.mob_timers[MT_FROST_SHARD] + FROST_SHARD_DR_DURATION)
			damage = reduced_damage
			repeat_hit = TRUE
		else
			M.mob_timers[MT_FROST_SHARD] = world.time
	return ..()

/obj/projectile/magic/frost_shard/on_hit(target, blocked = FALSE)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with \the [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target) && !repeat_hit && !out_of_effective_range() && blocked < 100)
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

/obj/projectile/magic/frostbolt
	name = "frost bolt"
	expose_caster_on_deflect = TRUE
	icon_state = "ice_2"
	damage = 30
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
	damage = 23
	arcshot = TRUE

/obj/projectile/magic/frostbolt/on_hit(target, blocked = FALSE)
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
			if(out_of_effective_range())
				return
			if(blocked >= 100)
				return
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

#undef MT_FROST_SHARD
#undef FROST_SHARD_DR_DURATION
