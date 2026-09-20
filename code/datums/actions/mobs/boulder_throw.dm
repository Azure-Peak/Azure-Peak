/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/boulder_throw
	name = "Boulder Throw"
	desc = "Rips a boulder out of the earth and hurls it."
	button_icon_state = "boulder_throw"
	cooldown_time = 25 SECONDS
	lockout_time = 25 SECONDS
	npc_min_range = 3
	npc_max_range = 12
	cast_range = 12
	required_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	windup_time = TELEGRAPH_HIGH_IMPACT
	telegraph_sound = list('sound/combat/ground_smash_start.ogg')
	telegraph_type = /obj/effect/temp_visual/telegraph

	blast_radius = 2
	damage = 75
	damage_structures = TRUE
	structure_damage = 75
	knockdown_on_hit = 1 SECONDS
	strike_sound = null
	hit_sound = list('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
	impact_sound = list('sound/misc/explode/explosionfar (1).ogg')
	rock_type = /obj/effect/temp_visual/thrown_boulder

	var/list/ring_damage_mult = list(1, 0.6, 0.2)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/boulder_throw/get_sweep_bands()
	var/list/centre = list(list(0, 0))
	var/list/inner = list()
	var/list/outer = list()
	for(var/x in -blast_radius to blast_radius)
		for(var/y in -blast_radius to blast_radius)
			var/ring = max(abs(x), abs(y))
			if(!ring)
				continue
			if(ring == 1)
				inner += list(list(x, y))
			else
				outer += list(list(x, y))
	return list(centre, inner, outer)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/boulder_throw/get_strike_damage()
	. = ..()
	if(length(ring_damage_mult))
		. *= ring_damage_mult[clamp(band_index, 1, length(ring_damage_mult))]

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/boulder_throw/cast(atom/cast_on)
	. = ..()
	if(!.)
		return
	var/datum/action/cooldown/spell/troll_shove/shove = locate() in owner.actions
	if(shove)
		shove.consecutive = 0

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/boulder_throw/on_pattern_turf(turf/T, mob/living/H, facing)
	var/obj/effect/temp_visual/special_intent/shatter = new (T, 0.6 SECONDS)
	shatter.icon = 'icons/effects/effects.dmi'
	shatter.icon_state = "sweep_fx"
	if(band_index > 1)
		shatter.alpha = 150

/datum/action/cooldown/spell/troll_shove
	name = "Shove"
	desc = "Clears some space with a backhand."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "shove"
	panel = null
	cooldown_time = 0.7 SECONDS
	npc_max_range = 2
	use_chance = 100
	shared_cooldown = "mob_special"
	lockout_time = 0
	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	self_cast_possible = FALSE
	charge_required = FALSE
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE

	var/consecutive = 0
	var/escalation = 1 SECONDS
	var/max_cooldown = 10 SECONDS

/datum/action/cooldown/spell/troll_shove/can_use(atom/target)
	if(!..())
		return FALSE
	if(!isliving(target))
		return FALSE
	var/mob/living/victim = target
	return !victim.incapacitated()

/// The escalating cooldown is set in cast(); stop Activate() from stamping the flat one over it.
/datum/action/cooldown/spell/troll_shove/before_cast(atom/cast_on)
	return ..() | SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/troll_shove/cast(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/troll = owner
	var/mob/living/victim = cast_on
	troll.visible_message(span_danger("<b>[troll]</b> shoves [victim] back to clear some space!"))
	playsound(troll, 'sound/combat/flail_sweep_hit_minor.ogg', 80, TRUE)
	victim.apply_status_effect(/datum/status_effect/debuff/vulnerable, 4 SECONDS)
	victim.throw_at(get_edge_target_turf(victim, get_dir(troll, victim)), 4, 2, troll)
	consecutive++
	StartCooldownSelf(min(cooldown_time + (consecutive - 1) * escalation, max_cooldown))
	return TRUE

/obj/effect/temp_visual/thrown_boulder
	name = "massive boulder"
	desc = "A terrifyingly huge slab of rock rocketing through the air."
	icon = 'icons/roguetown/weapons/ranged/arrow_proj.dmi'
	icon_state = "boulder"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
