/datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce
	name = "Pounce"
	desc = "Gathers momentum and leaps forward onto its target, knocking down anything in its trajectory."
	button_icon_state = "pounce"
	cooldown_time = 15 SECONDS
	npc_min_range = 2
	npc_max_range = 5
	windup_time = TELEGRAPH_SKILLSHOT
	telegraph_sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg')
	strike_sound = null
	freeze_cast = FALSE

	var/step_delay = 0.3
	var/pounce_damage = 32
	var/knockdown_duration = 3 SECONDS

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce/get_pattern_offsets()
	. = list()
	for(var/d in 1 to npc_max_range)
		. += list(list(0, d))

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce/strike(mob/living/H, facing, list/indicator, atom/cast_on)
	clear_indicators(indicator)
	if(QDELETED(cast_on) || H.buckled || H.incapacitated())
		return
	H.visible_message(span_danger("<b>[H]</b> leaps forward!"))
	INVOKE_ASYNC(src, PROC_REF(pounce_run), H, facing)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce/proc/pounce_run(mob/living/hound, facing)
	playsound(get_turf(hound), 'sound/combat/ground_smash_start.ogg', 70, TRUE)

	for(var/i in 1 to npc_max_range)
		if(QDELETED(hound) || hound.stat != CONSCIOUS || hound.incapacitated())
			return

		var/turf/next = get_step(get_turf(hound), facing)

		if(!next || next.density)
			slam_impact(hound, next || get_turf(hound))
			return

		var/blocked = FALSE
		for(var/obj/structure/S in next)
			if(S.density && !S.climbable)
				blocked = TRUE
				break
		if(blocked)
			slam_impact(hound, next)
			return

		// Check for target collision on the step
		for(var/mob/living/victim in next)
			if(victim == hound || victim.stat == DEAD)
				continue
			if(hound.faction_check_mob(victim))
				continue

			pounce_hit(hound, victim)
			step(hound, facing)
			return

		step(hound, facing)
		sleep(step_delay)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce/proc/pounce_hit(mob/living/hound, mob/living/victim)
	victim.visible_message(span_userdanger("[hound] pounces on [victim]!"))
	victim.Knockdown(knockdown_duration)
	victim.apply_status_effect(/datum/status_effect/debuff/vulnerable, 4 SECONDS)
	arcyne_strike(hound, victim, null, pounce_damage, BODY_ZONE_CHEST, BCLASS_BLUNT, spell_name = name, skip_animation = TRUE, exact_zone = TRUE)
	playsound(victim, 'sound/combat/hits/blunt/metalblunt (1).ogg', 75, TRUE)

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce/proc/slam_impact(mob/living/hound, turf/impact_turf)
	hound.visible_message(span_warning("[hound] leaps directly into the wall!"))
	playsound(impact_turf, 'sound/combat/hits/onwood/fence_hit3.ogg', 80, TRUE)
	hound.Stun(1.5 SECONDS)
