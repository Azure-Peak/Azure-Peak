// This is for legacy poke spell, as the shotgun is designed for Cryo which has less spell as a budget
#define FROST_BOLT_DAMAGE 50 // Making it symmetrical with spitfire
#define FROST_BOLT_ARC_DAMAGE 38

/datum/action/cooldown/spell/projectile/frostbolt
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Frost Bolt"
	desc = "A shard of frozen energy that slows and damages a target. \
	Applies one stack of frost on hit. \
	Toggle arc mode (Shift+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
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
	charge_swingdelay_type = SWINGDELAY_NORMAL
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5.5 SECONDS
	attunement_school = ASPECT_NAME_CRYOMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/frostbolt
	name = "frost bolt"
	expose_caster_on_deflect = TRUE
	icon_state = "ice_2"
	damage = SPELL_DMG(FROST_BOLT_DAMAGE)
	intdamfactor = SPELL_INTDAM(1)
	spell_damage_scaled = TRUE
	damage_type = BURN
	woundclass = BCLASS_BURN
	flag = "fire"
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_FAST
	nodamage = FALSE

/obj/projectile/magic/frostbolt/arc
	name = "arced frost bolt"
	damage = SPELL_DMG(FROST_BOLT_ARC_DAMAGE)
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

#undef FROST_BOLT_DAMAGE
#undef FROST_BOLT_ARC_DAMAGE
