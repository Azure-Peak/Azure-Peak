/*
*/
/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "primordial_mark"
	cooldown_time = 20 SECONDS
	npc_min_range = 0
	npc_max_range = 4
	use_chance = 55

	recovery_time = 2 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM

/*
*/
/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/flame
	name = "Searing Blast"
	desc = "Breathes a searing blast of fire across the ground ahead."

	damage = 60
	cone_range = 4
	push_dist = 2
	scorch_stacks = 1
	vuln_on_hit = 3 SECONDS

/*
*/
/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/deluge
	name = "Deluge"
	desc = "Draws the moisture out of the land and spends it in a single surging torrent."
	telegraph_type = /obj/effect/temp_visual/telegraph/primordial/water
	telegraph_sound = list('sound/misc/undertow.ogg')

	damage = 25
	strike_damage_type = BRUTE
	blade_class = BCLASS_BLUNT
	strike_armor_pen = PEN_NONE
	cone_range = 3
	push_dist = 0
	scorch_stacks = 0
	ignite_pattern = FALSE
	strike_sound = 'sound/misc/undertow.ogg'
	detonate_sound = null
	hit_sound = null
	var/victim_slowdown = 4
	var/flood_duration = 15 SECONDS
	var/list/flooded

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/deluge/on_pattern_turf(turf/T, mob/living/H, facing)
	LAZYADD(flooded, T)

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/deluge/on_hit_target(mob/living/H, mob/living/L, facing)
	. = ..()
	if(victim_slowdown)
		L.Slowdown(victim_slowdown)

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/deluge/on_strike_complete(mob/living/H, hit_count, deflected)
	. = ..()
	if(length(flooded))
		new /obj/effect/deluge(flooded[1], flooded, flood_duration)
	flooded = null

/*
*/
/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/gale
	name = "Gale"
	desc = "Exhales a violent gust that hurls anything in front of it away."
	cooldown_time = 18 SECONDS
	windup_time = TELEGRAPH_HIGH_IMPACT
	telegraph_type = /obj/effect/temp_visual/telegraph/primordial/air
	telegraph_sound = list('sound/weather/rain/wind_6.ogg')

	damage = 20
	strike_damage_type = BRUTE
	blade_class = BCLASS_BLUNT
	strike_armor_pen = PEN_NONE
	cone_range = 3
	cone_half_width = 1
	sweep_by_ring = TRUE
	sweep_step = 2
	push_dist = 3
	scorch_stacks = 0
	ignite_pattern = FALSE
	strike_sound = 'sound/weather/rain/wind_6.ogg'
	detonate_sound = null
	hit_sound = null

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/gale/on_pattern_turf(turf/T, mob/living/H, facing)
	new /obj/effect/temp_visual/dir_setting/gust(T, facing)

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/gale/on_hit_target(mob/living/H, mob/living/L, facing)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/windswept)
