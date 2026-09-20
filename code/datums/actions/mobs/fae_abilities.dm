/*
	Dryad is a mixup for the Fae roster, slow, steady, and relies on a big log chuck to pose any threat to anyone at range.
*/
/datum/action/cooldown/spell/projectile/log_throw
	name = "Hurl Log"
	desc = "Heaves a whole tree log overhead. Slow, but hits hard."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "boulder_throw"
	panel = null
	use_chance = 60
	shared_cooldown = "mob_special"
	lockout_time = 5 SECONDS
	cooldown_time = 16 SECONDS
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
	telegraph_sound = list('sound/misc/woodhit.ogg')

	recovery_time = 2 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM

	projectile_type = /obj/projectile/thrown_log

/datum/action/cooldown/spell/projectile/log_throw/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.def_zone = BODY_ZONE_CHEST

/obj/projectile/thrown_log
	name = "hurled log"
	desc = "That's a big piece of log!"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "log"
	damage = 100
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	armor_penetration = PEN_NONE
	nodamage = FALSE
	flag = "blunt"
	speed = 6
	range = 10
	arcshot = TRUE
	expose_caster_on_deflect = TRUE
	hitsound = 'sound/misc/woodhit.ogg'
	var/splinter_radius = 1
	var/splinter_damage = 40
	var/victim_slowdown = 6

/obj/projectile/thrown_log/on_hit(target, blocked = FALSE)
	. = ..()
	var/turf/epicenter = get_turf(target) || get_turf(src)
	if(!epicenter)
		return
	playsound(epicenter, 'sound/misc/woodhit.ogg', 100, TRUE, 6)
	var/mob/living/direct = isliving(target) ? target : null
	if(direct && blocked < 100)
		plant_victim(direct)
	for(var/mob/living/L in range(splinter_radius, epicenter))
		if(L == direct || L == firer || L.stat == DEAD)
			continue
		if(isliving(firer) && L.faction_check_mob(firer))
			continue
		L.apply_damage(splinter_damage, BRUTE, BODY_ZONE_CHEST, L.run_armor_check(BODY_ZONE_CHEST, "blunt", damage = splinter_damage))
		plant_victim(L)

/obj/projectile/thrown_log/proc/plant_victim(mob/living/L)
	if(!victim_slowdown)
		return
	L.Slowdown(victim_slowdown)
	L.apply_status_effect(/datum/status_effect/debuff/vulnerable, 6 SECONDS)
	to_chat(L, span_danger("<B>OUCH! THAT HURTS</B>"))

/datum/action/cooldown/spell/projectile/frost_lance
	name = "Frost Lance"
	desc = "Throws a volley of icy shards."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 60
	shared_cooldown = "mob_special"
	lockout_time = 4 SECONDS
	cooldown_time = 9 SECONDS
	npc_min_range = 2
	npc_max_range = 8
	cast_range = 9
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
	telegraph_sound = list('sound/spellbooks/icicle.ogg')

	recovery_time = 1.5 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM

	projectile_type = /obj/projectile/magic/frostbolt/greater
	projectiles_per_fire = 3
