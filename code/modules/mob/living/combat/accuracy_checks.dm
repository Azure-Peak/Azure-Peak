#define ULTRA_PRECISE_ZONE 1
#define PRECISE_ZONE 2
#define NO_PENALTY_ZONE 3
#define PRECISE_FACE_ZONE 4
#define RANGED_MAX_ULTRA_PRECISE_HIT_CHANCE 50 // No matter what max 50% chance to hit
#define RANGED_MAX_FACE_HIT_CHANCE 30 // No matter what max 30% chance to hit
#define RANGED_ULTRA_PRECISE_HIT_PENALTY -25 // -25 for you - THEN we clamp.
#define RANGED_MAX_PRECISE_HIT_CHANCE 75 // No matter what max 75% chance to hit
#define RANGED_PRECISE_HIT_PENALTY -10 // -10 - THEN we clamp.

/// Shared zone resolution used by melee and weapon specials
/proc/resolve_aimed_zone(zone, mob/living/user, mob/living/target, accuracy_bonus = 0)
	if(!zone)
		return BODY_ZONE_CHEST
	if(user == target)
		return zone
	if(zone == BODY_ZONE_CHEST)
		return zone
	if(target.stat >= UNCONSCIOUS)
		return zone

	var/chance2hit = 0

	if(check_zone(zone) == zone)
		chance2hit += ACC_MAJOR_ZONE_BONUS

	if(check_face_subzone(zone) && target.mind)
		chance2hit -= ACC_FACE_SUBZONE_PENALTY

	if(user.STAPER > 10)
		chance2hit += (min((user.STAPER - 10) * ACC_PER_BONUS_PER_POINT, ACC_PER_BONUS_CAP))

	if(user.STAPER < 10)
		chance2hit -= ((10 - user.STAPER) * ACC_PER_PENALTY_PER_POINT)

	if(HAS_TRAIT(user, TRAIT_CURSE_RAVOX))
		chance2hit -= 40

	if(target.pulledby || target.pulling)
		chance2hit += target.pulledby?.grab_state > GRAB_PASSIVE ? ACC_AGGRESSIVE_GRAB_BONUS : ACC_GRABBED_BONUS

	if(!(target.mobility_flags & MOBILITY_STAND))
		chance2hit += ACC_PRONE_TARGET_BONUS

	if(target.has_status_effect(/datum/status_effect/debuff/exposed) || target.has_status_effect(/datum/status_effect/debuff/vulnerable))
		chance2hit += ACC_OPENED_TARGET_BONUS

	if(!(user.mobility_flags & MOBILITY_STAND) && (zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)))
		chance2hit += ACC_PRONE_ATTACKER_LEG_BONUS
	chance2hit += target.get_zone_melee_hit_bonus(zone)
	chance2hit += accuracy_bonus

	chance2hit = CLAMP(chance2hit, ACC_MIN, ACC_MAX)

	if(prob(chance2hit))
		return zone
	else
		if(prob(chance2hit + (user.STAPER - 10)))
			if(check_zone(zone) == zone)
				return zone
			if(user.client?.prefs.showrolls)
				to_chat(user, span_warning("Accuracy fail! [chance2hit]%"))
			if(user.STAPER >= 11)
				return check_zone(zone)
			else
				return BODY_ZONE_CHEST
		else
			if(user.client?.prefs.showrolls)
				to_chat(user, span_warning("Double accuracy fail! [chance2hit]%"))
			return BODY_ZONE_CHEST

/// Melee accuracy check. Computes weapon/intent-specific modifiers and delegates to resolve_aimed_zone().
/proc/melee_accuracy_check(zone, mob/living/user, mob/living/target, associated_skill, datum/intent/used_intent, obj/item/I)
	if(!zone)
		return
	var/bonus = 0

	bonus += (user.get_skill_level(associated_skill) * ACC_SKILL_BONUS_PER_LEVEL)

	if(used_intent)
		if(used_intent.blade_class == BCLASS_STAB)
			bonus += ACC_STAB_BONUS
		if(used_intent.blade_class == BCLASS_PICK)
			bonus += ACC_PICK_BONUS
		if(used_intent.blade_class == BCLASS_CUT)
			bonus += ACC_CUT_BONUS
		if((used_intent.blade_class == BCLASS_BLUNT || used_intent.blade_class == BCLASS_SMASH) && check_zone(zone) != zone)	//A mace can't hit the eyes very well
			bonus -= ACC_BLUNT_PRECISE_PENALTY
		if(used_intent.accuracy_modifier)
			bonus += used_intent.accuracy_modifier

	if(I)
		if(I.wlength == WLENGTH_SHORT)
			bonus += ACC_SHORT_WEAPON_BONUS
	else if(used_intent?.unarmed) // Unarmed is inherently short-range
		bonus += ACC_SHORT_WEAPON_BONUS

	if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
		bonus += ACC_AIMED_BONUS
	if(istype(user.rmb_intent, /datum/rmb_intent/swift))
		bonus -= ACC_SWIFT_PENALTY

	return resolve_aimed_zone(zone, user, target, bonus)

