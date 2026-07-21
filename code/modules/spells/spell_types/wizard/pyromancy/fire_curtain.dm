#define CURTAIN_TICK_DAMAGE 30
#define CURTAIN_BURN_KEY "curtain_burn"

/datum/action/cooldown/spell/fire_curtain
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "Fire Curtain"
	desc = "Conjure a 5x2 curtain of flame at a target location, perpendicular to your facing. \
	After a 2-second telegraph, the fire erupts. Burning for 10 seconds. \
	The fire does not block movement but will burn anything that passes through or stands in it. \
	You are not immune to your own curtain."
	button_icon_state = "fire_curtain"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_PYROMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Velum Ignis!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 1 SECONDS
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/curtain_width = 5
	var/curtain_depth = 2
	var/curtain_life = 10 SECONDS
	var/telegraph_time = 3 SECONDS

/datum/action/cooldown/spell/fire_curtain/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("Damage: [CURTAIN_TICK_DAMAGE] burn per second (up to [DisplayTimeText(curtain_life)] in the flames)")
	return stats

/datum/action/cooldown/spell/fire_curtain/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/list/affected_turfs = get_curtain_turfs(center, H.dir)

	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/trap_wall/fire(T)

	H.visible_message(span_danger("[H] conjures a wall of flame!"))
	playsound(get_turf(H), 'sound/magic/charging_fire.ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(spawn_curtain), affected_turfs, H, H.zone_selected), telegraph_time)
	return TRUE

/datum/action/cooldown/spell/fire_curtain/proc/get_curtain_turfs(turf/center, facing)
	var/list/row_turfs = list(center)
	var/spread_dir1
	var/spread_dir2
	if(facing == NORTH || facing == SOUTH)
		spread_dir1 = WEST
		spread_dir2 = EAST
	else
		spread_dir1 = NORTH
		spread_dir2 = SOUTH

	var/half = (curtain_width - 1) / 2
	var/turf/current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir1)
		if(current)
			row_turfs += current
	current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir2)
		if(current)
			row_turfs += current

	// Extend depth along the facing direction
	var/list/all_turfs = row_turfs.Copy()
	for(var/d in 1 to curtain_depth - 1)
		var/list/next_row = list()
		for(var/turf/T in row_turfs)
			var/turf/deep = get_step(T, facing)
			if(deep)
				all_turfs |= deep
				next_row += deep
		row_turfs = next_row
	return all_turfs

/datum/action/cooldown/spell/fire_curtain/proc/spawn_curtain(list/turfs, mob/living/caster, aim_zone)
	if(QDELETED(src) || QDELETED(owner))
		return
	for(var/turf/T in turfs)
		new /obj/effect/curtain_fire(T, curtain_life, caster, aim_zone)
	playsound(turfs[1], pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 120, TRUE, 6)

/obj/effect/temp_visual/trap_wall/fire
	color = GLOW_COLOR_FIRE
	light_color = GLOW_COLOR_FIRE
	duration = 3 SECONDS

/obj/effect/curtain_fire
	name = "wall of flame"
	desc = "A searing curtain of conjured fire."
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_outer_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	object_slowdown = 15
	var/lifetime = 10 SECONDS
	var/tick_damage = CURTAIN_TICK_DAMAGE
	var/burn_cooldown = 1 SECONDS
	var/datum/weakref/caster_ref
	var/aim_zone

/obj/effect/curtain_fire/Initialize(mapload, life, mob/living/new_caster, aimed_zone)
	. = ..()
	if(life)
		lifetime = life
	if(new_caster)
		caster_ref = WEAKREF(new_caster)
	aim_zone = aimed_zone
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, lifetime)

/obj/effect/curtain_fire/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/curtain_fire/Crossed(atom/movable/AM, oldLoc)
	. = ..()
	if(isliving(AM))
		burn_occupant(AM)

/obj/effect/curtain_fire/process(seconds_per_tick)
	var/turf/T = get_turf(src)
	if(!isturf(T))
		return
	for(var/mob/living/L in T)
		burn_occupant(L)

/obj/effect/curtain_fire/proc/burn_occupant(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_NOFIRE))
		return
	if(L.mob_timers[CURTAIN_BURN_KEY] && world.time < L.mob_timers[CURTAIN_BURN_KEY])
		return
	L.mob_timers[CURTAIN_BURN_KEY] = world.time + burn_cooldown
	var/hit_zone = aim_zone || BODY_ZONE_CHEST
	var/mob/living/carbon/human/caster = caster_ref?.resolve()
	if(istype(caster) && !QDELETED(caster))
		arcyne_strike(caster, L, null, tick_damage, hit_zone, BCLASS_BURN, spell_name = "Fire Curtain", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE)
	else
		var/fallback_zone = check_zone(hit_zone)
		var/armor_block = L.run_armor_check(fallback_zone, "fire", blade_dulling = BCLASS_BURN, damage = tick_damage, flat_integ = TRUE)
		L.apply_damage(tick_damage, BURN, fallback_zone, armor_block)
	apply_scorch_stack(L, 1, hit_zone)
	L.emote("pain", forced = TRUE)

#undef CURTAIN_TICK_DAMAGE
#undef CURTAIN_BURN_KEY
