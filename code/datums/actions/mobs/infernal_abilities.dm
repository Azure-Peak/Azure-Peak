/obj/effect/temp_visual/telegraph/hellfire
	light_color = GLOW_COLOR_FIRE
	light_outer_range = 2
	duration = 2 SECONDS

/*
*/
/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/meteor_storm
	name = "Meteor Storm"
	desc = "Calls a rain of burning rock down onto a patch of ground."
	button_icon_state = "meteor_storm"
	cooldown_time = 25 SECONDS
	lockout_time = 8 SECONDS
	npc_min_range = 2
	npc_max_range = 9
	cast_range = 9
	use_chance = 55
	required_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	windup_time = TELEGRAPH_ULTIMATE
	telegraph_type = /obj/effect/temp_visual/telegraph/hellfire
	telegraph_sound = list('sound/magic/meteorstorm.ogg')
	recovery_time = 3 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM

	blast_radius = 3
	damage = 45
	strike_damage_type = BURN
	blade_class = BCLASS_BURN
	strike_armor_pen = PEN_NONE
	damage_structures = TRUE
	structure_damage = 45
	strike_sound = null
	detonate_sound = null
	hit_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')
	var/scorch_stacks = 2
	var/victim_slowdown = 2

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/meteor_storm/on_impact(mob/living/H, facing, atom/movable/visual)
	if(!locked_turf)
		return
	playsound(locked_turf, 'sound/magic/fireball.ogg', 100, TRUE, 6)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/meteor_storm/on_pattern_turf(turf/T, mob/living/H, facing)
	new /obj/effect/temp_visual/dragonfire(T)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/meteor_storm/on_hit_target(mob/living/H, mob/living/L, facing)
	if(scorch_stacks)
		apply_scorch_stack(L, scorch_stacks)
	if(victim_slowdown)
		L.Slowdown(victim_slowdown)

/*
*/
/datum/action/cooldown/spell/call_infernals
	name = "Call Infernals"
	desc = "Drags lesser infernals through the veil to fight alongside it."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 40
	shared_cooldown = "mob_special"
	lockout_time = 6 SECONDS
	cooldown_time = 40 SECONDS
	npc_min_range = 0
	npc_max_range = 9
	self_targetable = TRUE
	required_zones = list(BODY_ZONE_HEAD)

	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	self_cast_possible = TRUE
	invocations = list()
	invocation_type = INVOCATION_NONE
	sound = list('sound/magic/whiteflame.ogg')
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE
	glow_intensity = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	blocked_by_antimagic = FALSE
	charge_required = FALSE

	var/list/spawn_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
	)
	var/summon_count = 2
	/// Hard ceiling on how many of its own summons can be alive at once.
	var/max_alive = 4
	var/list/spawned

/datum/action/cooldown/spell/call_infernals/proc/live_count()
	var/list/still_up = list()
	for(var/datum/weakref/ref as anything in spawned)
		var/mob/living/summoned = ref.resolve()
		if(QDELETED(summoned) || summoned.stat == DEAD)
			continue
		still_up += ref
	spawned = length(still_up) ? still_up : null
	return length(still_up)

/datum/action/cooldown/spell/call_infernals/can_use(atom/target)
	if(!..())
		return FALSE
	return live_count() < max_alive

/datum/action/cooldown/spell/call_infernals/cast(atom/cast_on)
	. = ..()
	var/mob/living/summoner = owner
	if(!isliving(summoner))
		return FALSE
	var/room = max_alive - live_count()
	if(room <= 0)
		return FALSE
	var/list/turflist = list()
	for(var/turf/open/candidate in RANGE_TURFS(1, summoner))
		if(candidate.is_blocked_turf())
			continue
		turflist += candidate
	if(!length(turflist))
		return FALSE
	summoner.say("To me, my minions!")
	summoner.visible_message(span_boldwarning("[summoner] tears the veil open, and things come through!"))
	for(var/i in 1 to min(summon_count, room))
		var/mob_path = pick(spawn_types)
		var/mob/living/summoned = new mob_path(pick(turflist))
		summoned.faction = summoner.faction.Copy()
		LAZYADD(spawned, WEAKREF(summoned))
	return TRUE

/*
*/
/datum/action/cooldown/spell/projectile/fireball/mob_ability/watcher/great
	name = "Eye of Ruin"
	cooldown_time = 8 SECONDS
	// Fires point blank on purpose. It is a floating eye - closing on it should not switch it off,
	// and anything higher whiffs the moment the quarry steps in during the wind-up.
	npc_min_range = 1
	npc_max_range = 9
	use_chance = 70
	damage_mult = 1.4

/*
*/
/datum/action/cooldown/spell/projectile/spitfire_bolt
	name = "Spitfire"
	desc = "Spits a gobbet of flame."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 55
	shared_cooldown = "mob_special"
	lockout_time = 2 SECONDS
	cooldown_time = 6 SECONDS
	npc_min_range = 2
	npc_max_range = 7
	cast_range = 8
	required_zones = list(BODY_ZONE_HEAD)

	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	self_cast_possible = FALSE
	invocations = list()
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	associated_stat = null
	has_visual_effects = FALSE
	glow_intensity = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	charge_required = TRUE
	charge_time = TELEGRAPH_DODGEABLE
	charge_sound = null
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	freeze_cast = FALSE
	telegraph_sound = list('sound/magic/fireball.ogg')

	projectile_type = /obj/projectile/magic/firebolt
