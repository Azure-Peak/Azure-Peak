/obj/effect/temp_visual/telegraph/marker
	light_color = GLOW_COLOR_EARTHEN
	light_outer_range = 2
	duration = 1.5 SECONDS

/obj/effect/temp_visual/stomp
	icon = 'icons/effects/effects.dmi'
	icon_state = "phaseout"
	light_outer_range = 2
	duration = 5
	layer = ABOVE_ALL_MOB_LAYER

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam
	blade_class = BCLASS_BLUNT
	strike_damage_type = BRUTE
	strike_armor_pen = PEN_NONE
	strike_sound = null
	detonate_sound = null
	damage_structures = TRUE
	hit_sound = list('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
	var/exposed_on_hit = 6 SECONDS
	var/victim_slowdown = 0
	var/list/band_sound = list('sound/combat/ground_smash1.ogg','sound/combat/ground_smash2.ogg','sound/combat/ground_smash3.ogg')

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/on_band_start(mob/living/H, band)
	if(length(band_sound))
		playsound(get_turf(H), band_sound, 100, TRUE)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/on_pattern_turf(turf/T, mob/living/H, facing)
	var/obj/effect/temp_visual/special_intent/fx = new (T, 0.5 SECONDS)
	fx.icon = 'icons/effects/effects.dmi'
	fx.icon_state = "sweep_fx"

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/on_hit_target(mob/living/H, mob/living/L, facing)
	if(exposed_on_hit)
		L.apply_status_effect(/datum/status_effect/debuff/exposed, exposed_on_hit)
	if(victim_slowdown)
		L.Slowdown(victim_slowdown)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/sunder
	name = "Sunder"
	desc = "Slams both fists down, leaving anything hit wide open."
	button_icon_state = "ground_slam"
	cooldown_time = 12 SECONDS
	npc_max_range = 2
	use_chance = 55
	required_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	windup_time = TELEGRAPH_HIGH_IMPACT
	freeze_cast = FALSE
	track_target = TRUE
	telegraph_sound = list('sound/combat/ground_smash_start.ogg')
	sweep_step = 3
	recovery_time = 2 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM

	damage = 55
	structure_damage = 55
	victim_slowdown = 2

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/sunder/get_sweep_bands()
	var/list/front = list(list(0, 1))
	var/list/spread = list(list(-1, 1), list(1, 1), list(0, 2))
	return list(front, spread)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/stomp
	name = "Stomp"
	desc = "Drives a foot down, rupturing the ground all around it."
	button_icon_state = "ground_slam"
	cooldown_time = 20 SECONDS
	npc_max_range = 2
	use_chance = 60
	self_targetable = TRUE
	required_zones = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	windup_time = TELEGRAPH_AREA_DENIAL
	lock_direction = FALSE
	track_target = FALSE
	freeze_cast = TRUE
	telegraph_sound = list('sound/combat/ground_smash_start.ogg')
	sweep_step = 2
	recovery_time = 3 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_HEAVY

	damage = 60
	structure_damage = 60
	exposed_on_hit = 8 SECONDS
	victim_slowdown = 3
	band_sound = list('sound/misc/bamf.ogg')

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/stomp/get_sweep_bands()
	var/list/inner = list()
	var/list/outer = list()
	for(var/x in -2 to 2)
		for(var/y in -2 to 2)
			var/ring = max(abs(x), abs(y))
			if(!ring)
				continue
			if(ring == 1)
				inner += list(list(x, y))
			else
				outer += list(list(x, y))
	return list(inner, outer)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/stomp/get_strike_damage()
	. = ..()
	if(band_index > 1)
		. *= 0.5

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/stomp/on_pattern_turf(turf/T, mob/living/H, facing)
	new /obj/effect/temp_visual/stomp(T)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/quake
	name = "Quake"
	desc = "Ruptures the ground under a distant foe and throws up rubble."
	button_icon_state = "ground_slam"
	cooldown_time = 20 SECONDS
	npc_min_range = 2
	npc_max_range = 7
	cast_range = 7
	use_chance = 50
	required_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	windup_time = TELEGRAPH_AREA_DENIAL
	telegraph_type = /obj/effect/temp_visual/telegraph/marker
	telegraph_sound = list('sound/combat/ground_smash_start.ogg')
	recovery_time = 3 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM

	blast_radius = 1
	damage = 35
	blade_class = BCLASS_BLUNT
	strike_armor_pen = PEN_NONE
	damage_structures = TRUE
	structure_damage = 35
	strike_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	detonate_sound = null
	hit_sound = list('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
	var/victim_slowdown = 4
	// We don't want to actually cage in the victim, that'd be lame
	var/rubble_type = /obj/structure/flora/rock
	var/rubble_duration = 20 SECONDS
	var/rubble_count = 3

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/quake/on_impact(mob/living/H, facing, atom/movable/visual)
	if(!locked_turf)
		return
	playsound(locked_turf, 'sound/combat/hits/onstone/wallhit.ogg', 100, TRUE)
	for(var/mob/living/shaken in view(blast_radius, locked_turf))
		shake_camera(shaken, 5, 5)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/quake/on_hit_target(mob/living/H, mob/living/L, facing)
	to_chat(L, span_danger("<B>The ground ruptures beneath my feet!</B>"))
	if(victim_slowdown)
		L.Slowdown(victim_slowdown)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/quake/on_strike_complete(mob/living/H, hit_count, deflected)
	. = ..()
	if(!rubble_type || !locked_turf || rubble_count <= 0)
		return
	var/list/candidates = list()
	for(var/turf/open/T in RANGE_TURFS(blast_radius, locked_turf))
		if(T.is_blocked_turf() || (locate(/mob/living) in T))
			continue
		candidates += T
	for(var/i in 1 to min(rubble_count, length(candidates)))
		var/obj/structure/rubble = new rubble_type(pick_n_take(candidates))
		QDEL_IN(rubble, rubble_duration)

/datum/action/cooldown/spell/projectile/earthen_chunk
	name = "Earthen Chunk"
	desc = "Hurls a chunk of your own body at a distant foe."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "stone_throw"
	panel = null
	use_chance = 45
	shared_cooldown = "mob_special"
	lockout_time = 4 SECONDS
	cooldown_time = 10 SECONDS
	npc_min_range = 3
	npc_max_range = 9
	cast_range = 10
	required_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	self_cast_possible = FALSE
	invocations = list()
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE
	glow_intensity = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	blocked_by_antimagic = FALSE

	charge_required = TRUE
	charge_time = TELEGRAPH_HIGH_IMPACT
	charge_sound = null
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	freeze_cast = TRUE
	telegraph_sound = list('sound/foley/smash_rock.ogg')

	projectile_type = /obj/projectile/earthenchunk

/datum/action/cooldown/spell/projectile/earthen_chunk/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/obj/projectile/earthenchunk/chunk = to_fire
	if(istype(chunk))
		chunk.thrower = WEAKREF(user)
