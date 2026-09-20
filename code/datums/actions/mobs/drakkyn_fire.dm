/*
*/
/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "dragons_breath"
	panel = null
	cooldown_time = 25 SECONDS
	npc_min_range = 0
	npc_max_range = 4
	use_chance = 45
	shared_cooldown = "mob_special"
	lockout_time = 5 SECONDS

	invocations = list()
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE
	glow_intensity = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	blocked_by_antimagic = FALSE
	spare_allies = TRUE
	require_target_in_pattern = TRUE
	freeze_cast = FALSE
	track_target = TRUE
	damage_structures = FALSE

	telegraph_type = /obj/effect/temp_visual/telegraph/primordial/fire
	telegraph_sound = list('sound/magic/fireball.ogg')

	damage = 55
	push_dist = 0
	detonate_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')
	hit_sound = list('sound/items/firelight.ogg')

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/drakkyn
	name = "Dragon's Breath"
	desc = "Exhale a cone of flame."
	required_zones = list(BODY_ZONE_HEAD)
	cast_effect_x_offset = 32
	cast_effect_y_offset = 32

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/drakkyn/greater
	cooldown_time = 20 SECONDS
	damage = 60
	cone_range = 5
	npc_max_range = 5
	scorch_stacks = 2


/datum/action/cooldown/spell/projectile/fireball/mob_ability
	abstract_type = /datum/action/cooldown/spell/projectile/fireball/mob_ability
	panel = null
	use_chance = 100
	shared_cooldown = "mob_special"
	lockout_time = 5 SECONDS
	cooldown_time = 20 SECONDS
	npc_min_range = 4
	npc_max_range = 9

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
	weapon_cast_penalized = FALSE

	charge_required = TRUE
	charge_time = TELEGRAPH_HIGH_IMPACT
	charge_sound = null
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_swingdelay_type = SWINGDELAY_NORMAL
	hold_drain = 0
	freeze_cast = FALSE

	telegraph_sound = list('sound/magic/fireball.ogg')

	var/damage_mult = 1

/datum/action/cooldown/spell/projectile/fireball/mob_ability/cast(atom/cast_on)
	if(!npc_controlled() || can_use(cast_on))
		return ..()
	return TRUE

/datum/action/cooldown/spell/projectile/fireball/mob_ability/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	if(damage_mult == 1)
		return
	to_fire.damage *= damage_mult
	var/obj/projectile/magic/aoe/fireball/rogue/bolt = to_fire
	if(istype(bolt))
		bolt.arcyne_aoe_damage *= damage_mult

/datum/action/cooldown/spell/projectile/fireball/mob_ability/drakkyn
	name = "Drakkyn Fireball"
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "drakkyn_fireball"
	use_chance = 15
	required_zones = list(BODY_ZONE_HEAD)
	cast_effect_x_offset = 32
	cast_effect_y_offset = 32

/datum/action/cooldown/spell/projectile/fireball/mob_ability/drakkyn/greater
	cooldown_time = 15 SECONDS
	damage_mult = 1.5

/datum/action/cooldown/spell/projectile/fireball/mob_ability/watcher
	name = "Eye of Fire"
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "eye_of_fire"
	cooldown_time = 8 SECONDS
	npc_min_range = 2
	npc_max_range = 9
	use_chance = 70
