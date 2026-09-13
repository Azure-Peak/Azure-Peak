/datum/action/cooldown/spell/telegraphed_strike/mob_ability
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/mob_ability
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 100
	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	shared_cooldown = "mob_special"
	lockout_time = 5 SECONDS
	self_cast_possible = TRUE
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE
	blocked_by_antimagic = FALSE
	spare_allies = TRUE
	require_target_in_pattern = TRUE
	freeze_cast = TRUE
	track_target = TRUE
	damage_structures = FALSE

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/proc/brace_charge(mob/living/charger, mob/living/victim, impact_damage, recovery)
	if(!victim.has_status_effect(/datum/status_effect/buff/clash) && !victim.has_status_effect(/datum/status_effect/buff/parry_buffer))
		return FALSE
	victim.visible_message(span_boldwarning("<b>[victim]</b> braces, and [charger] halts!"), \
		span_userdanger("I brace against [charger], the impact drives through my armor!"))
	var/obj/item/held = victim.get_active_held_item()
	if(held?.parrysound)
		playsound(get_turf(victim), pick(held.parrysound), 100, TRUE)
	else
		playsound(get_turf(victim), pick(victim.parry_sound), 100, TRUE)
	playsound(get_turf(charger), 'sound/combat/ground_smash_start.ogg', 80, TRUE)
	victim.remove_status_effect(/datum/status_effect/buff/clash)
	victim.apply_status_effect(/datum/status_effect/buff/parry_buffer)
	victim.apply_damage(impact_damage, BRUTE, BODY_ZONE_CHEST, 0, TRUE)
	victim.stamina_add(victim.max_stamina / 3)
	var/turf/shoved = get_step(get_turf(victim), get_dir(charger, victim))
	if(shoved && !shoved.density)
		victim.safe_throw_at(shoved, 1, 1, charger, force = MOVE_FORCE_STRONG)
	charger.apply_status_effect(/datum/status_effect/debuff/clickcd, recovery)
	return TRUE

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/can_strike_victim(mob/living/H, mob/living/L)
	if(L.stat == DEAD)
		return FALSE
	if(spare_allies && H.faction_check_mob(L))
		return FALSE
	return TRUE

/// Blast anchored on a turf picked at cast time, rather than a pattern swept from the caster.
/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground
	lock_direction = FALSE
	sweep_step = 0
	require_target_in_pattern = FALSE // anchored on the quarry's turf, so it is always in the pattern
	var/blast_radius = 1
	var/turf/locked_turf

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/cast(atom/cast_on)
	locked_turf = get_turf(cast_on)
	if(!locked_turf)
		return FALSE
	return ..()

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/get_pattern_origin(mob/living/H)
	return locked_turf || ..()

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/get_pattern_offsets()
	. = list()
	for(var/x in -blast_radius to blast_radius)
		for(var/y in -blast_radius to blast_radius)
			. += list(list(x, y))

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/get_sweep_bands()
	return list(get_pattern_offsets())
