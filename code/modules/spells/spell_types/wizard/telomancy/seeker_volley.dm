/obj/projectile/magic/seeker_orb
	name = "seeker orb"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "seeker_orb"
	damage = SPELL_DMG(5)
	damage_type = BRUTE
	nodamage = FALSE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = 16
	speed = MAGE_PROJ_SLOW
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	intdamfactor = SPELL_INTDAM(1)
	spell_damage_scaled = TRUE
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	homing_turn_speed = 35
	homing_inaccuracy_max = 12
	var/list/impact_sounds = list('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')

/obj/projectile/magic/seeker_orb/prehit(atom/target)
	if(isliving(target) && target != original)
		return FALSE
	return ..()

/obj/projectile/magic/seeker_orb/process_homing()
	if(QDELETED(homing_target))
		homing = FALSE
		return FALSE
	var/desired_angle = Get_Angle(src, homing_target)
	var/diff = closer_angle_difference(Angle, desired_angle)
	if(!isnum(diff))
		return FALSE
	setAngle(Angle + CLAMP(diff, -homing_turn_speed, homing_turn_speed))
	return TRUE

/obj/projectile/magic/seeker_orb/on_hit(target, blocked = FALSE)
	if(length(impact_sounds))
		hitsound = pick(impact_sounds)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] dissipates harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(out_of_effective_range())
			return
		if(blocked < 100)
			M.apply_status_effect(/datum/status_effect/debuff/seeker_marked)
	. = ..()

/datum/status_effect/debuff/seeker_marked
	id = "seeker_marked"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/seeker_marked
	duration = 8 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/seeker_marked
	name = "Marked"
	desc = "An arcyne weight clings to my limbs. The Telomancer's mark is upon me."
	icon_state = "debuff"

/datum/status_effect/debuff/seeker_marked/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.balloon_alert_to_viewers("<font color='#b388ff'>marked!</font>")
