#define ULTRA_PRECISE_ZONE 1 
#define PRECISE_ZONE 2 
#define NO_PENALTY_ZONE 3
#define PRECISE_FACE_ZONE 4
#define RANGED_MAX_ULTRA_PRECISE_HIT_CHANCE 50 // No matter what max 50% chance to hit
#define RANGED_MAX_FACE_HIT_CHANCE 30 // No matter what max 30% chance to hit
#define RANGED_ULTRA_PRECISE_HIT_PENALTY -25 // -25 for you - THEN we clamp.
#define RANGED_MAX_PRECISE_HIT_CHANCE 75 // No matter what max 75% chance to hit
#define RANGED_PRECISE_HIT_PENALTY -10 // -10 - THEN we clamp.

/proc/accuracy_check(zone, mob/living/user, mob/living/target, associated_skill, datum/intent/used_intent, obj/item/I)
	if(!zone)
		return
	if(user == target)
		return zone
	if(zone == BODY_ZONE_CHEST)
		return zone
	if(HAS_TRAIT(user, TRAIT_CIVILIZEDBARBARIAN) && (zone == BODY_ZONE_L_LEG || zone == BODY_ZONE_R_LEG))
		return zone
	if(target.pulledby || target.pulling)
		return zone
	if(!(target.mobility_flags & MOBILITY_STAND))
		return zone
	// If you're floored, you will aim feet and legs easily. There's a check for whether the victim is laying down already.
	if(!(user.mobility_flags & MOBILITY_STAND) && (zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)))
		return zone
	if( (target.dir == turn(get_dir(target,user), 180)))
		return zone

	var/chance2hit = 0

	if(check_zone(zone) == zone)	//Are we targeting a big limb or chest?
		chance2hit += 10

	if(check_face_subzone(zone) && used_intent.blade_class != BCLASS_PEEL && target.mind)	//Are we targeting the face of a player mob?
		chance2hit -= 24	// -3 PER, feel free to adjust if face attacks get too real.

	chance2hit += (user.get_skill_level(associated_skill) * 8)

	if(used_intent)
		if(used_intent.blade_class == BCLASS_STAB)
			chance2hit += 10
		if(used_intent.blade_class == BCLASS_PEEL)
			chance2hit += 25
		if(used_intent.blade_class == BCLASS_CUT)
			chance2hit += 6
		if((used_intent.blade_class == BCLASS_BLUNT || used_intent.blade_class == BCLASS_SMASH) && check_zone(zone) != zone)	//A mace can't hit the eyes very well
			chance2hit -= 10
		if(used_intent.accuracy_modifier)
			chance2hit += used_intent.accuracy_modifier

	if(I)
		if(I.wlength == WLENGTH_SHORT)
			chance2hit += 10

	if(user.STAPER > 10)
		chance2hit += (min((user.STAPER-10)*8, 40))

	if(user.STAPER < 10)
		chance2hit -= ((10-user.STAPER)*10)

	if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
		chance2hit += 20
	if(istype(user.rmb_intent, /datum/rmb_intent/swift))
		chance2hit -= 20
	
	if(HAS_TRAIT(user, TRAIT_CURSE_RAVOX))
		chance2hit -= 40

	chance2hit = CLAMP(chance2hit, 5, 93)

	if(prob(chance2hit))
		return zone
	else
		if(prob(chance2hit+(user.STAPER - 10)))
			if(check_zone(zone) == zone)
				return zone
			to_chat(user, span_warning("Accuracy fail! [chance2hit]%"))
			if(user.STAPER >= 11)
				if(user.client?.prefs.showrolls)
					return check_zone(zone)
			else
				return BODY_ZONE_CHEST
		else
			if(user.client?.prefs.showrolls)
				to_chat(user, span_warning("Double accuracy fail! [chance2hit]%"))
			return BODY_ZONE_CHEST

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

// Based on the remaining accuracy of the projectile and the aimed zone, return the zone, precise zone or chest
/mob/living/proc/bullet_hit_accuracy_check(final_accuracy, def_zone = BODY_ZONE_CHEST)
	// No matter what, 5% chance to hit the zone. No benefit from overaccuracy (unlikely)
	var/zone_type = ranged_zone_difficulty(def_zone)
	var/chance2hit = final_accuracy
	// If you aim very precisely, you take -25 on hit chance, and then no matter what, it is clamped at 50%
	// If you aim precisely (at limb), -10, 75% max.
	// Aiming very precise part has a chance of hitting the parent limb instead.

	// We only want these limits vs Players
	if(zone_type == PRECISE_FACE_ZONE && !mind)
		zone_type = ULTRA_PRECISE_ZONE

	switch(zone_type)
		if(ULTRA_PRECISE_ZONE)
			chance2hit -= RANGED_ULTRA_PRECISE_HIT_PENALTY
			chance2hit = CLAMP(chance2hit, 5, RANGED_MAX_ULTRA_PRECISE_HIT_CHANCE)
		if(PRECISE_ZONE)
			chance2hit -= RANGED_PRECISE_HIT_PENALTY
			chance2hit = CLAMP(chance2hit, 5, RANGED_MAX_PRECISE_HIT_CHANCE)
		if(PRECISE_FACE_ZONE)
			chance2hit -= (RANGED_ULTRA_PRECISE_HIT_PENALTY + RANGED_PRECISE_HIT_PENALTY)
			chance2hit = CLAMP(chance2hit, 5, RANGED_MAX_FACE_HIT_CHANCE)

	if(prob(chance2hit))
		return def_zone
	else if(prob(chance2hit))
		return check_zone(def_zone)
	else
		return BODY_ZONE_CHEST

#undef ULTRA_PRECISE_ZONE
#undef PRECISE_ZONE
#undef NO_PENALTY_ZONE
#undef PRECISE_FACE_ZONE
#undef RANGED_MAX_PRECISE_HIT_CHANCE
#undef RANGED_ULTRA_PRECISE_HIT_PENALTY
#undef RANGED_MAX_ULTRA_PRECISE_HIT_CHANCE
#undef RANGED_PRECISE_HIT_PENALTY
#undef RANGED_MAX_FACE_HIT_CHANCE
