/datum/action/cooldown/spell/projectile/rimecast
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Rimecast"
	desc = "Conjure ice and hurl it in one of two forms. Lance drives a single spear straight ahead, punching through up to three foes in a line, leaving two stacks of frost on each. \
	Burst lobs an arcing shard that shatters on impact in a 3x3 area, dealing 66% damage to non primary targets while leaving one stack of frost on all of them. \
	Toggle firing mode (Shift+G) while the spell is active: Lance or Burst."
	button_icon_state = "ice_burst"
	sound = 'sound/spellbooks/icicle.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_CRYOMANCY

	projectile_type = /obj/projectile/magic/ice_lance
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 6
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Hasta Glaciei!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 16 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Ice Lance", "tag" = "LANCE", "proj" = /obj/projectile/magic/ice_lance, "sound" = 'sound/spellbooks/icicle.ogg', "invocation" = "Hasta Glaciei!"),
		list("name" = "Ice Burst", "tag" = "BURST", "proj" = /obj/projectile/magic/ice_burst, "sound" = 'sound/spellbooks/crystal.ogg', "invocation" = "Glacies Frangor!"),
	)

/datum/action/cooldown/spell/projectile/rimecast/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/rimecast/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
	sound = mode["sound"]
	invocations = list(mode["invocation"])
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/rimecast/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))

/datum/action/cooldown/spell/projectile/rimecast/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.color = "#00ccff"

/datum/action/cooldown/spell/projectile/rimecast/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("Firing mode (toggle with Shift+G): Ice Lance (Pierces up to 3 foes for 2 frost each) / Ice Burst (arced 3x3 shatter for 1 frost).")
	return stats

/obj/projectile/magic/ice_lance
	name = "ice lance"
	expose_caster_on_deflect = TRUE
	icon_state = "u_laser"
	damage = 90
	npc_simple_damage_mult = 2
	damage_type = BURN
	woundclass = BCLASS_BURN
	flag = "fire"
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_MEDIUM
	movement_type = UNSTOPPABLE
	nodamage = FALSE
	/// How many mob targets have been pierced
	var/hits = 0
	/// Max mob targets before the lance shatters
	var/max_hits = 3

/obj/projectile/magic/ice_lance/on_hit(target, blocked = FALSE)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] shatters on contact with \the [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(!out_of_effective_range() && blocked < 100)
			if(L.on_fire)
				L.adjust_fire_stacks(-1)
				L.visible_message(span_warning("The frost dampens the flames on [L]!"))
			apply_frost_stack(L, 2)
			playsound(get_turf(L), pick('sound/combat/fracture/fracturedry (1).ogg', 'sound/combat/fracture/fracturedry (2).ogg', 'sound/combat/fracture/fracturedry (3).ogg'), 80, TRUE)
			new /obj/effect/temp_visual/snap_freeze(get_turf(L))
		hits++
		if(hits >= max_hits)
			qdel(src)
			return . || BULLET_ACT_HIT
		return BULLET_ACT_FORCE_PIERCE
	else if(isobj(target))
		var/obj/O = target
		O.extinguish()
		var/turf/target_turf = get_turf(target)
		var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in target_turf)
		if(hotspot)
			new /obj/effect/temp_visual/small_smoke(target_turf)
			qdel(hotspot)
	qdel(src)
	return . || BULLET_ACT_HIT

/obj/projectile/magic/ice_burst
	name = "ice burst"
	expose_caster_on_deflect = TRUE
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "wipe"
	speed = MAGE_PROJ_VERY_SLOW
	damage = 90
	damage_type = BURN
	woundclass = BCLASS_BURN
	npc_simple_damage_mult = 2
	nodamage = FALSE
	flag = "fire"
	arcshot = TRUE
	hitsound = 'sound/blank.ogg'
	/// Radius for AOE blast around impact point
	var/aoe_radius = 1
	/// AOE damage as a fraction of the projectile's base damage
	var/aoe_damage_ratio = 0.66

/obj/projectile/magic/ice_burst/on_hit(target, blocked = FALSE)
	..()
	var/mob/living/M = ismob(target) ? target : null

	if(M?.anti_magic_check())
		visible_message(span_warning("[src] fizzles on contact with \the [target]!"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK

	if(out_of_effective_range())
		return

	var/aoe_damage = round(damage * aoe_damage_ratio)
	var/turf/epicenter = get_turf(target)

	if(epicenter)
		playsound(epicenter, 'sound/spellbooks/crystal.ogg', 100, TRUE, 6)
		playsound(epicenter, pick('sound/combat/fracture/fracturedry (1).ogg', 'sound/combat/fracture/fracturedry (2).ogg', 'sound/combat/fracture/fracturedry (3).ogg'), 80, TRUE)

	if(aoe_radius > 0 && istype(firer, /mob/living/carbon/human))
		var/mob/living/carbon/human/caster = firer
		var/mob/living/direct_hit = M
		for(var/turf/T in range(aoe_radius, epicenter))
			new /obj/effect/temp_visual/snap_freeze(T)
			// Extinguish burning objects and hotspots in the blast radius
			for(var/obj/O in T)
				O.extinguish()
			var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in T)
			if(hotspot)
				new /obj/effect/temp_visual/small_smoke(T)
				qdel(hotspot)
			for(var/mob/living/L in T)
				if(L == direct_hit || L.stat == DEAD)
					continue
				if(L.anti_magic_check())
					continue
				if(L.guard_deflect_spell("Ice Burst", TRUE, caster))
					continue
				arcyne_strike(caster, L, null, aoe_damage, BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "Ice Burst (Shatter)", \
					allow_shield_check = TRUE, damage_type = BURN, \
					npc_simple_damage_mult = npc_simple_damage_mult, \
					skip_animation = TRUE)
				apply_frost_stack(L, 1)
				new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_ICE, SPELL_IMPACT_MEDIUM)

	// Apply frost to direct hit target (AOE loop skips them)
	if(isliving(target) && blocked < 100)
		var/mob/living/L = target
		if(L.on_fire)
			L.adjust_fire_stacks(-1)
			L.visible_message(span_warning("The frost dampens the flames on [L]!"))
		apply_frost_stack(L, 1)

	qdel(src)
	return TRUE
