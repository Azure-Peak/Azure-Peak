/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep
	name = "Great Sweep"
	button_icon_state = "great_sweep"
	desc = "Sweeps your weapon forward in a committed arc that leaves yourself wide open, inflicting heavy damage to anything and anyone in the way."
	cooldown_time = 14 SECONDS
	npc_max_range = 2
	use_chance = 55
	cast_effect_x_offset = 16
	cast_effect_y_offset = 16
	required_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	windup_time = TELEGRAPH_AREA_DENIAL
	freeze_cast = FALSE // steps with its quarry through the wind-up instead of planting
	telegraph_sound = list('sound/combat/rend_start.ogg')
	sweep_step = 7
	recovery_time = 2 SECONDS
	recovery_status = /datum/status_effect/debuff/vulnerable
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM

	damage = 60
	blade_class = BCLASS_CUT
	strike_armor_pen = PEN_HEAVY
	strike_sound = null
	detonate_sound = null
	hit_sound = list('sound/combat/sidesweep_hit.ogg')
	var/victim_slowdown = 2
	/// Damage multiplier per band. Bands past the end reuse the last entry.
	var/list/band_damage_mult = list(1, 1.5, 2)
	/// Unpenetrating follow-up on the last band, as a fraction of damage.
	var/final_band_bonus = 0.8
	/// How long a guard deflection leaves the caster fully exposed, on top of the normal recovery.
	var/deflect_exposed = 3 SECONDS
	var/list/band_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/get_pattern_offsets()
	. = list()
	for(var/list/band in get_sweep_bands())
		for(var/list/off in band)
			. |= list(off)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/get_strike_damage()
	. = ..()
	if(length(band_damage_mult))
		. *= band_damage_mult[clamp(band_index, 1, length(band_damage_mult))]

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/on_band_start(mob/living/H, band)
	if(length(band_sound))
		playsound(get_turf(H), band_sound, 100, TRUE)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/on_pattern_turf(turf/T, mob/living/H, facing)
	var/obj/effect/temp_visual/special_intent/fx = new (T, 0.5 SECONDS)
	fx.icon = 'icons/effects/effects.dmi'
	fx.icon_state = "sweep_fx"

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/on_hit_target(mob/living/H, mob/living/L, facing)
	L.visible_message(span_userdanger("[H]'s swing catches [L]!"))
	if(victim_slowdown)
		L.Slowdown(victim_slowdown)
	if(final_band_bonus && band_index >= length(band_damage_mult))
		arcyne_strike(H, L, null, damage * final_band_bonus, H.zone_selected || BODY_ZONE_CHEST, blade_class, spell_name = name, damage_type = strike_damage_type, skip_animation = TRUE, skip_message = TRUE)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/on_strike_complete(mob/living/H, hit_count, deflected)
	. = ..()
	if(!deflected)
		return
	H.visible_message(span_boldwarning("[H]'s swing is turned aside!"))
	if(deflect_exposed)
		H.apply_status_effect(/datum/status_effect/debuff/exposed, deflect_exposed)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/axe
	name = "Great Swipe"
	button_icon_state = "great_swipe"
	desc = "A wide axe arc that travels out and back across its whole front."
	band_sound = list('sound/combat/sp_axe_swing1.ogg','sound/combat/sp_axe_swing2.ogg','sound/combat/sp_axe_swing3.ogg')
	hit_sound = list('sound/combat/sp_gsword_hit.ogg')

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/axe/get_sweep_bands()
	var/list/inner = list(list(-1, 0), list(-1, 1), list(0, 1), list(1, 1), list(1, 0))
	var/list/outer = list(list(-2, 0), list(-2, 1), list(-1, 2), list(0, 2), list(1, 2), list(2, 1), list(2, 0))
	return list(inner, outer, inner)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/slam
	name = "Ground Slam"
	button_icon_state = "ground_slam"
	desc = "Smashes your feet forward into the ground, sending shockwave to damage everyone in the area."
	blade_class = BCLASS_BLUNT
	strike_armor_pen = PEN_NONE
	damage = 60
	damage_structures = TRUE
	structure_damage = 60
	telegraph_sound = list('sound/combat/ground_smash_start.ogg')
	band_sound = list('sound/combat/ground_smash1.ogg','sound/combat/ground_smash2.ogg','sound/combat/ground_smash3.ogg')
	hit_sound = list('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
	npc_max_range = 3
	self_targetable = TRUE
	lock_direction = FALSE
	track_target = TRUE
	freeze_cast = FALSE
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/minotaur_sweep/slam/get_sweep_bands()
	var/list/front = list(list(-1, 1), list(0, 1), list(1, 1))
	var/list/around = list(list(-1, 0), list(1, 0), list(-1, -1), list(0, -1), list(1, -1))
	return list(front, around, front)