/mob/living/proc/checkmiss(mob/living/user)
	if(user == src)
		return FALSE
	if(stat)
		return FALSE
	if(!(mobility_flags & MOBILITY_STAND))
		return FALSE
	if(user.badluck(4))
		badluckmessage(user)
		return TRUE

/proc/badluckmessage(mob/living/user)
	var/static/list/usedp = list("Critical miss!", "Damn! Critical miss!", "No! Critical miss!", "It can't be! Critical miss!", "Xylix laughs at me! Critical miss!", "Bad luck! Critical miss!", "Curse creation! Critical miss!", "What?! Critical miss!")
	to_chat(user, span_boldwarning("[pick(usedp)]"))
	user.flash_fullscreen("blackflash2")
	user.aftermiss()

/proc/ranged_zone_difficulty(zone)
	switch(zone)
		//Hyper specific targetting is very difficult
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND,
			BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return ULTRA_PRECISE_ZONE

		// Head, arms, legs are all harder to hit then chest, but doable
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_NECK,
			BODY_ZONE_L_ARM, BODY_ZONE_R_ARM,
			BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			return PRECISE_ZONE

		// Face & Skull targeting is extra-extra difficult due to their debilitating crits. Players only!
		if(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE,
			BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS,
			BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return PRECISE_FACE_ZONE

	return NO_PENALTY_ZONE // Groin, Stomach and Chest are OK and Center of Mass.

/mob/living/proc/show_ranged_accuracy_fail(mob/living/user, aimed_zone, landed_zone, list/roll_out)
	if(aimed_zone == landed_zone || !isliving(user) || !user.client?.prefs.showrolls)
		return
	to_chat(user, span_warning("Accuracy fail! [roll_out?["chance"]]% - hit the [hit_zone_name(landed_zone)] instead."))

// Based on the remaining accuracy of the projectile and the aimed zone, return the zone, precise zone or chest
/mob/living/proc/bullet_hit_accuracy_check(final_accuracy, def_zone = BODY_ZONE_CHEST, list/roll_out)
	// No matter what, 5% chance to hit the zone. No benefit from overaccuracy (unlikely)
	var/zone_type = ranged_zone_difficulty(def_zone)
	var/chance2hit = final_accuracy + get_zone_ranged_hit_bonus(def_zone)
	// If you aim very precisely, you take -25 on hit chance, and then no matter what, it is clamped at 50%
	// If you aim precisely (at limb), -10, 75% max.
	// Aiming very precise part has a chance of hitting the parent limb instead.

	// We only want these limits vs Players
	if(zone_type == PRECISE_FACE_ZONE && !mind)
		zone_type = ULTRA_PRECISE_ZONE

	switch(zone_type)
		if(ULTRA_PRECISE_ZONE)
			chance2hit += RANGED_ULTRA_PRECISE_HIT_PENALTY
			chance2hit = CLAMP(chance2hit, 5, RANGED_MAX_ULTRA_PRECISE_HIT_CHANCE)
		if(PRECISE_ZONE)
			chance2hit += RANGED_PRECISE_HIT_PENALTY
			chance2hit = CLAMP(chance2hit, 5, RANGED_MAX_PRECISE_HIT_CHANCE)
		if(PRECISE_FACE_ZONE)
			chance2hit += (RANGED_ULTRA_PRECISE_HIT_PENALTY + RANGED_PRECISE_HIT_PENALTY)
			chance2hit = CLAMP(chance2hit, 5, RANGED_MAX_FACE_HIT_CHANCE)

	if(roll_out)
		roll_out["chance"] = chance2hit

	if(prob(chance2hit))
		return def_zone
	var/parent_zone = check_zone(def_zone)
	if(parent_zone != def_zone && prob(chance2hit))
		return parent_zone
	return BODY_ZONE_CHEST

/mob/living/proc/get_ranged_aim_window()
	var/shift = round((STAPER - ARCHER_NPC_AIM_BASELINE) / ARCHER_NPC_AIM_PER_STAT_POINT, 1)
	return max(ARCHER_NPC_AIM_WINDOW_MIN, ARCHER_NPC_AIM_WINDOW_BASE - shift)

/// aim_stat defaults to Perception, the archery case. Spells pass Intelligence.
/mob/living/proc/apply_ranged_accuracy(obj/projectile/P, aim_stat)
	if(!P)
		return
	if(isnull(aim_stat))
		aim_stat = STAPER
	P.accuracy += (aim_stat - 9) * 4
	P.bonus_accuracy += (aim_stat - 8) * 3

/// aim_stat defaults to Perception, the archery case. Spells pass Intelligence.
/mob/living/proc/get_ranged_lead_error(moved, aim_stat)
	// If you have not moved, they don't miss
	if(moved <= 0)
		return 0
	if(isnull(aim_stat))
		aim_stat = STAPER
	var/error = ARCHER_NPC_STATIONARY_MISS + (moved * ARCHER_NPC_MOVING_TARGET_ERROR)
	if(aim_stat > ARCHER_NPC_AIM_BASELINE)
		error -= min((aim_stat - ARCHER_NPC_AIM_BASELINE) * ARCHER_NPC_LEAD_ERROR_PER_POINT, ARCHER_NPC_LEAD_ERROR_MAX_BONUS)
	else if(aim_stat < ARCHER_NPC_AIM_BASELINE)
		error += (ARCHER_NPC_AIM_BASELINE - aim_stat) * ARCHER_NPC_LEAD_ERROR_PER_POOR
	return CLAMP(error, ARCHER_NPC_LEAD_ERROR_FLOOR, ARCHER_NPC_LEAD_ERROR_CEILING)

/mob/living/proc/scatter_aim_turf(turf/aim, atom/reference, tiles)
	if(!isturf(aim) || tiles <= 0)
		return aim
	var/perp = turn(get_dir(src, reference), pick(90, -90))
	return get_ranged_target_turf(aim, perp, tiles) || aim

/mob/living/proc/get_ranged_lead_turf(atom/movable/target, turf/locked_turf, projectile_speed = ARCHER_NPC_DEFAULT_PROJECTILE_SPEED, aim_stat)
	var/turf/current = get_turf(target)
	if(!isturf(current) || !isturf(locked_turf))
		return current
	var/turf/aim = current
	var/lead = 0
	// get_dist hands back -1 when it cannot measure, and -1 is truthy - unclamped it slips past every
	// "did they move" guard and leads a full cap's worth at a target standing still.
	var/moved = max(0, get_dist(locked_turf, current))
	if(moved > 0 && target.last_move && isliving(target))
		var/mob/living/living_target = target
		var/target_delay = living_target.cached_multiplicative_slowdown
		if(target_delay > 0)
			lead = CLAMP(round((get_dist(src, current) * projectile_speed) / target_delay, 1), 0, ARCHER_NPC_MAX_LEAD)
			if(lead)
				aim = get_ranged_target_turf(current, target.last_move, lead) || current
	var/error_chance = get_ranged_lead_error(moved, aim_stat)
	if(!prob(error_chance))
		return aim
	var/offset = ARCHER_NPC_MISS_OFFSET_TILES + (prob(error_chance) ? 1 : 0)
	return scatter_aim_turf(aim, current, offset)

#undef ULTRA_PRECISE_ZONE
#undef PRECISE_ZONE
#undef NO_PENALTY_ZONE
#undef PRECISE_FACE_ZONE
#undef RANGED_MAX_PRECISE_HIT_CHANCE
#undef RANGED_ULTRA_PRECISE_HIT_PENALTY
#undef RANGED_MAX_ULTRA_PRECISE_HIT_CHANCE
#undef RANGED_PRECISE_HIT_PENALTY
#undef RANGED_MAX_FACE_HIT_CHANCE
